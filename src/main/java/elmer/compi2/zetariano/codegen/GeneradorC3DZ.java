/*
 */
package elmer.compi2.zetariano.codegen;

import elmer.compi2.zetariano.core.node.zeta.*;
import elmer.compi2.zetariano.codegen.Cuadruplo;
import elmer.compi2.zetariano.codegen.GeneradorEtiquetas;
import elmer.compi2.zetariano.codegen.GeneradorTemporales;
import elmer.compi2.zetariano.codegen.ResultadoExpresion;
import elmer.compi2.zetariano.runtime.zeta.AtributoMemoriaZ;
import elmer.compi2.zetariano.runtime.zeta.ClaseMemoriaZ;
import elmer.compi2.zetariano.runtime.zeta.ConstructorMarcosZ;
import elmer.compi2.zetariano.runtime.zeta.MarcoMetodoZ;
import elmer.compi2.zetariano.runtime.zeta.TablaMemoriaZ;
import elmer.compi2.zetariano.runtime.zeta.VariableMemoriaZ;
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
public class GeneradorC3DZ {

    private final List<Cuadruplo> cuadruplos;

    private final GeneradorTemporales temporales;
    private final GeneradorEtiquetas etiquetas;
    private TablaMemoriaZ tablaMemoria;

    private MarcoMetodoZ marcoActual;

    private ClaseMemoriaZ claseActual;
    private ClaseASTZ claseASTActual;

    /* AST de todas las clases del módulo Z, indexados por nombre. */
    private final Map<String, ClaseASTZ> clasesAST;

    private final Deque<String> pilaBreak
            = new ArrayDeque<>();

    private final Deque<String> pilaContinue
            = new ArrayDeque<>();

    private final Deque<java.util.Map<String, VariableMemoriaZ>> pilaAmbitosVariables
            = new ArrayDeque<>();

    public GeneradorC3DZ() {

        this.cuadruplos = new ArrayList<>();
        this.temporales = new GeneradorTemporales();
        this.etiquetas = new GeneradorEtiquetas();
        this.tablaMemoria = null;

        this.marcoActual = null;
        this.claseActual = null;
        this.claseASTActual = null;
        this.clasesAST = new LinkedHashMap<>();
    }

    // =========================================================
    // GENERAR
    // =========================================================
    public List<Cuadruplo> generar(
            ProgramaASTZ programa) {

        if (programa == null) {
            return Collections.emptyList();
        }

        return generar(
                Collections.singletonList(programa)
        );
    }

    /**
     * Genera un solo módulo Z a partir de varias clases importadas.
     * La tabla de memoria se combina antes de procesar los cuerpos para
     * permitir llamadas y construcciones entre clases distintas.
     */
    public List<Cuadruplo> generar(
            List<ProgramaASTZ> programas) {

        cuadruplos.clear();

        temporales.reiniciar();
        etiquetas.reiniciar();

        marcoActual = null;

        if (programas == null || programas.isEmpty()) {
            return Collections.emptyList();
        }

        ConstructorMarcosZ constructorMarcos
                = new ConstructorMarcosZ();

        tablaMemoria
                = new TablaMemoriaZ();

        clasesAST.clear();

        for (ProgramaASTZ programa : programas) {

            if (programa != null
                    && programa.getClase() != null) {

                clasesAST.put(
                        programa.getClase().getNombre(),
                        programa.getClase()
                );
            }
        }

        for (ProgramaASTZ programa : programas) {

            if (programa == null) {
                continue;
            }

            TablaMemoriaZ tablaParcial
                    = constructorMarcos.construir(programa);

            for (ClaseMemoriaZ clase
                    : tablaParcial.getClases().values()) {

                tablaMemoria.registrarClase(clase);
            }

            for (MarcoMetodoZ marco
                    : tablaParcial.getMarcos().values()) {

                tablaMemoria.registrar(marco);
            }
        }

        for (ProgramaASTZ programa : programas) {

            if (programa != null) {
                procesarPrograma(programa);
            }
        }

        return Collections.unmodifiableList(
                cuadruplos
        );
    }

    public List<Cuadruplo> getCuadruplos() {

        return Collections.unmodifiableList(
                cuadruplos
        );
    }

    // =========================================================
    // AGREGAR CUADRUPLO
    // =========================================================
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

    // =========================================================
    // PROGRAMA
    // =========================================================
    private void procesarPrograma(
            ProgramaASTZ programa) {

        if (programa.getClase() != null) {
            procesarClase(
                    programa.getClase()
            );
        }
    }

    // =========================================================
    // CLASE
    // =========================================================
    private void procesarClase(
            ClaseASTZ clase) {

        ClaseMemoriaZ memoriaAnterior
                = claseActual;

        ClaseASTZ astAnterior
                = claseASTActual;

        claseActual
                = tablaMemoria.buscarClase(
                        clase.getNombre()
                );

        claseASTActual
                = clase;

        agregar(
                "CLASS_BEGIN",
                clase.getNombre(),
                null,
                null
        );

        for (MiembroASTZ miembro
                : clase.getMiembros()) {

            procesarMiembro(miembro);
        }

        agregar(
                "CLASS_END",
                clase.getNombre(),
                null,
                null
        );

        claseActual
                = memoriaAnterior;

        claseASTActual
                = astAnterior;
    }

    // =========================================================
    // MIEMBROS
    // =========================================================
    private void procesarMiembro(
            MiembroASTZ miembro) {

        if (miembro == null) {
            return;
        }

        if (miembro instanceof AtributoASTZ atributo) {
            procesarAtributo(atributo);
            return;
        }

        if (miembro instanceof ConstructorASTZ constructor) {
            procesarConstructor(constructor);
            return;
        }

        if (miembro instanceof MetodoASTZ metodo) {
            procesarMetodo(metodo);
        }
    }

    // =========================================================
    // ATRIBUTO
    // =========================================================
    private void procesarAtributo(
            AtributoASTZ atributo) {

        agregar(
                "ATTR",
                describirTipo(
                        atributo.getTipo(),
                        atributo.getDimensiones()
                ),
                null,
                atributo.getNombre()
        );
    }

    // =========================================================
    // CONSTRUCTOR
    // =========================================================
    private void procesarConstructor(
            ConstructorASTZ constructor) {

        String firma
                = construirFirma(
                        constructor.getNombre(),
                        constructor.getParametros()
                );

        MarcoMetodoZ marcoAnterior
                = marcoActual;

        marcoActual
                = tablaMemoria.buscar(
                        firma
                );

        agregar(
                "FUNC_BEGIN",
                firma,
                null,
                null
        );

        procesarParametros(
                constructor.getParametros()
        );

        inicializarAtributosInstancia(
                claseASTActual
        );

        procesarSentencia(
                constructor.getCuerpo()
        );

        agregar(
                "FUNC_END",
                firma,
                null,
                null
        );

        marcoActual
                = marcoAnterior;
    }

    // =========================================================
    // METODO
    // =========================================================
    private void procesarMetodo(
            MetodoASTZ metodo) {

        String firma
                = construirFirma(
                        metodo.getNombre(),
                        metodo.getParametros()
                );

        MarcoMetodoZ marcoAnterior
                = marcoActual;

        marcoActual
                = tablaMemoria.buscar(
                        firma
                );

        iniciarAmbitosMetodo();

        try {

            agregar(
                    "FUNC_BEGIN",
                    firma,
                    metodo.getTipoRetorno(),
                    null
            );

            procesarParametros(
                    metodo.getParametros()
            );

            procesarBloqueRaiz(
                    metodo.getCuerpo()
            );

            agregar(
                    "FUNC_END",
                    firma,
                    null,
                    null
            );

        } finally {

            finalizarAmbitosMetodo();

            marcoActual
                    = marcoAnterior;
        }
    }

    private void procesarBloqueRaiz(
            BloqueASTZ bloque) {

        if (bloque == null) {
            return;
        }

        for (SentenciaASTZ sentencia
                : bloque.getSentencias()) {

            procesarSentencia(
                    sentencia
            );
        }
    }

    // =========================================================
    // PARAMETROS
    // =========================================================
    private void procesarParametros(
            List<ParametroASTZ> parametros) {

        for (ParametroASTZ parametro
                : parametros) {

            agregar(
                    "PARAM",
                    describirTipo(
                            parametro.getTipo(),
                            parametro.getDimensiones()
                    ),
                    null,
                    parametro.getNombre()
            );
        }
    }

    // =========================================================
// AMBITOS DE VARIABLES LOCALES
// =========================================================
    private void iniciarAmbitosMetodo() {

        pilaAmbitosVariables.clear();

        /*
     * Ámbito raíz del método.
     *
     * Aquí se colocarán las declaraciones pertenecientes
     * directamente al cuerpo principal.
         */
        entrarAmbitoVariables();
    }

    private void finalizarAmbitosMetodo() {

        pilaAmbitosVariables.clear();
    }

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

    private void activarVariableLocal(
            DeclaracionASTZ declaracion) {

        if (declaracion == null
                || marcoActual == null) {

            return;
        }

        if (pilaAmbitosVariables.isEmpty()) {
            entrarAmbitoVariables();
        }

        VariableMemoriaZ variable
                = marcoActual.buscarDeclaracion(
                        declaracion
                );

        if (variable == null) {

            agregar(
                    "ERROR_C3D",
                    "Variable local sin posicion de memoria",
                    declaracion.getNombre(),
                    null
            );

            return;
        }

        pilaAmbitosVariables.peek().put(
                declaracion.getNombre(),
                variable
        );
    }

    private VariableMemoriaZ buscarVariableVisible(
            String nombre) {

        if (nombre == null
                || marcoActual == null) {

            return null;
        }

        for (Map<String, VariableMemoriaZ> ambito
                : pilaAmbitosVariables) {

            VariableMemoriaZ variable
                    = ambito.get(
                            nombre
                    );

            if (variable != null) {
                return variable;
            }
        }

        return marcoActual.buscarBase(
                nombre
        );
    }

    // =========================================================
    // SENTENCIAS
    // =========================================================
    private void procesarSentencia(
            SentenciaASTZ sentencia) {

        if (sentencia == null) {
            return;
        }

        if (sentencia instanceof BloqueASTZ bloque) {

            entrarAmbitoVariables();

            try {

                for (SentenciaASTZ hijo
                        : bloque.getSentencias()) {

                    procesarSentencia(
                            hijo
                    );
                }

            } finally {

                salirAmbitoVariables();
            }

            return;
        }
        if (sentencia instanceof DeclaracionASTZ declaracion) {
            procesarDeclaracion(declaracion);
            return;
        }

        if (sentencia instanceof AsignacionASTZ asignacion) {
            procesarAsignacion(asignacion);
            return;
        }

        if (sentencia instanceof IncrementoDecrementoASTZ incremento) {

            procesarIncrementoDecremento(
                    incremento
            );

            return;
        }

        if (sentencia instanceof IfASTZ sentenciaIf) {

            procesarIf(sentenciaIf);

            return;
        }

        if (sentencia instanceof WhileASTZ sentenciaWhile) {

            procesarWhile(
                    sentenciaWhile
            );

            return;
        }

        if (sentencia instanceof DoWhileASTZ sentenciaDoWhile) {

            procesarDoWhile(
                    sentenciaDoWhile
            );

            return;
        }

        if (sentencia instanceof ForASTZ sentenciaFor) {

            procesarFor(
                    sentenciaFor
            );

            return;
        }

        if (sentencia instanceof SwitchASTZ sentenciaSwitch) {

            procesarSwitch(
                    sentenciaSwitch
            );

            return;
        }

        if (sentencia instanceof BreakASTZ) {

            procesarBreak();

            return;
        }

        if (sentencia instanceof ContinueASTZ) {

            procesarContinue();

            return;
        }

        if (sentencia instanceof ReturnASTZ retorno) {
            procesarReturn(retorno);
            return;
        }

        if (sentencia instanceof ImpresionASTZ impresion) {
            procesarImpresion(impresion);
            return;
        }

        if (sentencia instanceof ExpresionSentenciaASTZ expresionSentencia) {

            generarExpresion(
                    expresionSentencia.getExpresion()
            );

            return;
        }

    }

    // =========================================================
    // DECLARACION
    // =========================================================
    private void procesarDeclaracion(
            DeclaracionASTZ declaracion) {

        if (declaracion == null) {
            return;
        }

        // =====================================================
        // 1. REGISTRAR DECLARACION EN C3D
        // =====================================================
        agregar(
                "DECL",
                describirTipo(
                        declaracion.getTipo(),
                        declaracion.getDimensiones()
                ),
                null,
                declaracion.getNombre()
        );

        activarVariableLocal(
                declaracion
        );

        // =====================================================
        // 2. SIN INICIALIZADOR
        // =====================================================
        if (declaracion.getInicializador() == null) {
            return;
        }

        // =====================================================
        // 3. INICIALIZADOR CON LISTA
        // =====================================================
        if (declaracion.getInicializador() instanceof InicializadorListaASTZ lista) {

            ResultadoExpresion arreglo
                    = generarInicializadorListaArreglo(
                            lista,
                            declaracion.getDimensiones()
                    );

            escribirVariableStack(
                    declaracion.getNombre(),
                    arreglo.getValor()
            );

            return;
        }

        // =====================================================
        // 4. INICIALIZADOR NORMAL
        // =====================================================
        ResultadoExpresion valor
                = generarExpresion(
                        declaracion.getInicializador()
                );

        escribirVariableStack(
                declaracion.getNombre(),
                valor.getValor()
        );
    }

