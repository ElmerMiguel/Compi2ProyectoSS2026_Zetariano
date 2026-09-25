package elmer.compi2.zetariano.analysis.semantic;

import elmer.compi2.zetariano.imports.CargadorImportYPig;
import org.junit.jupiter.api.Test;
import java.io.File;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.*;

public class YAnalyzerTest {

    @Test
    public void testAnalisisSemanticoY() throws Exception {
        File archivoY = new File("docs/Pruebas/Utilidades.y");
        assertTrue(archivoY.exists(), "El archivo docs/Pruebas/Utilidades.y debe existir");

        CargadorImportYPig cargador = new CargadorImportYPig();
        SemanticoY semantico = cargador.cargarSemantico(archivoY.getAbsolutePath());

        assertNotNull(semantico, "El analizador semántico no debe ser nulo");
        assertNotNull(semantico.getTabla(), "La tabla de símbolos no debe ser nula");
        assertNotNull(semantico.getEstructuras(), "Las estructuras no deben ser nulas");

        // Validar que se reconocieron las estructuras
        assertTrue(semantico.getEstructuras().containsKey("Direccion"), "Debe reconocer estructura Direccion");
        assertTrue(semantico.getEstructuras().containsKey("Persona"), "Debe reconocer estructura Persona");
        assertTrue(semantico.getEstructuras().containsKey("Estudiante"), "Debe reconocer estructura Estudiante");

        // Validar funciones en la tabla de símbolos
        assertNotNull(semantico.getTabla().buscar("sumar"), "Debe existir la funcion sumar");
        assertNotNull(semantico.getTabla().buscar("saludar"), "Debe existir la funcion saludar");
        assertNotNull(semantico.getTabla().buscar("seleccionar"), "Debe existir la funcion seleccionar");
        assertNotNull(semantico.getTabla().buscar("clasificar"), "Debe existir la funcion clasificar");
    }
}
