/*
 */
package elmer.compi2.zetariano.codegen;

import elmer.compi2.zetariano.runtime.piglatin.VariableMemoriaPig;
import elmer.compi2.zetariano.runtime.piglatin.MarcoPrincipalPig;
import elmer.compi2.zetariano.core.node.piglatin.*;
import elmer.compi2.zetariano.codegen.Cuadruplo;
import elmer.compi2.zetariano.codegen.GeneradorEtiquetas;
import elmer.compi2.zetariano.codegen.GeneradorTemporales;
import elmer.compi2.zetariano.imports.AtributoImportadoPig;
import elmer.compi2.zetariano.imports.ClaseImportadaPig;
import elmer.compi2.zetariano.imports.RegistroImportsPig;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.List;
import elmer.compi2.zetariano.imports.MetodoImportadoPig;
import elmer.compi2.zetariano.imports.TipoImportPig;

/**
 *
 */
public class GeneradorC3DPig {

    private final ProgramaASTPig programa;

    private final MarcoPrincipalPig marco;
    private final RegistroImportsPig registroImports;

    private final List<Cuadruplo> cuadruplos;

    private final GeneradorTemporales temporales;

    private final GeneradorEtiquetas etiquetas;

    private final Deque<String> pilaBreak;

    private final Deque<String> pilaContinue;

    // =========================================================
    // CONSTRUCTOR SIN IMPORTS
    // =========================================================
    public GeneradorC3DPig(
            ProgramaASTPig programa,
            MarcoPrincipalPig marco) {

        this(
                programa,
                marco,
                new RegistroImportsPig()
        );
    }

    // =========================================================
    // CONSTRUCTOR CON IMPORTS
    // =========================================================
    public GeneradorC3DPig(
            ProgramaASTPig programa,
            MarcoPrincipalPig marco,
            RegistroImportsPig registroImports) {

        this.programa = programa;

        this.marco = marco;

        this.registroImports
                = registroImports == null
                        ? new RegistroImportsPig()
                        : registroImports;

        this.cuadruplos
                = new ArrayList<>();

        this.temporales
                = new GeneradorTemporales();

        this.etiquetas
                = new GeneradorEtiquetas();

        this.pilaBreak
                = new ArrayDeque<>();

        this.pilaContinue
                = new ArrayDeque<>();
    }

    // =========================================================
    // GENERAR
    // =========================================================
    public List<Cuadruplo> generar() {

        cuadruplos.clear();

        agregar(
                "FUNC_BEGIN",
                "main_pig",
                null,
                null
        );

        // =====================================================
        // VARIABLES GLOBALES
        // =====================================================
        for (SentenciaASTPig sentencia
                : programa.getVariablesGlobales()) {

            generarSentencia(
                    sentencia
            );
        }

        // =====================================================
        // MAIOR
        // =====================================================
        for (SentenciaASTPig sentencia
                : programa.getPrincipal()) {

            generarSentencia(
                    sentencia
            );
        }

        agregar(
                "FUNC_END",
                "main_pig",
                null,
                null
        );

        return cuadruplos;
    }

    // =========================================================
    // SENTENCIAS
    // =========================================================
    private void generarSentencia(
            SentenciaASTPig sentencia) {

        if (sentencia == null) {
            return;
        }

        // -----------------------------------------------------
        // DECLARACION
        // -----------------------------------------------------
        if (sentencia instanceof DeclaracionASTPig declaracion) {

            generarDeclaracion(
                    declaracion
            );

            return;
        }

        // -----------------------------------------------------
        // ASIGNACION
        // -----------------------------------------------------
        if (sentencia instanceof AsignacionASTPig asignacion) {

            generarAsignacion(
                    asignacion
            );

            return;
        }

        // -----------------------------------------------------
        // ++ / --
        // -----------------------------------------------------
        if (sentencia instanceof IncrementoDecrementoASTPig incDec) {

            generarIncrementoDecremento(
                    incDec
            );

            return;
        }

        // -----------------------------------------------------
        // LECTURA
        // -----------------------------------------------------
        if (sentencia instanceof LecturaASTPig lectura) {

            generarLectura(
                    lectura
            );

            return;
        }

        // -----------------------------------------------------
        // ESCRITURA
        // -----------------------------------------------------
        if (sentencia instanceof EscrituraASTPig escritura) {

            ResultadoPig valor
                    = generarExpresion(
                            escritura.getExpresion()
                    );

            if ("textum".equals(valor.tipo)) {

                agregar(
                        "PRINTLN_STRING",
                        valor.valor,
                        null,
                        null
                );

            } else if ("littera".equals(valor.tipo)) {

                agregar(
                        "PRINTLN_CHAR",
                        valor.valor,
                        null,
                        null
                );

            } else if ("decimalis".equals(valor.tipo)) {

                agregar(
                        "PRINTLN_DOUBLE",
                        valor.valor,
                        null,
                        null
                );

            } else {

                agregar(
                        "PRINTLN",
                        valor.valor,
                        null,
                        null
                );
            }

            return;
        }

        // -----------------------------------------------------
        // EXPRESION COMO SENTENCIA
        // -----------------------------------------------------
        if (sentencia instanceof ExpresionSentenciaASTPig expresionSentencia) {

            generarExpresion(
                    expresionSentencia.getExpresion()
            );

            return;
        }

        // -----------------------------------------------------
        // BLOQUE
        // -----------------------------------------------------
        if (sentencia instanceof BloqueASTPig bloque) {

            generarBloque(
                    bloque
            );

            return;
        }

        // -----------------------------------------------------
        // IF
        // -----------------------------------------------------
        if (sentencia instanceof IfASTPig sentenciaIf) {

            generarIf(
                    sentenciaIf
            );

            return;
        }

        // -----------------------------------------------------
        // WHILE
        // -----------------------------------------------------
        if (sentencia instanceof WhileASTPig whileAST) {

            generarWhile(
                    whileAST
            );

            return;
        }

        // -----------------------------------------------------
        // DO WHILE
        // -----------------------------------------------------
        if (sentencia instanceof DoWhileASTPig doWhile) {

            generarDoWhile(
                    doWhile
            );

            return;
        }

        // -----------------------------------------------------
        // FOR
        // -----------------------------------------------------
        if (sentencia instanceof ForASTPig forAST) {

            generarFor(
                    forAST
            );

            return;
        }

        // -----------------------------------------------------
        // BREAK
        // -----------------------------------------------------
        if (sentencia instanceof BreakASTPig) {

            if (!pilaBreak.isEmpty()) {

                agregar(
                        "GOTO",
                        null,
                        null,
                        pilaBreak.peek()
                );
            }

            return;
        }

        // -----------------------------------------------------
        // CONTINUE
        // -----------------------------------------------------
        if (sentencia instanceof ContinueASTPig) {

            if (!pilaContinue.isEmpty()) {

                agregar(
                        "GOTO",
                        null,
                        null,
                        pilaContinue.peek()
                );
            }
        }
    }