    // =========================================================
    // ASIGNACION
    // =========================================================
    private void procesarAsignacion(
            AsignacionASTZ asignacion) {

        if (asignacion == null
                || asignacion.getDestino() == null) {

            return;
        }

        // =====================================================
        // 1. DESTINO SIMPLE
        // =====================================================
        if (asignacion.getDestino() instanceof AccesoASTZ accesoSimple
                && accesoSimple.getPasos().isEmpty()) {

            String nombre
                    = accesoSimple.getBase();

            // =================================================
            // 1.1 VARIABLE LOCAL / PARAMETRO
            // =================================================
            VariableMemoriaZ variable
                    = marcoActual != null
                            ? buscarVariableVisible(nombre)
                            : null;

            if (variable != null) {

                ResultadoExpresion valor
                        = generarExpresion(
                                asignacion.getValor()
                        );

                String operador
                        = asignacion.getOperador();

                // =============================================
                // =
                // =============================================
                if ("=".equals(operador)) {

                    escribirVariableStack(
                            nombre,
                            valor.getValor()
                    );

                    return;
                }

                // =============================================
                // += -= *=
                // =============================================
                String actual
                        = leerVariableStack(
                                nombre
                        );

                String operadorReal
                        = operador.substring(
                                0,
                                operador.length() - 1
                        );

                String nuevoValor
                        = temporales.nuevoTemporal();

                agregar(
                        operadorReal,
                        actual,
                        valor.getValor(),
                        nuevoValor
                );

                escribirVariableStack(
                        nombre,
                        nuevoValor
                );

                return;
            }

            // =================================================
            // 1.2 ATRIBUTO IMPLICITO DE THIS
            // =================================================
            if (claseActual != null) {

                AtributoMemoriaZ atributo
                        = claseActual.buscarAtributo(
                                nombre
                        );

                if (atributo != null) {

                    ResultadoExpresion valor
                            = generarExpresion(
                                    asignacion.getValor()
                            );

                    String direccion
                            = generarDireccionAtributoThis(
                                    nombre
                            );

                    String operador
                            = asignacion.getOperador();

                    // =========================================
                    // =
                    // =========================================
                    if ("=".equals(operador)) {

                        agregar(
                                "HEAP_SET",
                                valor.getValor(),
                                null,
                                direccion
                        );

                        return;
                    }

                    // =========================================
                    // += -= *=
                    // =========================================
                    String actual
                            = temporales.nuevoTemporal();

                    agregar(
                            "HEAP_GET",
                            direccion,
                            null,
                            actual
                    );

                    String operadorReal
                            = operador.substring(
                                    0,
                                    operador.length() - 1
                            );

                    String nuevoValor
                            = temporales.nuevoTemporal();

                    agregar(
                            operadorReal,
                            actual,
                            valor.getValor(),
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
            }
        }

        // =====================================================
        // 2. ASIGNACION A INDICE DE ARREGLO
        // =====================================================
        if (asignacion.getDestino() instanceof AccesoASTZ accesoIndice) {

            DireccionIndiceZ direccionIndice
                    = resolverDireccionIndice(
                            accesoIndice
                    );

            if (direccionIndice != null) {

                ResultadoExpresion valor
                        = generarExpresion(
                                asignacion.getValor()
                        );

                String operador
                        = asignacion.getOperador();

                // =============================================
                // =
                // =============================================
                if ("=".equals(operador)) {

                    agregar(
                            "HEAP_SET",
                            valor.getValor(),
                            null,
                            direccionIndice.getDireccion()
                    );

                    return;
                }

                // =============================================
                // += -= *=
                // =============================================
                String actual
                        = temporales.nuevoTemporal();

                agregar(
                        "HEAP_GET",
                        direccionIndice.getDireccion(),
                        null,
                        actual
                );

                String operadorReal
                        = operador.substring(
                                0,
                                operador.length() - 1
                        );

                String nuevoValor
                        = temporales.nuevoTemporal();

                agregar(
                        operadorReal,
                        actual,
                        valor.getValor(),
                        nuevoValor
                );

                agregar(
                        "HEAP_SET",
                        nuevoValor,
                        null,
                        direccionIndice.getDireccion()
                );

                return;
            }
        }

        // =====================================================
        // 3. DESTINO COMPLEJO DE OBJETO
        // =====================================================
        if (asignacion.getDestino() instanceof AccesoASTZ accesoComplejo) {

            DireccionAccesoZ direccionAcceso
                    = resolverDireccionAccesoObjeto(
                            accesoComplejo
                    );

            if (direccionAcceso != null) {

                ResultadoExpresion valor
                        = generarExpresion(
                                asignacion.getValor()
                        );

                String operador
                        = asignacion.getOperador();

                // =============================================
                // =
                // =============================================
                if ("=".equals(operador)) {

                    agregar(
                            "HEAP_SET",
                            valor.getValor(),
                            null,
                            direccionAcceso.getDireccion()
                    );

                    return;
                }

                // =============================================
                // += -= *=
                // =============================================
                String actual
                        = temporales.nuevoTemporal();

                agregar(
                        "HEAP_GET",
                        direccionAcceso.getDireccion(),
                        null,
                        actual
                );

                String operadorReal
                        = operador.substring(
                                0,
                                operador.length() - 1
                        );

                String nuevoValor
                        = temporales.nuevoTemporal();

                agregar(
                        operadorReal,
                        actual,
                        valor.getValor(),
                        nuevoValor
                );

                agregar(
                        "HEAP_SET",
                        nuevoValor,
                        null,
                        direccionAcceso.getDireccion()
                );

                return;
            }
        }

        // =====================================================
        // 4. FALLBACK
        // =====================================================
        ResultadoExpresion valor
                = generarExpresion(
                        asignacion.getValor()
                );

        String destino
                = describirAcceso(
                        asignacion.getDestino()
                );

        String operador
                = asignacion.getOperador();

        // =====================================================
        // =
        // =====================================================
        if ("=".equals(operador)) {

            agregar(
                    "=",
                    valor.getValor(),
                    null,
                    destino
            );

            return;
        }

        // =====================================================
        // += -= *=
        // =====================================================
        String operadorReal
                = operador.substring(
                        0,
                        operador.length() - 1
                );

        String temporal
                = temporales.nuevoTemporal();

        agregar(
                operadorReal,
                destino,
                valor.getValor(),
                temporal
        );

        agregar(
                "=",
                temporal,
                null,
                destino
        );
    }

    // =========================================================
    // RETURN
    // =========================================================
    private void procesarReturn(
            ReturnASTZ retorno) {

        if (retorno.getExpresion() == null) {

            agregar(
                    "RETURN",
                    null,
                    null,
                    null
            );

            return;
        }

        ResultadoExpresion valor
                = generarExpresion(
                        retorno.getExpresion()
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
                valor.getValor(),
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

    // =========================================================
    // IMPRESION
    // =========================================================
    private void procesarImpresion(
            ImpresionASTZ impresion) {

        if (impresion == null) {
            return;
        }

        // =====================================================
        // 1. PRINTLN() SIN EXPRESION
        // =====================================================
        if (impresion.getExpresion() == null) {

            agregar(
                    impresion.isSaltoLinea()
                    ? "PRINTLN"
                    : "PRINT",
                    null,
                    null,
                    null
            );

            return;
        }

        // =====================================================
        // 2. GENERAR VALOR
        // =====================================================
        ResultadoExpresion valor
                = generarExpresion(
                        impresion.getExpresion()
                );

        // =====================================================
        // 3. DETERMINAR TIPO
        // =====================================================
        String tipo
                = inferirTipoBasicoAST(
                        impresion.getExpresion()
                );

        // =====================================================
        // 4. STRING
        // =====================================================
        if ("String".equals(tipo)) {

            agregar(
                    impresion.isSaltoLinea()
                    ? "PRINTLN_STRING"
                    : "PRINT_STRING",
                    valor.getValor(),
                    null,
                    null
            );

            return;
        }

        // =====================================================
        // 5. RESTO DE TIPOS
        // =====================================================
        agregar(
                impresion.isSaltoLinea()
                ? "PRINTLN"
                : "PRINT",
                valor.getValor(),
                null,
                null
        );
    }

    // =========================================================
    // EVALUAR ARGUMENTOS ANTES DE CREAR FRAME DE LLAMADA
    // =========================================================
    private List<String> evaluarArgumentosLlamada(
            List<ExpresionASTZ> argumentos) {

        List<String> valores = new ArrayList<>();

        if (argumentos == null) {
            return valores;
        }

        for (ExpresionASTZ argumento : argumentos) {

            ResultadoExpresion resultado
                    = generarExpresion(argumento);

            valores.add(
                    resultado.getValor()
            );
        }

        return valores;
    }

    // =========================================================
    // EXPRESIONES
    // =========================================================
    private ResultadoExpresion generarExpresion(
            ExpresionASTZ expresion) {

        if (expresion == null) {

            return new ResultadoExpresion(
                    "?"
            );
        }

        // =========================================================
        // LITERAL
        // =========================================================
        if (expresion instanceof LiteralASTZ literal) {

            Object valor
                    = literal.getValor();

            // -----------------------------------------------------
            // NULL
            // -----------------------------------------------------
            if (valor == null) {

                return new ResultadoExpresion(
                        "0"
                );
            }

            // -----------------------------------------------------
            // BOOLEAN
            // -----------------------------------------------------
            if (valor instanceof Boolean booleano) {

                return new ResultadoExpresion(
                        booleano
                                ? "1"
                                : "0"
                );
            }

            // -----------------------------------------------------
            // CHAR
            // -----------------------------------------------------
            if (valor instanceof Character caracter) {

                return new ResultadoExpresion(
                        String.valueOf(
                                (int) caracter
                        )
                );
            }

            // -----------------------------------------------------
            // STRING
            // -----------------------------------------------------
            if (valor instanceof String cadena) {

                return generarCadenaHeap(cadena);
            }

            // -----------------------------------------------------
            // INT / DOUBLE
            // -----------------------------------------------------
            return new ResultadoExpresion(
                    String.valueOf(valor)
            );
        }

        // =========================================================
        // ACCESO
        // =========================================================
        if (expresion instanceof AccesoASTZ acceso) {

            if (acceso.getPasos().isEmpty()) {

                String nombre
                        = acceso.getBase();

                // =================================================
                // VARIABLE LOCAL / PARAMETRO
                // =================================================
                if (marcoActual != null) {

                    VariableMemoriaZ variable
                            = marcoActual.buscar(
                                    nombre
                            );

                    if (variable != null) {

                        return new ResultadoExpresion(
                                leerVariableStack(
                                        nombre
                                )
                        );
                    }
                }

                // =================================================
                // ATRIBUTO IMPLICITO DE THIS
                // =================================================
                if (claseActual != null) {

                    AtributoMemoriaZ atributo
                            = claseActual.buscarAtributo(
                                    nombre
                            );

                    if (atributo != null) {

                        String direccion
                                = generarDireccionAtributoThis(
                                        nombre
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
                }
            }

            // =====================================================
            // LLAMADA A METODO DE OBJETO
            // =====================================================
            if (!acceso.getPasos().isEmpty()) {

                PasoAccesoASTZ ultimoPaso
                        = acceso.getPasos().get(
                                acceso.getPasos().size() - 1
                        );

                if ("LLAMADA".equals(
                        ultimoPaso.getTipo().name())) {

                    return generarLlamadaMetodoObjeto(
                            acceso
                    );
                }
            }

            // =====================================================
            // ACCESO A INDICE DE ARREGLO
            // =====================================================
            DireccionIndiceZ direccionIndice
                    = resolverDireccionIndice(
                            acceso
                    );

            if (direccionIndice != null) {

                String valor
                        = temporales.nuevoTemporal();

                agregar(
                        "HEAP_GET",
                        direccionIndice.getDireccion(),
                        null,
                        valor
                );

                return new ResultadoExpresion(
                        valor
                );
            }

            // =====================================================
            // ACCESO COMPLEJO A ATRIBUTO
            // =====================================================
            DireccionAccesoZ direccionAcceso
                    = resolverDireccionAccesoObjeto(
                            acceso
                    );

            if (direccionAcceso != null) {

                String valor
                        = temporales.nuevoTemporal();

                agregar(
                        "HEAP_GET",
                        direccionAcceso.getDireccion(),
                        null,
                        valor
                );

                return new ResultadoExpresion(
                        valor
                );
            }

            return new ResultadoExpresion(
                    describirAcceso(
                            acceso
                    )
            );
        }

        // =========================================================
        // NEW OBJETO
        // =========================================================
        if (expresion instanceof NuevoObjetoASTZ nuevoObjeto) {

            return generarNuevoObjeto(
                    nuevoObjeto
            );
        }

        // =========================================================
        // EXPRESION BINARIA
        // =========================================================
        if (expresion instanceof BinariaASTZ binaria) {

            String operador
                    = binaria.getOperador();

            if ("&&".equals(operador)) {

                return generarAndCortocircuito(
                        binaria
                );
            }

            if ("||".equals(operador)) {

                return generarOrCortocircuito(
                        binaria
                );
            }

            // =====================================================
            // CONCATENACION STRING
            // =====================================================
            if ("+".equals(operador)) {

                String tipoIzquierdo
                        = inferirTipoBasicoAST(
                                binaria.getIzquierda()
                        );

                String tipoDerecho
                        = inferirTipoBasicoAST(
                                binaria.getDerecha()
                        );

                if ("String".equals(tipoIzquierdo)
                        || "String".equals(tipoDerecho)) {

                    return generarConcatenacionString(
                            binaria
                    );
                }
            }

            ResultadoExpresion izquierda
                    = generarExpresion(
                            binaria.getIzquierda()
                    );

            ResultadoExpresion derecha
                    = generarExpresion(
                            binaria.getDerecha()
                    );

            String temporal
                    = temporales.nuevoTemporal();

            agregar(
                    operador,
                    izquierda.getValor(),
                    derecha.getValor(),
                    temporal
            );

            return new ResultadoExpresion(
                    temporal
            );
        }

        // =========================================================
        // EXPRESION UNARIA
        // =========================================================
        if (expresion instanceof UnariaASTZ unaria) {

            ResultadoExpresion valor
                    = generarExpresion(
                            unaria.getExpresion()
                    );

            String temporal
                    = temporales.nuevoTemporal();

            agregar(
                    unaria.getOperador(),
                    valor.getValor(),
                    null,
                    temporal
            );

            return new ResultadoExpresion(
                    temporal
            );
        }

        // =========================================================
        // NUEVO ARREGLO
        // =========================================================
        if (expresion instanceof NuevoArregloASTZ nuevoArreglo) {

            return generarNuevoArreglo(
                    nuevoArreglo
            );
        }

        // =========================================================
        // LLAMADA DIRECTA
        // =========================================================
        if (expresion instanceof LlamadaASTZ llamada) {

            // -----------------------------------------------------
            // READLN
            // -----------------------------------------------------
            if ("readln".equals(
                    llamada.getNombre())) {

                String temporal
                        = temporales.nuevoTemporal();

                agregar(
                        "READLN",
                        null,
                        null,
                        temporal
                );

                return new ResultadoExpresion(
                        temporal
                );
            }

            // -----------------------------------------------------
            // METODO DE LA MISMA INSTANCIA
            // -----------------------------------------------------
            return generarLlamadaMetodoDirecta(
                    llamada
            );
        }

        // =========================================================
        // OPERADOR TERNARIO
        // condicion ? verdadero : falso
        // =========================================================
        if (expresion instanceof TernariaASTZ ternaria) {

            return generarTernaria(
                    ternaria
            );
        }

        // =========================================================
        // INICIALIZADOR DE LISTA
        // =========================================================
        if (expresion instanceof InicializadorListaASTZ) {

            return new ResultadoExpresion(
                    "?"
            );
        }

        // =========================================================
        // EXPRESION NO IMPLEMENTADA
        // =========================================================
        return new ResultadoExpresion(
                "?"
        );
    }

    // =========================================================
    // ACCESO TEMPORAL
    // =========================================================
    private String describirAcceso(
            ExpresionASTZ expresion) {

        if (!(expresion instanceof AccesoASTZ acceso)) {
            return "?";
        }

        StringBuilder sb
                = new StringBuilder(
                        acceso.getBase()
                );

        for (PasoAccesoASTZ paso
                : acceso.getPasos()) {

            switch (paso.getTipo()) {

                case ATRIBUTO ->
                    sb.append(".")
                            .append(
                                    paso.getNombre()
                            );

                case INDICE -> {

                    ResultadoExpresion indice
                            = generarExpresion(
                                    paso.getIndice()
                            );

                    sb.append("[")
                            .append(
                                    indice.getValor()
                            )
                            .append("]");
                }

                case LLAMADA -> {

                    sb.append(".")
                            .append(
                                    paso.getNombre()
                            )
                            .append("(");

                    for (int i = 0;
                            i < paso.getArgumentos().size();
                            i++) {

                        if (i > 0) {
                            sb.append(",");
                        }

                        ResultadoExpresion argumento
                                = generarExpresion(
                                        paso.getArgumentos()
                                                .get(i)
                                );

                        sb.append(
                                argumento.getValor()
                        );
                    }

                    sb.append(")");
                }
            }
        }

        return sb.toString();
    }

    // =========================================================
    // FIRMA
    // =========================================================
    private String construirFirma(
            String nombre,
            List<ParametroASTZ> parametros) {

        StringBuilder sb
                = new StringBuilder();

        sb.append(nombre)
                .append("(");

        for (int i = 0;
                i < parametros.size();
                i++) {

            if (i > 0) {
                sb.append(",");
            }

            ParametroASTZ parametro
                    = parametros.get(i);

            sb.append(
                    describirTipo(
                            parametro.getTipo(),
                            parametro.getDimensiones()
                    )
            );
        }

        sb.append(")");

        return sb.toString();
    }

    private String describirTipo(
            String tipo,
            int dimensiones) {

        StringBuilder sb
                = new StringBuilder(tipo);

        for (int i = 0;
                i < dimensiones;
                i++) {

            sb.append("[]");
        }

        return sb.toString();
    }

    private String leerVariableStack(
            String nombre) {

        if (marcoActual == null) {
            return nombre;
        }

        VariableMemoriaZ variable
                = buscarVariableVisible(
                        nombre
                );

        if (variable == null) {
            return nombre;
        }

        String direccion
                = temporales.nuevoTemporal();

        agregar(
                "+",
                "P",
                String.valueOf(
                        variable.getOffset()
                ),
                direccion
        );

        String valor
                = temporales.nuevoTemporal();

        agregar(
                "STACK_GET",
                direccion,
                null,
                valor
        );

        return valor;
    }

    private void escribirVariableStack(
            String nombre,
            String valor) {

        if (marcoActual == null) {

            agregar(
                    "=",
                    valor,
                    null,
                    nombre
            );

            return;
        }

        VariableMemoriaZ variable
                = buscarVariableVisible(
                        nombre
                );

        if (variable == null) {

            agregar(
                    "=",
                    valor,
                    null,
                    nombre
            );

            return;
        }

        String direccion
                = temporales.nuevoTemporal();

        agregar(
                "+",
                "P",
                String.valueOf(
                        variable.getOffset()
                ),
                direccion
        );

        agregar(
                "STACK_SET",
                valor,
                null,
                direccion
        );
    }

    private String leerThis() {

        if (marcoActual == null) {
            return "?";
        }

        VariableMemoriaZ thisVariable
                = marcoActual.getThis();

        String direccion
                = temporales.nuevoTemporal();

        agregar(
                "+",
                "P",
                String.valueOf(
                        thisVariable.getOffset()
                ),
                direccion
        );

        String punteroObjeto
                = temporales.nuevoTemporal();

        agregar(
                "STACK_GET",
                direccion,
                null,
                punteroObjeto
        );

        return punteroObjeto;
    }

    private String generarDireccionAtributoThis(
            String nombreAtributo) {

        if (claseActual == null) {
            return null;
        }

        AtributoMemoriaZ atributo
                = claseActual.buscarAtributo(
                        nombreAtributo
                );

        if (atributo == null) {
            return null;
        }

        String thisPtr
                = leerThis();

        String direccion
                = temporales.nuevoTemporal();

        agregar(
                "+",
                thisPtr,
                String.valueOf(
                        atributo.getOffset()
                ),
                direccion
        );

        return direccion;
    }

    private void inicializarAtributosInstancia(
            ClaseASTZ clase) {

        if (clase == null
                || claseActual == null
                || marcoActual == null) {

            return;
        }

        for (MiembroASTZ miembro
                : clase.getMiembros()) {

            if (!(miembro instanceof AtributoASTZ atributo)) {
                continue;
            }

            if (atributo.getInicializador() == null) {
                continue;
            }

            AtributoMemoriaZ atributoMemoria
                    = claseActual.buscarAtributo(
                            atributo.getNombre()
                    );

            if (atributoMemoria == null) {
                continue;
            }

            ResultadoExpresion valor;

            // =====================================================
            // ATRIBUTO ARREGLO INICIALIZADO CON LISTA
            // =====================================================
            if (atributo.getInicializador() instanceof InicializadorListaASTZ lista) {

                if (atributo.getDimensiones() <= 0) {

                    agregar(
                            "ERROR_C3D",
                            "Inicializador de lista en atributo no arreglo",
                            atributo.getNombre(),
                            null
                    );

                    continue;
                }

                valor = generarInicializadorListaArreglo(
                        lista,
                        atributo.getDimensiones()
                );

            } else {

                // =================================================
                // INICIALIZADOR NORMAL
                // =================================================
                valor = generarExpresion(
                        atributo.getInicializador()
                );
            }

            if (valor == null
                    || valor.getValor() == null
                    || "?".equals(valor.getValor())) {

                agregar(
                        "ERROR_C3D",
                        "No se pudo generar inicializador de atributo",
                        atributo.getNombre(),
                        null
                );

                continue;
            }

            String direccion
                    = generarDireccionAtributoThis(
                            atributo.getNombre()
                    );

            if (direccion == null) {

                agregar(
                        "ERROR_C3D",
                        "No se pudo resolver direccion de atributo",
                        atributo.getNombre(),
                        null
                );

                continue;
            }

            agregar(
                    "HEAP_SET",
                    valor.getValor(),
                    null,
                    direccion
            );
        }
    }

    private ResultadoExpresion generarNuevoObjeto(
            NuevoObjetoASTZ nuevoObjeto) {

        if (nuevoObjeto == null) {

            return new ResultadoExpresion(
                    "?"
            );
        }

        String nombreClase
                = nuevoObjeto.getTipo();

        ClaseMemoriaZ clase
                = tablaMemoria.buscarClase(
                        nombreClase
                );

        if (clase == null) {

            return new ResultadoExpresion(
                    "?"
            );
        }

        // =====================================================
        // 1. RESOLVER FIRMA DEL CONSTRUCTOR
        // =====================================================
        String firma
                = construirFirmaConstructorDesdeArgumentos(
                        nombreClase,
                        nuevoObjeto.getArgumentos()
                );

        MarcoMetodoZ marcoConstructor
                = tablaMemoria.buscar(
                        firma
                );

        if (marcoConstructor == null) {

            agregar(
                    "ERROR_C3D",
                    "Constructor no encontrado",
                    firma,
                    null
            );

            return new ResultadoExpresion(
                    "?"
            );
        }

        // =====================================================
        // 2. EVALUAR ARGUMENTOS ANTES DE PREPARAR FRAME
        // =====================================================
        List<String> valoresArgumentos
                = evaluarArgumentosLlamada(
                        nuevoObjeto.getArgumentos()
                );

        // =====================================================
        // 3. RESERVAR OBJETO EN HEAP
        // =====================================================
        String punteroObjeto
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "H",
                null,
                punteroObjeto
        );

        int tamanoReserva
                = Math.max(
                        1,
                        clase.getTamanoObjeto()
                );

        agregar(
                "+",
                "H",
                String.valueOf(tamanoReserva),
                "H"
        );

        // =====================================================
        // 4. TAMAÑO DEL FRAME ACTUAL
        // =====================================================
        int tamanoActual
                = marcoActual != null
                        ? marcoActual.getTamanoMarco()
                        : 0;

        // =====================================================
        // 5. CALCULAR NUEVA BASE
        // =====================================================
        String nuevaBase
                = temporales.nuevoTemporal();

        agregar(
                "+",
                "P",
                String.valueOf(tamanoActual),
                nuevaBase
        );

        // =====================================================
        // 6. THIS DEL CONSTRUCTOR
        // =====================================================
        String direccionThis
                = temporales.nuevoTemporal();

        agregar(
                "+",
                nuevaBase,
                "1",
                direccionThis
        );

        agregar(
                "STACK_SET",
                punteroObjeto,
                null,
                direccionThis
        );

        // =====================================================
        // 7. ARGUMENTOS YA EVALUADOS
        // =====================================================
        for (int i = 0;
                i < valoresArgumentos.size();
                i++) {

            String direccionParametro
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    nuevaBase,
                    String.valueOf(i + 2),
                    direccionParametro
            );

            agregar(
                    "STACK_SET",
                    valoresArgumentos.get(i),
                    null,
                    direccionParametro
            );
        }

        // =====================================================
        // 8. ENTRAR AL FRAME
        // =====================================================
        agregar(
                "+",
                "P",
                String.valueOf(tamanoActual),
                "P"
        );

        // =====================================================
        // 9. CALL CONSTRUCTOR
        // =====================================================
        agregar(
                "CALL",
                firma,
                null,
                null
        );

        // =====================================================
        // 10. RESTAURAR P
        // =====================================================
        agregar(
                "-",
                "P",
                String.valueOf(tamanoActual),
                "P"
        );

        // =====================================================
        // 11. RESULTADO = REFERENCIA AL OBJETO
        // =====================================================
        return new ResultadoExpresion(
                punteroObjeto
        );
    }

    private String construirFirmaConstructorDesdeArgumentos(
            String nombreClase,
            List<ExpresionASTZ> argumentos) {

        if (argumentos == null
                || argumentos.isEmpty()) {

            return nombreClase + "()";
        }

        StringBuilder sb
                = new StringBuilder();

        sb.append(nombreClase)
                .append("(");

        for (int i = 0;
                i < argumentos.size();
                i++) {

            if (i > 0) {
                sb.append(",");
            }

            sb.append(
                    inferirTipoBasicoAST(
                            argumentos.get(i)
                    )
            );
        }

        sb.append(")");

        return sb.toString();
    }

    private String inferirTipoBasicoAST(
            ExpresionASTZ expresion) {

        if (expresion == null) {
            return "?";
        }

        // =========================================================
        // 1. LITERAL
        // =========================================================
        if (expresion instanceof LiteralASTZ literal) {
            return literal.getTipo();
        }

        // =========================================================
        // 2. NEW OBJETO
        // =========================================================
        if (expresion instanceof NuevoObjetoASTZ nuevo) {
            return nuevo.getTipo();
        }

        // =========================================================
        // 3. NEW ARREGLO
        // =========================================================
        if (expresion instanceof NuevoArregloASTZ nuevoArreglo) {

            return describirTipo(
                    nuevoArreglo.getTipoBase(),
                    nuevoArreglo.getDimensiones().size()
            );
        }

        // =========================================================
        // 4. ACCESO
        // =========================================================
        if (expresion instanceof AccesoASTZ acceso) {

            String tipoActual = null;
            int dimensionesActual = 0;

            // =====================================================
            // 4.1 RESOLVER LA BASE
            // =====================================================
            if (marcoActual != null) {

                VariableMemoriaZ variable
                        = marcoActual.buscar(
                                acceso.getBase()
                        );

                if (variable != null) {

                    tipoActual
                            = variable.getTipo();

                    dimensionesActual
                            = variable.getDimensiones();
                }
            }

            // =====================================================
            // 4.2 SI NO ES LOCAL/PARAMETRO,
            // =====================================================
            if (tipoActual == null
                    && claseActual != null) {

                AtributoMemoriaZ atributo
                        = claseActual.buscarAtributo(
                                acceso.getBase()
                        );

                if (atributo != null) {

                    tipoActual
                            = atributo.getTipo();

                    dimensionesActual
                            = atributo.getDimensiones();
                }
            }

            if (tipoActual == null) {
                return "?";
            }

            // =====================================================
            // 4.3 SIN PASOS
            // =====================================================
            if (acceso.getPasos().isEmpty()) {

                return describirTipo(
                        tipoActual,
                        dimensionesActual
                );
            }

            // =====================================================
            // 4.4 RECORRER PASOS
            // =====================================================
            for (PasoAccesoASTZ paso
                    : acceso.getPasos()) {

                if (paso == null) {
                    return "?";
                }

                // =================================================
                // INDICE
                // =================================================
                if (paso.getTipo()
                        == PasoAccesoASTZ.TipoPaso.INDICE) {

                    if (dimensionesActual <= 0) {
                        return "?";
                    }

                    dimensionesActual--;

                    continue;
                }

                // =================================================
                // ATRIBUTO
                // =================================================
                if (paso.getTipo()
                        == PasoAccesoASTZ.TipoPaso.ATRIBUTO) {

                    if (dimensionesActual != 0) {
                        return "?";
                    }

                    ClaseMemoriaZ claseTipo
                            = tablaMemoria != null
                                    ? tablaMemoria.buscarClase(
                                            tipoActual
                                    )
                                    : null;

                    if (claseTipo == null) {
                        return "?";
                    }

                    AtributoMemoriaZ atributo
                            = claseTipo.buscarAtributo(
                                    paso.getNombre()
                            );

                    if (atributo == null) {
                        return "?";
                    }

                    tipoActual
                            = atributo.getTipo();

                    dimensionesActual
                            = atributo.getDimensiones();

                    continue;
                }

                // =================================================
                // LLAMADA A METODO
                // =================================================
                if (paso.getTipo()
                        == PasoAccesoASTZ.TipoPaso.LLAMADA) {

                    if (dimensionesActual != 0) {
                        return "?";
                    }

                    String tipoRetorno
                            = inferirTipoRetornoMetodoObjeto(
                                    tipoActual,
                                    paso.getNombre(),
                                    paso.getArgumentos()
                            );

                    /*
                     * Respaldo para módulos con varias clases. El marco
                     * combinado conserva la firma y el tipo de retorno,
                     * aunque la búsqueda por AST no logre resolverlo.
                     */
                    if (tipoRetorno == null
                            && tablaMemoria != null) {

                        String firmaMetodo
                                = construirFirmaMetodoDesdeArgumentos(
                                        paso.getNombre(),
                                        paso.getArgumentos()
                                );

                        MarcoMetodoZ marcoMetodo
                                = tablaMemoria.buscar(firmaMetodo);

                        if (marcoMetodo != null
                                && marcoMetodo.getRetorno() != null) {

                            tipoRetorno
                                    = describirTipo(
                                            marcoMetodo.getRetorno().getTipo(),
                                            marcoMetodo.getRetorno().getDimensiones()
                                    );
                        }
                    }

                    if (tipoRetorno == null) {
                        return "?";
                    }

                    tipoActual = tipoRetorno;
                    dimensionesActual = 0;
                }
            }

            return describirTipo(
                    tipoActual,
                    dimensionesActual
            );
        }

        // =========================================================
        // 5. BINARIA
        // =========================================================
        if (expresion instanceof BinariaASTZ binaria) {

            String tipoIzquierdo
                    = inferirTipoBasicoAST(
                            binaria.getIzquierda()
                    );

            String tipoDerecho
                    = inferirTipoBasicoAST(
                            binaria.getDerecha()
                    );

            String operador
                    = binaria.getOperador();

            // -----------------------------------------------------
            // CONCATENACION STRING
            // -----------------------------------------------------
            if ("+".equals(operador)
                    && ("String".equals(tipoIzquierdo)
                    || "String".equals(tipoDerecho))) {

                return "String";
            }

            // -----------------------------------------------------
            // RELACIONALES / LOGICOS
            // -----------------------------------------------------
            if ("==".equals(operador)
                    || "!=".equals(operador)
                    || "<".equals(operador)
                    || ">".equals(operador)
                    || "<=".equals(operador)
                    || ">=".equals(operador)
                    || "&&".equals(operador)
                    || "||".equals(operador)) {

                return "boolean";
            }

            // -----------------------------------------------------
            // NUMERICOS
            // -----------------------------------------------------
            if ("double".equals(tipoIzquierdo)
                    || "double".equals(tipoDerecho)) {

                return "double";
            }

            if ("int".equals(tipoIzquierdo)
                    && "int".equals(tipoDerecho)) {

                return "int";
            }

            return "?";
        }

        // =========================================================
        // 6. UNARIA
        // =========================================================
        if (expresion instanceof UnariaASTZ unaria) {

            if ("!".equals(unaria.getOperador())) {
                return "boolean";
            }

            return inferirTipoBasicoAST(
                    unaria.getExpresion()
            );
        }

        // =========================================================
        // 7. LLAMADA DIRECTA
        // =========================================================
        if (expresion instanceof LlamadaASTZ llamada) {

            String tipoRetorno
                    = inferirTipoRetornoLlamada(
                            llamada
                    );

            if (tipoRetorno != null) {
                return tipoRetorno;
            }

            return "?";
        }

        // =========================================================
        // 8. TERNARIA
        // =========================================================
        if (expresion instanceof TernariaASTZ ternaria) {

            String tipoVerdadero
                    = inferirTipoBasicoAST(
                            ternaria.getVerdadero()
                    );

            String tipoFalso
                    = inferirTipoBasicoAST(
                            ternaria.getFalso()
                    );

            if (tipoVerdadero.equals(tipoFalso)) {
                return tipoVerdadero;
            }

            if (("double".equals(tipoVerdadero)
                    && "int".equals(tipoFalso))
                    || ("int".equals(tipoVerdadero)
                    && "double".equals(tipoFalso))) {

                return "double";
            }

            if ("null".equals(tipoVerdadero)) {
                return tipoFalso;
            }

            if ("null".equals(tipoFalso)) {
                return tipoVerdadero;
            }

            return "?";
        }

        return "?";
    }

    // =========================================================
    // RESULTADO DE DIRECCION DE ACCESO
    // =========================================================
    private static class DireccionAccesoZ {

        private final String direccion;
        private final String tipo;
        private final int dimensiones;

        public DireccionAccesoZ(
                String direccion,
                String tipo,
                int dimensiones) {

            this.direccion = direccion;
            this.tipo = tipo;
            this.dimensiones = dimensiones;
        }

        public String getDireccion() {
            return direccion;
        }

        public String getTipo() {
            return tipo;
        }

        public int getDimensiones() {
            return dimensiones;
        }
    }

    // =========================================================
    // DIRECCION DE ACCESO A ATRIBUTO DE OBJETO
    // =========================================================
    private DireccionAccesoZ resolverDireccionAccesoObjeto(
            AccesoASTZ acceso) {

        if (acceso == null
                || acceso.getPasos().isEmpty()) {

            return null;
        }

        String nombreBase
                = acceso.getBase();

        List<PasoAccesoASTZ> pasos
                = acceso.getPasos();

        String punteroActual;
        String tipoActual;
        int dimensionesActual;

        // =====================================================
        // 1. RESOLVER BASE
        // =====================================================
        VariableMemoriaZ variableBase
                = marcoActual != null
                        ? marcoActual.buscar(nombreBase)
                        : null;

        AtributoMemoriaZ atributoBase = null;

        // =====================================================
        // 1.1 BASE LOCAL / PARAMETRO
        // =====================================================
        if (variableBase != null) {

            tipoActual
                    = variableBase.getTipo();

            dimensionesActual
                    = variableBase.getDimensiones();

            punteroActual
                    = leerVariableStack(
                            nombreBase
                    );

        } else {

            // =================================================
            // 1.2 BASE COMO ATRIBUTO IMPLICITO DE THIS
            // =================================================
            if (claseActual == null) {
                return null;
            }

            atributoBase
                    = claseActual.buscarAtributo(
                            nombreBase
                    );

            if (atributoBase == null) {
                return null;
            }

            String direccionBase
                    = generarDireccionAtributoThis(
                            nombreBase
                    );

            punteroActual
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccionBase,
                    null,
                    punteroActual
            );

            tipoActual
                    = atributoBase.getTipo();

            dimensionesActual
                    = atributoBase.getDimensiones();
        }

        // =====================================================
        // 2. CONTAR INDICES INICIALES
        // =====================================================
        int cantidadIndicesIniciales = 0;

        while (cantidadIndicesIniciales
                < pasos.size()
                && pasos.get(
                        cantidadIndicesIniciales
                ).getTipo()
                == PasoAccesoASTZ.TipoPaso.INDICE) {

            cantidadIndicesIniciales++;
        }

        // =====================================================
        // 3. SI LA BASE ES UN ARREGLO
        // =====================================================
        if (dimensionesActual > 0) {

            if (cantidadIndicesIniciales
                    != dimensionesActual) {

                return null;
            }

            if (variableBase == null) {
                return null;
            }

            punteroActual
                    = resolverPunteroObjetoDesdeArreglo(
                            acceso,
                            cantidadIndicesIniciales
                    );

            if (punteroActual == null) {
                return null;
            }

            dimensionesActual = 0;

        } else {

            if (cantidadIndicesIniciales > 0) {
                return null;
            }
        }

        // =====================================================
        // 4. DEBE QUEDAR AL MENOS UN PASO
        // =====================================================
        if (cantidadIndicesIniciales
                >= pasos.size()) {

            return null;
        }

        // =====================================================
        // 5. RECORRER ATRIBUTOS DESPUES DE LOS INDICES
        // =====================================================
        for (int i = cantidadIndicesIniciales;
                i < pasos.size();
                i++) {

            PasoAccesoASTZ paso
                    = pasos.get(i);

            if (paso.getTipo()
                    != PasoAccesoASTZ.TipoPaso.ATRIBUTO) {

                return null;
            }

            if (dimensionesActual > 0) {
                return null;
            }

            // =================================================
            // BUSCAR CLASE DEL OBJETO ACTUAL
            // =================================================
            ClaseMemoriaZ claseTipo
                    = tablaMemoria.buscarClase(
                            tipoActual
                    );

            if (claseTipo == null) {
                return null;
            }

            // =================================================
            // BUSCAR ATRIBUTO
            // =================================================
            AtributoMemoriaZ atributo
                    = claseTipo.buscarAtributo(
                            paso.getNombre()
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

            boolean ultimo
                    = i == pasos.size() - 1;

            // =================================================
            // 6. ULTIMO ATRIBUTO
            // =================================================
            if (ultimo) {

                return new DireccionAccesoZ(
                        direccion,
                        atributo.getTipo(),
                        atributo.getDimensiones()
                );
            }

            // =================================================
            // 7. ATRIBUTO INTERMEDIO
            // =================================================
            if (atributo.getDimensiones() > 0) {

                /*
             * objeto.arreglo[i].atributo será una
             * extensión posterior.
                 */
                return null;
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

            dimensionesActual
                    = atributo.getDimensiones();
        }

        return null;
    }

    // =========================================================
    // BUSCAR METODO AST POR FIRMA
    // =========================================================
    private MetodoASTZ buscarMetodoPorFirma(
            String firma) {

        return buscarMetodoPorFirma(
                claseASTActual != null
                        ? claseASTActual.getNombre()
                        : null,
                firma
        );
    }

    private MetodoASTZ buscarMetodoPorFirma(
            String nombreClase,
            String firma) {

        if (nombreClase == null
                || firma == null) {

            return null;
        }

        ClaseASTZ claseBuscada
                = clasesAST.get(nombreClase);

        if (claseBuscada == null) {
            return null;
        }

        for (MiembroASTZ miembro
                : claseBuscada.getMiembros()) {

            if (!(miembro instanceof MetodoASTZ metodo)) {
                continue;
            }

            String firmaMetodo
                    = construirFirma(
                            metodo.getNombre(),
                            metodo.getParametros()
                    );

            if (firma.equals(firmaMetodo)) {
                return metodo;
            }
        }

        return null;
    }

    // =========================================================
    // FIRMA DE LLAMADA A METODO
    // =========================================================
    private String construirFirmaMetodoDesdeArgumentos(
            String nombreMetodo,
            List<ExpresionASTZ> argumentos) {

        StringBuilder sb
                = new StringBuilder();

        sb.append(nombreMetodo)
                .append("(");

        if (argumentos != null) {

            for (int i = 0;
                    i < argumentos.size();
                    i++) {

                if (i > 0) {
                    sb.append(",");
                }

                String tipoArgumento
                        = inferirTipoBasicoAST(
                                argumentos.get(i)
                        );

                sb.append(
                        tipoArgumento
                );
            }
        }

        sb.append(")");

        return sb.toString();
    }

    // =========================================================
    // LLAMADA DIRECTA A METODO
    // =========================================================
    private ResultadoExpresion generarLlamadaMetodoDirecta(
            LlamadaASTZ llamada) {

        if (llamada == null) {

            return new ResultadoExpresion(
                    "?"
            );
        }

        String nombreMetodo
                = llamada.getNombre();

        List<ExpresionASTZ> argumentos
                = llamada.getArgumentos();

        // =====================================================
        // 1. CONSTRUIR FIRMA
        // =====================================================
        String firma
                = construirFirmaMetodoDesdeArgumentos(
                        nombreMetodo,
                        argumentos
                );

        // =====================================================
        // 2. BUSCAR FRAME DEL METODO
        // =====================================================
        MarcoMetodoZ marcoDestino
                = tablaMemoria.buscar(
                        firma
                );

        if (marcoDestino == null) {

            agregar(
                    "ERROR_C3D",
                    "Metodo no encontrado",
                    firma,
                    null
            );

            return new ResultadoExpresion(
                    "?"
            );
        }

        // =====================================================
        // 3. BUSCAR INFORMACION DEL METODO
        // =====================================================
        MetodoASTZ metodoDestino
                = buscarMetodoPorFirma(
                        firma
                );

        String tipoRetorno
                = metodoDestino != null
                        ? metodoDestino.getTipoRetorno()
                        : "any";

        // =====================================================
        // 4. TAMAÑO DEL FRAME ACTUAL
        // =====================================================
        int tamanoActual
                = marcoActual != null
                        ? marcoActual.getTamanoMarco()
                        : 0;

        // =====================================================
        // 5. CAPTURAR THIS DEL LLAMADOR
        // =====================================================
        String thisActual
                = leerThis();

        // =====================================================
        // 6. EVALUAR TODOS LOS ARGUMENTOS PRIMERO
        // =====================================================
        List<String> valoresArgumentos
                = evaluarArgumentosLlamada(
                        argumentos
                );

        // =====================================================
        // 7. AHORA SI CREAR EL FRAME DE LA LLAMADA
        // =====================================================
        String nuevaBase
                = temporales.nuevoTemporal();

        agregar(
                "+",
                "P",
                String.valueOf(tamanoActual),
                nuevaBase
        );

        // =====================================================
        // 8. PASAR THIS
        // =====================================================
        String direccionThis
                = temporales.nuevoTemporal();

        agregar(
                "+",
                nuevaBase,
                "1",
                direccionThis
        );

        agregar(
                "STACK_SET",
                thisActual,
                null,
                direccionThis
        );

        // =====================================================
        // 9. PASAR ARGUMENTOS YA EVALUADOS
        // =====================================================
        for (int i = 0;
                i < valoresArgumentos.size();
                i++) {

            String direccionParametro
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    nuevaBase,
                    String.valueOf(i + 2),
                    direccionParametro
            );

            agregar(
                    "STACK_SET",
                    valoresArgumentos.get(i),
                    null,
                    direccionParametro
            );
        }

        // =====================================================
        // 10. ENTRAR AL FRAME
        // =====================================================
        agregar(
                "+",
                "P",
                String.valueOf(tamanoActual),
                "P"
        );

        // =====================================================
        // 11. CALL
        // =====================================================
        agregar(
                "CALL",
                firma,
                null,
                null
        );

        // =====================================================
        // 12. RECUPERAR RETORNO
        // =====================================================
        String resultado = null;

        if (!"void".equals(tipoRetorno)) {

            String direccionRetorno
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    "P",
                    "0",
                    direccionRetorno
            );

            resultado
                    = temporales.nuevoTemporal();

            agregar(
                    "STACK_GET",
                    direccionRetorno,
                    null,
                    resultado
            );
        }

        // =====================================================
        // 13. RESTAURAR FRAME
        // =====================================================
        agregar(
                "-",
                "P",
                String.valueOf(tamanoActual),
                "P"
        );

        // =====================================================
        // 14. RESULTADO
        // =====================================================
        if ("void".equals(tipoRetorno)) {

            return new ResultadoExpresion(
                    "void"
            );
        }

        return new ResultadoExpresion(
                resultado
        );
    }

    // =========================================================
    // RECEPTOR DE LLAMADA A METODO
    // =========================================================
    private static class ReceptorMetodoZ {

        private final String puntero;
        private final String tipo;

        public ReceptorMetodoZ(
                String puntero,
                String tipo) {

            this.puntero = puntero;
            this.tipo = tipo;
        }

        public String getPuntero() {
            return puntero;
        }

        public String getTipo() {
            return tipo;
        }
    }

    // =========================================================
    // RESOLVER RECEPTOR DE METODO DE OBJETO
    // =========================================================
    private ReceptorMetodoZ resolverReceptorMetodoObjeto(
            AccesoASTZ acceso) {

        if (acceso == null
                || acceso.getPasos().isEmpty()) {

            return null;
        }

        List<PasoAccesoASTZ> pasos
                = acceso.getPasos();

        // =====================================================
        // 0. EL ULTIMO PASO DEBE SER UNA LLAMADA
        // =====================================================
        PasoAccesoASTZ ultimoPaso
                = pasos.get(
                        pasos.size() - 1
                );

        if (ultimoPaso.getTipo()
                != PasoAccesoASTZ.TipoPaso.LLAMADA) {

            return null;
        }

        String nombreBase
                = acceso.getBase();

        String punteroActual;
        String tipoActual;
        int dimensionesActual;

        // =====================================================
        // 1. RESOLVER BASE
        // =====================================================
        VariableMemoriaZ variableBase
                = marcoActual != null
                        ? marcoActual.buscar(nombreBase)
                        : null;

        AtributoMemoriaZ atributoBase = null;

        // =====================================================
        // 1.1 VARIABLE LOCAL / PARAMETRO
        // =====================================================
        if (variableBase != null) {

            punteroActual
                    = leerVariableStack(
                            nombreBase
                    );

            tipoActual
                    = variableBase.getTipo();

            dimensionesActual
                    = variableBase.getDimensiones();

        } else {

            // =================================================
            // 1.2 ATRIBUTO IMPLICITO DE THIS
            // =================================================
            if (claseActual == null) {
                return null;
            }

            atributoBase
                    = claseActual.buscarAtributo(
                            nombreBase
                    );

            if (atributoBase == null) {
                return null;
            }

            String direccionBase
                    = generarDireccionAtributoThis(
                            nombreBase
                    );

            punteroActual
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccionBase,
                    null,
                    punteroActual
            );

            tipoActual
                    = atributoBase.getTipo();

            dimensionesActual
                    = atributoBase.getDimensiones();
        }

        int cantidadIndicesIniciales = 0;

        while (cantidadIndicesIniciales
                < pasos.size() - 1
                && pasos.get(
                        cantidadIndicesIniciales
                ).getTipo()
                == PasoAccesoASTZ.TipoPaso.INDICE) {

            cantidadIndicesIniciales++;
        }

        // =====================================================
        // 3. SI LA BASE ES ARREGLO/MATRIZ
        // =====================================================
        if (dimensionesActual > 0) {

            // Para obtener un OBJETO individual deben consumirse
            // todas las dimensiones.
            if (cantidadIndicesIniciales
                    != dimensionesActual) {

                return null;
            }

            if (variableBase == null) {

                return null;
            }

            String punteroObjeto
                    = resolverPunteroObjetoDesdeArreglo(
                            acceso,
                            cantidadIndicesIniciales
                    );

            if (punteroObjeto == null) {
                return null;
            }

            punteroActual
                    = punteroObjeto;

            dimensionesActual = 0;

        } else {

            // Si no era arreglo, no deberían existir índices
            // iniciales.
            if (cantidadIndicesIniciales > 0) {
                return null;
            }
        }

        for (int i = cantidadIndicesIniciales;
                i < pasos.size() - 1;
                i++) {

            PasoAccesoASTZ paso
                    = pasos.get(i);

            if (paso.getTipo()
                    != PasoAccesoASTZ.TipoPaso.ATRIBUTO) {

                return null;
            }

            if (dimensionesActual > 0) {
                return null;
            }

            // =================================================
            // 4.1 BUSCAR CLASE DEL OBJETO ACTUAL
            // =================================================
            ClaseMemoriaZ claseTipo
                    = tablaMemoria.buscarClase(
                            tipoActual
                    );

            if (claseTipo == null) {
                return null;
            }

            // =================================================
            // 4.2 BUSCAR ATRIBUTO
            // =================================================
            AtributoMemoriaZ atributo
                    = claseTipo.buscarAtributo(
                            paso.getNombre()
                    );

            if (atributo == null) {
                return null;
            }

            if (atributo.getDimensiones() > 0) {
                return null;
            }

            // =================================================
            // 4.3 DIRECCION DEL ATRIBUTO
            // =================================================
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

            // =================================================
            // 4.4 LEER REFERENCIA DEL SIGUIENTE OBJETO
            // =================================================
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

            dimensionesActual
                    = atributo.getDimensiones();
        }

        // =====================================================
        // 5. VALIDACION FINAL
        // =====================================================
        if (dimensionesActual != 0) {

            return null;
        }

        // =====================================================
        // 6. OBJETO QUE RECIBIRA EL METODO
        // =====================================================
        return new ReceptorMetodoZ(
                punteroActual,
                tipoActual
        );
    }

    // =========================================================
    // LLAMADA A METODO DE OBJETO
    // =========================================================
    private ResultadoExpresion generarLlamadaMetodoObjeto(
            AccesoASTZ acceso) {

        if (acceso == null
                || acceso.getPasos().isEmpty()) {

            return new ResultadoExpresion(
                    "?"
            );
        }

        // =====================================================
        // 1. OBTENER LLAMADA
        // =====================================================
        List<PasoAccesoASTZ> pasos
                = acceso.getPasos();

        PasoAccesoASTZ llamada
                = pasos.get(
                        pasos.size() - 1
                );

        if (llamada.getTipo()
                != PasoAccesoASTZ.TipoPaso.LLAMADA) {

            return new ResultadoExpresion(
                    "?"
            );
        }

        // =====================================================
        // 2. RESOLVER RECEPTOR
        // =====================================================
        ReceptorMetodoZ receptor
                = resolverReceptorMetodoObjeto(
                        acceso
                );

        if (receptor == null) {

            return new ResultadoExpresion(
                    "?"
            );
        }

        /*
     * El puntero del receptor queda guardado en un temporal.
     * Aunque los argumentos hagan llamadas anidadas, ese
     * temporal seguirá representando el objeto receptor.
         */
        String punteroReceptor
                = receptor.getPuntero();

        String nombreMetodo
                = llamada.getNombre();

        List<ExpresionASTZ> argumentos
                = llamada.getArgumentos();

        // =====================================================
        // 3. CONSTRUIR FIRMA
        // =====================================================
        String firma
                = construirFirmaMetodoDesdeArgumentos(
                        nombreMetodo,
                        argumentos
                );

        // =====================================================
        // 4. BUSCAR FRAME
        // =====================================================
        MarcoMetodoZ marcoDestino
                = tablaMemoria.buscar(
                        firma
                );

        if (marcoDestino == null) {

            agregar(
                    "ERROR_C3D",
                    "Metodo no encontrado",
                    firma,
                    null
            );

            return new ResultadoExpresion(
                    "?"
            );
        }

        // =====================================================
        // 5. TIPO DE RETORNO
        // =====================================================
        MetodoASTZ metodoDestino
                = buscarMetodoPorFirma(
                        receptor.getTipo(),
                        firma
                );

        String tipoRetorno
                = metodoDestino != null
                        ? metodoDestino.getTipoRetorno()
                        : "any";

        // =====================================================
        // 6. TAMAÑO DEL CALLER
        // =====================================================
        int tamanoActual
                = marcoActual != null
                        ? marcoActual.getTamanoMarco()
                        : 0;

        // =====================================================
        // 7. EVALUAR ARGUMENTOS COMPLETAMENTE
        // =====================================================
        List<String> valoresArgumentos
                = evaluarArgumentosLlamada(
                        argumentos
                );

        // =====================================================
        // 8. CREAR FRAME EXTERIOR
        // =====================================================
        String nuevaBase
                = temporales.nuevoTemporal();

        agregar(
                "+",
                "P",
                String.valueOf(tamanoActual),
                nuevaBase
        );

        // =====================================================
        // 9. THIS = OBJETO RECEPTOR
        // =====================================================
        String direccionThis
                = temporales.nuevoTemporal();

        agregar(
                "+",
                nuevaBase,
                "1",
                direccionThis
        );

        agregar(
                "STACK_SET",
                punteroReceptor,
                null,
                direccionThis
        );

        // =====================================================
        // 10. ARGUMENTOS
        // =====================================================
        for (int i = 0;
                i < valoresArgumentos.size();
                i++) {

            String direccionParametro
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    nuevaBase,
                    String.valueOf(i + 2),
                    direccionParametro
            );

            agregar(
                    "STACK_SET",
                    valoresArgumentos.get(i),
                    null,
                    direccionParametro
            );
        }

        // =====================================================
        // 11. ENTRAR AL FRAME
        // =====================================================
        agregar(
                "+",
                "P",
                String.valueOf(tamanoActual),
                "P"
        );

        // =====================================================
        // 12. CALL
        // =====================================================
        agregar(
                "CALL",
                firma,
                null,
                null
        );

        // =====================================================
        // 13. RECUPERAR RETORNO
        // =====================================================
        String resultado = null;

        if (!"void".equals(tipoRetorno)) {

            String direccionRetorno
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    "P",
                    "0",
                    direccionRetorno
            );

            resultado
                    = temporales.nuevoTemporal();

            agregar(
                    "STACK_GET",
                    direccionRetorno,
                    null,
                    resultado
            );
        }

        // =====================================================
        // 14. RESTAURAR P
        // =====================================================
        agregar(
                "-",
                "P",
                String.valueOf(tamanoActual),
                "P"
        );

        // =====================================================
        // 15. RESULTADO
        // =====================================================
        if ("void".equals(tipoRetorno)) {

            return new ResultadoExpresion(
                    "void"
            );
        }

        return new ResultadoExpresion(
                resultado
        );
    }

