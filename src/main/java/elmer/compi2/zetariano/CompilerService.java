package elmer.compi2.zetariano;

import elmer.compi2.zetariano.antlr.piglatin.PigLatinLexer;
import elmer.compi2.zetariano.antlr.piglatin.PigLatinParser;
import elmer.compi2.zetariano.antlr.ypython.YLexer;
import elmer.compi2.zetariano.antlr.ypython.YParser;
import elmer.compi2.zetariano.codegen.C3DEmitter;
import elmer.compi2.zetariano.codegen.Cuadruplo;
import elmer.compi2.zetariano.codegen.piglatin.PigC3DEmitter;
import elmer.compi2.zetariano.codegen.zeta.ZC3DEmitter;
import elmer.compi2.zetariano.codigo.unificado.GeneradorCUnificado;
import elmer.compi2.zetariano.core.node.NodoAST;
import elmer.compi2.zetariano.core.node.piglatin.ImportASTPig;
import elmer.compi2.zetariano.core.node.piglatin.ProgramaASTPig;
import elmer.compi2.zetariano.core.node.zeta.ProgramaASTZ;
import elmer.compi2.zetariano.diagnostic.AntlrErrorBridge;
import elmer.compi2.zetariano.diagnostic.ErrorCollector;
import elmer.compi2.zetariano.diagnostic.ErrorKind;
import elmer.compi2.zetariano.diagnostic.ErrorReport;
import elmer.compi2.zetariano.enlace.EnlazadorC3D;
import elmer.compi2.zetariano.imports.*;
import elmer.compi2.zetariano.parser.piglatin.PigTreeBuilder;
import elmer.compi2.zetariano.parser.ypython.YTreeBuilder;
import elmer.compi2.zetariano.analysis.semantic.PigAnalyzer;
import elmer.compi2.zetariano.runtime.piglatin.ConstructorMemoriaPig;
import elmer.compi2.zetariano.runtime.piglatin.MarcoPrincipalPig;
import elmer.compi2.zetariano.runtime.zeta.TablaMemoriaZ;
import lombok.Builder;
import lombok.Data;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * Servicio orquestador del compilador multi-lenguaje (Pig Latin, Y?, Zetariano).
 */
public class CompilerService {

    @Data
    @Builder
    public static class CompilationResult {
        private boolean success;
        private String consoleLog;
        private List<Cuadruplo> c3dInstructions;
        private String c3dText;
        private String generatedCCode;
        private List<ErrorReport> errors;
    }

