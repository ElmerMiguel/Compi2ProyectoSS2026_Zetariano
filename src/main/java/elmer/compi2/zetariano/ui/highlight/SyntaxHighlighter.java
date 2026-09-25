package elmer.compi2.zetariano.ui.highlight;

import javax.swing.JTextPane;
import javax.swing.SwingUtilities;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.text.BadLocationException;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;
import java.awt.Color;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Base abstracta para resaltado de sintaxis 100% manual con tema Monokai
 * usando StyledDocument y DocumentListener.
 */
public abstract class SyntaxHighlighter {

    protected final JTextPane editor;
    private boolean updatePending = false;

    public SyntaxHighlighter(JTextPane editor) {
        this.editor = editor;
        initListener();
        scheduleHighlight();
    }

    private void initListener() {
        editor.getDocument().addDocumentListener(new DocumentListener() {
            @Override
            public void insertUpdate(DocumentEvent e) {
                scheduleHighlight();
            }

            @Override
            public void removeUpdate(DocumentEvent e) {
                scheduleHighlight();
            }

            @Override
            public void changedUpdate(DocumentEvent e) {
                // Ignore style changes to prevent recursive loop
            }
        });
    }

    public void scheduleHighlight() {
        if (updatePending) {
            return;
        }
        updatePending = true;
        SwingUtilities.invokeLater(() -> {
            updatePending = false;
            applyHighlight();
        });
    }

    protected abstract void applyHighlightRules(StyledDocument doc, String text);

    private void applyHighlight() {
        StyledDocument doc = editor.getStyledDocument();
        String text;
        try {
            text = doc.getText(0, doc.getLength());
        } catch (BadLocationException e) {
            return;
        }

        // 1. Reset everything to Monokai foreground normal text
        SimpleAttributeSet baseStyle = createStyle(MonokaiPalette.FOREGROUND, false, false);
        doc.setCharacterAttributes(0, doc.getLength(), baseStyle, true);

        // 2. Apply specific language token patterns
        applyHighlightRules(doc, text);
    }

    protected void matchAndApply(StyledDocument doc, String text, Pattern pattern, SimpleAttributeSet style) {
        Matcher matcher = pattern.matcher(text);
        while (matcher.find()) {
            int start = matcher.start();
            int length = matcher.end() - start;
            doc.setCharacterAttributes(start, length, style, true);
        }
    }

    protected SimpleAttributeSet createStyle(Color color, boolean bold, boolean italic) {
        SimpleAttributeSet attrs = new SimpleAttributeSet();
        StyleConstants.setForeground(attrs, color);
        StyleConstants.setBold(attrs, bold);
        StyleConstants.setItalic(attrs, italic);
        return attrs;
    }
}
