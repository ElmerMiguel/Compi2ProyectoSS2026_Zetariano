package elmer.compi2.zetariano.analysis.symbol;

import lombok.Builder;
import lombok.Data;

/**
 * Metadatos de un parametro formal para funciones o metodos.
 */
@Data
@Builder
public class ParamInfo {
    private final String name;
    private final DataType type;
    private final DataType elementType;
    private final String referenceType;
    private final boolean byReference;

    @Override
    public String toString() {
        return String.format("ParamInfo{name='%s', type=%s, elem=%s, ref='%s', byRef=%s}",
                name, type, elementType, referenceType, byReference);
    }
}
