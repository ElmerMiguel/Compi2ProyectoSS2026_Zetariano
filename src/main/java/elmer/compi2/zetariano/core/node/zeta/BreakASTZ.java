/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class BreakASTZ extends SentenciaASTZ {

    public BreakASTZ(
            int linea,
            int columna) {

        super(linea, columna);
    }

    @Override
    public String getNombreNodo() {
        return "BREAK";
    }
}
