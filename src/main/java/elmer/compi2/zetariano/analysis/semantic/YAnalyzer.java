
package elmer.compi2.zetariano.analysis.semantic;

import elmer.compi2.zetariano.analysis.symbol.SymbolKind;
import elmer.compi2.zetariano.analysis.symbol.StructDef;
import elmer.compi2.zetariano.analysis.symbol.ParamInfo;
import elmer.compi2.zetariano.analysis.symbol.Symbol;
import elmer.compi2.zetariano.analysis.symbol.SymbolTable;
import elmer.compi2.zetariano.analysis.symbol.DataType;

import elmer.compi2.zetariano.antlr.ypython.YParser;
import elmer.compi2.zetariano.antlr.ypython.YParserBaseVisitor;
import elmer.compi2.zetariano.diagnostic.ErrorReport;
import elmer.compi2.zetariano.diagnostic.ErrorCollector;
import elmer.compi2.zetariano.diagnostic.ErrorKind;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


public class YAnalyzer extends YParserBaseVisitor<Void> {

    private int profundidadCiclos = 0;
    private int profundidadElegir = 0;
    private boolean registrandoFirmas = false;

    private final SymbolTable tabla
            = new SymbolTable();

    private DataType tipoRetornoActual
            = DataType.VOID;

    private String tipoReferenciaRetornoActual = null;

    public SymbolTable getTabla() {
        return tabla;
    }

    private final Map<String, StructDef> estructuras
            = new LinkedHashMap<>();

    private final Deque<Map<String, StructDef>> ambitosEstructuras
            = new ArrayDeque<>();

    private final Map<
        YParser.DefinicionFuncionContext, Symbol> funcionesRegistradas
            = new LinkedHashMap<>();

    private void error(
            String mensaje,
            org.antlr.v4.runtime.ParserRuleContext ctx) {

        ErrorCollector.addError(
                ErrorKind.SEMANTICO,
                mensaje,
                ctx.getStart().getLine(),
                ctx.getStart()
                        .getCharPositionInLine()
        );
    }

    private DataType convertirTipo(
            YParser.TipoContext ctx) {

        if (ctx == null) {
            return DataType.DESCONOCIDO;
        }

        String texto
                = ctx.getText();

        return switch (texto) {

            case "entero" ->
                DataType.ENTERO;

            case "flotante" ->
                DataType.DECIMAL;

            case "cadena" ->
                DataType.CADENA;

            case "caracter" ->
                DataType.CARACTER;

            case "bool" ->
                DataType.BOOLEANO;

            default ->
                DataType.ESTRUCTURA;
        };
    }

    private DataType convertirTipoPrimitivo(
            YParser.TipoPrimitivoContext ctx) {

        if (ctx == null) {
            return DataType.DESCONOCIDO;
        }

        return switch (ctx.getText()) {

            case "entero" ->
                DataType.ENTERO;

            case "flotante" ->
                DataType.DECIMAL;

            case "cadena" ->
                DataType.CADENA;

            case "caracter" ->
                DataType.CARACTER;

            case "bool" ->
                DataType.BOOLEANO;

            default ->
                DataType.DESCONOCIDO;
        };
    }

    
    //INICIO DE LOS VISIT
    
    @Override
    public Void visitDefinicionFuncion(
            YParser.DefinicionFuncionContext ctx) {

        /*
     * Las funciones se manejan desde
     * visitSeccionFunciones() en dos pasadas.
         */
        return null;
    }

    @Override
    public Void visitDeclaracionVariable(
            YParser.DeclaracionVariableContext ctx) {

        String nombre = ctx.IDENTIFICADOR().getText();

        if (tabla.existeEnAmbitoActual(nombre)) {

            error(
                    "La variable '"
                    + nombre
                    + "' ya fue declarada en este ámbito.",
                    ctx
            );

            return null;
        }

        DataType tipoBase = convertirTipo(ctx.tipo());

        String nombreTipo = ctx.tipo().getText();

        
        // VALIDAR ESTRUCTURA
        
        if (tipoBase == DataType.ESTRUCTURA) {

            if (!existeEstructura(nombreTipo)) {

                error(
                        "La estructura '"
                        + nombreTipo
                        + "' no ha sido declarada.",
                        ctx.tipo()
                );

                return null;
            }
        }

        boolean esArreglo
                = ctx.dimensiones() != null
                && !ctx.dimensiones().isEmpty();

        Symbol simbolo;

        
        // ARREGLO
        
        if (esArreglo) {

            simbolo = new Symbol(
                    nombre,
                    DataType.ARREGLO,
                    SymbolKind.ARREGLO,
                    tabla.getNivelActual(),
                    tabla.getAmbitoActual()
            );

            simbolo.setTipoElemento(tipoBase);

            if (tipoBase == DataType.ESTRUCTURA) {
                simbolo.setTipoReferencia(nombreTipo);
            }

            for (YParser.DimensionesContext dimension
                    : ctx.dimensiones()) {

                DataType tipoDimension
                        = obtenerTipoExpresion(
                                dimension.expresion()
                        );

                if (tipoDimension != DataType.ENTERO
                        && tipoDimension != DataType.DESCONOCIDO) {

                    error(
                            "El tamaño de un arreglo "
                            + "debe ser de tipo ENTERO.",
                            dimension
                    );
                }

                String texto
                        = dimension.expresion()
                                .getText();

                if (texto.matches("\\d+")) {

                    int tamano
                            = Integer.parseInt(texto);

                    if (tamano <= 0) {

                        error(
                                "El tamaño de un arreglo "
                                + "debe ser mayor que cero.",
                                dimension
                        );
                    }

                    simbolo.getDimensiones()
                            .add(tamano);

                } else {

                    simbolo.getDimensiones()
                            .add(-1);
                }
            }

        } else {

            simbolo = new Symbol(
                    nombre,
                    tipoBase,
                    SymbolKind.VARIABLE,
                    tabla.getNivelActual(),
                    tabla.getAmbitoActual()
            );

            if (tipoBase == DataType.ESTRUCTURA) {
                simbolo.setTipoReferencia(nombreTipo);
            }
        }

        
        // INICIALIZACIÓN
        
        if (ctx.inicializador() != null) {

            validarInicializadorVariable(
                    simbolo,
                    ctx.inicializador(),
                    nombre
            );
        }
        tabla.agregar(simbolo);

        return null;
    }

    @Override
    public Void visitAsignacion(
            YParser.AsignacionContext ctx) {

        
        // TIPO DEL DESTINO COMPLETO
        
        DataType tipoDestino
                = obtenerTipoAcceso(
                        ctx.acceso()
                );

        if (tipoDestino
                == DataType.DESCONOCIDO) {

            return null;
        }

        
        // TIPO DEL VALOR ASIGNADO
        
        DataType tipoRecibido
                = obtenerTipoExpresion(
                        ctx.expresion()
                );

        if (tipoRecibido
                == DataType.DESCONOCIDO) {

            return null;
        }

        
        // ASIGNACIÓN ENTRE ESTRUCTURAS
        
        if (tipoDestino == DataType.ESTRUCTURA
                && tipoRecibido == DataType.ESTRUCTURA) {

            String referenciaDestino
                    = obtenerTipoReferenciaAcceso(
                            ctx.acceso()
                    );

            String referenciaRecibida
                    = obtenerTipoReferenciaExpresion(
                            ctx.expresion()
                    );

            if (referenciaDestino != null
                    && referenciaRecibida != null
                    && !referenciaDestino.equals(
                            referenciaRecibida)) {

                error(
                        "No se puede asignar una estructura '"
                        + referenciaRecibida
                        + "' a una estructura '"
                        + referenciaDestino
                        + "'.",
                        ctx
                );

                return null;
            }
        }

        
        // VALIDAR COMPATIBILIDAD
        
        if (!compatibles(
                tipoDestino,
                tipoRecibido)) {

            error(
                    "Asignación incompatible para '"
                    + ctx.acceso().getText()
                    + "'. Se esperaba "
                    + tipoDestino
                    + " pero se recibió "
                    + tipoRecibido
                    + ".",
                    ctx
            );
        }

        return null;
    }

