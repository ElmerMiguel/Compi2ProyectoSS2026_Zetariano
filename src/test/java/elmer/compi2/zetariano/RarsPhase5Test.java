package elmer.compi2.zetariano;

import elmer.compi2.zetariano.ui.OutputPanel;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Pruebas unitarias para el servicio de ejecucion RARS y pipeline de compilacion.
 */
public class RarsPhase5Test {

    @Test
    public void testRarsExecutionServiceJarResolution() {
        RarsExecutionService service = new RarsExecutionService();
        Path jar = service.resolverRarsJar();
        Assertions.assertNotNull(jar);
        Assertions.assertTrue(Files.exists(jar), "El JAR de RARS debe existir en: " + jar);
    }

    @Test
    public void testRarsExecutionServiceExecution() throws Exception {
        RarsExecutionService service = new RarsExecutionService();
        String asm = """
            .data
            .text
            .globl main
            main:
                li a0, 42
                li a7, 1
                ecall
                li a7, 10
                ecall
            """;
        Path tempAsm = Files.createTempFile("test_rars_", ".s");
        try {
            Files.writeString(tempAsm, asm);
            var result = service.ejecutar(tempAsm, 5, null);
            Assertions.assertTrue(result.isSuccess(), "La ejecucion en RARS debe ser exitosa");
            Assertions.assertEquals(0, result.getExitCode());
            Assertions.assertTrue(result.getOutput().contains("42"), "La salida debe contener 42");
        } finally {
            Files.deleteIfExists(tempAsm);
        }
    }

    @Test
    public void testCompilerServiceEndToEndRiscV() throws Exception {
        CompilerService service = new CompilerService();
        String pigCode = """
            MAIOR>
                esto x : numerus 25;
                esto y : numerus 17;
                esto suma : numerus x + y;
                >> suma;
            FINIS;
            """;
        Path tempDir = Files.createTempDirectory("test_pipeline_pig_");
        try {
            var result = service.compilePigSource(pigCode, tempDir);
            Assertions.assertTrue(result.isSuccess(), "La compilacion debe ser exitosa: " + result.getErrors());
            Assertions.assertFalse(result.getCodigoRiscV().isBlank(), "Debe generarse codigo RISC-V");
            Assertions.assertNotNull(result.getArchivoRiscV());
            Assertions.assertTrue(Files.exists(result.getArchivoRiscV()), "El archivo .s debe existir");

            RarsExecutionService rarsService = new RarsExecutionService();
            var execRes = rarsService.ejecutar(result.getArchivoRiscV(), 10, null);
            Assertions.assertTrue(execRes.isSuccess(), "RARS debe ejecutar el codigo generado con exito");
            Assertions.assertTrue(execRes.getOutput().contains("42"), "La ejecucion en RARS debe imprimir 42 (25+17)");
        } finally {
            if (Files.exists(tempDir)) {
                try (var stream = Files.walk(tempDir)) {
                    stream.sorted((a, b) -> b.compareTo(a)).forEach(p -> {
                        try { Files.deleteIfExists(p); } catch (Exception ignored) {}
                    });
                }
            }
        }
    }

    @Test
    public void testOutputPanelTabRiscV() {
        OutputPanel panel = new OutputPanel();
        panel.setRiscVOutput("# Codigo de prueba RISC-V");
        panel.selectTabByTitle("Ensamblador RISC-V");
        panel.appendConsole("Mensaje de prueba");
        panel.clearAll();
    }
}
