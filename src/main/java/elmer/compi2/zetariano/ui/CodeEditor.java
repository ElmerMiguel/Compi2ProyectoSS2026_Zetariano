package elmer.compi2.zetariano.ui;

import elmer.compi2.zetariano.ui.highlight.MonokaiPalette;
import elmer.compi2.zetariano.ui.highlight.PigLatinHighlighter;
import elmer.compi2.zetariano.ui.highlight.YHighlighter;
import elmer.compi2.zetariano.ui.highlight.ZHighlighter;

import javax.swing.AbstractAction;
import javax.swing.Action;
import javax.swing.JComponent;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextPane;
import javax.swing.KeyStroke;
import javax.swing.event.DocumentEvent;
import javax.swing.undo.CannotRedoException;
import javax.swing.undo.CannotUndoException;
import javax.swing.undo.UndoManager;
import javax.swing.undo.UndoableEdit;
import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;

/**
 * Panel de edicion de codigo con JTextPane, coloreado Monokai manual en tiempo real
 * y soporte independiente de Deshacer (Ctrl+Z) y Rehacer (Ctrl+Y / Ctrl+Shift+Z) por pestana.
 */
public class CodeEditor extends JPanel {

    public enum LanguageMode {
        PIG_LATIN,
        Y_PYTHON,
        ZETARIANO,
        PLAIN
    }

    private final JTextPane textPane;
    private final UndoManager undoManager;
    private LanguageMode mode;

    public CodeEditor(LanguageMode mode) {
        super(new BorderLayout());
        this.mode = mode;
        this.undoManager = new UndoManager();

        textPane = new JTextPane();
        textPane.setBackground(MonokaiPalette.BACKGROUND);
        textPane.setForeground(MonokaiPalette.FOREGROUND);
        textPane.setCaretColor(MonokaiPalette.FOREGROUND);
        textPane.setSelectionColor(new java.awt.Color(73, 72, 62));
        textPane.setSelectedTextColor(MonokaiPalette.FOREGROUND);
        
        textPane.setFont(new Font(Font.MONOSPACED, Font.PLAIN, 16));
        
        attachHighlighter(mode);
        setupUndoRedo();

        JScrollPane scrollPane = new JScrollPane(textPane);
        scrollPane.setBorder(null);
        scrollPane.setRowHeaderView(new LineNumberGutter(textPane));
        add(scrollPane, BorderLayout.CENTER);
    }

    private void setupUndoRedo() {
        // Escuchar cambios editables, ignorando cambios de solo atributos (coloreado sintactico)
        textPane.getDocument().addUndoableEditListener(e -> {
            UndoableEdit edit = e.getEdit();
            if (edit instanceof DocumentEvent de) {
                if (de.getType() == DocumentEvent.EventType.CHANGE) {
                    return; // Ignorar coloreado de estilo para no bloquear el Ctrl+Z de texto
                }
            }
            undoManager.addEdit(edit);
        });

        int mask = Toolkit.getDefaultToolkit().getMenuShortcutKeyMaskEx();
        KeyStroke undoKey = KeyStroke.getKeyStroke(KeyEvent.VK_Z, mask);
        KeyStroke redoKeyY = KeyStroke.getKeyStroke(KeyEvent.VK_Y, mask);
        KeyStroke redoKeyShiftZ = KeyStroke.getKeyStroke(KeyEvent.VK_Z, mask | KeyEvent.SHIFT_DOWN_MASK);

        Action undoAction = new AbstractAction("Undo") {
            @Override
            public void actionPerformed(ActionEvent e) {
                undo();
            }
        };

        Action redoAction = new AbstractAction("Redo") {
            @Override
            public void actionPerformed(ActionEvent e) {
                redo();
            }
        };

        textPane.getInputMap(JComponent.WHEN_FOCUSED).put(undoKey, "Undo");
        textPane.getActionMap().put("Undo", undoAction);

        textPane.getInputMap(JComponent.WHEN_FOCUSED).put(redoKeyY, "Redo");
        textPane.getInputMap(JComponent.WHEN_FOCUSED).put(redoKeyShiftZ, "Redo");
        textPane.getActionMap().put("Redo", redoAction);
    }

    public void undo() {
        try {
            if (undoManager.canUndo()) {
                undoManager.undo();
            }
        } catch (CannotUndoException ignored) {}
    }

    public void redo() {
        try {
            if (undoManager.canRedo()) {
                undoManager.redo();
            }
        } catch (CannotRedoException ignored) {}
    }

    public boolean canUndo() {
        return undoManager.canUndo();
    }

    public boolean canRedo() {
        return undoManager.canRedo();
    }

    public void clearUndoHistory() {
        undoManager.discardAllEdits();
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
        undoManager.discardAllEdits();
    }

    public JTextPane getTextPane() {
        return textPane;
    }

    public LanguageMode getMode() {
        return mode;
    }
}