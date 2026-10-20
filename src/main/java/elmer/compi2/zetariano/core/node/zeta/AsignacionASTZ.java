/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class AsignacionASTZ extends SentenciaASTZ {

    private final ExpresionASTZ destino;
    private final String operador;
    private final ExpresionASTZ valor;

    public AsignacionASTZ(
            ExpresionASTZ destino,
            String operador,
            ExpresionASTZ valor,
            int linea,
            int columna) {

        super(linea, columna);

        this.destino = destino;
        this.operador = operador;
        this.valor = valor;
    }

    public ExpresionASTZ getDestino() {
        return destino;
    }

    public String getOperador() {
        return operador;
    }

    public ExpresionASTZ getValor() {
        return valor;
    }

    @Override
    public String getNombreNodo() {
        return "ASIGNACION";
    }
}
