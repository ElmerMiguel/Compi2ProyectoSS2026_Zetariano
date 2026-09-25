package elmer.compi2.zetariano.diagnostic;

import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;

/**
 * Puente entre los oyentes de error nativos de ANTLR y el ErrorCollector.
 */
public class AntlrErrorBridge extends BaseErrorListener {

    private final ErrorKind kind;

    public AntlrErrorBridge(ErrorKind kind) {
        this.kind = kind;
    }

    @Override
    public void syntaxError(
            Recognizer<?, ?> recognizer,
            Object offendingSymbol,
            int line,
            int charPositionInLine,
            String msg,
            RecognitionException e) {

        ErrorCollector.addError(kind, msg, line, charPositionInLine);
    }
}