    // =========================================================
    // RESULTADO DE DIRECCION DE INDICE
    // =========================================================
    private static class DireccionIndiceZ {

        private final String direccion;
        private final String tipoElemento;
        private final int dimensionesRestantes;

        public DireccionIndiceZ(
                String direccion,
                String tipoElemento,
                int dimensionesRestantes) {

            this.direccion = direccion;
            this.tipoElemento = tipoElemento;
            this.dimensionesRestantes = dimensionesRestantes;
        }

        public String getDireccion() {
            return direccion;
        }

        public String getTipoElemento() {
            return tipoElemento;
        }

        public int getDimensionesRestantes() {
            return dimensionesRestantes;
        }
    }

    // =========================================================
    // CREACION DE ARREGLO
    // =========================================================
    private ResultadoExpresion generarNuevoArreglo(
            NuevoArregloASTZ nuevoArreglo) {

        if (nuevoArreglo == null) {
            return new ResultadoExpresion("?");
        }

        List<ExpresionASTZ> dimensiones
                = nuevoArreglo.getDimensiones();

        if (dimensiones == null
                || dimensiones.isEmpty()) {

            return new ResultadoExpresion("?");
        }

        // =====================================================
        // 1. GENERAR TODAS LAS DIMENSIONES
        // =====================================================
        List<String> valoresDimensiones
                = new ArrayList<>();

        for (ExpresionASTZ dimension : dimensiones) {

            ResultadoExpresion resultadoDimension
                    = generarExpresion(dimension);

            valoresDimensiones.add(
                    resultadoDimension.getValor()
            );
        }

        // =====================================================
        // 2. GUARDAR PUNTERO INICIAL DEL ARREGLO
        // =====================================================
        String puntero
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "H",
                null,
                puntero
        );

