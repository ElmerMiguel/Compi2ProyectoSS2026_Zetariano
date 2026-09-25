/*
 */
package elmer.compi2.zetariano.runtime.zeta;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 */
public class TablaMemoriaZ {

    private final Map<String, MarcoMetodoZ> marcos;
    private final Map<String, ClaseMemoriaZ> clases;

    public TablaMemoriaZ() {

        this.marcos
                = new LinkedHashMap<>();

        this.clases
                = new LinkedHashMap<>();
    }

    public void registrar(
            MarcoMetodoZ marco) {

        if (marco == null) {
            return;
        }

        marcos.put(
                marco.getFirma(),
                marco
        );
    }

    public MarcoMetodoZ buscar(
            String firma) {

        return marcos.get(firma);
    }

    public boolean contiene(
            String firma) {

        return marcos.containsKey(
                firma
        );
    }

    public Map<String, MarcoMetodoZ> getMarcos() {

        return Collections.unmodifiableMap(
                marcos
        );
    }

    public void imprimir() {

        System.out.println();
        System.out.println(
                "=== TABLA MEMORIA Z ==="
        );

        System.out.println("CLASES:");

        for (ClaseMemoriaZ clase
                : clases.values()) {

            System.out.println(clase);
        }

        if (marcos.isEmpty()) {

            System.out.println(
                    "Sin marcos registrados."
            );

        } else {

            for (MarcoMetodoZ marco
                    : marcos.values()) {

                System.out.println(
                        marco
                );
            }
        }

        System.out.println(
                "=== FIN TABLA MEMORIA Z ==="
        );
    }

    public void registrarClase(
            ClaseMemoriaZ clase) {

        if (clase == null) {
            return;
        }

        clases.put(
                clase.getNombre(),
                clase
        );
    }

    public ClaseMemoriaZ buscarClase(
            String nombre) {

        return clases.get(nombre);
    }

    public Map<String, ClaseMemoriaZ> getClases() {

        return Collections.unmodifiableMap(
                clases
        );
    }
}
