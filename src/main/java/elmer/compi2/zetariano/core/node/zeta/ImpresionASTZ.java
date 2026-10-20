/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class ImpresionASTZ extends SentenciaASTZ {

    private final ExpresionASTZ expresion;
    private final boolean saltoLinea;

    public ImpresionASTZ(
            ExpresionASTZ expresion,
            boolean saltoLinea,
            int linea,
            int columna) {

        super(linea, columna);

        this.expresion = expresion;
        this.saltoLinea = saltoLinea;
    }

    public ExpresionASTZ getExpresion() {
        return expresion;
    }

    public boolean isSaltoLinea() {
        return saltoLinea;
    }

    @Override
    public String getNombreNodo() {
        return saltoLinea
                ? "PRINTLN"
                : "PRINT";
    }
}
