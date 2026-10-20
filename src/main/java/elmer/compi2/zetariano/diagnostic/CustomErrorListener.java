package elmer.compi2.zetariano.diagnostic;

import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;

public class CustomErrorListener extends BaseErrorListener {
    private final CompilerError.Tipo tipo;
    public CustomErrorListener(CompilerError.Tipo tipo) { this.tipo = tipo; }
    @Override
    public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
        ErrorManager.addError(tipo, msg, line, charPositionInLine);
    }
}
