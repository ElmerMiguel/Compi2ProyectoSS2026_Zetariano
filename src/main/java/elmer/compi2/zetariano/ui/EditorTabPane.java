package elmer.compi2.zetariano.ui;

import javax.swing.JPanel;
import javax.swing.JTabbedPane;
import java.awt.BorderLayout;
import java.io.File;
import java.util.HashMap;
import java.util.Map;

/**
 * Gestor de pestanas de edicion para multiples archivos abiertos.
 */
public class EditorTabPane extends JPanel {

    private final JTabbedPane tabbedPane;
    private final Map<String, CodeEditor> openEditors = new HashMap<>();

    public EditorTabPane() {
        super(new BorderLayout());
        tabbedPane = new JTabbedPane();
        add(tabbedPane, BorderLayout.CENTER);
    }

    public CodeEditor openFile(File file, String content) {
        String path = file.getAbsolutePath();
        if (openEditors.containsKey(path)) {
            tabbedPane.setSelectedComponent(openEditors.get(path));
            return openEditors.get(path);
        }

        CodeEditor.LanguageMode mode = determineMode(file.getName());
        CodeEditor editor = new CodeEditor(mode);
        editor.setText(content);

        openEditors.put(path, editor);
        tabbedPane.addTab(file.getName(), editor);
        tabbedPane.setSelectedComponent(editor);
        return editor;
    }

    public void addTab(String title, CodeEditor editor) {
        tabbedPane.addTab(title, editor);
        tabbedPane.setSelectedComponent(editor);
    }

    public CodeEditor getCurrentEditor() {
        return (CodeEditor) tabbedPane.getSelectedComponent();
    }

    private CodeEditor.LanguageMode determineMode(String fileName) {
        String lower = fileName.toLowerCase();
        if (lower.endsWith(".pig")) {
            return CodeEditor.LanguageMode.PIG_LATIN;
        } else if (lower.endsWith(".y")) {
            return CodeEditor.LanguageMode.Y_PYTHON;
        } else if (lower.endsWith(".z")) {
            return CodeEditor.LanguageMode.ZETARIANO;
        }
        return CodeEditor.LanguageMode.PLAIN;
    }
}
