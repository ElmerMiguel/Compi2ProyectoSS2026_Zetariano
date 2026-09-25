package elmer.compi2.zetariano.ui;

import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTree;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeModel;
import java.awt.BorderLayout;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.Comparator;
import java.util.function.Consumer;

/**
 * Panel con JTree para exploracion de archivos y carpetas del proyecto.
 */
public class FileExplorer extends JPanel {

    private final JTree fileTree;
    private final DefaultMutableTreeNode rootNode;
    private final DefaultTreeModel treeModel;
    private Consumer<File> onFileDoubleClicked;

    public FileExplorer() {
        super(new BorderLayout());

        rootNode = new DefaultMutableTreeNode("Proyecto");
        treeModel = new DefaultTreeModel(rootNode);
        fileTree = new JTree(treeModel);

        fileTree.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                if (e.getClickCount() == 2) {
                    DefaultMutableTreeNode selected = (DefaultMutableTreeNode) fileTree.getLastSelectedPathComponent();
                    if (selected != null && selected.getUserObject() instanceof FileNode fileNode) {
                        if (!fileNode.file().isDirectory() && onFileDoubleClicked != null) {
                            onFileDoubleClicked.accept(fileNode.file());
                        }
                    }
                }
            }
        });

        add(new JScrollPane(fileTree), BorderLayout.CENTER);
    }

    public record FileNode(File file) {
        @Override
        public String toString() {
            return file.getName().isEmpty() ? file.getPath() : file.getName();
        }
    }

    public void loadDirectory(Path dirPath) {
        File dir = dirPath.toFile();
        if (!dir.exists() || !dir.isDirectory()) {
            return;
        }

        rootNode.removeAllChildren();
        rootNode.setUserObject(new FileNode(dir));
        populateTree(rootNode, dir);
        treeModel.reload();
        fileTree.expandRow(0);
    }

    private void populateTree(DefaultMutableTreeNode parentNode, File parentDir) {
        File[] files = parentDir.listFiles();
        if (files == null) return;

        Arrays.sort(files, Comparator.comparing(File::isFile).thenComparing(File::getName));

        for (File f : files) {
            if (f.getName().startsWith(".") || f.getName().equals("target")) {
                continue;
            }
            DefaultMutableTreeNode childNode = new DefaultMutableTreeNode(new FileNode(f));
            parentNode.add(childNode);
            if (f.isDirectory()) {
                populateTree(childNode, f);
            }
        }
    }

    public void setOnFileDoubleClicked(Consumer<File> onFileDoubleClicked) {
        this.onFileDoubleClicked = onFileDoubleClicked;
    }
}
