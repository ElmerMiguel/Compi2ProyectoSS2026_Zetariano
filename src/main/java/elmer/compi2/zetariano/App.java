package elmer.compi2.zetariano;

import com.jtattoo.plaf.hifi.HiFiLookAndFeel;
import elmer.compi2.zetariano.ui.MainWindow;

import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;

/**
 * Punto de entrada principal de la aplicacion con Look & Feel JTattoo HiFi.
 */
public class App {

    public static void main(String[] args) {
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
