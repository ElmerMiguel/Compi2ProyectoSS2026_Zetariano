/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class BreakASTPig
        extends SentenciaASTPig {

    public BreakASTPig(
            int linea,
            int columna) {

        super(linea, columna);
    }

    @Override
    public String generarTexto() {
        return "BREAK";
    }
}
