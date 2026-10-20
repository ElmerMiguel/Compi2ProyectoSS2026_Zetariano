/*
 */
package elmer.compi2.zetariano.imports;

import java.util.Collection;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 */
public class RegistroImportsPig {

    private final Map<String, ClaseImportadaPig> clases;

    public RegistroImportsPig() {

        this.clases = new LinkedHashMap<>();
    }

    public void registrarClase(
            ClaseImportadaPig clase) {

        if (clase == null) {
            return;
        }

        ClaseImportadaPig existente
                = clases.get(
                        clase.getNombre()
                );

        if (existente != null) {

            throw new IllegalStateException(
                    "Conflicto de imports Pig: la clase '"
                    + clase.getNombre()
                    + "' ya fue importada desde "
                    + existente.getOrigen()
                    + " y no puede importarse nuevamente desde "
                    + clase.getOrigen()
                    + "."
            );
        }

        clases.put(
                clase.getNombre(),
                clase
        );
    }

    public ClaseImportadaPig buscarClase(
            String nombre) {

        return clases.get(nombre);
    }

    public boolean existeClase(
            String nombre) {

        return clases.containsKey(nombre);
    }

    public AtributoImportadoPig buscarAtributo(
            String nombreClase,
            String nombreAtributo) {

        ClaseImportadaPig clase
                = buscarClase(nombreClase);

        if (clase == null) {
            return null;
        }

        return clase.buscarAtributo(
                nombreAtributo
        );
    }

    public MetodoImportadoPig buscarMetodo(
            String nombreClase,
            String firma) {

        ClaseImportadaPig clase
                = buscarClase(nombreClase);

        if (clase == null) {
            return null;
        }

        return clase.buscarMetodoPorFirma(
                firma
        );
    }

    public Collection<ClaseImportadaPig> getClases() {

        return Collections.unmodifiableCollection(
                clases.values()
        );
    }

    public void limpiar() {

        clases.clear();
    }

    public void imprimir() {

        System.out.println();
        System.out.println(
                "=== IMPORTS PIG ==="
        );

        if (clases.isEmpty()) {

            System.out.println(
                    "Sin clases importadas."
            );

        } else {

            for (ClaseImportadaPig clase
                    : clases.values()) {

                System.out.println(clase);

                for (AtributoImportadoPig atributo
                        : clase.getAtributos()) {

                    System.out.println(
                            "    " + atributo
                    );
                }

                for (MetodoImportadoPig metodo
                        : clase.getMetodos()) {

                    System.out.println(
                            "    " + metodo
                    );
                }
            }
        }

        System.out.println(
                "=== FIN IMPORTS PIG ==="
        );
    }
}
