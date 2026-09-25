/*
 */
package elmer.compi2.zetariano.codegen;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */
public class AtributoEstructuraC3D {

    private final String nombre;
    private final String tipo;
    private final int offset;
    private final List<Integer> dimensiones;

    public AtributoEstructuraC3D(
            String nombre,
            String tipo,
            int offset) {

        this(
                nombre,
                tipo,
                offset,
                new ArrayList<>()
        );
    }

    public AtributoEstructuraC3D(
            String nombre,
            String tipo,
            int offset,
            List<Integer> dimensiones) {

        this.nombre
                = nombre;

        this.tipo
                = tipo;

        this.offset
                = offset;

        this.dimensiones
                = new ArrayList<>(
                        dimensiones
                );
    }

    public String getNombre() {
        return nombre;
    }

    public String getTipo() {
        return tipo;
    }

    public int getOffset() {
        return offset;
    }

    public List<Integer> getDimensiones() {

        return Collections.unmodifiableList(
                dimensiones
        );
    }

    public boolean esArreglo() {

        return !dimensiones.isEmpty();
    }

    public int getRango() {

        return dimensiones.size();
    }

    @Override
    public String toString() {

        return nombre
                + " : "
                + tipo
                + " | offset="
                + offset
                + " | dimensiones="
                + dimensiones;
    }
}
