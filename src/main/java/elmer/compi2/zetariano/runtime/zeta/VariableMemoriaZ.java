/*
 */
package elmer.compi2.zetariano.runtime.zeta;

/**
 *
 */
public class VariableMemoriaZ {

    public enum Categoria {

        RETORNO,
        THIS,
        PARAMETRO,
        LOCAL
    }

    private final String nombre;
    private final String tipo;

    private final int dimensiones;
    private final int offset;

    private final Categoria categoria;

    public VariableMemoriaZ(
            String nombre,
            String tipo,
            int dimensiones,
            int offset,
            Categoria categoria) {

        this.nombre = nombre;
        this.tipo = tipo;
        this.dimensiones = dimensiones;
        this.offset = offset;
        this.categoria = categoria;
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

    public Categoria getCategoria() {
        return categoria;
    }

    public boolean esArreglo() {
        return dimensiones > 0;
    }

    @Override
    public String toString() {

        return "VariableMemoriaZ{"
                + "nombre='" + nombre + '\''
                + ", tipo='" + tipo + '\''
                + ", dimensiones=" + dimensiones
                + ", offset=" + offset
                + ", categoria=" + categoria
                + '}';
    }
}
