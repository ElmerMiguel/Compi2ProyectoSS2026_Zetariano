/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class IncrementoDecrementoASTPig
        extends SentenciaASTPig {

    private final AccesoASTPig acceso;
    private final String operador;

    public IncrementoDecrementoASTPig(
            AccesoASTPig acceso,
            String operador,
            int linea,
            int columna) {

        super(linea, columna);

        this.acceso = acceso;
        this.operador = operador;
    }

    public AccesoASTPig getAcceso() {
        return acceso;
    }

    public String getOperador() {
        return operador;
    }

    @Override
    public String generarTexto() {

        return "INC_DEC: "
                + acceso.generarTexto()
                + operador;
    }
}
