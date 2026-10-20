package elmer.compi2.zetariano.codegen;

import elmer.compi2.zetariano.antlr.piglatin.PigLatinLexer;
import elmer.compi2.zetariano.antlr.piglatin.PigLatinParser;
import elmer.compi2.zetariano.antlr.ypython.YLexer;
import elmer.compi2.zetariano.antlr.ypython.YParser;
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

public class C3DEmitterTest {

    @Test
    public void testGeneracionC3D_Y() throws Exception {
        File archivoY = new File("docs/Pruebas/Utilidades.y");
        assertTrue(archivoY.exists());

        String codigo = Files.readString(archivoY.toPath());
        YLexer lexer = new YLexer(CharStreams.fromString(codigo));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        YParser parser = new YParser(tokens);
        YParser.ProgramaContext tree = parser.programa();
        assertEquals(0, parser.getNumberOfSyntaxErrors());

        NodoAST ast = new YTreeBuilder().visit(tree);
        assertNotNull(ast, "El AST de Y no debe ser nulo");

        GeneradorC3D generadorY = new GeneradorC3D();
        List<Cuadruplo> c3d = generadorY.generar(ast);

        assertNotNull(c3d, "La lista de C3D de Y no debe ser nula");
        assertFalse(c3d.isEmpty(), "Debe haber instrucciones C3D para Utilidades.y");
        assertTrue(c3d.size() > 10, "Debe generar multiples cuadruplos para funciones de Y");
    }

    @Test
    public void testGeneracionC3D_PigLatinConImports() throws Exception {
        File archivoPig = new File("docs/Pruebas/Principal.pig");
        assertTrue(archivoPig.exists());

        Path baseDir = Path.of("docs/Pruebas");
        String codigoPig = Files.readString(archivoPig.toPath());

        PigLatinLexer lexerPig = new PigLatinLexer(CharStreams.fromString(codigoPig));
        CommonTokenStream tokensPig = new CommonTokenStream(lexerPig);
        PigLatinParser parserPig = new PigLatinParser(tokensPig);
        PigLatinParser.ProgramaContext treePig = parserPig.programa();
        assertEquals(0, parserPig.getNumberOfSyntaxErrors());

        ProgramaASTPig astPig = (ProgramaASTPig) new PigTreeBuilder().visit(treePig);
        assertNotNull(astPig, "El AST de Pig Latin no debe ser nulo");

        // Cargar imports
        RegistroImportsPig registro = new RegistroImportsPig();
        CargadorImportYPig cargadorY = new CargadorImportYPig();
        AdaptadorImportYPig adaptadorY = new AdaptadorImportYPig();
        adaptadorY.importar(cargadorY.cargarSemantico(baseDir.resolve("Utilidades.y").toString()), registro);

        CargadorImportZPig cargadorZ = new CargadorImportZPig();
        AdaptadorImportZPig adaptadorZ = new AdaptadorImportZPig();
        TablaMemoriaZ tablaZ = cargadorZ.cargarTabla(baseDir.resolve("Prueba.z").toString());
        adaptadorZ.importar(tablaZ, registro);

        // Generar memoria Pig y C3D Pig
        ConstructorMemoriaPig constructorMem = new ConstructorMemoriaPig();
        MarcoPrincipalPig marcoPig = constructorMem.construir(astPig);
        assertNotNull(marcoPig, "El marco principal de Pig no debe ser nulo");

        GeneradorC3DPig generadorPig = new GeneradorC3DPig(astPig, marcoPig, registro);
        List<Cuadruplo> c3dPig = generadorPig.generar();

        assertNotNull(c3dPig, "El C3D de Pig no debe ser nulo");
        assertFalse(c3dPig.isEmpty(), "Debe haber instrucciones C3D para Principal.pig");

        // Generar C3D de Y
        String codigoY = Files.readString(baseDir.resolve("Utilidades.y"));
        YLexer lexerY = new YLexer(CharStreams.fromString(codigoY));
        YParser parserY = new YParser(new CommonTokenStream(lexerY));
        NodoAST astY = new YTreeBuilder().visit(parserY.programa());
        List<Cuadruplo> c3dY = new GeneradorC3D().generar(astY);

        // Generar C3D de Z
        List<Cuadruplo> c3dZ = new GeneradorC3DZ().generar(cargadorZ.getUltimoProgramaAST());

        // Validar enlace con todos los modulos
        EnlazadorC3D enlazador = new EnlazadorC3D();
        enlazador.agregarModuloY(c3dY);
        enlazador.agregarModuloZ(c3dZ);
        enlazador.establecerModuloPig(c3dPig);
        List<Cuadruplo> enlazado = enlazador.enlazar();

        assertNotNull(enlazado, "El codigo enlazado no debe ser nulo");
        assertFalse(enlazador.tieneErrores(), "El enlazador no debe tener errores: " + enlazador.getErrores());
        assertTrue(enlazado.size() > 50, "El total enlazado debe contener suficientes instrucciones");
    }
}
