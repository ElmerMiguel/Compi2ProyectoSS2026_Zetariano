package elmer.compi2.zetariano;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Suite oficial de pruebas de validacion final para RARS RISC-V RV32.
 */
public class PruebaFinalRiscVTest {

    private final CompilerService compilerService = new CompilerService();
    private final RarsExecutionService rarsService = new RarsExecutionService();

    @Test
    public void testSuiteZoologicoCompleto() throws Exception {
        Path path = TestPathResolver.resolve("docs/Pruebas/ArchivosProyectoFinal/01_zoologico/Zoologico.pig");
        if (!Files.exists(path)) {
            System.out.println("[SKIP] Zoologico.pig no disponible en: " + path);
            return;
        }

        var result = compilerService.compilePigFile(path);
        Assertions.assertTrue(result.isSuccess(), "La compilacion de Zoologico debe ser exitosa: " + result.getErrors());
        Assertions.assertFalse(result.getCodigoRiscV().isBlank(), "Debe generarse codigo RISC-V");
        Assertions.assertNotNull(result.getArchivoRiscV());

        var execRes = rarsService.ejecutar(result.getArchivoRiscV(), 15, null);
        Assertions.assertTrue(execRes.isSuccess(), "RARS debe ejecutar Zoologico exitosamente: " + execRes.getStderr());
        Assertions.assertEquals(0, execRes.getExitCode(), "El codigo de retorno debe ser 0");

        String out = execRes.getOutput();
        Assertions.assertTrue(out.contains("=== ZOOLOGICO ZETARIANO ==="), "Debe contener titulo");
        Assertions.assertTrue(out.contains("Firulais"), "Debe contener Firulais");
        Assertions.assertTrue(out.contains("Guau guau"), "Debe contener sonido de Perro");
        Assertions.assertTrue(out.contains("Garfield"), "Debe contener Garfield");
        Assertions.assertTrue(out.contains("Miau"), "Debe contener sonido de Gato");
        Assertions.assertTrue(out.contains("Lola"), "Debe contener Lola");
        Assertions.assertTrue(out.contains("Muuu"), "Debe contener sonido de Vaca");
        Assertions.assertTrue(out.contains("Donald"), "Debe contener Donald");
        Assertions.assertTrue(out.contains("Cuac cuac"), "Debe contener sonido de Pato");
        Assertions.assertTrue(out.contains("Porky"), "Debe contener Porky");
        Assertions.assertTrue(out.contains("Oink oink"), "Debe contener sonido de Cerdo");
        Assertions.assertTrue(out.contains("Hay un animal fantasma? No, es null"), "Debe validar fantasma == null");
        Assertions.assertTrue(out.contains("Scooby dice: Guau guau"), "Debe contener llamada polimorfica de Scooby");
    }

    @Test
    public void testSuiteEscuelaCompleto() throws Exception {
        Path path = TestPathResolver.resolve("docs/Pruebas/ArchivosProyectoFinal/02_escuela/Escuela.pig");
        if (!Files.exists(path)) {
            System.out.println("[SKIP] Escuela.pig no disponible en: " + path);
            return;
        }

        var result = compilerService.compilePigFile(path);
        Assertions.assertTrue(result.isSuccess(), "La compilacion de Escuela debe ser exitosa: " + result.getErrors());
        Assertions.assertNotNull(result.getArchivoRiscV());

        var execRes = rarsService.ejecutar(result.getArchivoRiscV(), 20, null);
        Assertions.assertTrue(execRes.isSuccess(), "RARS debe ejecutar Escuela exitosamente: " + execRes.getStderr());
        Assertions.assertEquals(0, execRes.getExitCode());

        String out = execRes.getOutput();
        Assertions.assertTrue(out.contains("=== ESCUELA ZETARIANA ==="));
        Assertions.assertTrue(out.contains("--- Presentaciones (polimorfismo) ---"));
        Assertions.assertTrue(out.contains("--- Saludos ---"));
        Assertions.assertTrue(out.contains("--- Validaciones ---"));
        Assertions.assertTrue(out.contains("--- Evaluaciones ---"));
        Assertions.assertTrue(out.contains("--- Reporte ---"));
    }

    @Test
    public void testSuiteFigurasCompleto() throws Exception {
        Path path = TestPathResolver.resolve("docs/Pruebas/ArchivosProyectoFinal/04_figuras/Figuras.pig");
        if (!Files.exists(path)) {
            System.out.println("[SKIP] Figuras.pig no disponible en: " + path);
            return;
        }

        var result = compilerService.compilePigFile(path);
        Assertions.assertTrue(result.isSuccess(), "La compilacion de Figuras debe ser exitosa: " + result.getErrors());
        Assertions.assertNotNull(result.getArchivoRiscV());

        var execRes = rarsService.ejecutar(result.getArchivoRiscV(), 20, null);
        Assertions.assertTrue(execRes.isSuccess(), "RARS debe ejecutar Figuras exitosamente: " + execRes.getStderr());
        Assertions.assertEquals(0, execRes.getExitCode());

        String out = execRes.getOutput();
        Assertions.assertTrue(out.contains("=== FIGURAS GEOMETRICAS ==="));
        Assertions.assertTrue(out.contains("--- Descripciones ---"));
        Assertions.assertTrue(out.contains("--- Estadisticas (funciones Y?) ---"));
        Assertions.assertTrue(out.contains("--- Clasificacion por tamano ---"));
        Assertions.assertTrue(out.contains("--- La figura mas grande ---"));
        Assertions.assertTrue(out.contains("--- Recorrido con perge e interrumpe ---"));
        Assertions.assertTrue(out.contains("--- Raiz cuadrada aproximada ---"));
    }

    @Test
    public void testSuiteArenaCompleto() throws Exception {
        Path path = TestPathResolver.resolve("docs/Pruebas/ArchivosProyectoFinal/05_arena/Arena.pig");
        if (!Files.exists(path)) {
            System.out.println("[SKIP] Arena.pig no disponible en: " + path);
            return;
        }

        var result = compilerService.compilePigFile(path);
        Assertions.assertTrue(result.isSuccess(), "La compilacion de Arena debe ser exitosa: " + result.getErrors());
        Assertions.assertNotNull(result.getArchivoRiscV());

        // Secuencia de entrada para simular combate:
        // Heroe 0: accion 2 (habilidad), objetivo 0 (Oinkzilla)
        // Heroe 1: accion 2 (habilidad), objetivo 0
        // Heroe 2: accion 2 (habilidad), objetivo 0
        // Repetir ataques o habilidad hasta rendirse o vencer
        // Entrada: 2 0 \n 2 0 \n 2 0 \n ... o 0 para rendirse
        String inputSimulado = """
            2
            0
            2
            0
            2
            0
            0
            """;

        var execRes = rarsService.ejecutar(result.getArchivoRiscV(), 30, inputSimulado);
        Assertions.assertTrue(execRes.isSuccess(), "RARS debe ejecutar Arena exitosamente: " + execRes.getStderr());
        Assertions.assertEquals(0, execRes.getExitCode());

        String out = execRes.getOutput();
        Assertions.assertTrue(out.contains("=== ARENA ZETARIANA ==="));
        Assertions.assertTrue(out.contains("--- RONDA "));
        Assertions.assertTrue(out.contains("=== FIN DE LA BATALLA ==="));
        Assertions.assertTrue(out.contains("===== ESTADISTICAS ====="));
    }
}
