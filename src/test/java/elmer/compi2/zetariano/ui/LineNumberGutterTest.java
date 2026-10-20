package elmer.compi2.zetariano.ui;

import org.junit.jupiter.api.Test;

import javax.swing.JScrollPane;
import javax.swing.JTextPane;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;

import static org.junit.jupiter.api.Assertions.*;

public class LineNumberGutterTest {

    @Test
    public void testLineNumberGutterCreationAndPainting() {
        CodeEditor editor = new CodeEditor(CodeEditor.LanguageMode.PIG_LATIN);
        editor.setText("linea 1\nlinea 2\nlinea 3\nlinea 4\nlinea 5\n");

        JTextPane textPane = editor.getTextPane();
        LineNumberGutter gutter = new LineNumberGutter(textPane);

        Dimension preferred = gutter.getPreferredSize();
        assertNotNull(preferred);
        assertTrue(preferred.width > 0, "El ancho del gutter debe ser mayor a 0");

        // Simular pintado en headless graphics
        BufferedImage img = new BufferedImage(100, 300, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g2 = img.createGraphics();
        assertDoesNotThrow(() -> gutter.paint(g2), "El gutter debe pintarse sin lanzar excepciones");
        g2.dispose();
    }

    @Test
    public void testWidthExpandsWithManyLines() {
        JTextPane pane = new JTextPane();
        LineNumberGutter gutter = new LineNumberGutter(pane);

        pane.setText("single line");
        int widthFewLines = gutter.getPreferredSize().width;

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 1500; i++) {
            sb.append("line ").append(i).append("\n");
        }
        pane.setText(sb.toString());

        int widthManyLines = gutter.getPreferredSize().width;
        assertTrue(widthManyLines >= widthFewLines, "El ancho debe ser igual o mayor para 1500 lineas (4 digitos)");
    }
}