    @Override
    public Void visitRetorno(
            YParser.RetornoContext ctx) {

        if (tipoRetornoActual
                == DataType.VOID) {

            error(
                    "No se puede utilizar retornar "
                    + "dentro de una función sin retorno.",
                    ctx
            );

            return null;
        }

        DataType recibido
                = obtenerTipoExpresion(
                        ctx.expresion()
                );

        
        // RETORNO DE ESTRUCTURAS
        
        if (tipoRetornoActual == DataType.ESTRUCTURA
                && recibido == DataType.ESTRUCTURA) {

            String referenciaRecibida
                    = obtenerTipoReferenciaExpresion(
                            ctx.expresion()
                    );

            if (tipoReferenciaRetornoActual != null
                    && referenciaRecibida != null
                    && !tipoReferenciaRetornoActual.equals(
                            referenciaRecibida)) {

                error(
                        "Tipo de retorno incorrecto. "
                        + "La función espera una estructura '"
                        + tipoReferenciaRetornoActual
                        + "' pero retorna una estructura '"
                        + referenciaRecibida
                        + "'.",
                        ctx
                );

                return null;
            }
        }

        if (!compatibles(
                tipoRetornoActual,
                recibido)) {

            error(
                    "Tipo de retorno incorrecto. "
                    + "La función espera "
                    + tipoRetornoActual
                    + " pero retorna "
                    + recibido
                    + ".",
                    ctx
            );
        }

        return null;
    }

    @Override
    public Void visitLlamadaFuncion(
            YParser.LlamadaFuncionContext ctx) {

        obtenerTipoLlamada(ctx);

        return null;
    }

    @Override
    public Void visitSentenciaSi(
            YParser.SentenciaSiContext ctx) {

        DataType condicion
                = obtenerTipoExpresion(
                        ctx.expresion()
                );

        if (condicion != DataType.BOOLEANO
                && condicion != DataType.DESCONOCIDO) {

            error(
                    "La condición de 'si' debe ser booleana.",
                    ctx.expresion()
            );
        }

        // Bloque principal del SI.
        visitarBloqueConAmbito(
                ctx.bloque()
        );

        // Bloques SINO.
        for (YParser.BloqueSinoContext sino
                : ctx.bloqueSino()) {

            DataType condicionSino
                    = obtenerTipoExpresion(
                            sino.expresion()
                    );

            if (condicionSino
                    != DataType.BOOLEANO
                    && condicionSino
                    != DataType.DESCONOCIDO) {

                error(
                        "La condición de 'sino' debe ser booleana.",
                        sino.expresion()
                );
            }

            visitarBloqueConAmbito(
                    sino.bloque()
            );
        }

        // CONTRARIO.
        if (ctx.bloqueContrario() != null) {

            visitarBloqueConAmbito(
                    ctx.bloqueContrario()
                            .bloque()
            );
        }

        return null;
    }

    @Override
    public Void visitSentenciaMientras(
            YParser.SentenciaMientrasContext ctx) {

        DataType condicion
                = obtenerTipoExpresion(
                        ctx.expresion()
                );

        if (condicion != DataType.BOOLEANO
                && condicion != DataType.DESCONOCIDO) {

            error(
                    "La condición de 'mientras' "
                    + "debe ser booleana.",
                    ctx.expresion()
            );
        }

        profundidadCiclos++;

        visitarBloqueConAmbito(
                ctx.bloque()
        );

        profundidadCiclos--;

        return null;
    }

    @Override
    public Void visitSentenciaHacerMientras(
            YParser.SentenciaHacerMientrasContext ctx) {

        profundidadCiclos++;

        visitarBloqueConAmbito(
                ctx.bloque()
        );

        profundidadCiclos--;

        DataType condicion
                = obtenerTipoExpresion(
                        ctx.expresion()
                );

        if (condicion != DataType.BOOLEANO
                && condicion != DataType.DESCONOCIDO) {

            error(
                    "La condición final de hacer-mientras "
                    + "debe ser booleana.",
                    ctx.expresion()
            );
        }

        return null;
    }

    @Override
    public Void visitSentenciaPara(
            YParser.SentenciaParaContext ctx) {

        tabla.entrarAmbito();

        if (ctx.inicializacionPara() != null) {

            visit(
                    ctx.inicializacionPara()
            );
        }

        if (ctx.expresion() != null) {

            DataType condicion
                    = obtenerTipoExpresion(
                            ctx.expresion()
                    );

            if (condicion != DataType.BOOLEANO
                    && condicion
                    != DataType.DESCONOCIDO) {

                error(
                        "La condición del ciclo 'para' "
                        + "debe ser booleana.",
                        ctx.expresion()
                );
            }
        }

        if (ctx.actualizacionPara() != null) {

            visit(
                    ctx.actualizacionPara()
            );
        }

        profundidadCiclos++;

        /*
     * El cuerpo tendrá un ámbito todavía
     * más interno.
         */
        visitarBloqueConAmbito(
                ctx.bloque()
        );

        profundidadCiclos--;

        tabla.salirAmbito();

        return null;
    }

    @Override
    public Void visitIncrementoDecremento(
            YParser.IncrementoDecrementoContext ctx) {

        DataType tipo
                = obtenerTipoAcceso(
                        ctx.acceso()
                );

        if (tipo
                == DataType.DESCONOCIDO) {

            return null;
        }

        if (!esNumerico(tipo)) {

            error(
                    "Los operadores ++ y -- "
                    + "solo pueden aplicarse "
                    + "a valores numéricos. "
                    + "El acceso '"
                    + ctx.acceso().getText()
                    + "' es de tipo "
                    + tipo
                    + ".",
                    ctx
            );
        }

        return null;
    }

    @Override
    public Void visitSentencia(
            YParser.SentenciaContext ctx) {

        if (ctx.ROMPER() != null) {

            if (profundidadCiclos == 0
                    && profundidadElegir == 0) {

                error(
                        "'romper' solo puede utilizarse "
                        + "dentro de un ciclo o una sentencia 'elegir'.",
                        ctx
                );
            }

            return null;
        }

        if (ctx.CONTINUAR() != null) {

            if (profundidadCiclos == 0) {

                error(
                        "'continuar' solo puede utilizarse "
                        + "dentro de un ciclo.",
                        ctx
                );
            }

            return null;
        }

        return visitChildren(ctx);
    }

    @Override
    public Void visitDefinicionEstructura(
            YParser.DefinicionEstructuraContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR()
                        .getText();

        
        // EVITAR DUPLICADO EN EL MISMO ÁMBITO
        
        if (existeEstructuraEnAmbitoActual(nombre)) {

            error(
                    "La estructura '"
                    + nombre
                    + "' ya fue declarada en este ámbito.",
                    ctx
            );

            return null;
        }

        StructDef estructura
                = new StructDef(
                        nombre
                );

        

        // REGISTRAR PRIMERO PARA PERMITIR REFERENCIAS POSTERIORES
        
        registrarEstructuraEnAmbitoActual(
                nombre,
                estructura
        );

        
        // REGISTRAR ATRIBUTOS
        
        for (YParser.AtributoEstructuraContext atributoCtx
                : ctx.atributoEstructura()) {

            registrarAtributoEstructura(
                    estructura,
                    atributoCtx
            );
        }

        return null;
    }

    @Override
    public Void visitSeccionFunciones(
            YParser.SeccionFuncionesContext ctx) {

        
        // PASADA 1
        // Registrar todas las firmas
        
        registrandoFirmas = true;

        for (YParser.DefinicionFuncionContext funcionCtx
                : ctx.definicionFuncion()) {

            registrarFirmaFuncion(funcionCtx);
        }

        
        // PASADA 2
        // Analizar los cuerpos
        
        registrandoFirmas = false;

        for (YParser.DefinicionFuncionContext funcionCtx
                : ctx.definicionFuncion()) {

            analizarCuerpoFuncion(funcionCtx);
        }

        return null;
    }

    @Override
    public Void visitSentenciaElegir(
            YParser.SentenciaElegirContext ctx) {

        
        // TIPO DE LA EXPRESIÓN DEL ELEGIR
        
        DataType tipoSelector
                = obtenerTipoExpresion(
                        ctx.expresion()
                );

        profundidadElegir++;

        
        // CASOS
        
        for (YParser.CasoElegirContext caso
                : ctx.casoElegir()) {

            DataType tipoCaso
                    = obtenerTipoExpresion(
                            caso.expresion()
                    );

            
            // SELECTOR Y CASO DEBEN SER COMPARABLES
            
            if (!tiposComparables(
                    tipoSelector,
                    tipoCaso)) {

                error(
                        "El valor del 'caso' de tipo "
                        + tipoCaso
                        + " no es compatible con "
                        + "la expresión de 'elegir' de tipo "
                        + tipoSelector
                        + ".",
                        caso.expresion()
                );
            }

            visitarBloqueConAmbito(
                    caso.bloque()
            );
        }

        
        // SIEMPRE
        
        if (ctx.siempreElegir() != null) {

            visitarBloqueConAmbito(
                    ctx.siempreElegir()
                            .bloque()
            );
        }

        profundidadElegir--;

        return null;
    }

