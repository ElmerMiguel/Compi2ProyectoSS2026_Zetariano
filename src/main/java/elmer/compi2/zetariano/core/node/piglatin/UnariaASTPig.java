/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class UnariaASTPig extends ExpresionASTPig {

    private final String operador;
    private final ExpresionASTPig expresion;
    private final boolean prefijo;

    public UnariaASTPig(
            String operador,
            ExpresionASTPig expresion,
            boolean prefijo,
            int linea,
            int columna) {

        super(linea, columna);

        this.operador = operador;
        this.expresion = expresion;
        this.prefijo = prefijo;
    }

    public String getOperador() {
        return operador;
    }

    public ExpresionASTPig getExpresion() {
        return expresion;
    }

    public boolean isPrefijo() {
        return prefijo;
    }

    @Override
    public String generarTexto() {

        if (prefijo) {

            return "UNARIA: "
                    + operador
                    + expresion.generarTexto();
        }

        return "UNARIA: "
                + expresion.generarTexto()
                + operador;
    }

    @Override
    public String toString() {
        return generarTexto();
    }
}