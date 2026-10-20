/*
 */
package elmer.compi2.zetariano.analysis.symbol.Simbolo;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

/**
 *
 */
public class TablaSimbolos {

    private final List<Simbolo> simbolos
            = new ArrayList<>();

    private final Stack<Integer> pilaAmbitos
            = new Stack<>();

    private int siguienteIdAmbito = 1;

    public TablaSimbolos() {

        // Ámbito global.
        pilaAmbitos.push(0);
    }

    public void entrarAmbito() {

        pilaAmbitos.push(
                siguienteIdAmbito++
        );
    }

    public void salirAmbito() {

        if (pilaAmbitos.size() > 1) {

            pilaAmbitos.pop();
        }
    }

    public int getAmbitoActual() {

        return pilaAmbitos.peek();
    }

    public int getNivelActual() {

        return pilaAmbitos.size() - 1;
    }

    public boolean existeEnAmbitoActual(
            String nombre) {

        int actual
                = getAmbitoActual();

        return simbolos.stream()
                .anyMatch(
                        simbolo
                        -> simbolo.getNombre()
                                .equals(nombre)
                        && simbolo.getIdAmbito()
                        == actual
                );
    }

    public void agregar(
            Simbolo simbolo) {

        simbolos.add(simbolo);
    }

    public Simbolo buscar(
            String nombre) {

        /*
         * Se recorren los ámbitos activos
         * desde el más interno hacia afuera.
         */
        for (int i = pilaAmbitos.size() - 1;
                i >= 0;
                i--) {

            int idAmbito
                    = pilaAmbitos.get(i);

            for (int j = simbolos.size() - 1;
                    j >= 0;
                    j--) {

                Simbolo simbolo
                        = simbolos.get(j);

                if (simbolo.getNombre()
                        .equals(nombre)
                        && simbolo.getIdAmbito()
                        == idAmbito) {

                    return simbolo;
                }
            }
        }

        return null;
    }

    public List<Simbolo> getSimbolos() {

        return simbolos;
    }

    public void imprimir() {

        System.out.println();

        System.out.println(
                "========== TABLA DE SIMBOLOS =========="
        );

        for (Simbolo simbolo
                : simbolos) {

            System.out.println(
                    simbolo
            );
        }

        System.out.println(
                "========================================"
        );
    }

}
