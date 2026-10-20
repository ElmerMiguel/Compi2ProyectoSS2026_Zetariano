/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class AsignacionASTPig
        extends SentenciaASTPig {

    private final ExpresionASTPig destino;
    private final ExpresionASTPig valor;
    private final String operador;

    public AsignacionASTPig(
            ExpresionASTPig destino,
            String operador,
            ExpresionASTPig valor,
            int linea,
            int columna) {

        super(linea, columna);

        this.destino = destino;
        this.operador = operador;
        this.valor = valor;
    }

    public ExpresionASTPig getDestino() {
        return destino;
    }

    public ExpresionASTPig getValor() {
        return valor;
    }

    public String getOperador() {
        return operador;
    }

    @Override
    public String generarTexto() {

        return "ASIGNACION: "
                + destino.generarTexto()
                + " "
                + operador
                + " "
                + valor.generarTexto();
    }
}