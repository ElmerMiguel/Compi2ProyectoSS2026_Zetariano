/*
 */
package elmer.compi2.zetariano.codegen;

/**
 *
 */
public class GeneradorTemporales {

    private int contador;

    public GeneradorTemporales() {
        contador = 0;
    }

    public String nuevoTemporal() {
        contador++;
        return "t" + contador;
    }

    public void reiniciar() {
        contador = 0;
    }

    public int getCantidad() {
        return contador;
    }
}