    @Override
    public Void visitImpresion(
            YParser.ImpresionContext ctx) {

        if (ctx.argumentos() == null) {
            return null;
        }

        for (YParser.ExpresionContext expresion
                : ctx.argumentos().expresion()) {

            obtenerTipoExpresion(
                    expresion
            );
        }

        return null;
    }

    
    // FUNCIONES Y PROCEDIMIENTOS AUXILIARES A VISIT
    
    private DataType obtenerTipoParametro(
            YParser.ParametroContext ctx) {

        if (ctx.parametroValor() != null) {

            return convertirTipoPrimitivo(
                    ctx.parametroValor()
                            .tipoPrimitivo()
            );
        }

        if (ctx.parametroArreglo() != null) {

            return DataType.ARREGLO;
        }

        if (ctx.parametroEstructura() != null) {

            return DataType.ESTRUCTURA;
        }

        return DataType.DESCONOCIDO;
    }

    private void registrarParametro(
            YParser.ParametroContext ctx) {

        String nombre;
        DataType tipo;

        String tipoReferencia = null;
        DataType tipoElemento = null;

        boolean esArreglo = false;

        
        // 1. PARÁMETRO PRIMITIVO
        //
        // entero numero
        // flotante valor
        
        if (ctx.parametroValor() != null) {

            YParser.ParametroValorContext valor
                    = ctx.parametroValor();

            nombre = valor.IDENTIFICADOR()
                    .getText();

            tipo = convertirTipoPrimitivo(
                    valor.tipoPrimitivo()
            );
        } 
        // 2. PARÁMETRO ARREGLO POR REFERENCIA
        //
        // [] entero numeros
        // [] Persona personas
        
        else if (ctx.parametroArreglo() != null) {

            YParser.ParametroArregloContext arreglo
                    = ctx.parametroArreglo();

            nombre = arreglo.IDENTIFICADOR()
                    .getText();

            tipo = DataType.ARREGLO;
            esArreglo = true;

            tipoElemento = convertirTipo(
                    arreglo.tipo()
            );

            // Si es arreglo de estructuras:
            //
            // [] Persona personas
            if (tipoElemento == DataType.ESTRUCTURA) {

                tipoReferencia = arreglo.tipo()
                        .getText();

                if (!existeEstructura(
                        tipoReferencia)) {

                    error(
                            "La estructura '"
                            + tipoReferencia
                            + "' utilizada en el parámetro '"
                            + nombre
                            + "' no ha sido declarada.",
                            arreglo
                    );
                }

            }
        } 
        // 3. PARÁMETRO ESTRUCTURA POR REFERENCIA
        //
        // {} Persona persona
        
        else if (ctx.parametroEstructura() != null) {

            YParser.ParametroEstructuraContext estructuraCtx
                    = ctx.parametroEstructura();

            tipoReferencia
                    = estructuraCtx.IDENTIFICADOR(0)
                            .getText();

            nombre
                    = estructuraCtx.IDENTIFICADOR(1)
                            .getText();

            tipo = DataType.ESTRUCTURA;

            if (!existeEstructura(
                    tipoReferencia)) {

                error(
                        "La estructura '"
                        + tipoReferencia
                        + "' utilizada en el parámetro '"
                        + nombre
                        + "' no ha sido declarada.",
                        estructuraCtx
                );
            }
        } 
        // 4. ERROR INTERNO
        
        else {

            error(
                    "No se pudo determinar el tipo del parámetro.",
                    ctx
            );

            return;
        }

        
        // 5. DUPLICADO
        
        if (tabla.existeEnAmbitoActual(nombre)) {

            error(
                    "El parámetro '"
                    + nombre
                    + "' ya existe.",
                    ctx
            );

            return;
        }

        
        // 6. CREAR SÍMBOLO
        
        Symbol simbolo
                = new Symbol(
                        nombre,
                        tipo,
                        SymbolKind.PARAMETRO,
                        tabla.getNivelActual(),
                        tabla.getAmbitoActual()
                );

        simbolo.setTipoReferencia(
                tipoReferencia
        );

        simbolo.setTipoElemento(
                tipoElemento
        );

        
        // 7. DIMENSIÓN DEL PARÁMETRO ARREGLO
        
        if (esArreglo) {

        
            simbolo.getDimensiones()
                    .add(-1);
        }

        tabla.agregar(simbolo);
    }

    private boolean compatibles(
            DataType esperado,
            DataType recibido) {

        if (esperado
                == DataType.DESCONOCIDO
                || recibido
                == DataType.DESCONOCIDO) {

            return true;
        }

        if (esperado == recibido) {
            return true;
        }

        // Promoción implícita:
        // entero -> flotante
        return esperado
                == DataType.DECIMAL
                && recibido
                == DataType.ENTERO;
    }

    private DataType obtenerTipoExpresion(
            YParser.ExpresionContext ctx) {

        if (ctx == null) {
            return DataType.DESCONOCIDO;
        }

        return obtenerTipoOr(
                ctx.expresionOr()
        );
    }

    
    // OR
    
    private DataType obtenerTipoOr(
            YParser.ExpresionOrContext ctx) {

        DataType tipoActual
                = obtenerTipoAnd(
                        ctx.expresionAnd(0)
                );

        for (int i = 1;
                i < ctx.expresionAnd().size();
                i++) {

            DataType derecho
                    = obtenerTipoAnd(
                            ctx.expresionAnd(i)
                    );

            if (tipoActual != DataType.BOOLEANO
                    || derecho != DataType.BOOLEANO) {

                error(
                        "El operador || requiere operandos booleanos.",
                        ctx
                );

                tipoActual
                        = DataType.DESCONOCIDO;

            } else {

                tipoActual
                        = DataType.BOOLEANO;
            }
        }

        return tipoActual;
    }

    
    // AND
    
    private DataType obtenerTipoAnd(
            YParser.ExpresionAndContext ctx) {

        DataType tipoActual
                = obtenerTipoIgualdad(
                        ctx.expresionIgualdad(0)
                );

        for (int i = 1;
                i < ctx.expresionIgualdad().size();
                i++) {

            DataType derecho
                    = obtenerTipoIgualdad(
                            ctx.expresionIgualdad(i)
                    );

            if (tipoActual != DataType.BOOLEANO
                    || derecho != DataType.BOOLEANO) {

                error(
                        "El operador && requiere operandos booleanos.",
                        ctx
                );

                tipoActual
                        = DataType.DESCONOCIDO;

            } else {

                tipoActual
                        = DataType.BOOLEANO;
            }
        }

        return tipoActual;
    }

    
    // IGUALDAD
    // ==
    // !=
    
    private DataType obtenerTipoIgualdad(
            YParser.ExpresionIgualdadContext ctx) {

        DataType tipoActual
                = obtenerTipoRelacional(
                        ctx.expresionRelacional(0)
                );

        for (int i = 1;
                i < ctx.expresionRelacional().size();
                i++) {

            DataType derecho
                    = obtenerTipoRelacional(
                            ctx.expresionRelacional(i)
                    );

            if (!tiposComparables(
                    tipoActual,
                    derecho)) {

                error(
                        "No se pueden comparar valores de tipo "
                        + tipoActual
                        + " y "
                        + derecho
                        + ".",
                        ctx
                );
            }

            tipoActual
                    = DataType.BOOLEANO;
        }

        return tipoActual;
    }

    
    // RELACIONALES
    // <
    // >
    
    private DataType obtenerTipoRelacional(
            YParser.ExpresionRelacionalContext ctx) {

        DataType tipoActual
                = obtenerTipoAditiva(
                        ctx.expresionAditiva(0)
                );

        for (int i = 1;
                i < ctx.expresionAditiva().size();
                i++) {

            DataType derecho
                    = obtenerTipoAditiva(
                            ctx.expresionAditiva(i)
                    );

            if (!esNumerico(tipoActual)
                    || !esNumerico(derecho)) {

                error(
                        "Los operadores relacionales < y > "
                        + "requieren operandos numéricos.",
                        ctx
                );
            }

            tipoActual
                    = DataType.BOOLEANO;
        }

        return tipoActual;
    }

    
    // ADITIVA
    // +
    // -
    
