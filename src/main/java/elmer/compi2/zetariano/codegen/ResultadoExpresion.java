/*
 */
package elmer.compi2.zetariano.codegen;

/**
 *
 */
public class ResultadoExpresion {

    private final String valor;

    public ResultadoExpresion(String valor) {
        this.valor = valor;
    }

    public String getValor() {
        return valor;
    }

    @Override
    public String toString() {
        return valor;
    }
}