        // =====================================================
        // 3. GUARDAR LAS DIMENSIONES EN EL HEAP
        // =====================================================
        // =====================================================
        // 3. GUARDAR RANGO EN base+0
        // =====================================================
        agregar(
                "HEAP_SET",
                String.valueOf(
                        valoresDimensiones.size()
                ),
                null,
                puntero
        );

        for (int i = 0;
                i < valoresDimensiones.size();
                i++) {

            String direccionDimension
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    puntero,
                    String.valueOf(i + 1),
                    direccionDimension
            );

            agregar(
                    "HEAP_SET",
                    valoresDimensiones.get(i),
                    null,
                    direccionDimension
            );
        }

        // =====================================================
        // 4. CALCULAR TOTAL DE ELEMENTOS
        // =====================================================
        String totalElementos
                = valoresDimensiones.get(0);

        for (int i = 1;
                i < valoresDimensiones.size();
                i++) {

            String temporalProducto
                    = temporales.nuevoTemporal();

            agregar(
                    "*",
                    totalElementos,
                    valoresDimensiones.get(i),
                    temporalProducto
            );

            totalElementos
                    = temporalProducto;
        }

        // =====================================================
        // 5. ESPACIO TOTAL
        // =====================================================
        String espacioTotal
                = temporales.nuevoTemporal();

        agregar(
                "+",
                totalElementos,
                String.valueOf(
                        valoresDimensiones.size() + 1
                ),
                espacioTotal
        );

        // =====================================================
        // 6. RESERVAR ESPACIO EN HEAP
        // =====================================================
        agregar(
                "+",
                "H",
                espacioTotal,
                "H"
        );

        // =====================================================
        // 7. RESULTADO = REFERENCIA AL ARREGLO
        // =====================================================
        return new ResultadoExpresion(
                puntero
        );
    }

    // =========================================================
    // RESOLVER DIRECCION DE INDICE DE ARREGLO
    // =========================================================
    private DireccionIndiceZ resolverDireccionIndice(
            AccesoASTZ acceso) {

        if (acceso == null
                || acceso.getPasos().isEmpty()) {

            return null;
        }

        String nombreBase
                = acceso.getBase();

        String puntero;
        String tipoElemento;
        int dimensionesTotales;

        // =====================================================
        // 1. BUSCAR COMO VARIABLE LOCAL / PARAMETRO
        // =====================================================
        VariableMemoriaZ variable
                = marcoActual != null
                        ? buscarVariableVisible(nombreBase)
                        : null;

        if (variable != null) {

            dimensionesTotales
                    = variable.getDimensiones();

            tipoElemento
                    = variable.getTipo();

            if (dimensionesTotales <= 0) {
                return null;
            }

            puntero
                    = leerVariableStack(
                            nombreBase
                    );

        } else {

            // =================================================
            // 2. BUSCAR COMO ATRIBUTO IMPLICITO DE THIS
            // =================================================
            if (claseActual == null) {
                return null;
            }

            AtributoMemoriaZ atributo
                    = claseActual.buscarAtributo(
                            nombreBase
                    );

            if (atributo == null) {
                return null;
            }

            dimensionesTotales
                    = atributo.getDimensiones();

            tipoElemento
                    = atributo.getTipo();

            if (dimensionesTotales <= 0) {
                return null;
            }

            String direccionAtributo
                    = generarDireccionAtributoThis(
                            nombreBase
                    );

            if (direccionAtributo == null) {
                return null;
            }

            puntero
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccionAtributo,
                    null,
                    puntero
            );
        }

        // =====================================================
        // 3. VERIFICAR PASOS
        // =====================================================
        List<PasoAccesoASTZ> pasos
                = acceso.getPasos();

        if (pasos.size() > dimensionesTotales) {
            return null;
        }

        for (PasoAccesoASTZ paso : pasos) {

            if (paso.getTipo()
                    != PasoAccesoASTZ.TipoPaso.INDICE) {

                return null;
            }
        }

        // =====================================================
        // 4. GENERAR INDICES
        // =====================================================
        List<String> indices
                = new ArrayList<>();

        for (PasoAccesoASTZ paso : pasos) {

            ResultadoExpresion indice
                    = generarExpresion(
                            paso.getIndice()
                    );

            indices.add(
                    indice.getValor()
            );
        }

        if (indices.isEmpty()) {
            return null;
        }

        // =====================================================
        // 5. CALCULAR INDICE LINEAL
        // =====================================================
        String indiceLineal
                = indices.get(0);

        for (int i = 1;
                i < indices.size();
                i++) {

            String direccionDimension
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    puntero,
                    String.valueOf(i + 1),
                    direccionDimension
            );

            String tamanoDimension
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccionDimension,
                    null,
                    tamanoDimension
            );

            // ---------------------------------------------
            // indiceLineal *= tamañoDimension
            // ---------------------------------------------
            String producto
                    = temporales.nuevoTemporal();

            agregar(
                    "*",
                    indiceLineal,
                    tamanoDimension,
                    producto
            );

            // ---------------------------------------------
            // indiceLineal += indiceActual
            // ---------------------------------------------
            String suma
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    producto,
                    indices.get(i),
                    suma
            );

            indiceLineal
                    = suma;
        }

        // =====================================================
        // 6. INICIO DE LOS DATOS
        // =====================================================
        String inicioDatos
                = temporales.nuevoTemporal();

        agregar(
                "+",
                puntero,
                String.valueOf(
                        dimensionesTotales + 1
                ),
                inicioDatos
        );

        // =====================================================
        // 7. DIRECCION FINAL
        // =====================================================
        String direccion
                = temporales.nuevoTemporal();

        agregar(
                "+",
                inicioDatos,
                indiceLineal,
                direccion
        );

        // =====================================================
        // 8. DIMENSIONES RESTANTES
        // =====================================================
        int dimensionesRestantes
                = dimensionesTotales
                - indices.size();

        return new DireccionIndiceZ(
                direccion,
                tipoElemento,
                dimensionesRestantes
        );
    }

    private String resolverPunteroObjetoDesdeArreglo(
            AccesoASTZ acceso,
            int cantidadIndices) {

        if (acceso == null
                || marcoActual == null
                || cantidadIndices <= 0) {

            return null;
        }

        VariableMemoriaZ variable
                = marcoActual.buscar(
                        acceso.getBase()
                );

        if (variable == null) {
            return null;
        }

        if (variable.getDimensiones() <= 0) {
            return null;
        }

        if (cantidadIndices
                != variable.getDimensiones()) {

            return null;
        }

        List<PasoAccesoASTZ> pasos
                = acceso.getPasos();

        if (cantidadIndices > pasos.size()) {
            return null;
        }

        for (int i = 0;
                i < cantidadIndices;
                i++) {

            if (pasos.get(i).getTipo()
                    != PasoAccesoASTZ.TipoPaso.INDICE) {

                return null;
            }
        }

        String punteroArreglo
                = leerVariableStack(
                        acceso.getBase()
                );

        List<String> indices
                = new ArrayList<>();

        for (int i = 0;
                i < cantidadIndices;
                i++) {

            ResultadoExpresion indice
                    = generarExpresion(
                            pasos.get(i).getIndice()
                    );

            indices.add(
                    indice.getValor()
            );
        }

        String indiceLineal
                = indices.get(0);

        for (int i = 1;
                i < indices.size();
                i++) {

            String direccionDimension
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    punteroArreglo,
                    String.valueOf(i + 1),
                    direccionDimension
            );

            String tamanoDimension
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccionDimension,
                    null,
                    tamanoDimension
            );

            String producto
                    = temporales.nuevoTemporal();

            agregar(
                    "*",
                    indiceLineal,
                    tamanoDimension,
                    producto
            );

            String suma
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    producto,
                    indices.get(i),
                    suma
            );

            indiceLineal
                    = suma;
        }

        // =====================================================
        // Saltar cabecera de dimensiones
        // =====================================================
        String inicioDatos
                = temporales.nuevoTemporal();

        agregar(
                "+",
                punteroArreglo,
                String.valueOf(
                        variable.getDimensiones() + 1
                ),
                inicioDatos
        );
        String direccionCelda
                = temporales.nuevoTemporal();

        agregar(
                "+",
                inicioDatos,
                indiceLineal,
                direccionCelda
        );

        String punteroObjeto
                = temporales.nuevoTemporal();

        agregar(
                "HEAP_GET",
                direccionCelda,
                null,
                punteroObjeto
        );

        return punteroObjeto;
    }

    private ResultadoExpresion generarInicializadorListaArreglo(
            InicializadorListaASTZ lista,
            int dimensionesEsperadas) {

        if (lista == null
                || dimensionesEsperadas <= 0) {

            agregar(
                    "ERROR_C3D",
                    "Inicializador de lista invalido",
                    null,
                    null
            );

            return new ResultadoExpresion("?");
        }

        // =====================================================
        // 1. OBTENER FORMA DEL ARREGLO
        // =====================================================
        List<Integer> forma
                = obtenerFormaInicializador(
                        lista,
                        dimensionesEsperadas
                );

        if (forma == null
                || forma.size() != dimensionesEsperadas) {

            agregar(
                    "ERROR_C3D",
                    "Forma de inicializador incompatible",
                    String.valueOf(
                            dimensionesEsperadas
                    ),
                    null
            );

            return new ResultadoExpresion("?");
        }

        // =====================================================
        // 2. APLANAR LOS ELEMENTOS
        // =====================================================
        List<ExpresionASTZ> elementos
                = new ArrayList<>();

        boolean estructuraValida
                = aplanarInicializador(
                        lista,
                        dimensionesEsperadas,
                        elementos
                );

        if (!estructuraValida) {

            agregar(
                    "ERROR_C3D",
                    "Estructura de inicializador invalida",
                    null,
                    null
            );

            return new ResultadoExpresion("?");
        }

        // =====================================================
        // 3. GUARDAR PUNTERO INICIAL
        // =====================================================
        String puntero
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "H",
                null,
                puntero
        );

        // =====================================================
        // GUARDAR RANGO EN base+0
        // =====================================================
        agregar(
                "HEAP_SET",
                String.valueOf(
                        dimensionesEsperadas
                ),
                null,
                puntero
        );

        // =====================================================
        // 4. GUARDAR DIMENSIONES EN CABECERA
        // =====================================================
        for (int i = 0;
                i < forma.size();
                i++) {

            String direccionDimension
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    puntero,
                    String.valueOf(i + 1),
                    direccionDimension
            );

            agregar(
                    "HEAP_SET",
                    String.valueOf(forma.get(i)),
                    null,
                    direccionDimension
            );
        }

        // =====================================================
        // 5. CALCULAR TOTAL DE ELEMENTOS
        // =====================================================
        int totalElementos = 1;

        for (Integer dimension : forma) {

            totalElementos
                    *= dimension;
        }

        // =====================================================
        // 6. RESERVAR TODO EL ARREGLO ANTES DE GENERAR
        // =====================================================
        int espacioTotal
                = 1
                + dimensionesEsperadas
                + totalElementos;

        agregar(
                "+",
                "H",
                String.valueOf(
                        espacioTotal
                ),
                "H"
        );

        // =====================================================
        // 7. DIRECCION DONDE COMIENZAN LOS DATOS
        // =====================================================
        String inicioDatos
                = temporales.nuevoTemporal();

        agregar(
                "+",
                puntero,
                String.valueOf(
                        dimensionesEsperadas + 1
                ),
                inicioDatos
        );

        // =====================================================
        // 8. GENERAR Y GUARDAR ELEMENTOS
        // =====================================================
        for (int i = 0;
                i < elementos.size();
                i++) {

            ResultadoExpresion valor
                    = generarExpresion(
                            elementos.get(i)
                    );

            String direccionElemento;

            if (i == 0) {

                direccionElemento
                        = inicioDatos;

            } else {

                direccionElemento
                        = temporales.nuevoTemporal();

                agregar(
                        "+",
                        inicioDatos,
                        String.valueOf(i),
                        direccionElemento
                );
            }

            agregar(
                    "HEAP_SET",
                    valor.getValor(),
                    null,
                    direccionElemento
            );
        }

        // =====================================================
        // 9. RESULTADO = PUNTERO AL ARREGLO
        // =====================================================
        return new ResultadoExpresion(
                puntero
        );
    }

    private List<Integer> obtenerFormaInicializador(
            InicializadorListaASTZ lista,
            int dimensionesEsperadas) {

        if (lista == null
                || dimensionesEsperadas <= 0) {

            return null;
        }

        List<Integer> forma
                = new ArrayList<>();

        List<ExpresionASTZ> elementos
                = lista.getElementos();

        // =====================================================
        // DIMENSION ACTUAL
        // =====================================================
        forma.add(
                elementos.size()
        );

        if (dimensionesEsperadas == 1) {

            for (ExpresionASTZ elemento
                    : elementos) {

                if (elemento instanceof InicializadorListaASTZ) {

                    return null;
                }
            }

            return forma;
        }

        if (elementos.isEmpty()) {

            for (int i = 1;
                    i < dimensionesEsperadas;
                    i++) {

                forma.add(0);
            }

            return forma;
        }

        List<Integer> formaInternaBase
                = null;

        for (ExpresionASTZ elemento
                : elementos) {

            if (!(elemento instanceof InicializadorListaASTZ subLista)) {

                return null;
            }

            List<Integer> formaInterna
                    = obtenerFormaInicializador(
                            subLista,
                            dimensionesEsperadas - 1
                    );

            if (formaInterna == null) {
                return null;
            }

            if (formaInternaBase == null) {

                formaInternaBase
                        = formaInterna;

            } else if (!formaInternaBase.equals(
                    formaInterna)) {

                return null;
            }
        }

        forma.addAll(
                formaInternaBase
        );

        return forma;
    }

    private boolean aplanarInicializador(
            InicializadorListaASTZ lista,
            int dimensionesEsperadas,
            List<ExpresionASTZ> salida) {

        if (lista == null
                || salida == null
                || dimensionesEsperadas <= 0) {

            return false;
        }

        // =====================================================
        // ULTIMA DIMENSION
        // =====================================================
        if (dimensionesEsperadas == 1) {

            for (ExpresionASTZ elemento
                    : lista.getElementos()) {

                if (elemento instanceof InicializadorListaASTZ) {

                    return false;
                }

                salida.add(
                        elemento
                );
            }

            return true;
        }

        // =====================================================
        // DIMENSION INTERMEDIA
        // =====================================================
        for (ExpresionASTZ elemento
                : lista.getElementos()) {

            if (!(elemento instanceof InicializadorListaASTZ subLista)) {

                return false;
            }

            if (!aplanarInicializador(
                    subLista,
                    dimensionesEsperadas - 1,
                    salida)) {

                return false;
            }
        }

        return true;
    }

    private void procesarIf(
            IfASTZ sentenciaIf) {

        if (sentenciaIf == null) {
            return;
        }

        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        List<IfASTZ.RamaIf> ramas
                = sentenciaIf.getRamas();

        // =====================================================
        // IF + ELSE IF
        // =====================================================
        if (ramas != null) {

            for (int i = 0;
                    i < ramas.size();
                    i++) {

                IfASTZ.RamaIf rama
                        = ramas.get(i);

                if (rama == null) {
                    continue;
                }

                String etiquetaSiguiente
                        = etiquetas.nuevaEtiqueta();

                // =============================================
                // GENERAR CONDICION
                // =============================================
                ResultadoExpresion condicion
                        = generarExpresion(
                                rama.getCondicion()
                        );

                // =============================================
                // SI ES FALSA -> SIGUIENTE RAMA
                // =============================================
                agregar(
                        "IF_FALSE",
                        condicion.getValor(),
                        null,
                        etiquetaSiguiente
                );

                // =============================================
                // CUERPO DE LA RAMA
                // =============================================
                procesarSentencia(
                        rama.getCuerpo()
                );

                // =============================================
                // SI LA RAMA SE EJECUTO, SALIR DEL IF COMPLETO
                // =============================================
                agregar(
                        "GOTO",
                        etiquetaFin,
                        null,
                        null
                );

                // =============================================
                // SIGUIENTE ELSE IF / ELSE
                // =============================================
                agregar(
                        "LABEL",
                        etiquetaSiguiente,
                        null,
                        null
                );
            }
        }

        // =====================================================
        // ELSE
        // =====================================================
        if (sentenciaIf.getCuerpoElse() != null) {

            procesarSentencia(
                    sentenciaIf.getCuerpoElse()
            );
        }

        // =====================================================
        // FIN DEL IF COMPLETO
        // =====================================================
        agregar(
                "LABEL",
                etiquetaFin,
                null,
                null
        );
    }

    private void procesarIncrementoDecremento(
            IncrementoDecrementoASTZ incremento) {

        if (incremento == null
                || incremento.getDestino() == null) {

            return;
        }

        ExpresionASTZ destino
                = incremento.getDestino();

        String operador
                = incremento.getOperador();

        // =====================================================
        // 1. VARIABLE SIMPLE / ATRIBUTO IMPLICITO
        // =====================================================
        if (destino instanceof AccesoASTZ acceso
                && acceso.getPasos().isEmpty()) {

            String nombre
                    = acceso.getBase();

            VariableMemoriaZ variable
                    = marcoActual != null
                            ? buscarVariableVisible(nombre)
                            : null;

            // =================================================
            // VARIABLE LOCAL / PARAMETRO
            // =================================================
            if (variable != null) {

                String actual
                        = leerVariableStack(nombre);

                String nuevo
                        = temporales.nuevoTemporal();

                agregar(
                        "++".equals(operador)
                        ? "+"
                        : "-",
                        actual,
                        "1",
                        nuevo
                );

                escribirVariableStack(
                        nombre,
                        nuevo
                );

                return;
            }

            // =================================================
            // ATRIBUTO IMPLICITO DE THIS
            // =================================================
            if (claseActual != null) {

                AtributoMemoriaZ atributo
                        = claseActual.buscarAtributo(nombre);

                if (atributo != null) {

                    String direccion
                            = generarDireccionAtributoThis(
                                    nombre
                            );

                    String actual
                            = temporales.nuevoTemporal();

                    agregar(
                            "HEAP_GET",
                            direccion,
                            null,
                            actual
                    );

                    String nuevo
                            = temporales.nuevoTemporal();

                    agregar(
                            "++".equals(operador)
                            ? "+"
                            : "-",
                            actual,
                            "1",
                            nuevo
                    );

                    agregar(
                            "HEAP_SET",
                            nuevo,
                            null,
                            direccion
                    );

                    return;
                }
            }
        }

        // =====================================================
        // 2. INDICE DE ARREGLO
        // =====================================================
        if (destino instanceof AccesoASTZ accesoIndice) {

            DireccionIndiceZ direccionIndice
                    = resolverDireccionIndice(
                            accesoIndice
                    );

            if (direccionIndice != null) {

                String actual
                        = temporales.nuevoTemporal();

                agregar(
                        "HEAP_GET",
                        direccionIndice.getDireccion(),
                        null,
                        actual
                );

                String nuevo
                        = temporales.nuevoTemporal();

                agregar(
                        "++".equals(operador)
                        ? "+"
                        : "-",
                        actual,
                        "1",
                        nuevo
                );

                agregar(
                        "HEAP_SET",
                        nuevo,
                        null,
                        direccionIndice.getDireccion()
                );

                return;
            }
        }

        // =====================================================
        // 3. ATRIBUTO COMPLEJO
        // =====================================================
        if (destino instanceof AccesoASTZ accesoComplejo) {

            DireccionAccesoZ direccionAcceso
                    = resolverDireccionAccesoObjeto(
                            accesoComplejo
                    );

            if (direccionAcceso != null) {

                String actual
                        = temporales.nuevoTemporal();

                agregar(
                        "HEAP_GET",
                        direccionAcceso.getDireccion(),
                        null,
                        actual
                );

                String nuevo
                        = temporales.nuevoTemporal();

                agregar(
                        "++".equals(operador)
                        ? "+"
                        : "-",
                        actual,
                        "1",
                        nuevo
                );

                agregar(
                        "HEAP_SET",
                        nuevo,
                        null,
                        direccionAcceso.getDireccion()
                );
            }
        }
    }

    private void procesarWhile(
            WhileASTZ sentenciaWhile) {

        if (sentenciaWhile == null) {
            return;
        }

        String etiquetaInicio
                = etiquetas.nuevaEtiqueta();

        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        // =====================================================
        // REGISTRAR CONTEXTO DEL CICLO
        // =====================================================
        pilaBreak.push(
                etiquetaFin
        );

        pilaContinue.push(
                etiquetaInicio
        );

        try {

            // =================================================
            // INICIO
            // =================================================
            agregar(
                    "LABEL",
                    etiquetaInicio,
                    null,
                    null
            );

            // =================================================
            // CONDICION
            // =================================================
            ResultadoExpresion condicion
                    = generarExpresion(
                            sentenciaWhile.getCondicion()
                    );

            agregar(
                    "IF_FALSE",
                    condicion.getValor(),
                    null,
                    etiquetaFin
            );

            // =================================================
            // CUERPO
            // =================================================
            procesarSentencia(
                    sentenciaWhile.getCuerpo()
            );

            // =================================================
            // REPETIR
            // =================================================
            agregar(
                    "GOTO",
                    etiquetaInicio,
                    null,
                    null
            );

            // =================================================
            // FIN
            // =================================================
            agregar(
                    "LABEL",
                    etiquetaFin,
                    null,
                    null
            );

        } finally {

            // =================================================
            // RESTAURAR CONTEXTO EXTERIOR
            // =================================================
            pilaContinue.pop();
            pilaBreak.pop();
        }
    }

    private void procesarBreak() {

        if (pilaBreak.isEmpty()) {

            agregar(
                    "ERROR_C3D",
                    "break fuera de ciclo/switch",
                    null,
                    null
            );

            return;
        }

        agregar(
                "GOTO",
                pilaBreak.peek(),
                null,
                null
        );
    }

    private void procesarContinue() {

        if (pilaContinue.isEmpty()) {

            agregar(
                    "ERROR_C3D",
                    "continue fuera de ciclo",
                    null,
                    null
            );

            return;
        }

        agregar(
                "GOTO",
                pilaContinue.peek(),
                null,
                null
        );
    }

    private void procesarDoWhile(
            DoWhileASTZ sentenciaDoWhile) {

        if (sentenciaDoWhile == null) {
            return;
        }

        // =====================================================
        // 1. CREAR ETIQUETAS
        // =====================================================
        String etiquetaInicio
                = etiquetas.nuevaEtiqueta();

        String etiquetaCondicion
                = etiquetas.nuevaEtiqueta();

        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        // =====================================================
        // 2. REGISTRAR CONTEXTO
        // =====================================================
        pilaBreak.push(
                etiquetaFin
        );

        pilaContinue.push(
                etiquetaCondicion
        );

        try {

            // =================================================
            // 3. INICIO DEL CUERPO
            // =================================================
            agregar(
                    "LABEL",
                    etiquetaInicio,
                    null,
                    null
            );

            // =================================================
            // 4. CUERPO
            // =================================================
            procesarSentencia(
                    sentenciaDoWhile.getCuerpo()
            );

            // =================================================
            // 5. ETIQUETA DE CONDICION
            // =================================================
            agregar(
                    "LABEL",
                    etiquetaCondicion,
                    null,
                    null
            );

            // =================================================
            // 6. GENERAR CONDICION
            // =================================================
            ResultadoExpresion condicion
                    = generarExpresion(
                            sentenciaDoWhile.getCondicion()
                    );

            // =================================================
            // 7. SI ES FALSA, TERMINAR
            // =================================================
            agregar(
                    "IF_FALSE",
                    condicion.getValor(),
                    null,
                    etiquetaFin
            );

            // =================================================
            // 8. SI ES VERDADERA, REPETIR
            // =================================================
            agregar(
                    "GOTO",
                    etiquetaInicio,
                    null,
                    null
            );

            // =================================================
            // 9. FIN
            // =================================================
            agregar(
                    "LABEL",
                    etiquetaFin,
                    null,
                    null
            );

        } finally {

            // =================================================
            // 10. RESTAURAR CICLO EXTERIOR
            // =================================================
            pilaContinue.pop();
            pilaBreak.pop();
        }
    }

    private void procesarFor(
            ForASTZ sentenciaFor) {

        if (sentenciaFor == null) {
            return;
        }

        entrarAmbitoVariables();

        try {

            // =====================================================
            // 1. PROCESAR INICIALIZACION
            // =====================================================
            procesarNodoFor(
                    sentenciaFor.getInicializacion()
            );

            // =====================================================
            // 2. CREAR ETIQUETAS
            // =====================================================
            String etiquetaCondicion
                    = etiquetas.nuevaEtiqueta();

            String etiquetaActualizacion
                    = etiquetas.nuevaEtiqueta();

            String etiquetaFin
                    = etiquetas.nuevaEtiqueta();

            // =====================================================
            // 3. REGISTRAR CONTEXTO DEL FOR
            // =====================================================
            pilaBreak.push(
                    etiquetaFin
            );

            pilaContinue.push(
                    etiquetaActualizacion
            );

            try {

                // =================================================
                // 4. CONDICION
                // =================================================
                agregar(
                        "LABEL",
                        etiquetaCondicion,
                        null,
                        null
                );

                if (sentenciaFor.getCondicion() != null) {

                    ResultadoExpresion condicion
                            = generarExpresion(
                                    sentenciaFor.getCondicion()
                            );

                    agregar(
                            "IF_FALSE",
                            condicion.getValor(),
                            null,
                            etiquetaFin
                    );
                }

                // =================================================
                // 5. CUERPO
                // =================================================
                procesarSentencia(
                        sentenciaFor.getCuerpo()
                );

                // =================================================
                // 6. ACTUALIZACION
                // =================================================
                agregar(
                        "LABEL",
                        etiquetaActualizacion,
                        null,
                        null
                );

                procesarNodoFor(
                        sentenciaFor.getActualizacion()
                );

                // =================================================
                // 7. REPETIR
                // =================================================
                agregar(
                        "GOTO",
                        etiquetaCondicion,
                        null,
                        null
                );

                // =================================================
                // 8. FIN
                // =================================================
                agregar(
                        "LABEL",
                        etiquetaFin,
                        null,
                        null
                );

            } finally {

                pilaContinue.pop();
                pilaBreak.pop();
            }

        } finally {

            salirAmbitoVariables();
        }
    }

    private void procesarNodoFor(
            NodoASTZ nodo) {

        if (nodo == null) {
            return;
        }

        // =====================================================
        // 1. DECLARACION
        // =====================================================
        if (nodo instanceof DeclaracionASTZ declaracion) {

            procesarDeclaracion(
                    declaracion
            );

            return;
        }

        // =====================================================
        // 2. ASIGNACION
        // =====================================================
        if (nodo instanceof AsignacionASTZ asignacion) {

            procesarAsignacion(
                    asignacion
            );

            return;
        }

        // =====================================================
        // 3. INCREMENTO / DECREMENTO
        // =====================================================
        if (nodo instanceof IncrementoDecrementoASTZ incremento) {

            procesarIncrementoDecremento(
                    incremento
            );

            return;
        }

        // =====================================================
        // 4. EXPRESION COMO SENTENCIA
        // =====================================================
        if (nodo instanceof ExpresionSentenciaASTZ expresionSentencia) {

            generarExpresion(
                    expresionSentencia.getExpresion()
            );

            return;
        }

        // =====================================================
        // 5. SI POR ALGUNA RAZON LLEGA UNA SENTENCIA NORMAL
        // =====================================================
        if (nodo instanceof SentenciaASTZ sentencia) {

            procesarSentencia(
                    sentencia
            );
        }
    }

    private void procesarSwitch(
            SwitchASTZ sentenciaSwitch) {

        if (sentenciaSwitch == null
                || sentenciaSwitch.getExpresion() == null) {

            return;
        }

        // =====================================================
        // 1. EVALUAR EXPRESION DEL SWITCH UNA SOLA VEZ
        // =====================================================
        ResultadoExpresion resultadoSwitch
                = generarExpresion(
                        sentenciaSwitch.getExpresion()
                );

        String valorSwitch
                = resultadoSwitch.getValor();

        // =====================================================
        // 2. OBTENER CASES
        // =====================================================
        List<CasoSwitchASTZ> casos
                = sentenciaSwitch.getCasos();

        int cantidadCasos
                = casos != null
                        ? casos.size()
                        : 0;

        // =====================================================
        // 3. CREAR ETIQUETAS DE LOS CASES
        // =====================================================
        List<String> etiquetasCasos
                = new ArrayList<>();

        for (int i = 0;
                i < cantidadCasos;
                i++) {

            etiquetasCasos.add(
                    etiquetas.nuevaEtiqueta()
            );
        }

        // =====================================================
        // 4. CREAR ETIQUETA DEFAULT SI EXISTE
        // =====================================================
        boolean tieneDefault
                = sentenciaSwitch.getDefecto() != null
                && !sentenciaSwitch.getDefecto().isEmpty();

        String etiquetaDefault
                = tieneDefault
                        ? etiquetas.nuevaEtiqueta()
                        : null;

        // =====================================================
        // 5. ETIQUETA FINAL
        // =====================================================
        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        // =====================================================
        // 6. COMPARACIONES
        // =====================================================
        for (int i = 0;
                i < cantidadCasos;
                i++) {

            CasoSwitchASTZ caso
                    = casos.get(i);

            if (caso == null
                    || caso.getValor() == null) {

                continue;
            }

            ResultadoExpresion valorCaso
                    = generarExpresion(
                            caso.getValor()
                    );

            String temporalComparacion
                    = temporales.nuevoTemporal();

            agregar(
                    "==",
                    valorSwitch,
                    valorCaso.getValor(),
                    temporalComparacion
            );

            String etiquetaSiguienteChequeo
                    = etiquetas.nuevaEtiqueta();

            agregar(
                    "IF_FALSE",
                    temporalComparacion,
                    null,
                    etiquetaSiguienteChequeo
            );

            agregar(
                    "GOTO",
                    etiquetasCasos.get(i),
                    null,
                    null
            );

            agregar(
                    "LABEL",
                    etiquetaSiguienteChequeo,
                    null,
                    null
            );
        }

        // =====================================================
        // 7. NINGUN CASE COINCIDIO
        // =====================================================
        if (tieneDefault) {

            agregar(
                    "GOTO",
                    etiquetaDefault,
                    null,
                    null
            );

        } else {

            agregar(
                    "GOTO",
                    etiquetaFin,
                    null,
                    null
            );
        }

        // =====================================================
        // 8. ACTIVAR BREAK PARA ESTE SWITCH
        // =====================================================
        pilaBreak.push(
                etiquetaFin
        );

        try {

            // =================================================
            // 9. GENERAR CUERPOS CASE EN ORDEN
            // =================================================
            for (int i = 0;
                    i < cantidadCasos;
                    i++) {

                CasoSwitchASTZ caso
                        = casos.get(i);

                if (caso == null) {
                    continue;
                }

                agregar(
                        "LABEL",
                        etiquetasCasos.get(i),
                        null,
                        null
                );

                if (caso.getSentencias() != null) {

                    for (SentenciaASTZ sentencia
                            : caso.getSentencias()) {

                        procesarSentencia(
                                sentencia
                        );
                    }
                }
            }

            // =================================================
            // 10. DEFAULT
            // =================================================
            if (tieneDefault) {

                agregar(
                        "LABEL",
                        etiquetaDefault,
                        null,
                        null
                );

                for (SentenciaASTZ sentencia
                        : sentenciaSwitch.getDefecto()) {

                    procesarSentencia(
                            sentencia
                    );
                }
            }

            // =================================================
            // 11. FIN SWITCH
            // =================================================
            agregar(
                    "LABEL",
                    etiquetaFin,
                    null,
                    null
            );

        } finally {

            // =================================================
            // 12. RESTAURAR BREAK EXTERIOR
            // =================================================
            pilaBreak.pop();
        }
    }

    private ResultadoExpresion generarTernaria(
            TernariaASTZ ternaria) {

        if (ternaria == null) {

            return new ResultadoExpresion(
                    "?"
            );
        }

        // =====================================================
        // 1. GENERAR CONDICION
        // =====================================================
        ResultadoExpresion condicion
                = generarExpresion(
                        ternaria.getCondicion()
                );

        // =====================================================
        // 2. TEMPORAL RESULTADO
        // =====================================================
        String temporalResultado
                = temporales.nuevoTemporal();

        // =====================================================
        // 3. ETIQUETAS
        // =====================================================
        String etiquetaFalso
                = etiquetas.nuevaEtiqueta();

        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        // =====================================================
        // 4. EVALUAR CONDICION
        // =====================================================
        agregar(
                "IF_FALSE",
                condicion.getValor(),
                null,
                etiquetaFalso
        );

        // =====================================================
        // 5. RAMA VERDADERA
        // =====================================================
        ResultadoExpresion verdadero
                = generarExpresion(
                        ternaria.getVerdadero()
                );

        agregar(
                "=",
                verdadero.getValor(),
                null,
                temporalResultado
        );

        agregar(
                "GOTO",
                etiquetaFin,
                null,
                null
        );

        // =====================================================
        // 6. RAMA FALSA
        // =====================================================
        agregar(
                "LABEL",
                etiquetaFalso,
                null,
                null
        );

        ResultadoExpresion falso
                = generarExpresion(
                        ternaria.getFalso()
                );

        agregar(
                "=",
                falso.getValor(),
                null,
                temporalResultado
        );

        // =====================================================
        // 7. FIN
        // =====================================================
        agregar(
                "LABEL",
                etiquetaFin,
                null,
                null
        );

        // =====================================================
        // 8. DEVOLVER RESULTADO
        // =====================================================
        return new ResultadoExpresion(
                temporalResultado
        );
    }

    private ResultadoExpresion generarAndCortocircuito(
            BinariaASTZ binaria) {

        // =====================================================
        // 1. EVALUAR SOLO IZQUIERDA
        // =====================================================
        ResultadoExpresion izquierda
                = generarExpresion(
                        binaria.getIzquierda()
                );

        // =====================================================
        // 2. TEMPORAL RESULTADO
        // =====================================================
        String temporalResultado
                = temporales.nuevoTemporal();

        // =====================================================
        // 3. ETIQUETAS
        // =====================================================
        String etiquetaFalso
                = etiquetas.nuevaEtiqueta();

        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        // =====================================================
        // 4. SI IZQUIERDA ES FALSA
        // =====================================================
        agregar(
                "IF_FALSE",
                izquierda.getValor(),
                null,
                etiquetaFalso
        );

        // =====================================================
        // 5. IZQUIERDA ERA TRUE
        // =====================================================
        ResultadoExpresion derecha
                = generarExpresion(
                        binaria.getDerecha()
                );

        agregar(
                "=",
                derecha.getValor(),
                null,
                temporalResultado
        );

        agregar(
                "GOTO",
                etiquetaFin,
                null,
                null
        );

        // =====================================================
        // 6. IZQUIERDA ERA FALSE
        // =====================================================
        agregar(
                "LABEL",
                etiquetaFalso,
                null,
                null
        );

        agregar(
                "=",
                "0",
                null,
                temporalResultado
        );

        // =====================================================
        // 7. FIN
        // =====================================================
        agregar(
                "LABEL",
                etiquetaFin,
                null,
                null
        );

        return new ResultadoExpresion(
                temporalResultado
        );
    }

    private ResultadoExpresion generarOrCortocircuito(
            BinariaASTZ binaria) {

        // =====================================================
        // 1. EVALUAR IZQUIERDA
        // =====================================================
        ResultadoExpresion izquierda
                = generarExpresion(
                        binaria.getIzquierda()
                );

        // =====================================================
        // 2. TEMPORAL RESULTADO
        // =====================================================
        String temporalResultado
                = temporales.nuevoTemporal();

        // =====================================================
        // 3. ETIQUETAS
        // =====================================================
        String etiquetaEvaluarDerecha
                = etiquetas.nuevaEtiqueta();

        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        // =====================================================
        // 4. SI IZQUIERDA ES FALSE
        // =====================================================
        agregar(
                "IF_FALSE",
                izquierda.getValor(),
                null,
                etiquetaEvaluarDerecha
        );

        // =====================================================
        // 5. IZQUIERDA ERA TRUE
        // =====================================================
        agregar(
                "=",
                "1",
                null,
                temporalResultado
        );

        agregar(
                "GOTO",
                etiquetaFin,
                null,
                null
        );

        // =====================================================
        // 6. IZQUIERDA ERA FALSE
        // =====================================================
        agregar(
                "LABEL",
                etiquetaEvaluarDerecha,
                null,
                null
        );

        ResultadoExpresion derecha
                = generarExpresion(
                        binaria.getDerecha()
                );

        agregar(
                "=",
                derecha.getValor(),
                null,
                temporalResultado
        );

        // =====================================================
        // 7. FIN
        // =====================================================
        agregar(
                "LABEL",
                etiquetaFin,
                null,
                null
        );

        return new ResultadoExpresion(
                temporalResultado
        );
    }

    private ResultadoExpresion generarCadenaHeap(
            String cadena) {

        if (cadena == null) {
            return new ResultadoExpresion("null");
        }

        // El resultado de una cadena es la dirección
        // donde comienza dentro del Heap.
        String inicio
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "H",
                null,
                inicio
        );

        // Guardar cada carácter como su código numérico.
        for (int i = 0; i < cadena.length(); i++) {

            int codigo
                    = cadena.charAt(i);

            agregar(
                    "HEAP_SET",
                    String.valueOf(codigo),
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

        // -1 indica el final de la cadena.
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
                inicio
        );
    }

    // =========================================================
