/*
 */
package elmer.compi2.zetariano.runtime.piglatin;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */
public class VariableMemoriaPig {

    public enum Categoria {

        VARIABLE,
        ARREGLO,
        OBJETO
    }

    private final String nombre;

    private final String tipo;

    private final String tipoReferencia;

    private final List<Integer> dimensiones;

    private final int offset;

    private final Categoria categoria;

    public VariableMemoriaPig(
            String nombre,
            String tipo,
            String tipoReferencia,
            List<Integer> dimensiones,
            int offset,
            Categoria categoria) {

        this.nombre = nombre;

        this.tipo = tipo;

        this.tipoReferencia
                = tipoReferencia;

        this.dimensiones
                = dimensiones == null
                        ? new ArrayList<>()
                        : new ArrayList<>(dimensiones);

        this.offset = offset;

        this.categoria = categoria;
    }

    public String getNombre() {
        return nombre;
    }

    public String getTipo() {
        return tipo;
    }

    public String getTipoReferencia() {
        return tipoReferencia;
    }

    public List<Integer> getDimensiones() {

        return Collections.unmodifiableList(
                dimensiones
        );
    }

    public int getOffset() {
        return offset;
    }

    public Categoria getCategoria() {
        return categoria;
    }

    public boolean esArreglo() {

        return categoria
                == Categoria.ARREGLO;
    }

    public boolean esObjeto() {

        return categoria
                == Categoria.OBJETO;
    }

    @Override
    public String toString() {

        return "VariableMemoriaPig{"
                + "nombre='" + nombre + '\''
                + ", tipo='" + tipo + '\''
                + ", tipoReferencia='" + tipoReferencia + '\''
                + ", dimensiones=" + dimensiones
                + ", offset=" + offset
                + ", categoria=" + categoria
                + '}';
    }
}
