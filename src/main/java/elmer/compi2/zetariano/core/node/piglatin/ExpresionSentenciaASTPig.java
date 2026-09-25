/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class ExpresionSentenciaASTPig
        extends SentenciaASTPig {

    private final ExpresionASTPig expresion;

    public ExpresionSentenciaASTPig(
            ExpresionASTPig expresion,
            int linea,
            int columna) {

        super(linea, columna);

        this.expresion = expresion;
    }

    public ExpresionASTPig getExpresion() {
        return expresion;
    }

    @Override
    public String generarTexto() {

        return "EXPRESION_SENTENCIA: "
                + (
                expresion == null
                        ? "(vacio)"
                        : expresion.generarTexto()
                );
    }
}