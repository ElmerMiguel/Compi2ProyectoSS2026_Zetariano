/*
 */
package elmer.compi2.zetariano.runtime.zeta;

import elmer.compi2.zetariano.core.node.zeta.DeclaracionASTZ;
import java.util.ArrayList;
import java.util.Collections;
import java.util.IdentityHashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *
 */
public class MarcoMetodoZ {

    private final String firma;

    private final Map<String, VariableMemoriaZ> variablesBase;

    private final List<VariableMemoriaZ> variables;

    private final Map<DeclaracionASTZ, VariableMemoriaZ> localesPorDeclaracion;

    private int siguienteOffset;

    public MarcoMetodoZ(
            String firma) {

        this(
                firma,
                "any"
        );
    }

    public MarcoMetodoZ(
            String firma,
            String tipoRetorno) {

        this.firma = firma;

        this.variablesBase
                = new LinkedHashMap<>();

        this.variables
                = new ArrayList<>();

        this.localesPorDeclaracion
                = new IdentityHashMap<>();

        this.siguienteOffset = 0;

        registrarEspeciales(
                tipoRetorno
        );
    }

    // =========================================================
    // VARIABLES ESPECIALES
    // =========================================================
    private void registrarEspeciales(
            String tipoRetorno) {

        String tipoRetornoSeguro
                = tipoRetorno == null
                || tipoRetorno.isBlank()
                ? "any"
                : tipoRetorno;

        VariableMemoriaZ retorno
                = new VariableMemoriaZ(
                        "$retorno",
                        tipoRetornoSeguro,
                        0,
                        siguienteOffset++,
                        VariableMemoriaZ.Categoria.RETORNO
                );

        variablesBase.put(
                retorno.getNombre(),
                retorno
        );

        variables.add(
                retorno
        );

        VariableMemoriaZ thisRef
                = new VariableMemoriaZ(
                        "$this",
                        "object",
                        0,
                        siguienteOffset++,
                        VariableMemoriaZ.Categoria.THIS
                );

        variablesBase.put(
                thisRef.getNombre(),
                thisRef
        );

        variables.add(
                thisRef
        );
    }

    public VariableMemoriaZ registrarParametro(
            String nombre,
            String tipo,
            int dimensiones) {

        VariableMemoriaZ variable
                = new VariableMemoriaZ(
                        nombre,
                        tipo,
                        dimensiones,
                        siguienteOffset++,
                        VariableMemoriaZ.Categoria.PARAMETRO
                );

        variablesBase.put(
                nombre,
                variable
        );

        variables.add(
                variable
        );

        return variable;
    }

    public VariableMemoriaZ registrarLocal(
            DeclaracionASTZ declaracion) {

        if (declaracion == null) {
            return null;
        }

        VariableMemoriaZ variable
                = new VariableMemoriaZ(
                        declaracion.getNombre(),
                        declaracion.getTipo(),
                        declaracion.getDimensiones(),
                        siguienteOffset++,
                        VariableMemoriaZ.Categoria.LOCAL
                );

        variables.add(
                variable
        );

        localesPorDeclaracion.put(
                declaracion,
                variable
        );

        return variable;
    }

    public VariableMemoriaZ registrarLocal(
            String nombre,
            String tipo,
            int dimensiones) {

        VariableMemoriaZ variable
                = new VariableMemoriaZ(
                        nombre,
                        tipo,
                        dimensiones,
                        siguienteOffset++,
                        VariableMemoriaZ.Categoria.LOCAL
                );

        variables.add(
                variable
        );

        return variable;
    }

    public VariableMemoriaZ buscarBase(
            String nombre) {

        return variablesBase.get(
                nombre
        );
    }

    public VariableMemoriaZ buscarDeclaracion(
            DeclaracionASTZ declaracion) {

        return localesPorDeclaracion.get(
                declaracion
        );
    }

    public VariableMemoriaZ buscar(
            String nombre) {

        VariableMemoriaZ base
                = variablesBase.get(
                        nombre
                );

        if (base != null) {
            return base;
        }

        for (int i = variables.size() - 1;
                i >= 0;
                i--) {

            VariableMemoriaZ variable
                    = variables.get(i);

            if (variable.getCategoria()
                    == VariableMemoriaZ.Categoria.LOCAL
                    && variable.getNombre().equals(nombre)) {

                return variable;
            }
        }

        return null;
    }

    public VariableMemoriaZ getRetorno() {

        return variablesBase.get(
                "$retorno"
        );
    }

    public VariableMemoriaZ getThis() {

        return variablesBase.get(
                "$this"
        );
    }

    public String getFirma() {
        return firma;
    }

    public int getTamanoMarco() {
        return siguienteOffset;
    }

    public List<VariableMemoriaZ> getVariables() {

        return Collections.unmodifiableList(
                variables
        );
    }

    @Override
    public String toString() {

        StringBuilder sb
                = new StringBuilder();

        sb.append(
                "MarcoMetodoZ{firma='"
        );

        sb.append(firma);

        sb.append(
                "', tamano="
        );

        sb.append(
                getTamanoMarco()
        );

        sb.append("}");

        for (VariableMemoriaZ variable
                : variables) {

            sb.append("\n    ")
                    .append(variable);
        }

        return sb.toString();
    }
}
