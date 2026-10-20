/*
 */
package elmer.compi2.zetariano.analysis.semantic.zeta;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 */
public class TablaClasesZ {

    private final Map<String, ClaseZ> clases
            = new LinkedHashMap<>();

    public boolean registrar(ClaseZ clase) {

        if (clase == null) {
            return false;
        }

        if (clases.containsKey(clase.getNombre())) {
            return false;
        }

        clases.put(
                clase.getNombre(),
                clase
        );

        return true;
    }

    public ClaseZ buscar(String nombre) {

        if (nombre == null) {
            return null;
        }

        return clases.get(nombre);
    }

    public boolean existe(String nombre) {
        return clases.containsKey(nombre);
    }

    public Collection<ClaseZ> obtenerClases() {
        return clases.values();
    }

    public void limpiar() {
        clases.clear();
    }
}
