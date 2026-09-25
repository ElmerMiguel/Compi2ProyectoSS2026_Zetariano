package elmer.compi2.zetariano.diagnostic;

import lombok.Builder;
import lombok.Data;

/**
 * Reporte inmutable de error con soporte de Lombok.
 */
@Data
@Builder
public class ErrorReport {
    private final ErrorKind kind;
    private final String message;
    private final int line;
    private final int column;

    @Override
    public String toString() {
        return String.format("[%s] Linea %d:%d -> %s", kind, line, column, message);
    }
}
