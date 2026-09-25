/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class IncrementoDecrementoASTZ extends SentenciaASTZ {

    private final ExpresionASTZ destino;
    private final String operador;

    public IncrementoDecrementoASTZ(
            ExpresionASTZ destino,
            String operador,
            int linea,
            int columna) {

        super(linea, columna);

        this.destino = destino;
        this.operador = operador;
    }

    public ExpresionASTZ getDestino() {
        return destino;
    }

    public String getOperador() {
        return operador;
    }

    @Override
    public String getNombreNodo() {
        return "INCREMENTO_DECREMENTO";
    }
}
