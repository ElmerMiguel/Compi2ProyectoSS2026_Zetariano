/*
 */
package elmer.compi2.zetariano.analysis.semantic;

import elmer.compi2.zetariano.analysis.semantic.zeta.AtributoZ;
import elmer.compi2.zetariano.analysis.semantic.zeta.ClaseZ;
import elmer.compi2.zetariano.analysis.semantic.zeta.ConstructorZ;
import elmer.compi2.zetariano.analysis.semantic.zeta.MetodoZ;
import elmer.compi2.zetariano.analysis.semantic.zeta.ParametroZ;
import elmer.compi2.zetariano.analysis.semantic.zeta.ResultadoAccesoZ;
import elmer.compi2.zetariano.analysis.semantic.zeta.TablaClasesZ;
import elmer.compi2.zetariano.analysis.semantic.zeta.TablaVariablesZ;
import elmer.compi2.zetariano.analysis.semantic.zeta.VariableZ;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTree;
import elmer.compi2.zetariano.antlr.zeta.ZParser;
import elmer.compi2.zetariano.antlr.zeta.ZParserBaseVisitor;

/**
 *
 */
public class ZAnalyzer extends ZParserBaseVisitor<Void> {

    private ClaseZ claseActual;

    private final List<String> errores = new ArrayList<>();
    private final TablaVariablesZ tablaVariables
            = new TablaVariablesZ();

    private String tipoRetornoActual = null;
    private String nombreMetodoActual = null;

    private final TablaClasesZ tablaClases
            = new TablaClasesZ();

    private final Map<
        ZParser.ConstructorContext, List<ParametroZ>> parametrosConstructores
            = new IdentityHashMap<>();

    private final Map<
        ZParser.MetodoContext, List<ParametroZ>> parametrosMetodos
            = new IdentityHashMap<>();

    private int profundidadCiclo = 0;
    private int profundidadSwitch = 0;

    // =========================================================
    // ANALISIS PRINCIPAL
    // =========================================================
    public void analizar(ZParser.ProgramaContext ctx) {

        errores.clear();
        tablaClases.limpiar();

        parametrosConstructores.clear();
        parametrosMetodos.clear();

        profundidadCiclo = 0;
        profundidadSwitch = 0;

        claseActual = null;

        if (ctx != null) {
            visit(ctx);
        }
    }

    /**
     * Analiza otro archivo Z conservando las clases que ya fueron
     * analizadas por esta misma instancia. Se utiliza para resolver
     * dependencias entre archivos, por ejemplo Pila.z -> Nodo.z.
     */
    public void analizarAcumulando(ZParser.ProgramaContext ctx) {

        errores.clear();

        parametrosConstructores.clear();
        parametrosMetodos.clear();

        profundidadCiclo = 0;
        profundidadSwitch = 0;

        claseActual = null;

        if (ctx != null) {
            visit(ctx);
        }
    }

    public ClaseZ getClaseActual() {
        return claseActual;
    }

    public List<String> getErrores() {
        return new ArrayList<>(errores);
    }

    public boolean tieneErrores() {
        return !errores.isEmpty();
    }

    private void agregarError(int linea, int columna, String mensaje) {

        errores.add(
                "[SEMANTICO Z] Línea "
                + linea
                + ":"
                + columna
                + " -> "
                + mensaje
        );
    }

    // =========================================================
    // CLASE
    // =========================================================
    @Override
    public Void visitDefinicionClase(
            ZParser.DefinicionClaseContext ctx) {

        String nombreClase
                = ctx.IDENTIFICADOR().getText();

        claseActual
                = new ClaseZ(nombreClase);

        tablaClases.registrar(
                claseActual
        );

        for (ZParser.MiembroClaseContext miembro
                : ctx.miembroClase()) {

            if (miembro.atributo() != null) {

                registrarAtributo(
                        miembro.atributo()
                );

                continue;
            }

            if (miembro.constructor() != null) {

                registrarFirmaConstructor(
                        miembro.constructor()
                );

                continue;
            }

            if (miembro.metodo() != null) {

                registrarFirmaMetodo(
                        miembro.metodo()
                );
            }
        }

        for (ZParser.MiembroClaseContext miembro
                : ctx.miembroClase()) {

            if (miembro.atributo() != null) {

                analizarInicializadorAtributo(
                        miembro.atributo()
                );

                continue;
            }

            if (miembro.constructor() != null) {

                analizarConstructor(
                        miembro.constructor()
                );

                continue;
            }

            if (miembro.metodo() != null) {

                analizarMetodo(
                        miembro.metodo()
                );
            }
        }

        return null;
    }

    // =========================================================
    // ATRIBUTOS
    // =========================================================
    @Override
    public Void visitAtributo(
            ZParser.AtributoContext ctx) {

        registrarAtributo(ctx);

        return null;
    }

    // =========================================================
    // CONSTRUCTORES
    // =========================================================
    @Override
    public Void visitConstructor(
            ZParser.ConstructorContext ctx) {

        analizarConstructor(ctx);

        return null;
    }

