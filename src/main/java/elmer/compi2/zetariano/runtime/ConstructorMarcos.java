/*
 */
package elmer.compi2.zetariano.runtime;

import elmer.compi2.zetariano.core.node.NodoAST;
import elmer.compi2.zetariano.core.node.TipoNodoAST;

/**
 *
 */
public class ConstructorMarcos {

    private final TablaMemoria tabla;

    public ConstructorMarcos() {
        tabla = new TablaMemoria();
    }

    public TablaMemoria construir(
            NodoAST raiz) {

        tabla.limpiar();

        recorrer(
                raiz,
                null
        );

        return tabla;
    }

    private void recorrer(
            NodoAST nodo,
            MarcoFuncion marcoActual) {

        if (nodo == null) {
            return;
        }

        if (nodo.getTipo()
                == TipoNodoAST.FUNCION) {

            MarcoFuncion nuevoMarco
                    = tabla.crearFuncion(
                            nodo.getValor()
                    );

            for (NodoAST hijo
                    : nodo.getHijos()) {

                recorrer(
                        hijo,
                        nuevoMarco
                );
            }

            return;
        }

        if (marcoActual != null
                && nodo.getTipo()
                == TipoNodoAST.PARAMETRO) {

            registrarParametro(
                    nodo,
                    marcoActual
            );
        }

        if (marcoActual != null
                && nodo.getTipo()
                == TipoNodoAST.DECLARACION_VARIABLE) {

            registrarVariable(
                    nodo,
                    marcoActual,
                    false
            );
        }

        if (marcoActual != null
                && nodo.getTipo()
                == TipoNodoAST.DECLARACION_ARREGLO) {

            registrarVariable(
                    nodo,
                    marcoActual,
                    true
            );
        }

        for (NodoAST hijo
                : nodo.getHijos()) {

            recorrer(
                    hijo,
                    marcoActual
            );
        }
    }

    private void registrarVariable(
            NodoAST nodo,
            MarcoFuncion marco,
            boolean arreglo) {

        String texto
                = nodo.getValor();

        String nombre
                = extraerNombre(texto);

        String tipo
                = extraerTipo(texto);

        boolean heap
                = arreglo
                || ClasificadorMemoria
                        .requiereHeap(tipo);

        marco.agregarVariable(
                nodo,
                nombre,
                tipo,
                heap
        );
    }

    private void registrarParametro(
            NodoAST nodo,
            MarcoFuncion marco) {

        String nombre
                = nodo.getValor();

        String tipo
                = obtenerTipoParametro(
                        nodo
                );

        String modo
                = obtenerModoParametro(
                        nodo
                );

        boolean referenciaHeap
                = modo.equals(
                        "REFERENCIA_ARREGLO"
                )
                || modo.equals(
                        "REFERENCIA_ESTRUCTURA"
                )
                || ClasificadorMemoria
                        .requiereHeap(tipo);

        marco.agregarVariable(
                nodo,
                nombre,
                tipo,
                referenciaHeap
        );
    }

    private String extraerNombre(
            String texto) {

        if (texto == null) {
            return "?";
        }

        int indice
                = texto.indexOf(":");

        if (indice == -1) {
            return texto.trim();
        }

        return texto
                .substring(0, indice)
                .trim();
    }

    private String extraerTipo(
            String texto) {

        if (texto == null) {
            return "?";
        }

        int indice
                = texto.indexOf(":");

        if (indice == -1) {
            return "?";
        }

        return texto
                .substring(indice + 1)
                .trim();
    }

    private String obtenerTipoParametro(
            NodoAST parametro) {

        for (NodoAST hijo
                : parametro.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.TIPO_PARAMETRO) {

                return hijo.getValor();
            }
        }

        return "desconocido";
    }

    private String obtenerModoParametro(
            NodoAST parametro) {

        for (NodoAST hijo
                : parametro.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.MODO_PARAMETRO) {

                return hijo.getValor();
            }
        }

        return "VALOR";
    }

}
