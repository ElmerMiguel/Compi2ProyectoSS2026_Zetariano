/*
 */
package elmer.compi2.zetariano.analysis.semantic.zeta;

/**
 *
 */
public class VariableZ {

    private final String nombre;
    private final String tipo;
    private final int dimensiones;
    private final boolean parametro;

    public VariableZ(
            String nombre,
            String tipo,
            int dimensiones,
            boolean parametro) {

        this.nombre = nombre;
        this.tipo = tipo;
        this.dimensiones = dimensiones;
        this.parametro = parametro;
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

    public boolean esParametro() {
        return parametro;
    }

    @Override
    public String toString() {
        return "VariableZ{"
                + "nombre='" + nombre + '\''
                + ", tipo='" + tipo + '\''
                + ", dimensiones=" + dimensiones
                + ", parametro=" + parametro
                + '}';
    }
}
