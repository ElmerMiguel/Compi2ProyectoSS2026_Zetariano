package elmer.compi2.zetariano.diagnostic;

/**
 * Reporte inmutable de error con soporte para GUI y diagnóstico.
 */
public class ErrorReport {

    private final ErrorKind kind;
    private final String message;
    private final int line;
    private final int column;

    public ErrorReport(ErrorKind kind, String message, int line, int column) {
        this.kind = kind;
        this.message = message;
        this.line = line;
        this.column = column;
    }

    public ErrorKind getKind() {
        return kind;
    }

    public String getMessage() {
        return message;
    }

    public int getLine() {
        return line;
    }

    public int getColumn() {
        return column;
    }

    @Override
    public String toString() {
        return String.format("[%s] Linea %d:%d -> %s", kind, line, column, message);
    }

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private ErrorKind kind;
        private String message;
        private int line;
        private int column;

        public Builder kind(ErrorKind kind) {
            this.kind = kind;
            return this;
        }

        public Builder message(String message) {
            this.message = message;
            return this;
        }

        public Builder line(int line) {
            this.line = line;
            return this;
        }

        public Builder column(int column) {
            this.column = column;
            return this;
        }

        public ErrorReport build() {
            return new ErrorReport(kind, message, line, column);
        }
    }
}
