package elmer.compi2.zetariano;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
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

    /**
     * DTO con el resultado de la simulacion en RARS.
     */
    public static class RarsExecutionResult {
        private final boolean success;
        private final int exitCode;
        private final String stdout;
        private final String stderr;
        private final String combinedOutput;
        private final boolean timedOut;

        public RarsExecutionResult(
                boolean success,
                int exitCode,
                String stdout,
                String stderr,
                String combinedOutput,
                boolean timedOut
        ) {
            this.success = success;
            this.exitCode = exitCode;
            this.stdout = stdout;
            this.stderr = stderr;
            this.combinedOutput = combinedOutput;
            this.timedOut = timedOut;
        }

        public boolean isSuccess() {
            return success;
        }

        public int getExitCode() {
            return exitCode;
        }

        public String getStdout() {
            return stdout;
        }

        public String getStderr() {
            return stderr;
        }

        public String getCombinedOutput() {
            return combinedOutput;
        }

        public boolean isTimedOut() {
            return timedOut;
        }

        public String getOutput() {
            return combinedOutput != null ? combinedOutput : "";
        }

        public static Builder builder() {
            return new Builder();
        }

        public static class Builder {
            private boolean success;
            private int exitCode;
            private String stdout;
            private String stderr;
            private String combinedOutput;
            private boolean timedOut;

            public Builder success(boolean success) {
                this.success = success;
                return this;
            }

            public Builder exitCode(int exitCode) {
                this.exitCode = exitCode;
                return this;
            }

            public Builder stdout(String stdout) {
                this.stdout = stdout;
                return this;
            }

            public Builder stderr(String stderr) {
                this.stderr = stderr;
                return this;
            }

            public Builder combinedOutput(String combinedOutput) {
                this.combinedOutput = combinedOutput;
                return this;
            }

            public Builder timedOut(boolean timedOut) {
                this.timedOut = timedOut;
                return this;
            }

            public RarsExecutionResult build() {
                return new RarsExecutionResult(success, exitCode, stdout, stderr, combinedOutput, timedOut);
            }
        }
    }

    public Path resolverRarsJar() {
        // 1. Verificar si existe en la carpeta tools local o relativa
        Path rutaDirecta = Path.of(RARS_JAR_NAME);
        if (Files.exists(rutaDirecta)) {
            return rutaDirecta.toAbsolutePath();
        }

        Path rutaSubdirectorio = Path.of("..", RARS_JAR_NAME);
        if (Files.exists(rutaSubdirectorio)) {
            return rutaSubdirectorio.toAbsolutePath();
        }

        // 2. Verificar junto al JAR en ejecucion
        try {
            Path ubicacionApp = Path.of(
                    RarsExecutionService.class.getProtectionDomain()
                            .getCodeSource().getLocation().toURI()
            ).toAbsolutePath().normalize();
            Path dirPadre = Files.isRegularFile(ubicacionApp) ? ubicacionApp.getParent() : ubicacionApp;
            if (dirPadre != null) {
                Path juntoAlJar = dirPadre.resolve(RARS_JAR_NAME);
                if (Files.exists(juntoAlJar)) {
                    return juntoAlJar.toAbsolutePath();
                }
                Path enMismoDir = dirPadre.resolve("rars1_6.jar");
                if (Files.exists(enMismoDir)) {
                    return enMismoDir.toAbsolutePath();
                }
            }
        } catch (Exception ignored) {
        }

        File backup = new File("src/backup_original/tools/rars1_6.jar");
        if (backup.exists()) {
            return backup.toPath().toAbsolutePath();
        }

        // 3. Extraer desde los recursos embebidos en el Fat JAR si no existe fisicamente
        try {
            var stream = getClass().getResourceAsStream("/tools/rars1_6.jar");
            if (stream != null) {
                Path tempRars = Files.createTempFile("rars1_6_", ".jar");
                tempRars.toFile().deleteOnExit();
                try (stream; var out = Files.newOutputStream(tempRars)) {
                    stream.transferTo(out);
                }
                return tempRars.toAbsolutePath();
            }
        } catch (Exception ignored) {
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

    /**
     * Lanza la simulacion interactiva en una terminal grafica externa.
     */
    public boolean launchInTerminal(Path archivoAsm) {
        if (archivoAsm == null || !Files.exists(archivoAsm)) {
            return false;
        }

        Path rarsJar = resolverRarsJar();
        if (!Files.exists(rarsJar)) {
            return false;
        }

        ProcessBuilder pb = createTerminalProcess(rarsJar, archivoAsm);
        if (pb == null) {
            return false;
        }

        try {
            if (archivoAsm.getParent() != null) {
                pb.directory(archivoAsm.getParent().toFile());
            }
            pb.start();
            return true;
        } catch (IOException e) {
            return false;
        }
    }

    private ProcessBuilder createTerminalProcess(Path rarsJar, Path archivoAsm) {
        String jarPath = rarsJar.toAbsolutePath().toString();
        String asmPath = archivoAsm.toAbsolutePath().toString();

        if (isWindows()) {
            String winCmd = "java -jar \"" + jarPath + "\" nc sm \"" + asmPath + "\"";
            return new ProcessBuilder("cmd.exe", "/c", "start", "Simulacion RISC-V en RARS", "cmd.exe", "/k", winCmd);
        }

        if (isMac()) {
            String script = "tell application \"Terminal\" to do script \"java -jar '" + jarPath + "' nc sm '" + asmPath + "'; echo; read -p 'Presiona Enter para cerrar...'\"";
            return new ProcessBuilder("osascript", "-e", script);
        }

        // Linux terminals
        String command = "java -jar \"" + jarPath + "\" nc sm \"" + asmPath + "\"; echo; echo 'Simulacion RARS finalizada. Presiona Enter para cerrar...'; read";

        if (isCommandAvailable("x-terminal-emulator")) {
            return new ProcessBuilder("x-terminal-emulator", "-e", "bash", "-lc", command);
        }
        if (isCommandAvailable("gnome-terminal")) {
            return new ProcessBuilder("gnome-terminal", "--", "bash", "-lc", command);
        }
        if (isCommandAvailable("konsole")) {
            return new ProcessBuilder("konsole", "-e", "bash", "-lc", command);
        }
        if (isCommandAvailable("xfce4-terminal")) {
            return new ProcessBuilder("xfce4-terminal", "--command", "bash -lc \"" + command + "\"");
        }
        if (isCommandAvailable("xterm")) {
            return new ProcessBuilder("xterm", "-e", "bash", "-lc", command);
        }

        return null;
    }

    private static boolean isWindows() {
        return System.getProperty("os.name", "").toLowerCase().contains("win");
    }

    private static boolean isMac() {
        return System.getProperty("os.name", "").toLowerCase().contains("mac");
    }

    private static boolean isCommandAvailable(String cmd) {
        try {
            ProcessBuilder pb = isWindows()
                    ? new ProcessBuilder("where", cmd)
                    : new ProcessBuilder("which", cmd);
            Process p = pb.start();
            return p.waitFor() == 0;
        } catch (Exception e) {
            return false;
        }
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
