/*
 */
package elmer.compi2.zetariano.codegen;

/**
 *
 */
public class GeneradorEtiquetas {

    private int contador;

    public GeneradorEtiquetas() {
        contador = 0;
    }

    public String nuevaEtiqueta() {
        contador++;
        return "L" + contador;
    }

    public void reiniciar() {
        contador = 0;
    }

    public int getCantidad() {
        return contador;
    }
}
