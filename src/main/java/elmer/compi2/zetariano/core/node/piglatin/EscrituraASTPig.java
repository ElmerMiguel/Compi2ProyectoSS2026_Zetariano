/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class EscrituraASTPig
        extends SentenciaASTPig {

    private final ExpresionASTPig expresion;

    public EscrituraASTPig(
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

        return "ESCRITURA: "
                + (expresion == null
                        ? "(vacio)"
                        : expresion.generarTexto());
    }
}
