/*
 */
package elmer.compi2.zetariano.imports;

import elmer.compi2.zetariano.analysis.symbol.CategoriaSimbolo;
import elmer.compi2.zetariano.analysis.symbol.EstructuraDef.EstructuraDef;
import elmer.compi2.zetariano.analysis.symbol.ParametroInfo;
import elmer.compi2.zetariano.analysis.symbol.Simbolo.Simbolo;
import elmer.compi2.zetariano.analysis.symbol.TipoDato;
import elmer.compi2.zetariano.analysis.semantic.SemanticoY;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 */
public class AdaptadorImportYPig {

    public void importar(
            SemanticoY semanticoY,
            RegistroImportsPig registro) {

        if (semanticoY == null
                || registro == null) {

            return;
        }

        // =====================================================
        // 1. IMPORTAR ESTRUCTURAS
        // =====================================================
        for (Map.Entry<String, EstructuraDef> entrada
                : semanticoY.getEstructuras().entrySet()) {

            EstructuraDef estructuraY
                    = entrada.getValue();

            ClaseImportadaPig clasePig
                    = new ClaseImportadaPig(
                            estructuraY.getNombre(),
                            TipoImportPig.Y
                    );

            for (Simbolo atributoY
                    : estructuraY.getAtributosOrdenados()) {

                String tipo
                        = describirTipoAtributo(
                                atributoY
                        );

                int dimensiones
                        = atributoY.getDimensiones().size();

                AtributoImportadoPig atributoPig
                        = new AtributoImportadoPig(
                                atributoY.getNombre(),
                                tipo,
                                dimensiones
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
        // 2. IMPORTAR FUNCIONES
        // =====================================================
        for (Simbolo simbolo
                : semanticoY.getTabla().getSimbolos()) {

            if (simbolo.getCategoria()
                    != CategoriaSimbolo.FUNCION) {

                continue;
            }

            String nombre
                    = simbolo.getNombre();

            String retorno
                    = describirTipoSimbolo(
                            simbolo
                    );

            List<String> tiposParametros
                    = new ArrayList<>();

            for (ParametroInfo parametro
                    : simbolo.getParametrosInfo()) {

                tiposParametros.add(
                        describirParametro(
                                parametro
                        )
                );
            }

            String firma
                    = construirFirma(
                            nombre,
                            tiposParametros
                    );

            ClaseImportadaPig contenedor
                    = registro.buscarClase(
                            "$Y_GLOBAL"
                    );

            if (contenedor == null) {

                contenedor
                        = new ClaseImportadaPig(
                                "$Y_GLOBAL",
                                TipoImportPig.Y
                        );

                registro.registrarClase(
                        contenedor
                );
            }

            MetodoImportadoPig funcionPig
                    = new MetodoImportadoPig(
                            nombre,
                            firma,
                            retorno,
                            tiposParametros,
                            false
                    );

            contenedor.registrarMetodo(
                    funcionPig
            );
        }
    }

    // =========================================================
    // CONVERTIR TIPO Y -> TIPO COMUN PIG
    // =========================================================
    private String describirTipoAtributo(
            Simbolo simbolo) {

        TipoDato tipo;

        if (simbolo.getTipo()
                == TipoDato.ARREGLO) {

            tipo = simbolo.getTipoElemento();

        } else {

            tipo = simbolo.getTipo();
        }

        // Estructura definida por el usuario
        if (tipo == TipoDato.ESTRUCTURA) {

            String referencia
                    = simbolo.getTipoReferencia();

            return referencia == null
                    ? "any"
                    : referencia;
        }

        return convertirTipo(
                tipo
        );
    }

    // =========================================================
    // TIPOS Y -> TIPOS DE IMPORTACION PIG
    // =========================================================
    private String convertirTipo(
            TipoDato tipo) {

        if (tipo == null) {
            return "any";
        }

        return switch (tipo) {

            case ENTERO ->
                "int";

            case DECIMAL ->
                "float";

            case CADENA ->
                "string";

            case CARACTER ->
                "char";

            case BOOLEANO ->
                "bool";

            case VOID ->
                "void";

            default ->
                "any";
        };
    }

    // =========================================================
    // TIPO COMPLETO DE UN SIMBOLO
    // =========================================================
    private String describirTipoSimbolo(
            Simbolo simbolo) {

        if (simbolo == null) {
            return "any";
        }

        if (simbolo.getTipo()
                == TipoDato.ESTRUCTURA) {

            return simbolo.getTipoReferencia() == null
                    ? "any"
                    : simbolo.getTipoReferencia();
        }

        if (simbolo.getTipo()
                == TipoDato.ARREGLO) {

            String base;

            if (simbolo.getTipoElemento()
                    == TipoDato.ESTRUCTURA) {

                base = simbolo.getTipoReferencia() == null
                        ? "any"
                        : simbolo.getTipoReferencia();

            } else {

                base = convertirTipo(
                        simbolo.getTipoElemento()
                );
            }

            StringBuilder resultado
                    = new StringBuilder(base);

            for (int i = 0;
                    i < simbolo.getDimensiones().size();
                    i++) {

                resultado.append("[]");
            }

            return resultado.toString();
        }

        return convertirTipo(
                simbolo.getTipo()
        );
    }

    // =========================================================
    // TIPO DE PARAMETRO
    // =========================================================
    private String describirParametro(
            ParametroInfo parametro) {

        if (parametro == null) {
            return "any";
        }

        if (parametro.getTipo()
                == TipoDato.ESTRUCTURA) {

            return parametro.getTipoReferencia() == null
                    ? "any"
                    : parametro.getTipoReferencia();
        }

        if (parametro.getTipo()
                == TipoDato.ARREGLO) {

            String base;

            if (parametro.getTipoElemento()
                    == TipoDato.ESTRUCTURA) {

                base = parametro.getTipoReferencia() == null
                        ? "any"
                        : parametro.getTipoReferencia();

            } else {

                base = convertirTipo(
                        parametro.getTipoElemento()
                );
            }

            return base + "[]";
        }

        return convertirTipo(
                parametro.getTipo()
        );
    }

    // =========================================================
    // CONSTRUIR FIRMA
    // =========================================================
    private String construirFirma(
            String nombre,
            List<String> parametros) {

        return nombre
                + "("
                + String.join(
                        ",",
                        parametros
                )
                + ")";
    }
}
