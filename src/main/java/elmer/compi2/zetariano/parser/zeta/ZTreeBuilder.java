package elmer.compi2.zetariano.parser.zeta;

import elmer.compi2.zetariano.core.node.*;
import elmer.compi2.zetariano.core.node.zeta.*;
/*
 */
import elmer.compi2.zetariano.core.node.*;
import elmer.compi2.zetariano.core.node.zeta.*;

import java.util.ArrayList;
import java.util.List;
import elmer.compi2.zetariano.antlr.zeta.ZParser;
import elmer.compi2.zetariano.antlr.zeta.ZParserBaseVisitor;

/**
 *
 */
public class ZTreeBuilder extends ZParserBaseVisitor<NodoASTZ> {

    // =========================================================
    // PROGRAMA
    // =========================================================
    @Override
    public NodoASTZ visitPrograma(
            ZParser.ProgramaContext ctx) {

        ClaseASTZ clase = (ClaseASTZ) visit(ctx.definicionClase());

        return new ProgramaASTZ(
                clase,
                ctx.getStart().getLine(),
                ctx.getStart().getCharPositionInLine()
        );
    }

    // =========================================================
    // CLASE
    // =========================================================
    @Override
    public NodoASTZ visitDefinicionClase(
            ZParser.DefinicionClaseContext ctx) {

        String nombreClase
                = ctx.IDENTIFICADOR().getText();

        ClaseASTZ clase = new ClaseASTZ(
                nombreClase,
                ctx.getStart().getLine(),
                ctx.getStart().getCharPositionInLine()
        );

        for (ZParser.MiembroClaseContext miembro
                : ctx.miembroClase()) {

            NodoASTZ nodo = visit(miembro);

            if (nodo instanceof MiembroASTZ miembroAST) {
                clase.agregarMiembro(miembroAST);
            }
        }

        return clase;
    }

    // =========================================================
    // MIEMBRO DE CLASE
    // =========================================================
    @Override
    public NodoASTZ visitMiembroClase(
            ZParser.MiembroClaseContext ctx) {

        if (ctx.atributo() != null) {
            return visit(ctx.atributo());
        }

        if (ctx.constructor() != null) {
            return visit(ctx.constructor());
        }

        if (ctx.metodo() != null) {
            return visit(ctx.metodo());
        }

        return null;
    }

