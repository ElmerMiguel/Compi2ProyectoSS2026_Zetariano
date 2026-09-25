package elmer.compi2.zetariano.ui.highlight;

import javax.swing.JTextPane;
import javax.swing.text.StyledDocument;
import java.util.regex.Pattern;

/**
 * Resaltador de sintaxis manual para el lenguaje Y? con paleta Monokai.
 */
public class YHighlighter extends SyntaxHighlighter {

    private static final Pattern PATTERN_SECTIONS = Pattern.compile(
            "%(?:estructuras|funciones)\\b"
    );

    private static final Pattern PATTERN_KEYWORDS = Pattern.compile(
            "\\b(?:"
                    + "estructura|definir|retornar|si|entonces|sino|contrario|"
                    + "elegir|caso|siempre|para|mientras|hacer|continuar|romper|"
                    + "imprimir|leer"
                    + ")\\b"
    );

    private static final Pattern PATTERN_BOOLEANS = Pattern.compile(
            "\\b(?:verdadero|falso)\\b"
    );

    private static final Pattern PATTERN_TYPES = Pattern.compile(
            "\\b(?:"
                    + "entero|flotante|cadena|caracter|bool"
                    + ")\\b"
    );

    private static final Pattern PATTERN_OPERATORS = Pattern.compile(
            "->|==|!=|<=|>=|&&|\\|\\||\\+\\+|--|[+\\-*/=<>!:]"
    );

    private static final Pattern PATTERN_NUMBERS = Pattern.compile(
            "\\b\\d+(?:\\.\\d+)?\\b"
    );

    private static final Pattern PATTERN_STRINGS = Pattern.compile(
            "\"(?:\\\\.|[^\"\\\\])*\"|'(?:\\\\.|[^'\\\\])'"
    );

    private static final Pattern PATTERN_COMMENTS = Pattern.compile(
            "//.*?$|/\\*[\\s\\S]*?\\*/",
            Pattern.MULTILINE
    );

    public YHighlighter(JTextPane editor) {
        super(editor);
    }

    public static void install(JTextPane editor) {
        if (editor != null) {
            new YHighlighter(editor);
        }
    }

    @Override
    protected void applyHighlightRules(StyledDocument doc, String text) {
        matchAndApply(doc, text, PATTERN_OPERATORS, createStyle(MonokaiPalette.OPERATOR, false, false));
        matchAndApply(doc, text, PATTERN_SECTIONS, createStyle(MonokaiPalette.LITERAL, true, false));
        matchAndApply(doc, text, PATTERN_KEYWORDS, createStyle(MonokaiPalette.KEYWORD, true, false));
        matchAndApply(doc, text, PATTERN_TYPES, createStyle(MonokaiPalette.TYPE, true, false));
        matchAndApply(doc, text, PATTERN_BOOLEANS, createStyle(MonokaiPalette.BOOLEAN, true, false));
        matchAndApply(doc, text, PATTERN_NUMBERS, createStyle(MonokaiPalette.NUMBER, false, false));
        matchAndApply(doc, text, PATTERN_STRINGS, createStyle(MonokaiPalette.STRING, false, false));
        matchAndApply(doc, text, PATTERN_COMMENTS, createStyle(MonokaiPalette.COMMENT, false, true));
    }
}
