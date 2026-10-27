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
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import elmer.compi2.zetariano.CompilerService;
import elmer.compi2.zetariano.NativeCompilerService;
import elmer.compi2.zetariano.RarsExecutionService;

/**
 * Ventana Principal del Compilador Zetariano con arquitectura desacoplada y responsiva.
 */
public class MainWindow extends JFrame {

    private final FileExplorer fileExplorer;
    private final EditorTabPane editorTabPane;
    private final OutputPanel outputPanel;

    private final JButton compileBtn = new JButton("Compilar Proyecto (F5)");
    private final JButton executeRarsBtn = new JButton("Ejecutar en RARS (F7)");
    private final JButton executeBtn = new JButton("Ejecutar C (F6)");
    private final JLabel statusLabel = new JLabel("Listo");
    private final RarsExecutionService rarsExecutionService = new RarsExecutionService();
    private CompilerService.CompilationResult lastResult = null;

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

        JMenuItem itemNuevo = new JMenuItem("Nuevo Archivo...");
        itemNuevo.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_N, java.awt.event.InputEvent.CTRL_DOWN_MASK));
        itemNuevo.addActionListener(e -> createNewFile());
        menuArchivo.add(itemNuevo);

        JMenuItem itemAbrirArchivo = new JMenuItem("Abrir Archivo...");
        itemAbrirArchivo.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_O, java.awt.event.InputEvent.CTRL_DOWN_MASK));
        itemAbrirArchivo.addActionListener(e -> chooseFile());
        menuArchivo.add(itemAbrirArchivo);

        JMenuItem itemAbrir = new JMenuItem("Abrir Carpeta...");
        itemAbrir.addActionListener(e -> chooseDirectory());
        menuArchivo.add(itemAbrir);

        menuArchivo.addSeparator();

        JMenuItem itemGuardar = new JMenuItem("Guardar Archivo");
        itemGuardar.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_S, java.awt.event.InputEvent.CTRL_DOWN_MASK));
        itemGuardar.addActionListener(e -> saveActiveFile(false));
        menuArchivo.add(itemGuardar);

        JMenuItem itemGuardarComo = new JMenuItem("Guardar Como...");
        itemGuardarComo.addActionListener(e -> saveActiveFile(true));
        menuArchivo.add(itemGuardarComo);

        menuArchivo.addSeparator();

        JMenuItem itemSalir = new JMenuItem("Salir");
        itemSalir.addActionListener(e -> System.exit(0));
        menuArchivo.add(itemSalir);

        JMenu menuEditar = new JMenu("Editar");
        JMenuItem itemUndo = new JMenuItem("Deshacer");
        itemUndo.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_Z, java.awt.event.InputEvent.CTRL_DOWN_MASK));
        itemUndo.addActionListener(e -> {
            CodeEditor current = editorTabPane.getCurrentEditor();
            if (current != null) current.undo();
        });
        menuEditar.add(itemUndo);

        JMenuItem itemRedo = new JMenuItem("Rehacer");
        itemRedo.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_Y, java.awt.event.InputEvent.CTRL_DOWN_MASK));
        itemRedo.addActionListener(e -> {
            CodeEditor current = editorTabPane.getCurrentEditor();
            if (current != null) current.redo();
        });
        menuEditar.add(itemRedo);

        JMenu menuCompilar = new JMenu("Compilar");
        JMenuItem itemRun = new JMenuItem("Compilar Proyecto");
        itemRun.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_F5, 0));
        itemRun.addActionListener(e -> triggerCompilation());
        menuCompilar.add(itemRun);

        JMenuItem itemRars = new JMenuItem("Ejecutar en RARS (Terminal)");
        itemRars.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_F7, 0));
        itemRars.addActionListener(e -> triggerRarsExecution(false));
        menuCompilar.add(itemRars);

        JMenuItem itemRarsConsola = new JMenuItem("Ejecutar en RARS (Consola interna)");
        itemRarsConsola.addActionListener(e -> triggerRarsConsoleExecution());
        menuCompilar.add(itemRarsConsola);

        JMenuItem itemRarsGui = new JMenuItem("Abrir Simulador RARS (GUI)");
        itemRarsGui.addActionListener(e -> triggerRarsExecution(true));
        menuCompilar.add(itemRarsGui);

        menuCompilar.addSeparator();

        JMenuItem itemExec = new JMenuItem("Ejecutar Programa C (Terminal)");
        itemExec.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_F6, 0));
        itemExec.addActionListener(e -> triggerExecution());
        menuCompilar.add(itemExec);

        bar.add(menuArchivo);
        bar.add(menuEditar);
        bar.add(menuCompilar);
        return bar;
    }

    private JToolBar buildToolBar() {
        JToolBar toolBar = new JToolBar();
        toolBar.setFloatable(false);

        JButton newBtn = new JButton("Nuevo");
        newBtn.addActionListener(e -> createNewFile());
        toolBar.add(newBtn);

        JButton openFileBtn = new JButton("Abrir Archivo");
        openFileBtn.addActionListener(e -> chooseFile());
        toolBar.add(openFileBtn);

        JButton openDirBtn = new JButton("Abrir Carpeta");
        openDirBtn.addActionListener(e -> chooseDirectory());
        toolBar.add(openDirBtn);

        JButton saveBtn = new JButton("Guardar");
        saveBtn.addActionListener(e -> saveActiveFile(false));
        toolBar.add(saveBtn);

        toolBar.addSeparator();

        compileBtn.addActionListener(e -> triggerCompilation());
        toolBar.add(compileBtn);

        executeRarsBtn.addActionListener(e -> triggerRarsExecution(false));
        toolBar.add(executeRarsBtn);

        executeBtn.addActionListener(e -> triggerExecution());
        toolBar.add(executeBtn);

        return toolBar;
    }

    private File activeFile = null;
    private final CompilerService compilerService = new CompilerService();

    private void updateActiveFileInfo() {
        File current = editorTabPane.getCurrentFile();
        if (current != null) {
            activeFile = current;
            statusLabel.setText("Archivo: " + current.getAbsolutePath());
            setTitle("Compilador Zetariano - " + current.getName());
        } else {
            CodeEditor editor = editorTabPane.getCurrentEditor();
            if (editor != null) {
                String title = editorTabPane.getCurrentTitle();
                statusLabel.setText("Archivo sin guardar (" + title + ")");
                setTitle("Compilador Zetariano - " + title);
            } else {
                activeFile = null;
                statusLabel.setText("Listo");
                setTitle("Compilador Zetariano");
            }
        }
    }

    private void bindEvents() {
        fileExplorer.setOnFileDoubleClicked(file -> {
            try {
                String content = Files.readString(file.toPath());
                editorTabPane.openFile(file, content);
                updateActiveFileInfo();
            } catch (IOException e) {
                JOptionPane.showMessageDialog(this, "Error al abrir archivo: " + e.getMessage());
            }
        });

        // Sincronizar el archivo activo cada vez que el usuario cambia de pestaña
        editorTabPane.addChangeListener(e -> updateActiveFileInfo());
    }

    private void chooseFile() {
        File currentFile = editorTabPane.getCurrentFile();
        File defaultDir = (currentFile != null && currentFile.getParentFile() != null)
                ? currentFile.getParentFile()
                : (activeFile != null && activeFile.getParentFile() != null ? activeFile.getParentFile() : new File("."));

        JFileChooser chooser = new JFileChooser(defaultDir);
        chooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
        if (chooser.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
            File selected = chooser.getSelectedFile();
            try {
                String content = Files.readString(selected.toPath());
                editorTabPane.openFile(selected, content);
                updateActiveFileInfo();
            } catch (IOException e) {
                JOptionPane.showMessageDialog(this, "Error al abrir archivo: " + e.getMessage());
            }
        }
    }

    private void createNewFile() {
        String name = JOptionPane.showInputDialog(this,
                "Nombre del nuevo archivo (ej. Programa.pig, Modulo.y, Clase.z):",
                "Nuevo Archivo", JOptionPane.PLAIN_MESSAGE);
        if (name == null || name.trim().isEmpty()) {
            return;
        }
        name = name.trim();
        CodeEditor.LanguageMode mode = CodeEditor.LanguageMode.PLAIN;
        if (name.endsWith(".pig")) mode = CodeEditor.LanguageMode.PIG_LATIN;
        else if (name.endsWith(".y")) mode = CodeEditor.LanguageMode.Y_PYTHON;
        else if (name.endsWith(".z")) mode = CodeEditor.LanguageMode.ZETARIANO;

        CodeEditor newEditor = new CodeEditor(mode);
        newEditor.setText("");
        editorTabPane.addTab(name, newEditor);
        updateActiveFileInfo();
    }

    private void saveActiveFile(boolean saveAs) {
        CodeEditor currentEditor = editorTabPane.getCurrentEditor();
        if (currentEditor == null) {
            JOptionPane.showMessageDialog(this, "No hay ningun editor abierto para guardar.");
            return;
        }

        // Siempre usar el archivo asociado al editor de la pestaña actual
        File target = editorTabPane.getCurrentFile();
        if (saveAs || target == null) {
            File defaultDir = (target != null && target.getParentFile() != null)
                    ? target.getParentFile()
                    : (activeFile != null && activeFile.getParentFile() != null ? activeFile.getParentFile() : new File("."));

            JFileChooser chooser = new JFileChooser(defaultDir);
            chooser.setDialogTitle("Guardar Archivo Como...");
            if (target != null) {
                chooser.setSelectedFile(target);
            }
            if (chooser.showSaveDialog(this) == JFileChooser.APPROVE_OPTION) {
                target = chooser.getSelectedFile();
            } else {
                return;
            }
        }

        try {
            Files.writeString(target.toPath(), currentEditor.getText(), StandardCharsets.UTF_8);
            editorTabPane.setFileForEditor(currentEditor, target);
            updateActiveFileInfo();
            JOptionPane.showMessageDialog(this, "Archivo guardado exitosamente: " + target.getName(),
                    "Guardado", JOptionPane.INFORMATION_MESSAGE);
        } catch (IOException e) {
            JOptionPane.showMessageDialog(this, "Error al guardar archivo: " + e.getMessage(),
                    "Error", JOptionPane.ERROR_MESSAGE);
        }
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
                updateActiveFileInfo();
                return;
            } catch (IOException ignored) {}
        }

        // Tab de bienvenida por defecto
        CodeEditor defaultEditor = new CodeEditor(CodeEditor.LanguageMode.PIG_LATIN);
        defaultEditor.setText("## Compilador Zetariano (Pig Latin, Y?, Zetariano) ##\nMAIOR>\n    >> \"Listo para compilar!\";\nFINIS;\n");
        editorTabPane.addTab("Bienvenido.pig", defaultEditor);
        updateActiveFileInfo();
    }

    private void triggerCompilation() {
        CodeEditor currentEditor = editorTabPane.getCurrentEditor();
        if (currentEditor == null) {
            JOptionPane.showMessageDialog(this, "No hay ningun editor abierto para compilar.");
            return;
        }

        String sourceCode = currentEditor.getText();
        File currentFile = editorTabPane.getCurrentFile();
        Path baseDir;
        if (currentFile != null && currentFile.getParentFile() != null) {
            baseDir = currentFile.getParentFile().toPath();
        } else if (activeFile != null && activeFile.getParentFile() != null) {
            baseDir = activeFile.getParentFile().toPath();
        } else {
            baseDir = Path.of("docs/Pruebas");
        }
        baseDir = baseDir.toAbsolutePath().normalize();

        statusLabel.setText("Compilando...");
        outputPanel.clearAll();

        lastResult = compilerService.compilePigSource(sourceCode, baseDir);

        outputPanel.setConsoleOutput(lastResult.getConsoleLog());
        outputPanel.setC3DOutput(lastResult.getC3dText());
        outputPanel.setRiscVOutput(lastResult.getCodigoRiscV());
        outputPanel.setCCodeOutput(lastResult.getGeneratedCCode());
        outputPanel.setErrors(lastResult.getErrors());

        if (lastResult.isSuccess()) {
            statusLabel.setText("Compilacion finalizada exitosamente.");
            StringBuilder msg = new StringBuilder();
            msg.append("Compilacion finalizada con exito.\n\n");
            msg.append("1. Cuartetos C3D generados en:\n   ").append(baseDir.resolve("salida_c3d.txt")).append("\n\n");
            msg.append("2. Ensamblador RISC-V generado en:\n   ").append(baseDir.resolve("salida_riscv.s")).append("\n");
            msg.append("   -> Puedes simularlo con el boton 'Ejecutar en RARS (F7)'.\n\n");
            msg.append("3. Codigo C unificado generado en:\n   ").append(baseDir.resolve("salida_unificada.c")).append("\n");
            if (lastResult.getNativeBinaryPath() != null) {
                msg.append("   -> Binario nativo (GCC): ").append(lastResult.getNativeBinaryPath().getFileName()).append("\n");
            }
            JOptionPane.showMessageDialog(this, msg.toString(), "Compilacion Exitosa", JOptionPane.INFORMATION_MESSAGE);
        } else {
            statusLabel.setText("La compilacion finalizo con errores.");
            JOptionPane.showMessageDialog(this,
                    "Se encontraron errores durante la compilacion.\nRevisa el panel de Errores y la Consola.",
                    "Errores de Compilacion", JOptionPane.WARNING_MESSAGE);
        }
    }

    private void triggerRarsExecution(boolean abrirGui) {
        if (lastResult == null || !lastResult.isSuccess() || lastResult.getArchivoRiscV() == null) {
            triggerCompilation();
        }

        if (lastResult != null && lastResult.isSuccess() && lastResult.getArchivoRiscV() != null) {
            Path asm = lastResult.getArchivoRiscV();
            if (!Files.exists(asm)) {
                JOptionPane.showMessageDialog(this,
                        "El archivo ensamblador RISC-V no existe: " + asm.toAbsolutePath(),
                        "Archivo no encontrado", JOptionPane.ERROR_MESSAGE);
                return;
            }

            if (abrirGui) {
                statusLabel.setText("Lanzando interfaz grafica de RARS 1.6...");
                boolean lanzada = rarsExecutionService.abrirGui(asm);
                if (!lanzada) {
                    JOptionPane.showMessageDialog(this,
                            "No se pudo iniciar la interfaz grafica de RARS 1.6.",
                            "Error RARS", JOptionPane.ERROR_MESSAGE);
                }
                return;
            }

            statusLabel.setText("Lanzando simulador RARS en terminal: " + asm.getFileName());
            boolean launched = rarsExecutionService.launchInTerminal(asm);
            if (!launched) {
                triggerRarsConsoleExecution();
            }
        }
    }

    private void triggerRarsConsoleExecution() {
        if (lastResult == null || !lastResult.isSuccess() || lastResult.getArchivoRiscV() == null) {
            triggerCompilation();
        }

        if (lastResult != null && lastResult.isSuccess() && lastResult.getArchivoRiscV() != null) {
            Path asm = lastResult.getArchivoRiscV();
            if (!Files.exists(asm)) {
                JOptionPane.showMessageDialog(this,
                        "El archivo ensamblador RISC-V no existe: " + asm.toAbsolutePath(),
                        "Archivo no encontrado", JOptionPane.ERROR_MESSAGE);
                return;
            }

            statusLabel.setText("Ejecutando en simulador RARS 1.6...");
            outputPanel.selectTabByTitle("Consola");
            outputPanel.appendConsole("\n========================================\nINICIANDO SIMULACION RISC-V EN RARS 1.6\n========================================\n");

            new javax.swing.SwingWorker<RarsExecutionService.RarsExecutionResult, Void>() {
                @Override
                protected RarsExecutionService.RarsExecutionResult doInBackground() {
                    return rarsExecutionService.ejecutar(asm, 15, null);
                }

                @Override
                protected void done() {
                    try {
                        RarsExecutionService.RarsExecutionResult res = get();
                        outputPanel.appendConsole(res.getOutput());
                        outputPanel.appendConsole("\n--- Simulacion finalizada con codigo de salida: "
                                + res.getExitCode() + " ---\n");
                        statusLabel.setText("Simulacion RARS finalizada (codigo " + res.getExitCode() + ").");
                    } catch (Exception ex) {
                        outputPanel.appendConsole("\n[ERROR RARS]: " + ex.getMessage() + "\n");
                        statusLabel.setText("Error en simulacion RARS.");
                    }
                }
            }.execute();
        }
    }

    private void triggerExecution() {
        if (lastResult == null || !lastResult.isSuccess() || lastResult.getNativeBinaryPath() == null) {
            triggerCompilation();
        }

        if (lastResult != null && lastResult.isSuccess() && lastResult.getNativeBinaryPath() != null) {
            Path bin = lastResult.getNativeBinaryPath();
            if (Files.exists(bin)) {
                statusLabel.setText("Lanzando programa en terminal: " + bin.getFileName());
                boolean launched = NativeCompilerService.launchInTerminal(bin);
                if (!launched) {
                    JOptionPane.showMessageDialog(this,
                            "No se pudo abrir una terminal grafica para ejecutar el binario automaticamente.\n" +
                            "Puedes ejecutarlo directamente desde tu consola con:\n" + bin.toAbsolutePath(),
                            "Aviso de Terminal", JOptionPane.WARNING_MESSAGE);
                }
            } else {
                JOptionPane.showMessageDialog(this,
                        "El binario ejecutable no existe: " + bin.toAbsolutePath(),
                        "Binario no encontrado", JOptionPane.ERROR_MESSAGE);
            }
        }
    }
}