// CONCATENACION STRING
// =========================================================
    private ResultadoExpresion generarConcatenacionString(
            BinariaASTZ binaria) {

        if (binaria == null) {
            return new ResultadoExpresion("?");
        }

        // =====================================================
        // 1. DETERMINAR TIPOS
        // =====================================================
        String tipoIzquierdo
                = inferirTipoBasicoAST(
                        binaria.getIzquierda()
                );

        String tipoDerecho
                = inferirTipoBasicoAST(
                        binaria.getDerecha()
                );

        // =====================================================
        // 2. EVALUAR OPERANDOS
        // =====================================================
        ResultadoExpresion izquierda
                = generarExpresion(
                        binaria.getIzquierda()
                );

        ResultadoExpresion derecha
                = generarExpresion(
                        binaria.getDerecha()
                );

        // =====================================================
        // 3. CONVERTIR A STRING CUANDO SEA NECESARIO
        // =====================================================
        String punteroIzquierdo
                = convertirAString(
                        izquierda.getValor(),
                        tipoIzquierdo
                );

        String punteroDerecho
                = convertirAString(
                        derecha.getValor(),
                        tipoDerecho
                );

        if (punteroIzquierdo == null
                || punteroDerecho == null) {

            agregar(
                    "ERROR_C3D",
                    "Concatenacion String incompatible",
                    null,
                    null
            );

            return new ResultadoExpresion("?");
        }

        // =====================================================
        // 4. INICIO DE NUEVA CADENA
        // =====================================================
        String inicioResultado
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "H",
                null,
                inicioResultado
        );

        // =====================================================
        // 5. COPIAR IZQUIERDA
        // =====================================================
        generarCopiaCadenaHeap(
                punteroIzquierdo
        );

        // =====================================================
        // 6. COPIAR DERECHA
        // =====================================================
        generarCopiaCadenaHeap(
                punteroDerecho
        );

        // =====================================================
        // 7. TERMINADOR
        // =====================================================
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
                inicioResultado
        );
    }

    // =========================================================
