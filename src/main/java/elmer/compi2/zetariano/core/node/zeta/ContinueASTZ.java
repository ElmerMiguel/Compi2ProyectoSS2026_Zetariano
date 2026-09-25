/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class ContinueASTZ extends SentenciaASTZ {

    public ContinueASTZ(
            int linea,
            int columna) {

        super(linea, columna);
    }

    @Override
    public String getNombreNodo() {
        return "CONTINUE";
    }
}
