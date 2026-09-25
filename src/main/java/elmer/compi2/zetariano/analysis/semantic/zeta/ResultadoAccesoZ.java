/*
 */
package elmer.compi2.zetariano.analysis.semantic.zeta;

/**
 *
 */
public class ResultadoAccesoZ {

    private final String tipo;
    private final int dimensiones;
    private final boolean valido;

    public ResultadoAccesoZ(
            String tipo,
            int dimensiones,
            boolean valido) {

        this.tipo = tipo;
        this.dimensiones = dimensiones;
        this.valido = valido;
    }

    public String getTipo() {
        return tipo;
    }

    public int getDimensiones() {
        return dimensiones;
    }

    public boolean isValido() {
        return valido;
    }

    public boolean esArreglo() {
        return dimensiones > 0;
    }

    public static ResultadoAccesoZ error() {
        return new ResultadoAccesoZ(
                "desconocido",
                0,
                false
        );
    }
}