    // =========================================================
    // LECTURA DESDE CONSOLA
    // =========================================================
    private void generarLectura(
            LecturaASTPig lectura) {

        if (lectura == null) {
            return;
        }

        if (lectura.getDestino() == null) {
            String valorDescartado = temporales.nuevoTemporal();
            agregar("READLN", null, null, valorDescartado);
            return;
        }

        if (!(lectura.getDestino() instanceof AccesoASTPig acceso)) {

            return;
        }

        // =====================================================
        // VARIABLE SIMPLE
        // =====================================================
        if (acceso.esSimple()) {

            VariableMemoriaPig variable
                    = marco.buscar(
                            acceso.getIdentificador()
                    );

            if (variable == null) {
                return;
            }

            String valorLeido = generarLecturaTipada(variable.getTipo());

            String direccionStack
                    = nuevaDireccionStack(
                            variable
                    );

            agregar(
                    "STACK_SET",
                    valorLeido,
                    null,
                    direccionStack
            );

            return;
        }

        // =====================================================
        // ELEMENTO DE ARREGLO
        // =====================================================
        DireccionIndicePig direccionIndice
                = resolverDireccionIndice(
                        acceso
                );

        if (direccionIndice != null) {

            String valorLeido
                    = generarLecturaTipada(direccionIndice.tipo);

            agregar(
                    "HEAP_SET",
                    valorLeido,
                    null,
                    direccionIndice.direccion
            );

            return;
        }

        // =====================================================
        // ATRIBUTO O ACCESO ANIDADO
        // =====================================================
        DireccionAtributoPig direccionAtributo
                = resolverDireccionAtributo(
                        acceso
                );

        if (direccionAtributo != null) {

            String valorLeido
                    = generarLecturaTipada(direccionAtributo.tipo);

            agregar(
                    "HEAP_SET",
                    valorLeido,
                    null,
                    direccionAtributo.direccion
            );
        }
    }

    private String generarLecturaTipada(String tipo) {

        String temporal = temporales.nuevoTemporal();
        String normalizado = normalizarTipoFirma(tipo);

        String operador = switch (normalizado) {
            case "int" -> "READ_INT";
            case "double" -> "READ_DOUBLE";
            case "char" -> "READ_CHAR";
            case "bool" -> "READ_BOOL";
            default -> "READLN";
        };

        agregar(operador, null, null, temporal);
        return temporal;
    }

    // =========================================================
    // DECLARACION
    // =========================================================
    private void generarDeclaracion(
            DeclaracionASTPig declaracion) {

        VariableMemoriaPig variable
                = marco.buscar(
                        declaracion
                );

        if (variable == null) {
            return;
        }

        // -----------------------------------------------------
        // ARREGLO
        // -----------------------------------------------------
        if (variable.esArreglo()) {

            generarDeclaracionArreglo(
                    declaracion,
                    variable
            );

            return;
        }

        // -----------------------------------------------------
        // OBJETO
        // -----------------------------------------------------
        if (variable.esObjeto()) {

            generarDeclaracionObjeto(
                    declaracion,
                    variable
            );

            return;
        }

        String direccion
                = nuevaDireccionStack(
                        variable
                );

        if (declaracion.getInicializador()
                != null) {

            ResultadoPig resultado
                    = generarExpresion(
                            declaracion
                                    .getInicializador()
                    );

            agregar(
                    "STACK_SET",
                    resultado.valor,
                    null,
                    direccion
            );

        } else {

            agregar(
                    "STACK_SET",
                    "0",
                    null,
                    direccion
            );
        }
    }

    // =========================================================
    // DECLARACION DE ARREGLO
    // =========================================================
    private void generarDeclaracionArreglo(
            DeclaracionASTPig declaracion,
            VariableMemoriaPig variable) {

        List<Integer> dimensiones
                = variable.getDimensiones();

        if (dimensiones == null
                || dimensiones.isEmpty()) {

            return;
        }

        // =====================================================
        // 1. GUARDAR PUNTERO BASE DEL ARREGLO
        // =====================================================
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

        // =====================================================
        // 3. TOTAL DE ELEMENTOS
        // =====================================================
        int total
                = calcularTotalElementos(
                        dimensiones
                );

        // =====================================================
        // 4. APLANAR INICIALIZADOR
        // =====================================================
        List<ExpresionASTPig> valores
                = new ArrayList<>();

        if (declaracion.getInicializador() instanceof InicializadorListaASTPig lista) {

            aplanarInicializador(
                    lista,
                    valores
            );
        }

        // =====================================================
        // 5. RESERVAR PRIMERO TODAS LAS CELDAS DE DATOS
        // =====================================================
        String inicioDatos
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "H",
                null,
                inicioDatos
        );

        for (int i = 0;
                i < total;
                i++) {

            agregar(
                    "HEAP_SET",
                    "0",
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

        // =====================================================
        // 6. GENERAR Y ESCRIBIR LOS VALORES
        // =====================================================
        for (int i = 0;
                i < total;
                i++) {

            String valor = "0";

            if (i < valores.size()) {

                ResultadoPig resultado
                        = generarExpresion(
                                valores.get(i)
                        );

                valor = resultado.valor;
            }

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
                    valor,
                    null,
                    direccionElemento
            );
        }

        // =====================================================
        // 7. STACK[offset] = base
        // =====================================================
        String direccionStack
                = nuevaDireccionStack(
                        variable
                );

        agregar(
                "STACK_SET",
                base,
                null,
                direccionStack
        );
    }

    // =========================================================
    // ASIGNACION
    // =========================================================
    private void generarAsignacion(
            AsignacionASTPig asignacion) {

        if (!(asignacion.getDestino() instanceof AccesoASTPig acceso)) {

            return;
        }

        // =====================================================
        // 1. GENERAR VALOR
        // =====================================================
        ResultadoPig valor
                = generarExpresion(
                        asignacion.getValor()
                );

        // =====================================================
        // 2. VARIABLE SIMPLE
        // =====================================================
        if (acceso.esSimple()) {

            VariableMemoriaPig variable
                    = marco.buscar(
                            acceso.getIdentificador()
                    );

            if (variable == null) {
                return;
            }

            String direccion
                    = nuevaDireccionStack(
                            variable
                    );

            agregar(
                    "STACK_SET",
                    valor.valor,
                    null,
                    direccion
            );

            return;
        }

        DireccionIndicePig direccionIndice
                = resolverDireccionIndice(
                        acceso
                );

        if (direccionIndice != null) {

            agregar(
                    "HEAP_SET",
                    valor.valor,
                    null,
                    direccionIndice.direccion
            );

            return;
        }

        // =====================================================
        // ATRIBUTO DE OBJETO
        // =====================================================
        DireccionAtributoPig direccionAtributo
                = resolverDireccionAtributo(
                        acceso
                );

        if (direccionAtributo != null) {

            agregar(
                    "HEAP_SET",
                    valor.valor,
                    null,
                    direccionAtributo.direccion
            );

            return;
        }

    }

    // =========================================================
    // ++ / --
    // =========================================================
    private void generarIncrementoDecremento(
            IncrementoDecrementoASTPig sentencia) {

        AccesoASTPig acceso
                = sentencia.getAcceso();

        if (acceso == null
                || !acceso.esSimple()) {

            return;
        }

        VariableMemoriaPig variable
                = marco.buscar(
                        acceso.getIdentificador()
                );

        if (variable == null) {
            return;
        }

        String direccion
                = nuevaDireccionStack(
                        variable
                );

        String actual
                = temporales.nuevoTemporal();

        agregar(
                "STACK_GET",
                direccion,
                null,
                actual
        );

        String nuevo
                = temporales.nuevoTemporal();

        String operador
                = "++".equals(
                        sentencia.getOperador()
                )
                ? "+"
                : "-";

        agregar(
                operador,
                actual,
                "1",
                nuevo
        );

        agregar(
                "STACK_SET",
                nuevo,
                null,
                direccion
        );
    }

