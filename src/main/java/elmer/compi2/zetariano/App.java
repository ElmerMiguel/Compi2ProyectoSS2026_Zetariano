package elmer.compi2.zetariano;

import com.jtattoo.plaf.hifi.HiFiLookAndFeel;
import elmer.compi2.zetariano.ui.MainWindow;

import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Punto de entrada principal de la aplicacion con soporte GUI y CLI.
 */
public class App {

    public static void main(String[] args) {
        if (args.length > 0 && !args[0].isBlank()) {
            boolean runAfter = false;
            Path archivo = null;
            for (String arg : args) {
                if ("--run".equals(arg) || "-r".equals(arg)) {
                    runAfter = true;
                } else if (!arg.startsWith("-")) {
                    archivo = Path.of(arg);
                }
            }

            if (archivo == null || !Files.exists(archivo)) {
                System.err.println("Error: Archivo no valido o inexistente: " + (archivo != null ? archivo : args[0]));
                System.exit(1);
            }

            try {
                String source = Files.readString(archivo);
                Path baseDir = archivo.toAbsolutePath().getParent();
                CompilerService service = new CompilerService();
                CompilerService.CompilationResult result = service.compilePigSource(source, baseDir);
                System.out.println(result.getConsoleLog());

                if (!result.isSuccess()) {
                    System.err.println("Compilacion fallida. Revisa los mensajes anteriores.");
                    System.exit(1);
                }

                if (runAfter && result.getNativeBinaryPath() != null) {
                    System.out.println("\n>>> Ejecutando programa compilado (" + result.getNativeBinaryPath().getFileName() + ")...");
                    Process p = new ProcessBuilder(result.getNativeBinaryPath().toString()).inheritIO().start();
                    int code = p.waitFor();
                    System.out.println("\n>>> Programa finalizado con codigo de salida: " + code);
                }

                System.exit(0);
            } catch (Exception e) {
                System.err.println("Error en ejecucion: " + e.getMessage());
                System.exit(1);
            }
            return;
        }

        // Modo Interfaz Grafica (Swing)
        SwingUtilities.invokeLater(() -> {
            try {
                UIManager.setLookAndFeel(new HiFiLookAndFeel());
            } catch (UnsupportedLookAndFeelException e) {
                System.err.println("No se pudo aplicar el Look & Feel JTattoo HiFi: " + e.getMessage());
            }

            MainWindow window = new MainWindow();
            window.setVisible(true);
        });
    }
}