    private DataType obtenerTipoAditiva(
            YParser.ExpresionAditivaContext ctx) {

        DataType tipoActual
                = obtenerTipoMultiplicativa(
                        ctx.expresionMultiplicativa(0)
                );

        for (int i = 1;
                i < ctx.expresionMultiplicativa().size();
                i++) {

            DataType derecho
                    = obtenerTipoMultiplicativa(
                            ctx.expresionMultiplicativa(i)
                    );

            String operador
                    = ctx.getChild(
                            i * 2 - 1
                    ).getText();

            if (operador.equals("+")) {

                tipoActual
                        = resolverSuma(
                                tipoActual,
                                derecho,
                                ctx
                        );

            } else {

                tipoActual
                        = resolverOperacionNumerica(
                                tipoActual,
                                derecho,
                                "-",
                                ctx
                        );
            }
        }

        return tipoActual;
    }

    
    // MULTIPLICATIVA
    // *
    // /
    
    private DataType obtenerTipoMultiplicativa(
            YParser.ExpresionMultiplicativaContext ctx) {

        DataType tipoActual
                = obtenerTipoUnaria(
                        ctx.expresionUnaria(0)
                );

        for (int i = 1;
                i < ctx.expresionUnaria().size();
                i++) {

            DataType derecho
                    = obtenerTipoUnaria(
                            ctx.expresionUnaria(i)
                    );

            String operador
                    = ctx.getChild(
                            i * 2 - 1
                    ).getText();

            tipoActual
                    = resolverOperacionNumerica(
                            tipoActual,
                            derecho,
                            operador,
                            ctx
                    );
        }

        return tipoActual;
    }

    
    // UNARIOS
    // !
    // -
    
    private DataType obtenerTipoUnaria(
            YParser.ExpresionUnariaContext ctx) {

        if (ctx.NOT() != null) {

            DataType tipo
                    = obtenerTipoUnaria(
                            ctx.expresionUnaria()
                    );

            if (tipo != DataType.BOOLEANO) {

                error(
                        "El operador ! requiere una expresión booleana.",
                        ctx
                );

                return DataType.DESCONOCIDO;
            }

            return DataType.BOOLEANO;
        }

        if (ctx.MENOS() != null) {

            DataType tipo
                    = obtenerTipoUnaria(
                            ctx.expresionUnaria()
                    );

            if (!esNumerico(tipo)) {

                error(
                        "El operador unario - requiere "
                        + "una expresión numérica.",
                        ctx
                );

                return DataType.DESCONOCIDO;
            }

            return tipo;
        }

        return obtenerTipoPrimaria(
                ctx.expresionPrimaria()
        );
    }

    
    // PRIMARIAS
    
    private DataType obtenerTipoPrimaria(
            YParser.ExpresionPrimariaContext ctx) {

        if (ctx.ENTERO() != null) {
            return DataType.ENTERO;
        }

        if (ctx.DECIMAL() != null) {
            return DataType.DECIMAL;
        }

        if (ctx.CADENA() != null) {
            return DataType.CADENA;
        }

        if (ctx.CARACTER() != null) {
            return DataType.CARACTER;
        }

        if (ctx.VERDADERO() != null
                || ctx.FALSO() != null) {

            return DataType.BOOLEANO;
        }

        if (ctx.acceso() != null) {

            return obtenerTipoAcceso(
                    ctx.acceso()
            );
        }

        if (ctx.llamadaFuncion() != null) {

            return obtenerTipoLlamada(
                    ctx.llamadaFuncion()
            );
        }

        if (ctx.lectura() != null) {

            return DataType.CADENA;
        }

        if (ctx.expresion() != null) {

            return obtenerTipoExpresion(
                    ctx.expresion()
            );
        }

        return DataType.DESCONOCIDO;
    }

    
    // ACCESOS
    
    private DataType obtenerTipoAcceso(
            YParser.AccesoContext ctx) {

        String nombreBase
                = ctx.IDENTIFICADOR()
                        .getText();

        Symbol actual
                = tabla.buscar(nombreBase);

        if (actual == null) {

            error(
                    "La variable '"
                    + nombreBase
                    + "' no ha sido declarada.",
                    ctx
            );

            return DataType.DESCONOCIDO;
        }

        DataType tipoActual
                = actual.getTipo();

        String estructuraActual
                = actual.getTipoReferencia();

        int dimensionesRestantes = 0;

        if (tipoActual == DataType.ARREGLO) {

            boolean parametroRangoDinamico
                    = actual.getCategoria()
                    == SymbolKind.PARAMETRO
                    && actual.getDimensiones().size() == 1
                    && actual.getDimensiones().get(0) == -1;

            if (parametroRangoDinamico) {

                for (YParser.SufijoAccesoContext sufijo
                        : ctx.sufijoAcceso()) {

                    if (sufijo.expresion() == null) {
                        break;
                    }

                    dimensionesRestantes++;
                }

            } else {

                dimensionesRestantes
                        = actual.getDimensiones().size();
            }
        }

        for (YParser.SufijoAccesoContext sufijo
                : ctx.sufijoAcceso()) {

            // ====================================================
            // ACCESO [EXPRESION]
            // ====================================================
            if (sufijo.expresion() != null) {

                if (tipoActual != DataType.ARREGLO
                        || dimensionesRestantes <= 0) {

                    error(
                            "Se intentó indexar un valor "
                            + "que no es un arreglo "
                            + "o se utilizaron demasiados índices.",
                            sufijo
                    );

                    return DataType.DESCONOCIDO;
                }

                DataType indice
                        = obtenerTipoExpresion(
                                sufijo.expresion()
                        );

                if (indice != DataType.ENTERO
                        && indice != DataType.DESCONOCIDO) {

                    error(
                            "El índice de un arreglo "
                            + "debe ser de tipo ENTERO.",
                            sufijo.expresion()
                    );
                }

                dimensionesRestantes--;

                if (dimensionesRestantes > 0) {

                    tipoActual
                            = DataType.ARREGLO;

                } else {

                    /*
                 * Se consumieron todas las dimensiones.
                     */
                    tipoActual
                            = actual.getTipoElemento();

                    estructuraActual
                            = actual.getTipoReferencia();
                }

                continue;
            }

            // ====================================================
            // ACCESO .ATRIBUTO
            // ====================================================
            String nombreAtributo
                    = sufijo.IDENTIFICADOR()
                            .getText();

            if (tipoActual == DataType.ARREGLO) {

                error(
                        "No se puede acceder al atributo '"
                        + nombreAtributo
                        + "' sin consumir primero "
                        + "las dimensiones del arreglo.",
                        sufijo
                );

                return DataType.DESCONOCIDO;
            }

            if (tipoActual != DataType.ESTRUCTURA) {

                error(
                        "No se puede acceder al atributo '"
                        + nombreAtributo
                        + "' porque el valor actual "
                        + "no es una estructura.",
                        sufijo
                );

                return DataType.DESCONOCIDO;
            }

            StructDef estructura
                    = buscarEstructura(
                            estructuraActual
                    );

            if (estructura == null) {

                error(
                        "No existe la definición de la estructura '"
                        + estructuraActual
                        + "'.",
                        sufijo
                );

                return DataType.DESCONOCIDO;
            }

            Symbol atributo
                    = estructura.buscarAtributo(
                            nombreAtributo
                    );

            if (atributo == null) {

                error(
                        "La estructura '"
                        + estructuraActual
                        + "' no contiene el atributo '"
                        + nombreAtributo
                        + "'.",
                        sufijo
                );

                return DataType.DESCONOCIDO;
            }

            actual = atributo;
            tipoActual = atributo.getTipo();
            estructuraActual = atributo.getTipoReferencia();

            dimensionesRestantes
                    = tipoActual == DataType.ARREGLO
                            ? atributo.getDimensiones().size()
                            : 0;
        }

        return tipoActual;
    }

    
    // LLAMADAS A FUNCIONES
    
