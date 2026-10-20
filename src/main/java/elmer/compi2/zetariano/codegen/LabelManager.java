/*
 */
package elmer.compi2.zetariano.codegen;

/**
 *
 */
public class LabelManager {

    private int contador;

    public LabelManager() {
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
