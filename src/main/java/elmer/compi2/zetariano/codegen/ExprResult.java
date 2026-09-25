/*
 */
package elmer.compi2.zetariano.codegen;

/**
 *
 */
public class ExprResult {

    private final String valor;

    public ExprResult(String valor) {
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
