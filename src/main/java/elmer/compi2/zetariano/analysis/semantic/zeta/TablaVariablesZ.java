/*
 */
package elmer.compi2.zetariano.analysis.semantic.zeta;

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 */
public class TablaVariablesZ {

    private final Deque<Map<String, VariableZ>> ambitos
            = new ArrayDeque<>();

    public void entrarAmbito() {
        ambitos.push(new LinkedHashMap<>());
    }

    public void salirAmbito() {
        if (!ambitos.isEmpty()) {
            ambitos.pop();
        }
    }

    public boolean registrar(VariableZ variable) {

        if (variable == null || ambitos.isEmpty()) {
            return false;
        }

        Map<String, VariableZ> actual = ambitos.peek();

        if (actual.containsKey(variable.getNombre())) {
            return false;
        }

        actual.put(variable.getNombre(), variable);
        return true;
    }

    public VariableZ buscar(String nombre) {

        for (Map<String, VariableZ> ambito : ambitos) {

            VariableZ variable = ambito.get(nombre);

            if (variable != null) {
                return variable;
            }
        }

        return null;
    }

    public boolean existeEnAmbitoActual(String nombre) {

        if (ambitos.isEmpty()) {
            return false;
        }

        return ambitos.peek().containsKey(nombre);
    }

    public int cantidadAmbitos() {
        return ambitos.size();
    }
}
