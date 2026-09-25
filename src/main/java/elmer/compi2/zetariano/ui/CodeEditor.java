package elmer.compi2.zetariano.ui;

import elmer.compi2.zetariano.ui.highlight.MonokaiPalette;
import elmer.compi2.zetariano.ui.highlight.PigLatinHighlighter;
import elmer.compi2.zetariano.ui.highlight.YHighlighter;
import elmer.compi2.zetariano.ui.highlight.ZHighlighter;

import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextPane;
import javax.swing.UIManager;
import java.awt.BorderLayout;
import java.awt.Font;

/**
 * Panel de edicion de codigo con JTextPane y coloreado Monokai manual en tiempo real.
 */
public class CodeEditor extends JPanel {

    public enum LanguageMode {
        PIG_LATIN,
        Y_PYTHON,
        ZETARIANO,
        PLAIN
    }

    private final JTextPane textPane;
    private LanguageMode mode;

    public CodeEditor(LanguageMode mode) {
        super(new BorderLayout());
        this.mode = mode;

        textPane = new JTextPane();
        textPane.setBackground(MonokaiPalette.BACKGROUND);
        textPane.setForeground(MonokaiPalette.FOREGROUND);
        textPane.setCaretColor(MonokaiPalette.FOREGROUND);
        textPane.setSelectionColor(new java.awt.Color(73, 72, 62));
        textPane.setSelectedTextColor(MonokaiPalette.FOREGROUND);
        textPane.setFont(new Font(Font.MONOSPACED, Font.PLAIN, 14));

        attachHighlighter(mode);

        JScrollPane scrollPane = new JScrollPane(textPane);
        scrollPane.setBorder(null);
        add(scrollPane, BorderLayout.CENTER);
    }

    private void attachHighlighter(LanguageMode mode) {
        switch (mode) {
            case PIG_LATIN -> PigLatinHighlighter.install(textPane);
            case Y_PYTHON -> YHighlighter.install(textPane);
            case ZETARIANO -> ZHighlighter.install(textPane);
            default -> {}
        }
    }

    public String getText() {
        return textPane.getText();
    }

    public void setText(String text) {
        textPane.setText(text == null ? "" : text);
        textPane.setCaretPosition(0);
    }

    public JTextPane getTextPane() {
        return textPane;
    }

    public LanguageMode getMode() {
        return mode;
    }
}
