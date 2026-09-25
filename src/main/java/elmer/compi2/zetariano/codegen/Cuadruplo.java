/*
 */
package elmer.compi2.zetariano.codegen;

/**
 *
 */
public class Cuadruplo {

    private final String operador;
    private final String argumento1;
    private final String argumento2;
    private final String resultado;

    public Cuadruplo(
            String operador,
            String argumento1,
            String argumento2,
            String resultado) {

        this.operador = operador;
        this.argumento1 = argumento1;
        this.argumento2 = argumento2;
        this.resultado = resultado;
    }

    public String getOperador() {
        return operador;
    }

    public String getArgumento1() {
        return argumento1;
    }

    public String getArgumento2() {
        return argumento2;
    }

    public String getResultado() {
        return resultado;
    }

    private String mostrar(String valor) {
        return valor == null ? "-" : valor;
    }

    @Override
    public String toString() {
        return String.format(
                "(%-12s, %-12s, %-12s, %-12s)",
                mostrar(operador),
                mostrar(argumento1),
                mostrar(argumento2),
                mostrar(resultado)
        );
    }
}
