package elmer.compi2.zetariano.parser.ypython;

import elmer.compi2.zetariano.core.node.*;
/*
 */
import elmer.compi2.zetariano.core.node.*;

import elmer.compi2.zetariano.antlr.ypython.YParser;
import elmer.compi2.zetariano.antlr.ypython.YParserBaseVisitor;
import org.antlr.v4.runtime.tree.ParseTree;

/**
 *
 */
public class YTreeBuilder
        extends YParserBaseVisitor<NodoAST> {

    // ============================================================
    // PROGRAMA
    // ============================================================
    @Override
    public NodoAST visitPrograma(
            YParser.ProgramaContext ctx) {

        NodoAST programa
                = crearNodo(
                        TipoNodoAST.PROGRAMA,
                        null,
                        ctx
                );

        // ========================================================
        // SECCION DE ESTRUCTURAS
        // ========================================================
        if (ctx.seccionEstructuras() != null) {

            NodoAST estructuras
                    = visit(
                            ctx.seccionEstructuras()
                    );

            programa.agregarHijo(
                    estructuras
            );
        }

        // ========================================================
        // SECCION DE FUNCIONES
        // ========================================================
        if (ctx.seccionFunciones() != null) {

            NodoAST funciones
                    = visit(
                            ctx.seccionFunciones()
                    );

            programa.agregarHijo(
                    funciones
            );
        }

        return programa;
    }

    // ============================================================
    // SECCION DE ESTRUCTURAS
    // ============================================================
    @Override
    public NodoAST visitSeccionEstructuras(
            YParser.SeccionEstructurasContext ctx) {

        NodoAST seccion
                = crearNodo(
                        TipoNodoAST.SECCION_ESTRUCTURAS,
                        null,
                        ctx
                );

        for (YParser.DefinicionEstructuraContext estructuraCtx
                : ctx.definicionEstructura()) {

            NodoAST estructura
                    = visit(
                            estructuraCtx
                    );

            seccion.agregarHijo(
                    estructura
            );
        }

        return seccion;
    }

    // ============================================================
    // DEFINICION DE ESTRUCTURA
    // ============================================================
    @Override
    public NodoAST visitDefinicionEstructura(
            YParser.DefinicionEstructuraContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR()
                        .getText();

        NodoAST estructura
                = crearNodo(
                        TipoNodoAST.ESTRUCTURA,
                        nombre,
                        ctx
                );

        // ========================================================
        // ATRIBUTOS
        // ========================================================
        for (YParser.AtributoEstructuraContext atributoCtx
                : ctx.atributoEstructura()) {

            NodoAST atributo
                    = visit(
                            atributoCtx
                    );

            estructura.agregarHijo(
                    atributo
            );
        }

        return estructura;
    }

    // ============================================================
    // ATRIBUTO DE ESTRUCTURA
    // ============================================================
    @Override
    public NodoAST visitAtributoEstructura(
            YParser.AtributoEstructuraContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR().getText();

        String tipo
                = ctx.tipo().getText();

        NodoAST atributo
                = crearNodo(
                        TipoNodoAST.ATRIBUTO_ESTRUCTURA,
                        nombre + " : " + tipo,
                        ctx
                );

        for (YParser.DimensionConstanteContext dimensionCtx
                : ctx.dimensionConstante()) {

            NodoAST dimension
                    = crearNodo(
                            TipoNodoAST.DIMENSION,
                            null,
                            dimensionCtx
                    );

            NodoAST tamanio
                    = crearNodo(
                            TipoNodoAST.LITERAL_ENTERO,
                            dimensionCtx.ENTERO().getText(),
                            dimensionCtx
                    );

            dimension.agregarHijo(
                    tamanio
            );

            atributo.agregarHijo(
                    dimension
            );
        }

        return atributo;
    }

    // ============================================================
    // SECCION DE FUNCIONES
    // ============================================================
    @Override
    public NodoAST visitSeccionFunciones(
            YParser.SeccionFuncionesContext ctx) {

        NodoAST seccion
                = crearNodo(
                        TipoNodoAST.SECCION_FUNCIONES,
                        null,
                        ctx
                );

        for (YParser.DefinicionFuncionContext funcionCtx
                : ctx.definicionFuncion()) {

            NodoAST funcion
                    = visit(
                            funcionCtx
                    );

            seccion.agregarHijo(
                    funcion
            );
        }

        return seccion;
    }

    // ============================================================
    // FUNCION
    // ============================================================
    @Override
    public NodoAST visitDefinicionFuncion(
            YParser.DefinicionFuncionContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR()
                        .getText();

        NodoAST funcion
                = crearNodo(
                        TipoNodoAST.FUNCION,
                        nombre,
                        ctx
                );

        // ========================================================
        // PARAMETROS
        // ========================================================
        if (ctx.parametros() != null) {

            for (YParser.ParametroContext parametroCtx
                    : ctx.parametros()
                            .parametro()) {

                NodoAST parametro
                        = visit(
                                parametroCtx
                        );

                funcion.agregarHijo(
                        parametro
                );
            }
        }

        // ========================================================
        // TIPO DE RETORNO
        // ========================================================
        if (ctx.retornoFuncion() != null) {

            String tipoRetorno
                    = ctx.retornoFuncion()
                            .tipo()
                            .getText();

            NodoAST retorno
                    = crearNodo(
                            TipoNodoAST.TIPO_RETORNO,
                            tipoRetorno,
                            ctx.retornoFuncion()
                    );

            funcion.agregarHijo(
                    retorno
            );
        }

        // ========================================================
        // BLOQUE
        // ========================================================
        if (ctx.bloqueFuncion() != null) {

            NodoAST bloque
                    = visit(
                            ctx.bloqueFuncion()
                    );

            funcion.agregarHijo(
                    bloque
            );
        }

        return funcion;
    }

    // ============================================================
    // BLOQUE DE FUNCION
    // ============================================================
    @Override
    public NodoAST visitBloqueFuncion(
            YParser.BloqueFuncionContext ctx) {

        NodoAST bloque
                = crearNodo(
                        TipoNodoAST.BLOQUE,
                        null,
                        ctx
                );

        for (ParseTree child
                : ctx.children) {

            if (child instanceof YParser.DefinicionEstructuraContext estructuraCtx) {

                bloque.agregarHijo(
                        visit(
                                estructuraCtx
                        )
                );

            } else if (child instanceof YParser.SentenciaContext sentenciaCtx) {

                bloque.agregarHijo(
                        visit(
                                sentenciaCtx
                        )
                );
            }
        }

        return bloque;
    }

    @Override
    public NodoAST visitSentencia(
            YParser.SentenciaContext ctx) {

        if (ctx.declaracionVariable() != null) {

            return visit(
                    ctx.declaracionVariable()
            );
        }

        if (ctx.asignacion() != null) {

            return visit(
                    ctx.asignacion()
            );
        }

        if (ctx.retorno() != null) {

            return visit(
                    ctx.retorno()
            );
        }

        if (ctx.impresion() != null) {

            return visit(
                    ctx.impresion()
            );
        }

        if (ctx.incrementoDecremento() != null) {

            return visit(
                    ctx.incrementoDecremento()
            );
        }

        if (ctx.llamadaFuncion() != null) {

            return visit(
                    ctx.llamadaFuncion()
            );
        }

        if (ctx.ROMPER() != null) {

            return crearNodo(
                    TipoNodoAST.BREAK,
                    "romper",
                    ctx
            );
        }

        if (ctx.CONTINUAR() != null) {

            return crearNodo(
                    TipoNodoAST.CONTINUE,
                    "continuar",
                    ctx
            );
        }

        if (ctx.lectura() != null) {

            return visit(
                    ctx.lectura()
            );
        }

        if (ctx.sentenciaSi() != null) {
            return visit(ctx.sentenciaSi());
        }

        if (ctx.sentenciaMientras() != null) {
            return visit(ctx.sentenciaMientras());
        }

        if (ctx.sentenciaHacerMientras() != null) {
            return visit(ctx.sentenciaHacerMientras());
        }

        if (ctx.sentenciaPara() != null) {
            return visit(ctx.sentenciaPara());
        }

        if (ctx.sentenciaElegir() != null) {
            return visit(ctx.sentenciaElegir());
        }

        return null;
    }

    @Override
    public NodoAST visitDeclaracionVariable(
            YParser.DeclaracionVariableContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR()
                        .getText();

        String tipo
                = ctx.tipo()
                        .getText();

        TipoNodoAST tipoNodo
                = ctx.dimensiones().isEmpty()
                ? TipoNodoAST.DECLARACION_VARIABLE
                : TipoNodoAST.DECLARACION_ARREGLO;

        NodoAST declaracion
                = crearNodo(
                        tipoNodo,
                        nombre + " : " + tipo,
                        ctx
                );

        // ============================================================
        // DIMENSIONES
        // ============================================================
        for (YParser.DimensionesContext dimension
                : ctx.dimensiones()) {

            NodoAST nodoDimension
                    = crearNodo(
                            TipoNodoAST.DIMENSION,
                            null,
                            dimension
                    );

            if (dimension.expresion() != null) {

                nodoDimension.agregarHijo(
                        visit(
                                dimension.expresion()
                        )
                );
            }

            declaracion.agregarHijo(
                    nodoDimension
            );
        }

        // ============================================================
        // INICIALIZADOR
        // ============================================================
        if (ctx.inicializador() != null) {

            NodoAST inicializador
                    = visit(
                            ctx.inicializador()
                    );

            declaracion.agregarHijo(
                    inicializador
            );
        }

        return declaracion;
    }

    @Override
    public NodoAST visitRetorno(
            YParser.RetornoContext ctx) {

        NodoAST retorno
                = crearNodo(
                        TipoNodoAST.RETORNO,
                        null,
                        ctx
                );

        if (ctx.expresion() != null) {

            retorno.agregarHijo(
                    visit(
                            ctx.expresion()
                    )
            );
        }

        return retorno;
    }

    @Override
    public NodoAST visitAsignacion(
            YParser.AsignacionContext ctx) {

        NodoAST asignacion = crearNodo(
                TipoNodoAST.ASIGNACION,
                "=",
                ctx
        );

        asignacion.agregarHijo(
                visit(ctx.acceso())
        );

        asignacion.agregarHijo(
                visit(ctx.expresion())
        );

        return asignacion;
    }

    @Override
    public NodoAST visitInicializador(
            YParser.InicializadorContext ctx) {

        if (ctx.expresion() != null) {

            return visit(
                    ctx.expresion()
            );
        }

        if (ctx.inicializadorLista() != null) {

            return visit(
                    ctx.inicializadorLista()
            );
        }

        return null;
    }

    @Override
    public NodoAST visitInicializadorLista(
            YParser.InicializadorListaContext ctx) {

        NodoAST lista
                = crearNodo(
                        TipoNodoAST.INICIALIZADOR_LISTA,
                        null,
                        ctx
                );

        for (YParser.InicializadorContext elemento
                : ctx.inicializador()) {

            lista.agregarHijo(
                    visit(elemento)
            );
        }

        return lista;
    }

    @Override
    public NodoAST visitExpresion(
            YParser.ExpresionContext ctx) {

        return visit(
                ctx.expresionOr()
        );
    }

    @Override
    public NodoAST visitExpresionOr(
            YParser.ExpresionOrContext ctx) {

        NodoAST izquierdo
                = visit(
                        ctx.expresionAnd(0)
                );

        for (int i = 1;
                i < ctx.expresionAnd().size();
                i++) {

            NodoAST derecho
                    = visit(
                            ctx.expresionAnd(i)
                    );

            NodoAST operador
                    = crearNodo(
                            TipoNodoAST.EXPRESION_BINARIA,
                            "||",
                            ctx
                    );

            operador.agregarHijo(
                    izquierdo
            );

            operador.agregarHijo(
                    derecho
            );

            izquierdo = operador;
        }

        return izquierdo;
    }

    @Override
    public NodoAST visitExpresionAnd(
            YParser.ExpresionAndContext ctx) {

        NodoAST izquierdo
                = visit(
                        ctx.expresionIgualdad(0)
                );

        for (int i = 1;
                i < ctx.expresionIgualdad().size();
                i++) {

            NodoAST derecho
                    = visit(
                            ctx.expresionIgualdad(i)
                    );

            NodoAST operador
                    = crearNodo(
                            TipoNodoAST.EXPRESION_BINARIA,
                            "&&",
                            ctx
                    );

            operador.agregarHijo(
                    izquierdo
            );

            operador.agregarHijo(
                    derecho
            );

            izquierdo = operador;
        }

        return izquierdo;
    }

    @Override
    public NodoAST visitExpresionIgualdad(
            YParser.ExpresionIgualdadContext ctx) {

        NodoAST izquierdo
                = visit(
                        ctx.expresionRelacional(0)
                );

        for (int i = 1;
                i < ctx.expresionRelacional().size();
                i++) {

            String operador
                    = ctx.getChild(
                            (i * 2) - 1
                    ).getText();

            NodoAST derecho
                    = visit(
                            ctx.expresionRelacional(i)
                    );

            NodoAST expresion
                    = crearNodo(
                            TipoNodoAST.EXPRESION_BINARIA,
                            operador,
                            ctx
                    );

            expresion.agregarHijo(
                    izquierdo
            );

            expresion.agregarHijo(
                    derecho
            );

            izquierdo = expresion;
        }

        return izquierdo;
    }

    @Override
    public NodoAST visitExpresionRelacional(
            YParser.ExpresionRelacionalContext ctx) {

        NodoAST izquierdo
                = visit(
                        ctx.expresionAditiva(0)
                );

        for (int i = 1;
                i < ctx.expresionAditiva().size();
                i++) {

            String operador
                    = ctx.getChild(
                            (i * 2) - 1
                    ).getText();

            NodoAST derecho
                    = visit(
                            ctx.expresionAditiva(i)
                    );

            NodoAST expresion
                    = crearNodo(
                            TipoNodoAST.EXPRESION_BINARIA,
                            operador,
                            ctx
                    );

            expresion.agregarHijo(
                    izquierdo
            );

            expresion.agregarHijo(
                    derecho
            );

            izquierdo = expresion;
        }

        return izquierdo;
    }

    @Override
    public NodoAST visitExpresionAditiva(
            YParser.ExpresionAditivaContext ctx) {

        NodoAST izquierdo
                = visit(
                        ctx.expresionMultiplicativa(0)
                );

        for (int i = 1;
                i < ctx.expresionMultiplicativa().size();
                i++) {

            String operador
                    = ctx.getChild(
                            (i * 2) - 1
                    ).getText();

            NodoAST derecho
                    = visit(
                            ctx.expresionMultiplicativa(i)
                    );

            NodoAST expresion
                    = crearNodo(
                            TipoNodoAST.EXPRESION_BINARIA,
                            operador,
                            ctx
                    );

            expresion.agregarHijo(
                    izquierdo
            );

            expresion.agregarHijo(
                    derecho
            );

            izquierdo = expresion;
        }

        return izquierdo;
    }

    @Override
    public NodoAST visitExpresionMultiplicativa(
            YParser.ExpresionMultiplicativaContext ctx) {

        NodoAST izquierdo
                = visit(
                        ctx.expresionUnaria(0)
                );

        for (int i = 1;
                i < ctx.expresionUnaria().size();
                i++) {

            String operador
                    = ctx.getChild(
                            (i * 2) - 1
                    ).getText();

            NodoAST derecho
                    = visit(
                            ctx.expresionUnaria(i)
                    );

            NodoAST expresion
                    = crearNodo(
                            TipoNodoAST.EXPRESION_BINARIA,
                            operador,
                            ctx
                    );

            expresion.agregarHijo(
                    izquierdo
            );

            expresion.agregarHijo(
                    derecho
            );

            izquierdo = expresion;
        }

        return izquierdo;
    }

    @Override
    public NodoAST visitExpresionUnaria(
            YParser.ExpresionUnariaContext ctx) {

        // ============================================================
        // NOT
        // ============================================================
        if (ctx.NOT() != null) {

            NodoAST nodo
                    = crearNodo(
                            TipoNodoAST.EXPRESION_UNARIA,
                            "!",
                            ctx
                    );

            nodo.agregarHijo(
                    visit(
                            ctx.expresionUnaria()
                    )
            );

            return nodo;
        }

        // ============================================================
        // NEGATIVO
        // ============================================================
        if (ctx.MENOS() != null) {

            NodoAST nodo
                    = crearNodo(
                            TipoNodoAST.EXPRESION_UNARIA,
                            "-",
                            ctx
                    );

            nodo.agregarHijo(
                    visit(
                            ctx.expresionUnaria()
                    )
            );

            return nodo;
        }

        // ============================================================
        // PRIMARIA
        // ============================================================
        return visit(
                ctx.expresionPrimaria()
        );
    }

    @Override
    public NodoAST visitExpresionPrimaria(
            YParser.ExpresionPrimariaContext ctx) {

        // ============================================================
        // ENTERO
        // ============================================================
        if (ctx.ENTERO() != null) {

            return crearNodo(
                    TipoNodoAST.LITERAL_ENTERO,
                    ctx.ENTERO().getText(),
                    ctx
            );
        }

        // ============================================================
        // DECIMAL
        // ============================================================
        if (ctx.DECIMAL() != null) {

            return crearNodo(
                    TipoNodoAST.LITERAL_DECIMAL,
                    ctx.DECIMAL().getText(),
                    ctx
            );
        }

        // ============================================================
        // CADENA
        // ============================================================
        if (ctx.CADENA() != null) {

            return crearNodo(
                    TipoNodoAST.LITERAL_CADENA,
                    ctx.CADENA().getText(),
                    ctx
            );
        }

        // ============================================================
        // CARACTER
        // ============================================================
        if (ctx.CARACTER() != null) {

            return crearNodo(
                    TipoNodoAST.LITERAL_CARACTER,
                    ctx.CARACTER().getText(),
                    ctx
            );
        }

        // ============================================================
        // BOOLEANOS
        // ============================================================
        if (ctx.VERDADERO() != null) {

            return crearNodo(
                    TipoNodoAST.LITERAL_BOOLEANO,
                    ctx.VERDADERO().getText(),
                    ctx
            );
        }

        if (ctx.FALSO() != null) {

            return crearNodo(
                    TipoNodoAST.LITERAL_BOOLEANO,
                    ctx.FALSO().getText(),
                    ctx
            );
        }

        // ============================================================
        // ACCESO
        // ============================================================
        if (ctx.acceso() != null) {

            return visit(
                    ctx.acceso()
            );
        }

        // ============================================================
        // LLAMADA DE FUNCION
        // ============================================================
        if (ctx.llamadaFuncion() != null) {

            return visit(
                    ctx.llamadaFuncion()
            );
        }

        // ============================================================
        // LEER()
        // ============================================================
        if (ctx.lectura() != null) {

            return visit(
                    ctx.lectura()
            );
        }

        // ============================================================
        // EXPRESION ENTRE PARENTESIS
        //
        // Los parentesis NO necesitan nodo propio.
        // ============================================================
        if (ctx.expresion() != null) {

            return visit(
                    ctx.expresion()
            );
        }

        return null;
    }

    @Override
    public NodoAST visitAcceso(
            YParser.AccesoContext ctx) {

        NodoAST accesoActual
                = crearNodo(
                        TipoNodoAST.ACCESO_VARIABLE,
                        ctx.IDENTIFICADOR()
                                .getText(),
                        ctx
                );

        for (YParser.SufijoAccesoContext sufijo
                : ctx.sufijoAcceso()) {

            // ========================================================
            // ACCESO A ARREGLO
            //
            // arreglo[indice]
            // ========================================================
            if (sufijo.expresion() != null) {

                NodoAST accesoArreglo
                        = crearNodo(
                                TipoNodoAST.ACCESO_ARREGLO,
                                null,
                                sufijo
                        );

                accesoArreglo.agregarHijo(
                        accesoActual
                );

                accesoArreglo.agregarHijo(
                        visit(
                                sufijo.expresion()
                        )
                );

                accesoActual
                        = accesoArreglo;

                continue;
            }

            // ========================================================
            // ACCESO A ATRIBUTO
            //
            // objeto.atributo
            // ========================================================
            if (sufijo.IDENTIFICADOR() != null) {

                NodoAST accesoAtributo
                        = crearNodo(
                                TipoNodoAST.ACCESO_ATRIBUTO,
                                sufijo.IDENTIFICADOR()
                                        .getText(),
                                sufijo
                        );

                accesoAtributo.agregarHijo(
                        accesoActual
                );

                accesoActual
                        = accesoAtributo;
            }
        }

        return accesoActual;
    }

    @Override
    public NodoAST visitLlamadaFuncion(
            YParser.LlamadaFuncionContext ctx) {

        NodoAST llamada
                = crearNodo(
                        TipoNodoAST.LLAMADA_FUNCION,
                        ctx.IDENTIFICADOR()
                                .getText(),
                        ctx
                );

        if (ctx.argumentos() != null) {

            for (YParser.ExpresionContext argumento
                    : ctx.argumentos()
                            .expresion()) {

                llamada.agregarHijo(
                        visit(argumento)
                );
            }
        }

        return llamada;
    }

    @Override
    public NodoAST visitImpresion(
            YParser.ImpresionContext ctx) {

        NodoAST imprimir
                = crearNodo(
                        TipoNodoAST.IMPRIMIR,
                        null,
                        ctx
                );

        if (ctx.argumentos() != null) {

            for (YParser.ExpresionContext argumento
                    : ctx.argumentos()
                            .expresion()) {

                imprimir.agregarHijo(
                        visit(argumento)
                );
            }
        }

        return imprimir;
    }

    @Override
    public NodoAST visitLectura(
            YParser.LecturaContext ctx) {

        return crearNodo(
                TipoNodoAST.LECTURA,
                null,
                ctx
        );
    }

    @Override
    public NodoAST visitIncrementoDecremento(
            YParser.IncrementoDecrementoContext ctx) {

        boolean incremento
                = ctx.INCREMENTO() != null;

        NodoAST nodo
                = crearNodo(
                        incremento
                                ? TipoNodoAST.INCREMENTO
                                : TipoNodoAST.DECREMENTO,
                        incremento
                                ? "++"
                                : "--",
                        ctx
                );

        nodo.agregarHijo(
                visit(
                        ctx.acceso()
                )
        );

        return nodo;
    }

    @Override
    public NodoAST visitBloque(
            YParser.BloqueContext ctx) {

        NodoAST bloque = crearNodo(
                TipoNodoAST.BLOQUE,
                null,
                ctx
        );

        for (YParser.SentenciaContext sentenciaCtx
                : ctx.sentencia()) {

            NodoAST sentencia
                    = visit(sentenciaCtx);

            bloque.agregarHijo(sentencia);
        }

        return bloque;
    }

    @Override
    public NodoAST visitSentenciaSi(
            YParser.SentenciaSiContext ctx) {

        NodoAST nodoIf = crearNodo(
                TipoNodoAST.IF,
                null,
                ctx
        );

        // condición principal
        nodoIf.agregarHijo(
                visit(ctx.expresion())
        );

        // bloque del SI
        nodoIf.agregarHijo(
                visit(ctx.bloque())
        );

        // bloques SINO(condicion)
        for (YParser.BloqueSinoContext sinoCtx
                : ctx.bloqueSino()) {

            NodoAST nodoSino = crearNodo(
                    TipoNodoAST.IF,
                    "sino",
                    sinoCtx
            );

            nodoSino.agregarHijo(
                    visit(sinoCtx.expresion())
            );

            nodoSino.agregarHijo(
                    visit(sinoCtx.bloque())
            );

            nodoIf.agregarHijo(
                    nodoSino
            );
        }

        // CONTRARIO
        if (ctx.bloqueContrario() != null) {

            NodoAST nodoElse = crearNodo(
                    TipoNodoAST.ELSE,
                    null,
                    ctx.bloqueContrario()
            );

            nodoElse.agregarHijo(
                    visit(
                            ctx.bloqueContrario()
                                    .bloque()
                    )
            );

            nodoIf.agregarHijo(
                    nodoElse
            );
        }

        return nodoIf;
    }

    @Override
    public NodoAST visitSentenciaMientras(
            YParser.SentenciaMientrasContext ctx) {

        NodoAST nodo = crearNodo(
                TipoNodoAST.WHILE,
                null,
                ctx
        );

        nodo.agregarHijo(
                visit(ctx.expresion())
        );

        nodo.agregarHijo(
                visit(ctx.bloque())
        );

        return nodo;
    }

    @Override
    public NodoAST visitSentenciaHacerMientras(
            YParser.SentenciaHacerMientrasContext ctx) {

        NodoAST nodo = crearNodo(
                TipoNodoAST.DO_WHILE,
                null,
                ctx
        );

        // primero el cuerpo
        nodo.agregarHijo(
                visit(ctx.bloque())
        );

        // luego la condición
        nodo.agregarHijo(
                visit(ctx.expresion())
        );

        return nodo;
    }

    @Override
    public NodoAST visitSentenciaPara(
            YParser.SentenciaParaContext ctx) {

        NodoAST nodoFor
                = crearNodo(
                        TipoNodoAST.FOR,
                        null,
                        ctx
                );

        // ============================================================
        // 1. INICIALIZACION
        // ============================================================
        NodoAST nodoInicializacion
                = crearNodo(
                        TipoNodoAST.INICIALIZACION_FOR,
                        null,
                        ctx
                );

        if (ctx.inicializacionPara() != null) {

            YParser.InicializacionParaContext init
                    = ctx.inicializacionPara();

            if (init.declaracionVariable() != null) {

                nodoInicializacion.agregarHijo(
                        visit(
                                init.declaracionVariable()
                        )
                );

            } else if (init.asignacion() != null) {

                nodoInicializacion.agregarHijo(
                        visit(
                                init.asignacion()
                        )
                );
            }
        }

        nodoFor.agregarHijo(
                nodoInicializacion
        );

        // ============================================================
        // 2. CONDICION
        // ============================================================
        NodoAST nodoCondicion
                = crearNodo(
                        TipoNodoAST.CONDICION_FOR,
                        null,
                        ctx
                );

        if (ctx.expresion() != null) {

            nodoCondicion.agregarHijo(
                    visit(
                            ctx.expresion()
                    )
            );
        }

        nodoFor.agregarHijo(
                nodoCondicion
        );

        // ============================================================
        // 3. ACTUALIZACION
        // ============================================================
        NodoAST nodoActualizacion
                = crearNodo(
                        TipoNodoAST.ACTUALIZACION_FOR,
                        null,
                        ctx
                );

        if (ctx.actualizacionPara() != null) {

            YParser.ActualizacionParaContext actualizacion
                    = ctx.actualizacionPara();

            if (actualizacion.asignacion() != null) {

                nodoActualizacion.agregarHijo(
                        visit(
                                actualizacion.asignacion()
                        )
                );

            } else if (actualizacion.incrementoDecremento() != null) {

                nodoActualizacion.agregarHijo(
                        visit(
                                actualizacion.incrementoDecremento()
                        )
                );
            }
        }

        nodoFor.agregarHijo(
                nodoActualizacion
        );

        // ============================================================
        // 4. CUERPO
        // ============================================================
        nodoFor.agregarHijo(
                visit(
                        ctx.bloque()
                )
        );

        return nodoFor;
    }

    @Override
    public NodoAST visitSentenciaElegir(
            YParser.SentenciaElegirContext ctx) {

        NodoAST elegir = crearNodo(
                TipoNodoAST.ELEGIR,
                null,
                ctx
        );

        // selector
        elegir.agregarHijo(
                visit(ctx.expresion())
        );

        // casos
        for (YParser.CasoElegirContext casoCtx
                : ctx.casoElegir()) {

            elegir.agregarHijo(
                    visit(casoCtx)
            );
        }

        // siempre
        if (ctx.siempreElegir() != null) {

            elegir.agregarHijo(
                    visit(
                            ctx.siempreElegir()
                    )
            );
        }

        return elegir;
    }

    @Override
    public NodoAST visitCasoElegir(
            YParser.CasoElegirContext ctx) {

        NodoAST caso = crearNodo(
                TipoNodoAST.CASO,
                null,
                ctx
        );

        caso.agregarHijo(
                visit(ctx.expresion())
        );

        caso.agregarHijo(
                visit(ctx.bloque())
        );

        return caso;
    }

    @Override
    public NodoAST visitSiempreElegir(
            YParser.SiempreElegirContext ctx) {

        NodoAST siempre = crearNodo(
                TipoNodoAST.SIEMPRE,
                null,
                ctx
        );

        siempre.agregarHijo(
                visit(ctx.bloque())
        );

        return siempre;
    }

    @Override
    public NodoAST visitParametroValor(
            YParser.ParametroValorContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR().getText();

        String tipo
                = ctx.tipoPrimitivo().getText();

        NodoAST parametro
                = crearNodo(
                        TipoNodoAST.PARAMETRO,
                        nombre,
                        ctx
                );

        parametro.agregarHijo(
                crearNodo(
                        TipoNodoAST.TIPO_PARAMETRO,
                        tipo,
                        ctx.tipoPrimitivo()
                )
        );

        parametro.agregarHijo(
                crearNodo(
                        TipoNodoAST.MODO_PARAMETRO,
                        "VALOR",
                        ctx
                )
        );

        return parametro;
    }

    @Override
    public NodoAST visitParametro(
            YParser.ParametroContext ctx) {

        if (ctx.parametroValor() != null) {
            return visitParametroValor(
                    ctx.parametroValor()
            );
        }

        if (ctx.parametroArreglo() != null) {
            return visitParametroArreglo(
                    ctx.parametroArreglo()
            );
        }

        if (ctx.parametroEstructura() != null) {
            return visitParametroEstructura(
                    ctx.parametroEstructura()
            );
        }

        return crearNodo(
                TipoNodoAST.DESCONOCIDO,
                "parametro",
                ctx
        );
    }

    @Override
    public NodoAST visitParametroArreglo(
            YParser.ParametroArregloContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR().getText();

        String tipo
                = ctx.tipo().getText();

        NodoAST parametro
                = crearNodo(
                        TipoNodoAST.PARAMETRO,
                        nombre,
                        ctx
                );

        parametro.agregarHijo(
                crearNodo(
                        TipoNodoAST.TIPO_PARAMETRO,
                        tipo,
                        ctx.tipo()
                )
        );

        parametro.agregarHijo(
                crearNodo(
                        TipoNodoAST.MODO_PARAMETRO,
                        "REFERENCIA_ARREGLO",
                        ctx
                )
        );

        return parametro;
    }

    @Override
    public NodoAST visitParametroEstructura(
            YParser.ParametroEstructuraContext ctx) {

        String tipo
                = ctx.IDENTIFICADOR(0).getText();

        String nombre
                = ctx.IDENTIFICADOR(1).getText();

        NodoAST parametro
                = crearNodo(
                        TipoNodoAST.PARAMETRO,
                        nombre,
                        ctx
                );

        parametro.agregarHijo(
                crearNodo(
                        TipoNodoAST.TIPO_PARAMETRO,
                        tipo,
                        ctx
                )
        );

        parametro.agregarHijo(
                crearNodo(
                        TipoNodoAST.MODO_PARAMETRO,
                        "REFERENCIA_ESTRUCTURA",
                        ctx
                )
        );

        return parametro;
    }

    // ============================================================
    // CREACION DE NODOS
    // ============================================================
    private NodoAST crearNodo(
            TipoNodoAST tipo,
            String valor,
            org.antlr.v4.runtime.ParserRuleContext ctx) {

        int linea = -1;
        int columna = -1;

        if (ctx != null
                && ctx.getStart() != null) {

            linea
                    = ctx.getStart()
                            .getLine();

            columna
                    = ctx.getStart()
                            .getCharPositionInLine();
        }

        return new NodoAST(
                tipo,
                valor,
                linea,
                columna
        );
    }
}
