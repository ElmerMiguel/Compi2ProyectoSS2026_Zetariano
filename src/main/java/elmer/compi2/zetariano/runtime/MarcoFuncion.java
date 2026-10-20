/*
 */
package elmer.compi2.zetariano.runtime;

import elmer.compi2.zetariano.core.node.NodoAST;
import java.util.ArrayList;
import java.util.Collection;
import java.util.IdentityHashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *
 */
public class MarcoFuncion {

    private final String nombre;

    private final List<VariableMemoria> variables;

    private final Map<NodoAST, VariableMemoria> variablesPorNodo;

    private int siguienteOffset;

    public MarcoFuncion(String nombre) {

        this.nombre = nombre;

        this.variables
                = new ArrayList<>();

        this.variablesPorNodo
                = new IdentityHashMap<>();

        /*
         * offset 0 queda reservado
         * para el valor de retorno.
         */
        this.siguienteOffset = 1;
    }

    // ============================================================
    // REGISTRAR VARIABLE / PARAMETRO
    // ============================================================
    public VariableMemoria agregarVariable(
            NodoAST nodoDeclaracion,
            String nombre,
            String tipo,
            boolean referenciaHeap) {

        if (nodoDeclaracion != null) {

            VariableMemoria existente
                    = variablesPorNodo.get(
                            nodoDeclaracion
                    );

            if (existente != null) {
                return existente;
            }
        }

        VariableMemoria variable
                = new VariableMemoria(
                        nombre,
                        tipo,
                        siguienteOffset,
                        referenciaHeap
                );

        variables.add(variable);

        if (nodoDeclaracion != null) {

            variablesPorNodo.put(
                    nodoDeclaracion,
                    variable
            );
        }

        siguienteOffset++;

        return variable;
    }

    // ============================================================
    // BUSCAR POR NODO AST
    // ============================================================
    public VariableMemoria buscarVariablePorNodo(
            NodoAST nodo) {

        if (nodo == null) {
            return null;
        }

        return variablesPorNodo.get(nodo);
    }

    public VariableMemoria buscarVariable(
            String nombre) {

        for (VariableMemoria variable
                : variables) {

            if (variable.getNombre()
                    .equals(nombre)) {

                return variable;
            }
        }

        return null;
    }

    // ============================================================
    // TODAS LAS VARIABLES
    // ============================================================
    public Collection<VariableMemoria> getVariables() {

        return variables;
    }

    public int getTamano() {

        return siguienteOffset;
    }

    public String getNombre() {

        return nombre;
    }
}
