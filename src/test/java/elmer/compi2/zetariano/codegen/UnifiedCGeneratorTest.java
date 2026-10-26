package elmer.compi2.zetariano.codegen;

import elmer.compi2.zetariano.TestPathResolver;
import elmer.compi2.zetariano.antlr.piglatin.PigLatinLexer;
import elmer.compi2.zetariano.antlr.piglatin.PigLatinParser;
import elmer.compi2.zetariano.antlr.ypython.YLexer;
import elmer.compi2.zetariano.antlr.ypython.YParser;
import elmer.compi2.zetariano.codigo.unificado.GeneradorCUnificado;
import elmer.compi2.zetariano.codegen.piglatin.PigC3DEmitter;
import elmer.compi2.zetariano.codegen.zeta.ZC3DEmitter;
import elmer.compi2.zetariano.core.node.NodoAST;
import elmer.compi2.zetariano.core.node.piglatin.ProgramaASTPig;
import elmer.compi2.zetariano.enlace.EnlazadorC3D;
import elmer.compi2.zetariano.imports.*;
import elmer.compi2.zetariano.parser.piglatin.PigTreeBuilder;
import elmer.compi2.zetariano.parser.ypython.YTreeBuilder;
import elmer.compi2.zetariano.runtime.piglatin.ConstructorMemoriaPig;
import elmer.compi2.zetariano.runtime.piglatin.MarcoPrincipalPig;
import elmer.compi2.zetariano.runtime.zeta.TablaMemoriaZ;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class UnifiedCGeneratorTest {

    @Test
    public void testCompilacionCompletaYGeneracionC() throws Exception {
        Path pathPruebaZ = TestPathResolver.resolve("docs/Pruebas/Prueba.z");
        assertTrue(Files.exists(pathPruebaZ), "Prueba.z debe existir");
        Path baseDir = pathPruebaZ.getParent();

        // 1. Z
        CargadorImportZPig cargadorZ = new CargadorImportZPig();
        TablaMemoriaZ tablaZ = cargadorZ.cargarTabla(pathPruebaZ.toString());
        assertNotNull(tablaZ);
        ZC3DEmitter emitterZ = new ZC3DEmitter();
        List<Cuadruplo> c3dZ = emitterZ.generar(cargadorZ.getUltimoProgramaAST());
        assertNotNull(c3dZ);
        assertFalse(c3dZ.isEmpty());

        // 2. Y
        CargadorImportYPig cargadorY = new CargadorImportYPig();
        Path pathUtilY = TestPathResolver.resolve("docs/Pruebas/Utilidades.y");
        assertTrue(Files.exists(pathUtilY), "Utilidades.y debe existir");
        String codigoY = Files.readString(pathUtilY);
        YLexer lexerY = new YLexer(CharStreams.fromString(codigoY));
        YParser parserY = new YParser(new CommonTokenStream(lexerY));
        NodoAST astY = new YTreeBuilder().visit(parserY.programa());
        C3DEmitter emitterY = new C3DEmitter();
        List<Cuadruplo> c3dY = emitterY.generar(astY);
        assertNotNull(c3dY);
        assertFalse(c3dY.isEmpty());

        // 3. Pig Latin
        Path pathPrincipalPig = TestPathResolver.resolve("docs/Pruebas/Principal.pig");
        assertTrue(Files.exists(pathPrincipalPig), "Principal.pig debe existir");
        String codigoPig = Files.readString(pathPrincipalPig);
        PigLatinLexer lexerPig = new PigLatinLexer(CharStreams.fromString(codigoPig));
        PigLatinParser parserPig = new PigLatinParser(new CommonTokenStream(lexerPig));
        ProgramaASTPig astPig = (ProgramaASTPig) new PigTreeBuilder().visit(parserPig.programa());

        RegistroImportsPig registro = new RegistroImportsPig();
        new AdaptadorImportYPig().importar(cargadorY.cargarSemantico(pathUtilY.toString()), registro);
        new AdaptadorImportZPig().importar(tablaZ, registro);

        MarcoPrincipalPig marcoPig = new ConstructorMemoriaPig().construir(astPig);
        PigC3DEmitter emitterPig = new PigC3DEmitter(astPig, marcoPig, registro);
        List<Cuadruplo> c3dPig = emitterPig.generar();
        assertNotNull(c3dPig);
        assertFalse(c3dPig.isEmpty());

        // 4. Enlace
        EnlazadorC3D enlazador = new EnlazadorC3D();
        enlazador.agregarModuloY(c3dY);
        enlazador.agregarModuloZ(c3dZ);
        enlazador.establecerModuloPig(c3dPig);
        List<Cuadruplo> enlazado = enlazador.enlazar();
        assertFalse(enlazador.tieneErrores(), "No deben haber errores de enlace: " + enlazador.getErrores());
        assertTrue(enlazado.size() > 50);

        // 5. Generacion de codigo C unificado
        GeneradorCUnificado generadorC = new GeneradorCUnificado(enlazado);
        String codigoC = generadorC.generar();

        assertNotNull(codigoC, "El codigo C no debe ser nulo");
        assertTrue(codigoC.contains("#include <stdio.h>"), "Debe incluir stdio.h");
        assertTrue(codigoC.contains("double Stack["), "Debe definir el stack");
        assertTrue(codigoC.contains("double Heap["), "Debe definir el heap");
        assertTrue(codigoC.contains("int main()"), "Debe generar la funcion main");
    }
}
