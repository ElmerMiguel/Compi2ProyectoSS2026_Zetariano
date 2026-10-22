/*
 */
package elmer.compi2.zetariano.imports;

import elmer.compi2.zetariano.parser.zeta.ZTreeBuilder;
import elmer.compi2.zetariano.core.node.zeta.ProgramaASTZ;
import elmer.compi2.zetariano.runtime.zeta.ClaseMemoriaZ;
import elmer.compi2.zetariano.runtime.zeta.ConstructorMarcosZ;
import elmer.compi2.zetariano.runtime.zeta.MarcoMetodoZ;
import elmer.compi2.zetariano.runtime.zeta.TablaMemoriaZ;
import elmer.compi2.zetariano.analysis.semantic.SemanticoZ;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.antlr.v4.runtime.BailErrorStrategy;
import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.misc.ParseCancellationException;
import elmer.compi2.zetariano.antlr.zeta.ZLexer;
import elmer.compi2.zetariano.antlr.zeta.ZParser;

/**
 *
 */
public class CargadorImportZPig {

    /*
     * Una misma instancia conserva las clases Z cargadas anteriormente.
     * De esta forma Pila.z puede utilizar la clase declarada en Nodo.z.
     */
    private final SemanticoZ semanticoCompartido
            = new SemanticoZ();

    private final Map<String, ProgramaASTZ> programasCargados
            = new LinkedHashMap<>();

    private ProgramaASTZ ultimoProgramaAST;

    public ProgramaASTZ getUltimoProgramaAST() {
        return ultimoProgramaAST;
    }

    public List<ProgramaASTZ> getTodosLosProgramasAST() {
        return new ArrayList<>(programasCargados.values());
    }

    public TablaMemoriaZ cargarTabla(String rutaArchivo)
            throws IOException {

        // ==========================================
        // 1. LEER ARCHIVO .z
        // ==========================================
        String codigo = Files.readString(
                Path.of(rutaArchivo)
        );

        // ==========================================
        // 2. LEXER
        // ==========================================
        CharStream input
                = CharStreams.fromString(codigo);

        ZLexer lexer
                = new ZLexer(input);

        List<String> erroresLexicos
                = new ArrayList<>();

        lexer.removeErrorListeners();

        lexer.addErrorListener(
                new BaseErrorListener() {

            @Override
            public void syntaxError(
                    Recognizer<?, ?> recognizer,
                    Object simbolo,
                    int linea,
                    int columna,
                    String mensaje,
                    RecognitionException excepcion) {

                erroresLexicos.add(
                        "Linea "
                        + linea
                        + ", columna "
                        + columna
                        + " -> "
                        + mensaje
                );
            }
        }
        );

        CommonTokenStream tokens
                = new CommonTokenStream(lexer);

        tokens.fill();

        if (!erroresLexicos.isEmpty()) {

            StringBuilder detalle
                    = new StringBuilder();

            for (String error
                    : erroresLexicos) {

                detalle.append(
                        System.lineSeparator()
                );

                detalle.append(
                        error
                );
            }

            throw new IllegalStateException(
                    "El archivo Z importado '"
                    + rutaArchivo
                    + "' contiene errores lexicos:"
                    + detalle
            );
        }

        tokens.seek(0);

        // ==========================================
        // 3. PARSER
        // ==========================================
        ZParser parser
                = new ZParser(tokens);

        parser.setErrorHandler(
                new BailErrorStrategy()
        );

        ZParser.ProgramaContext arbol;

        try {

            arbol = parser.programa();

        } catch (ParseCancellationException ex) {

            Token token = parser.getCurrentToken();

            int linea = token != null
                    ? token.getLine()
                    : -1;

            int columna = token != null
                    ? token.getCharPositionInLine()
                    : -1;

            String texto = token != null
                    ? token.getText()
                    : "<desconocido>";

            throw new IllegalStateException(
                    "Error sintactico en el archivo Z. "
                    + "Linea " + linea
                    + ", columna " + columna
                    + ", cerca de '" + texto + "'.",
                    ex
            );
        }

        if (parser.getNumberOfSyntaxErrors() > 0) {

            throw new IllegalStateException(
                    "El archivo Z contiene "
                    + parser.getNumberOfSyntaxErrors()
                    + " error(es) sintactico(s)."
            );
        }

        // ==========================================
        // VALIDAR NOMBRE DEL ARCHIVO Y DE LA CLASE
        // ==========================================
        String nombreArchivo
                = Path.of(rutaArchivo)
                        .getFileName()
                        .toString();

        int posicionExtension
                = nombreArchivo.lastIndexOf('.');

        if (posicionExtension > 0) {

            nombreArchivo
                    = nombreArchivo.substring(
                            0,
                            posicionExtension
                    );
        }

        String nombreClase
                = arbol.definicionClase()
                        .IDENTIFICADOR()
                        .getText();

        if (!nombreArchivo.equals(nombreClase)) {

            throw new IllegalStateException(
                    "El archivo Z se llama '"
                    + nombreArchivo
                    + ".z', pero declara la clase publica '"
                    + nombreClase
                    + "'. El nombre del archivo debe coincidir "
                    + "exactamente con el nombre de la clase."
            );
        }

        // ==========================================
        // 4. ANALISIS SEMANTICO Z
        // ==========================================
        semanticoCompartido.analizarAcumulando(
                arbol
        );

        if (semanticoCompartido.tieneErrores()) {

            StringBuilder detalle
                    = new StringBuilder();

            for (String error
                    : semanticoCompartido.getErrores()) {

                detalle.append(
                        System.lineSeparator()
                );

                detalle.append(
                        error
                );
            }

            throw new IllegalStateException(
                    "El archivo Z importado '"
                    + rutaArchivo
                    + "' contiene errores semanticos:"
                    + detalle
            );
        }

        // ==========================================
        // 4. AST Z
        // ==========================================
        ZTreeBuilder builder
                = new ZTreeBuilder();

        ProgramaASTZ programaAST
                = (ProgramaASTZ) builder.visitPrograma(
                        arbol
                );

        if (programaAST == null) {

            throw new IllegalStateException(
                    "No fue posible construir el AST Z."
            );
        }

        ultimoProgramaAST = programaAST;

        programasCargados.put(
                programaAST.getClase().getNombre(),
                programaAST
        );

        if (programaAST.getClase().tienePadre()) {
            String padre = programaAST.getClase().getNombrePadre();
            if (!programasCargados.containsKey(padre)) {
                Path archivoPadre = Path.of(rutaArchivo).toAbsolutePath().getParent().resolve(padre + ".z");
                if (Files.isRegularFile(archivoPadre)) {
                    cargarTabla(archivoPadre.toString());
                }
            }
        }

        // ==========================================
        // 5. TABLA DE MEMORIA Z
        // ==========================================
        ConstructorMarcosZ constructorMarcos
                = new ConstructorMarcosZ();

        TablaMemoriaZ tablaCompleta
                = constructorMarcos.construir(
                        new ArrayList<>(programasCargados.values())
                );

        if (tablaCompleta == null) {

            throw new IllegalStateException(
                    "No fue posible construir "
                    + "la tabla de memoria Z."
            );
        }

        TablaMemoriaZ resultado = new TablaMemoriaZ();
        ClaseMemoriaZ claseActual = tablaCompleta.buscarClase(programaAST.getClase().getNombre());
        if (claseActual != null) {
            resultado.registrarClase(claseActual);
        }
        for (MarcoMetodoZ marco : tablaCompleta.getMarcos().values()) {
            resultado.registrar(marco);
        }

        return resultado;
    }
}
