/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public abstract class NodoASTZ {

    private final int linea;
    private final int columna;

    protected NodoASTZ(
            int linea,
            int columna) {

        this.linea = linea;
        this.columna = columna;
    }

    public int getLinea() {
        return linea;
    }

    public int getColumna() {
        return columna;
    }

    public abstract String getNombreNodo();
}