    public CompilationResult compilePigSource(String source, Path baseDir) {
        ErrorCollector.clear();
        StringBuilder log = new StringBuilder();
        log.append("========================================\n");
        log.append("INICIANDO COMPILACION MULTI-LENGUAJE\n");
        log.append("========================================\n\n");

        Path base = (baseDir != null) ? baseDir.toAbsolutePath().normalize() : Path.of(".").toAbsolutePath().normalize();

        try {
            // 1. Lexer y Parser Pig Latin
            PigLatinLexer lexerPig = new PigLatinLexer(CharStreams.fromString(source));
            lexerPig.removeErrorListeners();
            lexerPig.addErrorListener(new AntlrErrorBridge(ErrorKind.LEXICO));

            CommonTokenStream tokensPig = new CommonTokenStream(lexerPig);
            PigLatinParser parserPig = new PigLatinParser(tokensPig);
            parserPig.removeErrorListeners();
            parserPig.addErrorListener(new AntlrErrorBridge(ErrorKind.SINTACTICO));

            PigLatinParser.ProgramaContext treePig = parserPig.programa();
            if (ErrorCollector.hasErrors()) {
                return abortWithErrors(log, "Errores lexicos/sintacticos en Pig Latin.");
            }

            ProgramaASTPig astPig = (ProgramaASTPig) new PigTreeBuilder().visit(treePig);
            if (astPig == null) {
                ErrorCollector.addError(ErrorKind.SINTACTICO, "No se pudo construir el AST de Pig Latin.", 1, 0);
                return abortWithErrors(log, "Fallo al construir AST Pig Latin.");
            }

            // 2. Procesar Imports cruzados (Y? y Zetariano)
            RegistroImportsPig registroImports = new RegistroImportsPig();
            CargadorImportYPig cargadorY = new CargadorImportYPig();
            CargadorImportZPig cargadorZ = new CargadorImportZPig();
            AdaptadorImportYPig adaptadorY = new AdaptadorImportYPig();
            AdaptadorImportZPig adaptadorZ = new AdaptadorImportZPig();

            List<Cuadruplo> c3dY = new ArrayList<>();
            List<ProgramaASTZ> programasZ = new ArrayList<>();

            for (ImportASTPig imp : astPig.getImports()) {
                String rutaRelativa = imp.getRuta().replace('.', File.separatorChar) + imp.getExtension();
                Path archivoImport = base.resolve(rutaRelativa).normalize();

                if (!Files.isRegularFile(archivoImport)) {
                    ErrorCollector.addError(ErrorKind.SEMANTICO,
                            "No se encontro el archivo importado: " + rutaRelativa, imp.getLinea(), 0);
                    continue;
                }

                if (imp.esY()) {
                    var semY = cargadorY.cargarSemantico(archivoImport.toString());
                    adaptadorY.importar(semY, registroImports);

                    // Generar C3D de Y
                    String codY = Files.readString(archivoImport, StandardCharsets.UTF_8);
                    YLexer lY = new YLexer(CharStreams.fromString(codY));
                    YParser pY = new YParser(new CommonTokenStream(lY));
                    NodoAST astY = new YTreeBuilder().visit(pY.programa());
                    c3dY.addAll(new C3DEmitter().generar(astY));
                    log.append("Import Y cargado: ").append(rutaRelativa).append("\n");
                } else if (imp.esZ()) {
                    TablaMemoriaZ tablaMemZ = cargadorZ.cargarTabla(archivoImport.toString());
                    adaptadorZ.importar(tablaMemZ, registroImports);
                    ProgramaASTZ progZ = cargadorZ.getUltimoProgramaAST();
                    if (progZ != null) {
                        programasZ.add(progZ);
                    }
                    log.append("Import Z cargado: ").append(rutaRelativa).append("\n");
                }
            }

            if (ErrorCollector.hasErrors()) {
                return abortWithErrors(log, "Errores al resolver dependencias importadas.");
            }

            // 3. C3D de Zetariano
            List<Cuadruplo> c3dZ = new ArrayList<>();
            if (!programasZ.isEmpty()) {
                c3dZ = new ZC3DEmitter().generar(programasZ);
            }
            log.append("C3D Y: ").append(c3dY.size()).append(" instrucciones.\n");
            log.append("C3D Z: ").append(c3dZ.size()).append(" instrucciones.\n");

            // 4. Analisis Semantico Pig Latin
            PigAnalyzer semanticoPig = new PigAnalyzer(base);
            semanticoPig.visit(treePig);
            if (semanticoPig.hayErrores()) {
                for (String err : semanticoPig.getErrores()) {
                    ErrorCollector.addError(ErrorKind.SEMANTICO, err, 0, 0);
                }
                return abortWithErrors(log, "Errores semanticos en Pig Latin.");
            }

            // 5. C3D de Pig Latin
            ConstructorMemoriaPig constructorMem = new ConstructorMemoriaPig();
            MarcoPrincipalPig marcoPig = constructorMem.construir(astPig);
            PigC3DEmitter emitterPig = new PigC3DEmitter(astPig, marcoPig, registroImports);
            List<Cuadruplo> c3dPig = emitterPig.generar();
            log.append("C3D Pig Latin: ").append(c3dPig.size()).append(" instrucciones.\n");

            // 6. Enlazador C3D
            EnlazadorC3D enlazador = new EnlazadorC3D();
            enlazador.agregarModuloY(c3dY);
            enlazador.agregarModuloZ(c3dZ);
            enlazador.establecerModuloPig(c3dPig);
            List<Cuadruplo> enlazado = enlazador.enlazar();

            if (enlazador.tieneErrores()) {
                for (String err : enlazador.getErrores()) {
                    ErrorCollector.addError(ErrorKind.ENLACE, "Error de enlace C3D: " + err, 0, 0);
                }
                return abortWithErrors(log, "Errores durante el enlace C3D.");
            }
            log.append("Total C3D Enlazado: ").append(enlazado.size()).append(" instrucciones.\n");

            // 7. Generacion de Codigo C Unificado
            GeneradorCUnificado generadorC = new GeneradorCUnificado(enlazado);
            String codigoC = generadorC.generar();

            // Guardar salida C en directorio base
            Path salidaC = base.resolve("salida_unificada.c");
            Files.writeString(salidaC, codigoC, StandardCharsets.UTF_8);
            log.append("Codigo C generado exitosamente en: ").append(salidaC.toAbsolutePath()).append("\n");
            log.append("\n========================================\n");
            log.append("COMPILACION EXITOSA CON C3D Y C FINAL\n");
            log.append("========================================\n");

            // Construir texto legible de C3D
            StringBuilder c3dText = new StringBuilder();
            for (Cuadruplo q : enlazado) {
                c3dText.append(q.toString()).append("\n");
            }

            return CompilationResult.builder()
                    .success(true)
                    .consoleLog(log.toString())
                    .c3dInstructions(enlazado)
                    .c3dText(c3dText.toString())
                    .generatedCCode(codigoC)
                    .errors(ErrorCollector.getErrors())
                    .build();

        } catch (Exception e) {
            ErrorCollector.addError(ErrorKind.SEMANTICO, "Excepcion no controlada: " + e.getMessage(), 0, 0);
            log.append("\nERROR FATAL: ").append(e.getMessage()).append("\n");
            return CompilationResult.builder()
                    .success(false)
                    .consoleLog(log.toString())
                    .c3dInstructions(List.of())
                    .c3dText("")
                    .generatedCCode("")
                    .errors(ErrorCollector.getErrors())
                    .build();
        }
    }

    private CompilationResult abortWithErrors(StringBuilder log, String razon) {
        log.append("\n[FALLO DE COMPILACION]: ").append(razon).append("\n");
        for (ErrorReport err : ErrorCollector.getErrors()) {
            log.append(" - [").append(err.getKind()).append("] Linea ").append(err.getLine())
               .append(": ").append(err.getMessage()).append("\n");
        }
        return CompilationResult.builder()
                .success(false)
                .consoleLog(log.toString())
                .c3dInstructions(List.of())
                .c3dText("")
                .generatedCCode("")
                .errors(ErrorCollector.getErrors())
                .build();
    }
}
