/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */
public class BloqueASTPig
        extends SentenciaASTPig {

    private final List<SentenciaASTPig> sentencias;

    public BloqueASTPig(
            int linea,
            int columna) {

        super(linea, columna);

        this.sentencias
                = new ArrayList<>();
    }

    public void agregarSentencia(
            SentenciaASTPig sentencia) {

        if (sentencia != null) {
            sentencias.add(sentencia);
        }
    }

    public List<SentenciaASTPig> getSentencias() {

        return Collections.unmodifiableList(
                sentencias
        );
    }

    @Override
    public String generarTexto() {

        StringBuilder sb
                = new StringBuilder();

        sb.append("BLOQUE");

        for (SentenciaASTPig sentencia
                : sentencias) {

            sb.append("\n  ")
                    .append(
                            sentencia.generarTexto()
                    );
        }

        return sb.toString();
    }
}
