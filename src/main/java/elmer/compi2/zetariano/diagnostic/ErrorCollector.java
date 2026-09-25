package elmer.compi2.zetariano.diagnostic;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Gestor y acumulador global de errores producidos en el compilador.
 */
public final class ErrorCollector {

    private static final List<ErrorReport> ERRORS = new ArrayList<>();

    private ErrorCollector() {
    }

    public static synchronized void clear() {
        ERRORS.clear();
    }

    public static synchronized void addError(ErrorKind kind, String message, int line, int column) {
        ERRORS.add(ErrorReport.builder()
                .kind(kind)
                .message(message)
                .line(line)
                .column(column)
                .build());
    }

    public static synchronized boolean hasErrors() {
        return !ERRORS.isEmpty();
    }

    public static synchronized List<ErrorReport> getErrors() {
        return Collections.unmodifiableList(new ArrayList<>(ERRORS));
    }

    public static synchronized long countByKind(ErrorKind kind) {
        return ERRORS.stream()
                .filter(e -> e.getKind() == kind)
                .count();
    }
}