    private DataType obtenerTipoLlamada(
            YParser.LlamadaFuncionContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR()
                        .getText();

        Symbol funcion
                = tabla.buscar(nombre);

        if (funcion == null) {

            error(
                    "La función '"
                    + nombre
                    + "' no ha sido declarada.",
                    ctx
            );

            return DataType.DESCONOCIDO;
        }

        if (funcion.getCategoria()
                != SymbolKind.FUNCION) {

            error(
                    "'"
                    + nombre
                    + "' no es una función.",
                    ctx
            );

            return DataType.DESCONOCIDO;
        }

        int cantidadArgumentos
                = ctx.argumentos() == null
                ? 0
                : ctx.argumentos()
                        .expresion()
                        .size();

        int cantidadParametros
                = funcion.getParametrosInfo()
                        .size();

        
        // CONSISTENCIA INTERNA DE LA FIRMA
        
        if (funcion.getParametros().size()
                != funcion.getParametrosInfo().size()) {

            error(
                    "Error interno en la firma de la función '"
                    + nombre
                    + "'. La información detallada "
                    + "de sus parámetros no está completa.",
                    ctx
            );

            return funcion.getTipo();
        }

        
        // CANTIDAD DE ARGUMENTOS
        
        if (cantidadArgumentos
                != cantidadParametros) {

            error(
                    "La función '"
                    + nombre
                    + "' espera "
                    + cantidadParametros
                    + " argumento(s), pero recibió "
                    + cantidadArgumentos
                    + ".",
                    ctx
            );

            return funcion.getTipo();
        }

        
        // VALIDAR CADA ARGUMENTO
        
        if (ctx.argumentos() != null) {

            for (int i = 0;
                    i < cantidadArgumentos;
                    i++) {

                YParser.ExpresionContext argumento
                        = ctx.argumentos()
                                .expresion(i);

                ParamInfo esperado
                        = funcion.getParametrosInfo()
                                .get(i);

                boolean valido
                        = validarParametro(
                                esperado,
                                argumento
                        );

                if (!valido) {

                    
                    // PARÁMETRO POR REFERENCIA
                    
                    if (esperado.isPorReferencia()) {

                        Symbol simboloArgumento
                                = obtenerSymbolArgumento(
                                        argumento
                                );

                        if (simboloArgumento == null) {

                            error(
                                    "El parámetro '"
                                    + esperado.getNombre()
                                    + "' debe recibir "
                                    + describirParametro(esperado)
                                    + " mediante una variable por referencia.",
                                    argumento
                            );

                            continue;
                        }
                    }

                    
                    // INCOMPATIBILIDAD DE TIPOS
                    
                    DataType recibido
                            = obtenerTipoExpresion(
                                    argumento
                            );

                    error(
                            "Argumento "
                            + (i + 1)
                            + " incompatible en la función '"
                            + nombre
                            + "'. Se esperaba "
                            + describirParametro(esperado)
                            + " pero se recibió "
                            + recibido
                            + ".",
                            argumento
                    );
                }
            }
        }

        return funcion.getTipo();
    }

    
    // SUMA
    
    private DataType resolverSuma(
            DataType izquierdo,
            DataType derecho,
            org.antlr.v4.runtime.ParserRuleContext ctx) {

        // entero + entero
        if (izquierdo == DataType.ENTERO
                && derecho == DataType.ENTERO) {

            return DataType.ENTERO;
        }

        // combinación de entero y flotante
        if (esNumerico(izquierdo)
                && esNumerico(derecho)) {

            return DataType.DECIMAL;
        }

        if (izquierdo == DataType.CADENA
                && derecho == DataType.CADENA) {

            return DataType.CADENA;
        }

        error(
                "No se puede aplicar el operador + "
                + "entre "
                + izquierdo
                + " y "
                + derecho
                + ".",
                ctx
        );

        return DataType.DESCONOCIDO;
    }


// OPERACIONES NUMÉRICAS

    private DataType resolverOperacionNumerica(
            DataType izquierdo,
            DataType derecho,
            String operador,
            org.antlr.v4.runtime.ParserRuleContext ctx) {

        if (!esNumerico(izquierdo)
                || !esNumerico(derecho)) {

            error(
                    "El operador '"
                    + operador
                    + "' requiere operandos numéricos. "
                    + "Se recibió "
                    + izquierdo
                    + " y "
                    + derecho
                    + ".",
                    ctx
            );

            return DataType.DESCONOCIDO;
        }

        if (izquierdo == DataType.DECIMAL
                || derecho == DataType.DECIMAL) {

            return DataType.DECIMAL;
        }

        return DataType.ENTERO;
    }


// UTILIDADES DE TIPOS

    private boolean esNumerico(
            DataType tipo) {

        return tipo == DataType.ENTERO
                || tipo == DataType.DECIMAL;
    }

    private boolean tiposComparables(
            DataType izquierdo,
            DataType derecho) {

        if (izquierdo == DataType.DESCONOCIDO
                || derecho == DataType.DESCONOCIDO) {

            return true;
        }

        if (izquierdo == derecho) {
            return true;
        }

        return esNumerico(izquierdo)
                && esNumerico(derecho);
    }

    private void visitarBloqueConAmbito(
            YParser.BloqueContext ctx) {

        tabla.entrarAmbito();

        visit(ctx);

        tabla.salirAmbito();
    }

    private void registrarAtributoEstructura(
            StructDef estructura,
            YParser.AtributoEstructuraContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR()
                        .getText();

        if (estructura.existeAtributo(nombre)) {

            error(
                    "El atributo '"
                    + nombre
                    + "' ya existe en la estructura '"
                    + estructura.getNombre()
                    + "'.",
                    ctx
            );

            return;
        }

        DataType tipoBase
                = convertirTipo(
                        ctx.tipo()
                );

        if (tipoBase == DataType.ESTRUCTURA) {

            String nombreTipo
                    = ctx.tipo()
                            .getText();

            if (!existeEstructura(
                    nombreTipo)) {

                error(
                        "La estructura '"
                        + nombreTipo
                        + "' utilizada por el atributo '"
                        + nombre
                        + "' no ha sido declarada.",
                        ctx
                );
            }
        }

        boolean esArreglo
                = !ctx.dimensionConstante()
                        .isEmpty();

        Symbol atributo;

        if (esArreglo) {

            atributo = new Symbol(
                    nombre,
                    DataType.ARREGLO,
                    SymbolKind.ATRIBUTO,
                    0,
                    0
            );

            atributo.setTipoElemento(
                    tipoBase
            );

            if (tipoBase
                    == DataType.ESTRUCTURA) {

                atributo.setTipoReferencia(
                        ctx.tipo()
                                .getText()
                );
            }

            for (YParser.DimensionConstanteContext dim
                    : ctx.dimensionConstante()) {

                int tamano
                        = Integer.parseInt(
                                dim.ENTERO()
                                        .getText()
                        );

                if (tamano <= 0) {

                    error(
                            "El tamaño de un arreglo debe ser mayor que cero.",
                            dim
                    );
                }

                atributo.getDimensiones()
                        .add(tamano);
            }

        } else {

            atributo = new Symbol(
                    nombre,
                    tipoBase,
                    SymbolKind.ATRIBUTO,
                    0,
                    0
            );

            if (tipoBase
                    == DataType.ESTRUCTURA) {

                atributo.setTipoReferencia(
                        ctx.tipo()
                                .getText()
                );
            }
        }

        estructura.agregarAtributo(
                atributo
        );
    }

    public Map<String, StructDef> getEstructuras() {
        return estructuras;
    }

    private ParamInfo construirParamInfo(
            YParser.ParametroContext ctx) {

        
        // PRIMITIVO POR VALOR
        // entero x
        
        if (ctx.parametroValor() != null) {

            YParser.ParametroValorContext valor
                    = ctx.parametroValor();

            String nombre
                    = valor.IDENTIFICADOR()
                            .getText();

            DataType tipo
                    = convertirTipoPrimitivo(
                            valor.tipoPrimitivo()
                    );

            return new ParamInfo(
                    nombre,
                    tipo,
                    null,
                    null,
                    false
            );
        }

        
        // ARREGLO POR REFERENCIA
        // [] entero numeros
        // [] Persona personas
        
        if (ctx.parametroArreglo() != null) {

            YParser.ParametroArregloContext arreglo
                    = ctx.parametroArreglo();

            String nombre
                    = arreglo.IDENTIFICADOR()
                            .getText();

            DataType tipoElemento
                    = convertirTipo(
                            arreglo.tipo()
                    );

            String tipoReferencia = null;

            if (tipoElemento == DataType.ESTRUCTURA) {

                tipoReferencia
                        = arreglo.tipo()
                                .getText();
            }

            return new ParamInfo(
                    nombre,
                    DataType.ARREGLO,
                    tipoElemento,
                    tipoReferencia,
                    true
            );
        }

        
        // ESTRUCTURA POR REFERENCIA
        // {} Persona persona
        
        if (ctx.parametroEstructura() != null) {

            YParser.ParametroEstructuraContext estructura
                    = ctx.parametroEstructura();

            String tipoReferencia
                    = estructura.IDENTIFICADOR(0)
                            .getText();

            String nombre
                    = estructura.IDENTIFICADOR(1)
                            .getText();

            return new ParamInfo(
                    nombre,
                    DataType.ESTRUCTURA,
                    null,
                    tipoReferencia,
                    true
            );
        }

        return new ParamInfo(
                "?",
                DataType.DESCONOCIDO,
                null,
                null,
                false
        );
    }