    // =========================================================
    // ATRIBUTO
    // =========================================================
    @Override
    public NodoASTZ visitAtributo(
            ZParser.AtributoContext ctx) {

        String tipo
                = ctx.tipo().getText();

        String nombre
                = ctx.IDENTIFICADOR().getText();

        int dimensiones
                = ctx.dimensionesParametro().size()
                + ctx.dimensiones().size();

        ExpresionASTZ inicializador = null;

        if (ctx.inicializador() != null) {
            inicializador
                    = construirInicializador(
                            ctx.inicializador()
                    );
        }

        return new AtributoASTZ(
                nombre,
                tipo,
                dimensiones,
                inicializador,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    // =========================================================
    // CONSTRUCTOR
    // =========================================================
    @Override
    public NodoASTZ visitConstructor(
            ZParser.ConstructorContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR().getText();

        List<ParametroASTZ> parametros
                = construirParametros(
                        ctx.listaParametros()
                );

        BloqueASTZ cuerpo
                = (BloqueASTZ) visit(ctx.bloque());

        return new ConstructorASTZ(
                nombre,
                parametros,
                cuerpo,
                ctx.getStart().getLine(),
                ctx.getStart().getCharPositionInLine()
        );
    }

    // =========================================================
    // METODO
    // =========================================================
    @Override
    public NodoASTZ visitMetodo(
            ZParser.MetodoContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR().getText();

        String tipoRetorno
                = ctx.tipoRetorno().getText();

        List<ParametroASTZ> parametros
                = construirParametros(
                        ctx.listaParametros()
                );

        BloqueASTZ cuerpo
                = (BloqueASTZ) visit(ctx.bloque());

        return new MetodoASTZ(
                nombre,
                tipoRetorno,
                parametros,
                cuerpo,
                ctx.getStart().getLine(),
                ctx.getStart().getCharPositionInLine()
        );
    }

    // =========================================================
    // PARAMETROS
    // =========================================================
    private List<ParametroASTZ> construirParametros(
            ZParser.ListaParametrosContext ctx) {

        List<ParametroASTZ> parametros
                = new ArrayList<>();

        if (ctx == null) {
            return parametros;
        }

        for (ZParser.ParametroContext parametro
                : ctx.parametro()) {

            String tipo
                    = parametro.tipo().getText();

            String nombre
                    = parametro.IDENTIFICADOR().getText();

            int dimensiones
                    = parametro.dimensionesParametro().size();

            ParametroASTZ parametroAST
                    = new ParametroASTZ(
                            nombre,
                            tipo,
                            dimensiones,
                            parametro.getStart().getLine(),
                            parametro.getStart()
                                    .getCharPositionInLine()
                    );

            parametros.add(parametroAST);
        }

        return parametros;
    }

    // =========================================================
    // BLOQUE
    // =========================================================
    @Override
    public NodoASTZ visitBloque(
            ZParser.BloqueContext ctx) {

        BloqueASTZ bloque
                = new BloqueASTZ(
                        ctx.getStart().getLine(),
                        ctx.getStart()
                                .getCharPositionInLine()
                );

        for (ZParser.SentenciaContext sentencia
                : ctx.sentencia()) {

            NodoASTZ nodo
                    = visit(sentencia);

            if (nodo instanceof SentenciaASTZ sentenciaAST) {

                bloque.agregarSentencia(
                        sentenciaAST
                );
            }
        }

        return bloque;
    }

    @Override
    public NodoASTZ visitInicializadorLista(
            ZParser.InicializadorListaContext ctx) {

        List<ExpresionASTZ> elementos
                = new ArrayList<>();

        for (ZParser.InicializadorContext inicializador
                : ctx.inicializador()) {

            ExpresionASTZ elemento
                    = construirInicializador(
                            inicializador
                    );

            if (elemento != null) {
                elementos.add(elemento);
            }
        }

        return new InicializadorListaASTZ(
                elementos,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitExpresion(
            ZParser.ExpresionContext ctx) {

        // Ternario
        if (ctx.TERNARIO() != null) {

            ExpresionASTZ condicion
                    = (ExpresionASTZ) visit(ctx.expresionOr());

            ExpresionASTZ verdadero
                    = (ExpresionASTZ) visit(ctx.expresion(0));

            ExpresionASTZ falso
                    = (ExpresionASTZ) visit(ctx.expresion(1));

            return new TernariaASTZ(
                    condicion,
                    verdadero,
                    falso,
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine()
            );
        }

        return visit(ctx.expresionOr());
    }

    @Override
    public NodoASTZ visitDeclaracionVariable(
            ZParser.DeclaracionVariableContext ctx) {

        String tipo
                = ctx.tipo().getText();

        String nombre
                = ctx.IDENTIFICADOR().getText();

        int dimensiones
                = ctx.dimensionesParametro().size()
                + ctx.dimensiones().size();

        ExpresionASTZ inicializador = null;

        if (ctx.inicializador() != null) {
            inicializador
                    = construirInicializador(
                            ctx.inicializador()
                    );
        }

        return new DeclaracionASTZ(
                nombre,
                tipo,
                dimensiones,
                inicializador,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitSentencia(
            ZParser.SentenciaContext ctx) {

        if (ctx.declaracionVariable() != null) {
            return visit(ctx.declaracionVariable());
        }

        if (ctx.asignacion() != null) {
            return visit(ctx.asignacion());
        }

        if (ctx.incrementoDecremento() != null) {
            return visit(ctx.incrementoDecremento());
        }

        if (ctx.sentenciaReturn() != null) {
            return visit(ctx.sentenciaReturn());
        }

        if (ctx.sentenciaIf() != null) {
            return visit(ctx.sentenciaIf());
        }

        if (ctx.sentenciaSwitch() != null) {
            return visit(ctx.sentenciaSwitch());
        }

        if (ctx.sentenciaFor() != null) {
            return visit(ctx.sentenciaFor());
        }

        if (ctx.sentenciaWhile() != null) {
            return visit(ctx.sentenciaWhile());
        }

        if (ctx.sentenciaDoWhile() != null) {
            return visit(ctx.sentenciaDoWhile());
        }

        if (ctx.BREAK() != null) {
            return new BreakASTZ(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine()
            );
        }

        if (ctx.CONTINUE() != null) {
            return new ContinueASTZ(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine()
            );
        }

        if (ctx.llamadaMetodo() != null) {

            ExpresionASTZ llamada
                    = (ExpresionASTZ) visit(ctx.llamadaMetodo());

            return new ExpresionSentenciaASTZ(
                    llamada,
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine()
            );
        }

        if (ctx.llamadaMetodoObjeto() != null) {

            ExpresionASTZ llamada
                    = (ExpresionASTZ) visit(ctx.llamadaMetodoObjeto());

            return new ExpresionSentenciaASTZ(
                    llamada,
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine()
            );
        }

        if (ctx.impresion() != null) {
            return visit(ctx.impresion());
        }

        if (ctx.bloque() != null) {
            return visit(ctx.bloque());
        }

        return null;
    }

    @Override
    public NodoASTZ visitExpresionOr(
            ZParser.ExpresionOrContext ctx) {

        if (ctx.OR() != null) {

            ExpresionASTZ izquierda
                    = (ExpresionASTZ) visit(ctx.expresionOr());

            ExpresionASTZ derecha
                    = (ExpresionASTZ) visit(ctx.expresionAnd());

            return new BinariaASTZ(
                    izquierda,
                    ctx.OR().getText(),
                    derecha,
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine()
            );
        }

        return visit(ctx.expresionAnd());
    }

    @Override
    public NodoASTZ visitExpresionAnd(
            ZParser.ExpresionAndContext ctx) {

        if (ctx.AND() != null) {

            ExpresionASTZ izquierda
                    = (ExpresionASTZ) visit(ctx.expresionAnd());

            ExpresionASTZ derecha
                    = (ExpresionASTZ) visit(ctx.expresionIgualdad());

            return new BinariaASTZ(
                    izquierda,
                    ctx.AND().getText(),
                    derecha,
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine()
            );
        }

        return visit(ctx.expresionIgualdad());
    }

    @Override
    public NodoASTZ visitExpresionIgualdad(
            ZParser.ExpresionIgualdadContext ctx) {

        if (ctx.expresionIgualdad() != null) {

            ExpresionASTZ izquierda
                    = (ExpresionASTZ) visit(ctx.expresionIgualdad());

            ExpresionASTZ derecha
                    = (ExpresionASTZ) visit(ctx.expresionRelacional());

            String operador;

            if (ctx.IGUAL_IGUAL() != null) {
                operador = ctx.IGUAL_IGUAL().getText();
            } else {
                operador = ctx.DIFERENTE().getText();
            }

            return new BinariaASTZ(
                    izquierda,
                    operador,
                    derecha,
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine()
            );
        }

        return visit(ctx.expresionRelacional());
    }

    @Override
    public NodoASTZ visitExpresionRelacional(
            ZParser.ExpresionRelacionalContext ctx) {

        if (ctx.expresionRelacional() != null) {

            ExpresionASTZ izquierda
                    = (ExpresionASTZ) visit(ctx.expresionRelacional());

            ExpresionASTZ derecha
                    = (ExpresionASTZ) visit(ctx.expresionAditiva());

            String operador;

            if (ctx.MAYOR() != null) {
                operador = ctx.MAYOR().getText();

            } else if (ctx.MENOR() != null) {
                operador = ctx.MENOR().getText();

            } else if (ctx.MAYOR_IGUAL() != null) {
                operador = ctx.MAYOR_IGUAL().getText();

            } else {
                operador = ctx.MENOR_IGUAL().getText();
            }

            return new BinariaASTZ(
                    izquierda,
                    operador,
                    derecha,
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine()
            );
        }

        return visit(ctx.expresionAditiva());
    }

    @Override
    public NodoASTZ visitExpresionAditiva(
            ZParser.ExpresionAditivaContext ctx) {

        if (ctx.expresionAditiva() != null) {

            ExpresionASTZ izquierda
                    = (ExpresionASTZ) visit(ctx.expresionAditiva());

            ExpresionASTZ derecha
                    = (ExpresionASTZ) visit(ctx.expresionMultiplicativa());

            String operador;

            if (ctx.MAS() != null) {
                operador = ctx.MAS().getText();
            } else {
                operador = ctx.MENOS().getText();
            }

            return new BinariaASTZ(
                    izquierda,
                    operador,
                    derecha,
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine()
            );
        }

        return visit(ctx.expresionMultiplicativa());
    }

    @Override
    public NodoASTZ visitExpresionMultiplicativa(
            ZParser.ExpresionMultiplicativaContext ctx) {

        if (ctx.expresionMultiplicativa() != null) {

            ExpresionASTZ izquierda
                    = (ExpresionASTZ) visit(ctx.expresionMultiplicativa());

            ExpresionASTZ derecha
                    = (ExpresionASTZ) visit(ctx.expresionUnaria());

            String operador;

            if (ctx.POR() != null) {
                operador = ctx.POR().getText();

            } else if (ctx.DIV() != null) {
                operador = ctx.DIV().getText();

            } else {
                operador = ctx.MOD().getText();
            }

            return new BinariaASTZ(
                    izquierda,
                    operador,
                    derecha,
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine()
            );
        }

        return visit(ctx.expresionUnaria());
    }

    @Override
    public NodoASTZ visitExpresionUnaria(
            ZParser.ExpresionUnariaContext ctx) {

        if (ctx.NOT() != null) {

            ExpresionASTZ expresion
                    = (ExpresionASTZ) visit(ctx.expresionUnaria());

            return new UnariaASTZ(
                    ctx.NOT().getText(),
                    expresion,
                    false,
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine()
            );
        }

        if (ctx.MENOS() != null) {

            ExpresionASTZ expresion
                    = (ExpresionASTZ) visit(ctx.expresionUnaria());

            return new UnariaASTZ(
                    ctx.MENOS().getText(),
                    expresion,
                    false,
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine()
            );
        }

        return visit(ctx.primario());
    }

    @Override
    public NodoASTZ visitPrimario(
            ZParser.PrimarioContext ctx) {

        if (ctx.literal() != null) {
            return visit(ctx.literal());
        }

        if (ctx.acceso() != null) {
            return visit(ctx.acceso());
        }

        if (ctx.llamadaMetodo() != null) {
            return visit(ctx.llamadaMetodo());
        }

        if (ctx.creacionObjeto() != null) {
            return visit(ctx.creacionObjeto());
        }

        if (ctx.creacionArreglo() != null) {
            return visit(ctx.creacionArreglo());
        }

        if (ctx.READLN() != null) {

            return new LlamadaASTZ(
                    "readln",
                    new ArrayList<>(),
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine()
            );
        }

        if (ctx.expresion() != null) {
            return visit(ctx.expresion());
        }

        return null;
    }

    @Override
    public NodoASTZ visitLiteral(
            ZParser.LiteralContext ctx) {

        int linea
                = ctx.getStart().getLine();

        int columna
                = ctx.getStart()
                        .getCharPositionInLine();

        if (ctx.ENTERO() != null) {

            return new LiteralASTZ(
                    Integer.parseInt(
                            ctx.ENTERO().getText()
                    ),
                    "int",
                    linea,
                    columna
            );
        }

        if (ctx.DECIMAL() != null) {

            return new LiteralASTZ(
                    Double.parseDouble(
                            ctx.DECIMAL().getText()
                    ),
                    "double",
                    linea,
                    columna
            );
        }

        if (ctx.CADENA() != null) {

            String texto
                    = ctx.CADENA().getText();

            if (texto.length() >= 2) {
                texto
                        = texto.substring(
                                1,
                                texto.length() - 1
                        );
            }

            return new LiteralASTZ(
                    texto,
                    "String",
                    linea,
                    columna
            );
        }

        if (ctx.CARACTER() != null) {

            String texto
                    = ctx.CARACTER().getText();

            char valor = '\0';

            if (texto.length() >= 3) {
                valor = texto.charAt(1);
            }

            return new LiteralASTZ(
                    valor,
                    "char",
                    linea,
                    columna
            );
        }

        if (ctx.TRUE() != null) {

            return new LiteralASTZ(
                    true,
                    "boolean",
                    linea,
                    columna
            );
        }

        if (ctx.FALSE() != null) {

            return new LiteralASTZ(
                    false,
                    "boolean",
                    linea,
                    columna
            );
        }

        if (ctx.NULL() != null) {

            return new LiteralASTZ(
                    null,
                    "null",
                    linea,
                    columna
            );
        }

        return null;
    }

    @Override
    public NodoASTZ visitLlamadaMetodo(
            ZParser.LlamadaMetodoContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR().getText();

        List<ExpresionASTZ> argumentos
                = construirArgumentos(
                        ctx.listaArgumentos()
                );

        return new LlamadaASTZ(
                nombre,
                argumentos,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitAcceso(
            ZParser.AccesoContext ctx) {

        String base
                = ctx.IDENTIFICADOR().getText();

        AccesoASTZ acceso
                = new AccesoASTZ(
                        base,
                        ctx.getStart().getLine(),
                        ctx.getStart()
                                .getCharPositionInLine()
                );

        for (ZParser.SufijoAccesoContext sufijo
                : ctx.sufijoAcceso()) {

            // =============================================
            // INDICE
            // =============================================
            if (sufijo.CORCHETE_IZQ() != null) {

                ExpresionASTZ indice
                        = (ExpresionASTZ) visit(sufijo.expresion());

                acceso.agregarPaso(
                        PasoAccesoASTZ.indice(
                                indice
                        )
                );

                continue;
            }

            String nombre
                    = sufijo.IDENTIFICADOR().getText();

            // =============================================
            // LLAMADA
            // =============================================
            if (sufijo.PAREN_IZQ() != null) {

                List<ExpresionASTZ> argumentos
                        = construirArgumentos(
                                sufijo.listaArgumentos()
                        );

                acceso.agregarPaso(
                        PasoAccesoASTZ.llamada(
                                nombre,
                                argumentos
                        )
                );

                continue;
            }

            // =============================================
            // ATRIBUTO
            // =============================================
            acceso.agregarPaso(
                    PasoAccesoASTZ.atributo(
                            nombre
                    )
            );
        }

        return acceso;
    }

    @Override
    public NodoASTZ visitCreacionObjeto(
            ZParser.CreacionObjetoContext ctx) {

        String tipo
                = ctx.IDENTIFICADOR().getText();

        List<ExpresionASTZ> argumentos
                = construirArgumentos(
                        ctx.listaArgumentos()
                );

        return new NuevoObjetoASTZ(
                tipo,
                argumentos,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitCreacionArreglo(
            ZParser.CreacionArregloContext ctx) {

        String tipo
                = ctx.tipo().getText();

        List<ExpresionASTZ> dimensiones
                = new ArrayList<>();

        for (ZParser.DimensionCreacionContext dimension
                : ctx.dimensionCreacion()) {

            ExpresionASTZ expresion
                    = (ExpresionASTZ) visit(dimension.expresion());

            dimensiones.add(expresion);
        }

        return new NuevoArregloASTZ(
                tipo,
                dimensiones,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitAsignacion(
            ZParser.AsignacionContext ctx) {

        ExpresionASTZ destino
                = (ExpresionASTZ) visit(ctx.acceso());

        ExpresionASTZ valor
                = (ExpresionASTZ) visit(ctx.expresion());

        String operador
                = ctx.operadorAsignacion().getText();

        return new AsignacionASTZ(
                destino,
                operador,
                valor,
                ctx.getStart().getLine(),
                ctx.getStart().getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitIncrementoDecremento(
            ZParser.IncrementoDecrementoContext ctx) {

        ExpresionASTZ destino
                = (ExpresionASTZ) visit(ctx.acceso());

        String operador;

        if (ctx.INCREMENTO() != null) {
            operador = ctx.INCREMENTO().getText();
        } else {
            operador = ctx.DECREMENTO().getText();
        }

        return new IncrementoDecrementoASTZ(
                destino,
                operador,
                ctx.getStart().getLine(),
                ctx.getStart().getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitSentenciaReturn(
            ZParser.SentenciaReturnContext ctx) {

        ExpresionASTZ expresion = null;

        if (ctx.expresion() != null) {
            expresion
                    = (ExpresionASTZ) visit(ctx.expresion());
        }

        return new ReturnASTZ(
                expresion,
                ctx.getStart().getLine(),
                ctx.getStart().getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitImpresion(
            ZParser.ImpresionContext ctx) {

        ExpresionASTZ expresion = null;

        if (ctx.expresion() != null) {
            expresion
                    = (ExpresionASTZ) visit(ctx.expresion());
        }

        boolean saltoLinea
                = ctx.PRINTLN() != null;

        return new ImpresionASTZ(
                expresion,
                saltoLinea,
                ctx.getStart().getLine(),
                ctx.getStart().getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitLlamadaMetodoObjeto(
            ZParser.LlamadaMetodoObjetoContext ctx) {

        String base
                = ctx.IDENTIFICADOR(0).getText();

        AccesoASTZ acceso
                = new AccesoASTZ(
                        base,
                        ctx.getStart().getLine(),
                        ctx.getStart().getCharPositionInLine()
                );

        for (ZParser.SufijoObjetoContext sufijo
                : ctx.sufijoObjeto()) {

            if (sufijo.CORCHETE_IZQ() != null) {

                ExpresionASTZ indice
                        = (ExpresionASTZ) visit(sufijo.expresion());

                acceso.agregarPaso(
                        PasoAccesoASTZ.indice(indice)
                );

            } else {

                acceso.agregarPaso(
                        PasoAccesoASTZ.atributo(
                                sufijo.IDENTIFICADOR().getText()
                        )
                );
            }
        }

        String nombreMetodo
                = ctx.IDENTIFICADOR(
                        ctx.IDENTIFICADOR().size() - 1
                ).getText();

        List<ExpresionASTZ> argumentos
                = construirArgumentos(
                        ctx.listaArgumentos()
                );

        acceso.agregarPaso(
                PasoAccesoASTZ.llamada(
                        nombreMetodo,
                        argumentos
                )
        );

        return acceso;
    }

    @Override
    public NodoASTZ visitSentenciaIf(
            ZParser.SentenciaIfContext ctx) {

        List<IfASTZ.RamaIf> ramas
                = new ArrayList<>();

        List<ZParser.ExpresionContext> condiciones
                = ctx.expresion();

        List<ZParser.CuerpoControlContext> cuerpos
                = ctx.cuerpoControl();

        for (int i = 0;
                i < condiciones.size();
                i++) {

            ExpresionASTZ condicion
                    = (ExpresionASTZ) visit(condiciones.get(i));

            SentenciaASTZ cuerpo
                    = construirCuerpoControl(
                            cuerpos.get(i)
                    );

            ramas.add(
                    new IfASTZ.RamaIf(
                            condicion,
                            cuerpo
                    )
            );
        }

        SentenciaASTZ cuerpoElse = null;

        if (cuerpos.size()
                > condiciones.size()) {

            cuerpoElse
                    = construirCuerpoControl(
                            cuerpos.get(
                                    cuerpos.size() - 1
                            )
                    );
        }

        return new IfASTZ(
                ramas,
                cuerpoElse,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitSentenciaWhile(
            ZParser.SentenciaWhileContext ctx) {

        ExpresionASTZ condicion
                = (ExpresionASTZ) visit(ctx.expresion());

        SentenciaASTZ cuerpo
                = construirCuerpoControl(
                        ctx.cuerpoControl()
                );

        return new WhileASTZ(
                condicion,
                cuerpo,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitSentenciaDoWhile(
            ZParser.SentenciaDoWhileContext ctx) {

        SentenciaASTZ cuerpo
                = construirCuerpoControl(
                        ctx.cuerpoControl()
                );

        ExpresionASTZ condicion
                = (ExpresionASTZ) visit(ctx.expresion());

        return new DoWhileASTZ(
                cuerpo,
                condicion,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitSentenciaFor(
            ZParser.SentenciaForContext ctx) {

        NodoASTZ inicializacion = null;
        ExpresionASTZ condicion = null;
        NodoASTZ actualizacion = null;

        if (ctx.inicializacionFor() != null) {
            inicializacion
                    = visit(ctx.inicializacionFor());
        }

        if (ctx.expresion() != null) {
            condicion
                    = (ExpresionASTZ) visit(ctx.expresion());
        }

        if (ctx.actualizacionFor() != null) {
            actualizacion
                    = visit(ctx.actualizacionFor());
        }

        SentenciaASTZ cuerpo
                = construirCuerpoControl(
                        ctx.cuerpoControl()
                );

        return new ForASTZ(
                inicializacion,
                condicion,
                actualizacion,
                cuerpo,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitInicializacionFor(
            ZParser.InicializacionForContext ctx) {

        if (ctx.tipo() != null) {

            String tipo
                    = ctx.tipo().getText();

            String nombre
                    = ctx.IDENTIFICADOR().getText();

            ExpresionASTZ valor
                    = (ExpresionASTZ) visit(ctx.expresion());

            return new DeclaracionASTZ(
                    nombre,
                    tipo,
                    0,
                    valor,
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine()
            );
        }

        ExpresionASTZ destino
                = (ExpresionASTZ) visit(ctx.acceso());

        ExpresionASTZ valor
                = (ExpresionASTZ) visit(ctx.expresion());

        return new AsignacionASTZ(
                destino,
                ctx.operadorAsignacion().getText(),
                valor,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitActualizacionFor(
            ZParser.ActualizacionForContext ctx) {

        ExpresionASTZ destino
                = (ExpresionASTZ) visit(ctx.acceso());

        if (ctx.INCREMENTO() != null) {

            return new IncrementoDecrementoASTZ(
                    destino,
                    "++",
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine()
            );
        }

        if (ctx.DECREMENTO() != null) {

            return new IncrementoDecrementoASTZ(
                    destino,
                    "--",
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine()
            );
        }

        ExpresionASTZ valor
                = (ExpresionASTZ) visit(ctx.expresion());

        return new AsignacionASTZ(
                destino,
                ctx.operadorAsignacion().getText(),
                valor,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    @Override
    public NodoASTZ visitSentenciaSwitch(
            ZParser.SentenciaSwitchContext ctx) {

        ExpresionASTZ expresion
                = (ExpresionASTZ) visit(ctx.expresion());

        List<CasoSwitchASTZ> casos
                = new ArrayList<>();

        for (ZParser.BloqueCaseContext caso
                : ctx.bloqueCase()) {

            ExpresionASTZ valor
                    = (ExpresionASTZ) visit(caso.expresion());

            List<SentenciaASTZ> sentencias
                    = new ArrayList<>();

            for (ZParser.SentenciaContext sentencia
                    : caso.sentencia()) {

                NodoASTZ nodo
                        = visit(sentencia);

                if (nodo instanceof SentenciaASTZ sentenciaAST) {
                    sentencias.add(sentenciaAST);
                }
            }

            casos.add(
                    new CasoSwitchASTZ(
                            valor,
                            sentencias,
                            caso.getStart().getLine(),
                            caso.getStart()
                                    .getCharPositionInLine()
                    )
            );
        }

        List<SentenciaASTZ> defecto
                = new ArrayList<>();

        if (ctx.bloqueDefault() != null) {

            for (ZParser.SentenciaContext sentencia
                    : ctx.bloqueDefault().sentencia()) {

                NodoASTZ nodo
                        = visit(sentencia);

                if (nodo instanceof SentenciaASTZ sentenciaAST) {
                    defecto.add(sentenciaAST);
                }
            }
        }

        return new SwitchASTZ(
                expresion,
                casos,
                defecto,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    private ExpresionASTZ construirInicializador(
            ZParser.InicializadorContext ctx) {

        if (ctx == null) {
            return null;
        }

        if (ctx.expresion() != null) {
            return (ExpresionASTZ) visit(ctx.expresion());
        }

        if (ctx.inicializadorLista() != null) {
            return (ExpresionASTZ) visit(ctx.inicializadorLista());
        }

        return null;
    }

    private List<ExpresionASTZ> construirArgumentos(
            ZParser.ListaArgumentosContext ctx) {

        List<ExpresionASTZ> argumentos
                = new ArrayList<>();

        if (ctx == null) {
            return argumentos;
        }

        for (ZParser.ExpresionContext expresion
                : ctx.expresion()) {

            NodoASTZ nodo
                    = visit(expresion);

            if (nodo instanceof ExpresionASTZ expresionAST) {
                argumentos.add(expresionAST);
            }
        }

        return argumentos;
    }

    private SentenciaASTZ construirCuerpoControl(
            ZParser.CuerpoControlContext ctx) {

        if (ctx == null) {
            return null;
        }

        if (ctx.bloque() != null) {
            return (SentenciaASTZ) visit(ctx.bloque());
        }

        if (ctx.sentencia() != null) {
            return (SentenciaASTZ) visit(ctx.sentencia());
        }

        return null;
    }
}