    // =========================================================
    // EXPRESIONES
    // =========================================================
    private ResultadoPig generarExpresion(
            ExpresionASTPig expresion) {

        if (expresion == null) {

            return new ResultadoPig(
                    "0",
                    "desconocido"
            );
        }

        // -----------------------------------------------------
        // LITERAL
        // -----------------------------------------------------
        if (expresion instanceof LiteralASTPig literal) {

            Object valor
                    = literal.getValor();

            String tipo
                    = literal.getTipo();

            // =================================================
            // BOOLEANO
            // =================================================
            if (valor instanceof Boolean booleano) {

                return new ResultadoPig(
                        booleano
                                ? "1"
                                : "0",
                        tipo
                );
            }

            // =================================================
            // TEXTUM
            // =================================================
            if ("textum".equals(tipo)) {

                return generarCadenaHeap(
                        valor == null
                                ? ""
                                : String.valueOf(valor)
                );
            }

            if ("littera".equals(tipo)) {

                String texto
                        = valor == null
                                ? ""
                                : String.valueOf(valor);

                int codigo
                        = texto.isEmpty()
                        ? 0
                        : texto.charAt(0);

                return new ResultadoPig(
                        String.valueOf(codigo),
                        "littera"
                );
            }

            // =================================================
            // NUMERUS / DECIMALIS
            // =================================================
            return new ResultadoPig(
                    String.valueOf(valor),
                    tipo
            );
        }

        // -----------------------------------------------------
        // LLAMADA GLOBAL
        // -----------------------------------------------------
        if (expresion instanceof LlamadaASTPig llamada) {

            ResultadoPig resultado
                    = generarLlamadaFuncionY(
                            llamada
                    );

            if (resultado != null) {
                return resultado;
            }

            return new ResultadoPig(
                    "?",
                    "desconocido"
            );
        }

        // -----------------------------------------------------
        // ACCESO SIMPLE
        // -----------------------------------------------------
        if (expresion instanceof AccesoASTPig acceso) {

            // =================================================
            // VARIABLE SIMPLE
            // =================================================
            if (acceso.esSimple()) {

                VariableMemoriaPig variable
                        = marco.buscar(
                                acceso.getIdentificador()
                        );

                if (variable == null) {

                    return new ResultadoPig(
                            "?",
                            "desconocido"
                    );
                }

                String direccion
                        = nuevaDireccionStack(
                                variable
                        );

                String temporal
                        = temporales.nuevoTemporal();

                agregar(
                        "STACK_GET",
                        direccion,
                        null,
                        temporal
                );

                return new ResultadoPig(
                        temporal,
                        variable.getTipo()
                );
            }

            // =================================================
            // ELEMENTO DE ARREGLO
            // =================================================
            DireccionIndicePig direccionIndice
                    = resolverDireccionIndice(
                            acceso
                    );

            if (direccionIndice != null) {

                String valor
                        = temporales.nuevoTemporal();

                agregar(
                        "HEAP_GET",
                        direccionIndice.direccion,
                        null,
                        valor
                );

                return new ResultadoPig(
                        valor,
                        direccionIndice.tipo
                );
            }

            // =================================================
            // ATRIBUTO DE OBJETO
            // =================================================
            DireccionAtributoPig direccionAtributo
                    = resolverDireccionAtributo(
                            acceso
                    );

            if (direccionAtributo != null) {

                String valor
                        = temporales.nuevoTemporal();

                agregar(
                        "HEAP_GET",
                        direccionAtributo.direccion,
                        null,
                        valor
                );

                return new ResultadoPig(
                        valor,
                        direccionAtributo.tipo
                );
            }

            // =================================================
            // METODO DE OBJETO
            // =================================================
            ResultadoPig llamadaMetodo
                    = generarLlamadaMetodoObjeto(
                            acceso
                    );

            if (llamadaMetodo != null) {

                return llamadaMetodo;
            }

            return new ResultadoPig(
                    "?",
                    "desconocido"
            );
        }

        // -----------------------------------------------------
        // BINARIA
        // -----------------------------------------------------
        if (expresion instanceof BinariaASTPig binaria) {

            ResultadoPig izquierda
                    = generarExpresion(
                            binaria.getIzquierda()
                    );

            ResultadoPig derecha
                    = generarExpresion(
                            binaria.getDerecha()
                    );

            String temporal
                    = temporales.nuevoTemporal();

            agregar(
                    binaria.getOperador(),
                    izquierda.valor,
                    derecha.valor,
                    temporal
            );

            return new ResultadoPig(
                    temporal,
                    inferirTipoBinario(
                            binaria.getOperador(),
                            izquierda.tipo,
                            derecha.tipo
                    )
            );
        }

        // -----------------------------------------------------
        // UNARIA
        // -----------------------------------------------------
        if (expresion instanceof UnariaASTPig unaria) {

            ResultadoPig valor
                    = generarExpresion(
                            unaria.getExpresion()
                    );

            String temporal
                    = temporales.nuevoTemporal();

            agregar(
                    unaria.getOperador(),
                    valor.valor,
                    null,
                    temporal
            );

            return new ResultadoPig(
                    temporal,
                    valor.tipo
            );
        }

        return new ResultadoPig(
                "?",
                "desconocido"
        );
    }

    // =========================================================
    // DIRECCION DE INDICE DE ARREGLO
    // =========================================================
    private DireccionIndicePig resolverDireccionIndice(
            AccesoASTPig acceso) {

        if (acceso == null
                || acceso.esSimple()) {

            return null;
        }

        VariableMemoriaPig variable
                = marco.buscar(
                        acceso.getIdentificador()
                );

        if (variable == null
                || !variable.esArreglo()) {

            return null;
        }

        List<PasoAccesoASTPig> pasos
                = acceso.getPasos();

        List<ExpresionASTPig> indices
                = new ArrayList<>();

        for (PasoAccesoASTPig paso
                : pasos) {

            if (paso.getTipo()
                    != PasoAccesoASTPig.TipoPaso.INDICE) {

                return null;
            }

            indices.add(
                    paso.getIndice()
            );
        }

        if (indices.size()
                != variable.getDimensiones().size()) {

            return null;
        }

        // =====================================================
        // LEER BASE DESDE STACK
        // =====================================================
        String direccionStack
                = nuevaDireccionStack(
                        variable
                );

        String base
                = temporales.nuevoTemporal();

        agregar(
                "STACK_GET",
                direccionStack,
                null,
                base
        );

        ResultadoPig primerIndice
                = generarExpresion(
                        indices.get(0)
                );

        String lineal
                = primerIndice.valor;

        for (int i = 1;
                i < indices.size();
                i++) {

            String multiplicacion
                    = temporales.nuevoTemporal();

            agregar(
                    "*",
                    lineal,
                    String.valueOf(
                            variable.getDimensiones()
                                    .get(i)
                    ),
                    multiplicacion
            );

            ResultadoPig indiceActual
                    = generarExpresion(
                            indices.get(i)
                    );

            String suma
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    multiplicacion,
                    indiceActual.valor,
                    suma
            );

            lineal = suma;
        }