    private Symbol obtenerSymbolArgumento(
            YParser.ExpresionContext expresion) {

        try {

            YParser.ExpresionPrimariaContext primaria
                    = expresion
                            .expresionOr()
                            .expresionAnd(0)
                            .expresionIgualdad(0)
                            .expresionRelacional(0)
                            .expresionAditiva(0)
                            .expresionMultiplicativa(0)
                            .expresionUnaria(0)
                            .expresionPrimaria();

            
            // PARA PASO POR REFERENCIA SOLO ACEPTAMOS UN ACCESO
            
            if (primaria == null
                    || primaria.acceso() == null) {

                return null;
            }

            YParser.AccesoContext acceso
                    = primaria.acceso();

            
            // VARIABLE DIRECTA
            //
            // persona
            // personas
            
            if (acceso.sufijoAcceso().isEmpty()) {

                return tabla.buscar(
                        acceso.IDENTIFICADOR()
                                .getText()
                );
            }

            
            // ACCESO COMPLEJO
            //
            // persona.direccion
            // personas[0]
            // personas[0].direccion
            
            DataType tipoFinal
                    = obtenerTipoAcceso(
                            acceso
                    );

            if (tipoFinal
                    == DataType.DESCONOCIDO) {

                return null;
            }

            Symbol simboloTemporal
                    = new Symbol(
                            acceso.getText(),
                            tipoFinal,
                            SymbolKind.VARIABLE,
                            tabla.getNivelActual(),
                            tabla.getAmbitoActual()
                    );

            
            // SI EL RESULTADO FINAL ES UNA ESTRUCTURA
            
            if (tipoFinal
                    == DataType.ESTRUCTURA) {

                String tipoReferencia
                        = obtenerTipoReferenciaAcceso(
                                acceso
                        );

                simboloTemporal.setTipoReferencia(
                        tipoReferencia
                );
            }

            return simboloTemporal;

        } catch (Exception ex) {

            return null;
        }
    }

    private boolean validarParametro(
            ParamInfo esperado,
            YParser.ExpresionContext argumento) {

        DataType recibido
                = obtenerTipoExpresion(
                        argumento
                );

        
        // PRIMITIVO POR VALOR
        
        if (!esperado.isPorReferencia()) {

            return compatibles(
                    esperado.getTipo(),
                    recibido
            );
        }

        
        // POR REFERENCIA
        
        Symbol simboloArgumento
                = obtenerSymbolArgumento(
                        argumento
                );

        if (simboloArgumento == null) {
            return false;
        }

        
        // ESTRUCTURA
        
        if (esperado.getTipo()
                == DataType.ESTRUCTURA) {

            if (simboloArgumento.getTipo()
                    != DataType.ESTRUCTURA) {

                return false;
            }

            return esperado.getTipoReferencia()
                    .equals(
                            simboloArgumento
                                    .getTipoReferencia()
                    );
        }

        
        // ARREGLO
        
        if (esperado.getTipo()
                == DataType.ARREGLO) {

            if (simboloArgumento.getTipo()
                    != DataType.ARREGLO) {

                return false;
            }

            if (esperado.getTipoElemento()
                    != simboloArgumento
                            .getTipoElemento()) {

                return false;
            }

            /*
         * Si son arreglos de estructuras:
         *
         * [] Persona
         *
         * también comparamos Persona.
             */
            if (esperado.getTipoElemento()
                    == DataType.ESTRUCTURA) {

                return esperado.getTipoReferencia()
                        .equals(
                                simboloArgumento
                                        .getTipoReferencia()
                        );
            }

            return true;
        }

        return false;
    }

    private String describirParametro(
            ParamInfo parametro) {

        if (parametro.getTipo()
                == DataType.ESTRUCTURA) {

            return "ESTRUCTURA "
                    + parametro.getTipoReferencia();
        }

        if (parametro.getTipo()
                == DataType.ARREGLO) {

            if (parametro.getTipoElemento()
                    == DataType.ESTRUCTURA) {

                return "ARREGLO DE "
                        + parametro.getTipoReferencia();
            }

            return "ARREGLO DE "
                    + parametro.getTipoElemento();
        }

        return parametro.getTipo()
                .toString();
    }

    private void registrarFirmaFuncion(
            YParser.DefinicionFuncionContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR()
                        .getText();

        DataType retorno
                = ctx.retornoFuncion() != null
                ? convertirTipo(
                        ctx.retornoFuncion()
                                .tipo()
                )
                : DataType.VOID;

        String tipoReferenciaRetorno = null;

        
        // VALIDAR TIPO DE RETORNO ESTRUCTURA
        
        if (ctx.retornoFuncion() != null
                && retorno == DataType.ESTRUCTURA) {

            tipoReferenciaRetorno
                    = ctx.retornoFuncion()
                            .tipo()
                            .getText();

            if (!existeEstructura(
                    tipoReferenciaRetorno)) {

                error(
                        "La estructura '"
                        + tipoReferenciaRetorno
                        + "' utilizada como tipo de retorno "
                        + "de la función '"
                        + nombre
                        + "' no ha sido declarada.",
                        ctx.retornoFuncion()
                );
            }
        }

        
        // FUNCIÓN DUPLICADA
        
        if (tabla.existeEnAmbitoActual(nombre)) {

            error(
                    "La función '"
                    + nombre
                    + "' ya fue declarada.",
                    ctx
            );

            return;
        }

        
        // CREAR FUNCIÓN
        
        Symbol funcion
                = new Symbol(
                        nombre,
                        retorno,
                        SymbolKind.FUNCION,
                        tabla.getNivelActual(),
                        tabla.getAmbitoActual()
                );

        if (retorno == DataType.ESTRUCTURA) {

            funcion.setTipoReferencia(
                    tipoReferenciaRetorno
            );
        }

        
        // REGISTRAR FIRMA
        
        if (ctx.parametros() != null) {

            for (YParser.ParametroContext parametro
                    : ctx.parametros()
                            .parametro()) {

                funcion.getParametros().add(
                        obtenerTipoParametro(
                                parametro
                        )
                );

                funcion.getParametrosInfo().add(
                        construirParamInfo(
                                parametro
                        )
                );
            }
        }

        tabla.agregar(funcion);

        funcionesRegistradas.put(
                ctx,
                funcion
        );
    }

    private void analizarCuerpoFuncion(
            YParser.DefinicionFuncionContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR()
                        .getText();

        Symbol funcion
                = funcionesRegistradas.get(ctx);

        if (funcion == null) {
            return;
        }

        tabla.entrarAmbito();

        ambitosEstructuras.push(
                new LinkedHashMap<>()
        );

        
        // GUARDAR CONTEXTO DE RETORNO ANTERIOR
        
        DataType retornoAnterior
                = tipoRetornoActual;

        String referenciaRetornoAnterior
                = tipoReferenciaRetornoActual;

        
        // ESTABLECER RETORNO DE LA FUNCIÓN ACTUAL
        
        tipoRetornoActual
                = funcion.getTipo();

        tipoReferenciaRetornoActual
                = funcion.getTipoReferencia();

        
        // REGISTRAR PARÁMETROS DEL ÁMBITO LOCAL
        
        if (ctx.parametros() != null) {

            for (YParser.ParametroContext parametro
                    : ctx.parametros().parametro()) {

                registrarParametro(
                        parametro
                );
            }
        }

        
        // ANALIZAR CUERPO
        
        visit(
                ctx.bloqueFuncion()
        );

        
        // RESTAURAR CONTEXTO ANTERIOR
        
        tipoRetornoActual
                = retornoAnterior;

        tipoReferenciaRetornoActual
                = referenciaRetornoAnterior;

        ambitosEstructuras.pop();

        tabla.salirAmbito();
    }