    // =========================================================
    // METODOS
    // =========================================================
    @Override
    public Void visitMetodo(
            ZParser.MetodoContext ctx) {

        if (claseActual == null) {
            return null;
        }

        String nombreMetodo
                = ctx.IDENTIFICADOR().getText();

        String tipoRetorno
                = obtenerTipoRetorno(
                        ctx.tipoRetorno()
                );

        List<ParametroZ> parametros
                = obtenerParametros(
                        ctx.listaParametros(),
                        "método '" + nombreMetodo + "'"
                );

        MetodoZ metodo = new MetodoZ(
                nombreMetodo,
                tipoRetorno,
                parametros
        );

        if (!claseActual.registrarMetodo(metodo)) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "El método con firma '"
                    + metodo.obtenerFirma()
                    + "' ya fue declarado."
            );
        }

        String tipoRetornoAnterior = tipoRetornoActual;
        String nombreMetodoAnterior = nombreMetodoActual;

        tipoRetornoActual = tipoRetorno;
        nombreMetodoActual = nombreMetodo;

        tablaVariables.entrarAmbito();

        registrarParametrosEnAmbito(parametros);

        visitarBloqueSinCrearAmbito(
                ctx.bloque()
        );

        tablaVariables.salirAmbito();
        tipoRetornoActual = tipoRetornoAnterior;
        nombreMetodoActual = nombreMetodoAnterior;

        return null;
    }

    @Override
    public Void visitDeclaracionVariable(
            ZParser.DeclaracionVariableContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR().getText();

        String tipo
                = obtenerTipo(ctx.tipo());

        int dimensiones
                = ctx.dimensionesParametro().size()
                + ctx.dimensiones().size();

        VariableZ variable
                = new VariableZ(
                        nombre,
                        tipo,
                        dimensiones,
                        false
                );

        if (!tablaVariables.registrar(variable)) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "La variable local '"
                    + nombre
                    + "' ya fue declarada en este ámbito."
            );

            return null;
        }

        // =========================================================
        // SIN INICIALIZADOR
        // =========================================================
        if (ctx.inicializador() == null) {
            return null;
        }

        // =========================================================
        // INICIALIZADOR CON LISTA
        // =========================================================
        if (ctx.inicializador()
                .inicializadorLista() != null) {

            if (dimensiones == 0) {

                agregarError(
                        ctx.getStart().getLine(),
                        ctx.getStart().getCharPositionInLine(),
                        "La variable '"
                        + nombre
                        + "' no es un arreglo y no puede inicializarse mediante una lista."
                );

                return null;
            }

            validarInicializadorLista(
                    ctx.inicializador()
                            .inicializadorLista(),
                    tipo,
                    dimensiones,
                    nombre
            );

            return null;
        }

        // =========================================================
        // INICIALIZADOR CON EXPRESION
        // =========================================================
        if (ctx.inicializador()
                .expresion() == null) {

            return null;
        }

        ZParser.ExpresionContext expresion
                = ctx.inicializador()
                        .expresion();

        ResultadoAccesoZ origen
                = obtenerResultadoExpresionCompleto(
                        expresion
                );

        if (!origen.isValido()) {
            return null;
        }

        // =========================================================
        // VALIDACION COMPLETA:
        // tipo + dimensiones
        // =========================================================
        if (!tiposCompatiblesCompletos(
                tipo,
                dimensiones,
                origen.getTipo(),
                origen.getDimensiones())) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "No se puede inicializar '"
                    + nombre
                    + "' de tipo '"
                    + tipo
                    + "' con "
                    + dimensiones
                    + " dimensión(es) utilizando un valor de tipo '"
                    + origen.getTipo()
                    + "' con "
                    + origen.getDimensiones()
                    + " dimensión(es)."
            );
        }

        return null;
    }

    @Override
    public Void visitAsignacion(
            ZParser.AsignacionContext ctx) {

        ResultadoAccesoZ destino
                = resolverAcceso(
                        ctx.acceso()
                );

        validarAsignacionAcceso(
                destino,
                ctx.operadorAsignacion(),
                ctx.expresion(),
                ctx.getStart().getLine(),
                ctx.getStart().getCharPositionInLine()
        );

        return null;
    }

    @Override
    public Void visitBloque(
            ZParser.BloqueContext ctx) {

        tablaVariables.entrarAmbito();

        for (ZParser.SentenciaContext sentencia
                : ctx.sentencia()) {

            visit(sentencia);
        }

        tablaVariables.salirAmbito();

        return null;
    }

    @Override
    public Void visitSentenciaReturn(
            ZParser.SentenciaReturnContext ctx) {

        if (tipoRetornoActual == null) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "La sentencia return se encuentra fuera de un método o constructor."
            );

            return null;
        }

        boolean tieneExpresion
                = ctx.expresion() != null;

        // =========================================================
        // CONSTRUCTOR
        // =========================================================
        if (tipoRetornoActual.equals("constructor")) {

            if (tieneExpresion) {

                agregarError(
                        ctx.getStart().getLine(),
                        ctx.getStart().getCharPositionInLine(),
                        "Un constructor no puede retornar un valor."
                );
            }

            return null;
        }

        // =========================================================
        // VOID
        // =========================================================
        if (tipoRetornoActual.equals("void")) {

            if (tieneExpresion) {

                agregarError(
                        ctx.getStart().getLine(),
                        ctx.getStart().getCharPositionInLine(),
                        "El método '"
                        + nombreMetodoActual
                        + "' es void y no puede retornar un valor."
                );
            }

            return null;
        }

        // =========================================================
        // METODO CON RETORNO
        // =========================================================
        if (!tieneExpresion) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "El método '"
                    + nombreMetodoActual
                    + "' debe retornar un valor de tipo '"
                    + tipoRetornoActual
                    + "'."
            );

            return null;
        }

        String tipoValor
                = obtenerTipoExpresion(
                        ctx.expresion()
                );

        if (tipoValor.equals("desconocido")) {
            return null;
        }

        if (!tiposCompatibles(
                tipoRetornoActual,
                tipoValor)) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "El método '"
                    + nombreMetodoActual
                    + "' debe retornar tipo '"
                    + tipoRetornoActual
                    + "', pero se encontró tipo '"
                    + tipoValor
                    + "'."
            );
        }

        return null;
    }

    @Override
    public Void visitSentenciaIf(
            ZParser.SentenciaIfContext ctx) {

        for (ZParser.ExpresionContext condicion
                : ctx.expresion()) {

            validarCondicion(
                    condicion,
                    condicion.getStart().getLine(),
                    condicion.getStart().getCharPositionInLine(),
                    "if"
            );
        }

        for (ZParser.CuerpoControlContext cuerpo
                : ctx.cuerpoControl()) {

            visit(cuerpo);
        }

        return null;
    }

    @Override
    public Void visitSentenciaWhile(
            ZParser.SentenciaWhileContext ctx) {

        validarCondicion(
                ctx.expresion(),
                ctx.getStart().getLine(),
                ctx.getStart().getCharPositionInLine(),
                "while"
        );

        profundidadCiclo++;

        visit(ctx.cuerpoControl());

        profundidadCiclo--;

        return null;
    }

    @Override
    public Void visitSentenciaDoWhile(
            ZParser.SentenciaDoWhileContext ctx) {

        profundidadCiclo++;

        visit(ctx.cuerpoControl());

        profundidadCiclo--;

        validarCondicion(
                ctx.expresion(),
                ctx.getStart().getLine(),
                ctx.getStart().getCharPositionInLine(),
                "do-while"
        );

        return null;
    }

    @Override
    public Void visitSentenciaFor(
            ZParser.SentenciaForContext ctx) {

        tablaVariables.entrarAmbito();

        if (ctx.inicializacionFor() != null) {
            visit(ctx.inicializacionFor());
        }

        if (ctx.expresion() != null) {

            validarCondicion(
                    ctx.expresion(),
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "for"
            );
        }

        if (ctx.actualizacionFor() != null) {
            visit(ctx.actualizacionFor());
        }

        profundidadCiclo++;

        visit(ctx.cuerpoControl());

        profundidadCiclo--;

        tablaVariables.salirAmbito();

        return null;
    }

    @Override
    public Void visitSentencia(
            ZParser.SentenciaContext ctx) {

        if (ctx.BREAK() != null) {

            if (profundidadCiclo <= 0
                    && profundidadSwitch <= 0) {

                agregarError(
                        ctx.getStart().getLine(),
                        ctx.getStart().getCharPositionInLine(),
                        "La sentencia break solo puede utilizarse dentro de un ciclo o switch."
                );
            }

            return null;
        }

        if (ctx.CONTINUE() != null) {

            if (profundidadCiclo <= 0) {

                agregarError(
                        ctx.getStart().getLine(),
                        ctx.getStart().getCharPositionInLine(),
                        "La sentencia continue solo puede utilizarse dentro de un ciclo."
                );
            }

            return null;
        }

        return visitChildren(ctx);
    }

    @Override
    public Void visitInicializacionFor(
            ZParser.InicializacionForContext ctx) {

        if (ctx.tipo() != null) {

            String nombre
                    = ctx.IDENTIFICADOR().getText();

            String tipo
                    = obtenerTipo(ctx.tipo());

            VariableZ variable
                    = new VariableZ(
                            nombre,
                            tipo,
                            0,
                            false
                    );

            if (!tablaVariables.registrar(variable)) {

                agregarError(
                        ctx.getStart().getLine(),
                        ctx.getStart().getCharPositionInLine(),
                        "La variable '"
                        + nombre
                        + "' ya fue declarada en este ámbito."
                );

                return null;
            }

            String tipoValor
                    = obtenerTipoExpresion(
                            ctx.expresion()
                    );

            if (!tipoValor.equals("desconocido")
                    && !tiposCompatibles(
                            tipo,
                            tipoValor)) {

                agregarError(
                        ctx.getStart().getLine(),
                        ctx.getStart().getCharPositionInLine(),
                        "No se puede inicializar la variable '"
                        + nombre
                        + "' de tipo '"
                        + tipo
                        + "' con tipo '"
                        + tipoValor
                        + "'."
                );
            }

            return null;
        }

        if (ctx.acceso() != null) {

            ResultadoAccesoZ destino
                    = resolverAcceso(
                            ctx.acceso()
                    );

            validarAsignacionAcceso(
                    destino,
                    ctx.operadorAsignacion(),
                    ctx.expresion(),
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine()
            );
        }

        return null;
    }

    @Override
    public Void visitActualizacionFor(
            ZParser.ActualizacionForContext ctx) {

        ResultadoAccesoZ destino
                = resolverAcceso(
                        ctx.acceso()
                );

        if (!destino.isValido()) {
            return null;
        }

        // =========================================================
        // ++
        // =========================================================
        if (ctx.INCREMENTO() != null) {

            validarIncrementoDecrementoFor(
                    destino,
                    ctx
            );

            return null;
        }

        // =========================================================
        // --
        // =========================================================
        if (ctx.DECREMENTO() != null) {

            validarIncrementoDecrementoFor(
                    destino,
                    ctx
            );

            return null;
        }

        // =========================================================
        // += -= *=
        // =========================================================
        if (ctx.operadorAsignacion() != null) {

            validarAsignacionAcceso(
                    destino,
                    ctx.operadorAsignacion(),
                    ctx.expresion(),
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine()
            );
        }

        return null;
    }

    @Override
    public Void visitSentenciaSwitch(
            ZParser.SentenciaSwitchContext ctx) {

        String tipoSwitch
                = obtenerTipoExpresion(
                        ctx.expresion()
                );

        profundidadSwitch++;

        Set<String> casosRegistrados
                = new HashSet<>();

        for (ZParser.BloqueCaseContext caso
                : ctx.bloqueCase()) {

            String tipoCase
                    = obtenerTipoExpresion(
                            caso.expresion()
                    );

            // =====================================================
            // VALIDAR TIPO DEL CASE
            // =====================================================
            if (!tipoSwitch.equals("desconocido")
                    && !tipoCase.equals("desconocido")
                    && !tiposCompatibles(
                            tipoSwitch,
                            tipoCase)
                    && !tiposCompatibles(
                            tipoCase,
                            tipoSwitch)) {

                agregarError(
                        caso.getStart().getLine(),
                        caso.getStart()
                                .getCharPositionInLine(),
                        "El tipo del case '"
                        + tipoCase
                        + "' no es compatible con el tipo del switch '"
                        + tipoSwitch
                        + "'."
                );
            }

            String claveCase
                    = tipoCase
                    + ":"
                    + caso.expresion().getText();

            if (!casosRegistrados.add(claveCase)) {

                agregarError(
                        caso.getStart().getLine(),
                        caso.getStart()
                                .getCharPositionInLine(),
                        "El valor del case '"
                        + caso.expresion().getText()
                        + "' ya fue declarado anteriormente en este switch."
                );
            }

            // =====================================================
            // VISITAR SENTENCIAS DEL CASE
            // =====================================================
            for (ZParser.SentenciaContext sentencia
                    : caso.sentencia()) {

                visit(sentencia);
            }
        }

        // =========================================================
        // DEFAULT
        // =========================================================
        if (ctx.bloqueDefault() != null) {

            for (ZParser.SentenciaContext sentencia
                    : ctx.bloqueDefault()
                            .sentencia()) {

                visit(sentencia);
            }
        }

        profundidadSwitch--;

        return null;
    }

    @Override
    public Void visitIncrementoDecremento(
            ZParser.IncrementoDecrementoContext ctx) {

        ResultadoAccesoZ resultado
                = resolverAcceso(
                        ctx.acceso()
                );

        if (!resultado.isValido()) {
            return null;
        }

        if (resultado.getDimensiones() > 0) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "No se puede aplicar ++ o -- directamente a un arreglo."
            );

            return null;
        }

        if (!esNumerico(
                resultado.getTipo())) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "El operador ++ o -- requiere un valor numérico, pero se encontró tipo '"
                    + resultado.getTipo()
                    + "'."
            );
        }

        return null;
    }

    @Override
    public Void visitLlamadaMetodoObjeto(
            ZParser.LlamadaMetodoObjetoContext ctx) {

        // =========================================================
        // 1. RESOLVER OBJETO BASE
        // =========================================================
        String nombreBase
                = ctx.IDENTIFICADOR(0).getText();

        VariableZ base
                = buscarVariable(nombreBase);

        if (base == null) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "La variable o atributo '"
                    + nombreBase
                    + "' no ha sido declarado."
            );

            return null;
        }

        String tipoActual
                = base.getTipo();

        int dimensionesActuales
                = base.getDimensiones();

        // =========================================================
        // 2. RECORRER SUFIJOS PREVIOS AL METODO
        // =========================================================
        for (ZParser.SufijoObjetoContext sufijo
                : ctx.sufijoObjeto()) {

            // -----------------------------------------------------
            // [expresion]
            // -----------------------------------------------------
            if (sufijo.CORCHETE_IZQ() != null) {

                if (dimensionesActuales <= 0) {

                    agregarError(
                            sufijo.getStart().getLine(),
                            sufijo.getStart()
                                    .getCharPositionInLine(),
                            "Se intenta indexar un valor que no es un arreglo."
                    );

                    return null;
                }

                String tipoIndice
                        = obtenerTipoExpresion(
                                sufijo.expresion()
                        );

                if (!tipoIndice.equals("desconocido")
                        && !tipoIndice.equals("int")) {

                    agregarError(
                            sufijo.getStart().getLine(),
                            sufijo.getStart()
                                    .getCharPositionInLine(),
                            "El índice de un arreglo debe ser de tipo int."
                    );
                }

                dimensionesActuales--;

                continue;
            }

            // -----------------------------------------------------
            // .atributo
            // -----------------------------------------------------
            if (sufijo.PUNTO() != null) {

                if (dimensionesActuales > 0) {

                    agregarError(
                            sufijo.getStart().getLine(),
                            sufijo.getStart()
                                    .getCharPositionInLine(),
                            "No se puede acceder a un atributo directamente sobre un arreglo."
                    );

                    return null;
                }

                ClaseZ clase
                        = tablaClases.buscar(
                                tipoActual
                        );

                if (clase == null) {

                    agregarError(
                            sufijo.getStart().getLine(),
                            sufijo.getStart()
                                    .getCharPositionInLine(),
                            "El tipo '"
                            + tipoActual
                            + "' no posee atributos."
                    );

                    return null;
                }

                String nombreAtributo
                        = sufijo.IDENTIFICADOR()
                                .getText();

                AtributoZ atributo
                        = clase.buscarAtributo(
                                nombreAtributo
                        );

                if (atributo == null) {

                    agregarError(
                            sufijo.getStart().getLine(),
                            sufijo.getStart()
                                    .getCharPositionInLine(),
                            "La clase '"
                            + tipoActual
                            + "' no contiene el atributo '"
                            + nombreAtributo
                            + "'."
                    );

                    return null;
                }

                tipoActual
                        = atributo.getTipo();

                dimensionesActuales
                        = atributo.getDimensiones();
            }
        }

        // =========================================================
        // 3. DESPUES DE LOS SUFIJOS DEBE QUEDAR UN OBJETO
        // =========================================================
        if (dimensionesActuales > 0) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "No se puede invocar un método directamente sobre un arreglo."
            );

            return null;
        }

        ClaseZ claseMetodo
                = tablaClases.buscar(
                        tipoActual
                );

        if (claseMetodo == null) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "El tipo '"
                    + tipoActual
                    + "' no posee métodos."
            );

            return null;
        }

        // =========================================================
        // 4. METODO FINAL
        // =========================================================
        String nombreMetodo
                = ctx.IDENTIFICADOR(
                        ctx.IDENTIFICADOR().size() - 1
                ).getText();

        // =========================================================
        // 5. ARGUMENTOS
        // =========================================================
        List<ResultadoAccesoZ> argumentos
                = obtenerArgumentosCompletos(
                        ctx.listaArgumentos()
                );

        MetodoZ metodo
                = buscarMetodoCompatible(
                        claseMetodo,
                        nombreMetodo,
                        argumentos
                );

        if (metodo == null) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "No existe el método '"
                    + nombreMetodo
                    + "' compatible con los argumentos "
                    + describirArgumentos(argumentos)
                    + " en la clase '"
                    + claseMetodo.getNombre()
                    + "'."
            );
        }

        return null;
    }

    @Override
    public Void visitLlamadaMetodo(
            ZParser.LlamadaMetodoContext ctx) {

        obtenerTipoLlamadaDirecta(ctx);

        return null;
    }

    @Override
    public Void visitCuerpoControl(
            ZParser.CuerpoControlContext ctx) {

        if (ctx == null) {
            return null;
        }

        if (ctx.bloque() != null) {

            visit(ctx.bloque());

            return null;
        }

        if (ctx.sentencia() != null) {

            tablaVariables.entrarAmbito();

            visit(ctx.sentencia());

            tablaVariables.salirAmbito();
        }

        return null;
    }

    // =========================================================
    // PARAMETROS
    // =========================================================
    private List<ParametroZ> obtenerParametros(
            ZParser.ListaParametrosContext ctx,
            String propietario) {

        List<ParametroZ> parametros
                = new ArrayList<>();

        if (ctx == null) {
            return parametros;
        }

        Set<String> nombres
                = new HashSet<>();

        for (ZParser.ParametroContext parametroCtx
                : ctx.parametro()) {

            String nombre
                    = parametroCtx.IDENTIFICADOR().getText();

            String tipo
                    = obtenerTipo(
                            parametroCtx.tipo()
                    );

            int dimensiones
                    = parametroCtx
                            .dimensionesParametro()
                            .size();

            if (!nombres.add(nombre)) {

                agregarError(
                        parametroCtx.getStart().getLine(),
                        parametroCtx.getStart()
                                .getCharPositionInLine(),
                        "El parámetro '"
                        + nombre
                        + "' está declarado más de una vez en el "
                        + propietario
                        + "."
                );
            }

            parametros.add(
                    new ParametroZ(
                            nombre,
                            tipo,
                            dimensiones
                    )
            );
        }

        return parametros;
    }

    // =========================================================
    // TIPOS
    // =========================================================
    private String obtenerTipo(
            ZParser.TipoContext ctx) {

        if (ctx == null) {
            return "desconocido";
        }

        return ctx.getText();
    }

    private String obtenerTipoRetorno(
            ZParser.TipoRetornoContext ctx) {

        if (ctx == null) {
            return "desconocido";
        }

        if (ctx.VOID() != null) {
            return "void";
        }

        if (ctx.tipo() != null) {
            return obtenerTipo(ctx.tipo());
        }

        return "desconocido";
    }

    // =========================================================
    // REPORTE
    // =========================================================
    public void imprimirResultado() {

        System.out.println();
        System.out.println(
                "=== RESULTADO SEMANTICO ZETARIANO ==="
        );

        if (claseActual != null) {

            System.out.println(
                    "Clase: "
                    + claseActual.getNombre()
            );

            System.out.println();
            System.out.println("Atributos:");

            if (claseActual.getAtributos().isEmpty()) {

                System.out.println("  (ninguno)");

            } else {

                for (AtributoZ atributo
                        : claseActual.getAtributos()) {

                    System.out.println(
                            "  " + atributo
                    );
                }
            }

            System.out.println();
            System.out.println("Constructores:");

            if (claseActual
                    .getConstructores()
                    .isEmpty()) {

                System.out.println("  (ninguno)");

            } else {

                for (ConstructorZ constructor
                        : claseActual.getConstructores()) {

                    System.out.println(
                            "  "
                            + constructor
                    );
                }
            }

            System.out.println();
            System.out.println("Métodos:");

            if (claseActual
                    .getMetodos()
                    .isEmpty()) {

                System.out.println("  (ninguno)");

            } else {

                for (MetodoZ metodo
                        : claseActual.getMetodos()) {

                    System.out.println(
                            "  " + metodo
                    );
                }
            }
        }

        System.out.println();
        System.out.println("Errores semánticos: "
                + errores.size());

        for (String error : errores) {
            System.out.println(error);
        }

        if (errores.isEmpty()) {
            System.out.println(
                    "RESULTADO: ANALISIS SEMANTICO CORRECTO"
            );
        } else {
            System.out.println(
                    "RESULTADO: EXISTEN ERRORES SEMANTICOS"
            );
        }

        System.out.println(
                "=== FIN SEMANTICO ZETARIANO ==="
        );
    }

    private void registrarParametrosEnAmbito(
            List<ParametroZ> parametros) {

        Set<String> registrados = new HashSet<>();

        for (ParametroZ parametro : parametros) {

            if (!registrados.add(parametro.getNombre())) {
                continue;
            }

            VariableZ variable = new VariableZ(
                    parametro.getNombre(),
                    parametro.getTipo(),
                    parametro.getDimensiones(),
                    true
            );

            tablaVariables.registrar(variable);
        }
    }

    private void visitarBloqueSinCrearAmbito(
            ZParser.BloqueContext ctx) {

        if (ctx == null) {
            return;
        }

        for (ZParser.SentenciaContext sentencia
                : ctx.sentencia()) {

            visit(sentencia);
        }
    }

    private VariableZ buscarVariable(String nombre) {

        VariableZ variable
                = tablaVariables.buscar(nombre);

        if (variable != null) {
            return variable;
        }

        if (claseActual != null) {

            AtributoZ atributo
                    = claseActual.buscarAtributo(nombre);

            if (atributo != null) {

                return new VariableZ(
                        atributo.getNombre(),
                        atributo.getTipo(),
                        atributo.getDimensiones(),
                        false
                );
            }
        }

        return null;
    }

    private String obtenerTipoLiteral(
            ZParser.LiteralContext ctx) {

        if (ctx == null) {
            return "desconocido";
        }

        if (ctx.ENTERO() != null) {
            return "int";
        }

        if (ctx.DECIMAL() != null) {
            return "double";
        }

        if (ctx.CADENA() != null) {
            return "String";
        }

        if (ctx.CARACTER() != null) {
            return "char";
        }

        if (ctx.TRUE() != null
                || ctx.FALSE() != null) {

            return "boolean";
        }

        if (ctx.NULL() != null) {
            return "null";
        }

        return "desconocido";
    }

    private boolean tiposCompatibles(
            String destino,
            String origen) {

        if (destino == null || origen == null) {
            return false;
        }

        if (destino.equals("desconocido")
                || origen.equals("desconocido")) {

            return false;
        }

        if (destino.equals(origen)) {
            return true;
        }

        if (destino.equals("double")
                && origen.equals("int")) {

            return true;
        }

        if (origen.equals("null")) {

            return destino.equals("String")
                    || esTipoObjeto(destino);
        }

        return false;
    }

    private boolean esTipoPrimitivoNoNullable(
            String tipo) {

        return tipo.equals("int")
                || tipo.equals("double")
                || tipo.equals("char")
                || tipo.equals("boolean");
    }

    private String obtenerTipoExpresion(
            ZParser.ExpresionContext ctx) {

        if (ctx == null) {
            return "desconocido";
        }

        // =========================================================
        // PARTE PRINCIPAL
        // =========================================================
        String tipoCondicion
                = obtenerTipoExpresionOr(
                        ctx.expresionOr()
                );

        if (ctx.TERNARIO() == null) {
            return tipoCondicion;
        }

        // =========================================================
        // OPERADOR TERNARIO
        // =========================================================
        if (!tipoCondicion.equals("desconocido")
                && !tipoCondicion.equals("boolean")) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "La condición del operador ternario debe ser de tipo boolean, pero se encontró tipo '"
                    + tipoCondicion
                    + "'."
            );
        }

        List<ZParser.ExpresionContext> ramas
                = ctx.expresion();

        if (ramas.size() < 2) {
            return "desconocido";
        }

        String tipoVerdadero
                = obtenerTipoExpresion(
                        ramas.get(0)
                );

        String tipoFalso
                = obtenerTipoExpresion(
                        ramas.get(1)
                );

        if (tipoVerdadero.equals("desconocido")
                || tipoFalso.equals("desconocido")) {

            return "desconocido";
        }

        // =========================================================
        // MISMO TIPO
        // =========================================================
        if (tipoVerdadero.equals(
                tipoFalso)) {

            return tipoVerdadero;
        }

        // =========================================================
        // PROMOCION NUMERICA
        // =========================================================
        if (esNumerico(tipoVerdadero)
                && esNumerico(tipoFalso)) {

            return "double";
        }

        // =========================================================
        // NULL + REFERENCIA
        // =========================================================
        if (tipoVerdadero.equals("null")
                && (tipoFalso.equals("String")
                || esTipoObjeto(tipoFalso))) {

            return tipoFalso;
        }

        if (tipoFalso.equals("null")
                && (tipoVerdadero.equals("String")
                || esTipoObjeto(tipoVerdadero))) {

            return tipoVerdadero;
        }

        // =========================================================
        // TIPOS INCOMPATIBLES
        // =========================================================
        agregarError(
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine(),
                "Las ramas del operador ternario tienen tipos incompatibles: '"
                + tipoVerdadero
                + "' y '"
                + tipoFalso
                + "'."
        );

        return "desconocido";
    }

    private String obtenerTipoExpresionOr(
            ZParser.ExpresionOrContext ctx) {

        if (ctx == null) {
            return "desconocido";
        }

        if (ctx.expresionOr() == null) {
            return obtenerTipoExpresionAnd(
                    ctx.expresionAnd()
            );
        }

        String izquierdo
                = obtenerTipoExpresionOr(
                        ctx.expresionOr()
                );

        String derecho
                = obtenerTipoExpresionAnd(
                        ctx.expresionAnd()
                );

        if (izquierdo.equals("desconocido")
                || derecho.equals("desconocido")) {

            return "desconocido";
        }

        if (!izquierdo.equals("boolean")
                || !derecho.equals("boolean")) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "El operador || requiere operandos boolean."
            );
        }

        return "boolean";
    }

    private String obtenerTipoExpresionAnd(
            ZParser.ExpresionAndContext ctx) {

        if (ctx == null) {
            return "desconocido";
        }

        if (ctx.expresionAnd() == null) {
            return obtenerTipoIgualdad(
                    ctx.expresionIgualdad()
            );
        }

        String izquierdo
                = obtenerTipoExpresionAnd(
                        ctx.expresionAnd()
                );

        String derecho
                = obtenerTipoIgualdad(
                        ctx.expresionIgualdad()
                );

        if (izquierdo.equals("desconocido")
                || derecho.equals("desconocido")) {

            return "desconocido";
        }

        if (!izquierdo.equals("boolean")
                || !derecho.equals("boolean")) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "El operador && requiere operandos boolean."
            );
        }

        return "boolean";
    }

    private String obtenerTipoIgualdad(
            ZParser.ExpresionIgualdadContext ctx) {

        if (ctx == null) {
            return "desconocido";
        }

        if (ctx.expresionIgualdad() == null) {

            return obtenerTipoRelacional(
                    ctx.expresionRelacional()
            );
        }

        String izquierdo
                = obtenerTipoIgualdad(
                        ctx.expresionIgualdad()
                );

        String derecho
                = obtenerTipoRelacional(
                        ctx.expresionRelacional()
                );

        if (izquierdo.equals("desconocido")
                || derecho.equals("desconocido")) {

            return "desconocido";
        }

        if (!tiposCompatibles(izquierdo, derecho)
                && !tiposCompatibles(derecho, izquierdo)) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "No se pueden comparar tipos '"
                    + izquierdo
                    + "' y '"
                    + derecho
                    + "'."
            );
        }

        return "boolean";
    }

    private String obtenerTipoRelacional(
            ZParser.ExpresionRelacionalContext ctx) {

        if (ctx == null) {
            return "desconocido";
        }

        if (ctx.expresionRelacional() == null) {

            return obtenerTipoAditiva(
                    ctx.expresionAditiva()
            );
        }

        String izquierdo
                = obtenerTipoRelacional(
                        ctx.expresionRelacional()
                );

        String derecho
                = obtenerTipoAditiva(
                        ctx.expresionAditiva()
                );

        if (izquierdo.equals("desconocido")
                || derecho.equals("desconocido")) {

            return "desconocido";
        }

        if (!esNumerico(izquierdo)
                || !esNumerico(derecho)) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "El operador relacional requiere operandos numéricos."
            );
        }

        return "boolean";
    }

    private boolean esNumerico(String tipo) {

        return tipo.equals("int")
                || tipo.equals("double");
    }

    private String obtenerTipoAditiva(
            ZParser.ExpresionAditivaContext ctx) {

        if (ctx == null) {
            return "desconocido";
        }

        if (ctx.expresionAditiva() == null) {

            return obtenerTipoMultiplicativa(
                    ctx.expresionMultiplicativa()
            );
        }

        String izquierdo
                = obtenerTipoAditiva(
                        ctx.expresionAditiva()
                );

        String derecho
                = obtenerTipoMultiplicativa(
                        ctx.expresionMultiplicativa()
                );

        if (izquierdo.equals("desconocido")
                || derecho.equals("desconocido")) {

            return "desconocido";
        }

        if (izquierdo.equals("String")
                || derecho.equals("String")) {

            return "String";
        }

        if (!esNumerico(izquierdo)
                || !esNumerico(derecho)) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "La operación aritmética requiere operandos numéricos."
            );

            return "desconocido";
        }

        if (izquierdo.equals("double")
                || derecho.equals("double")) {

            return "double";
        }

        return "int";
    }

    private String obtenerTipoMultiplicativa(
            ZParser.ExpresionMultiplicativaContext ctx) {

        if (ctx == null) {
            return "desconocido";
        }

        if (ctx.expresionMultiplicativa() == null) {

            return obtenerTipoUnaria(
                    ctx.expresionUnaria()
            );
        }

        String izquierdo
                = obtenerTipoMultiplicativa(
                        ctx.expresionMultiplicativa()
                );

        String derecho
                = obtenerTipoUnaria(
                        ctx.expresionUnaria()
                );

        if (izquierdo.equals("desconocido")
                || derecho.equals("desconocido")) {

            return "desconocido";
        }

        if (!esNumerico(izquierdo)
                || !esNumerico(derecho)) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "La operación *, / o % requiere operandos numéricos."
            );

            return "desconocido";
        }

        if (izquierdo.equals("double")
                || derecho.equals("double")) {

            return "double";
        }

        return "int";
    }

    private String obtenerTipoUnaria(
            ZParser.ExpresionUnariaContext ctx) {

        if (ctx == null) {
            return "desconocido";
        }

        if (ctx.primario() != null) {
            return obtenerTipoPrimario(
                    ctx.primario()
            );
        }

        String tipo
                = obtenerTipoUnaria(
                        ctx.expresionUnaria()
                );

        if (ctx.NOT() != null) {

            if (!tipo.equals("boolean")) {

                agregarError(
                        ctx.getStart().getLine(),
                        ctx.getStart()
                                .getCharPositionInLine(),
                        "El operador ! requiere boolean."
                );
            }

            return "boolean";
        }

        if (!esNumerico(tipo)) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "El operador unario - requiere un valor numérico."
            );
        }

        return tipo;
    }

    private String obtenerTipoPrimario(
            ZParser.PrimarioContext ctx) {

        if (ctx == null) {
            return "desconocido";
        }

        if (ctx.literal() != null) {
            return obtenerTipoLiteral(
                    ctx.literal()
            );
        }

        if (ctx.acceso() != null) {

            ResultadoAccesoZ resultado
                    = resolverAcceso(
                            ctx.acceso()
                    );

            if (!resultado.isValido()) {
                return "desconocido";
            }

            return resultado.getTipo();
        }

        if (ctx.expresion() != null) {
            return obtenerTipoExpresion(
                    ctx.expresion()
            );
        }

        if (ctx.READLN() != null) {
            return "String";
        }

        if (ctx.creacionObjeto() != null) {

            return obtenerTipoCreacionObjeto(
                    ctx.creacionObjeto()
            );
        }

        if (ctx.llamadaMetodo() != null) {
            return obtenerTipoLlamadaDirecta(
                    ctx.llamadaMetodo()
            );
        }

        return "desconocido";
    }

    private void validarCondicion(
            ZParser.ExpresionContext expresion,
            int linea,
            int columna,
            String estructura) {

        if (expresion == null) {
            return;
        }

        String tipo
                = obtenerTipoExpresion(expresion);

        if (tipo.equals("desconocido")) {
            return;
        }

        if (!tipo.equals("boolean")) {

            agregarError(
                    linea,
                    columna,
                    "La condición de "
                    + estructura
                    + " debe ser de tipo boolean, pero se encontró '"
                    + tipo
                    + "'."
            );
        }
    }

    private boolean esTipoPrimitivo(String tipo) {

        return tipo != null
                && (tipo.equals("int")
                || tipo.equals("double")
                || tipo.equals("String")
                || tipo.equals("char")
                || tipo.equals("boolean"));
    }

    private boolean esTipoObjeto(String tipo) {

        if (tipo == null) {
            return false;
        }

        if (esTipoPrimitivo(tipo)) {
            return false;
        }

        if (tipo.equals("void")
                || tipo.equals("null")
                || tipo.equals("desconocido")) {

            return false;
        }

        return true;
    }

    private String obtenerTipoCreacionObjeto(
            ZParser.CreacionObjetoContext ctx) {

        String nombreClase
                = ctx.IDENTIFICADOR().getText();

        ClaseZ clase
                = tablaClases.buscar(nombreClase);

        if (clase == null) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "No existe la clase '"
                    + nombreClase
                    + "'."
            );

            return "desconocido";
        }

        List<ResultadoAccesoZ> argumentos
                = obtenerArgumentosCompletos(
                        ctx.listaArgumentos()
                );

        ConstructorZ constructor
                = buscarConstructorCompatible(
                        clase,
                        argumentos
                );

        if (constructor == null) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "No existe un constructor compatible para '"
                    + nombreClase
                    + "' con los argumentos "
                    + describirArgumentos(argumentos)
                    + "."
            );

            return "desconocido";
        }

        return nombreClase;
    }

    private ConstructorZ buscarConstructorCompatible(
            ClaseZ clase,
            List<ResultadoAccesoZ> argumentos) {

        if (clase == null) {
            return null;
        }

        ConstructorZ mejorConstructor
                = null;

        int mejorCosto
                = Integer.MAX_VALUE;

        for (ConstructorZ constructor
                : clase.getConstructores()) {

            List<ParametroZ> parametros
                    = constructor.getParametros();

            if (parametros.size()
                    != argumentos.size()) {

                continue;
            }

            int costo
                    = costoParametros(
                            parametros,
                            argumentos
                    );

            if (costo < 0) {
                continue;
            }

            if (costo < mejorCosto) {

                mejorCosto
                        = costo;

                mejorConstructor
                        = constructor;

                if (mejorCosto == 0) {
                    break;
                }
            }
        }

        // =========================================================
        // CONSTRUCTOR IMPLICITO VACIO
        // =========================================================
        if (argumentos.isEmpty()
                && clase.getConstructores().isEmpty()) {

            return new ConstructorZ(
                    clase.getNombre(),
                    new ArrayList<>()
            );
        }

        return mejorConstructor;
    }

    private MetodoZ buscarMetodoCompatible(
            ClaseZ clase,
            String nombre,
            List<ResultadoAccesoZ> argumentos) {

        if (clase == null) {
            return null;
        }

        MetodoZ mejorMetodo = null;

        int mejorCosto
                = Integer.MAX_VALUE;

        for (MetodoZ metodo
                : clase.getMetodos()) {

            if (!metodo.getNombre()
                    .equals(nombre)) {

                continue;
            }

            List<ParametroZ> parametros
                    = metodo.getParametros();

            if (parametros.size()
                    != argumentos.size()) {

                continue;
            }

            int costo
                    = costoParametros(
                            parametros,
                            argumentos
                    );

            if (costo < 0) {
                continue;
            }

            if (costo < mejorCosto) {

                mejorCosto
                        = costo;

                mejorMetodo
                        = metodo;

                if (mejorCosto == 0) {
                    break;
                }
            }
        }

        return mejorMetodo;
    }

    private ResultadoAccesoZ resolverAcceso(
            ZParser.AccesoContext ctx) {

        if (ctx == null) {
            return ResultadoAccesoZ.error();
        }

        String nombreBase
                = ctx.IDENTIFICADOR().getText();

        VariableZ base
                = buscarVariable(nombreBase);

        if (base == null) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "La variable o atributo '"
                    + nombreBase
                    + "' no ha sido declarado."
            );

            return ResultadoAccesoZ.error();
        }

        String tipoActual
                = base.getTipo();

        int dimensionesActuales
                = base.getDimensiones();

        for (ZParser.SufijoAccesoContext sufijo
                : ctx.sufijoAcceso()) {

            // ==========================================
            // [expresion]
            // ==========================================
            if (sufijo.CORCHETE_IZQ() != null) {

                if (dimensionesActuales <= 0) {

                    agregarError(
                            sufijo.getStart().getLine(),
                            sufijo.getStart()
                                    .getCharPositionInLine(),
                            "Se intenta indexar un valor que no es un arreglo."
                    );

                    return ResultadoAccesoZ.error();
                }

                String tipoIndice
                        = obtenerTipoExpresion(
                                sufijo.expresion()
                        );

                if (!tipoIndice.equals("desconocido")
                        && !tipoIndice.equals("int")) {

                    agregarError(
                            sufijo.getStart().getLine(),
                            sufijo.getStart()
                                    .getCharPositionInLine(),
                            "El índice de un arreglo debe ser de tipo int."
                    );
                }

                dimensionesActuales--;

                continue;
            }

            // ==========================================
            // .metodo(argumentos)
            // ==========================================
            if (sufijo.PUNTO() != null
                    && sufijo.PAREN_IZQ() != null) {

                if (dimensionesActuales > 0) {

                    agregarError(
                            sufijo.getStart().getLine(),
                            sufijo.getStart()
                                    .getCharPositionInLine(),
                            "No se puede invocar un método directamente sobre un arreglo."
                    );

                    return ResultadoAccesoZ.error();
                }

                ClaseZ clase
                        = tablaClases.buscar(tipoActual);

                if (clase == null) {

                    agregarError(
                            sufijo.getStart().getLine(),
                            sufijo.getStart()
                                    .getCharPositionInLine(),
                            "El tipo '"
                            + tipoActual
                            + "' no posee métodos."
                    );

                    return ResultadoAccesoZ.error();
                }

                String nombreMetodo
                        = sufijo.IDENTIFICADOR()
                                .getText();

                List<ResultadoAccesoZ> argumentos
                        = obtenerArgumentosCompletos(
                                sufijo.listaArgumentos()
                        );

                MetodoZ metodo
                        = buscarMetodoCompatible(
                                clase,
                                nombreMetodo,
                                argumentos
                        );

                if (metodo == null) {

                    agregarError(
                            sufijo.getStart().getLine(),
                            sufijo.getStart()
                                    .getCharPositionInLine(),
                            "No existe el método '"
                            + nombreMetodo
                            + "' compatible con los argumentos "
                            + describirArgumentos(argumentos)
                            + " en la clase '"
                            + tipoActual
                            + "'."
                    );

                    return ResultadoAccesoZ.error();
                }

                tipoActual
                        = metodo.getTipoRetorno();

                dimensionesActuales = 0;

                continue;
            }

            // ==========================================
            // .identificador
            // ==========================================
            if (sufijo.PUNTO() != null
                    && sufijo.PAREN_IZQ() == null) {

                if (dimensionesActuales > 0) {

                    agregarError(
                            sufijo.getStart().getLine(),
                            sufijo.getStart()
                                    .getCharPositionInLine(),
                            "No se puede acceder a un atributo directamente sobre un arreglo."
                    );

                    return ResultadoAccesoZ.error();
                }

                ClaseZ clase
                        = tablaClases.buscar(tipoActual);

                if (clase == null) {

                    agregarError(
                            sufijo.getStart().getLine(),
                            sufijo.getStart()
                                    .getCharPositionInLine(),
                            "El tipo '"
                            + tipoActual
                            + "' no posee atributos."
                    );

                    return ResultadoAccesoZ.error();
                }

                String nombreAtributo
                        = sufijo.IDENTIFICADOR()
                                .getText();

                AtributoZ atributo
                        = clase.buscarAtributo(
                                nombreAtributo
                        );

                if (atributo == null) {

                    agregarError(
                            sufijo.getStart().getLine(),
                            sufijo.getStart()
                                    .getCharPositionInLine(),
                            "La clase '"
                            + tipoActual
                            + "' no contiene el atributo '"
                            + nombreAtributo
                            + "'."
                    );

                    return ResultadoAccesoZ.error();
                }

                tipoActual
                        = atributo.getTipo();

                dimensionesActuales
                        = atributo.getDimensiones();

                continue;
            }

        }

        return new ResultadoAccesoZ(
                tipoActual,
                dimensionesActuales,
                true
        );
    }

    private String obtenerTipoLlamadaDirecta(
            ZParser.LlamadaMetodoContext ctx) {

        if (ctx == null) {
            return "desconocido";
        }

        if (claseActual == null) {
            return "desconocido";
        }

        String nombreMetodo
                = ctx.IDENTIFICADOR().getText();

        List<ResultadoAccesoZ> argumentos
                = obtenerArgumentosCompletos(
                        ctx.listaArgumentos()
                );

        MetodoZ metodo
                = buscarMetodoCompatible(
                        claseActual,
                        nombreMetodo,
                        argumentos
                );

        if (metodo == null) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "No existe el método '"
                    + nombreMetodo
                    + "' compatible con los argumentos "
                    + describirArgumentos(argumentos)
                    + " en la clase '"
                    + claseActual.getNombre()
                    + "'."
            );

            return "desconocido";
        }

        return metodo.getTipoRetorno();
    }

    private ResultadoAccesoZ obtenerTipoCreacionArreglo(
            ZParser.CreacionArregloContext ctx) {

        if (ctx == null) {
            return ResultadoAccesoZ.error();
        }

        String tipoElemento
                = obtenerTipo(ctx.tipo());

        int dimensiones
                = ctx.dimensionCreacion().size();

        for (ZParser.DimensionCreacionContext dimension
                : ctx.dimensionCreacion()) {

            if (dimension.expresion() == null) {
                continue;
            }

            String tipoDimension
                    = obtenerTipoExpresion(
                            dimension.expresion()
                    );

            if (tipoDimension.equals("desconocido")) {
                continue;
            }

            if (!tipoDimension.equals("int")) {

                agregarError(
                        dimension.getStart().getLine(),
                        dimension.getStart()
                                .getCharPositionInLine(),
                        "El tamaño de un arreglo debe ser de tipo int."
                );
            }
        }

        return new ResultadoAccesoZ(
                tipoElemento,
                dimensiones,
                true
        );
    }

    private boolean tiposCompatiblesCompletos(
            String tipoDestino,
            int dimensionesDestino,
            String tipoOrigen,
            int dimensionesOrigen) {

        if (tipoDestino == null
                || tipoOrigen == null) {

            return false;
        }

        if (tipoDestino.equals("desconocido")
                || tipoOrigen.equals("desconocido")) {

            return false;
        }

        // =========================================================
        // NULL
        // =========================================================
        if (tipoOrigen.equals("null")) {

            /*
         * Todo arreglo es una referencia.
             */
            if (dimensionesDestino > 0) {
                return true;
            }

            return tiposCompatibles(
                    tipoDestino,
                    tipoOrigen
            );
        }

        // =========================================================
        // DIMENSIONES
        // =========================================================
        if (dimensionesDestino
                != dimensionesOrigen) {

            return false;
        }

        // =========================================================
        // ARREGLOS
        // =========================================================
        if (dimensionesDestino > 0) {

            return tipoDestino.equals(
                    tipoOrigen
            );
        }

        // =========================================================
        // ESCALARES
        // =========================================================
        return tiposCompatibles(
                tipoDestino,
                tipoOrigen
        );
    }

    private ZParser.CreacionArregloContext buscarCreacionArreglo(
            ParseTree nodo) {

        if (nodo == null) {
            return null;
        }

        if (nodo instanceof ZParser.CreacionArregloContext) {

            return (ZParser.CreacionArregloContext) nodo;
        }

        for (int i = 0;
                i < nodo.getChildCount();
                i++) {

            ZParser.CreacionArregloContext resultado
                    = buscarCreacionArreglo(
                            nodo.getChild(i)
                    );

            if (resultado != null) {
                return resultado;
            }
        }

        return null;
    }

    private ZParser.AccesoContext buscarAccesoExpresion(
            ParseTree nodo) {

        if (nodo == null) {
            return null;
        }

        if (nodo instanceof ZParser.AccesoContext) {
            return (ZParser.AccesoContext) nodo;
        }

        for (int i = 0;
                i < nodo.getChildCount();
                i++) {

            ZParser.AccesoContext resultado
                    = buscarAccesoExpresion(
                            nodo.getChild(i)
                    );

            if (resultado != null) {
                return resultado;
            }
        }

        return null;
    }

    private void registrarAtributo(
            ZParser.AtributoContext ctx) {

        if (ctx == null
                || claseActual == null) {

            return;
        }

        String nombre
                = ctx.IDENTIFICADOR().getText();

        String tipo
                = obtenerTipo(
                        ctx.tipo()
                );

        int dimensiones
                = ctx.dimensionesParametro().size()
                + ctx.dimensiones().size();

        AtributoZ atributo
                = new AtributoZ(
                        nombre,
                        tipo,
                        dimensiones
                );

        if (!claseActual.registrarAtributo(
                atributo)) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "El atributo '"
                    + nombre
                    + "' ya fue declarado en la clase '"
                    + claseActual.getNombre()
                    + "'."
            );
        }
    }

    private void analizarInicializadorAtributo(
            ZParser.AtributoContext ctx) {

        if (ctx == null || claseActual == null) {
            return;
        }

        // =========================================================
        // ATRIBUTO SIN INICIALIZADOR
        // =========================================================
        if (ctx.inicializador() == null) {
            return;
        }

        String nombre
                = ctx.IDENTIFICADOR().getText();

        String tipo
                = obtenerTipo(
                        ctx.tipo()
                );

        int dimensiones
                = ctx.dimensionesParametro().size()
                + ctx.dimensiones().size();

        // =========================================================
        // INICIALIZADOR MEDIANTE LISTA
        // =========================================================
        if (ctx.inicializador()
                .inicializadorLista() != null) {

            if (dimensiones == 0) {

                agregarError(
                        ctx.getStart().getLine(),
                        ctx.getStart().getCharPositionInLine(),
                        "El atributo '"
                        + nombre
                        + "' no es un arreglo y no puede inicializarse mediante una lista."
                );

                return;
            }

            validarInicializadorLista(
                    ctx.inicializador()
                            .inicializadorLista(),
                    tipo,
                    dimensiones,
                    nombre
            );

            return;
        }

        // =========================================================
        // INICIALIZADOR MEDIANTE EXPRESION
        // =========================================================
        if (ctx.inicializador()
                .expresion() == null) {

            return;
        }

        ResultadoAccesoZ origen
                = obtenerResultadoExpresionCompleto(
                        ctx.inicializador()
                                .expresion()
                );

        if (!origen.isValido()) {
            return;
        }

        // =========================================================
        // VALIDAR TIPO + DIMENSIONES
        // =========================================================
        if (!tiposCompatiblesCompletos(
                tipo,
                dimensiones,
                origen.getTipo(),
                origen.getDimensiones())) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "No se puede inicializar el atributo '"
                    + nombre
                    + "' de tipo '"
                    + tipo
                    + "' con "
                    + dimensiones
                    + " dimensión(es) utilizando un valor de tipo '"
                    + origen.getTipo()
                    + "' con "
                    + origen.getDimensiones()
                    + " dimensión(es)."
            );
        }
    }

    private void registrarFirmaConstructor(
            ZParser.ConstructorContext ctx) {

        if (ctx == null
                || claseActual == null) {

            return;
        }

        String nombreConstructor
                = ctx.IDENTIFICADOR().getText();

        List<ParametroZ> parametros
                = obtenerParametros(
                        ctx.listaParametros(),
                        "constructor '"
                        + nombreConstructor
                        + "'"
                );

        parametrosConstructores.put(
                ctx,
                parametros
        );

        // =========================================================
        // NOMBRE DEL CONSTRUCTOR
        // =========================================================
        if (!nombreConstructor.equals(
                claseActual.getNombre())) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "El constructor '"
                    + nombreConstructor
                    + "' debe tener el mismo nombre que la clase '"
                    + claseActual.getNombre()
                    + "'."
            );

            return;
        }

        ConstructorZ constructor
                = new ConstructorZ(
                        nombreConstructor,
                        parametros
                );

        if (!claseActual.registrarConstructor(
                constructor)) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "El constructor con firma '"
                    + constructor.obtenerFirma()
                    + "' ya fue declarado."
            );
        }
    }

    private void analizarConstructor(
            ZParser.ConstructorContext ctx) {

        if (ctx == null
                || claseActual == null) {

            return;
        }

        String nombreConstructor
                = ctx.IDENTIFICADOR().getText();

        List<ParametroZ> parametros
                = parametrosConstructores.get(ctx);

        if (parametros == null) {

            parametros
                    = obtenerParametros(
                            ctx.listaParametros(),
                            "constructor '"
                            + nombreConstructor
                            + "'"
                    );
        }

        String tipoRetornoAnterior
                = tipoRetornoActual;

        String nombreMetodoAnterior
                = nombreMetodoActual;

        tipoRetornoActual
                = "constructor";

        nombreMetodoActual
                = nombreConstructor;

        tablaVariables.entrarAmbito();

        registrarParametrosEnAmbito(
                parametros
        );

        visitarBloqueSinCrearAmbito(
                ctx.bloque()
        );

        validarCodigoInalcanzableBloque(ctx.bloque());

        tablaVariables.salirAmbito();

        tipoRetornoActual
                = tipoRetornoAnterior;

        nombreMetodoActual
                = nombreMetodoAnterior;
    }

    private void registrarFirmaMetodo(
            ZParser.MetodoContext ctx) {

        if (ctx == null
                || claseActual == null) {

            return;
        }

        String nombreMetodo
                = ctx.IDENTIFICADOR().getText();

        String tipoRetorno
                = obtenerTipoRetorno(
                        ctx.tipoRetorno()
                );

        List<ParametroZ> parametros
                = obtenerParametros(
                        ctx.listaParametros(),
                        "método '"
                        + nombreMetodo
                        + "'"
                );

        parametrosMetodos.put(
                ctx,
                parametros
        );

        MetodoZ metodo
                = new MetodoZ(
                        nombreMetodo,
                        tipoRetorno,
                        parametros
                );

        if (!claseActual.registrarMetodo(
                metodo)) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "El método con firma '"
                    + metodo.obtenerFirma()
                    + "' ya fue declarado."
            );
        }
    }

    private void analizarMetodo(
            ZParser.MetodoContext ctx) {

        if (ctx == null
                || claseActual == null) {

            return;
        }

        String nombreMetodo
                = ctx.IDENTIFICADOR().getText();

        String tipoRetorno
                = obtenerTipoRetorno(
                        ctx.tipoRetorno()
                );

        List<ParametroZ> parametros
                = parametrosMetodos.get(ctx);

        if (parametros == null) {

            parametros
                    = obtenerParametros(
                            ctx.listaParametros(),
                            "método '"
                            + nombreMetodo
                            + "'"
                    );
        }

        String tipoRetornoAnterior
                = tipoRetornoActual;

        String nombreMetodoAnterior
                = nombreMetodoActual;

        tipoRetornoActual
                = tipoRetorno;

        nombreMetodoActual
                = nombreMetodo;

        tablaVariables.entrarAmbito();

        registrarParametrosEnAmbito(
                parametros
        );

        visitarBloqueSinCrearAmbito(
                ctx.bloque()
        );

        validarCodigoInalcanzableBloque(
                ctx.bloque()
        );

        // =========================================================
        // RETORNO GARANTIZADO
        // =========================================================
        if (!tipoRetorno.equals("void")
                && !bloqueGarantizaRetorno(
                        ctx.bloque())) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "El método '"
                    + nombreMetodo
                    + "' de tipo '"
                    + tipoRetorno
                    + "' no garantiza un valor de retorno en todos los caminos posibles."
            );
        }

        tablaVariables.salirAmbito();

        tipoRetornoActual
                = tipoRetornoAnterior;

        nombreMetodoActual
                = nombreMetodoAnterior;
    }

    private boolean sentenciaGarantizaRetorno(
            ZParser.SentenciaContext ctx) {

        if (ctx == null) {
            return false;
        }

        // =========================================================
        // RETURN
        // =========================================================
        if (ctx.sentenciaReturn() != null) {
            return true;
        }

        // =========================================================
        // IF / ELSE IF / ELSE
        // =========================================================
        if (ctx.sentenciaIf() != null) {

            return ifGarantizaRetorno(
                    ctx.sentenciaIf()
            );
        }

        // =========================================================
        // BLOQUE ANIDADO
        // =========================================================
        if (ctx.bloque() != null) {

            return bloqueGarantizaRetorno(
                    ctx.bloque()
            );
        }

        return false;
    }

    private boolean bloqueGarantizaRetorno(
            ZParser.BloqueContext ctx) {

        if (ctx == null) {
            return false;
        }

        for (ZParser.SentenciaContext sentencia
                : ctx.sentencia()) {

            if (sentenciaGarantizaRetorno(
                    sentencia)) {

                return true;
            }
        }

        return false;
    }

    private boolean cuerpoControlGarantizaRetorno(
            ZParser.CuerpoControlContext ctx) {

        if (ctx == null) {
            return false;
        }

        if (ctx.bloque() != null) {

            return bloqueGarantizaRetorno(
                    ctx.bloque()
            );
        }

        if (ctx.sentencia() != null) {

            return sentenciaGarantizaRetorno(
                    ctx.sentencia()
            );
        }

        return false;
    }

    private boolean ifGarantizaRetorno(
            ZParser.SentenciaIfContext ctx) {

        if (ctx == null) {
            return false;
        }

        List<ZParser.CuerpoControlContext> cuerpos
                = ctx.cuerpoControl();

        int cantidadCondiciones
                = ctx.expresion().size();

        boolean tieneElse
                = cuerpos.size()
                > cantidadCondiciones;

        if (!tieneElse) {
            return false;
        }

        for (ZParser.CuerpoControlContext cuerpo
                : cuerpos) {

            if (!cuerpoControlGarantizaRetorno(
                    cuerpo)) {

                return false;
            }
        }

        return true;
    }

    private void validarCodigoInalcanzableBloque(
            ZParser.BloqueContext ctx) {

        if (ctx == null) {
            return;
        }

        boolean flujoTerminado = false;

        for (ZParser.SentenciaContext sentencia
                : ctx.sentencia()) {

            // =====================================================
            // YA HUBO RETURN GARANTIZADO
            // =====================================================
            if (flujoTerminado) {

                agregarError(
                        sentencia.getStart().getLine(),
                        sentencia.getStart()
                                .getCharPositionInLine(),
                        "Código inalcanzable detectado después de una instrucción que termina el flujo."
                );

                validarCodigoInalcanzableSentencia(
                        sentencia
                );

                continue;
            }

            // =====================================================
            // REVISAR ESTRUCTURAS INTERNAS
            // =====================================================
            validarCodigoInalcanzableSentencia(
                    sentencia
            );

            // =====================================================
            // ESTA SENTENCIA TERMINA EL FLUJO
            // =====================================================
            if (sentenciaGarantizaRetorno(
                    sentencia)) {

                flujoTerminado = true;
            }
        }
    }

    private void validarCodigoInalcanzableSentencia(
            ZParser.SentenciaContext ctx) {

        if (ctx == null) {
            return;
        }

        // =========================================================
        // BLOQUE
        // =========================================================
        if (ctx.bloque() != null) {

            validarCodigoInalcanzableBloque(
                    ctx.bloque()
            );

            return;
        }

        // =========================================================
        // IF
        // =========================================================
        if (ctx.sentenciaIf() != null) {

            for (ZParser.CuerpoControlContext cuerpo
                    : ctx.sentenciaIf()
                            .cuerpoControl()) {

                validarCodigoInalcanzableCuerpo(
                        cuerpo
                );
            }

            return;
        }

        // =========================================================
        // WHILE
        // =========================================================
        if (ctx.sentenciaWhile() != null) {

            validarCodigoInalcanzableCuerpo(
                    ctx.sentenciaWhile()
                            .cuerpoControl()
            );

            return;
        }

        // =========================================================
        // DO-WHILE
        // =========================================================
        if (ctx.sentenciaDoWhile() != null) {

            validarCodigoInalcanzableCuerpo(
                    ctx.sentenciaDoWhile()
                            .cuerpoControl()
            );

            return;
        }

        // =========================================================
        // FOR
        // =========================================================
        if (ctx.sentenciaFor() != null) {

            validarCodigoInalcanzableCuerpo(
                    ctx.sentenciaFor()
                            .cuerpoControl()
            );
        }
    }

    private void validarCodigoInalcanzableCuerpo(
            ZParser.CuerpoControlContext ctx) {

        if (ctx == null) {
            return;
        }

        if (ctx.bloque() != null) {

            validarCodigoInalcanzableBloque(
                    ctx.bloque()
            );

            return;
        }

        if (ctx.sentencia() != null) {

            validarCodigoInalcanzableSentencia(
                    ctx.sentencia()
            );
        }
    }

    private void validarAsignacionAcceso(
            ResultadoAccesoZ destino,
            ZParser.OperadorAsignacionContext operador,
            ZParser.ExpresionContext expresion,
            int linea,
            int columna) {

        if (destino == null
                || !destino.isValido()) {

            return;
        }

        ResultadoAccesoZ origen
                = obtenerResultadoExpresionCompleto(
                        expresion
                );

        if (!origen.isValido()) {
            return;
        }

        String tipoDestino
                = destino.getTipo();

        String tipoOrigen
                = origen.getTipo();

        int dimensionesDestino
                = destino.getDimensiones();

        int dimensionesOrigen
                = origen.getDimensiones();

        // =========================================================
        // =
        // =========================================================
        if (operador.ASIGNACION() != null) {

            if (!tiposCompatiblesCompletos(
                    tipoDestino,
                    dimensionesDestino,
                    tipoOrigen,
                    dimensionesOrigen)) {

                agregarError(
                        linea,
                        columna,
                        "Asignación incompatible: el destino es de tipo '"
                        + tipoDestino
                        + "' con "
                        + dimensionesDestino
                        + " dimensión(es), pero el valor es de tipo '"
                        + tipoOrigen
                        + "' con "
                        + dimensionesOrigen
                        + " dimensión(es)."
                );
            }

            return;
        }

        // =========================================================
        // OPERACIONES COMPUESTAS SOBRE ARREGLOS
        // =========================================================
        if (dimensionesDestino > 0) {

            agregarError(
                    linea,
                    columna,
                    "No se puede utilizar una asignación compuesta directamente sobre un arreglo."
            );

            return;
        }

        if (dimensionesOrigen > 0) {

            agregarError(
                    linea,
                    columna,
                    "No se puede utilizar un arreglo como operando de una asignación compuesta."
            );

            return;
        }

        // =========================================================
        // +=
        // =========================================================
        if (operador.MAS_IGUAL() != null) {

            if (tipoDestino.equals("String")) {
                return;
            }

            if (esNumerico(tipoDestino)
                    && esNumerico(tipoOrigen)) {

                if (tipoDestino.equals("int")
                        && tipoOrigen.equals("double")) {

                    agregarError(
                            linea,
                            columna,
                            "La operación += produciría un valor double que no puede almacenarse en un acceso de tipo int."
                    );
                }

                return;
            }

            agregarError(
                    linea,
                    columna,
                    "El operador += no es compatible entre los tipos '"
                    + tipoDestino
                    + "' y '"
                    + tipoOrigen
                    + "'."
            );

            return;
        }

        // =========================================================
        // -= y *=
        // =========================================================
        if (operador.MENOS_IGUAL() != null
                || operador.POR_IGUAL() != null) {

            if (!esNumerico(tipoDestino)
                    || !esNumerico(tipoOrigen)) {

                agregarError(
                        linea,
                        columna,
                        "Los operadores -= y *= requieren operandos numéricos."
                );

                return;
            }

            if (tipoDestino.equals("int")
                    && tipoOrigen.equals("double")) {

                agregarError(
                        linea,
                        columna,
                        "La asignación compuesta produciría un valor double que no puede almacenarse en un acceso de tipo int."
                );
            }
        }
    }

    private void validarIncrementoDecrementoFor(
            ResultadoAccesoZ resultado,
            ParserRuleContext ctx) {

        if (resultado.getDimensiones() > 0) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "No se puede aplicar ++ o -- directamente a un arreglo."
            );

            return;
        }

        if (!esNumerico(resultado.getTipo())) {

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart().getCharPositionInLine(),
                    "El operador ++ o -- requiere un valor numérico, pero se encontró tipo '"
                    + resultado.getTipo()
                    + "'."
            );
        }
    }

    private List<Integer> obtenerFormaInicializador(
            ZParser.InicializadorListaContext lista) {

        if (lista == null) {
            return null;
        }

        List<Integer> forma
                = new ArrayList<>();

        forma.add(
                lista.inicializador().size()
        );

        List<Integer> formaInterna
                = null;

        boolean contieneListas = false;
        boolean contieneExpresiones = false;

        for (ZParser.InicializadorContext elemento
                : lista.inicializador()) {

            if (elemento.inicializadorLista() != null) {

                contieneListas = true;

                List<Integer> formaElemento
                        = obtenerFormaInicializador(
                                elemento.inicializadorLista()
                        );

                if (formaElemento == null) {
                    return null;
                }

                if (formaInterna == null) {

                    formaInterna
                            = formaElemento;

                } else if (!formaInterna.equals(
                        formaElemento)) {

                    return null;
                }

                continue;
            }

            if (elemento.expresion() != null) {
                contieneExpresiones = true;
            }
        }

        // Una misma lista no debe mezclar escalares y sublistas.
        // Ese error de niveles será reportado por
        // validarInicializadorLista.
        if (contieneListas
                && contieneExpresiones) {

            return null;
        }

        if (formaInterna != null) {
            forma.addAll(formaInterna);
        }

        return forma;
    }

    private void validarInicializadorLista(
            ZParser.InicializadorListaContext lista,
            String tipoElemento,
            int dimensionesEsperadas,
            String nombreVariable) {

        if (lista == null) {
            return;
        }

        // Una lista no puede inicializar una variable escalar.
        // Una lista no puede inicializar una variable escalar.
        if (dimensionesEsperadas <= 0) {

            agregarError(
                    lista.getStart().getLine(),
                    lista.getStart().getCharPositionInLine(),
                    "La variable '" + nombreVariable
                    + "' no es un arreglo y no puede inicializarse con una lista."
            );

            return;
        }

        // =========================================================
        // VALIDAR QUE LAS LISTAS HERMANAS TENGAN LA MISMA FORMA
        // =========================================================
        if (dimensionesEsperadas > 1) {

            List<Integer> formaEsperada = null;

            for (ZParser.InicializadorContext elemento
                    : lista.inicializador()) {

                if (elemento.inicializadorLista() == null) {
                    continue;
                }

                List<Integer> formaActual
                        = obtenerFormaInicializador(
                                elemento.inicializadorLista()
                        );

                if (formaActual == null) {
                    continue;
                }

                if (formaEsperada == null) {

                    formaEsperada
                            = formaActual;

                    continue;
                }

                if (!formaEsperada.equals(formaActual)) {

                    agregarError(
                            elemento.getStart().getLine(),
                            elemento.getStart().getCharPositionInLine(),
                            "El inicializador del arreglo '"
                            + nombreVariable
                            + "' es irregular: todas las listas del mismo nivel deben tener la misma forma."
                    );

                    break;
                }
            }
        }

        for (ZParser.InicializadorContext elemento
                : lista.inicializador()) {

            // =====================================================
            // ULTIMA DIMENSION
            // =====================================================
            if (dimensionesEsperadas == 1) {

                if (elemento.inicializadorLista() != null) {

                    agregarError(
                            elemento.getStart().getLine(),
                            elemento.getStart().getCharPositionInLine(),
                            "El inicializador del arreglo '"
                            + nombreVariable
                            + "' contiene más niveles de dimensiones de los esperados."
                    );

                    continue;
                }

                if (elemento.expresion() == null) {
                    continue;
                }

                ZParser.CreacionArregloContext creacion
                        = buscarCreacionArreglo(
                                elemento.expresion()
                        );

                if (creacion != null) {

                    agregarError(
                            elemento.getStart().getLine(),
                            elemento.getStart().getCharPositionInLine(),
                            "Se esperaba un elemento de tipo '"
                            + tipoElemento
                            + "' en el arreglo '"
                            + nombreVariable
                            + "', pero se encontró un arreglo."
                    );

                    continue;
                }

                String tipoValor
                        = obtenerTipoExpresion(
                                elemento.expresion()
                        );

                if (!tipoValor.equals("desconocido")
                        && !tiposCompatibles(
                                tipoElemento,
                                tipoValor)) {

                    agregarError(
                            elemento.getStart().getLine(),
                            elemento.getStart().getCharPositionInLine(),
                            "Elemento incompatible en el arreglo '"
                            + nombreVariable
                            + "': se esperaba tipo '"
                            + tipoElemento
                            + "' pero se encontró tipo '"
                            + tipoValor
                            + "'."
                    );
                }

                continue;
            }

            // =====================================================
            // TODAVIA FALTAN DIMENSIONES
            //
            // int[][] matriz = {
            //     {1,2},
            //     {3,4}
            // };
            // =====================================================
            if (elemento.inicializadorLista() != null) {

                validarInicializadorLista(
                        elemento.inicializadorLista(),
                        tipoElemento,
                        dimensionesEsperadas - 1,
                        nombreVariable
                );

                continue;
            }

            if (elemento.expresion() != null) {

                ZParser.CreacionArregloContext creacion
                        = buscarCreacionArreglo(
                                elemento.expresion()
                        );

                if (creacion != null) {

                    ResultadoAccesoZ resultado
                            = obtenerTipoCreacionArreglo(
                                    creacion
                            );

                    if (resultado.isValido()
                            && !tiposCompatiblesCompletos(
                                    tipoElemento,
                                    dimensionesEsperadas - 1,
                                    resultado.getTipo(),
                                    resultado.getDimensiones())) {

                        agregarError(
                                elemento.getStart().getLine(),
                                elemento.getStart().getCharPositionInLine(),
                                "Subarreglo incompatible en la inicialización de '"
                                + nombreVariable
                                + "'. Se esperaba tipo '"
                                + tipoElemento
                                + "' con "
                                + (dimensionesEsperadas - 1)
                                + " dimensión(es), pero se encontró tipo '"
                                + resultado.getTipo()
                                + "' con "
                                + resultado.getDimensiones()
                                + " dimensión(es)."
                        );
                    }

                    continue;
                }

                agregarError(
                        elemento.getStart().getLine(),
                        elemento.getStart().getCharPositionInLine(),
                        "La inicialización del arreglo '"
                        + nombreVariable
                        + "' requiere otro nivel de lista para representar "
                        + dimensionesEsperadas
                        + " dimensiones."
                );
            }
        }
    }

    private ResultadoAccesoZ obtenerResultadoExpresionCompleto(
            ZParser.ExpresionContext ctx) {

        if (ctx == null) {
            return ResultadoAccesoZ.error();
        }

        if (ctx.TERNARIO() != null) {

            // -----------------------------------------------------
            // 1. VALIDAR CONDICION
            // -----------------------------------------------------
            String tipoCondicion
                    = obtenerTipoExpresionOr(
                            ctx.expresionOr()
                    );

            if (!tipoCondicion.equals("desconocido")
                    && !tipoCondicion.equals("boolean")) {

                agregarError(
                        ctx.getStart().getLine(),
                        ctx.getStart()
                                .getCharPositionInLine(),
                        "La condición del operador ternario debe ser de tipo boolean, pero se encontró tipo '"
                        + tipoCondicion
                        + "'."
                );
            }

            List<ZParser.ExpresionContext> ramas
                    = ctx.expresion();

            if (ramas.size() < 2) {
                return ResultadoAccesoZ.error();
            }

            // -----------------------------------------------------
            // 2. OBTENER TIPO + DIMENSIONES DE LAS DOS RAMAS
            // -----------------------------------------------------
            ResultadoAccesoZ verdadero
                    = obtenerResultadoExpresionCompleto(
                            ramas.get(0)
                    );

            ResultadoAccesoZ falso
                    = obtenerResultadoExpresionCompleto(
                            ramas.get(1)
                    );

            if (!verdadero.isValido()
                    || !falso.isValido()) {

                return ResultadoAccesoZ.error();
            }

            String tipoVerdadero
                    = verdadero.getTipo();

            String tipoFalso
                    = falso.getTipo();

            int dimensionesVerdadero
                    = verdadero.getDimensiones();

            int dimensionesFalso
                    = falso.getDimensiones();

            if (tipoVerdadero.equals(tipoFalso)
                    && dimensionesVerdadero
                    == dimensionesFalso) {

                return new ResultadoAccesoZ(
                        tipoVerdadero,
                        dimensionesVerdadero,
                        true
                );
            }

            if (tipoVerdadero.equals("null")) {

                if (dimensionesFalso > 0
                        || tipoFalso.equals("String")
                        || esTipoObjeto(tipoFalso)) {

                    return new ResultadoAccesoZ(
                            tipoFalso,
                            dimensionesFalso,
                            true
                    );
                }
            }

            if (tipoFalso.equals("null")) {

                if (dimensionesVerdadero > 0
                        || tipoVerdadero.equals("String")
                        || esTipoObjeto(tipoVerdadero)) {

                    return new ResultadoAccesoZ(
                            tipoVerdadero,
                            dimensionesVerdadero,
                            true
                    );
                }
            }

            if (dimensionesVerdadero == 0
                    && dimensionesFalso == 0
                    && esNumerico(tipoVerdadero)
                    && esNumerico(tipoFalso)) {

                return new ResultadoAccesoZ(
                        "double",
                        0,
                        true
                );
            }

            agregarError(
                    ctx.getStart().getLine(),
                    ctx.getStart()
                            .getCharPositionInLine(),
                    "Las ramas del operador ternario tienen tipos incompatibles: '"
                    + describirTipoCompleto(
                            tipoVerdadero,
                            dimensionesVerdadero)
                    + "' y '"
                    + describirTipoCompleto(
                            tipoFalso,
                            dimensionesFalso)
                    + "'."
            );

            return ResultadoAccesoZ.error();
        }

        // =========================================================
        // NEW ARREGLO
        // =========================================================
        ZParser.CreacionArregloContext creacion
                = buscarCreacionArreglo(ctx);

        if (creacion != null
                && ctx.getText().equals(
                        creacion.getText())) {

            return obtenerTipoCreacionArreglo(
                    creacion
            );
        }

        ZParser.AccesoContext acceso
                = buscarAccesoExpresion(ctx);

        if (acceso != null
                && ctx.getText().equals(
                        acceso.getText())) {

            return resolverAcceso(
                    acceso
            );
        }

        // =========================================================
        // EXPRESION ESCALAR NORMAL
        // =========================================================
        String tipo
                = obtenerTipoExpresion(ctx);

        if (tipo.equals("desconocido")) {
            return ResultadoAccesoZ.error();
        }

        return new ResultadoAccesoZ(
                tipo,
                0,
                true
        );
    }

    private int costoCompatibilidadParametro(
            ParametroZ parametro,
            ResultadoAccesoZ argumento) {

        if (parametro == null
                || argumento == null
                || !argumento.isValido()) {

            return -1;
        }

        String tipoParametro
                = parametro.getTipo();

        int dimensionesParametro
                = parametro.getDimensiones();

        String tipoArgumento
                = argumento.getTipo();

        int dimensionesArgumento
                = argumento.getDimensiones();

        if (tipoArgumento.equals("desconocido")) {
            return -1;
        }

        // =========================================================
        // NULL
        // =========================================================
        if (tipoArgumento.equals("null")) {

            // null puede enviarse a cualquier arreglo.
            if (dimensionesParametro > 0) {
                return 1;
            }

            // String u objeto.
            if (tipoParametro.equals("String")
                    || esTipoObjeto(tipoParametro)) {

                return 1;
            }

            return -1;
        }

        // =========================================================
        // DIMENSIONES
        // =========================================================
        if (dimensionesParametro
                != dimensionesArgumento) {

            return -1;
        }

        // =========================================================
        // ARREGLOS
        // =========================================================
        if (dimensionesParametro > 0) {

            if (tipoParametro.equals(tipoArgumento)) {
                return 0;
            }

            return -1;
        }

        // =========================================================
        // ESCALAR EXACTO
        // =========================================================
        if (tipoParametro.equals(tipoArgumento)) {
            return 0;
        }

        // =========================================================
        // PROMOCION int -> double
        // =========================================================
        if (tipoParametro.equals("double")
                && tipoArgumento.equals("int")) {

            return 1;
        }

        return -1;
    }

    private int costoParametros(
            List<ParametroZ> parametros,
            List<ResultadoAccesoZ> argumentos) {

        if (parametros == null
                || argumentos == null
                || parametros.size() != argumentos.size()) {

            return -1;
        }

        int costoTotal = 0;

        for (int i = 0;
                i < parametros.size();
                i++) {

            int costo
                    = costoCompatibilidadParametro(
                            parametros.get(i),
                            argumentos.get(i)
                    );

            if (costo < 0) {
                return -1;
            }

            costoTotal += costo;
        }

        return costoTotal;
    }

    private List<ResultadoAccesoZ> obtenerArgumentosCompletos(
            ZParser.ListaArgumentosContext ctx) {

        List<ResultadoAccesoZ> argumentos
                = new ArrayList<>();

        if (ctx == null) {
            return argumentos;
        }

        for (ZParser.ExpresionContext expresion
                : ctx.expresion()) {

            argumentos.add(
                    obtenerResultadoExpresionCompleto(
                            expresion
                    )
            );
        }

        return argumentos;
    }

    private String describirArgumentos(
            List<ResultadoAccesoZ> argumentos) {

        List<String> partes
                = new ArrayList<>();

        for (ResultadoAccesoZ argumento
                : argumentos) {

            if (argumento == null
                    || !argumento.isValido()) {

                partes.add("desconocido");
                continue;
            }

            StringBuilder sb
                    = new StringBuilder(
                            argumento.getTipo()
                    );

            for (int i = 0;
                    i < argumento.getDimensiones();
                    i++) {

                sb.append("[]");
            }

            partes.add(
                    sb.toString()
            );
        }

        return partes.toString();
    }

    private String describirTipoCompleto(
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

}
