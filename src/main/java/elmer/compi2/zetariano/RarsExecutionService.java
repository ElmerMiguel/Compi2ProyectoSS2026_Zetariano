package elmer.compi2.zetariano;

import lombok.Builder;
import lombok.Getter;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * Servicio de ejecucion y simulacion de ensamblador RISC-V en RARS.
 */
public class RarsExecutionService {

    private static final String RARS_JAR_NAME = "tools/rars1_6.jar";

    @Getter
    @Builder
    public static class RarsExecutionResult {
        private final boolean success;
        private final int exitCode;
        private final String stdout;
        private final String stderr;
        private final String combinedOutput;
        private final boolean timedOut;

        public String getOutput() {
            return combinedOutput != null ? combinedOutput : "";
        }
    }

    public Path resolverRarsJar() {
        Path rutaDirecta = Path.of(RARS_JAR_NAME);
        if (Files.exists(rutaDirecta)) {
            return rutaDirecta.toAbsolutePath();
        }

        Path rutaSubdirectorio = Path.of("..", RARS_JAR_NAME);
        if (Files.exists(rutaSubdirectorio)) {
            return rutaSubdirectorio.toAbsolutePath();
        }

        File backup = new File("src/backup_original/tools/rars1_6.jar");
        if (backup.exists()) {
            return backup.toPath().toAbsolutePath();
        }

        return rutaDirecta.toAbsolutePath();
    }

    public RarsExecutionResult ejecutar(Path archivoAsm) {
        return ejecutar(archivoAsm, 10, null);
    }

    public RarsExecutionResult ejecutar(Path archivoAsm, int timeoutSegundos, String entradaSimulada) {
        if (archivoAsm == null || !Files.exists(archivoAsm)) {
            return RarsExecutionResult.builder()
                    .success(false)
                    .exitCode(-1)
                    .stdout("")
                    .stderr("El archivo ensamblador RISC-V no existe: " + archivoAsm)
                    .combinedOutput("El archivo ensamblador RISC-V no existe: " + archivoAsm)
                    .timedOut(false)
                    .build();
        }

        Path rarsJar = resolverRarsJar();
        if (!Files.exists(rarsJar)) {
            return RarsExecutionResult.builder()
                    .success(false)
                    .exitCode(-1)
                    .stdout("")
                    .stderr("No se encontro el ejecutable de RARS en: " + rarsJar)
                    .combinedOutput("No se encontro el ejecutable de RARS en: " + rarsJar)
                    .timedOut(false)
                    .build();
        }

        List<String> comando = new ArrayList<>();
        comando.add("java");
        comando.add("-jar");
        comando.add(rarsJar.toString());
        comando.add("nc");
        comando.add("sm");
        comando.add(archivoAsm.toAbsolutePath().toString());

        ProcessBuilder pb = new ProcessBuilder(comando);
        pb.redirectErrorStream(true);

        StringBuilder output = new StringBuilder();
        boolean timedOut = false;
        int exitCode = -1;

        try {
            Process proceso = pb.start();

            if (entradaSimulada != null && !entradaSimulada.isEmpty()) {
                try (OutputStream os = proceso.getOutputStream()) {
                    os.write(entradaSimulada.getBytes(StandardCharsets.UTF_8));
                    os.flush();
                }
            }

            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(proceso.getInputStream(), StandardCharsets.UTF_8))) {
                String linea;
                while ((linea = reader.readLine()) != null) {
                    output.append(linea).append("\n");
                }
            }

            boolean terminado = proceso.waitFor(timeoutSegundos, TimeUnit.SECONDS);
            if (terminado) {
                exitCode = proceso.exitValue();
            } else {
                proceso.destroyForcibly();
                timedOut = true;
                output.append("\n[TIMEOUT]: La ejecucion en RARS excedio el tiempo limite de ")
                        .append(timeoutSegundos).append(" segundos.\n");
            }

        } catch (Exception e) {
            output.append("\n[ERROR]: Fallo al ejecutar RARS: ").append(e.getMessage()).append("\n");
        }

        boolean exito = !timedOut && exitCode == 0;
        return RarsExecutionResult.builder()
                .success(exito)
                .exitCode(exitCode)
                .stdout(output.toString())
                .stderr("")
                .combinedOutput(output.toString())
                .timedOut(timedOut)
                .build();
    }

    public boolean abrirGui(Path archivoAsm) {
        Path rarsJar = resolverRarsJar();
        if (!Files.exists(rarsJar)) {
            return false;
        }

        List<String> comando = new ArrayList<>();
        comando.add("java");
        comando.add("-jar");
        comando.add(rarsJar.toString());
        if (archivoAsm != null && Files.exists(archivoAsm)) {
            comando.add(archivoAsm.toAbsolutePath().toString());
        }

        ProcessBuilder pb = new ProcessBuilder(comando);
        try {
            pb.start();
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