    private void validarInicializadorVariable(
            Symbol simbolo,
            YParser.InicializadorContext ctx,
            String nombre) {

        
        // INICIALIZACIÓN NORMAL MEDIANTE EXPRESIÓN
        
        if (ctx.expresion() != null) {

            DataType recibido
                    = obtenerTipoExpresion(
                            ctx.expresion()
                    );

            
            // INICIALIZACIÓN ENTRE ESTRUCTURAS
            
            if (simbolo.getTipo() == DataType.ESTRUCTURA
                    && recibido == DataType.ESTRUCTURA) {

                String referenciaEsperada
                        = simbolo.getTipoReferencia();

                String referenciaRecibida
                        = obtenerTipoReferenciaExpresion(
                                ctx.expresion()
                        );

                if (referenciaEsperada != null
                        && referenciaRecibida != null
                        && !referenciaEsperada.equals(
                                referenciaRecibida)) {

                    error(
                            "No se puede inicializar '"
                            + nombre
                            + "' de tipo estructura '"
                            + referenciaEsperada
                            + "' con una estructura '"
                            + referenciaRecibida
                            + "'.",
                            ctx
                    );

                    return;
                }
            }

            if (simbolo.getTipo() == DataType.ARREGLO) {

                error(
                        "El arreglo '"
                        + nombre
                        + "' debe inicializarse mediante una lista "
                        + "de valores entre { }.",
                        ctx
                );

                return;
            }

            if (!compatibles(
                    simbolo.getTipo(),
                    recibido)) {

                error(
                        "No se puede inicializar '"
                        + nombre
                        + "' de tipo "
                        + simbolo.getTipo()
                        + " con una expresión de tipo "
                        + recibido
                        + ".",
                        ctx
                );
            }

            return;
        }

        
        // INICIALIZACIÓN CON { ... }
        
        if (ctx.inicializadorLista() != null) {

            if (simbolo.getTipo() == DataType.ARREGLO) {

                validarInicializacionArreglo(
                        simbolo,
                        ctx.inicializadorLista(),
                        nombre
                );

                return;
            }

            if (simbolo.getTipo() == DataType.ESTRUCTURA) {

                validarInicializacionEstructuraLista(
                        simbolo,
                        ctx.inicializadorLista(),
                        nombre
                );

                return;
            }

            error(
                    "El tipo "
                    + simbolo.getTipo()
                    + " de la variable '"
                    + nombre
                    + "' no puede inicializarse mediante { }.",
                    ctx
            );
        }
    }

    private void validarInicializacionArreglo(
            Symbol simbolo,
            YParser.InicializadorListaContext ctx,
            String nombre) {

        List<YParser.InicializadorContext> valores
                = ctx.inicializador();

        if (simbolo.getDimensiones().isEmpty()) {
            return;
        }

        validarNivelArreglo(
                simbolo,
                valores,
                nombre,
                0,
                ctx
        );

    }

    private void validarNivelArreglo(
            Symbol simbolo,
            List<YParser.InicializadorContext> valores,
            String nombre,
            int dimension,
            org.antlr.v4.runtime.ParserRuleContext contexto) {

        int totalDimensiones
                = simbolo.getDimensiones().size();

        int limite
                = simbolo.getDimensiones().get(dimension);

        // Si conocemos el tamaño concreto.
        if (limite > 0
                && valores.size() > limite) {

            error(
                    "El arreglo '"
                    + nombre
                    + "' admite como máximo "
                    + limite
                    + " elemento(s) en la dimensión "
                    + (dimension + 1)
                    + ", pero recibió "
                    + valores.size()
                    + ".",
                    contexto
            );
        }

        boolean ultimaDimension
                = dimension
                == totalDimensiones - 1;

        for (YParser.InicializadorContext valor
                : valores) {

            if (ultimaDimension) {

                
                // ARREGLO DE ESTRUCTURAS
                
                if (simbolo.getTipoElemento()
                        == DataType.ESTRUCTURA) {

                    if (valor.inicializadorLista() != null) {

                        String tipoReferencia
                                = simbolo.getTipoReferencia();

                        if (tipoReferencia == null) {

                            error(
                                    "No se pudo determinar el tipo de estructura "
                                    + "del arreglo '"
                                    + nombre
                                    + "'.",
                                    valor
                            );

                            continue;
                        }

                        Symbol simboloTemporal
                                = new Symbol(
                                        nombre,
                                        DataType.ESTRUCTURA,
                                        SymbolKind.VARIABLE,
                                        0,
                                        0
                                );

                        simboloTemporal.setTipoReferencia(
                                tipoReferencia
                        );

                        validarInicializacionEstructuraLista(
                                simboloTemporal,
                                valor.inicializadorLista(),
                                nombre
                        );

                        continue;
                    }

                    
                    // También puede recibirse una expresión que ya sea
                    // una estructura, por ejemplo otra variable Persona.
                    
                    if (valor.expresion() != null) {

                        DataType recibido
                                = obtenerTipoExpresion(
                                        valor.expresion()
                                );

                        if (recibido != DataType.ESTRUCTURA) {

                            error(
                                    "Elemento incompatible en el arreglo '"
                                    + nombre
                                    + "'. Se esperaba una estructura '"
                                    + simbolo.getTipoReferencia()
                                    + "' pero se recibió "
                                    + recibido
                                    + ".",
                                    valor
                            );

                            continue;
                        }

                        String tipoReferenciaRecibida
                                = obtenerTipoReferenciaExpresion(
                                        valor.expresion()
                                );

                        if (simbolo.getTipoReferencia() != null
                                && tipoReferenciaRecibida != null
                                && !simbolo.getTipoReferencia().equals(
                                        tipoReferenciaRecibida)) {

                            error(
                                    "Elemento incompatible en el arreglo '"
                                    + nombre
                                    + "'. Se esperaba una estructura '"
                                    + simbolo.getTipoReferencia()
                                    + "' pero se recibió una estructura '"
                                    + tipoReferenciaRecibida
                                    + "'.",
                                    valor
                            );
                        }

                        continue;
                    }

                    error(
                            "Se esperaba un valor de estructura '"
                            + simbolo.getTipoReferencia()
                            + "' en el arreglo '"
                            + nombre
                            + "'.",
                            valor
                    );

                    continue;
                }

                
                // ARREGLO DE TIPOS NORMALES
                
                if (valor.expresion() == null) {

                    error(
                            "Se esperaba un valor de tipo "
                            + simbolo.getTipoElemento()
                            + " en el arreglo '"
                            + nombre
                            + "'.",
                            valor
                    );

                    continue;
                }

                DataType recibido
                        = obtenerTipoExpresion(
                                valor.expresion()
                        );

                if (!compatibles(
                        simbolo.getTipoElemento(),
                        recibido)) {

                    error(
                            "Elemento incompatible en el arreglo '"
                            + nombre
                            + "'. Se esperaba "
                            + simbolo.getTipoElemento()
                            + " pero se recibió "
                            + recibido
                            + ".",
                            valor
                    );
                }

            } else {

                if (valor.inicializadorLista() == null) {

                    error(
                            "La dimensión "
                            + (dimension + 1)
                            + " del arreglo '"
                            + nombre
                            + "' requiere una lista { ... }.",
                            valor
                    );

                    continue;
                }

                validarNivelArreglo(
                        simbolo,
                        valor.inicializadorLista()
                                .inicializador(),
                        nombre,
                        dimension + 1,
                        valor
                );
            }
        }
    }

