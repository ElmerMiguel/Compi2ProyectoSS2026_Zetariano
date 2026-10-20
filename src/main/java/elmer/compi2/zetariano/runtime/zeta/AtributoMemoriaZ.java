/*
 */
package elmer.compi2.zetariano.runtime.zeta;

/**
 *
 */
public class AtributoMemoriaZ {

    private final String nombre;
    private final String tipo;
    private final int dimensiones;
    private final int offset;

    public AtributoMemoriaZ(
            String nombre,
            String tipo,
            int dimensiones,
            int offset) {

        this.nombre = nombre;
        this.tipo = tipo;
        this.dimensiones = dimensiones;
        this.offset = offset;
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

    public int getOffset() {
        return offset;
    }

    public boolean esArreglo() {
        return dimensiones > 0;
    }

    @Override
    public String toString() {

        return "AtributoMemoriaZ{"
                + "nombre='" + nombre + '\''
                + ", tipo='" + tipo + '\''
                + ", dimensiones=" + dimensiones
                + ", offset=" + offset
                + '}';
    }
}
