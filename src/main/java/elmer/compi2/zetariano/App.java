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
            // Modo Linea de Comandos (CLI headless)
            Path archivo = Path.of(args[0]);
            if (!Files.exists(archivo)) {
                System.err.println("Error: No se encontro el archivo: " + args[0]);
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
                System.exit(0);
            } catch (IOException e) {
                System.err.println("Error al leer archivo: " + e.getMessage());
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
