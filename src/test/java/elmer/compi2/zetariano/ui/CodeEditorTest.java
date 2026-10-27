package elmer.compi2.zetariano.ui;

import org.junit.jupiter.api.Test;

import javax.swing.text.BadLocationException;

import static org.junit.jupiter.api.Assertions.*;

public class CodeEditorTest {

    @Test
    public void testUndoRedoPerEditor() throws BadLocationException {
        CodeEditor editor1 = new CodeEditor(CodeEditor.LanguageMode.PIG_LATIN);
        editor1.setText("INICIAL");

        // Al iniciar setText, el historial debe estar limpio
        assertFalse(editor1.canUndo());
        assertFalse(editor1.canRedo());

        // Insertar texto en editor 1
        editor1.getTextPane().getDocument().insertString(editor1.getTextPane().getDocument().getLength(), " EXTRA", null);
        assertEquals("INICIAL EXTRA", editor1.getText());
        assertTrue(editor1.canUndo());

        // Undo en editor 1
        editor1.undo();
        assertEquals("INICIAL", editor1.getText());
        assertTrue(editor1.canRedo());

        // Redo en editor 1
        editor1.redo();
        assertEquals("INICIAL EXTRA", editor1.getText());

        // Comprobar aislamiento con otro editor
        CodeEditor editor2 = new CodeEditor(CodeEditor.LanguageMode.ZETARIANO);
        editor2.setText("CLASE");
        assertFalse(editor2.canUndo());
        assertFalse(editor2.canRedo());
    }
}
