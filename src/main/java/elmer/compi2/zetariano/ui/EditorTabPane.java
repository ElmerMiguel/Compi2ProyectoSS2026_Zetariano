package elmer.compi2.zetariano.ui;

import javax.swing.*;
import javax.swing.event.ChangeListener;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.io.File;
import java.util.HashMap;
import java.util.Map;

/**
 * Gestor de pestañas de edición para múltiples archivos abiertos con opción de cierre
 * y seguimiento individual y desacoplado del archivo físico asociado a cada editor.
 */
public class EditorTabPane extends JPanel {

    private final JTabbedPane tabbedPane;
    private final Map<String, CodeEditor> openEditors = new HashMap<>();
    private final Map<CodeEditor, File> editorFiles = new HashMap<>();

    public EditorTabPane() {
        super(new BorderLayout());
        tabbedPane = new JTabbedPane();
        add(tabbedPane, BorderLayout.CENTER);
    }

    public CodeEditor openFile(File file, String content) {
        File normalized = file.toPath().toAbsolutePath().normalize().toFile();
        String path = normalized.getAbsolutePath();
        if (openEditors.containsKey(path)) {
            CodeEditor existing = openEditors.get(path);
            tabbedPane.setSelectedComponent(existing);
            return existing;
        }

        CodeEditor.LanguageMode mode = determineMode(normalized.getName());
        CodeEditor editor = new CodeEditor(mode);
        editor.setText(content);

        openEditors.put(path, editor);
        editorFiles.put(editor, normalized);

        tabbedPane.addTab(normalized.getName(), editor);

        int index = tabbedPane.indexOfComponent(editor);
        tabbedPane.setTabComponentAt(index, new ButtonTabComponent(normalized.getName(), editor));

        tabbedPane.setSelectedComponent(editor);
        return editor;
    }

    public void addTab(String title, CodeEditor editor) {
        tabbedPane.addTab(title, editor);
        editorFiles.put(editor, null);

        int index = tabbedPane.indexOfComponent(editor);
        tabbedPane.setTabComponentAt(index, new ButtonTabComponent(title, editor));

        tabbedPane.setSelectedComponent(editor);
    }

    public CodeEditor getCurrentEditor() {
        return (CodeEditor) tabbedPane.getSelectedComponent();
    }

    public File getCurrentFile() {
        CodeEditor current = getCurrentEditor();
        return (current != null) ? editorFiles.get(current) : null;
    }

    public File getFileForEditor(CodeEditor editor) {
        return (editor != null) ? editorFiles.get(editor) : null;
    }

    public void setFileForEditor(CodeEditor editor, File file) {
        if (editor == null) return;

        File oldFile = editorFiles.get(editor);
        if (oldFile != null) {
            openEditors.remove(oldFile.getAbsolutePath());
        }

        if (file != null) {
            File normalized = file.toPath().toAbsolutePath().normalize().toFile();
            editorFiles.put(editor, normalized);
            openEditors.put(normalized.getAbsolutePath(), editor);

            int index = tabbedPane.indexOfComponent(editor);
            if (index >= 0) {
                tabbedPane.setTitleAt(index, normalized.getName());
                Component tabComp = tabbedPane.getTabComponentAt(index);
                if (tabComp instanceof ButtonTabComponent btc) {
                    btc.setTitle(normalized.getName());
                }
            }
        } else {
            editorFiles.put(editor, null);
        }
    }

    public String getCurrentTitle() {
        int idx = tabbedPane.getSelectedIndex();
        if (idx >= 0) {
            return tabbedPane.getTitleAt(idx);
        }
        return "";
    }

    public int getTabCount() {
        return tabbedPane.getTabCount();
    }

    public void addChangeListener(ChangeListener listener) {
        tabbedPane.addChangeListener(listener);
    }

    public void closeEditor(CodeEditor editor) {
        if (editor == null) return;

        File file = editorFiles.remove(editor);
        if (file != null) {
            openEditors.remove(file.getAbsolutePath());
        }

        tabbedPane.remove(editor);
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
        private final JLabel label;

        public ButtonTabComponent(String title, CodeEditor editor) {
            super(new FlowLayout(FlowLayout.LEFT, 0, 0));
            setOpaque(false);

            label = new JLabel(title) {
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

        public void setTitle(String newTitle) {
            label.setText(newTitle);
        }
    }
}
