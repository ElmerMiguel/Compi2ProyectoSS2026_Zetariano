/*
 */
package elmer.compi2.zetariano.runtime;

/**
 *
 */
public class ResultadoAccesoMemoria {

    private final String direccion;
    private final String valor;

    public ResultadoAccesoMemoria(
            String direccion,
            String valor) {

        this.direccion = direccion;
        this.valor = valor;
    }

    public String getDireccion() {
        return direccion;
    }

    public String getValor() {
        return valor;
    }
}
