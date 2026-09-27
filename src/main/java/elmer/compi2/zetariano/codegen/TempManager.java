
package elmer.compi2.zetariano.codegen;


public class TempManager {

    private int contador;

    public TempManager() {
        contador = 0;
    }

    public String nuevoTemporal() {
        contador++;
        return "t" + contador;
    }

    public String newTemp() {
        return nuevoTemporal();
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
