package elmer.compi2.zetariano.parser.piglatin;

import elmer.compi2.zetariano.core.node.*;
import elmer.compi2.zetariano.core.node.piglatin.*;
/*
 */
import elmer.compi2.zetariano.core.node.*;
import elmer.compi2.zetariano.core.node.piglatin.*;

import java.util.ArrayList;
import java.util.List;
import elmer.compi2.zetariano.antlr.piglatin.PigLatinParser;
import elmer.compi2.zetariano.antlr.piglatin.PigLatinParserBaseVisitor;

/**
 *
 */
public class PigTreeBuilder
        extends PigLatinParserBaseVisitor<NodoASTPig> {

    // =========================================================
    // PROGRAMA
    // =========================================================
    @Override
    public NodoASTPig visitPrograma(
            PigLatinParser.ProgramaContext ctx) {

        ProgramaASTPig programa
                = new ProgramaASTPig(
                        linea(ctx),
                        columna(ctx)
                );

        // =====================================================
        // IMPORTS
        // =====================================================
        for (PigLatinParser.ImportacionContext importacion
                : ctx.importacion()) {

            ImportASTPig nodo
                    = construirImport(
                            importacion
                    );

            programa.agregarImport(
                    nodo
            );
        }

        // =====================================================
        // VARIABLES GLOBALES
        // =====================================================
        if (ctx.seccionVariables() != null) {

            for (PigLatinParser.DeclaracionGlobalContext global
                    : ctx.seccionVariables()
                            .declaracionGlobal()) {

                SentenciaASTPig sentencia
                        = construirDeclaracionGlobal(
                                global
                        );

                programa.agregarVariableGlobal(
                        sentencia
                );
            }
        }

        // =====================================================
        // MAIOR
        // =====================================================
        if (ctx.seccionPrincipal() != null) {

            for (PigLatinParser.SentenciaContext sentencia
                    : ctx.seccionPrincipal()
                            .sentencia()) {

                List<SentenciaASTPig> generadas
                        = construirSentencias(
                                sentencia
                        );

                for (SentenciaASTPig nodo
                        : generadas) {

                    programa.agregarSentenciaPrincipal(
                            nodo
                    );
                }
            }
        }

        return programa;
    }

    // =========================================================
    // IMPORT
    // =========================================================
    private ImportASTPig construirImport(
            PigLatinParser.ImportacionContext ctx) {

        String texto
                = ctx.rutaImportacion()
                        .getText();

        String ruta = texto;
        String extension = "";

        int ultimoPunto
                = texto.lastIndexOf('.');

        if (ultimoPunto >= 0) {

            ruta = texto.substring(
                    0,
                    ultimoPunto
            );

            extension = texto.substring(
                    ultimoPunto
            );
        }

        return new ImportASTPig(
                ruta,
                extension,
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // DECLARACION GLOBAL
    // =========================================================
    private SentenciaASTPig construirDeclaracionGlobal(
            PigLatinParser.DeclaracionGlobalContext ctx) {

        if (ctx.declaracionVariable() != null) {

            return construirDeclaracionVariable(
                    ctx.declaracionVariable()
            );
        }

        if (ctx.declaracionArreglo() != null) {

            return construirDeclaracionArreglo(
                    ctx.declaracionArreglo()
            );
        }

        return null;
    }

    // =========================================================
    // SENTENCIAS
    // =========================================================

    /*
     * Retornamos una lista porque una sola regla "escritura"
     * puede contener:
     *
     * >> a >> b >> c;
     *
     * y queremos representarla como tres nodos AST.
     */
    private List<SentenciaASTPig> construirSentencias(
            PigLatinParser.SentenciaContext ctx) {

        List<SentenciaASTPig> resultado
                = new ArrayList<>();

        if (ctx == null) {
            return resultado;
        }

        // -----------------------------------------------------
        // DECLARACION VARIABLE
        // -----------------------------------------------------
        if (ctx.declaracionVariable() != null) {

            resultado.add(
                    construirDeclaracionVariable(
                            ctx.declaracionVariable()
                    )
            );

            return resultado;
        }

        // -----------------------------------------------------
        // DECLARACION ARREGLO
        // -----------------------------------------------------
        if (ctx.declaracionArreglo() != null) {

            resultado.add(
                    construirDeclaracionArreglo(
                            ctx.declaracionArreglo()
                    )
            );

            return resultado;
        }

        // -----------------------------------------------------
        // ASIGNACION
        // -----------------------------------------------------
        if (ctx.asignacion() != null) {

            resultado.add(
                    construirAsignacion(
                            ctx.asignacion()
                    )
            );

            return resultado;
        }

        // -----------------------------------------------------
        // ++ / --
        // -----------------------------------------------------
        if (ctx.incrementoDecremento() != null) {

            resultado.add(
                    construirIncrementoDecremento(
                            ctx.incrementoDecremento()
                    )
            );

            return resultado;
        }

        // -----------------------------------------------------
        // LLAMADA COMO SENTENCIA
        // -----------------------------------------------------
        if (ctx.llamadaSentencia() != null) {

            ExpresionASTPig llamada
                    = construirLlamada(
                            ctx.llamadaSentencia()
                                    .llamada()
                    );

            resultado.add(
                    new ExpresionSentenciaASTPig(
                            llamada,
                            linea(ctx),
                            columna(ctx)
                    )
            );

            return resultado;
        }

        // -----------------------------------------------------
        // LECTURA
        // -----------------------------------------------------
        if (ctx.lectura() != null) {

            PigLatinParser.LecturaContext lectura
                    = ctx.lectura();

            AccesoASTPig destino = null;

            if (lectura.acceso() != null) {

                destino
                        = construirAcceso(
                                lectura.acceso()
                        );
            }

            resultado.add(
                    new LecturaASTPig(
                            destino,
                            linea(lectura),
                            columna(lectura)
                    )
            );

            return resultado;
        }

        // -----------------------------------------------------
        // ESCRITURA
        // -----------------------------------------------------
        if (ctx.escritura() != null) {

            PigLatinParser.EscrituraContext escritura
                    = ctx.escritura();

            for (PigLatinParser.ExpresionContext expresion
                    : escritura.expresion()) {

                resultado.add(
                        new EscrituraASTPig(
                                construirExpresion(
                                        expresion
                                ),
                                linea(escritura),
                                columna(escritura)
                        )
                );
            }

            return resultado;
        }

        // -----------------------------------------------------
        // IF
        // -----------------------------------------------------
        if (ctx.sentenciaSi() != null) {

            resultado.add(
                    construirIf(
                            ctx.sentenciaSi()
                    )
            );

            return resultado;
        }

        // -----------------------------------------------------
        // WHILE
        // -----------------------------------------------------
        if (ctx.sentenciaDum() != null) {

            resultado.add(
                    construirWhile(
                            ctx.sentenciaDum()
                    )
            );

            return resultado;
        }

        // -----------------------------------------------------
        // DO WHILE
        // -----------------------------------------------------
        if (ctx.sentenciaFacere() != null) {

            resultado.add(
                    construirDoWhile(
                            ctx.sentenciaFacere()
                    )
            );

            return resultado;
        }

        // -----------------------------------------------------
        // FOR
        // -----------------------------------------------------
        if (ctx.sentenciaPer() != null) {

            resultado.add(
                    construirFor(
                            ctx.sentenciaPer()
                    )
            );

            return resultado;
        }

        // -----------------------------------------------------
        // CONTINUE
        // -----------------------------------------------------
        if (ctx.PERGE() != null) {

            resultado.add(
                    new ContinueASTPig(
                            linea(ctx),
                            columna(ctx)
                    )
            );

            return resultado;
        }

        // -----------------------------------------------------
        // BREAK
        // -----------------------------------------------------
        if (ctx.INTERRUMPE() != null) {

            resultado.add(
                    new BreakASTPig(
                            linea(ctx),
                            columna(ctx)
                    )
            );
        }

        return resultado;
    }

    // =========================================================
    // DECLARACION VARIABLE
    // =========================================================
    private DeclaracionASTPig construirDeclaracionVariable(
            PigLatinParser.DeclaracionVariableContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR()
                        .getText();

        String tipo
                = ctx.tipo()
                        .getText();

        String tipoReferencia
                = ctx.tipo().IDENTIFICADOR() != null
                ? ctx.tipo()
                        .IDENTIFICADOR()
                        .getText()
                : null;

        ExpresionASTPig inicializador
                = null;

        if (ctx.inicializacionVariable() != null) {

            PigLatinParser.InicializacionVariableContext inicializacion
                    = ctx.inicializacionVariable();

            if (inicializacion.expresion() != null) {

                inicializador
                        = construirExpresion(
                                inicializacion.expresion()
                        );

            } else if (inicializacion.inicializadorEstructura()
                    != null) {

                inicializador
                        = construirInicializadorEstructura(
                                inicializacion
                                        .inicializadorEstructura()
                        );
            }
        }

        return new DeclaracionASTPig(
                nombre,
                tipo,
                tipoReferencia,
                List.of(),
                inicializador,
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // DECLARACION ARREGLO
    // =========================================================
    private DeclaracionASTPig construirDeclaracionArreglo(
            PigLatinParser.DeclaracionArregloContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR()
                        .getText();

        String tipo
                = ctx.tipo()
                        .getText();

        String tipoReferencia
                = ctx.tipo().IDENTIFICADOR() != null
                ? ctx.tipo()
                        .IDENTIFICADOR()
                        .getText()
                : null;

        List<Integer> dimensiones
                = new ArrayList<>();

        for (PigLatinParser.DimensionDeclaracionContext dimension
                : ctx.dimensionesDeclaracion()
                        .dimensionDeclaracion()) {

            try {

                dimensiones.add(
                        Integer.parseInt(
                                dimension.ENTERO()
                                        .getText()
                        )
                );

            } catch (NumberFormatException ex) {

                dimensiones.add(
                        0
                );
            }
        }

        ExpresionASTPig inicializador
                = null;

        if (ctx.inicializadorArreglo() != null) {

            inicializador
                    = construirInicializadorLista(
                            ctx.inicializadorArreglo()
                                    .inicializadorLista()
                    );
        }

        return new DeclaracionASTPig(
                nombre,
                tipo,
                tipoReferencia,
                dimensiones,
                inicializador,
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // ASIGNACION
    // =========================================================
    private AsignacionASTPig construirAsignacion(
            PigLatinParser.AsignacionContext ctx) {

        return new AsignacionASTPig(
                construirAcceso(
                        ctx.acceso()
                ),
                "=",
                construirExpresion(
                        ctx.expresion()
                ),
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // INCREMENTO / DECREMENTO
    // =========================================================
    private IncrementoDecrementoASTPig
            construirIncrementoDecremento(
                    PigLatinParser.IncrementoDecrementoContext ctx) {

        String operador
                = ctx.INCREMENTO() != null
                ? "++"
                : "--";

        return new IncrementoDecrementoASTPig(
                construirAcceso(
                        ctx.acceso()
                ),
                operador,
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // BLOQUE
    // =========================================================
    private BloqueASTPig construirBloque(
            PigLatinParser.BloqueContext ctx) {

        BloqueASTPig bloque
                = new BloqueASTPig(
                        linea(ctx),
                        columna(ctx)
                );

        for (PigLatinParser.SentenciaContext sentencia
                : ctx.sentencia()) {

            List<SentenciaASTPig> generadas
                    = construirSentencias(
                            sentencia
                    );

            for (SentenciaASTPig generada
                    : generadas) {

                bloque.agregarSentencia(
                        generada
                );
            }
        }

        return bloque;
    }

    // =========================================================
    // IF / ELSE IF / ELSE
    // =========================================================
    private IfASTPig construirIf(
            PigLatinParser.SentenciaSiContext ctx) {

        List<PigLatinParser.ExpresionContext> condiciones
                = ctx.expresion();

        List<PigLatinParser.BloqueContext> bloques
                = ctx.bloque();

        /*
         * Si hay un bloque más que condiciones,
         * el último bloque corresponde al ELSE.
         */
        BloqueASTPig bloqueElse
                = null;

        if (bloques.size()
                > condiciones.size()) {

            bloqueElse
                    = construirBloque(
                            bloques.get(
                                    bloques.size() - 1
                            )
                    );
        }

        /*
         * Construimos los ALITER(condicion) desde atrás
         * para convertirlos en IF anidados.
         */
        for (int i = condiciones.size() - 1;
                i >= 1;
                i--) {

            ExpresionASTPig condicion
                    = construirExpresion(
                            condiciones.get(i)
                    );

            BloqueASTPig verdadero
                    = construirBloque(
                            bloques.get(i)
                    );

            IfASTPig ifAnidado
                    = new IfASTPig(
                            condicion,
                            verdadero,
                            bloqueElse,
                            linea(condiciones.get(i)),
                            columna(condiciones.get(i))
                    );

            BloqueASTPig contenedor
                    = new BloqueASTPig(
                            linea(condiciones.get(i)),
                            columna(condiciones.get(i))
                    );

            contenedor.agregarSentencia(
                    ifAnidado
            );

            bloqueElse
                    = contenedor;
        }

        return new IfASTPig(
                construirExpresion(
                        condiciones.get(0)
                ),
                construirBloque(
                        bloques.get(0)
                ),
                bloqueElse,
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // WHILE
    // =========================================================
    private WhileASTPig construirWhile(
            PigLatinParser.SentenciaDumContext ctx) {

        return new WhileASTPig(
                construirExpresion(
                        ctx.expresion()
                ),
                construirBloque(
                        ctx.bloque()
                ),
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // DO WHILE
    // =========================================================
    private DoWhileASTPig construirDoWhile(
            PigLatinParser.SentenciaFacereContext ctx) {

        return new DoWhileASTPig(
                construirBloque(
                        ctx.bloque()
                ),
                construirExpresion(
                        ctx.expresion()
                ),
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // FOR
    // =========================================================
    private ForASTPig construirFor(
            PigLatinParser.SentenciaPerContext ctx) {

        SentenciaASTPig inicializacion
                = construirInicializacionFor(
                        ctx.inicializacionPer()
                );

        ExpresionASTPig condicion
                = construirExpresion(
                        ctx.expresion()
                );

        SentenciaASTPig actualizacion
                = construirActualizacionFor(
                        ctx.actualizacionPer()
                );

        BloqueASTPig cuerpo
                = construirBloque(
                        ctx.bloque()
                );

        return new ForASTPig(
                inicializacion,
                condicion,
                actualizacion,
                cuerpo,
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // FOR - INICIALIZACION
    // =========================================================
    private SentenciaASTPig construirInicializacionFor(
            PigLatinParser.InicializacionPerContext ctx) {

        if (ctx.ESTO() != null) {

            String tipo
                    = ctx.tipo()
                            .getText();

            String tipoReferencia
                    = ctx.tipo()
                            .IDENTIFICADOR() != null
                            ? ctx.tipo()
                                    .IDENTIFICADOR()
                                    .getText()
                            : null;

            return new DeclaracionASTPig(
                    ctx.IDENTIFICADOR()
                            .getText(),
                    tipo,
                    tipoReferencia,
                    List.of(),
                    construirExpresion(
                            ctx.expresion()
                    ),
                    linea(ctx),
                    columna(ctx)
            );
        }

        return new AsignacionASTPig(
                construirAcceso(
                        ctx.acceso()
                ),
                "=",
                construirExpresion(
                        ctx.expresion()
                ),
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // FOR - ACTUALIZACION
    // =========================================================
    private SentenciaASTPig construirActualizacionFor(
            PigLatinParser.ActualizacionPerContext ctx) {

        AccesoASTPig acceso
                = construirAcceso(
                        ctx.acceso()
                );

        if (ctx.INCREMENTO() != null) {

            return new IncrementoDecrementoASTPig(
                    acceso,
                    "++",
                    linea(ctx),
                    columna(ctx)
            );
        }

        if (ctx.DECREMENTO() != null) {

            return new IncrementoDecrementoASTPig(
                    acceso,
                    "--",
                    linea(ctx),
                    columna(ctx)
            );
        }

        return new AsignacionASTPig(
                acceso,
                "=",
                construirExpresion(
                        ctx.expresion()
                ),
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // ACCESO
    // =========================================================
    private AccesoASTPig construirAcceso(
            PigLatinParser.AccesoContext ctx) {

        AccesoASTPig acceso
                = new AccesoASTPig(
                        ctx.IDENTIFICADOR()
                                .getText(),
                        linea(ctx),
                        columna(ctx)
                );

        for (PigLatinParser.SufijoAccesoContext sufijo
                : ctx.sufijoAcceso()) {

            // -------------------------------------------------
            // [indice]
            // -------------------------------------------------
            if (sufijo.CORCHETE_IZQ() != null) {

                acceso.agregarPaso(
                        PasoAccesoASTPig.indice(
                                construirExpresion(
                                        sufijo.expresion()
                                )
                        )
                );

                continue;
            }

            // -------------------------------------------------
            // .metodo(...)
            // -------------------------------------------------
            if (sufijo.PARENTESIS_IZQ() != null) {

                List<ExpresionASTPig> argumentos
                        = construirArgumentos(
                                sufijo.listaArgumentos()
                        );

                acceso.agregarPaso(
                        PasoAccesoASTPig.llamada(
                                sufijo.IDENTIFICADOR()
                                        .getText(),
                                argumentos
                        )
                );

                continue;
            }

            // -------------------------------------------------
            // .atributo
            // -------------------------------------------------
            acceso.agregarPaso(
                    PasoAccesoASTPig.atributo(
                            sufijo.IDENTIFICADOR()
                                    .getText()
                    )
            );
        }

        return acceso;
    }

    // =========================================================
    // LLAMADA
    // =========================================================
    private ExpresionASTPig construirLlamada(
            PigLatinParser.LlamadaContext ctx) {

        /*
         * Segunda alternativa:
         *
         * llamada : acceso
         */
        if (ctx.acceso() != null) {

            return construirAcceso(
                    ctx.acceso()
            );
        }

        /*
         * Primera alternativa:
         *
         * IDENTIFICADOR(...)
         */
        LlamadaASTPig llamada
                = new LlamadaASTPig(
                        null,
                        ctx.IDENTIFICADOR()
                                .getText(),
                        linea(ctx),
                        columna(ctx)
                );

        for (ExpresionASTPig argumento
                : construirArgumentos(
                        ctx.listaArgumentos()
                )) {

            llamada.agregarArgumento(
                    argumento
            );
        }

        return llamada;
    }

    // =========================================================
    // ARGUMENTOS
    // =========================================================
    private List<ExpresionASTPig> construirArgumentos(
            PigLatinParser.ListaArgumentosContext ctx) {

        List<ExpresionASTPig> argumentos
                = new ArrayList<>();

        if (ctx == null) {
            return argumentos;
        }

        for (PigLatinParser.ExpresionContext expresion
                : ctx.expresion()) {

            argumentos.add(
                    construirExpresion(
                            expresion
                    )
            );
        }

        return argumentos;
    }

    // =========================================================
    // NOVUS
    // =========================================================
    private NuevoObjetoASTPig construirNuevoObjeto(
            PigLatinParser.CreacionObjetoContext ctx) {

        NuevoObjetoASTPig nuevo
                = new NuevoObjetoASTPig(
                        ctx.IDENTIFICADOR()
                                .getText(),
                        linea(ctx),
                        columna(ctx)
                );

        for (ExpresionASTPig argumento
                : construirArgumentos(
                        ctx.listaArgumentos()
                )) {

            nuevo.agregarArgumento(
                    argumento
            );
        }

        return nuevo;
    }

    // =========================================================
    // INICIALIZADOR ESTRUCTURA
    // =========================================================
    private InicializadorListaASTPig
            construirInicializadorEstructura(
                    PigLatinParser.InicializadorEstructuraContext ctx) {

        InicializadorListaASTPig lista
                = new InicializadorListaASTPig(
                        linea(ctx),
                        columna(ctx)
                );

        if (ctx.listaInicializacion() != null) {

            agregarValoresInicializacion(
                    lista,
                    ctx.listaInicializacion()
            );
        }

        return lista;
    }

    // =========================================================
    // INICIALIZADOR ARREGLO
    // =========================================================
    private InicializadorListaASTPig
            construirInicializadorLista(
                    PigLatinParser.InicializadorListaContext ctx) {

        InicializadorListaASTPig lista
                = new InicializadorListaASTPig(
                        linea(ctx),
                        columna(ctx)
                );

        if (ctx.listaInicializacion() != null) {

            agregarValoresInicializacion(
                    lista,
                    ctx.listaInicializacion()
            );
        }

        return lista;
    }

    private void agregarValoresInicializacion(
            InicializadorListaASTPig destino,
            PigLatinParser.ListaInicializacionContext ctx) {

        for (PigLatinParser.ValorInicializacionContext valor
                : ctx.valorInicializacion()) {

            if (valor.expresion() != null) {

                destino.agregarValor(
                        construirExpresion(
                                valor.expresion()
                        )
                );

            } else if (valor.inicializadorLista() != null) {

                destino.agregarValor(
                        construirInicializadorLista(
                                valor.inicializadorLista()
                        )
                );
            }
        }
    }

    // =========================================================
    // EXPRESION
    // =========================================================
    private ExpresionASTPig construirExpresion(
            PigLatinParser.ExpresionContext ctx) {

        if (ctx == null) {
            return null;
        }

        return construirOr(
                ctx.expresionOr()
        );
    }

    // =========================================================
    // OR
    // =========================================================
    private ExpresionASTPig construirOr(
            PigLatinParser.ExpresionOrContext ctx) {

        if (ctx.expresionOr() == null) {

            return construirAnd(
                    ctx.expresionAnd()
            );
        }

        return new BinariaASTPig(
                "||",
                construirOr(
                        ctx.expresionOr()
                ),
                construirAnd(
                        ctx.expresionAnd()
                ),
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // AND
    // =========================================================
    private ExpresionASTPig construirAnd(
            PigLatinParser.ExpresionAndContext ctx) {

        if (ctx.expresionAnd() == null) {

            return construirIgualdad(
                    ctx.expresionIgualdad()
            );
        }

        return new BinariaASTPig(
                "&&",
                construirAnd(
                        ctx.expresionAnd()
                ),
                construirIgualdad(
                        ctx.expresionIgualdad()
                ),
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // == / !=
    // =========================================================
    private ExpresionASTPig construirIgualdad(
            PigLatinParser.ExpresionIgualdadContext ctx) {

        if (ctx.expresionIgualdad() == null) {

            return construirRelacional(
                    ctx.expresionRelacional()
            );
        }

        String operador
                = ctx.getChild(1)
                        .getText();

        return new BinariaASTPig(
                operador,
                construirIgualdad(
                        ctx.expresionIgualdad()
                ),
                construirRelacional(
                        ctx.expresionRelacional()
                ),
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // < > <= >=
    // =========================================================
    private ExpresionASTPig construirRelacional(
            PigLatinParser.ExpresionRelacionalContext ctx) {

        if (ctx.expresionRelacional() == null) {

            return construirAditiva(
                    ctx.expresionAditiva()
            );
        }

        String operador
                = ctx.getChild(1)
                        .getText();

        return new BinariaASTPig(
                operador,
                construirRelacional(
                        ctx.expresionRelacional()
                ),
                construirAditiva(
                        ctx.expresionAditiva()
                ),
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // + / -
    // =========================================================
    private ExpresionASTPig construirAditiva(
            PigLatinParser.ExpresionAditivaContext ctx) {

        if (ctx.expresionAditiva() == null) {

            return construirMultiplicativa(
                    ctx.expresionMultiplicativa()
            );
        }

        String operador
                = ctx.getChild(1)
                        .getText();

        return new BinariaASTPig(
                operador,
                construirAditiva(
                        ctx.expresionAditiva()
                ),
                construirMultiplicativa(
                        ctx.expresionMultiplicativa()
                ),
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // * / %
    // =========================================================
    private ExpresionASTPig construirMultiplicativa(
            PigLatinParser.ExpresionMultiplicativaContext ctx) {

        if (ctx.expresionMultiplicativa() == null) {

            return construirUnaria(
                    ctx.expresionUnaria()
            );
        }

        String operador
                = ctx.getChild(1)
                        .getText();

        return new BinariaASTPig(
                operador,
                construirMultiplicativa(
                        ctx.expresionMultiplicativa()
                ),
                construirUnaria(
                        ctx.expresionUnaria()
                ),
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // UNARIA
    // =========================================================
    private ExpresionASTPig construirUnaria(
            PigLatinParser.ExpresionUnariaContext ctx) {

        if (ctx.primario() != null) {

            return construirPrimario(
                    ctx.primario()
            );
        }

        String operador
                = ctx.getChild(0)
                        .getText();

        return new UnariaASTPig(
                operador,
                construirUnaria(
                        ctx.expresionUnaria()
                ),
                true,
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // PRIMARIO
    // =========================================================
    private ExpresionASTPig construirPrimario(
            PigLatinParser.PrimarioContext ctx) {

        if (ctx.literal() != null) {

            return construirLiteral(
                    ctx.literal()
            );
        }

        if (ctx.creacionObjeto() != null) {

            return construirNuevoObjeto(
                    ctx.creacionObjeto()
            );
        }

        if (ctx.llamada() != null) {

            return construirLlamada(
                    ctx.llamada()
            );
        }

        if (ctx.expresion() != null) {

            return construirExpresion(
                    ctx.expresion()
            );
        }

        return null;
    }

    // =========================================================
    // LITERAL
    // =========================================================
    private LiteralASTPig construirLiteral(
            PigLatinParser.LiteralContext ctx) {

        if (ctx.ENTERO() != null) {

            int valor;

            try {

                valor = Integer.parseInt(
                        ctx.ENTERO()
                                .getText()
                );

            } catch (NumberFormatException ex) {

                valor = 0;
            }

            return new LiteralASTPig(
                    valor,
                    "numerus",
                    linea(ctx),
                    columna(ctx)
            );
        }

        if (ctx.DECIMAL() != null) {

            double valor;

            try {

                valor = Double.parseDouble(
                        ctx.DECIMAL()
                                .getText()
                );

            } catch (NumberFormatException ex) {

                valor = 0.0;
            }

            return new LiteralASTPig(
                    valor,
                    "decimalis",
                    linea(ctx),
                    columna(ctx)
            );
        }

        if (ctx.CADENA() != null) {

            return new LiteralASTPig(
                    quitarComillasDobles(
                            ctx.CADENA()
                                    .getText()
                    ),
                    "textum",
                    linea(ctx),
                    columna(ctx)
            );
        }

        if (ctx.CARACTER() != null) {

            String texto
                    = ctx.CARACTER()
                            .getText();

            String valor
                    = quitarComillasSimples(
                            texto
                    );

            return new LiteralASTPig(
                    valor,
                    "littera",
                    linea(ctx),
                    columna(ctx)
            );
        }

        if (ctx.VERUM() != null) {

            return new LiteralASTPig(
                    true,
                    "verum",
                    linea(ctx),
                    columna(ctx)
            );
        }

        return new LiteralASTPig(
                false,
                "verum",
                linea(ctx),
                columna(ctx)
        );
    }

    // =========================================================
    // UTILIDADES
    // =========================================================
    private int linea(
            org.antlr.v4.runtime.ParserRuleContext ctx) {

        if (ctx == null
                || ctx.getStart() == null) {

            return 0;
        }

        return ctx.getStart()
                .getLine();
    }

    private int columna(
            org.antlr.v4.runtime.ParserRuleContext ctx) {

        if (ctx == null
                || ctx.getStart() == null) {

            return 0;
        }

        return ctx.getStart()
                .getCharPositionInLine();
    }

    private String quitarComillasDobles(
            String texto) {

        if (texto == null
                || texto.length() < 2) {

            return texto;
        }

        if (texto.startsWith("\"")
                && texto.endsWith("\"")) {

            return texto.substring(
                    1,
                    texto.length() - 1
            );
        }

        return texto;
    }

    private String quitarComillasSimples(
            String texto) {

        if (texto == null
                || texto.length() < 2) {

            return texto;
        }

        if (texto.startsWith("'")
                && texto.endsWith("'")) {

            return texto.substring(
                    1,
                    texto.length() - 1
            );
        }

        return texto;
    }
}
