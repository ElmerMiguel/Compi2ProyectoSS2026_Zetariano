/*
 */
package elmer.compi2.zetariano.codegen;

import elmer.compi2.zetariano.core.node.NodoAST;
import elmer.compi2.zetariano.core.node.TipoNodoAST;
import elmer.compi2.zetariano.codegen.AtributoEstructuraC3D;
import elmer.compi2.zetariano.codegen.Cuadruplo;
import elmer.compi2.zetariano.codegen.GeneradorEtiquetas;
import elmer.compi2.zetariano.codegen.GeneradorTemporales;
import elmer.compi2.zetariano.codegen.ResultadoExpresion;
import elmer.compi2.zetariano.runtime.ConstructorMarcos;
import elmer.compi2.zetariano.runtime.MarcoFuncion;
import elmer.compi2.zetariano.runtime.TablaMemoria;
import elmer.compi2.zetariano.runtime.VariableMemoria;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Deque;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *
 */
public class GeneradorC3D {

    private final List<Cuadruplo> cuadruplos;

    private final GeneradorTemporales temporales;
    private final GeneradorEtiquetas etiquetas;

    private final Deque<String> pilaBreak;
    private final Deque<String> pilaContinue;

    private final Map<String, List<AtributoEstructuraC3D>> estructurasGlobales;

    private final Map<String, Map<String, List<AtributoEstructuraC3D>>> estructurasLocales;
    private final Map<String, NodoAST> funcionesAST;

    private TablaMemoria tablaMemoria;
    private MarcoFuncion marcoActual;
    private final Deque<Map<String, VariableMemoria>> pilaAmbitosVariables;

    public GeneradorC3D() {

        this.cuadruplos = new ArrayList<>();

        this.temporales = new GeneradorTemporales();
        this.etiquetas = new GeneradorEtiquetas();
        this.pilaBreak = new ArrayDeque<>();
        this.pilaContinue = new ArrayDeque<>();
        estructurasGlobales
                = new LinkedHashMap<>();

        estructurasLocales
                = new LinkedHashMap<>();
        this.tablaMemoria = null;
        this.marcoActual = null;
        this.funcionesAST
                = new LinkedHashMap<>();
        this.pilaAmbitosVariables
                = new ArrayDeque<>();
    }

    public List<Cuadruplo> generar(NodoAST raiz) {

        cuadruplos.clear();

        temporales.reiniciar();
        etiquetas.reiniciar();
        pilaBreak.clear();
        pilaContinue.clear();
        estructurasGlobales.clear();
        estructurasLocales.clear();

        funcionesAST.clear();

        registrarFuncionesAST(
                raiz
        );

        ConstructorMarcos constructorMarcos
                = new ConstructorMarcos();

        tablaMemoria
                = constructorMarcos.construir(raiz);

        marcoActual = null;

        procesarNodo(raiz);

        return Collections.unmodifiableList(cuadruplos);
    }

    public List<Cuadruplo> getCuadruplos() {
        return Collections.unmodifiableList(cuadruplos);
    }

    private void agregar(
            String operador,
            String argumento1,
            String argumento2,
            String resultado) {

        cuadruplos.add(
                new Cuadruplo(
                        operador,
                        argumento1,
                        argumento2,
                        resultado
                )
        );
    }

    private void procesarNodo(NodoAST nodo) {

        if (nodo == null) {
            return;
        }

        switch (nodo.getTipo()) {

            case PROGRAMA, SECCION_ESTRUCTURAS, SECCION_FUNCIONES -> {

                for (NodoAST hijo
                        : nodo.getHijos()) {

                    procesarNodo(hijo);
                }
            }

            case BLOQUE ->
                procesarBloque(nodo);

            case FUNCION ->
                procesarFuncion(nodo);

            case DECLARACION_VARIABLE ->
                procesarDeclaracion(nodo);

            case ASIGNACION ->
                procesarAsignacion(nodo);

            case RETORNO ->
                procesarRetorno(nodo);

            case LLAMADA_FUNCION ->
                procesarLlamadaComoSentencia(nodo);

            case IMPRIMIR ->
                procesarImpresion(nodo);

            case IF ->
                procesarIf(nodo);

            case WHILE ->
                procesarWhile(nodo);

            case DO_WHILE ->
                procesarDoWhile(nodo);

            case INCREMENTO ->
                procesarIncremento(nodo);

            case DECREMENTO ->
                procesarDecremento(nodo);

            case FOR ->
                procesarFor(nodo);

            case BREAK ->
                procesarBreak();

            case CONTINUE ->
                procesarContinue();

            case ELEGIR ->
                procesarElegir(nodo);

            case DECLARACION_ARREGLO ->
                procesarDeclaracionArregloHeap(nodo);

            case ESTRUCTURA ->
                registrarEstructura(nodo);

            default -> {
                // Se implementará por etapas.
            }
        }
    }

    private void procesarFuncion(
            NodoAST nodo) {

        String nombreFuncion
                = nodo.getValor();

        MarcoFuncion marcoAnterior
                = marcoActual;

        marcoActual
                = tablaMemoria.buscarFuncion(
                        nombreFuncion
                );

        /*
     * Ámbito exterior de la función.
     * Aquí viven parámetros.
         */
        entrarAmbitoVariables();

        // ============================================================
        // REGISTRAR PARAMETROS ACTIVOS
        // ============================================================
        for (NodoAST hijo
                : nodo.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.PARAMETRO) {

                registrarVariableActiva(
                        hijo
                );
            }
        }

        agregar(
                "FUNC_BEGIN",
                nombreFuncion,
                null,
                null
        );

        for (NodoAST hijo
                : nodo.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.TIPO_RETORNO) {
                continue;
            }

            if (hijo.getTipo()
                    == TipoNodoAST.PARAMETRO) {
                continue;
            }

