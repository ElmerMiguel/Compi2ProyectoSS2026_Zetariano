/*
 */
package elmer.compi2.zetariano.runtime;

/**
 *
 */
public class ClasificadorMemoria {

    private ClasificadorMemoria() {
    }

    public static boolean requiereHeap(
            String tipo) {

        if (tipo == null) {
            return false;
        }

        String normalizado
                = tipo.trim()
                        .toLowerCase();

        return switch (normalizado) {

            case "entero", "flotante", "decimal", "caracter", "booleano", "bool" ->
                false;

            case "cadena", "string" ->
                true;

            default ->
                true;
        };
    }
}
