/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class ContinueASTPig
        extends SentenciaASTPig {

    public ContinueASTPig(
            int linea,
            int columna) {

        super(linea, columna);
    }

    @Override
    public String generarTexto() {
        return "CONTINUE";
    }
}
