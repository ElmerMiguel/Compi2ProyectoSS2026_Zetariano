package elmer.compi2.zetariano.analysis.semantic;

import elmer.compi2.zetariano.antlr.piglatin.PigLatinLexer;
import elmer.compi2.zetariano.antlr.piglatin.PigLatinParser;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class PigAnalyzerTest {

    @Test
    public void testAnalisisSemanticoPigConImports() throws Exception {
        File archivoPig = new File("docs/Pruebas/Principal.pig");
        assertTrue(archivoPig.exists(), "El archivo docs/Pruebas/Principal.pig debe existir");

        String codigo = Files.readString(archivoPig.toPath());
        PigLatinLexer lexer = new PigLatinLexer(CharStreams.fromString(codigo));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        PigLatinParser parser = new PigLatinParser(tokens);

        PigLatinParser.ProgramaContext arbol = parser.programa();
        assertEquals(0, parser.getNumberOfSyntaxErrors(), "No debe haber errores sintacticos");

        Path baseDir = Path.of("docs/Pruebas");
        PigAnalyzer semantico = new PigAnalyzer(baseDir);
        semantico.visit(arbol);

        List<String> errores = semantico.getErrores();
        assertTrue(errores.isEmpty(), "No debe haber errores semanticos en Principal.pig: " + errores);

        assertNotNull(semantico.getTabla(), "La tabla de simbolos no debe ser nula");
        assertNotNull(semantico.getTabla().buscar("entrada"), "Debe existir variable 'entrada'");
        assertNotNull(semantico.getTabla().buscar("persona"), "Debe existir variable 'persona'");
        assertNotNull(semantico.getTabla().buscar("numeros"), "Debe existir variable 'numeros'");
        assertNotNull(semantico.getTabla().buscar("prueba"), "Debe existir variable 'prueba'");

        // Validar que los imports se registraron
        assertNotNull(semantico.getRegistroImports(), "El registro de imports no debe ser nulo");
        assertNotNull(semantico.getRegistroImports().buscarClase("Persona"), "Debe reconocer la estructura Persona importada de Y");
        assertNotNull(semantico.getRegistroImports().buscarClase("Prueba"), "Debe reconocer la clase Prueba importada de Z");
    }
}
