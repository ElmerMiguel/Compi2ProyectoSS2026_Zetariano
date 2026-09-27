package elmer.compi2.zetariano.ui;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.io.File;
import java.util.HashMap;
import java.util.Map;

/**
 * Gestor de pestañas de edición para múltiples archivos abiertos con opción de cierre.
 */
public class EditorTabPane extends JPanel {

    private final JTabbedPane tabbedPane;
    private final Map<String, CodeEditor> openEditors = new HashMap<>();
    private final Map<CodeEditor, String> editorPaths = new HashMap<>();

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
        editorPaths.put(editor, path);

        tabbedPane.addTab(file.getName(), editor);
        
        int index = tabbedPane.indexOfComponent(editor);
        tabbedPane.setTabComponentAt(index, new ButtonTabComponent(file.getName(), editor));

        tabbedPane.setSelectedComponent(editor);
        return editor;
    }

    public void addTab(String title, CodeEditor editor) {
        tabbedPane.addTab(title, editor);
        
        int index = tabbedPane.indexOfComponent(editor);
        tabbedPane.setTabComponentAt(index, new ButtonTabComponent(title, editor));

        tabbedPane.setSelectedComponent(editor);
    }

    public CodeEditor getCurrentEditor() {
        return (CodeEditor) tabbedPane.getSelectedComponent();
    }

  
    public void closeEditor(CodeEditor editor) {
        if (editor == null) return;
        
        tabbedPane.remove(editor);
        
        // Limpiar de los mapas
        String path = editorPaths.remove(editor);
        if (path != null) {
            openEditors.remove(path);
        }
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

    private class ButtonTabComponent extends JPanel {
        public ButtonTabComponent(String title, CodeEditor editor) {
            super(new FlowLayout(FlowLayout.LEFT, 0, 0));
            setOpaque(false);

            JLabel label = new JLabel(title) {
                @Override
                public Dimension getPreferredSize() {
                    Dimension d = super.getPreferredSize();
                    return new Dimension(Math.min(d.width, 120), d.height);
                }
            };
            label.setBorder(BorderFactory.createEmptyBorder(0, 0, 0, 5));
            add(label);

            JButton closeButton = new JButton("×");
            closeButton.setFont(new Font("Arial", Font.BOLD, 14));
            closeButton.setMargin(new Insets(0, 2, 0, 2));
            closeButton.setFocusable(false);
            closeButton.setBorder(BorderFactory.createEmptyBorder());
            closeButton.setContentAreaFilled(false);
            closeButton.setRolloverEnabled(true);

            closeButton.addActionListener((ActionEvent e) -> {
                closeEditor(editor);
            });

            add(closeButton);
        }
    }
}