package elmer.compi2.zetariano.ui;

import elmer.compi2.zetariano.ui.highlight.MonokaiPalette;

import javax.swing.JPanel;
import javax.swing.SwingUtilities;
import javax.swing.event.CaretEvent;
import javax.swing.event.CaretListener;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.text.BadLocationException;
import javax.swing.text.Document;
import javax.swing.text.Element;
import javax.swing.text.JTextComponent;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.RenderingHints;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;
import java.awt.geom.Point2D;
import java.awt.geom.Rectangle2D;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

/**
 * Componente de canaleta (Gutter) para numeracion de lineas estilo IDE con paleta Monokai.
 * Se integra en el rowHeaderView de un JScrollPane sobre cualquier JTextComponent.
 */
public class LineNumberGutter extends JPanel {

    private static final int PADDING_LEFT = 8;
    private static final int PADDING_RIGHT = 8;
    private static final int MINIMUM_DIGITS = 3;

    private static final Color GUTTER_BACKGROUND = new Color(30, 31, 26);
    private static final Color GUTTER_BORDER = new Color(55, 56, 48);
    private static final Color CURRENT_LINE_BG = new Color(46, 48, 39);

    private final JTextComponent textComponent;
    private int lastDigits = 0;
    private int lastCaretLine = -1;

    private final DocumentListener documentListener = new DocumentListener() {
        @Override
        public void insertUpdate(DocumentEvent e) {
            handleDocumentChange();
        }

        @Override
        public void removeUpdate(DocumentEvent e) {
            handleDocumentChange();
        }

        @Override
        public void changedUpdate(DocumentEvent e) {
            handleDocumentChange();
        }
    };

    public LineNumberGutter(JTextComponent textComponent) {
        this.textComponent = textComponent;
        setBackground(GUTTER_BACKGROUND);
        setFont(textComponent.getFont());

        initListeners();
        updateSize();
    }