// CONVERTIR VALOR PRIMITIVO A STRING
// =========================================================
    private String convertirAString(
            String valor,
            String tipo) {

        if (valor == null
                || tipo == null) {

            return null;
        }

        // =====================================================
        // STRING
        // Ya es un puntero al Heap.
        // =====================================================
        if ("String".equals(tipo)) {
            return valor;
        }

        String temporal
                = temporales.nuevoTemporal();

        // =====================================================
        // INT
        // =====================================================
        if ("int".equals(tipo)) {

            agregar(
                    "INT_TO_STRING",
                    valor,
                    null,
                    temporal
            );

            return temporal;
        }

        // =====================================================
        // DOUBLE
        // =====================================================
        if ("double".equals(tipo)) {

            agregar(
                    "DOUBLE_TO_STRING",
                    valor,
                    null,
                    temporal
            );

            return temporal;
        }

        // =====================================================
        // BOOLEAN
        // =====================================================
        if ("boolean".equals(tipo)) {

            agregar(
                    "BOOL_TO_STRING",
                    valor,
                    null,
                    temporal
            );

            return temporal;
        }

        // =====================================================
        // CHAR
        // =====================================================
        if ("char".equals(tipo)) {

            agregar(
                    "CHAR_TO_STRING",
                    valor,
                    null,
                    temporal
            );

            return temporal;
        }

        return null;
    }

    private void generarCopiaCadenaHeap(
            String punteroOrigen) {

        if (punteroOrigen == null
                || "?".equals(punteroOrigen)) {

            return;
        }

        // Copia del puntero para NO destruir el original.
        String puntero
                = temporales.nuevoTemporal();

        agregar(
                "=",
                punteroOrigen,
                null,
                puntero
        );

        String etiquetaInicio
                = etiquetas.nuevaEtiqueta();

        String etiquetaFin
                = etiquetas.nuevaEtiqueta();

        agregar(
                "LABEL",
                etiquetaInicio,
                null,
                null
        );

        // Leer Heap[p]
        String caracter
                = temporales.nuevoTemporal();

        agregar(
                "HEAP_GET",
                puntero,
                null,
                caracter
        );

        // Si encontramos -1 terminamos esta copia.
        String esFin
                = temporales.nuevoTemporal();

        agregar(
                "!=",
                caracter,
                "-1",
                esFin
        );

        agregar(
                "IF_FALSE",
                esFin,
                null,
                etiquetaFin
        );
        // Heap[H] = caracter
        agregar(
                "HEAP_SET",
                caracter,
                null,
                "H"
        );

        // H++
        agregar(
                "+",
                "H",
                "1",
                "H"
        );

        // puntero++
        agregar(
                "+",
                puntero,
                "1",
                puntero
        );

        agregar(
                "GOTO",
                etiquetaInicio,
                null,
                null
        );

        agregar(
                "LABEL",
                etiquetaFin,
                null,
                null
        );
    }

    private String inferirTipoRetornoLlamada(
            LlamadaASTZ llamada) {

        if (llamada == null
                || claseASTActual == null) {

            return null;
        }

        String nombre
                = llamada.getNombre();

        if (nombre == null) {
            return null;
        }

        // =====================================================
        // BUILTIN readln()
        // =====================================================
        if ("readln".equals(nombre)) {
            return "String";
        }

        // =====================================================
        // BUSCAR METODOS DE LA CLASE ACTUAL
        // =====================================================
        for (MiembroASTZ miembro
                : claseASTActual.getMiembros()) {

            if (!(miembro instanceof MetodoASTZ metodo)) {
                continue;
            }

            if (!nombre.equals(
                    metodo.getNombre())) {
                continue;
            }

            // Debe coincidir al menos la cantidad de parametros.
            if (metodo.getParametros().size()
                    != llamada.getArgumentos().size()) {
                continue;
            }

            boolean compatible = true;

            // =================================================
            // COMPROBAR TIPOS DE LOS ARGUMENTOS
            // =================================================
            for (int i = 0;
                    i < llamada.getArgumentos().size();
                    i++) {

                ExpresionASTZ argumento
                        = llamada.getArgumentos().get(i);

                ParametroASTZ parametro
                        = metodo.getParametros().get(i);

                String tipoArgumento
                        = inferirTipoBasicoAST(
                                argumento
                        );

                String tipoParametro
                        = parametro.getTipo();

                if (!tiposCompatiblesLlamadaC3D(
                        tipoParametro,
                        tipoArgumento)) {

                    compatible = false;
                    break;
                }
            }

            if (compatible) {
                return metodo.getTipoRetorno();
            }
        }

        return null;
    }

    private boolean tiposCompatiblesLlamadaC3D(
            String esperado,
            String recibido) {

        if (esperado == null
                || recibido == null
                || "?".equals(recibido)) {

            return false;
        }

        // Coincidencia exacta.
        if (esperado.equals(recibido)) {
            return true;
        }

        // Widening permitido: int -> double.
        if ("double".equals(esperado)
                && "int".equals(recibido)) {

            return true;
        }

        return false;
    }

    private String inferirTipoRetornoMetodoObjeto(
            String tipoObjeto,
            String nombreMetodo,
            List<ExpresionASTZ> argumentos) {

        if (tipoObjeto == null
                || nombreMetodo == null) {

            return null;
        }

        ClaseASTZ claseObjeto
                = clasesAST.get(tipoObjeto);

        if (claseObjeto == null) {

            return null;
        }

        int cantidadArgumentos
                = argumentos != null
                        ? argumentos.size()
                        : 0;

        // =====================================================
        // BUSCAR METODO COMPATIBLE
        // =====================================================
        for (MiembroASTZ miembro
                : claseObjeto.getMiembros()) {

            if (!(miembro instanceof MetodoASTZ metodo)) {
                continue;
            }

            if (!nombreMetodo.equals(
                    metodo.getNombre())) {

                continue;
            }

            if (metodo.getParametros().size()
                    != cantidadArgumentos) {

                continue;
            }

            boolean compatible = true;

            // =================================================
            // COMPARAR PARAMETROS
            // =================================================
            for (int i = 0;
                    i < cantidadArgumentos;
                    i++) {

                ExpresionASTZ argumento
                        = argumentos.get(i);

                ParametroASTZ parametro
                        = metodo.getParametros().get(i);

                String tipoArgumento
                        = inferirTipoBasicoAST(
                                argumento
                        );

                String tipoParametro
                        = describirTipo(
                                parametro.getTipo(),
                                parametro.getDimensiones()
                        );

                if (!tiposCompatiblesLlamadaC3D(
                        tipoParametro,
                        tipoArgumento)) {

                    compatible = false;
                    break;
                }
            }

            if (compatible) {

                return metodo.getTipoRetorno();
            }
        }

        return null;
    }
}
