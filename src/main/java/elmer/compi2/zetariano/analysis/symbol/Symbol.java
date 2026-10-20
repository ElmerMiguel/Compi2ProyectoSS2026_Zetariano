package elmer.compi2.zetariano.analysis.symbol;

import java.util.ArrayList;
import java.util.List;

/**
 * Representacion de una entrada en la tabla de simbolos.
 */
public class Symbol {

    private String name;
    private DataType type;
    private SymbolKind kind;
    private int scopeLevel;
    private int scopeId;
    private String referenceType;
    private DataType elementType;
    private List<Integer> dimensions = new ArrayList<>();
    private List<DataType> parameters = new ArrayList<>();
    private List<ParamInfo> parametersInfo = new ArrayList<>();

    public Symbol() {
    }

    public Symbol(String name, DataType type, SymbolKind kind, int scopeLevel, int scopeId,
                  String referenceType, DataType elementType, List<Integer> dimensions,
                  List<DataType> parameters, List<ParamInfo> parametersInfo) {
        this.name = name;
        this.type = type;
        this.kind = kind;
        this.scopeLevel = scopeLevel;
        this.scopeId = scopeId;
        this.referenceType = referenceType;
        this.elementType = elementType;
        this.dimensions = (dimensions != null) ? dimensions : new ArrayList<>();
        this.parameters = (parameters != null) ? parameters : new ArrayList<>();
        this.parametersInfo = (parametersInfo != null) ? parametersInfo : new ArrayList<>();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public DataType getType() {
        return type;
    }

    public void setType(DataType type) {
        this.type = type;
    }

    public SymbolKind getKind() {
        return kind;
    }

    public void setKind(SymbolKind kind) {
        this.kind = kind;
    }

    public int getScopeLevel() {
        return scopeLevel;
    }

    public void setScopeLevel(int scopeLevel) {
        this.scopeLevel = scopeLevel;
    }

    public int getScopeId() {
        return scopeId;
    }

    public void setScopeId(int scopeId) {
        this.scopeId = scopeId;
    }

    public String getReferenceType() {
        return referenceType;
    }

    public void setReferenceType(String referenceType) {
        this.referenceType = referenceType;
    }

    public DataType getElementType() {
        return elementType;
    }

    public void setElementType(DataType elementType) {
        this.elementType = elementType;
    }

    public List<Integer> getDimensions() {
        if (dimensions == null) {
            dimensions = new ArrayList<>();
        }
        return dimensions;
    }

    public void setDimensions(List<Integer> dimensions) {
        this.dimensions = dimensions;
    }

    public List<DataType> getParameters() {
        if (parameters == null) {
            parameters = new ArrayList<>();
        }
        return parameters;
    }

    public void setParameters(List<DataType> parameters) {
        this.parameters = parameters;
    }

    public List<ParamInfo> getParametersInfo() {
        if (parametersInfo == null) {
            parametersInfo = new ArrayList<>();
        }
        return parametersInfo;
    }

    public void setParametersInfo(List<ParamInfo> parametersInfo) {
        this.parametersInfo = parametersInfo;
    }

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

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private String name;
        private DataType type;
        private SymbolKind kind;
        private int scopeLevel;
        private int scopeId;
        private String referenceType;
        private DataType elementType;
        private List<Integer> dimensions = new ArrayList<>();
        private List<DataType> parameters = new ArrayList<>();
        private List<ParamInfo> parametersInfo = new ArrayList<>();

        public Builder name(String name) {
            this.name = name;
            return this;
        }

        public Builder type(DataType type) {
            this.type = type;
            return this;
        }

        public Builder kind(SymbolKind kind) {
            this.kind = kind;
            return this;
        }

        public Builder scopeLevel(int scopeLevel) {
            this.scopeLevel = scopeLevel;
            return this;
        }

        public Builder scopeId(int scopeId) {
            this.scopeId = scopeId;
            return this;
        }

        public Builder referenceType(String referenceType) {
            this.referenceType = referenceType;
            return this;
        }

        public Builder elementType(DataType elementType) {
            this.elementType = elementType;
            return this;
        }

        public Builder dimensions(List<Integer> dimensions) {
            this.dimensions = dimensions;
            return this;
        }

        public Builder parameters(List<DataType> parameters) {
            this.parameters = parameters;
            return this;
        }

        public Builder parametersInfo(List<ParamInfo> parametersInfo) {
            this.parametersInfo = parametersInfo;
            return this;
        }

        public Symbol build() {
            return new Symbol(name, type, kind, scopeLevel, scopeId, referenceType, elementType,
                    dimensions, parameters, parametersInfo);
        }
    }
}