        String inicioDatos
                = temporales.nuevoTemporal();

        agregar(
                "+",
                base,
                String.valueOf(
                        variable.getDimensiones().size() + 1
                ),
                inicioDatos
        );

        String direccionFinal
                = temporales.nuevoTemporal();

        agregar(
                "+",
                inicioDatos,
                lineal,
                direccionFinal
        );

        return new DireccionIndicePig(
                direccionFinal,
                variable.getTipo()
        );
    }

    // =========================================================
    // STACK
    // =========================================================
    private String nuevaDireccionStack(
            VariableMemoriaPig variable) {

        String temporal
                = temporales.nuevoTemporal();

        agregar(
                "+",
                "P",
                String.valueOf(
                        variable.getOffset()
                ),
                temporal
        );

        return temporal;
    }

    // =========================================================
    // TIPO BINARIO
    // =========================================================
    private String inferirTipoBinario(
            String operador,
            String izquierda,
            String derecha) {

        if ("==".equals(operador)
                || "!=".equals(operador)
                || "<".equals(operador)
                || ">".equals(operador)
                || "<=".equals(operador)
                || ">=".equals(operador)
                || "&&".equals(operador)
                || "||".equals(operador)) {

            return "verum";
        }

        if ("decimalis".equals(izquierda)
                || "decimalis".equals(derecha)) {

            return "decimalis";
        }

        return izquierda;
    }

    // =========================================================
    // CUADRUPLOS
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
    // RESULTADO INTERNO
    // =========================================================
    private static class ResultadoPig {

        private final String valor;
        private final String tipo;

        public ResultadoPig(
                String valor,
                String tipo) {

            this.valor = valor;
            this.tipo = tipo;
        }
    }

    private void generarBloque(
            BloqueASTPig bloque) {

        if (bloque == null) {
            return;
        }

        for (SentenciaASTPig sentencia
                : bloque.getSentencias()) {

            generarSentencia(
                    sentencia
            );
        }
    }

    private void generarIf(
            IfASTPig sentencia) {

        ResultadoPig condicion
                = generarExpresion(
                        sentencia.getCondicion()
                );

        String etiquetaFalsa
                = etiquetas.nuevaEtiqueta();

        String etiquetaSalida
                = etiquetas.nuevaEtiqueta();

        agregar(
                "IF_FALSE",
                condicion.valor,
                null,
                etiquetaFalsa
        );

        generarBloque(
                sentencia.getBloqueVerdadero()
        );

        if (sentencia.getBloqueFalso()
                != null) {

            agregar(
                    "GOTO",
                    null,
                    null,
                    etiquetaSalida
            );
        }

        agregar(
                "LABEL",
                null,
                null,
                etiquetaFalsa
        );

        if (sentencia.getBloqueFalso()
                != null) {

            generarBloque(
                    sentencia.getBloqueFalso()
            );

            agregar(
                    "LABEL",
                    null,
                    null,
                    etiquetaSalida
            );
        }
    }

    private void generarWhile(
            WhileASTPig sentencia) {

        String etiquetaInicio
                = etiquetas.nuevaEtiqueta();

        String etiquetaSalida
                = etiquetas.nuevaEtiqueta();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaInicio
        );

        ResultadoPig condicion
                = generarExpresion(
                        sentencia.getCondicion()
                );

        agregar(
                "IF_FALSE",
                condicion.valor,
                null,
                etiquetaSalida
        );

        pilaBreak.push(
                etiquetaSalida
        );

        pilaContinue.push(
                etiquetaInicio
        );

        generarBloque(
                sentencia.getCuerpo()
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
                etiquetaSalida
        );
    }

    private void generarDoWhile(
            DoWhileASTPig sentencia) {

        String etiquetaInicio
                = etiquetas.nuevaEtiqueta();

        String etiquetaCondicion
                = etiquetas.nuevaEtiqueta();

        String etiquetaSalida
                = etiquetas.nuevaEtiqueta();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaInicio
        );

        pilaBreak.push(
                etiquetaSalida
        );

        pilaContinue.push(
                etiquetaCondicion
        );

        generarBloque(
                sentencia.getCuerpo()
        );

        pilaContinue.pop();
        pilaBreak.pop();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaCondicion
        );

        ResultadoPig condicion
                = generarExpresion(
                        sentencia.getCondicion()
                );

        agregar(
                "IF_FALSE",
                condicion.valor,
                null,
                etiquetaSalida
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
                etiquetaSalida
        );
    }

    private void generarFor(
            ForASTPig sentencia) {

        generarSentencia(
                sentencia.getInicializacion()
        );

        String etiquetaCondicion
                = etiquetas.nuevaEtiqueta();

        String etiquetaActualizacion
                = etiquetas.nuevaEtiqueta();

        String etiquetaSalida
                = etiquetas.nuevaEtiqueta();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaCondicion
        );

        ResultadoPig condicion
                = generarExpresion(
                        sentencia.getCondicion()
                );

        agregar(
                "IF_FALSE",
                condicion.valor,
                null,
                etiquetaSalida
        );

        pilaBreak.push(
                etiquetaSalida
        );

        pilaContinue.push(
                etiquetaActualizacion
        );

        generarBloque(
                sentencia.getCuerpo()
        );

        pilaContinue.pop();
        pilaBreak.pop();

        agregar(
                "LABEL",
                null,
                null,
                etiquetaActualizacion
        );

        generarSentencia(
                sentencia.getActualizacion()
        );

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
                etiquetaSalida
        );
    }

    // =========================================================
    // TOTAL DE ELEMENTOS
    // =========================================================
    private int calcularTotalElementos(
            List<Integer> dimensiones) {

        int total = 1;

        for (Integer dimension
                : dimensiones) {

            if (dimension == null
                    || dimension <= 0) {

                return 0;
            }

            total *= dimension;
        }

        return total;
    }

    // =========================================================
    // APLANAR INICIALIZADOR
    // =========================================================
    private void aplanarInicializador(
            InicializadorListaASTPig lista,
            List<ExpresionASTPig> salida) {

        if (lista == null) {
            return;
        }

        for (ExpresionASTPig valor
                : lista.getValores()) {

            if (valor instanceof InicializadorListaASTPig interna) {

                aplanarInicializador(
                        interna,
                        salida
                );

            } else {

                salida.add(
                        valor
                );
            }
        }
    }

    // =========================================================
    // RESULTADO DE DIRECCION DE ARREGLO
    // =========================================================
    private static class DireccionIndicePig {

        private final String direccion;
        private final String tipo;

        public DireccionIndicePig(
                String direccion,
                String tipo) {

            this.direccion = direccion;
            this.tipo = tipo;
        }
    }

    // =========================================================
    // BUSCAR CONSTRUCTOR IMPORTADO
    // =========================================================
    private MetodoImportadoPig buscarConstructor(
            ClaseImportadaPig clase,
            NuevoObjetoASTPig nuevo) {

        if (clase == null
                || nuevo == null) {

            return null;
        }

        int cantidadArgumentos
                = nuevo.getArgumentos()
                        .size();

        for (MetodoImportadoPig metodo
                : clase.getMetodos()) {

            if (!metodo.esConstructor()) {
                continue;
            }

            if (metodo.getTiposParametros()
                    .size()
                    != cantidadArgumentos) {

                continue;
            }

            return metodo;
        }

        return null;
    }

    // =========================================================
    // DECLARACION DE OBJETO
    // =========================================================
    private void generarDeclaracionObjeto(
            DeclaracionASTPig declaracion,
            VariableMemoriaPig variable) {

        String tipoObjeto
                = variable.getTipoReferencia();

        if (tipoObjeto == null
                || tipoObjeto.isBlank()) {

            tipoObjeto = variable.getTipo();
        }

        ClaseImportadaPig clase
                = registroImports.buscarClase(
                        tipoObjeto
                );

        if (clase == null) {
            return;
        }

        // =====================================================
        // 1. RESERVAR OBJETO
        // =====================================================
        String base
                = temporales.nuevoTemporal();

        agregar(
                "=",
                "H",
                null,
                base
        );

        int cantidadAtributos
                = clase.getAtributos()
                        .size();

        int tamanoFisico
                = Math.max(
                        1,
                        cantidadAtributos
                );

        for (int i = 0;
                i < tamanoFisico;
                i++) {

            agregar(
                    "HEAP_SET",
                    "0",
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

        // =====================================================
        // 2. GUARDAR PUNTERO EN STACK DE PIG
        // =====================================================
        String direccionStack
                = nuevaDireccionStack(
                        variable
                );

        agregar(
                "STACK_SET",
                base,
                null,
                direccionStack
        );

        // =====================================================
        // 3. INICIALIZADOR DEL OBJETO
        // =====================================================
        ExpresionASTPig inicializador
                = declaracion.getInicializador();

        // -----------------------------------------------------
        // ESTRUCTURA IMPORTADA DESDE Y
        // -----------------------------------------------------
        if (inicializador instanceof InicializadorListaASTPig lista) {

            generarInicializacionEstructuraY(
                    clase,
                    base,
                    lista
            );

            return;
        }

        // -----------------------------------------------------
        // OBJETO IMPORTADO DESDE Z
        // -----------------------------------------------------
        if (!(inicializador instanceof NuevoObjetoASTPig nuevo)) {

            return;
        }

        // =====================================================
        // 4. BUSCAR CONSTRUCTOR
        // =====================================================
        MetodoImportadoPig constructor
                = buscarConstructor(
                        clase,
                        nuevo
                );

        if (constructor == null) {

            return;
        }

        // =====================================================
        // 5. EVALUAR ARGUMENTOS PRIMERO
        // =====================================================
        List<ResultadoPig> argumentos
                = new ArrayList<>();

        for (ExpresionASTPig argumento
                : nuevo.getArgumentos()) {

            argumentos.add(
                    generarExpresion(
                            argumento
                    )
            );
        }

        int desplazamiento
                = marco.getTamano() + 1;

        String baseFrame
                = temporales.nuevoTemporal();

        agregar(
                "+",
                "P",
                String.valueOf(
                        desplazamiento
                ),
                baseFrame
        );

        // =====================================================
        // 7. $this
        // =====================================================
        String direccionThis
                = temporales.nuevoTemporal();

        agregar(
                "+",
                baseFrame,
                "1",
                direccionThis
        );

        agregar(
                "STACK_SET",
                base,
                null,
                direccionThis
        );

        // =====================================================
        // 8. PARAMETROS
        // =====================================================
        for (int i = 0;
                i < argumentos.size();
                i++) {

            String direccionParametro
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    baseFrame,
                    String.valueOf(
                            i + 2
                    ),
                    direccionParametro
            );

            agregar(
                    "STACK_SET",
                    argumentos.get(i).valor,
                    null,
                    direccionParametro
            );
        }

        // =====================================================
        // 9. MOVER P
        // =====================================================
        agregar(
                "+",
                "P",
                String.valueOf(
                        desplazamiento
                ),
                "P"
        );

        // =====================================================
        // 10. CALL CON FIRMA REAL
        // =====================================================
        agregar(
                "CALL",
                constructor.getFirma(),
                null,
                null
        );

        // =====================================================
        // 11. RESTAURAR P
        // =====================================================
        agregar(
                "-",
                "P",
                String.valueOf(
                        desplazamiento
                ),
                "P"
        );
    }

    private int obtenerOffsetAtributo(
            ClaseImportadaPig clase,
            String nombreAtributo) {

        if (clase == null
                || nombreAtributo == null) {

            return -1;
        }

        int offset = 0;

        for (AtributoImportadoPig atributo
                : clase.getAtributos()) {

            if (nombreAtributo.equals(
                    atributo.getNombre())) {

                return offset;
            }

            offset++;
        }

        return -1;
    }

    private DireccionAtributoPig resolverDireccionAtributo(
            AccesoASTPig acceso) {

        // =====================================================
        // 1. VALIDACIONES BASICAS
        // =====================================================
        if (acceso == null
                || acceso.esSimple()) {

            return null;
        }

        VariableMemoriaPig variable
                = marco.buscar(
                        acceso.getIdentificador()
                );

        if (variable == null) {
            return null;
        }

        boolean raizEsObjeto
                = variable.esObjeto();

        boolean raizEsArregloDeObjetos
                = variable.esArreglo()
                && variable.getTipoReferencia() != null
                && !variable.getTipoReferencia().isBlank();

        if (!raizEsObjeto
                && !raizEsArregloDeObjetos) {

            return null;
        }

        List<PasoAccesoASTPig> pasos
                = acceso.getPasos();

        if (pasos == null
                || pasos.isEmpty()) {

            return null;
        }

        // =====================================================
        // 2. TIPO DE LA VARIABLE RAIZ
        // =====================================================
        String tipoActual
                = variable.getTipoReferencia();

        if (tipoActual == null
                || tipoActual.isBlank()) {

            tipoActual
                    = variable.getTipo();
        }

        ClaseImportadaPig claseActual
                = registroImports.buscarClase(
                        tipoActual
                );

        if (claseActual == null) {

            return null;
        }

        // =====================================================
        // 3. LEER BASE DE LA ESTRUCTURA DESDE STACK
        // =====================================================
        String direccionStack
                = nuevaDireccionStack(
                        variable
                );

        String baseActual
                = temporales.nuevoTemporal();

        agregar(
                "STACK_GET",
                direccionStack,
                null,
                baseActual
        );

        int primerAtributo = 0;

        if (raizEsArregloDeObjetos) {

            List<ExpresionASTPig> indices
                    = new ArrayList<>();

            while (primerAtributo < pasos.size()
                    && pasos.get(primerAtributo).getTipo()
                    == PasoAccesoASTPig.TipoPaso.INDICE) {

                indices.add(
                        pasos.get(primerAtributo)
                                .getIndice()
                );

                primerAtributo++;
            }

            if (indices.size()
                    != variable.getDimensiones().size()) {

                return null;
            }

            ResultadoPig primerIndice
                    = generarExpresion(
                            indices.get(0)
                    );

            String indiceLineal
                    = primerIndice.valor;

            for (int i = 1;
                    i < indices.size();
                    i++) {

                String multiplicacion
                        = temporales.nuevoTemporal();

                agregar(
                        "*",
                        indiceLineal,
                        String.valueOf(
                                variable.getDimensiones()
                                        .get(i)
                        ),
                        multiplicacion
                );

                ResultadoPig indiceActual
                        = generarExpresion(
                                indices.get(i)
                        );

                String suma
                        = temporales.nuevoTemporal();

                agregar(
                        "+",
                        multiplicacion,
                        indiceActual.valor,
                        suma
                );

                indiceLineal = suma;
            }

            String inicioDatos
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    baseActual,
                    String.valueOf(
                            variable.getDimensiones().size() + 1
                    ),
                    inicioDatos
            );

            String direccionElemento
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    inicioDatos,
                    indiceLineal,
                    direccionElemento
            );

            String punteroElemento
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccionElemento,
                    null,
                    punteroElemento
            );

            baseActual = punteroElemento;

            if (primerAtributo >= pasos.size()) {
                return null;
            }
        }

        // =====================================================
        // 4. RECORRER CADENA DE ATRIBUTOS
        // =====================================================
        for (int i = primerAtributo;
                i < pasos.size();
                i++) {

            PasoAccesoASTPig paso
                    = pasos.get(i);

            if (paso.getTipo()
                    != PasoAccesoASTPig.TipoPaso.ATRIBUTO) {

                return null;
            }

            // -------------------------------------------------
            // Buscar atributo en la clase actual
            // -------------------------------------------------
            AtributoImportadoPig atributo
                    = claseActual.buscarAtributo(
                            paso.getNombre()
                    );

            if (atributo == null) {

                return null;
            }

            // -------------------------------------------------
            // Offset físico
            // -------------------------------------------------
            int offset
                    = obtenerOffsetAtributo(
                            claseActual,
                            paso.getNombre()
                    );

            if (offset < 0) {

                return null;
            }

            String direccionAtributo
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    baseActual,
                    String.valueOf(offset),
                    direccionAtributo
            );

            boolean ultimo
                    = i == pasos.size() - 1;

            // =================================================
            // 5. ATRIBUTO QUE CONTIENE UN ARREGLO
            // =================================================
            if (atributo.getDimensiones() > 0) {

                int cantidadIndices
                        = atributo.getDimensiones();

                if (i + cantidadIndices
                        >= pasos.size()) {

                    return null;
                }

                for (int dimension = 0;
                        dimension < cantidadIndices;
                        dimension++) {

                    PasoAccesoASTPig pasoIndice
                            = pasos.get(
                                    i + 1 + dimension
                            );

                    if (pasoIndice.getTipo()
                            != PasoAccesoASTPig.TipoPaso.INDICE) {

                        return null;
                    }
                }

                String baseArreglo
                        = temporales.nuevoTemporal();

                agregar(
                        "HEAP_GET",
                        direccionAtributo,
                        null,
                        baseArreglo
                );

                ResultadoPig primerIndice
                        = generarExpresion(
                                pasos.get(i + 1)
                                        .getIndice()
                        );

                String indiceLineal
                        = primerIndice.valor;

                for (int dimension = 1;
                        dimension < cantidadIndices;
                        dimension++) {

                    String direccionDimension
                            = temporales.nuevoTemporal();

                    agregar(
                            "+",
                            baseArreglo,
                            String.valueOf(
                                    dimension + 1
                            ),
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

                    String multiplicacion
                            = temporales.nuevoTemporal();

                    agregar(
                            "*",
                            indiceLineal,
                            tamanoDimension,
                            multiplicacion
                    );

                    ResultadoPig indiceActual
                            = generarExpresion(
                                    pasos.get(i + 1 + dimension)
                                            .getIndice()
                            );

                    String suma
                            = temporales.nuevoTemporal();

                    agregar(
                            "+",
                            multiplicacion,
                            indiceActual.valor,
                            suma
                    );

                    indiceLineal = suma;
                }

                String inicioDatos
                        = temporales.nuevoTemporal();

                agregar(
                        "+",
                        baseArreglo,
                        String.valueOf(
                                cantidadIndices + 1
                        ),
                        inicioDatos
                );

                String direccionElemento
                        = temporales.nuevoTemporal();

                agregar(
                        "+",
                        inicioDatos,
                        indiceLineal,
                        direccionElemento
                );

                i += cantidadIndices;

                boolean elementoEsUltimo
                        = i == pasos.size() - 1;

                if (elementoEsUltimo) {

                    return new DireccionAtributoPig(
                            direccionElemento,
                            convertirTipoRetornoPig(
                                    atributo.getTipo()
                            ),
                            0
                    );
                }

                String tipoElemento
                        = atributo.getTipo();

                ClaseImportadaPig claseElemento
                        = registroImports.buscarClase(
                                tipoElemento
                        );

                if (claseElemento == null) {

                    return null;
                }

                String punteroElemento
                        = temporales.nuevoTemporal();

                agregar(
                        "HEAP_GET",
                        direccionElemento,
                        null,
                        punteroElemento
                );

                baseActual = punteroElemento;
                claseActual = claseElemento;

                continue;
            }

            // =================================================
            // 6. ATRIBUTO NORMAL FINAL
            // =================================================
            if (ultimo) {

                return new DireccionAtributoPig(
                        direccionAtributo,
                        convertirTipoRetornoPig(
                                atributo.getTipo()
                        ),
                        0
                );
            }

            String tipoSiguiente
                    = atributo.getTipo();

            ClaseImportadaPig claseSiguiente
                    = registroImports.buscarClase(
                            tipoSiguiente
                    );

            if (claseSiguiente == null) {

                return null;
            }

            String nuevaBase
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccionAtributo,
                    null,
                    nuevaBase
            );

            baseActual = nuevaBase;
            claseActual = claseSiguiente;
        }

        return null;
    }

    private static class DireccionAtributoPig {

        private final String direccion;
        private final String tipo;
        private final int dimensiones;

        public DireccionAtributoPig(
                String direccion,
                String tipo,
                int dimensiones) {

            this.direccion = direccion;
            this.tipo = tipo;
            this.dimensiones = dimensiones;
        }
    }

    // =========================================================
    // BUSCAR METODO IMPORTADO
    // =========================================================
    private MetodoImportadoPig buscarMetodoObjeto(
            ClaseImportadaPig clase,
            String nombreMetodo,
            List<ResultadoPig> argumentos) {

        if (clase == null
                || nombreMetodo == null) {

            return null;
        }

        List<MetodoImportadoPig> candidatos
                = new ArrayList<>();

        // =====================================================
        // 1. FILTRAR POR NOMBRE Y CANTIDAD
        // =====================================================
        for (MetodoImportadoPig metodo
                : clase.getMetodos()) {

            if (metodo.esConstructor()) {
                continue;
            }

            if (!nombreMetodo.equals(
                    metodo.getNombre())) {

                continue;
            }

            if (metodo.getTiposParametros().size()
                    != argumentos.size()) {

                continue;
            }

            candidatos.add(
                    metodo
            );
        }

        if (candidatos.isEmpty()) {
            return null;
        }

        // =====================================================
        // 2. BUSCAR COINCIDENCIA DE TIPOS
        // =====================================================
        for (MetodoImportadoPig candidato
                : candidatos) {

            boolean coincide = true;

            for (int i = 0;
                    i < argumentos.size();
                    i++) {

                String recibido
                        = normalizarTipoFirma(
                                argumentos.get(i).tipo
                        );

                String esperado
                        = normalizarTipoFirma(
                                candidato
                                        .getTiposParametros()
                                        .get(i)
                        );

                if (!recibido.equals(esperado)) {

                    coincide = false;
                    break;
                }
            }

            if (coincide) {
                return candidato;
            }
        }

        if (candidatos.size() == 1) {

            return candidatos.get(0);
        }

        return null;
    }

    // =========================================================
    // NORMALIZAR TIPO PARA FIRMAS Z
    // =========================================================
    private String normalizarTipoFirma(
            String tipo) {

        if (tipo == null) {
            return "any";
        }

        String t
                = tipo.trim()
                        .toLowerCase();

        return switch (t) {

            case "numerus", "entero", "integer", "int" ->
                "int";

            case "decimalis", "decimal", "float", "double" ->
                "double";

            case "textum", "cadena", "string" ->
                "string";

            case "littera", "caracter", "char" ->
                "char";

            case "verum", "falsus", "booleano", "boolean", "bool" ->
                "bool";

            default ->
                t;
        };
    }

    // =========================================================
    // LLAMADA A METODO DE OBJETO IMPORTADO
    // =========================================================
    private ResultadoPig generarLlamadaMetodoObjeto(
            AccesoASTPig acceso) {

        if (acceso == null
                || acceso.esSimple()) {

            return null;
        }

        List<PasoAccesoASTPig> pasos
                = acceso.getPasos();

        if (pasos.isEmpty()) {
            return null;
        }

        PasoAccesoASTPig paso
                = pasos.get(
                        pasos.size() - 1
                );

        if (paso.getTipo()
                != PasoAccesoASTPig.TipoPaso.LLAMADA) {

            return null;
        }

        // =====================================================
        // 1. VARIABLE RECEPTORA
        // =====================================================
        VariableMemoriaPig variable
                = marco.buscar(
                        acceso.getIdentificador()
                );

        if (variable == null) {
            return null;
        }

        boolean receptorDirecto
                = variable.esObjeto()
                && pasos.size() == 1;

        boolean receptorDesdeArreglo
                = variable.esArreglo()
                && variable.getTipoReferencia() != null
                && !variable.getTipoReferencia().isBlank()
                && pasos.size()
                == variable.getDimensiones().size() + 1;

        if (!receptorDirecto
                && !receptorDesdeArreglo) {

            return null;
        }

        if (receptorDesdeArreglo) {

            for (int i = 0;
                    i < pasos.size() - 1;
                    i++) {

                if (pasos.get(i).getTipo()
                        != PasoAccesoASTPig.TipoPaso.INDICE) {

                    return null;
                }
            }
        }

        // =====================================================
        // 2. CLASE IMPORTADA
        // =====================================================
        String tipoObjeto
                = variable.getTipoReferencia();

        ClaseImportadaPig clase
                = registroImports.buscarClase(
                        tipoObjeto
                );

        if (clase == null) {
            return null;
        }

        List<ResultadoPig> argumentos
                = new ArrayList<>();

        for (ExpresionASTPig argumento
                : paso.getArgumentos()) {

            argumentos.add(
                    generarExpresion(
                            argumento
                    )
            );
        }

        // =====================================================
        // 4. RESOLVER METODO
        // =====================================================
        MetodoImportadoPig metodo
                = buscarMetodoObjeto(
                        clase,
                        paso.getNombre(),
                        argumentos
                );

        if (metodo == null) {

            return null;
        }

        // =====================================================
        // 5. OBTENER PUNTERO DEL OBJETO
        // =====================================================
        String objeto;

        if (receptorDirecto) {

            String direccionObjeto
                    = nuevaDireccionStack(
                            variable
                    );

            objeto
                    = temporales.nuevoTemporal();

            agregar(
                    "STACK_GET",
                    direccionObjeto,
                    null,
                    objeto
            );

        } else {

            AccesoASTPig accesoElemento
                    = new AccesoASTPig(
                            acceso.getIdentificador(),
                            acceso.getLinea(),
                            acceso.getColumna()
                    );

            for (int i = 0;
                    i < pasos.size() - 1;
                    i++) {

                accesoElemento.agregarPaso(
                        pasos.get(i)
                );
            }

            DireccionIndicePig direccionElemento
                    = resolverDireccionIndice(
                            accesoElemento
                    );

            if (direccionElemento == null) {
                return null;
            }

            objeto
                    = temporales.nuevoTemporal();

            agregar(
                    "HEAP_GET",
                    direccionElemento.direccion,
                    null,
                    objeto
            );
        }

        // =====================================================
        // 6. NUEVO FRAME Z
        // =====================================================
        int desplazamiento
                = marco.getTamano() + 1;

        String baseFrame
                = temporales.nuevoTemporal();

        agregar(
                "+",
                "P",
                String.valueOf(
                        desplazamiento
                ),
                baseFrame
        );

        // =====================================================
        // 7. $this -> offset 1
        // =====================================================
        String direccionThis
                = temporales.nuevoTemporal();

        agregar(
                "+",
                baseFrame,
                "1",
                direccionThis
        );

        agregar(
                "STACK_SET",
                objeto,
                null,
                direccionThis
        );

        // =====================================================
        // 8. PARAMETROS -> offset 2...
        // =====================================================
        for (int i = 0;
                i < argumentos.size();
                i++) {

            String direccionParametro
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    baseFrame,
                    String.valueOf(
                            i + 2
                    ),
                    direccionParametro
            );

            agregar(
                    "STACK_SET",
                    argumentos.get(i).valor,
                    null,
                    direccionParametro
            );
        }

        // =====================================================
        // 9. ENTRAR AL FRAME
        // =====================================================
        agregar(
                "+",
                "P",
                String.valueOf(
                        desplazamiento
                ),
                "P"
        );

        // =====================================================
        // 10. LLAMAR
        // =====================================================
        agregar(
                "CALL",
                metodo.getFirma(),
                null,
                null
        );

        String valorRetorno = "0";

        String tipoRetorno
                = metodo.getTipoRetorno();

        if (tipoRetorno != null
                && !"void".equalsIgnoreCase(
                        tipoRetorno
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

        // =====================================================
        // 12. RESTAURAR P
        // =====================================================
        agregar(
                "-",
                "P",
                String.valueOf(
                        desplazamiento
                ),
                "P"
        );

        return new ResultadoPig(
                valorRetorno,
                convertirTipoRetornoPig(
                        tipoRetorno
                )
        );
    }

    // =========================================================
    // TIPO EXTERNO -> TIPO INTERNO PIG
    // =========================================================
    private String convertirTipoRetornoPig(
            String tipo) {

        String normalizado
                = normalizarTipoFirma(
                        tipo
                );

        return switch (normalizado) {

            case "int" ->
                "numerus";

            case "double" ->
                "decimalis";

            case "string" ->
                "textum";

            case "char" ->
                "littera";

            case "bool" ->
                "verum";

            default ->
                normalizado;
        };
    }

    // =========================================================
    // BUSCAR FUNCION GLOBAL IMPORTADA DE Y
    // =========================================================
    private MetodoImportadoPig buscarFuncionGlobalY(
            String nombre,
            List<ResultadoPig> argumentos) {

        if (nombre == null) {
            return null;
        }

        ClaseImportadaPig funcionesY
                = registroImports.buscarClase(
                        "$Y_GLOBAL"
                );

        if (funcionesY == null) {
            return null;
        }

        List<MetodoImportadoPig> candidatos
                = new ArrayList<>();

        // =====================================================
        // 1. FILTRAR POR NOMBRE Y CANTIDAD
        // =====================================================
        for (MetodoImportadoPig funcion
                : funcionesY.getMetodos()) {

            if (funcion.esConstructor()) {
                continue;
            }

            if (!nombre.equals(
                    funcion.getNombre())) {

                continue;
            }

            if (funcion.getTiposParametros().size()
                    != argumentos.size()) {

                continue;
            }

            candidatos.add(
                    funcion
            );
        }

        if (candidatos.isEmpty()) {
            return null;
        }

        // =====================================================
        // 2. BUSCAR COINCIDENCIA DE TIPOS
        // =====================================================
        for (MetodoImportadoPig candidato
                : candidatos) {

            boolean coincide = true;

            for (int i = 0;
                    i < argumentos.size();
                    i++) {

                String recibido
                        = normalizarTipoFirma(
                                argumentos.get(i).tipo
                        );

                String esperado
                        = normalizarTipoFirma(
                                candidato
                                        .getTiposParametros()
                                        .get(i)
                        );

                if (!recibido.equals(
                        esperado)) {

                    coincide = false;
                    break;
                }
            }

            if (coincide) {
                return candidato;
            }
        }

        if (candidatos.size() == 1) {

            return candidatos.get(0);
        }

        return null;
    }

    // =========================================================
    // LLAMADA A FUNCION GLOBAL Y
    // =========================================================
    private ResultadoPig generarLlamadaFuncionY(
            LlamadaASTPig llamada) {

        if (llamada == null
                || !llamada.esGlobal()) {

            return null;
        }

        // =====================================================
        // 1. EVALUAR ARGUMENTOS PRIMERO
        // =====================================================
        List<ResultadoPig> argumentos
                = new ArrayList<>();

        for (ExpresionASTPig argumento
                : llamada.getArgumentos()) {

            argumentos.add(
                    generarExpresion(
                            argumento
                    )
            );
        }

        // =====================================================
        // 2. BUSCAR FUNCION Y
        // =====================================================
        MetodoImportadoPig funcion
                = buscarFuncionGlobalY(
                        llamada.getNombre(),
                        argumentos
                );

        if (funcion == null) {

            return null;
        }

        int desplazamiento
                = marco.getTamano() + 1;

        String baseFrame
                = temporales.nuevoTemporal();

        agregar(
                "+",
                "P",
                String.valueOf(
                        desplazamiento
                ),
                baseFrame
        );

        // =====================================================
        // 4. PARAMETROS DESDE OFFSET 1
        // =====================================================
        for (int i = 0;
                i < argumentos.size();
                i++) {

            String direccionParametro
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    baseFrame,
                    String.valueOf(
                            i + 1
                    ),
                    direccionParametro
            );

            agregar(
                    "STACK_SET",
                    argumentos.get(i).valor,
                    null,
                    direccionParametro
            );
        }

        // =====================================================
        // 5. ENTRAR AL FRAME
        // =====================================================
        agregar(
                "+",
                "P",
                String.valueOf(
                        desplazamiento
                ),
                "P"
        );

        agregar(
                "CALL",
                funcion.getNombre(),
                String.valueOf(
                        argumentos.size()
                ),
                null
        );

        // =====================================================
        // 7. LEER RETORNO DESDE P + 0
        // =====================================================
        String tipoRetorno
                = funcion.getTipoRetorno();

        String valorRetorno = "0";

        if (tipoRetorno != null
                && !"void".equalsIgnoreCase(
                        tipoRetorno)) {

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

        // =====================================================
        // 8. RESTAURAR P
        // =====================================================
        agregar(
                "-",
                "P",
                String.valueOf(
                        desplazamiento
                ),
                "P"
        );

        return new ResultadoPig(
                valorRetorno,
                convertirTipoRetornoPig(
                        tipoRetorno
                )
        );
    }

    // =========================================================
    // CADENA EN HEAP
    // =========================================================
    private ResultadoPig generarCadenaHeap(
            String contenido) {

        if (contenido == null) {

            contenido = "";
        }

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
                    String.valueOf(
                            (int) caracter
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
        }

        // Terminador de cadena
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

        return new ResultadoPig(
                puntero,
                "textum"
        );
    }

    // =========================================================
    // INICIALIZAR ESTRUCTURA IMPORTADA DESDE Y
    // =========================================================
    private void generarInicializacionEstructuraY(
            ClaseImportadaPig clase,
            String base,
            InicializadorListaASTPig lista) {

        if (clase == null
                || base == null
                || lista == null) {

            return;
        }

        List<AtributoImportadoPig> atributos
                = new ArrayList<>(
                        clase.getAtributos()
                );

        List<ExpresionASTPig> valores
                = lista.getValores();

        if (valores == null) {
            return;
        }

        int cantidad
                = Math.min(
                        atributos.size(),
                        valores.size()
                );

        for (int i = 0;
                i < cantidad;
                i++) {

            AtributoImportadoPig atributo
                    = atributos.get(i);

            ExpresionASTPig expresion
                    = valores.get(i);

            String valorFinal;

            if (expresion instanceof InicializadorListaASTPig listaAnidada) {

                ClaseImportadaPig claseAnidada
                        = registroImports.buscarClase(
                                atributo.getTipo()
                        );

                if (claseAnidada != null
                        && claseAnidada.getOrigen()
                        == TipoImportPig.Y) {

                    String baseAnidada
                            = reservarEstructuraY(
                                    claseAnidada
                            );

                    generarInicializacionEstructuraY(
                            claseAnidada,
                            baseAnidada,
                            listaAnidada
                    );

                    valorFinal
                            = baseAnidada;

                } else {

                    valorFinal = "0";
                }

            } else {

                ResultadoPig resultado
                        = generarExpresion(
                                expresion
                        );

                valorFinal
                        = resultado.valor;
            }

            // =====================================================
            // DIRECCION DEL ATRIBUTO
            // =====================================================
            String direccionAtributo
                    = temporales.nuevoTemporal();

            agregar(
                    "+",
                    base,
                    String.valueOf(i),
                    direccionAtributo
            );

            // =====================================================
            // ESCRIBIR ATRIBUTO
            // =====================================================
            agregar(
                    "HEAP_SET",
                    valorFinal,
                    null,
                    direccionAtributo
            );
        }
    }

    // =========================================================
// RESERVAR ESTRUCTURA Y EN HEAP
// =========================================================
    private String reservarEstructuraY(
            ClaseImportadaPig clase) {

        if (clase == null) {
            return "0";
        }

        String base
                = temporales.nuevoTemporal();

        // base = H
        agregar(
                "=",
                "H",
                null,
                base
        );

        int cantidadAtributos
                = clase.getAtributos()
                        .size();

        int tamanoFisico
                = Math.max(
                        1,
                        cantidadAtributos
                );

        // Reservar espacio para todos los atributos
        for (int i = 0;
                i < tamanoFisico;
                i++) {

            agregar(
                    "HEAP_SET",
                    "0",
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

        return base;
    }
}
