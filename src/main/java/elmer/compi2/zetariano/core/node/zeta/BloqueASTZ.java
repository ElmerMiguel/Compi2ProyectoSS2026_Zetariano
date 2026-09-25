/*
 */
package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class BloqueASTZ extends SentenciaASTZ {

    private final List<SentenciaASTZ> sentencias;

    public BloqueASTZ(
            int linea,
            int columna) {

        super(linea, columna);

        this.sentencias = new ArrayList<>();
    }

    public void agregarSentencia(
            SentenciaASTZ sentencia) {

        if (sentencia != null) {
            sentencias.add(sentencia);
        }
    }

    public List<SentenciaASTZ> getSentencias() {
        return sentencias;
    }

    @Override
    public String getNombreNodo() {
        return "BLOQUE";
    }
}
