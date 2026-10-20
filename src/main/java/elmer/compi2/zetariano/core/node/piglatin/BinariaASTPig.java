/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class BinariaASTPig extends ExpresionASTPig {

    private final String operador;
    private final ExpresionASTPig izquierda;
    private final ExpresionASTPig derecha;

    public BinariaASTPig(
            String operador,
            ExpresionASTPig izquierda,
            ExpresionASTPig derecha,
            int linea,
            int columna) {

        super(linea, columna);

        this.operador = operador;
        this.izquierda = izquierda;
        this.derecha = derecha;
    }

    public String getOperador() {
        return operador;
    }

    public ExpresionASTPig getIzquierda() {
        return izquierda;
    }

    public ExpresionASTPig getDerecha() {
        return derecha;
    }

    @Override
    public String generarTexto() {

        return "BINARIA("
                + operador
                + ", "
                + izquierda.generarTexto()
                + ", "
                + derecha.generarTexto()
                + ")";
    }

    @Override
    public String toString() {
        return generarTexto();
    }
}
