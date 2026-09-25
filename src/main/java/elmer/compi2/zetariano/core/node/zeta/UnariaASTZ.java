/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class UnariaASTZ extends ExpresionASTZ {

    private final String operador;
    private final ExpresionASTZ expresion;
    private final boolean postfijo;

    public UnariaASTZ(
            String operador,
            ExpresionASTZ expresion,
            boolean postfijo,
            int linea,
            int columna) {

        super(linea, columna);

        this.operador = operador;
        this.expresion = expresion;
        this.postfijo = postfijo;
    }

    public String getOperador() {
        return operador;
    }

    public ExpresionASTZ getExpresion() {
        return expresion;
    }

    public boolean isPostfijo() {
        return postfijo;
    }

    @Override
    public String getNombreNodo() {
        return "UNARIA";
    }
}
