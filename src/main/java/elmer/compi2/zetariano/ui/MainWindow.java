package elmer.compi2.zetariano.ui;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JSplitPane;
import javax.swing.JToolBar;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import elmer.compi2.zetariano.CompilerService;

/**
 * Ventana Principal del Compilador Zetariano con arquitectura desacoplada y responsiva.
 */
public class MainWindow extends JFrame {

    private final FileExplorer fileExplorer;
    private final EditorTabPane editorTabPane;
    private final OutputPanel outputPanel;

    private final JButton compileBtn = new JButton("Compilar Proyecto");
    private final JLabel statusLabel = new JLabel("Listo");

    public MainWindow() {
        super("Compilador Zetariano - Contacto Extraterrestre");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(1400, 850);
        setMinimumSize(new Dimension(960, 540));
        setLocationRelativeTo(null);
        setLayout(new BorderLayout());

        fileExplorer = new FileExplorer();
        editorTabPane = new EditorTabPane();
        outputPanel = new OutputPanel();

        configureUi();
        bindEvents();
        loadWorkspace();
    }

    private void configureUi() {
        setJMenuBar(buildMenuBar());
        add(buildToolBar(), BorderLayout.NORTH);

        // Editor y Output divididos verticalmente
        JSplitPane centerSplit = new JSplitPane(
                JSplitPane.VERTICAL_SPLIT,
                editorTabPane,
                outputPanel
        );
        centerSplit.setResizeWeight(0.60);
        centerSplit.setOneTouchExpandable(true);

        // Explorador de archivos a la izquierda
        JSplitPane mainSplit = new JSplitPane(
                JSplitPane.HORIZONTAL_SPLIT,
                fileExplorer,
                centerSplit
        );
        mainSplit.setResizeWeight(0.18);
        mainSplit.setOneTouchExpandable(true);

        add(mainSplit, BorderLayout.CENTER);

        JPanel footer = new JPanel(new BorderLayout());
        footer.add(statusLabel, BorderLayout.WEST);
        add(footer, BorderLayout.SOUTH);
    }

    private JMenuBar buildMenuBar() {
        JMenuBar bar = new JMenuBar();
        JMenu menuArchivo = new JMenu("Archivo");
        JMenuItem itemAbrir = new JMenuItem("Abrir Carpeta...");
        itemAbrir.addActionListener(e -> chooseDirectory());
        menuArchivo.add(itemAbrir);

        JMenu menuCompilar = new JMenu("Compilar");
        JMenuItem itemRun = new JMenuItem("Ejecutar Compilacion");
        itemRun.addActionListener(e -> triggerCompilation());
        menuCompilar.add(itemRun);

        bar.add(menuArchivo);
        bar.add(menuCompilar);
        return bar;
    }

    private JToolBar buildToolBar() {
        JToolBar toolBar = new JToolBar();
        toolBar.setFloatable(false);

        JButton openDirBtn = new JButton("Abrir Carpeta");
        openDirBtn.addActionListener(e -> chooseDirectory());
        toolBar.add(openDirBtn);

        compileBtn.addActionListener(e -> triggerCompilation());
        toolBar.add(compileBtn);

        return toolBar;
    }

    private File activeFile = null;
    private final CompilerService compilerService = new CompilerService();

    private void bindEvents() {
        fileExplorer.setOnFileDoubleClicked(file -> {
            try {
                String content = Files.readString(file.toPath());
                editorTabPane.openFile(file, content);
                activeFile = file;
                statusLabel.setText("Abierto: " + file.getName());
            } catch (IOException e) {
                JOptionPane.showMessageDialog(this, "Error al abrir archivo: " + e.getMessage());
            }
        });
    }

    private void chooseDirectory() {
        JFileChooser chooser = new JFileChooser(new File("."));
        chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
        if (chooser.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
            File selected = chooser.getSelectedFile();
            fileExplorer.loadDirectory(selected.toPath());
        }
    }

    private void loadWorkspace() {
        File current = new File(".");
        fileExplorer.loadDirectory(current.toPath());

        // Cargar Principal.pig si existe como ejemplo inicial
        File demo = new File("docs/Pruebas/Principal.pig");
        if (demo.exists()) {
            try {
                String content = Files.readString(demo.toPath());
                editorTabPane.openFile(demo, content);
                activeFile = demo;
                statusLabel.setText("Abierto: Principal.pig");
                return;
            } catch (IOException ignored) {}
        }

        // Tab de bienvenida por defecto
        CodeEditor defaultEditor = new CodeEditor(CodeEditor.LanguageMode.PIG_LATIN);
        defaultEditor.setText("## Compilador Zetariano (Pig Latin, Y?, Zetariano) ##\nMAIOR>\n    >> \"Listo para compilar!\";\nFINIS;\n");
        editorTabPane.addTab("Bienvenido.pig", defaultEditor);
    }

    private void triggerCompilation() {
        CodeEditor currentEditor = editorTabPane.getCurrentEditor();
        if (currentEditor == null) {
            JOptionPane.showMessageDialog(this, "No hay ningun editor abierto para compilar.");
            return;
        }

        String sourceCode = currentEditor.getText();
        Path baseDir = (activeFile != null && activeFile.getParentFile() != null)
                ? activeFile.getParentFile().toPath()
                : Path.of("docs/Pruebas");

        statusLabel.setText("Compilando...");
        outputPanel.clearAll();

        CompilerService.CompilationResult result = compilerService.compilePigSource(sourceCode, baseDir);

        outputPanel.setConsoleOutput(result.getConsoleLog());
        outputPanel.setC3DOutput(result.getC3dText());
        outputPanel.setCCodeOutput(result.getGeneratedCCode());
        outputPanel.setErrors(result.getErrors());

        if (result.isSuccess()) {
            statusLabel.setText("Compilacion finalizada exitosamente.");
            JOptionPane.showMessageDialog(this,
                    "Compilacion finalizada con exito.\nCodigo C unificado generado en: " + baseDir.resolve("salida_unificada.c"),
                    "Compilacion Exitosa", JOptionPane.INFORMATION_MESSAGE);
        } else {
            statusLabel.setText("La compilacion finalizo con errores.");
            JOptionPane.showMessageDialog(this,
                    "Se encontraron errores durante la compilacion.\nRevisa el panel de Errores y la Consola.",
                    "Errores de Compilacion", JOptionPane.WARNING_MESSAGE);
        }
    }
}
