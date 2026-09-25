package elmer.compi2.zetariano.analysis.symbol;

import lombok.Builder;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * Representacion de una entrada en la tabla de simbolos con soporte Lombok.
 */
@Data
@Builder
public class Symbol {
    private String name;
    private DataType type;
    private SymbolKind kind;
    private int scopeLevel;
    private int scopeId;
    private String referenceType;
    private DataType elementType;

    @Builder.Default
    private List<Integer> dimensions = new ArrayList<>();

    @Builder.Default
    private List<DataType> parameters = new ArrayList<>();

    @Builder.Default
    private List<ParamInfo> parametersInfo = new ArrayList<>();

    @Override
    public String toString() {
        return "Symbol{"
                + "name='" + name + '\''
                + ", type=" + type
                + ", kind=" + kind
                + ", scopeLevel=" + scopeLevel
                + ", scopeId=" + scopeId
                + ", referenceType='" + referenceType + '\''
                + ", elementType=" + elementType
                + ", dimensions=" + dimensions
                + ", parameters=" + parameters
                + '}';
    }
}