    private void initListeners() {
        // Observar cambios en el documento
        textComponent.getDocument().addDocumentListener(documentListener);

        // Observar cambios de propiedad (fuente o documento reemplazado)
        textComponent.addPropertyChangeListener(evt -> {
            if ("document".equals(evt.getPropertyName())) {
                if (evt.getOldValue() instanceof Document oldDoc) {
                    oldDoc.removeDocumentListener(documentListener);
                }
                if (evt.getNewValue() instanceof Document newDoc) {
                    newDoc.addDocumentListener(documentListener);
                }
                handleDocumentChange();
            } else if ("font".equals(evt.getPropertyName())) {
                setFont(textComponent.getFont());
                handleDocumentChange();
            }
        });

        // Observar cambios en el cursor para resaltar linea activa
        textComponent.addCaretListener(e -> {
            Element root = textComponent.getDocument().getDefaultRootElement();
            int currentLine = root.getElementIndex(e.getDot());
            if (currentLine != lastCaretLine) {
                lastCaretLine = currentLine;
                repaint();
            }
        });

        // Observar redimensionamiento del editor de texto
        textComponent.addComponentListener(new ComponentAdapter() {
            @Override
            public void componentResized(ComponentEvent e) {
                revalidate();
                repaint();
            }
        });

        // Interaccion con el raton: clic o arrastre selecciona la linea
        addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                selectLineAt(e.getPoint());
            }
        });

        addMouseMotionListener(new MouseMotionAdapter() {
            @Override
            public void mouseDragged(MouseEvent e) {
                selectLineAt(e.getPoint());
            }
        });
    }

    private void selectLineAt(Point p) {
        int offset = textComponent.viewToModel2D(new Point2D.Float(0, p.y));
        if (offset >= 0) {
            Element root = textComponent.getDocument().getDefaultRootElement();
            int line = root.getElementIndex(offset);
            Element lineElem = root.getElement(line);
            textComponent.setCaretPosition(lineElem.getStartOffset());
            textComponent.moveCaretPosition(Math.min(textComponent.getDocument().getLength(), lineElem.getEndOffset()));
            textComponent.requestFocusInWindow();
        }
    }

    private void handleDocumentChange() {
        SwingUtilities.invokeLater(() -> {
            updateSize();
            repaint();
        });
    }

    private int calculateWidth() {
        Element root = textComponent.getDocument().getDefaultRootElement();
        int lines = Math.max(1, root.getElementCount());
        int digits = Math.max(MINIMUM_DIGITS, String.valueOf(lines).length());
        Font font = getFont();
        if (font == null) {
            font = textComponent.getFont();
        }
        FontMetrics fm = getFontMetrics(font);
        return digits * fm.charWidth('9') + PADDING_LEFT + PADDING_RIGHT;
    }

    private void updateSize() {
        int width = calculateWidth();
        int height = Math.max(textComponent.getHeight(), 100);
        Dimension preferred = new Dimension(width, height);
        setPreferredSize(preferred);
        revalidate();
    }

    @Override
    public Dimension getPreferredSize() {
        int width = calculateWidth();
        int height = Math.max(textComponent.getHeight(), 100);
        return new Dimension(width, height);
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);

        Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

        // Fondo de la canaleta
        g2.setColor(GUTTER_BACKGROUND);
        g2.fillRect(0, 0, getWidth(), getHeight());

        // Linea vertical divisoria a la derecha
        g2.setColor(GUTTER_BORDER);
        g2.drawLine(getWidth() - 1, 0, getWidth() - 1, getHeight());

        Document doc = textComponent.getDocument();
        Element root = doc.getDefaultRootElement();
        int totalLines = root.getElementCount();
        if (totalLines == 0) {
            return;
        }

        Font normalFont = getFont();
        if (normalFont == null) {
            normalFont = textComponent.getFont();
        }
        Font boldFont = normalFont.deriveFont(Font.BOLD);
        FontMetrics fm = g2.getFontMetrics(normalFont);
        int fontAscent = fm.getAscent();

        Rectangle clip = g2.getClipBounds();
        if (clip == null) {
            clip = new Rectangle(0, 0, getWidth(), getHeight());
        }

        int currentCaretPos = textComponent.getCaretPosition();
        int activeLine = root.getElementIndex(currentCaretPos);

        // Identificar rango visible de lineas para rendimiento eficiente
        int startOffset = textComponent.viewToModel2D(new Point2D.Float(0, Math.max(0, clip.y)));
        int endOffset = textComponent.viewToModel2D(new Point2D.Float(0, Math.min(textComponent.getHeight(), clip.y + clip.height)));

        int startLine = (startOffset >= 0) ? root.getElementIndex(startOffset) : 0;
        int endLine = (endOffset >= 0) ? root.getElementIndex(endOffset) : totalLines - 1;

        startLine = Math.max(0, startLine);
        endLine = Math.min(totalLines - 1, endLine + 1);

        for (int line = startLine; line <= endLine; line++) {
            Element lineElem = root.getElement(line);
            int startPos = lineElem.getStartOffset();

            Rectangle2D rect = null;
            try {
                rect = textComponent.modelToView2D(startPos);
            } catch (BadLocationException ignored) {
            }

            int y = (rect != null) ? (int) rect.getY() : (textComponent.getInsets().top + line * fm.getHeight());
            int lineHeight = (rect != null) ? (int) rect.getHeight() : fm.getHeight();

            boolean isActive = (line == activeLine);

            if (isActive) {
                // Resaltar fondo de la linea activa en el gutter
                g2.setColor(CURRENT_LINE_BG);
                g2.fillRect(0, y, getWidth() - 1, lineHeight);

                g2.setColor(MonokaiPalette.FOREGROUND);
                g2.setFont(boldFont);
            } else {
                g2.setColor(MonokaiPalette.COMMENT);
                g2.setFont(normalFont);
            }

            String lineNumberStr = String.valueOf(line + 1);
            int strWidth = fm.stringWidth(lineNumberStr);
            int textX = getWidth() - PADDING_RIGHT - strWidth;
            int textY = y + fontAscent;

            g2.drawString(lineNumberStr, textX, textY);
        }
    }
}