    private void validarInicializacionEstructuraLista(
            Symbol simbolo,
            YParser.InicializadorListaContext ctx,
            String nombre) {

        String tipoReferencia
                = simbolo.getTipoReferencia();

        if (tipoReferencia == null) {

            error(
                    "No se pudo determinar el tipo de estructura "
                    + "de la variable '"
                    + nombre
                    + "'.",
                    ctx
            );

            return;
        }

        StructDef estructura
                = buscarEstructura(
                        tipoReferencia
                );

        if (estructura == null) {

            error(
                    "La estructura '"
                    + tipoReferencia
                    + "' no ha sido declarada.",
                    ctx
            );

            return;
        }

        List<Symbol> atributos
                = estructura.getAtributosOrdenados();

        List<YParser.InicializadorContext> valores
                = ctx.inicializador();

        
        // CANTIDAD DE VALORES
        
        if (valores.size()
                != atributos.size()) {

            error(
                    "La estructura '"
                    + tipoReferencia
                    + "' requiere "
                    + atributos.size()
                    + " valor(es) para inicializarse, "
                    + "pero recibió "
                    + valores.size()
                    + ".",
                    ctx
            );
        }

        /*
     * Validamos hasta donde ambas listas tengan elementos,
     * así evitamos IndexOutOfBounds y todavía podemos
     * detectar errores de tipos.
         */
        int cantidad
                = Math.min(
                        atributos.size(),
                        valores.size()
                );

        for (int i = 0;
                i < cantidad;
                i++) {

            Symbol atributo
                    = atributos.get(i);

            YParser.InicializadorContext valor
                    = valores.get(i);

            validarValorAtributoEstructura(
                    tipoReferencia,
                    atributo,
                    valor,
                    i + 1
            );
        }
    }

    private void validarValorAtributoEstructura(
            String nombreEstructura,
            Symbol atributo,
            YParser.InicializadorContext valor,
            int posicion) {

        
        // ATRIBUTO NORMAL
        
        if (atributo.getTipo()
                != DataType.ARREGLO
                && atributo.getTipo()
                != DataType.ESTRUCTURA) {

            if (valor.expresion() == null) {

                error(
                        "El atributo '"
                        + atributo.getNombre()
                        + "' de la estructura '"
                        + nombreEstructura
                        + "' requiere un valor de tipo "
                        + atributo.getTipo()
                        + ".",
                        valor
                );

                return;
            }

            DataType recibido
                    = obtenerTipoExpresion(
                            valor.expresion()
                    );

            if (!compatibles(
                    atributo.getTipo(),
                    recibido)) {

                error(
                        "Valor incompatible para el atributo '"
                        + atributo.getNombre()
                        + "' de la estructura '"
                        + nombreEstructura
                        + "'. Se esperaba "
                        + atributo.getTipo()
                        + " pero se recibió "
                        + recibido
                        + ".",
                        valor
                );
            }

            return;
        }

        
        // ATRIBUTO QUE ES OTRA ESTRUCTURA
        
        if (atributo.getTipo()
                == DataType.ESTRUCTURA) {

            if (valor.inicializadorLista() == null) {

                error(
                        "El atributo '"
                        + atributo.getNombre()
                        + "' de tipo estructura '"
                        + atributo.getTipoReferencia()
                        + "' debe inicializarse mediante { ... }.",
                        valor
                );

                return;
            }

            Symbol simboloTemporal
                    = new Symbol(
                            atributo.getNombre(),
                            DataType.ESTRUCTURA,
                            SymbolKind.VARIABLE,
                            0,
                            0
                    );

            simboloTemporal.setTipoReferencia(
                    atributo.getTipoReferencia()
            );

            validarInicializacionEstructuraLista(
                    simboloTemporal,
                    valor.inicializadorLista(),
                    atributo.getNombre()
            );

            return;
        }

        
        // ATRIBUTO ARREGLO
        
        if (atributo.getTipo()
                == DataType.ARREGLO) {

            if (valor.inicializadorLista() == null) {

                error(
                        "El atributo arreglo '"
                        + atributo.getNombre()
                        + "' debe inicializarse mediante { ... }.",
                        valor
                );

                return;
            }

            validarInicializacionArreglo(
                    atributo,
                    valor.inicializadorLista(),
                    atributo.getNombre()
            );
        }
    }

    private String obtenerTipoReferenciaAcceso(
            YParser.AccesoContext ctx) {

        String nombreBase
                = ctx.IDENTIFICADOR()
                        .getText();

        Symbol actual
                = tabla.buscar(nombreBase);

        if (actual == null) {
            return null;
        }

        DataType tipoActual
                = actual.getTipo();

        String estructuraActual
                = actual.getTipoReferencia();

        int dimensionesRestantes
                = tipoActual == DataType.ARREGLO
                        ? actual.getDimensiones().size()
                        : 0;

        for (YParser.SufijoAccesoContext sufijo
                : ctx.sufijoAcceso()) {

            
            // ACCESO POR ÍNDICE [...]
            
            if (sufijo.expresion() != null) {

                if (tipoActual != DataType.ARREGLO) {
                    return null;
                }

                dimensionesRestantes--;

                if (dimensionesRestantes < 0) {
                    return null;
                }

                if (dimensionesRestantes > 0) {

                    tipoActual = DataType.ARREGLO;

                } else {

                    tipoActual
                            = actual.getTipoElemento();

                    estructuraActual
                            = actual.getTipoReferencia();
                }

                continue;
            }

            
            // ACCESO A ATRIBUTO .nombre
            
            if (sufijo.IDENTIFICADOR() != null) {

                if (tipoActual == DataType.ARREGLO) {
                    return null;
                }

                if (tipoActual != DataType.ESTRUCTURA) {
                    return null;
                }

                StructDef estructura
                        = buscarEstructura(
                                estructuraActual
                        );

                if (estructura == null) {
                    return null;
                }

                String nombreAtributo
                        = sufijo.IDENTIFICADOR()
                                .getText();

                Symbol atributo
                        = estructura.buscarAtributo(
                                nombreAtributo
                        );

                if (atributo == null) {
                    return null;
                }

                actual = atributo;

                tipoActual
                        = atributo.getTipo();

                estructuraActual
                        = atributo.getTipoReferencia();

                dimensionesRestantes
                        = tipoActual == DataType.ARREGLO
                                ? atributo.getDimensiones().size()
                                : 0;
            }
        }

        if (tipoActual == DataType.ESTRUCTURA) {
            return estructuraActual;
        }

        return null;
    }

    private String obtenerTipoReferenciaExpresion(
            YParser.ExpresionContext expresion) {

        try {

            YParser.ExpresionPrimariaContext primaria
                    = expresion
                            .expresionOr()
                            .expresionAnd(0)
                            .expresionIgualdad(0)
                            .expresionRelacional(0)
                            .expresionAditiva(0)
                            .expresionMultiplicativa(0)
                            .expresionUnaria(0)
                            .expresionPrimaria();

            if (primaria != null
                    && primaria.acceso() != null) {

                return obtenerTipoReferenciaAcceso(
                        primaria.acceso()
                );
            }

            
            // LLAMADA A FUNCIÓN QUE RETORNA ESTRUCTURA
            
            if (primaria != null
                    && primaria.llamadaFuncion() != null) {

                String nombreFuncion
                        = primaria.llamadaFuncion()
                                .IDENTIFICADOR()
                                .getText();

                Symbol funcion
                        = tabla.buscar(
                                nombreFuncion
                        );

                if (funcion == null) {
                    return null;
                }

                if (funcion.getCategoria()
                        != SymbolKind.FUNCION) {
                    return null;
                }

                if (funcion.getTipo()
                        != DataType.ESTRUCTURA) {
                    return null;
                }

                return funcion.getTipoReferencia();
            }

        } catch (Exception ex) {

            return null;
        }

        return null;
    }

    private StructDef buscarEstructura(
            String nombre) {

        
        // PRIMERO BUSCAR EN ÁMBITOS LOCALES
        
        for (Map<String, StructDef> ambito
                : ambitosEstructuras) {

            StructDef encontrada
                    = ambito.get(nombre);

            if (encontrada != null) {
                return encontrada;
            }
        }

        
        // DESPUÉS BUSCAR GLOBALMENTE
        
        return estructuras.get(nombre);
    }

    private boolean existeEstructura(
            String nombre) {

        return buscarEstructura(nombre) != null;
    }

    private boolean existeEstructuraEnAmbitoActual(
            String nombre) {

        if (!ambitosEstructuras.isEmpty()) {

            return ambitosEstructuras
                    .peek()
                    .containsKey(nombre);
        }

        return estructuras.containsKey(nombre);
    }

    private void registrarEstructuraEnAmbitoActual(
            String nombre,
            StructDef estructura) {

        if (!ambitosEstructuras.isEmpty()) {

            ambitosEstructuras
                    .peek()
                    .put(
                            nombre,
                            estructura
                    );

            return;
        }

        estructuras.put(
                nombre,
                estructura
        );
    }
}
