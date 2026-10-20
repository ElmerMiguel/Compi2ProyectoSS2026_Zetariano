package elmer.compi2.zetariano.diagnostic;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ErrorManager {
    private static final List<CompilerError> errores = new ArrayList<>();
    private ErrorManager() {}
    public static void clear() { errores.clear(); }
    public static void addError(CompilerError.Tipo tipo, String mensaje, int linea, int columna) {
        errores.add(new CompilerError(tipo, mensaje, linea, columna));
    }
    public static boolean hasErrors() { return !errores.isEmpty(); }
    public static List<CompilerError> getErrors() { return Collections.unmodifiableList(errores); }
    public static long contarPorTipo(CompilerError.Tipo tipo) {
        return errores.stream().filter(e -> e.getTipo() == tipo).count();
    }
}
