package elmer.compi2.zetariano.ui;

import elmer.compi2.zetariano.diagnostic.ErrorReport;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.ListSelectionModel;
import javax.swing.table.DefaultTableModel;
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.Font;
import java.util.List;

/**
 * Panel de resultados: Consola, Cuadruplos C3D, Codigo C, Tabla de Errores y Simbolos.
 */
public class OutputPanel extends JPanel {

    private final JTabbedPane tabbedPane;

    private final JTextArea consoleArea;
    private final JTextArea c3dArea;
    private final JTextArea cCodeArea;

    private final DefaultTableModel errorsModel;
    private final JTable errorsTable;

    public OutputPanel() {
        super(new BorderLayout());

        tabbedPane = new JTabbedPane();

        // 1. Consola de salida
        consoleArea = createTextArea();
        tabbedPane.addTab("Consola", new JScrollPane(consoleArea));

        // 2. Cuadruplos C3D
        c3dArea = createTextArea();
        tabbedPane.addTab("Cuadruplos (C3D)", new JScrollPane(c3dArea));

        // 3. Codigo C generado
        cCodeArea = createTextArea();
        tabbedPane.addTab("Codigo C", new JScrollPane(cCodeArea));

        // 4. Tabla de Errores
        errorsModel = new DefaultTableModel(new Object[]{"Fase", "Linea", "Columna", "Mensaje"}, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        errorsTable = new JTable(errorsModel);
        errorsTable.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        errorsTable.setFont(new Font(Font.SANS_SERIF, Font.PLAIN, 13));

        JPanel errorsWrapper = new JPanel(new BorderLayout());
        JPanel errorTools = new JPanel(new FlowLayout(FlowLayout.RIGHT, 4, 2));
        JButton openErrorsBtn = new JButton("Abrir en ventana");
        openErrorsBtn.addActionListener(e -> openErrorsWindow());
        errorTools.add(openErrorsBtn);
        errorsWrapper.add(errorTools, BorderLayout.NORTH);
        errorsWrapper.add(new JScrollPane(errorsTable), BorderLayout.CENTER);

        tabbedPane.addTab("Errores", errorsWrapper);

        add(tabbedPane, BorderLayout.CENTER);
    }

    private JTextArea createTextArea() {
        JTextArea area = new JTextArea();
        area.setEditable(false);
        area.setFont(new Font(Font.MONOSPACED, Font.PLAIN, 13));
        return area;
    }

    public void setConsoleOutput(String text) {
        consoleArea.setText(text == null ? "" : text);
    }

    public void setC3DOutput(String text) {
        c3dArea.setText(text == null ? "" : text);
    }

    public void setCCodeOutput(String text) {
        cCodeArea.setText(text == null ? "" : text);
    }

    public void setErrors(List<ErrorReport> errors) {
        errorsModel.setRowCount(0);
        if (errors == null) return;
        for (ErrorReport err : errors) {
            errorsModel.addRow(new Object[]{
                    err.getKind(),
                    err.getLine(),
                    err.getColumn(),
                    err.getMessage()
            });
        }
    }

    public void clearAll() {
        consoleArea.setText("");
        c3dArea.setText("");
        cCodeArea.setText("");
        errorsModel.setRowCount(0);
    }

    private void openErrorsWindow() {
        JFrame frame = new JFrame("Listado de Errores del Compilador");
        JTable popupTable = new JTable(errorsModel);
        frame.add(new JScrollPane(popupTable));
        frame.setSize(850, 450);
        frame.setLocationRelativeTo(this);
        frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        frame.setVisible(true);
    }
}
