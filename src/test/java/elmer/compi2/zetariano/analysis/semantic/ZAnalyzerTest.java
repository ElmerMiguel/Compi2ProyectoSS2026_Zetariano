package elmer.compi2.zetariano.analysis.semantic;

import elmer.compi2.zetariano.antlr.zeta.ZLexer;
import elmer.compi2.zetariano.antlr.zeta.ZParser;
import elmer.compi2.zetariano.analysis.semantic.zeta.ClaseZ;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.nio.file.Files;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class ZAnalyzerTest {

    @Test
    public void testAnalisisSemanticoZ() throws Exception {
        File archivoZ = new File("docs/Pruebas/Prueba.z");
        assertTrue(archivoZ.exists(), "El archivo docs/Pruebas/Prueba.z debe existir");

        String codigo = Files.readString(archivoZ.toPath());
        ZLexer lexer = new ZLexer(CharStreams.fromString(codigo));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        ZParser parser = new ZParser(tokens);

        ZParser.ProgramaContext arbol = parser.programa();
        assertEquals(0, parser.getNumberOfSyntaxErrors(), "No debe haber errores sintacticos");

        ZAnalyzer semantico = new ZAnalyzer();
        semantico.analizar(arbol);

        List<String> errores = semantico.getErrores();
        assertTrue(errores.isEmpty(), "No debe haber errores semanticos en Prueba.z: " + errores);

        ClaseZ clase = semantico.getClaseActual();
        assertNotNull(clase, "La clase actual no debe ser nula");
        assertEquals("Prueba", clase.getNombre(), "La clase debe ser 'Prueba'");

        // Verificar constructores
        assertNotNull(clase.getConstructores(), "Debe tener constructores");
        assertFalse(clase.getConstructores().isEmpty(), "Debe registrar constructores de Prueba");

        // Verificar metodos definidos
        assertNotNull(clase.buscarMetodoPorFirma("factorial(int)"), "Debe existir metodo factorial(int)");
        assertNotNull(clase.buscarMetodoPorFirma("clasificarTernario(int)"), "Debe existir metodo clasificarTernario(int)");
        assertNotNull(clase.buscarMetodoPorFirma("unirTextos(String,String)"), "Debe existir metodo unirTextos(String,String)");
    }
}