            procesarNodo(hijo);
        }

        agregar(
                "FUNC_END",
                nombreFuncion,
                null,
                null
        );

        salirAmbitoVariables();

        marcoActual
                = marcoAnterior;
    }

    private void procesarDeclaracion(NodoAST nodo) {

        String nombre
                = extraerNombreVariable(
                        nodo.getValor()
                );

        if (nodo.cantidadHijos() == 0) {

            String tipo
                    = extraerTipoVariable(
                            nodo.getValor()
                    );

            // ============================================================
            // 1. CADENA SIN INICIALIZAR
            // ============================================================
            if (esTipoCadena(tipo)) {

                String puntero
                        = temporales.nuevoTemporal();

                agregar(
                        "=",
                        "H",
                        null,
                        puntero
                );

                agregar(
                        "HEAP_SET",
                        "-1",
                        null,
                        "H"
                );

                agregar(
                        "+",
                        "H",
                        "1",
                        "H"
                );

                escribirVariableStack(
                        nombre,
                        puntero
                );

                return;
            }

            // ============================================================
            // 2. ESTRUCTURA SIN INICIALIZAR
            // ============================================================
            if (buscarEstructuraC3D(tipo) != null) {

                String puntero
                        = reservarEstructuraHeap(
                                tipo
                        );

                if (puntero == null) {
                    return;
                }

                guardarPunteroEstructuraStack(
                        nombre,
                        puntero
                );

                inicializarEstructuraPorDefecto(
                        tipo,
                        puntero
                );

                return;
            }

            // ============================================================
            // 3. PRIMITIVOS SIN INICIALIZAR
            // ============================================================
            escribirVariableStack(
                    nombre,
                    "0"
            );

            return;
        }

        NodoAST inicializador
                = nodo.getHijo(
                        nodo.cantidadHijos() - 1
                );

        if (inicializador.getTipo()
                == TipoNodoAST.INICIALIZADOR_LISTA) {

            String tipoEstructura
                    = extraerTipoVariable(
                            nodo.getValor()
                    );

            String puntero
                    = reservarEstructuraHeap(
                            tipoEstructura
                    );

            if (puntero == null) {
                return;
            }

            guardarPunteroEstructuraStack(
                    nombre,
                    puntero
            );

            generarInicializadorEstructuraHeap(
                    tipoEstructura,
                    inicializador,
                    puntero
            );

            return;
        }

        ResultadoExpresion resultado
                = generarExpresion(inicializador);

        escribirVariableStack(
                nombre,
                resultado.getValor()
        );
    }

    private void inicializarEstructuraPorDefecto(
            String tipoEstructura,
            String punteroBase) {

        List<AtributoEstructuraC3D> atributos
                = buscarEstructuraC3D(
                        tipoEstructura
                );

        if (atributos == null) {
            return;
        }

        for (AtributoEstructuraC3D atributo
                : atributos) {

            String direccion
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    punteroBase,
                    String.valueOf(
                            atributo.getOffset()
                    ),
                    direccion
            );

            String tipoAtributo
                    = atributo.getTipo();

            // ========================================================
            // 1. ARREGLO
            // ========================================================
            if (atributo.esArreglo()) {

                String punteroArreglo
                        = reservarArregloHeapConstante(
                                atributo.getDimensiones()
                        );

                if (punteroArreglo == null) {

                    agregar(
                            "HEAP_SET",
                            "0",
                            null,
                            direccion
                    );

                    continue;
                }

                // Guardamos el puntero del arreglo
                // en el atributo de la estructura.
                agregar(
                        "HEAP_SET",
                        punteroArreglo,
                        null,
                        direccion
                );

                // ====================================================
                // ARREGLO DE CADENAS
                // ====================================================
                if (esTipoCadena(
                        tipoAtributo)) {

                    inicializarArregloCadenasLocalPorDefecto(
                            punteroArreglo
                    );

                    continue;
                }

                // ====================================================
                // ARREGLO DE ESTRUCTURAS
                // ====================================================
                if (buscarEstructuraC3D(
                        tipoAtributo
                ) != null) {

                    inicializarArregloEstructurasPorDefecto(
                            punteroArreglo,
                            tipoAtributo,
                            atributo.getDimensiones()
                    );

                    continue;
                }

                continue;
            }

            // ========================================================
            // 2. CADENA SIMPLE
            // ========================================================
            if (esTipoCadena(
                    tipoAtributo)) {

                String punteroCadena
                        = temporales.nuevoTemporal();

                agregar(
                        "=",
                        "H",
                        null,
                        punteroCadena
                );

                agregar(
                        "HEAP_SET",
                        "-1",
                        null,
                        "H"
                );

                agregar(
                        "+",
                        "H",
                        "1",
                        "H"
                );

                agregar(
                        "HEAP_SET",
                        punteroCadena,
                        null,
                        direccion
                );

                continue;
            }

            // ========================================================
            // 3. ESTRUCTURA ANIDADA
            // ========================================================
            if (buscarEstructuraC3D(
                    tipoAtributo
            ) != null) {

                String punteroAnidado
                        = reservarEstructuraHeap(
                                tipoAtributo
                        );

                if (punteroAnidado != null) {

                    agregar(
                            "HEAP_SET",
                            punteroAnidado,
                            null,
                            direccion
                    );

                    inicializarEstructuraPorDefecto(
                            tipoAtributo,
                            punteroAnidado
                    );
                }

                continue;
            }

            // ========================================================
            // 4. PRIMITIVO
            // ========================================================
            agregar(
                    "HEAP_SET",
                    "0",
                    null,
                    direccion
            );
        }
    }

    private void inicializarArregloEstructurasPorDefecto(
            String punteroArreglo,
            String tipoElemento,
            List<Integer> dimensiones) {

        if (punteroArreglo == null
                || tipoElemento == null
                || dimensiones == null
                || dimensiones.isEmpty()) {

            return;
        }

        // Cantidad total de posiciones:
        // [2][3] = 6 elementos
        int total = 1;

        for (Integer dimension : dimensiones) {

            if (dimension == null
                    || dimension <= 0) {
                return;
            }

            total *= dimension;
        }

        String inicioDatos
                = generarInicioDatosArreglo(
                        punteroArreglo
                );

        for (int i = 0;
                i < total;
                i++) {

            // Reservamos una estructura REAL para esta posición.
            String punteroEstructura
                    = reservarEstructuraHeap(
                            tipoElemento
                    );

            if (punteroEstructura == null) {
                continue;
            }

            inicializarEstructuraPorDefecto(
                    tipoElemento,
                    punteroEstructura
            );

            String direccionElemento
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    inicioDatos,
                    String.valueOf(i),
                    direccionElemento
            );

            agregar(
                    "HEAP_SET",
                    punteroEstructura,
                    null,
                    direccionElemento
            );
        }
    }

    private void inicializarArregloEstructurasLocalPorDefecto(
            String punteroArreglo,
            String tipoElemento) {

        if (punteroArreglo == null
                || tipoElemento == null
                || buscarEstructuraC3D(tipoElemento) == null) {

            return;
        }

        // ============================================================
        // OBTENER RANGO DEL ARREGLO
        // Heap[base] = cantidad de dimensiones
        // ============================================================
        String rango
                = temporales.nuevoTemporal();

        agregar(
                "HEAP_GET",
                punteroArreglo,
                null,
                rango
        );

        // ============================================================
        // CALCULAR TOTAL DE ELEMENTOS
        // total = dim1 * dim2 * ... * dimN
        // ============================================================
        String total
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "1",
                null,
                total
        );

        String indiceDimension
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "0",
                null,
                indiceDimension
        );

        String etiquetaDimensiones
                = etiquetas.nuevaEtiqueta();

        String etiquetaFinDimensiones
                = etiquetas.nuevaEtiqueta();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaDimensiones
        );

        String condicionDimension
                = temporales.nuevoTemporal();

        agregar(
                "<",
                indiceDimension,
                rango,
                condicionDimension
        );

        agregar(
                "IF_FALSE",
                condicionDimension,
                null,
                etiquetaFinDimensiones
        );

        // base + 1
        String inicioDimensiones
                = temporales.nuevoTemporal();

        agregar(
                "+",
                punteroArreglo,
                "1",
                inicioDimensiones
        );

        // base + 1 + i
        String direccionDimension
                = temporales.nuevoTemporal();

        agregar(
                "+",
                inicioDimensiones,
                indiceDimension,
                direccionDimension
        );

        String valorDimension
                = temporales.nuevoTemporal();

        agregar(
                "HEAP_GET",
                direccionDimension,
                null,
                valorDimension
        );

        String nuevoTotal
                = temporales.nuevoTemporal();

        agregar(
                "*",
                total,
                valorDimension,
                nuevoTotal
        );

        agregar(
                "=",
                nuevoTotal,
                null,
                total
        );

        String siguienteDimension
                = temporales.nuevoTemporal();

        agregar(
                "+",
                indiceDimension,
                "1",
                siguienteDimension
        );

        agregar(
                "=",
                siguienteDimension,
                null,
                indiceDimension
        );

        agregar(
                "GOTO",
                null,
                null,
                etiquetaDimensiones
        );

        agregar(
                "LABEL",
                null,
                null,
                etiquetaFinDimensiones
        );

        // ============================================================
        // INICIO DE LOS DATOS
        // base + rango + 1
        // ============================================================
        String desplazamientoDatos
                = temporales.nuevoTemporal();

        agregar(
                "+",
                rango,
                "1",
                desplazamientoDatos
        );

        String inicioDatos
                = temporales.nuevoTemporal();

        agregar(
                "+",
                punteroArreglo,
                desplazamientoDatos,
                inicioDatos
        );

        // ============================================================
        // CREAR UNA ESTRUCTURA PARA CADA ELEMENTO
        // ============================================================
        String indiceElemento
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "0",
                null,
                indiceElemento
        );

        String etiquetaElementos
                = etiquetas.nuevaEtiqueta();

        String etiquetaFinElementos
                = etiquetas.nuevaEtiqueta();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaElementos
        );

        String condicionElemento
                = temporales.nuevoTemporal();

        agregar(
                "<",
                indiceElemento,
                total,
                condicionElemento
        );

        agregar(
                "IF_FALSE",
                condicionElemento,
                null,
                etiquetaFinElementos
        );

        // En tiempo de ejecución, cada iteración obtiene
        // el H actual, por lo que cada Persona será diferente.
        String punteroEstructura
                = reservarEstructuraHeap(
                        tipoElemento
                );

        if (punteroEstructura != null) {

            inicializarEstructuraPorDefecto(
                    tipoElemento,
                    punteroEstructura
            );

            String direccionElemento
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    inicioDatos,
                    indiceElemento,
                    direccionElemento
            );

            agregar(
                    "HEAP_SET",
                    punteroEstructura,
                    null,
                    direccionElemento
            );
        }

        String siguienteElemento
                = temporales.nuevoTemporal();

        agregar(
                "+",
                indiceElemento,
                "1",
                siguienteElemento
        );

        agregar(
                "=",
                siguienteElemento,
                null,
                indiceElemento
        );

        agregar(
                "GOTO",
                null,
                null,
                etiquetaElementos
        );

        agregar(
                "LABEL",
                null,
                null,
                etiquetaFinElementos
        );
    }

    private void inicializarArregloCadenasLocalPorDefecto(
            String punteroArreglo) {

        if (punteroArreglo == null) {
            return;
        }

        // ============================================================
        // OBTENER RANGO
        // ============================================================
        String rango
                = temporales.nuevoTemporal();

        agregar(
                "HEAP_GET",
                punteroArreglo,
                null,
                rango
        );

        // ============================================================
        // CALCULAR TOTAL DE ELEMENTOS
        // ============================================================
        String total
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "1",
                null,
                total
        );

        String indiceDimension
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "0",
                null,
                indiceDimension
        );

        String etiquetaDimensiones
                = etiquetas.nuevaEtiqueta();

        String etiquetaFinDimensiones
                = etiquetas.nuevaEtiqueta();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaDimensiones
        );

        String condicionDimension
                = temporales.nuevoTemporal();

        agregar(
                "<",
                indiceDimension,
                rango,
                condicionDimension
        );

        agregar(
                "IF_FALSE",
                condicionDimension,
                null,
                etiquetaFinDimensiones
        );

        String inicioDimensiones
                = temporales.nuevoTemporal();

        agregar(
                "+",
                punteroArreglo,
                "1",
                inicioDimensiones
        );

        String direccionDimension
                = temporales.nuevoTemporal();

        agregar(
                "+",
                inicioDimensiones,
                indiceDimension,
                direccionDimension
        );

        String valorDimension
                = temporales.nuevoTemporal();

        agregar(
                "HEAP_GET",
                direccionDimension,
                null,
                valorDimension
        );

        String nuevoTotal
                = temporales.nuevoTemporal();

        agregar(
                "*",
                total,
                valorDimension,
                nuevoTotal
        );

        agregar(
                "=",
                nuevoTotal,
                null,
                total
        );

        String siguienteDimension
                = temporales.nuevoTemporal();

        agregar(
                "+",
                indiceDimension,
                "1",
                siguienteDimension
        );

        agregar(
                "=",
                siguienteDimension,
                null,
                indiceDimension
        );

        agregar(
                "GOTO",
                null,
                null,
                etiquetaDimensiones
        );

        agregar(
                "LABEL",
                null,
                null,
                etiquetaFinDimensiones
        );

        // ============================================================
        // INICIO DE LOS DATOS
        // ============================================================
        String desplazamiento
                = temporales.nuevoTemporal();

        agregar(
                "+",
                rango,
                "1",
                desplazamiento
        );

        String inicioDatos
                = temporales.nuevoTemporal();

        agregar(
                "+",
                punteroArreglo,
                desplazamiento,
                inicioDatos
        );

        // ============================================================
        // INICIALIZAR CADA POSICION CON CADENA VACIA
        // ============================================================
        String indice
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "0",
                null,
                indice
        );

        String etiquetaInicio
                = etiquetas.nuevaEtiqueta();

        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaInicio
        );

        String condicion
                = temporales.nuevoTemporal();

        agregar(
                "<",
                indice,
                total,
                condicion
        );

        agregar(
                "IF_FALSE",
                condicion,
                null,
                etiquetaFin
        );

        // Crear cadena vacía.
        String punteroCadena
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "H",
                null,
                punteroCadena
        );

        agregar(
                "HEAP_SET",
                "-1",
                null,
                "H"
        );

        agregar(
                "+",
                "H",
                "1",
                "H"
        );

        // Guardar puntero de la cadena en el arreglo.
        String direccionElemento
                = temporales.nuevoTemporal();

        agregar(
                "+",
                inicioDatos,
                indice,
                direccionElemento
        );

        agregar(
                "HEAP_SET",
                punteroCadena,
                null,
                direccionElemento
        );

        String siguiente
                = temporales.nuevoTemporal();

        agregar(
                "+",
                indice,
                "1",
                siguiente
        );

        agregar(
                "=",
                siguiente,
                null,
                indice
        );

        agregar(
                "GOTO",
                null,
                null,
                etiquetaInicio
        );

        agregar(
                "LABEL",
                null,
                null,
                etiquetaFin
        );
    }

    private String extraerTipoVariable(
            String valor) {

        if (valor == null) {
            return "?";
        }

        int indice = valor.indexOf(":");

        if (indice == -1) {
            return "?";
        }

        return valor.substring(
                indice + 1
        ).trim();
    }

    private void procesarAsignacion(
            NodoAST nodo) {

        if (nodo == null
                || nodo.cantidadHijos() < 2) {
            return;
        }

        NodoAST destino
                = nodo.getHijo(0);

        NodoAST expresion
                = nodo.getHijo(1);

        ResultadoExpresion valor
                = generarExpresion(
                        expresion
                );

        if (destino.getTipo()
                == TipoNodoAST.ACCESO_VARIABLE) {

            escribirVariableStack(
                    destino.getValor(),
                    valor.getValor()
            );

            return;
        }

        if (destino.getTipo()
                == TipoNodoAST.ACCESO_ARREGLO) {

            String direccion
                    = generarDireccionElementoArreglo(
                            destino
                    );

            if (direccion != null) {

                agregar(
                        "HEAP_SET",
                        valor.getValor(),
                        null,
                        direccion
                );

                return;
            }
        }

        if (destino.getTipo()
                == TipoNodoAST.ACCESO_ATRIBUTO) {

            String direccion
                    = generarDireccionAtributoGeneral(
                            destino
                    );

            if (direccion != null) {

                agregar(
                        "HEAP_SET",
                        valor.getValor(),
                        null,
                        direccion
                );

                return;
            }
        }

        agregar(
                "=",
                valor.getValor(),
                null,
                generarAccesoSimple(destino)
        );
    }

    private void procesarRetorno(
            NodoAST nodo) {

        if (nodo.cantidadHijos() == 0) {

            agregar(
                    "RETURN",
                    null,
                    null,
                    null
            );

            return;
        }

        ResultadoExpresion resultado
                = generarExpresion(
                        nodo.getHijo(0)
                );

        String direccionRetorno
                = temporales.nuevoTemporal();

        agregar(
                "+",
                "P",
                "0",
                direccionRetorno
        );

        agregar(
                "STACK_SET",
                resultado.getValor(),
                null,
                direccionRetorno
        );

        agregar(
                "RETURN",
                null,
                null,
                null
        );
    }

    private ResultadoExpresion generarExpresion(
            NodoAST nodo) {

        if (nodo == null) {
            return new ResultadoExpresion("?");
        }

        switch (nodo.getTipo()) {

            case LITERAL_ENTERO, LITERAL_DECIMAL, LITERAL_CARACTER, LITERAL_BOOLEANO -> {

                return new ResultadoExpresion(
                        nodo.getValor()
                );
            }

            case LITERAL_CADENA -> {

                String puntero
                        = generarCadenaHeap(
                                nodo.getValor()
                        );

                return new ResultadoExpresion(
                        puntero
                );
            }

            case ACCESO_VARIABLE -> {

                return new ResultadoExpresion(
                        leerVariableStack(
                                nodo.getValor()
                        )
                );
            }

            case ACCESO_ATRIBUTO -> {
                return generarLecturaAtributo(nodo);
            }

            case ACCESO_ARREGLO -> {

                return generarLecturaArreglo(
                        nodo
                );
            }

            case EXPRESION_BINARIA -> {

                return generarBinaria(nodo);
            }

            case EXPRESION_UNARIA -> {

                return generarUnaria(nodo);
            }

            case LLAMADA_FUNCION -> {
                return generarLlamadaFuncion(nodo);
            }

            case LECTURA -> {
                String temporal = temporales.nuevoTemporal();

                agregar(
                        "READ",
                        null,
                        null,
                        temporal
                );

                return new ResultadoExpresion(temporal);
            }

            default -> {

                return new ResultadoExpresion(
                        nodo.toString()
                );
            }
        }
    }

    private ResultadoExpresion generarBinaria(
            NodoAST nodo) {

        ResultadoExpresion izquierda
                = generarExpresion(
                        nodo.getHijo(0)
                );

        ResultadoExpresion derecha
                = generarExpresion(
                        nodo.getHijo(1)
                );

        // ============================================================
        // CONCATENACION DE CADENAS
        // ============================================================
        if ("+".equals(nodo.getValor())
                && esExpresionCadena(nodo.getHijo(0))
                && esExpresionCadena(nodo.getHijo(1))) {

            return generarConcatenacionCadena(
                    izquierda.getValor(),
                    derecha.getValor()
            );
        }

        // ============================================================
        // OPERACION BINARIA NORMAL
        // ============================================================
        String temporal
                = temporales.nuevoTemporal();

        agregar(
                nodo.getValor(),
                izquierda.getValor(),
                derecha.getValor(),
                temporal
        );

        return new ResultadoExpresion(
                temporal
        );
    }

    private ResultadoExpresion generarConcatenacionCadena(
            String izquierda,
            String derecha) {

        String resultado
                = temporales.nuevoTemporal();

        // resultado apunta al inicio de la nueva cadena
        agregar(
                "=",
                "H",
                null,
                resultado
        );

        // ============================================================
        // COPIAR CADENA IZQUIERDA
        // ============================================================
        String punteroIzquierdo
                = temporales.nuevoTemporal();

        agregar(
                "=",
                izquierda,
                null,
                punteroIzquierdo
        );

        String etiquetaIzquierda
                = etiquetas.nuevaEtiqueta();

        String etiquetaFinIzquierda
                = etiquetas.nuevaEtiqueta();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaIzquierda
        );

        String caracterIzquierdo
                = temporales.nuevoTemporal();

        agregar(
                "HEAP_GET",
                punteroIzquierdo,
                null,
                caracterIzquierdo
        );

        String condicionFinIzquierda
                = temporales.nuevoTemporal();

        agregar(
                "==",
                caracterIzquierdo,
                "-1",
                condicionFinIzquierda
        );

        agregar(
                "IF_TRUE",
                condicionFinIzquierda,
                null,
                etiquetaFinIzquierda
        );

        agregar(
                "HEAP_SET",
                caracterIzquierdo,
                null,
                "H"
        );

        agregar(
                "+",
                "H",
                "1",
                "H"
        );

        agregar(
                "+",
                punteroIzquierdo,
                "1",
                punteroIzquierdo
        );

        agregar(
                "GOTO",
                null,
                null,
                etiquetaIzquierda
        );

        agregar(
                "LABEL",
                null,
                null,
                etiquetaFinIzquierda
        );

        // ============================================================
        // COPIAR CADENA DERECHA
        // ============================================================
        String punteroDerecho
                = temporales.nuevoTemporal();

        agregar(
                "=",
                derecha,
                null,
                punteroDerecho
        );

        String etiquetaDerecha
                = etiquetas.nuevaEtiqueta();

        String etiquetaFinDerecha
                = etiquetas.nuevaEtiqueta();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaDerecha
        );

        String caracterDerecho
                = temporales.nuevoTemporal();

        agregar(
                "HEAP_GET",
                punteroDerecho,
                null,
                caracterDerecho
        );

        String condicionFinDerecha
                = temporales.nuevoTemporal();

        agregar(
                "==",
                caracterDerecho,
                "-1",
                condicionFinDerecha
        );

        agregar(
                "IF_TRUE",
                condicionFinDerecha,
                null,
                etiquetaFinDerecha
        );

        agregar(
                "HEAP_SET",
                caracterDerecho,
                null,
                "H"
        );

        agregar(
                "+",
                "H",
                "1",
                "H"
        );

        agregar(
                "+",
                punteroDerecho,
                "1",
                punteroDerecho
        );

        agregar(
                "GOTO",
                null,
                null,
                etiquetaDerecha
        );

        agregar(
                "LABEL",
                null,
                null,
                etiquetaFinDerecha
        );

        // ============================================================
        // FIN DE CADENA
        // ============================================================
        agregar(
                "HEAP_SET",
                "-1",
                null,
                "H"
        );

        agregar(
                "+",
                "H",
                "1",
                "H"
        );

        return new ResultadoExpresion(
                resultado
        );
    }

    private ResultadoExpresion generarUnaria(
            NodoAST nodo) {

        ResultadoExpresion operando
                = generarExpresion(
                        nodo.getHijo(0)
                );

        String temporal
                = temporales.nuevoTemporal();

        agregar(
                nodo.getValor(),
                operando.getValor(),
                null,
                temporal
        );

        return new ResultadoExpresion(
                temporal
        );
    }

    private String generarAccesoSimple(NodoAST nodo) {

        if (nodo == null) {
            return "?";
        }

        switch (nodo.getTipo()) {

            case ACCESO_VARIABLE -> {
                return nodo.getValor();
            }

            case ACCESO_ARREGLO -> {

                if (nodo.cantidadHijos() < 2) {
                    return "?";
                }

                String base
                        = generarAccesoSimple(
                                nodo.getHijo(0)
                        );

                ResultadoExpresion indice
                        = generarExpresion(
                                nodo.getHijo(1)
                        );

                return base
                        + "["
                        + indice.getValor()
                        + "]";
            }

            case ACCESO_ATRIBUTO -> {

                if (nodo.cantidadHijos() == 0) {
                    return "?";
                }

                String base
                        = generarAccesoSimple(
                                nodo.getHijo(0)
                        );

                return base
                        + "."
                        + nodo.getValor();
            }

            default -> {
                return nodo.toString();
            }
        }
    }

    private String extraerNombreVariable(
            String valor) {

        if (valor == null) {
            return "?";
        }

        int indice = valor.indexOf(":");

        if (indice == -1) {
            return valor.trim();
        }

        return valor.substring(
                0,
                indice
        ).trim();
    }

    private ResultadoExpresion generarLlamadaFuncion(
            NodoAST nodo) {

        return generarLlamadaFuncion(
                nodo,
                true
        );
    }

    private void procesarLlamadaComoSentencia(
            NodoAST nodo) {

        generarLlamadaFuncion(
                nodo,
                false
        );
    }

    private void procesarImpresion(
            NodoAST nodo) {

        for (NodoAST expresion : nodo.getHijos()) {

            ResultadoExpresion resultado
                    = generarExpresion(
                            expresion
                    );

            if (esExpresionCadena(expresion)) {

                agregar(
                        "PRINT_STRING",
                        resultado.getValor(),
                        null,
                        null
                );

            } else {

                agregar(
                        "PRINT",
                        resultado.getValor(),
                        null,
                        null
                );
            }
        }
    }

    private boolean esExpresionCadena(
            NodoAST nodo) {

        if (nodo == null) {
            return false;
        }

        switch (nodo.getTipo()) {

            case LITERAL_CADENA, LECTURA -> {
                return true;
            }

            case ACCESO_VARIABLE -> {

                String tipo
                        = obtenerTipoVariable(
                                nodo.getValor()
                        );

                return esTipoCadena(tipo);
            }

            case ACCESO_ATRIBUTO -> {

                String tipo
                        = obtenerTipoResultadoAtributo(
                                nodo
                        );

                return esTipoCadena(tipo);
            }

            case ACCESO_ARREGLO -> {

                String tipo
                        = obtenerTipoBaseAcceso(
                                nodo
                        );

                return esTipoCadena(tipo);
            }

            case LLAMADA_FUNCION -> {

                NodoAST funcion
                        = funcionesAST.get(
                                nodo.getValor()
                        );

                String tipoRetorno
                        = obtenerTipoRetornoFuncion(
                                funcion
                        );

                return esTipoCadena(
                        tipoRetorno
                );
            }

            case EXPRESION_BINARIA -> {

                if (!"+".equals(nodo.getValor())
                        || nodo.cantidadHijos() < 2) {

                    return false;
                }

                return esExpresionCadena(
                        nodo.getHijo(0)
                )
                        && esExpresionCadena(
                                nodo.getHijo(1)
                        );
            }

            default -> {
                return false;
            }
        }
    }

    private boolean esTipoCadena(
            String tipo) {

        if (tipo == null) {
            return false;
        }

        String normalizado
                = tipo.trim()
                        .toLowerCase();

        return normalizado.equals("cadena")
                || normalizado.equals("string");
    }

    private void procesarIf(NodoAST nodo) {

        if (nodo.cantidadHijos() < 2) {
            return;
        }

        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        procesarIfInterno(
                nodo,
                etiquetaFin
        );

        agregar(
                "LABEL",
                null,
                null,
                etiquetaFin
        );
    }

    private void procesarIfInterno(
            NodoAST nodo,
            String etiquetaFin) {

        NodoAST condicion
                = nodo.getHijo(0);

        NodoAST bloqueVerdadero
                = nodo.getHijo(1);

        String etiquetaFalsa
                = etiquetas.nuevaEtiqueta();

        ResultadoExpresion resultadoCondicion
                = generarExpresion(condicion);

        agregar(
                "IF_FALSE",
                resultadoCondicion.getValor(),
                null,
                etiquetaFalsa
        );

        procesarNodo(
                bloqueVerdadero
        );

        agregar(
                "GOTO",
                null,
                null,
                etiquetaFin
        );

        agregar(
                "LABEL",
                null,
                null,
                etiquetaFalsa
        );

        for (int i = 2;
                i < nodo.cantidadHijos();
                i++) {

            NodoAST alternativa
                    = nodo.getHijo(i);

            if (alternativa.getTipo()
                    == TipoNodoAST.IF) {

                procesarIfInterno(
                        alternativa,
                        etiquetaFin
                );

            } else if (alternativa.getTipo()
                    == TipoNodoAST.ELSE) {

                if (alternativa.cantidadHijos()
                        > 0) {

                    procesarNodo(
                            alternativa.getHijo(0)
                    );
                }
            }
        }
    }

    private void procesarWhile(
            NodoAST nodo) {

        if (nodo.cantidadHijos() < 2) {
            return;
        }

        String etiquetaInicio
                = etiquetas.nuevaEtiqueta();

        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaInicio
        );

        ResultadoExpresion condicion
                = generarExpresion(
                        nodo.getHijo(0)
                );

        agregar(
                "IF_FALSE",
                condicion.getValor(),
                null,
                etiquetaFin
        );

        pilaBreak.push(etiquetaFin);
        pilaContinue.push(etiquetaInicio);

        procesarNodo(
                nodo.getHijo(1)
        );

        pilaContinue.pop();
        pilaBreak.pop();

        agregar(
                "GOTO",
                null,
                null,
                etiquetaInicio
        );

        agregar(
                "LABEL",
                null,
                null,
                etiquetaFin
        );
    }

    private void procesarDoWhile(
            NodoAST nodo) {

        if (nodo.cantidadHijos() < 2) {
            return;
        }

        String etiquetaInicio
                = etiquetas.nuevaEtiqueta();

        String etiquetaCondicion
                = etiquetas.nuevaEtiqueta();

        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaInicio
        );

        pilaBreak.push(etiquetaFin);
        pilaContinue.push(etiquetaCondicion);

        procesarNodo(
                nodo.getHijo(0)
        );

        pilaContinue.pop();
        pilaBreak.pop();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaCondicion
        );

        ResultadoExpresion condicion
                = generarExpresion(
                        nodo.getHijo(1)
                );

        agregar(
                "IF_TRUE",
                condicion.getValor(),
                null,
                etiquetaInicio
        );

        agregar(
                "LABEL",
                null,
                null,
                etiquetaFin
        );
    }

    private void procesarIncremento(
            NodoAST nodo) {

        if (nodo == null
                || nodo.cantidadHijos() == 0) {
            return;
        }

        NodoAST acceso
                = nodo.getHijo(0);

        // ============================================================
        // 1. VARIABLE SIMPLE
        //    x++
        // ============================================================
        if (acceso.getTipo()
                == TipoNodoAST.ACCESO_VARIABLE) {

            String nombre
                    = acceso.getValor();

            String valorActual
                    = leerVariableStack(
                            nombre
                    );

            String nuevoValor
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    valorActual,
                    "1",
                    nuevoValor
            );

            escribirVariableStack(
                    nombre,
                    nuevoValor
            );

            return;
        }

        // ============================================================
        // 2. ELEMENTO DE ARREGLO
        //    numeros[i]++
        // ============================================================
        if (acceso.getTipo()
                == TipoNodoAST.ACCESO_ARREGLO) {

            String direccion
                    = generarDireccionElementoArreglo(
                            acceso
                    );

            if (direccion == null) {
                return;
            }

            String valorActual
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccion,
                    null,
                    valorActual
            );

            String nuevoValor
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    valorActual,
                    "1",
                    nuevoValor
            );

            agregar(
                    "HEAP_SET",
                    nuevoValor,
                    null,
                    direccion
            );

            return;
        }

        if (acceso.getTipo()
                == TipoNodoAST.ACCESO_ATRIBUTO) {

            String direccion
                    = generarDireccionAtributoGeneral(
                            acceso
                    );

            if (direccion == null) {
                return;
            }

            String valorActual
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccion,
                    null,
                    valorActual
            );

            String nuevoValor
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    valorActual,
                    "1",
                    nuevoValor
            );

            agregar(
                    "HEAP_SET",
                    nuevoValor,
                    null,
                    direccion
            );
        }
    }

    private void procesarDecremento(
            NodoAST nodo) {

        if (nodo.cantidadHijos() == 0) {
            return;
        }

        NodoAST acceso
                = nodo.getHijo(0);

        // ============================================================
        // 1. VARIABLE SIMPLE -> STACK
        // ============================================================
        if (acceso.getTipo()
                == TipoNodoAST.ACCESO_VARIABLE) {

            String nombre
                    = acceso.getValor();

            String valorActual
                    = leerVariableStack(
                            nombre
                    );

            String nuevoValor
                    = temporales.nuevoTemporal();

            agregar(
                    "-",
                    valorActual,
                    "1",
                    nuevoValor
            );

            escribirVariableStack(
                    nombre,
                    nuevoValor
            );

            return;
        }

        // ============================================================
        // 2. ELEMENTO DE ARREGLO -> HEAP
        // ============================================================
        if (acceso.getTipo()
                == TipoNodoAST.ACCESO_ARREGLO) {

            String direccion
                    = generarDireccionElementoArreglo(
                            acceso
                    );

            if (direccion == null) {
                return;
            }

            String valorActual
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccion,
                    null,
                    valorActual
            );

            String nuevoValor
                    = temporales.nuevoTemporal();

            agregar(
                    "-",
                    valorActual,
                    "1",
                    nuevoValor
            );

            agregar(
                    "HEAP_SET",
                    nuevoValor,
                    null,
                    direccion
            );

            return;
        }

        // ============================================================
        // 3. ATRIBUTO DE ESTRUCTURA -> HEAP
        // ============================================================
        if (acceso.getTipo()
                == TipoNodoAST.ACCESO_ATRIBUTO) {

            String direccion
                    = generarDireccionAtributoGeneral(
                            acceso
                    );

            if (direccion == null) {
                return;
            }

            String valorActual
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccion,
                    null,
                    valorActual
            );

            String nuevoValor
                    = temporales.nuevoTemporal();

            agregar(
                    "-",
                    valorActual,
                    "1",
                    nuevoValor
            );

            agregar(
                    "HEAP_SET",
                    nuevoValor,
                    null,
                    direccion
            );
        }
    }

    private void procesarBreak() {

        if (pilaBreak.isEmpty()) {
            return;
        }

        agregar(
                "GOTO",
                null,
                null,
                pilaBreak.peek()
        );
    }

    private void procesarContinue() {

        if (pilaContinue.isEmpty()) {
            return;
        }

        agregar(
                "GOTO",
                null,
                null,
                pilaContinue.peek()
        );
    }

    private void procesarFor(
            NodoAST nodo) {

        if (nodo.cantidadHijos() < 4) {
            return;
        }

        NodoAST inicializacionWrapper
                = nodo.getHijo(0);

        NodoAST condicionWrapper
                = nodo.getHijo(1);

        NodoAST actualizacionWrapper
                = nodo.getHijo(2);

        NodoAST bloque
                = nodo.getHijo(3);

        String etiquetaCondicion
                = etiquetas.nuevaEtiqueta();

        String etiquetaActualizacion
                = etiquetas.nuevaEtiqueta();

        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        entrarAmbitoVariables();

        // ============================================================
        // INICIALIZACION
        // ============================================================
        if (inicializacionWrapper.cantidadHijos() > 0) {

            NodoAST inicializacion
                    = inicializacionWrapper.getHijo(0);

            if (inicializacion.getTipo()
                    == TipoNodoAST.DECLARACION_VARIABLE
                    || inicializacion.getTipo()
                    == TipoNodoAST.DECLARACION_ARREGLO) {

                registrarVariableActiva(
                        inicializacion
                );
            }

            procesarNodo(
                    inicializacion
            );
        }

        // ============================================================
        // CONDICION
        // ============================================================
        agregar(
                "LABEL",
                null,
                null,
                etiquetaCondicion
        );

        if (condicionWrapper.cantidadHijos() > 0) {

            ResultadoExpresion resultadoCondicion
                    = generarExpresion(
                            condicionWrapper.getHijo(0)
                    );

            agregar(
                    "IF_FALSE",
                    resultadoCondicion.getValor(),
                    null,
                    etiquetaFin
            );
        }

        // ============================================================
        // CUERPO
        // ============================================================
        pilaBreak.push(
                etiquetaFin
        );

        pilaContinue.push(
                etiquetaActualizacion
        );

        procesarNodo(
                bloque
        );

        pilaContinue.pop();
        pilaBreak.pop();

        // ============================================================
        // ACTUALIZACION
        // ============================================================
        agregar(
                "LABEL",
                null,
                null,
                etiquetaActualizacion
        );

        if (actualizacionWrapper.cantidadHijos() > 0) {

            procesarNodo(
                    actualizacionWrapper.getHijo(0)
            );
        }

        agregar(
                "GOTO",
                null,
                null,
                etiquetaCondicion
        );

        agregar(
                "LABEL",
                null,
                null,
                etiquetaFin
        );

        salirAmbitoVariables();
    }

    private void procesarElegir(
            NodoAST nodo) {

        if (nodo.cantidadHijos() == 0) {
            return;
        }

        // ============================================================
        // SELECTOR
        // ============================================================
        ResultadoExpresion selector
                = generarExpresion(
                        nodo.getHijo(0)
                );

        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        pilaBreak.push(etiquetaFin);

        // ============================================================
        // OBTENER CASOS Y SIEMPRE
        // ============================================================
        List<NodoAST> casos
                = new ArrayList<>();

        NodoAST siempre
                = null;

        for (int i = 1;
                i < nodo.cantidadHijos();
                i++) {

            NodoAST hijo
                    = nodo.getHijo(i);

            if (hijo.getTipo()
                    == TipoNodoAST.CASO) {

                casos.add(hijo);

            } else if (hijo.getTipo()
                    == TipoNodoAST.SIEMPRE) {

                siempre = hijo;
            }
        }

        // ============================================================
        // ETIQUETAS PARA LOS CUERPOS
        // ============================================================
        List<String> etiquetasCasos
                = new ArrayList<>();

        for (int i = 0;
                i < casos.size();
                i++) {

            etiquetasCasos.add(
                    etiquetas.nuevaEtiqueta()
            );
        }

        String etiquetaSiempre
                = siempre != null
                        ? etiquetas.nuevaEtiqueta()
                        : etiquetaFin;

        // ============================================================
        // FASE 1:
        // BUSCAR QUÉ CASO COINCIDE
        // ============================================================
        for (int i = 0;
                i < casos.size();
                i++) {

            NodoAST casoActual
                    = casos.get(i);

            if (casoActual.cantidadHijos() < 2) {
                continue;
            }

            ResultadoExpresion valorCaso
                    = generarExpresion(
                            casoActual.getHijo(0)
                    );

            String temporalComparacion
                    = temporales.nuevoTemporal();

            agregar(
                    "==",
                    selector.getValor(),
                    valorCaso.getValor(),
                    temporalComparacion
            );

            String etiquetaNoCoincide
                    = etiquetas.nuevaEtiqueta();

            agregar(
                    "IF_FALSE",
                    temporalComparacion,
                    null,
                    etiquetaNoCoincide
            );

            // Si coincide, entra directamente
            // al cuerpo correspondiente.
            agregar(
                    "GOTO",
                    null,
                    null,
                    etiquetasCasos.get(i)
            );

            agregar(
                    "LABEL",
                    null,
                    null,
                    etiquetaNoCoincide
            );
        }

        // Ningún caso coincidió.
        agregar(
                "GOTO",
                null,
                null,
                etiquetaSiempre
        );

        for (int i = 0;
                i < casos.size();
                i++) {

            NodoAST casoActual
                    = casos.get(i);

            agregar(
                    "LABEL",
                    null,
                    null,
                    etiquetasCasos.get(i)
            );

            if (casoActual.cantidadHijos() >= 2) {

                procesarNodo(
                        casoActual.getHijo(1)
                );
            }
        }

        // ============================================================
        // SIEMPRE
        // ============================================================
        if (siempre != null) {

            agregar(
                    "LABEL",
                    null,
                    null,
                    etiquetaSiempre
            );

            if (siempre.cantidadHijos() > 0) {

                procesarNodo(
                        siempre.getHijo(0)
                );
            }
        }

        // ============================================================
        // FIN DEL ELEGIR
        // ============================================================
        pilaBreak.pop();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaFin
        );
    }

    private void procesarCasoElegir(
            NodoAST nodo,
            String selector) {

        if (nodo.cantidadHijos() < 2) {
            return;
        }

        String etiquetaSiguiente
                = etiquetas.nuevaEtiqueta();

        ResultadoExpresion valorCaso
                = generarExpresion(
                        nodo.getHijo(0)
                );

        String temporalComparacion
                = temporales.nuevoTemporal();

        agregar(
                "==",
                selector,
                valorCaso.getValor(),
                temporalComparacion
        );

        agregar(
                "IF_FALSE",
                temporalComparacion,
                null,
                etiquetaSiguiente
        );

        procesarNodo(
                nodo.getHijo(1)
        );

        agregar(
                "LABEL",
                null,
                null,
                etiquetaSiguiente
        );
    }

    private void procesarSiempreElegir(
            NodoAST nodo) {

        if (nodo.cantidadHijos() == 0) {
            return;
        }

        procesarNodo(
                nodo.getHijo(0)
        );
    }

    private void procesarDeclaracionArreglo(
            NodoAST nodo) {

        String nombre
                = extraerNombreVariable(
                        nodo.getValor()
                );

        agregar(
                "ARRAY_DECL",
                nombre,
                null,
                String.valueOf(contarDimensiones(nodo))
        );

        for (NodoAST hijo : nodo.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.DIMENSION) {

                ResultadoExpresion dimension;

                if (hijo.cantidadHijos() > 0) {

                    dimension
                            = generarExpresion(
                                    hijo.getHijo(0)
                            );

                } else {

                    dimension
                            = new ResultadoExpresion(
                                    hijo.getValor()
                            );
                }

                agregar(
                        "ARRAY_DIM",
                        nombre,
                        dimension.getValor(),
                        null
                );
            }
        }

        NodoAST inicializador
                = buscarInicializadorArreglo(nodo);

        if (inicializador != null) {

            generarInicializadorArreglo(
                    nombre,
                    inicializador,
                    new ArrayList<>()
            );
        }
    }

    private int contarDimensiones(
            NodoAST nodo) {

        int cantidad = 0;

        for (NodoAST hijo : nodo.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.DIMENSION) {

                cantidad++;
            }
        }

        return cantidad;
    }

    private NodoAST buscarInicializadorArreglo(
            NodoAST nodo) {

        for (NodoAST hijo : nodo.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.INICIALIZADOR_LISTA) {

                return hijo;
            }
        }

        return null;
    }

    private void generarInicializadorArreglo(
            String nombre,
            NodoAST nodo,
            List<Integer> indices) {

        if (nodo.getTipo()
                != TipoNodoAST.INICIALIZADOR_LISTA) {

            ResultadoExpresion valor
                    = generarExpresion(nodo);

            StringBuilder acceso
                    = new StringBuilder(nombre);

            for (Integer indice : indices) {

                acceso.append("[")
                        .append(indice)
                        .append("]");
            }

            agregar(
                    "=",
                    valor.getValor(),
                    null,
                    acceso.toString()
            );

            return;
        }

        for (int i = 0;
                i < nodo.cantidadHijos();
                i++) {

            List<Integer> nuevosIndices
                    = new ArrayList<>(indices);

            nuevosIndices.add(i);

            generarInicializadorArreglo(
                    nombre,
                    nodo.getHijo(i),
                    nuevosIndices
            );
        }
    }

    private void registrarEstructura(
            NodoAST nodo) {

        String nombreEstructura
                = nodo.getValor();

        List<AtributoEstructuraC3D> atributos
                = new ArrayList<>();

        for (NodoAST hijo
                : nodo.getHijos()) {

            if (hijo.getTipo()
                    != TipoNodoAST.ATRIBUTO_ESTRUCTURA) {

                continue;
            }

            String texto
                    = hijo.getValor();

            String[] partes
                    = texto.split(
                            "\\s*:\\s*",
                            2
                    );

            if (partes.length < 2) {
                continue;
            }

            String nombreAtributo
                    = partes[0].trim();

            String tipoAtributo
                    = partes[1].trim();

            List<Integer> dimensiones
                    = new ArrayList<>();

            for (NodoAST hijoAtributo
                    : hijo.getHijos()) {

                if (hijoAtributo.getTipo()
                        != TipoNodoAST.DIMENSION) {

                    continue;
                }

                if (hijoAtributo.cantidadHijos()
                        == 0) {

                    continue;
                }

                NodoAST valorDimension
                        = hijoAtributo.getHijo(0);

                try {

                    dimensiones.add(
                            Integer.parseInt(
                                    valorDimension.getValor()
                            )
                    );

                } catch (NumberFormatException ex) {

                }
            }

            atributos.add(
                    new AtributoEstructuraC3D(
                            nombreAtributo,
                            tipoAtributo,
                            atributos.size(),
                            dimensiones
                    )
            );
        }

        if (marcoActual == null) {

            // Estructura global.
            estructurasGlobales.put(
                    nombreEstructura,
                    atributos
            );

        } else {

            // Estructura local a una función.
            String nombreFuncion
                    = marcoActual.getNombre();

            Map<String, List<AtributoEstructuraC3D>> localesFuncion
                    = estructurasLocales.computeIfAbsent(
                            nombreFuncion,
                            clave -> new LinkedHashMap<>()
                    );

            localesFuncion.put(
                    nombreEstructura,
                    atributos
            );
        }
    }

    private void generarInicializadorEstructuraHeap(
            String tipoEstructura,
            NodoAST inicializador,
            String punteroBase) {

        List<AtributoEstructuraC3D> atributos
                = buscarEstructuraC3D(
                        tipoEstructura
                );

        if (atributos == null) {
            return;
        }

        int cantidad
                = Math.min(
                        atributos.size(),
                        inicializador.cantidadHijos()
                );

        for (int i = 0; i < cantidad; i++) {

            AtributoEstructuraC3D atributo
                    = atributos.get(i);

            NodoAST valor
                    = inicializador.getHijo(i);

            String direccionAtributo
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    punteroBase,
                    String.valueOf(
                            atributo.getOffset()
                    ),
                    direccionAtributo
            );

            if (atributo.esArreglo()) {

                if (valor.getTipo()
                        != TipoNodoAST.INICIALIZADOR_LISTA) {

                    continue;
                }

                generarInicializadorAtributoArreglo(
                        atributo,
                        valor,
                        direccionAtributo
                );

                continue;
            }

            if (valor.getTipo()
                    == TipoNodoAST.INICIALIZADOR_LISTA
                    && buscarEstructuraC3D(
                            atributo.getTipo()
                    ) != null) {

                String punteroAnidado
                        = reservarEstructuraHeap(
                                atributo.getTipo()
                        );

                agregar(
                        "HEAP_SET",
                        punteroAnidado,
                        null,
                        direccionAtributo
                );

                generarInicializadorEstructuraHeap(
                        atributo.getTipo(),
                        valor,
                        punteroAnidado
                );

                continue;
            }

            ResultadoExpresion resultado
                    = generarExpresion(valor);

            agregar(
                    "HEAP_SET",
                    resultado.getValor(),
                    null,
                    direccionAtributo
            );
        }
    }

    private String generarDireccionStack(
            String nombreVariable) {

        if (marcoActual == null) {
            return nombreVariable;
        }

        VariableMemoria variable
                = buscarVariableActiva(
                        nombreVariable
                );

        if (variable == null) {
            return nombreVariable;
        }

        String temporalDireccion
                = temporales.nuevoTemporal();

        agregar(
                "+",
                "P",
                String.valueOf(
                        variable.getOffset()
                ),
                temporalDireccion
        );

        return temporalDireccion;
    }

    private String leerVariableStack(
            String nombreVariable) {

        if (marcoActual == null) {
            return nombreVariable;
        }

        VariableMemoria variable
                = buscarVariableActiva(
                        nombreVariable
                );

        if (variable == null) {
            return nombreVariable;
        }

        String direccion
                = generarDireccionStack(
                        nombreVariable
                );

        String temporalValor
                = temporales.nuevoTemporal();

        agregar(
                "STACK_GET",
                direccion,
                null,
                temporalValor
        );

        return temporalValor;
    }

    private void escribirVariableStack(
            String nombreVariable,
            String valor) {

        if (marcoActual == null) {

            agregar(
                    "=",
                    valor,
                    null,
                    nombreVariable
            );

            return;
        }

        VariableMemoria variable
                = buscarVariableActiva(
                        nombreVariable
                );

        if (variable == null) {

            agregar(
                    "=",
                    valor,
                    null,
                    nombreVariable
            );

            return;
        }

        String direccion
                = generarDireccionStack(
                        nombreVariable
                );

        agregar(
                "STACK_SET",
                valor,
                null,
                direccion
        );
    }

    private AtributoEstructuraC3D buscarAtributo(
            String tipoEstructura,
            String nombreAtributo) {

        List<AtributoEstructuraC3D> atributos
                = buscarEstructuraC3D(
                        tipoEstructura
                );

        if (atributos == null) {
            return null;
        }

        for (AtributoEstructuraC3D atributo
                : atributos) {

            if (atributo.getNombre()
                    .equals(nombreAtributo)) {

                return atributo;
            }
        }

        return null;
    }

    private String obtenerTipoVariable(
            String nombre) {

        if (marcoActual == null) {
            return null;
        }

        VariableMemoria variable
                = buscarVariableActiva(
                        nombre
                );

        if (variable == null) {
            return null;
        }

        return variable.getTipo();
    }

    private String reservarEstructuraHeap(
            String tipoEstructura) {

        List<AtributoEstructuraC3D> atributos
                = buscarEstructuraC3D(
                        tipoEstructura
                );

        if (atributos == null) {
            return null;
        }

        String puntero
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "H",
                null,
                puntero
        );

        agregar(
                "+",
                "H",
                String.valueOf(
                        atributos.size()
                ),
                "H"
        );

        return puntero;
    }

    private void guardarPunteroEstructuraStack(
            String nombreVariable,
            String puntero) {

        String direccionStack
                = generarDireccionStack(
                        nombreVariable
                );

        agregar(
                "STACK_SET",
                puntero,
                null,
                direccionStack
        );
    }

    private ResultadoExpresion generarLecturaAtributo(
            NodoAST nodo) {

        if (nodo.getTipo()
                != TipoNodoAST.ACCESO_ATRIBUTO
                || nodo.cantidadHijos() == 0) {

            return new ResultadoExpresion("?");
        }

        return resolverAccesoAtributo(
                nodo
        );
    }

    private ResultadoExpresion resolverAccesoAtributo(
            NodoAST nodo) {

        if (nodo == null
                || nodo.getTipo()
                != TipoNodoAST.ACCESO_ATRIBUTO
                || nodo.cantidadHijos() == 0) {

            return new ResultadoExpresion("?");
        }

        NodoAST baseAST
                = nodo.getHijo(0);

        String nombreAtributo
                = nodo.getValor();

        if (baseAST.getTipo()
                == TipoNodoAST.ACCESO_ATRIBUTO) {

            ResultadoExpresion base
                    = resolverAccesoAtributo(
                            baseAST
                    );

            String tipoBase
                    = obtenerTipoResultadoAtributo(
                            baseAST
                    );

            if (tipoBase == null) {

                return new ResultadoExpresion(
                        generarAccesoSimple(nodo)
                );
            }

            AtributoEstructuraC3D atributo
                    = buscarAtributo(
                            tipoBase,
                            nombreAtributo
                    );

            if (atributo == null) {

                return new ResultadoExpresion(
                        generarAccesoSimple(nodo)
                );
            }

            String direccion
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    base.getValor(),
                    String.valueOf(
                            atributo.getOffset()
                    ),
                    direccion
            );

            String valor
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccion,
                    null,
                    valor
            );

            return new ResultadoExpresion(valor);
        }

        String punteroBase
                = generarValorBaseAcceso(
                        baseAST
                );

        String tipoBase
                = obtenerTipoBaseAcceso(
                        baseAST
                );

        if (punteroBase == null
                || tipoBase == null) {

            return new ResultadoExpresion(
                    generarAccesoSimple(nodo)
            );
        }

        AtributoEstructuraC3D atributo
                = buscarAtributo(
                        tipoBase,
                        nombreAtributo
                );

        if (atributo == null) {

            return new ResultadoExpresion(
                    generarAccesoSimple(nodo)
            );
        }

        String direccion
                = temporales.nuevoTemporal();

        agregar(
                "+",
                punteroBase,
                String.valueOf(
                        atributo.getOffset()
                ),
                direccion
        );

        String valor
                = temporales.nuevoTemporal();

        agregar(
                "HEAP_GET",
                direccion,
                null,
                valor
        );

        return new ResultadoExpresion(
                valor
        );
    }

    private String generarDireccionAtributo(
            NodoAST nodo) {

        List<String> ruta
                = new ArrayList<>();

        NodoAST actual
                = nodo;

        while (actual.getTipo()
                == TipoNodoAST.ACCESO_ATRIBUTO) {

            ruta.add(
                    0,
                    actual.getValor()
            );

            actual
                    = actual.getHijo(0);
        }

        if (actual.getTipo()
                != TipoNodoAST.ACCESO_VARIABLE) {

            return null;
        }

        String nombreBase
                = actual.getValor();

        String tipoActual
                = obtenerTipoVariable(
                        nombreBase
                );

        if (tipoActual == null) {
            return null;
        }

        String punteroActual
                = leerVariableStack(
                        nombreBase
                );

        for (int i = 0;
                i < ruta.size();
                i++) {

            String nombreAtributo
                    = ruta.get(i);

            AtributoEstructuraC3D atributo
                    = buscarAtributo(
                            tipoActual,
                            nombreAtributo
                    );

            if (atributo == null) {
                return null;
            }

            String direccion
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    punteroActual,
                    String.valueOf(
                            atributo.getOffset()
                    ),
                    direccion
            );

            if (i == ruta.size() - 1) {
                return direccion;
            }

            String siguientePuntero
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccion,
                    null,
                    siguientePuntero
            );

            punteroActual
                    = siguientePuntero;

            tipoActual
                    = atributo.getTipo();
        }

        return null;
    }

    private String generarCadenaHeap(
            String literal) {

        String contenido
                = limpiarLiteralCadena(literal);

        String puntero
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "H",
                null,
                puntero
        );

        for (int i = 0;
                i < contenido.length();
                i++) {

            char caracter
                    = contenido.charAt(i);

            agregar(
                    "HEAP_SET",
                    String.valueOf((int) caracter),
                    null,
                    "H"
            );

            agregar(
                    "+",
                    "H",
                    "1",
                    "H"
            );
        }

        agregar(
                "HEAP_SET",
                "-1",
                null,
                "H"
        );

        agregar(
                "+",
                "H",
                "1",
                "H"
        );

        return puntero;
    }

    private String limpiarLiteralCadena(
            String literal) {

        if (literal == null) {
            return "";
        }

        String texto
                = literal;

        if (texto.length() >= 2
                && texto.startsWith("\"")
                && texto.endsWith("\"")) {

            texto
                    = texto.substring(
                            1,
                            texto.length() - 1
                    );
        }

        return decodificarEscapes(
                texto
        );
    }

    private String decodificarEscapes(
            String texto) {

        StringBuilder resultado
                = new StringBuilder();

        for (int i = 0;
                i < texto.length();
                i++) {

            char actual
                    = texto.charAt(i);

            if (actual == '\\'
                    && i + 1 < texto.length()) {

                char siguiente
                        = texto.charAt(++i);

                switch (siguiente) {

                    case 'n' ->
                        resultado.append('\n');

                    case 't' ->
                        resultado.append('\t');

                    case 'r' ->
                        resultado.append('\r');

                    case '"' ->
                        resultado.append('"');

                    case '\\' ->
                        resultado.append('\\');

                    default -> {
                        resultado.append('\\');
                        resultado.append(siguiente);
                    }
                }

            } else {

                resultado.append(actual);
            }
        }

        return resultado.toString();
    }

    private List<NodoAST> obtenerDimensionesArreglo(
            NodoAST declaracion) {

        List<NodoAST> dimensiones
                = new ArrayList<>();

        for (NodoAST hijo
                : declaracion.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.DIMENSION) {

                dimensiones.add(hijo);
            }
        }

        return dimensiones;
    }

    private NodoAST obtenerInicializadorArreglo(
            NodoAST declaracion) {

        for (NodoAST hijo
                : declaracion.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.INICIALIZADOR_LISTA) {

                return hijo;
            }
        }

        return null;
    }

    private ResultadoExpresion evaluarDimension(
            NodoAST dimension) {

        if (dimension.cantidadHijos() > 0) {

            return generarExpresion(
                    dimension.getHijo(0)
            );
        }

        return new ResultadoExpresion(
                dimension.getValor()
        );
    }

    private String reservarArregloHeap(
            NodoAST declaracion) {

        List<NodoAST> dimensiones
                = obtenerDimensionesArreglo(
                        declaracion
                );

        int rango
                = dimensiones.size();

        if (rango == 0) {
            return null;
        }

        List<String> valoresDimensiones
                = new ArrayList<>();

        for (NodoAST dimension
                : dimensiones) {

            ResultadoExpresion resultado
                    = evaluarDimension(dimension);

            valoresDimensiones.add(
                    resultado.getValor()
            );
        }

        String punteroBase
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "H",
                null,
                punteroBase
        );

        agregar(
                "HEAP_SET",
                String.valueOf(rango),
                null,
                "H"
        );

        agregar(
                "+",
                "H",
                "1",
                "H"
        );

        for (String dimension
                : valoresDimensiones) {

            agregar(
                    "HEAP_SET",
                    dimension,
                    null,
                    "H"
            );

            agregar(
                    "+",
                    "H",
                    "1",
                    "H"
            );
        }

        String total
                = valoresDimensiones.get(0);

        for (int i = 1;
                i < valoresDimensiones.size();
                i++) {

            String temporal
                    = temporales.nuevoTemporal();

            agregar(
                    "*",
                    total,
                    valoresDimensiones.get(i),
                    temporal
            );

            total = temporal;
        }

        agregar(
                "+",
                "H",
                total,
                "H"
        );

        return punteroBase;
    }

    private String generarInicioDatosArreglo(
            String punteroBase) {

        String rango
                = temporales.nuevoTemporal();

        agregar(
                "HEAP_GET",
                punteroBase,
                null,
                rango
        );

        String desplazamiento
                = temporales.nuevoTemporal();

        agregar(
                "+",
                rango,
                "1",
                desplazamiento
        );

        String inicioDatos
                = temporales.nuevoTemporal();

        agregar(
                "+",
                punteroBase,
                desplazamiento,
                inicioDatos
        );

        return inicioDatos;
    }

    private void recolectarValoresInicializador(
            NodoAST nodo,
            List<NodoAST> valores) {

        if (nodo == null) {
            return;
        }

        if (nodo.getTipo()
                == TipoNodoAST.INICIALIZADOR_LISTA) {

            for (NodoAST hijo
                    : nodo.getHijos()) {

                recolectarValoresInicializador(
                        hijo,
                        valores
                );
            }

            return;
        }

        valores.add(nodo);
    }

    private void generarInicializadorArregloHeap(
            String punteroBase,
            NodoAST inicializador) {

        if (inicializador == null) {
            return;
        }

        List<NodoAST> valores
                = new ArrayList<>();

        recolectarValoresInicializador(
                inicializador,
                valores
        );

        String inicioDatos
                = generarInicioDatosArreglo(
                        punteroBase
                );

        for (int i = 0;
                i < valores.size();
                i++) {

            ResultadoExpresion valor
                    = generarExpresion(
                            valores.get(i)
                    );

            String direccion
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    inicioDatos,
                    String.valueOf(i),
                    direccion
            );

            agregar(
                    "HEAP_SET",
                    valor.getValor(),
                    null,
                    direccion
            );
        }
    }

    private void procesarDeclaracionArregloHeap(
            NodoAST nodo) {

        String nombre
                = extraerNombreVariable(
                        nodo.getValor()
                );

        String tipoElemento
                = extraerTipoVariable(
                        nodo.getValor()
                );

        String puntero
                = reservarArregloHeap(
                        nodo
                );

        if (puntero == null) {
            return;
        }

        escribirVariableStack(
                nombre,
                puntero
        );

        NodoAST inicializador
                = obtenerInicializadorArreglo(
                        nodo
                );

        if (inicializador == null) {

            // ============================================================
            // ARREGLO DE CADENAS SIN INICIALIZADOR
            // ============================================================
            if (esTipoCadena(tipoElemento)) {

                inicializarArregloCadenasLocalPorDefecto(
                        puntero
                );

                return;
            }

            // ============================================================
            // ARREGLO DE ESTRUCTURAS SIN INICIALIZADOR
            // ============================================================
            if (esTipoEstructura(
                    tipoElemento)) {

                inicializarArregloEstructurasLocalPorDefecto(
                        puntero,
                        tipoElemento
                );

                return;
            }

            // Primitivos quedan en 0.
            return;
        }

        if (esTipoCadena(tipoElemento)) {

            inicializarArregloCadenasLocalPorDefecto(
                    puntero
            );

            generarInicializadorArregloHeap(
                    puntero,
                    inicializador
            );

            return;
        }

        // ============================================================
        // ARREGLO DE ESTRUCTURAS CON INICIALIZADOR
        // ============================================================
        if (esTipoEstructura(
                tipoElemento)) {

            inicializarArregloEstructurasLocalPorDefecto(
                    puntero,
                    tipoElemento
            );

            generarInicializadorArregloEstructuras(
                    puntero,
                    tipoElemento,
                    inicializador,
                    contarDimensiones(nodo)
            );

            return;
        }

        // ============================================================
        // ARREGLO DE PRIMITIVOS
        // ============================================================
        generarInicializadorArregloHeap(
                puntero,
                inicializador
        );
    }

    private AccesoArregloInfo descomponerAccesoArreglo(
            NodoAST nodo) {

        List<NodoAST> indices
                = new ArrayList<>();

        NodoAST actual
                = nodo;

        while (actual != null
                && actual.getTipo()
                == TipoNodoAST.ACCESO_ARREGLO) {

            if (actual.cantidadHijos() < 2) {
                return null;
            }

            indices.add(
                    0,
                    actual.getHijo(1)
            );

            actual
                    = actual.getHijo(0);
        }

        if (actual == null) {
            return null;
        }

        if (actual.getTipo()
                != TipoNodoAST.ACCESO_VARIABLE
                && actual.getTipo()
                != TipoNodoAST.ACCESO_ATRIBUTO) {

            return null;
        }

        return new AccesoArregloInfo(
                actual,
                indices
        );
    }

    private String generarDireccionElementoArreglo(
            NodoAST acceso) {

        AccesoArregloInfo info
                = descomponerAccesoArreglo(
                        acceso
                );

        if (info == null
                || info.getIndices().isEmpty()) {

            return null;
        }

        String base
                = generarValorBaseAcceso(
                        info.getBase()
                );

        if (base == null) {
            return null;
        }

        String rango
                = temporales.nuevoTemporal();

        agregar(
                "HEAP_GET",
                base,
                null,
                rango
        );

        String desplazamientoCabecera
                = temporales.nuevoTemporal();

        agregar(
                "+",
                rango,
                "1",
                desplazamientoCabecera
        );

        String inicioDatos
                = temporales.nuevoTemporal();

        agregar(
                "+",
                base,
                desplazamientoCabecera,
                inicioDatos
        );

        List<NodoAST> indicesAST
                = info.getIndices();

        List<String> indices
                = new ArrayList<>();

        for (NodoAST indiceAST
                : indicesAST) {

            ResultadoExpresion resultado
                    = generarExpresion(
                            indiceAST
                    );

            indices.add(
                    resultado.getValor()
            );
        }

        String offset
                = indices.get(0);

        for (int i = 1;
                i < indices.size();
                i++) {

            String direccionDimension
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    base,
                    String.valueOf(1 + i),
                    direccionDimension
            );

            String dimension
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccionDimension,
                    null,
                    dimension
            );

            String multiplicacion
                    = temporales.nuevoTemporal();

            agregar(
                    "*",
                    offset,
                    dimension,
                    multiplicacion
            );

            String nuevoOffset
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    multiplicacion,
                    indices.get(i),
                    nuevoOffset
            );

            offset
                    = nuevoOffset;
        }

        String direccionFinal
                = temporales.nuevoTemporal();

        agregar(
                "+",
                inicioDatos,
                offset,
                direccionFinal
        );

        return direccionFinal;
    }

    private ResultadoExpresion generarLecturaArreglo(
            NodoAST nodo) {

        String direccion
                = generarDireccionElementoArreglo(
                        nodo
                );

        if (direccion == null) {

            return new ResultadoExpresion(
                    generarAccesoSimple(nodo)
            );
        }

        String valor
                = temporales.nuevoTemporal();

        agregar(
                "HEAP_GET",
                direccion,
                null,
                valor
        );

        return new ResultadoExpresion(
                valor
        );
    }

    private boolean esTipoEstructura(
            String tipo) {

        return tipo != null
                && buscarEstructuraC3D(tipo) != null;
    }

    private void generarInicializadorArregloEstructuras(
            String punteroBase,
            String tipoElemento,
            NodoAST inicializador,
            int cantidadDimensiones) {

        if (inicializador == null) {
            return;
        }

        List<NodoAST> elementos
                = new ArrayList<>();

        recolectarInicializadoresEstructura(
                inicializador,
                cantidadDimensiones,
                elementos
        );

        String inicioDatos
                = generarInicioDatosArreglo(
                        punteroBase
                );

        for (int i = 0;
                i < elementos.size();
                i++) {

            NodoAST inicializadorElemento
                    = elementos.get(i);

            String punteroEstructura
                    = reservarEstructuraHeap(
                            tipoElemento
                    );

            if (punteroEstructura == null) {
                continue;
            }

            generarInicializadorEstructuraHeap(
                    tipoElemento,
                    inicializadorElemento,
                    punteroEstructura
            );

            String direccionElemento
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    inicioDatos,
                    String.valueOf(i),
                    direccionElemento
            );

            agregar(
                    "HEAP_SET",
                    punteroEstructura,
                    null,
                    direccionElemento
            );
        }
    }

    private String generarValorBaseAcceso(
            NodoAST nodo) {

        if (nodo == null) {
            return null;
        }

        switch (nodo.getTipo()) {

            case ACCESO_VARIABLE -> {

                return leerVariableStack(
                        nodo.getValor()
                );
            }

            case ACCESO_ATRIBUTO -> {

                ResultadoExpresion resultado
                        = resolverAccesoAtributo(
                                nodo
                        );

                return resultado.getValor();
            }

            case ACCESO_ARREGLO -> {

                String direccion
                        = generarDireccionElementoArreglo(
                                nodo
                        );

                if (direccion == null) {
                    return null;
                }

                String valor
                        = temporales.nuevoTemporal();

                agregar(
                        "HEAP_GET",
                        direccion,
                        null,
                        valor
                );

                return valor;
            }

            default -> {
                return null;
            }
        }
    }

    private String obtenerTipoBaseAcceso(
            NodoAST nodo) {

        if (nodo == null) {
            return null;
        }

        if (nodo.getTipo()
                == TipoNodoAST.ACCESO_VARIABLE) {

            return obtenerTipoVariable(
                    nodo.getValor()
            );
        }

        if (nodo.getTipo()
                == TipoNodoAST.ACCESO_ATRIBUTO) {

            return obtenerTipoResultadoAtributo(
                    nodo
            );
        }

        if (nodo.getTipo()
                == TipoNodoAST.ACCESO_ARREGLO) {

            AccesoArregloInfo info
                    = descomponerAccesoArreglo(
                            nodo
                    );

            if (info == null) {
                return null;
            }

            NodoAST base
                    = info.getBase();

            if (base.getTipo()
                    == TipoNodoAST.ACCESO_VARIABLE) {

                return obtenerTipoVariable(
                        base.getValor()
                );
            }

            if (base.getTipo()
                    == TipoNodoAST.ACCESO_ATRIBUTO) {

                return obtenerTipoResultadoAtributo(
                        base
                );
            }
        }

        return null;
    }

    private String obtenerTipoResultadoAtributo(
            NodoAST nodo) {

        if (nodo == null
                || nodo.getTipo()
                != TipoNodoAST.ACCESO_ATRIBUTO
                || nodo.cantidadHijos() == 0) {

            return null;
        }

        NodoAST base
                = nodo.getHijo(0);

        String tipoBase;

        if (base.getTipo()
                == TipoNodoAST.ACCESO_ATRIBUTO) {

            tipoBase
                    = obtenerTipoResultadoAtributo(
                            base
                    );

        } else {

            tipoBase
                    = obtenerTipoBaseAcceso(
                            base
                    );
        }

        if (tipoBase == null) {
            return null;
        }

        AtributoEstructuraC3D atributo
                = buscarAtributo(
                        tipoBase,
                        nodo.getValor()
                );

        if (atributo == null) {
            return null;
        }

        return atributo.getTipo();
    }

    private String generarDireccionAtributoGeneral(
            NodoAST nodo) {

        if (nodo == null
                || nodo.getTipo()
                != TipoNodoAST.ACCESO_ATRIBUTO
                || nodo.cantidadHijos() == 0) {

            return null;
        }

        NodoAST base
                = nodo.getHijo(0);

        String punteroBase;
        String tipoBase;

        if (base.getTipo()
                == TipoNodoAST.ACCESO_ATRIBUTO) {

            ResultadoExpresion resultadoBase
                    = resolverAccesoAtributo(
                            base
                    );

            punteroBase
                    = resultadoBase.getValor();

            tipoBase
                    = obtenerTipoResultadoAtributo(
                            base
                    );

        } else {

            punteroBase
                    = generarValorBaseAcceso(
                            base
                    );

            tipoBase
                    = obtenerTipoBaseAcceso(
                            base
                    );
        }

        if (punteroBase == null
                || tipoBase == null) {

            return null;
        }

        AtributoEstructuraC3D atributo
                = buscarAtributo(
                        tipoBase,
                        nodo.getValor()
                );

        if (atributo == null) {
            return null;
        }

        String direccion
                = temporales.nuevoTemporal();

        agregar(
                "+",
                punteroBase,
                String.valueOf(
                        atributo.getOffset()
                ),
                direccion
        );

        return direccion;
    }

    private String reservarArregloHeapConstante(
            List<Integer> dimensiones) {

        if (dimensiones == null
                || dimensiones.isEmpty()) {

            return null;
        }

        String base
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "H",
                null,
                base
        );

        agregar(
                "HEAP_SET",
                String.valueOf(
                        dimensiones.size()
                ),
                null,
                "H"
        );

        agregar(
                "+",
                "H",
                "1",
                "H"
        );

        for (Integer dimension
                : dimensiones) {

            agregar(
                    "HEAP_SET",
                    String.valueOf(dimension),
                    null,
                    "H"
            );

            agregar(
                    "+",
                    "H",
                    "1",
                    "H"
            );
        }

        String total
                = String.valueOf(
                        dimensiones.get(0)
                );

        for (int i = 1;
                i < dimensiones.size();
                i++) {

            String temporal
                    = temporales.nuevoTemporal();

            agregar(
                    "*",
                    total,
                    String.valueOf(
                            dimensiones.get(i)
                    ),
                    temporal
            );

            total
                    = temporal;
        }

        agregar(
                "+",
                "H",
                total,
                "H"
        );

        return base;
    }

    private void generarInicializadorAtributoArreglo(
            AtributoEstructuraC3D atributo,
            NodoAST inicializador,
            String direccionAtributo) {

        String punteroArreglo
                = reservarArregloHeapConstante(
                        atributo.getDimensiones()
                );

        if (punteroArreglo == null) {
            return;
        }

        agregar(
                "HEAP_SET",
                punteroArreglo,
                null,
                direccionAtributo
        );

        if (inicializador == null) {
            return;
        }

        generarInicializadorArregloHeap(
                punteroArreglo,
                inicializador
        );
    }

    private void registrarFuncionesAST(
            NodoAST nodo) {

        if (nodo == null) {
            return;
        }

        if (nodo.getTipo()
                == TipoNodoAST.FUNCION) {

            funcionesAST.put(
                    nodo.getValor(),
                    nodo
            );
        }

        for (NodoAST hijo
                : nodo.getHijos()) {

            registrarFuncionesAST(
                    hijo
            );
        }
    }

    private List<NodoAST> obtenerParametrosFuncion(
            NodoAST funcion) {

        List<NodoAST> parametros
                = new ArrayList<>();

        if (funcion == null) {
            return parametros;
        }

        for (NodoAST hijo
                : funcion.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.PARAMETRO) {

                parametros.add(
                        hijo
                );
            }
        }

        return parametros;
    }

    private String obtenerModoParametro(
            NodoAST parametro) {

        if (parametro == null) {
            return "VALOR";
        }

        for (NodoAST hijo
                : parametro.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.MODO_PARAMETRO) {

                return hijo.getValor();
            }
        }

        return "VALOR";
    }

    private boolean funcionTieneRetorno(
            NodoAST funcion) {

        if (funcion == null) {
            return false;
        }

        for (NodoAST hijo
                : funcion.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.TIPO_RETORNO) {

                return true;
            }
        }

        return false;
    }

    private ResultadoExpresion generarArgumentoReferencia(
            NodoAST argumento) {

        if (argumento == null) {

            return new ResultadoExpresion(
                    "?"
            );
        }

        if (argumento.getTipo()
                == TipoNodoAST.ACCESO_VARIABLE) {

            return new ResultadoExpresion(
                    leerVariableStack(
                            argumento.getValor()
                    )
            );
        }

        if (argumento.getTipo()
                == TipoNodoAST.ACCESO_ATRIBUTO) {

            return generarLecturaAtributo(
                    argumento
            );
        }

        if (argumento.getTipo()
                == TipoNodoAST.ACCESO_ARREGLO) {

            return generarLecturaArreglo(
                    argumento
            );
        }

        return generarExpresion(
                argumento
        );
    }

    private ResultadoExpresion generarLlamadaFuncion(
            NodoAST nodo,
            boolean obtenerRetorno) {

        String nombreFuncion
                = nodo.getValor();

        NodoAST funcionDestino
                = funcionesAST.get(
                        nombreFuncion
                );

        MarcoFuncion marcoDestino
                = tablaMemoria.buscarFuncion(
                        nombreFuncion
                );

        if (funcionDestino == null
                || marcoDestino == null) {

            agregar(
                    "CALL",
                    nombreFuncion,
                    String.valueOf(
                            nodo.cantidadHijos()
                    ),
                    null
            );

            return new ResultadoExpresion(
                    "?"
            );
        }

        List<NodoAST> parametros
                = obtenerParametrosFuncion(
                        funcionDestino
                );

        List<String> valoresArgumentos
                = new ArrayList<>();

        int cantidad
                = Math.min(
                        parametros.size(),
                        nodo.cantidadHijos()
                );

        for (int i = 0;
                i < cantidad;
                i++) {

            NodoAST parametro
                    = parametros.get(i);

            NodoAST argumento
                    = nodo.getHijo(i);

            String modo
                    = obtenerModoParametro(
                            parametro
                    );

            ResultadoExpresion resultado;

            if (modo.equals(
                    "REFERENCIA_ARREGLO")
                    || modo.equals(
                            "REFERENCIA_ESTRUCTURA")) {

                resultado
                        = generarArgumentoReferencia(
                                argumento
                        );

            } else {

                resultado
                        = generarExpresion(
                                argumento
                        );
            }

            valoresArgumentos.add(
                    resultado.getValor()
            );
        }

        int tamanoMarcoCaller
                = marcoActual != null
                        ? marcoActual.getTamano()
                        : 0;

        String nuevaBase
                = temporales.nuevoTemporal();

        agregar(
                "+",
                "P",
                String.valueOf(
                        tamanoMarcoCaller
                ),
                nuevaBase
        );

        for (int i = 0;
                i < cantidad;
                i++) {

            NodoAST parametro
                    = parametros.get(i);

            VariableMemoria variableParametro
                    = marcoDestino.buscarVariablePorNodo(
                            parametro
                    );

            if (variableParametro == null) {
                continue;
            }

            String direccionParametro
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    nuevaBase,
                    String.valueOf(
                            variableParametro.getOffset()
                    ),
                    direccionParametro
            );

            agregar(
                    "STACK_SET",
                    valoresArgumentos.get(i),
                    null,
                    direccionParametro
            );
        }

        agregar(
                "+",
                "P",
                String.valueOf(
                        tamanoMarcoCaller
                ),
                "P"
        );

        agregar(
                "CALL",
                nombreFuncion,
                String.valueOf(
                        nodo.cantidadHijos()
                ),
                null
        );

        String valorRetorno
                = null;

        if (obtenerRetorno
                && funcionTieneRetorno(
                        funcionDestino
                )) {

            String direccionRetorno
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    "P",
                    "0",
                    direccionRetorno
            );

            valorRetorno
                    = temporales.nuevoTemporal();

            agregar(
                    "STACK_GET",
                    direccionRetorno,
                    null,
                    valorRetorno
            );
        }

        agregar(
                "-",
                "P",
                String.valueOf(
                        tamanoMarcoCaller
                ),
                "P"
        );

        if (valorRetorno == null) {

            return new ResultadoExpresion(
                    "?"
            );
        }

        return new ResultadoExpresion(
                valorRetorno
        );
    }

    private List<AtributoEstructuraC3D>
            buscarEstructuraC3D(
                    String nombreEstructura) {

        if (nombreEstructura == null) {
            return null;
        }

        if (marcoActual != null) {

            Map<String, List<AtributoEstructuraC3D>> localesFuncion
                    = estructurasLocales.get(
                            marcoActual.getNombre()
                    );

            if (localesFuncion != null) {

                List<AtributoEstructuraC3D> estructuraLocal
                        = localesFuncion.get(
                                nombreEstructura
                        );

                if (estructuraLocal != null) {
                    return estructuraLocal;
                }
            }
        }

        return estructurasGlobales.get(
                nombreEstructura
        );
    }

    // ============================================================
    // AMBITOS DE VARIABLES PARA GENERACION C3D
    // ============================================================
    private void entrarAmbitoVariables() {

        pilaAmbitosVariables.push(
                new LinkedHashMap<>()
        );
    }

    private void salirAmbitoVariables() {

        if (!pilaAmbitosVariables.isEmpty()) {
            pilaAmbitosVariables.pop();
        }
    }

    private void registrarVariableActiva(
            NodoAST declaracion) {

        if (marcoActual == null
                || declaracion == null
                || pilaAmbitosVariables.isEmpty()) {

            return;
        }

        VariableMemoria variable
                = marcoActual.buscarVariablePorNodo(
                        declaracion
                );

        if (variable == null) {
            return;
        }

        pilaAmbitosVariables
                .peek()
                .put(
                        variable.getNombre(),
                        variable
                );
    }

    private VariableMemoria buscarVariableActiva(
            String nombre) {

        if (nombre == null) {
            return null;
        }

        for (Map<String, VariableMemoria> ambito
                : pilaAmbitosVariables) {

            VariableMemoria variable
                    = ambito.get(nombre);

            if (variable != null) {
                return variable;
            }
        }

        return null;
    }

    private void procesarBloque(
            NodoAST nodo) {

        entrarAmbitoVariables();

        for (NodoAST hijo
                : nodo.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.DECLARACION_VARIABLE
                    || hijo.getTipo()
                    == TipoNodoAST.DECLARACION_ARREGLO) {

                registrarVariableActiva(
                        hijo
                );
            }

            procesarNodo(hijo);
        }

        salirAmbitoVariables();
    }

    private String obtenerTipoRetornoFuncion(
            NodoAST funcion) {

        if (funcion == null) {
            return null;
        }

        for (NodoAST hijo
                : funcion.getHijos()) {

            if (hijo.getTipo()
                    == TipoNodoAST.TIPO_RETORNO) {

                return hijo.getValor();
            }
        }

        return null;
    }

    private void recolectarInicializadoresEstructura(
            NodoAST nodo,
            int nivelesRestantes,
            List<NodoAST> elementos) {

        if (nodo == null) {
            return;
        }

        // Cuando ya recorrimos todas las dimensiones
        // del arreglo, este nodo representa UNA estructura.
        if (nivelesRestantes <= 0) {

            elementos.add(nodo);
            return;
        }

        // Mientras estemos recorriendo dimensiones,
        // esperamos listas.
        if (nodo.getTipo()
                != TipoNodoAST.INICIALIZADOR_LISTA) {

            elementos.add(nodo);
            return;
        }

        for (NodoAST hijo : nodo.getHijos()) {

            recolectarInicializadoresEstructura(
                    hijo,
                    nivelesRestantes - 1,
                    elementos
            );
        }
    }

}
