/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class BinariaASTZ extends ExpresionASTZ {

    private final ExpresionASTZ izquierda;
    private final String operador;
    private final ExpresionASTZ derecha;

    public BinariaASTZ(
            ExpresionASTZ izquierda,
            String operador,
            ExpresionASTZ derecha,
            int linea,
            int columna) {

        super(linea, columna);

        this.izquierda = izquierda;
        this.operador = operador;
        this.derecha = derecha;
    }

    public ExpresionASTZ getIzquierda() {
        return izquierda;
    }

    public String getOperador() {
        return operador;
    }

    public ExpresionASTZ getDerecha() {
        return derecha;
    }

    @Override
    public String getNombreNodo() {
        return "BINARIA";
    }
}
