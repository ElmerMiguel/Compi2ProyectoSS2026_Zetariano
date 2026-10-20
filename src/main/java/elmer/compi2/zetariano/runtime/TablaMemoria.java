/*
 */
package elmer.compi2.zetariano.runtime;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Collection;

/**
 *
 */
public class TablaMemoria {

    private final Map<String, MarcoFuncion> funciones;

    public TablaMemoria() {
        funciones = new LinkedHashMap<>();
    }

    public MarcoFuncion crearFuncion(
            String nombre) {

        MarcoFuncion marco
                = new MarcoFuncion(nombre);

        funciones.put(
                nombre,
                marco
        );

        return marco;
    }

    public MarcoFuncion buscarFuncion(
            String nombre) {

        return funciones.get(nombre);
    }

    public Collection<MarcoFuncion> getFunciones() {
        return funciones.values();
    }

    public void limpiar() {
        funciones.clear();
    }
}
