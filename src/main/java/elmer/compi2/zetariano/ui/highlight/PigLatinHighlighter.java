package elmer.compi2.zetariano.ui.highlight;

import javax.swing.JTextPane;
import javax.swing.text.StyledDocument;
import java.util.regex.Pattern;

/**
 * Resaltador de sintaxis manual para Pig Latin con paleta Monokai.
 */
public class PigLatinHighlighter extends SyntaxHighlighter {

    private static final Pattern PATTERN_KEYWORDS = Pattern.compile(
            "\\b(?:"
                    + "import|VARIABILES|MAIOR|FINIS|finis|"
                    + "esto|series|novus|si|aliter|dum|facere|per|perge|interrumpe"
                    + ")\\b"
    );

    private static final Pattern PATTERN_BOOLEANS = Pattern.compile(
            "\\b(?:verum|falsus)\\b"
    );

    private static final Pattern PATTERN_TYPES = Pattern.compile(
            "\\b(?:numerus|textum|decimalis|littera)\\b"
    );

    private static final Pattern PATTERN_OPERATORS = Pattern.compile(
            ">>|<<|==|!=|<=|>=|&&|\\|\\||\\+\\+|--|[+\\-*/=<>!]"
    );

    private static final Pattern PATTERN_NUMBERS = Pattern.compile(
            "\\b\\d+(?:\\.\\d+)?\\b"
    );

    private static final Pattern PATTERN_STRINGS = Pattern.compile(
            "\"(?:\\\\.|[^\"\\\\])*\"|'(?:\\\\.|[^'\\\\])'"
    );

    private static final Pattern PATTERN_COMMENTS = Pattern.compile(
            "##[\\s\\S]*?##|//.*?$|/\\*[\\s\\S]*?\\*/",
            Pattern.MULTILINE
    );

    public PigLatinHighlighter(JTextPane editor) {
        super(editor);
    }

    public static void install(JTextPane editor) {
        if (editor != null) {
            new PigLatinHighlighter(editor);
        }
    }

    @Override
    protected void applyHighlightRules(StyledDocument doc, String text) {
        // Operadores
        matchAndApply(doc, text, PATTERN_OPERATORS, createStyle(MonokaiPalette.OPERATOR, false, false));

        // Palabras reservadas
        matchAndApply(doc, text, PATTERN_KEYWORDS, createStyle(MonokaiPalette.KEYWORD, true, false));

        // Tipos de datos
        matchAndApply(doc, text, PATTERN_TYPES, createStyle(MonokaiPalette.TYPE, true, false));

        // Booleanos
        matchAndApply(doc, text, PATTERN_BOOLEANS, createStyle(MonokaiPalette.BOOLEAN, true, false));

        // Numeros
        matchAndApply(doc, text, PATTERN_NUMBERS, createStyle(MonokaiPalette.NUMBER, false, false));

        // Cadenas y caracteres
        matchAndApply(doc, text, PATTERN_STRINGS, createStyle(MonokaiPalette.STRING, false, false));

        // Comentarios (al final para sobreescribir tokens internos)
        matchAndApply(doc, text, PATTERN_COMMENTS, createStyle(MonokaiPalette.COMMENT, false, true));
    }
}
