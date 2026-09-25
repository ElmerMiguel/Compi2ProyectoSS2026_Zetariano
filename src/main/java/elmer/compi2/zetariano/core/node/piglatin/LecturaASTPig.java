/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class LecturaASTPig
        extends SentenciaASTPig {

    private final ExpresionASTPig destino;

    public LecturaASTPig(
            ExpresionASTPig destino,
            int linea,
            int columna) {

        super(linea, columna);

        this.destino = destino;
    }

    public ExpresionASTPig getDestino() {
        return destino;
    }

    @Override
    public String generarTexto() {

        return "LECTURA: "
                + (destino == null
                        ? "(vacio)"
                        : destino.generarTexto());
    }
}
