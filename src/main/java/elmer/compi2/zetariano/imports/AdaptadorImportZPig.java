/*
 */
package elmer.compi2.zetariano.imports;

import elmer.compi2.zetariano.runtime.zeta.AtributoMemoriaZ;
import elmer.compi2.zetariano.runtime.zeta.ClaseMemoriaZ;
import elmer.compi2.zetariano.runtime.zeta.MarcoMetodoZ;
import elmer.compi2.zetariano.runtime.zeta.TablaMemoriaZ;
import elmer.compi2.zetariano.runtime.zeta.VariableMemoriaZ;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 */
public class AdaptadorImportZPig {

    public void importar(
            TablaMemoriaZ tablaZ,
            RegistroImportsPig registro) {

        if (tablaZ == null
                || registro == null) {

            return;
        }

        // =====================================================
        // 1. IMPORTAR CLASES Y ATRIBUTOS
        // =====================================================
        for (ClaseMemoriaZ claseZ
                : tablaZ.getClases().values()) {

            ClaseImportadaPig clasePig
                    = new ClaseImportadaPig(
                            claseZ.getNombre(),
                            TipoImportPig.Z
                    );

            for (AtributoMemoriaZ atributoZ
                    : claseZ.getAtributos().values()) {

                AtributoImportadoPig atributoPig
                        = new AtributoImportadoPig(
                                atributoZ.getNombre(),
                                atributoZ.getTipo(),
                                atributoZ.getDimensiones()
                        );

                clasePig.registrarAtributo(
                        atributoPig
                );
            }

            registro.registrarClase(
                    clasePig
            );
        }

        // =====================================================
        // 2. IMPORTAR CONSTRUCTORES Y METODOS
        // =====================================================
        for (Map.Entry<String, MarcoMetodoZ> entrada
                : tablaZ.getMarcos().entrySet()) {

            MarcoMetodoZ marco
                    = entrada.getValue();

            String firma
                    = marco.getFirma();

            String nombre
                    = extraerNombreFirma(firma);

            List<String> tiposParametros
                    = obtenerTiposParametros(marco);

            ClaseImportadaPig claseDestino
                    = buscarClasePropietaria(
                            registro,
                            tablaZ,
                            nombre
                    );

            if (claseDestino == null) {

                continue;
            }

            boolean esConstructor
                    = nombre.equals(
                            claseDestino.getNombre()
                    );

            String tipoRetorno
                    = esConstructor
                            ? claseDestino.getNombre()
                            : obtenerTipoRetorno(marco);

            MetodoImportadoPig metodo
                    = new MetodoImportadoPig(
                            nombre,
                            firma,
                            tipoRetorno,
                            tiposParametros,
                            esConstructor
                    );

            claseDestino.registrarMetodo(
                    metodo
            );
        }
    }

    // =========================================================
    // BUSCAR CLASE PROPIETARIA
    // =========================================================
    private ClaseImportadaPig buscarClasePropietaria(
            RegistroImportsPig registro,
            TablaMemoriaZ tablaZ,
            String nombreMetodo) {

        ClaseImportadaPig directa
                = registro.buscarClase(
                        nombreMetodo
                );

        if (directa != null) {

            return directa;
        }

        ClaseImportadaPig unica = null;

        for (ClaseMemoriaZ claseZ
                : tablaZ.getClases().values()) {

            ClaseImportadaPig clase
                    = registro.buscarClase(
                            claseZ.getNombre()
                    );

            if (clase == null
                    || clase.getOrigen()
                    != TipoImportPig.Z) {

                continue;
            }

            if (unica != null) {

                // La tabla contiene más de una posible propietaria.
                return null;
            }

            unica = clase;
        }

        return unica;
    }

    // =========================================================
    // PARAMETROS
    // =========================================================
    private List<String> obtenerTiposParametros(
            MarcoMetodoZ marco) {

        List<String> tipos
                = new ArrayList<>();

        for (VariableMemoriaZ variable
                : marco.getVariables()) {

            if (variable.getCategoria()
                    != VariableMemoriaZ.Categoria.PARAMETRO) {

                continue;
            }

            tipos.add(
                    describirTipo(
                            variable.getTipo(),
                            variable.getDimensiones()
                    )
            );
        }

        return tipos;
    }

    // =========================================================
    // RETORNO
    // =========================================================
    private String obtenerTipoRetorno(
            MarcoMetodoZ marco) {

        VariableMemoriaZ retorno
                = marco.getRetorno();

        if (retorno == null) {
            return "any";
        }

        return describirTipo(
                retorno.getTipo(),
                retorno.getDimensiones()
        );
    }

    // =========================================================
    // FIRMA
    // =========================================================
    private String extraerNombreFirma(
            String firma) {

        if (firma == null) {
            return "";
        }

        int posicion
                = firma.indexOf('(');

        if (posicion < 0) {
            return firma;
        }

        return firma.substring(
                0,
                posicion
        );
    }

    private String describirTipo(
            String tipo,
            int dimensiones) {

        StringBuilder sb
                = new StringBuilder(
                        tipo == null
                                ? "any"
                                : tipo
                );

        for (int i = 0;
                i < dimensiones;
                i++) {

            sb.append("[]");
        }

        return sb.toString();
    }
}
