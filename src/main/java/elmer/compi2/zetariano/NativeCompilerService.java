package elmer.compi2.zetariano;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * Servicio para compilar código C generado mediante GCC/Clang y
 * ejecutar el binario nativo resultante en terminal externa o modo headless.
 */
public class NativeCompilerService {

    public static class NativeCompileResult {
        private final boolean success;
        private final int exitCode;
        private final String outputMessage;
        private final Path binaryPath;

        public NativeCompileResult(boolean success, int exitCode, String outputMessage, Path binaryPath) {
            this.success = success;
            this.exitCode = exitCode;
            this.outputMessage = outputMessage;
            this.binaryPath = binaryPath;
        }

        public boolean isSuccess() {
            return success;
        }

        public int getExitCode() {
            return exitCode;
        }

        public String getOutputMessage() {
            return outputMessage;
        }

        public Path getBinaryPath() {
            return binaryPath;
        }

        public static Builder builder() {
            return new Builder();
        }

        public static class Builder {
            private boolean success;
            private int exitCode;
            private String outputMessage;
            private Path binaryPath;

            public Builder success(boolean success) {
                this.success = success;
                return this;
            }

            public Builder exitCode(int exitCode) {
                this.exitCode = exitCode;
                return this;
            }

            public Builder outputMessage(String outputMessage) {
                this.outputMessage = outputMessage;
                return this;
            }

            public Builder binaryPath(Path binaryPath) {
                this.binaryPath = binaryPath;
                return this;
            }

            public NativeCompileResult build() {
                return new NativeCompileResult(success, exitCode, outputMessage, binaryPath);
            }
        }
    }

    public static boolean isWindows() {
        return System.getProperty("os.name", "").toLowerCase().contains("win");
    }

    public static boolean isMac() {
        return System.getProperty("os.name", "").toLowerCase().contains("mac");
    }

    /**
     * Detecta el compilador de C disponible en el sistema (gcc, cc, clang).
     */
    public static String findCCompiler() {
        String[] candidates;
        if (isWindows()) {
            candidates = new String[]{"gcc", "clang", "cc"};
        } else if (isMac()) {
            candidates = new String[]{"clang", "gcc", "cc"};
        } else {
            candidates = new String[]{"gcc", "cc", "clang"};
        }

        for (String cmd : candidates) {
            if (isCommandAvailable(cmd)) {
                return cmd;
            }
        }
        return null;
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

    /**
     * Compila el archivo C generado produciendo un archivo binario ejecutable.
     */
    public static NativeCompileResult compileC(Path cFilePath) {
        if (cFilePath == null || !Files.exists(cFilePath)) {
            return NativeCompileResult.builder()
                    .success(false)
                    .outputMessage("El archivo C no existe: " + cFilePath)
                    .build();
        }

        String compiler = findCCompiler();
        if (compiler == null) {
            return NativeCompileResult.builder()
                    .success(false)
                    .outputMessage("No se encontro un compilador C (gcc, cc o clang) en el PATH del sistema.")
                    .build();
        }

        Path parent = cFilePath.getParent() != null ? cFilePath.getParent() : Path.of(".");
        String baseName = cFilePath.getFileName().toString();
        int dot = baseName.lastIndexOf('.');
        String execName = (dot > 0) ? baseName.substring(0, dot) : baseName;
        if (isWindows()) {
            execName += ".exe";
        }

        Path binaryPath = parent.resolve(execName);

        List<String> command = new ArrayList<>();
        command.add(compiler);
        command.add(cFilePath.getFileName().toString());
        command.add("-o");
        command.add(execName);
        command.add("-lm");

        try {
            ProcessBuilder pb = new ProcessBuilder(command);
            pb.directory(parent.toFile());
            pb.redirectErrorStream(true);

            Process process = pb.start();
            String output = new String(process.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
            int exitCode = process.waitFor();

            boolean ok = (exitCode == 0) && Files.exists(binaryPath);
            return NativeCompileResult.builder()
                    .success(ok)
                    .exitCode(exitCode)
                    .outputMessage(output.isBlank() ? "Compilacion C exitosa sin advertencias." : output)
                    .binaryPath(binaryPath)
                    .build();

        } catch (Exception e) {
            return NativeCompileResult.builder()
                    .success(false)
                    .exitCode(-1)
                    .outputMessage("Error ejecutando compilador C: " + e.getMessage())
                    .binaryPath(null)
                    .build();
        }
    }

    /**
     * Lanza el binario nativo en una terminal grafica interactiva (para poder ingresar datos en <<).
     */
    public static boolean launchInTerminal(Path binaryPath) {
        if (binaryPath == null || !Files.exists(binaryPath)) {
            return false;
        }

        ProcessBuilder pb = createTerminalProcess(binaryPath);
        if (pb == null) {
            return false;
        }

        try {
            if (binaryPath.getParent() != null) {
                pb.directory(binaryPath.getParent().toFile());
            }
            pb.start();
            return true;
        } catch (IOException e) {
            return false;
        }
    }

    private static ProcessBuilder createTerminalProcess(Path binaryPath) {
        String absPath = binaryPath.toAbsolutePath().toString();

        if (isWindows()) {
            return new ProcessBuilder("cmd.exe", "/c", "start", "Compilador Zetariano - Ejecucion", "cmd.exe", "/k", absPath);
        }

        if (isMac()) {
            String script = "tell application \"Terminal\" to do script \"" + absPath + "; echo; read -p 'Presiona Enter para cerrar...'\"";
            return new ProcessBuilder("osascript", "-e", script);
        }

        // Linux terminals
        String command = absPath + "; echo; echo 'Programa finalizado. Presiona Enter para cerrar...'; read";

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
}
