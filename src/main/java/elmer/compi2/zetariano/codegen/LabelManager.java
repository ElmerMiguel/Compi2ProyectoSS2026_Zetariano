
package elmer.compi2.zetariano.codegen;


public class LabelManager {

    private int contador;

    public LabelManager() {
        contador = 0;
    }

    public String nuevaEtiqueta() {
        contador++;
        return "L" + contador;
    }

    public String newLabel() {
        return nuevaEtiqueta();
    }

    public void reiniciar() {
        contador = 0;
    }

    public void reset() {
        reiniciar();
    }

    public int getCantidad() {
        return contador;
    }

    public int getCount() {
        return getCantidad();
    }
}
