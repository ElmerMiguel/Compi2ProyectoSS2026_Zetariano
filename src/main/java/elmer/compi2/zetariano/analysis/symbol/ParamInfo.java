package elmer.compi2.zetariano.analysis.symbol;

/**
 * Metadatos de un parametro formal para funciones o metodos.
 */
public class ParamInfo {

    private final String name;
    private final DataType type;
    private final DataType elementType;
    private final String referenceType;
    private final boolean byReference;

    public ParamInfo(String name, DataType type, DataType elementType, String referenceType, boolean byReference) {
        this.name = name;
        this.type = type;
        this.elementType = elementType;
        this.referenceType = referenceType;
        this.byReference = byReference;
    }

    public String getName() {
        return name;
    }

    public DataType getType() {
        return type;
    }

    public DataType getElementType() {
        return elementType;
    }

    public String getReferenceType() {
        return referenceType;
    }

    public boolean isByReference() {
        return byReference;
    }

    @Override
    public String toString() {
        return String.format("ParamInfo{name='%s', type=%s, elem=%s, ref='%s', byRef=%s}",
                name, type, elementType, referenceType, byReference);
    }

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private String name;
        private DataType type;
        private DataType elementType;
        private String referenceType;
        private boolean byReference;

        public Builder name(String name) {
            this.name = name;
            return this;
        }

        public Builder type(DataType type) {
            this.type = type;
            return this;
        }

        public Builder elementType(DataType elementType) {
            this.elementType = elementType;
            return this;
        }

        public Builder referenceType(String referenceType) {
            this.referenceType = referenceType;
            return this;
        }

        public Builder byReference(boolean byReference) {
            this.byReference = byReference;
            return this;
        }

        public ParamInfo build() {
            return new ParamInfo(name, type, elementType, referenceType, byReference);
        }
    }
}
