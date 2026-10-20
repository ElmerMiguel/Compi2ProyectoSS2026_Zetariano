/*
 */
package elmer.compi2.zetariano.imports;

/**
 *
 */
public class AtributoImportadoPig {

    private final String nombre;
    private final String tipo;
    private final int dimensiones;

    public AtributoImportadoPig(
            String nombre,
            String tipo,
            int dimensiones) {

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

        return "AtributoImportadoPig{"
                + "nombre='" + nombre + '\''
                + ", tipo='" + tipo + '\''
                + ", dimensiones=" + dimensiones
                + '}';
    }
}
