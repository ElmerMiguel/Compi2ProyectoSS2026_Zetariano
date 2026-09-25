/*
 */
package elmer.compi2.zetariano.analysis.semantic.zeta;

/**
 *
 */
public class AtributoZ {

    private final String nombre;
    private final String tipo;
    private final int dimensiones;

    public AtributoZ(String nombre, String tipo, int dimensiones) {
        this.nombre = nombre;
        this.tipo = tipo;
        this.dimensiones = dimensiones;
    }

    public String getNombre() {
        return nombre;
    }

    public String getTipo() {
        return tipo;
    }

    public int getDimensiones() {
        return dimensiones;
    }

    public boolean esArreglo() {
        return dimensiones > 0;
    }

    @Override
    public String toString() {
        return "AtributoZ{"
                + "nombre='" + nombre + '\''
                + ", tipo='" + tipo + '\''
                + ", dimensiones=" + dimensiones
                + '}';
    }

}
