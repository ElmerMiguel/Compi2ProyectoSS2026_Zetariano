/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public abstract class NodoASTPig {

    private final int linea;
    private final int columna;

    protected NodoASTPig(
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

    public abstract String generarTexto();

    protected String sangria(
            int nivel) {

        return "  ".repeat(
                Math.max(
                        0,
                        nivel
                )
        );
    }
}
