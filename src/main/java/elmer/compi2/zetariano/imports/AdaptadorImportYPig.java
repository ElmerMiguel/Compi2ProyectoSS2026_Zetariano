package elmer.compi2.zetariano.imports;

import elmer.compi2.zetariano.analysis.symbol.SymbolKind;
import elmer.compi2.zetariano.analysis.symbol.StructDef;
import elmer.compi2.zetariano.analysis.symbol.ParamInfo;
import elmer.compi2.zetariano.analysis.symbol.Symbol;
import elmer.compi2.zetariano.analysis.symbol.DataType;
import elmer.compi2.zetariano.analysis.semantic.YAnalyzer;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Adaptador para importar estructuras y funciones de Y hacia Pig Latin.
 */
public class AdaptadorImportYPig {

    public void importar(YAnalyzer semanticoY, RegistroImportsPig registro) {
        if (semanticoY == null || registro == null) {
            return;
        }

        // 1. IMPORTAR ESTRUCTURAS
        for (Map.Entry<String, StructDef> entrada : semanticoY.getEstructuras().entrySet()) {
            StructDef estructuraY = entrada.getValue();
            ClaseImportadaPig clasePig = new ClaseImportadaPig(
                    estructuraY.getNombre(),
                    TipoImportPig.Y
            );

            for (Symbol atributoY : estructuraY.getAtributosOrdenados()) {
                String tipo = describirTipoAtributo(atributoY);
                int dimensiones = atributoY.getDimensiones().size();
                AtributoImportadoPig atributoPig = new AtributoImportadoPig(
                        atributoY.getNombre(),
                        tipo,
                        dimensiones
                );
                clasePig.registrarAtributo(atributoPig);
            }

            registro.registrarClase(clasePig);
        }

        // 2. IMPORTAR FUNCIONES
        for (Symbol simbolo : semanticoY.getTabla().getSimbolos()) {
            if (simbolo.getCategoria() != SymbolKind.FUNCION) {
                continue;
            }

            String nombre = simbolo.getNombre();
            String retorno = describirTipoSimbolo(simbolo);
            List<String> tiposParametros = new ArrayList<>();

            for (ParamInfo parametro : simbolo.getParametrosInfo()) {
                tiposParametros.add(describirParametro(parametro));
            }

            String firma = construirFirma(nombre, tiposParametros);
            ClaseImportadaPig contenedor = registro.buscarClase("$Y_GLOBAL");

            if (contenedor == null) {
                contenedor = new ClaseImportadaPig("$Y_GLOBAL", TipoImportPig.Y);
                registro.registrarClase(contenedor);
            }

            MetodoImportadoPig funcionPig = new MetodoImportadoPig(
                    nombre,
                    firma,
                    retorno,
                    tiposParametros,
                    false
            );

            contenedor.registrarMetodo(funcionPig);
        }
    }

    private String describirTipoAtributo(Symbol simbolo) {
        DataType tipo = (simbolo.getTipo() == DataType.ARREGLO)
                ? simbolo.getTipoElemento()
                : simbolo.getTipo();

        if (tipo == DataType.ESTRUCTURA) {
            String referencia = simbolo.getTipoReferencia();
            return (referencia == null) ? "any" : referencia;
        }

        return convertirTipo(tipo);
    }

    private String convertirTipo(DataType tipo) {
        if (tipo == null) {
            return "any";
        }

        return switch (tipo) {
            case ENTERO -> "int";
            case DECIMAL -> "float";
            case CADENA -> "string";
            case CARACTER -> "char";
            case BOOLEANO -> "bool";
            case VOID -> "void";
            default -> "any";
        };
    }

    private String describirTipoSimbolo(Symbol simbolo) {
        if (simbolo == null) {
            return "any";
        }

        if (simbolo.getTipo() == DataType.ESTRUCTURA) {
            return (simbolo.getTipoReferencia() == null) ? "any" : simbolo.getTipoReferencia();
        }

        if (simbolo.getTipo() == DataType.ARREGLO) {
            String base = (simbolo.getTipoElemento() == DataType.ESTRUCTURA)
                    ? (simbolo.getTipoReferencia() == null ? "any" : simbolo.getTipoReferencia())
                    : convertirTipo(simbolo.getTipoElemento());

            StringBuilder resultado = new StringBuilder(base);
            for (int i = 0; i < simbolo.getDimensiones().size(); i++) {
                resultado.append("[]");
            }
            return resultado.toString();
        }

        return convertirTipo(simbolo.getTipo());
    }

    private String describirParametro(ParamInfo parametro) {
        if (parametro == null) {
            return "any";
        }

        if (parametro.getTipo() == DataType.ESTRUCTURA) {
            return (parametro.getTipoReferencia() == null) ? "any" : parametro.getTipoReferencia();
        }

        if (parametro.getTipo() == DataType.ARREGLO) {
            String base = (parametro.getTipoElemento() == DataType.ESTRUCTURA)
                    ? (parametro.getTipoReferencia() == null ? "any" : parametro.getTipoReferencia())
                    : convertirTipo(parametro.getTipoElemento());
            return base + "[]";
        }

        return convertirTipo(parametro.getTipo());
    }

    private String construirFirma(String nombre, List<String> parametros) {
        return nombre + "(" + String.join(",", parametros) + ")";
    }
}
