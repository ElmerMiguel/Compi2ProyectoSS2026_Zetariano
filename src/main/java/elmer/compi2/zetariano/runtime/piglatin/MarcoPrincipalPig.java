/*
 */
package elmer.compi2.zetariano.runtime.piglatin;

import elmer.compi2.zetariano.core.node.piglatin.DeclaracionASTPig;
import java.util.ArrayList;
import java.util.Collections;
import java.util.IdentityHashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *
 */
public class MarcoPrincipalPig {

    private final Map<String, VariableMemoriaPig> variablesBase;
    private final List<VariableMemoriaPig> variables;

    // =========================================================
    // DECLARACION AST -> VARIABLE FISICA
    // =========================================================
    private final IdentityHashMap<
            DeclaracionASTPig, VariableMemoriaPig> variablesPorDeclaracion;

    private int siguienteOffset;

    public MarcoPrincipalPig() {

        this.variablesBase
                = new LinkedHashMap<>();

        this.variables
                = new ArrayList<>();

        this.variablesPorDeclaracion
                = new IdentityHashMap<>();

        this.siguienteOffset = 0;
    }

    // =========================================================
    // REGISTRAR DECLARACION
    // =========================================================
    public VariableMemoriaPig registrar(
            DeclaracionASTPig declaracion) {

        if (declaracion == null) {
            return null;
        }

        // -----------------------------------------------------
        // Evitar registrar DOS veces el mismo nodo AST
        // -----------------------------------------------------
        VariableMemoriaPig existente
                = variablesPorDeclaracion.get(
                        declaracion
                );

        if (existente != null) {
            return existente;
        }

        VariableMemoriaPig.Categoria categoria
                = determinarCategoria(
                        declaracion
                );

        VariableMemoriaPig variable
                = new VariableMemoriaPig(
                        declaracion.getNombre(),
                        declaracion.getTipo(),
                        declaracion.getTipoReferencia(),
                        declaracion.getDimensiones(),
                        siguienteOffset++,
                        categoria
                );

        // -----------------------------------------------------
        // Guardar SIEMPRE en la lista física
        // -----------------------------------------------------
        variables.add(
                variable
        );

        // -----------------------------------------------------
        // Relacionar declaración exacta con offset exacto
        // -----------------------------------------------------
        variablesPorDeclaracion.put(
                declaracion,
                variable
        );

        variablesBase.put(
                declaracion.getNombre(),
                variable
        );

        return variable;
    }

    // =========================================================
    // BUSQUEDA POR NOMBRE
    // =========================================================
    public VariableMemoriaPig buscar(
            String nombre) {

        if (nombre == null) {
            return null;
        }

        return variablesBase.get(
                nombre
        );
    }

    // =========================================================
    // BUSQUEDA POR DECLARACION EXACTA
    // =========================================================
    public VariableMemoriaPig buscar(
            DeclaracionASTPig declaracion) {

        if (declaracion == null) {
            return null;
        }

        return variablesPorDeclaracion.get(
                declaracion
        );
    }

    // =========================================================
    // INFORMACION DEL MARCO
    // =========================================================
    public int getTamano() {
        return siguienteOffset;
    }

    public List<VariableMemoriaPig> getVariables() {

        return Collections.unmodifiableList(
                variables
        );
    }

    // =========================================================
    // CATEGORIA
    // =========================================================
    private VariableMemoriaPig.Categoria determinarCategoria(
            DeclaracionASTPig declaracion) {

        if (declaracion.esArreglo()) {

            return VariableMemoriaPig.Categoria.ARREGLO;
        }

        if (declaracion.getTipoReferencia()
                != null) {

            return VariableMemoriaPig.Categoria.OBJETO;
        }

        return VariableMemoriaPig.Categoria.VARIABLE;
    }

    // =========================================================
    // DEBUG
    // =========================================================
    public void imprimir() {

        System.out.println();

        System.out.println(
                "=== MARCO PRINCIPAL PIG ==="
        );

        System.out.println(
                "Tamano Stack: "
                + getTamano()
        );

        for (VariableMemoriaPig variable
                : variables) {

            System.out.println(
                    "    " + variable
            );
        }

        System.out.println(
                "=== FIN MARCO PRINCIPAL PIG ==="
        );
    }
}
