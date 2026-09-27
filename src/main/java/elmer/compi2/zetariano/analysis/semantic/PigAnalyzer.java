
package elmer.compi2.zetariano.analysis.semantic;

import elmer.compi2.zetariano.analysis.symbol.SymbolKind;
import elmer.compi2.zetariano.analysis.symbol.Symbol;
import elmer.compi2.zetariano.analysis.symbol.SymbolTable;
import elmer.compi2.zetariano.analysis.symbol.DataType;
import elmer.compi2.zetariano.runtime.zeta.TablaMemoriaZ;
import elmer.compi2.zetariano.imports.AdaptadorImportZPig;
import elmer.compi2.zetariano.imports.AtributoImportadoPig;
import elmer.compi2.zetariano.imports.CargadorImportZPig;
import elmer.compi2.zetariano.imports.ClaseImportadaPig;
import elmer.compi2.zetariano.imports.MetodoImportadoPig;
import elmer.compi2.zetariano.imports.RegistroImportsPig;
import elmer.compi2.zetariano.imports.TipoImportPig;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import elmer.compi2.zetariano.antlr.piglatin.PigLatinParser;
import elmer.compi2.zetariano.antlr.piglatin.PigLatinParserBaseVisitor;
import elmer.compi2.zetariano.imports.AdaptadorImportYPig;
import elmer.compi2.zetariano.imports.CargadorImportYPig;
import elmer.compi2.zetariano.analysis.semantic.YAnalyzer;


public class PigAnalyzer extends PigLatinParserBaseVisitor<DataType> {

    private final SymbolTable tabla
            = new SymbolTable();

    private final List<String> errores
            = new ArrayList<>();

    private int profundidadCiclo = 0;

    private final RegistroImportsPig registroImports
            = new RegistroImportsPig();

    private Path directorioBase;

    /* Reutilizado para que los imports Z compartan sus clases. */
    private final CargadorImportZPig cargadorZ
            = new CargadorImportZPig();

    
    // RESULTADOS
    
    public SymbolTable getTabla() {
        return tabla;
    }

    public RegistroImportsPig getRegistroImports() {
        return registroImports;
    }

    public List<String> getErrores() {
        return errores;
    }

    public boolean hayErrores() {
        return !errores.isEmpty();
    }

    public void imprimirErrores() {

        System.out.println();
        System.out.println(
                "========== ERRORES SEMANTICOS PIG =========="
        );

        if (errores.isEmpty()) {

            System.out.println(
                    "Sin errores semanticos."
            );

        } else {

            for (String error : errores) {
                System.out.println(error);
            }
        }

        System.out.println(
                ""
        );
    }

    public PigAnalyzer() {
        this.directorioBase = Path.of(".")
                .toAbsolutePath()
                .normalize();
    }

    public PigAnalyzer(Path directorioBase) {

        if (directorioBase == null) {

            this.directorioBase = Path.of(".")
                    .toAbsolutePath()
                    .normalize();

        } else {

            this.directorioBase = directorioBase
                    .toAbsolutePath()
                    .normalize();
        }
    }

    private void error(
            int linea,
            String mensaje) {

        errores.add(
                "[SEMANTICO] Linea "
                + linea
                + " -> "
                + mensaje
        );
    }

    
    // IMPORTACIONES
    
    @Override
    public DataType visitImportacion(
            PigLatinParser.ImportacionContext ctx) {

        int linea = ctx.getStart().getLine();

        String texto = ctx.getText();

        if (texto == null || texto.isBlank()) {

            error(
                    linea,
                    "Importacion vacia."
            );

            return DataType.DESCONOCIDO;
        }

        
        // LIMPIAR IMPORT
        
        if (texto.startsWith("import")) {

            texto = texto.substring(
                    "import".length()
            );
        }

        if (texto.endsWith(";")) {

            texto = texto.substring(
                    0,
                    texto.length() - 1
            );
        }

        texto = texto.trim();

        if (texto.startsWith("\"")
                && texto.endsWith("\"")
                && texto.length() >= 2) {

            texto = texto.substring(
                    1,
                    texto.length() - 1
            );
        }

        
        // DETERMINAR LENGUAJE
        
        String textoMinuscula
                = texto.toLowerCase();

        boolean esZ
                = textoMinuscula.endsWith(".z");

        boolean esY
                = textoMinuscula.endsWith(".y");

        if (!esZ && !esY) {

            error(
                    linea,
                    "Solo se soportan imports de archivos .z o .y: "
                    + texto
            );

            return DataType.DESCONOCIDO;
        }

        
        // RESOLVER RUTA
        
        String rutaRelativa
                = convertirImportARuta(
                        texto
                );

        Path archivo
                = directorioBase
                        .resolve(rutaRelativa)
                        .normalize();

        if (!Files.exists(archivo)) {

            error(
                    linea,
                    "No se encontro el archivo importado: "
                    + archivo
            );

            return DataType.DESCONOCIDO;
        }

        
        // IMPORTAR SEGUN LENGUAJE
        
        try {

            if (esZ) {

                
                // ARCHIVO Z
                
                TablaMemoriaZ tablaZ
                        = cargadorZ.cargarTabla(
                                archivo.toString()
                        );

                AdaptadorImportZPig adaptador
                        = new AdaptadorImportZPig();

                adaptador.importar(
                        tablaZ,
                        registroImports
                );

            } else {

                
                // ARCHIVO Y
                
                CargadorImportYPig cargador
                        = new CargadorImportYPig();

                YAnalyzer semanticoY
                        = cargador.cargarSemantico(
                                archivo.toString()
                        );

                AdaptadorImportYPig adaptador
                        = new AdaptadorImportYPig();

                adaptador.importar(
                        semanticoY,
                        registroImports
                );
            }

        } catch (Exception ex) {

            error(
                    linea,
                    "No fue posible importar '"
                    + texto
                    + "': "
                    + ex.getMessage()
            );

            return DataType.DESCONOCIDO;
        }

        return DataType.VOID;
    }

    
    // VARIABLES
    
    @Override
    public DataType visitDeclaracionVariable(
            PigLatinParser.DeclaracionVariableContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR().getText();

        int linea
                = ctx.getStart().getLine();

        if (tabla.existeEnAmbitoActual(nombre)) {

            error(
                    linea,
                    "La variable '"
                    + nombre
                    + "' ya fue declarada en este ambito."
            );

            return DataType.DESCONOCIDO;
        }

        DataType tipoDeclarado
                = obtenerTipo(ctx.tipo());

        if (ctx.tipo().IDENTIFICADOR() != null) {

            String nombreTipo
                    = ctx.tipo()
                            .IDENTIFICADOR()
                            .getText();

            if (!registroImports.existeClase(nombreTipo)) {

                error(
                        linea,
                        "El tipo '"
                        + nombreTipo
                        + "' no ha sido importado."
                );

                tipoDeclarado
                        = DataType.DESCONOCIDO;
            }
        }

        Symbol simbolo
                = new Symbol(
                        nombre,
                        tipoDeclarado,
                        SymbolKind.VARIABLE,
                        tabla.getNivelActual(),
                        tabla.getAmbitoActual()
                );

        if (tipoDeclarado == DataType.OBJETO
                && ctx.tipo().IDENTIFICADOR() != null) {

            simbolo.setTipoReferencia(
                    ctx.tipo()
                            .IDENTIFICADOR()
                            .getText()
            );
        }

        tabla.agregar(simbolo);

        if (ctx.inicializacionVariable() != null) {

            PigLatinParser.InicializacionVariableContext inicializacion
                    = ctx.inicializacionVariable();


            // INICIALIZADOR POSICIONAL DE ESTRUCTURA: { ... }

            if (inicializacion.inicializadorEstructura() != null) {

                if (tipoDeclarado != DataType.OBJETO
                        || simbolo.getTipoReferencia() == null) {

                    error(
                            linea,
                            "El inicializador { ... } solo puede utilizarse "
                            + "con una estructura importada desde Y."
                    );

                } else {

                    ClaseImportadaPig clase
                            = registroImports.buscarClase(
                                    simbolo.getTipoReferencia()
                            );

                    if (clase == null) {

                        error(
                                linea,
                                "No existe informacion importada para la estructura '"
                                + simbolo.getTipoReferencia()
                                + "'."
                        );

                    } else if (clase.getOrigen()
                            != TipoImportPig.Y) {

                        error(
                                linea,
                                "El tipo '"
                                + simbolo.getTipoReferencia()
                                + "' proviene de Z y debe inicializarse con novus."
                        );

                    } else {

                        validarInicializadorEstructura(
                                inicializacion.inicializadorEstructura(),
                                clase
                        );
                    }
                }

            } else {


                // INICIALIZACION NORMAL MEDIANTE EXPRESION

                DataType tipoValor
                        = visit(
                                inicializacion.expresion()
                        );

                if (!sonCompatibles(
                        tipoDeclarado,
                        tipoValor)) {

                    error(
                            linea,
                            "No se puede inicializar '"
                            + nombre
                            + "' de tipo "
                            + tipoDeclarado
                            + " con un valor de tipo "
                            + tipoValor
                            + "."
                    );
                }
            }
        }

        return tipoDeclarado;
    }

    
    // ARREGLOS
    
    @Override
    public DataType visitDeclaracionArreglo(
            PigLatinParser.DeclaracionArregloContext ctx) {

        String nombre
                = ctx.IDENTIFICADOR().getText();

        int linea
                = ctx.getStart().getLine();

        if (tabla.existeEnAmbitoActual(nombre)) {

            error(
                    linea,
                    "El identificador '"
                    + nombre
                    + "' ya fue declarado en este ambito."
            );

            return DataType.DESCONOCIDO;
        }

        DataType tipoElemento
                = obtenerTipo(ctx.tipo());

        if (ctx.tipo().IDENTIFICADOR() != null) {

            String nombreTipo
                    = ctx.tipo()
                            .IDENTIFICADOR()
                            .getText();

            if (!registroImports.existeClase(nombreTipo)) {

                error(
                        linea,
                        "El tipo de elemento '"
                        + nombreTipo
                        + "' no ha sido importado."
                );

                tipoElemento
                        = DataType.DESCONOCIDO;
            }
        }

        Symbol simbolo
                = new Symbol(
                        nombre,
                        DataType.ARREGLO,
                        SymbolKind.ARREGLO,
                        tabla.getNivelActual(),
                        tabla.getAmbitoActual()
                );

        simbolo.setTipoElemento(tipoElemento);

        if (tipoElemento == DataType.OBJETO
                && ctx.tipo().IDENTIFICADOR() != null) {

            simbolo.setTipoReferencia(
                    ctx.tipo()
                            .IDENTIFICADOR()
                            .getText()
            );
        }

        for (PigLatinParser.DimensionDeclaracionContext dimension
                : ctx.dimensionesDeclaracion()
                        .dimensionDeclaracion()) {

            try {

                int tamano
                        = Integer.parseInt(
                                dimension.ENTERO()
                                        .getText()
                        );

                if (tamano <= 0) {

                    error(
                            dimension.getStart().getLine(),
                            "El tamano de un arreglo debe ser mayor que cero."
                    );
                }

                simbolo.getDimensiones()
                        .add(tamano);

            } catch (NumberFormatException ex) {

                error(
                        dimension.getStart().getLine(),
                        "Tamano de arreglo invalido."
                );
            }
        }

        tabla.agregar(simbolo);

        if (ctx.inicializadorArreglo() != null) {

            validarInicializadorArreglo(
                    ctx.inicializadorArreglo()
                            .inicializadorLista(),
                    simbolo,
                    0
            );
        }

        return DataType.ARREGLO;
    }

    
    // BLOQUES / SCOPES
    
    @Override
    public DataType visitBloque(
            PigLatinParser.BloqueContext ctx) {

        tabla.entrarAmbito();

        for (PigLatinParser.SentenciaContext sentencia
                : ctx.sentencia()) {

            visit(sentencia);
        }

        tabla.salirAmbito();

        return DataType.VOID;
    }

    
    // ASIGNACIONES
    
    @Override
    public DataType visitAsignacion(
            PigLatinParser.AsignacionContext ctx) {

        DataType tipoDestino
                = visit(ctx.acceso());

        DataType tipoValor
                = visit(ctx.expresion());

        if (!sonCompatibles(
                tipoDestino,
                tipoValor)) {

            error(
                    ctx.getStart().getLine(),
                    "Asignacion incompatible: "
                    + tipoDestino
                    + " = "
                    + tipoValor
                    + "."
            );
        }

        return tipoDestino;
    }

    
    // ACCESOS
    
    @Override
    public DataType visitAcceso(
            PigLatinParser.AccesoContext ctx) {

        String nombreBase
                = ctx.IDENTIFICADOR()
                        .getText();

        int linea
                = ctx.getStart().getLine();

        Symbol simbolo
                = tabla.buscar(
                        nombreBase
                );

        if (simbolo == null) {

            error(
                    linea,
                    "El identificador '"
                    + nombreBase
                    + "' no ha sido declarado."
            );

            return DataType.DESCONOCIDO;
        }

        DataType tipoActual
                = simbolo.getTipo();

        String referenciaActual
                = simbolo.getTipoReferencia();

        int dimensionesRestantes
                = simbolo.getDimensiones().size();

        if (tipoActual == DataType.ARREGLO) {

            tipoActual
                    = simbolo.getTipoElemento();
        }

        for (PigLatinParser.SufijoAccesoContext sufijo
                : ctx.sufijoAcceso()) {

            
            // INDICE
            
            if (sufijo.CORCHETE_IZQ() != null) {

                if (dimensionesRestantes <= 0) {

                    error(
                            sufijo.getStart().getLine(),
                            "Se intento indexar un valor que no es un arreglo."
                    );

                    return DataType.DESCONOCIDO;
                }

                DataType tipoIndice
                        = visit(
                                sufijo.expresion()
                        );

                if (tipoIndice
                        != DataType.ENTERO
                        && tipoIndice
                        != DataType.DESCONOCIDO) {

                    error(
                            sufijo.getStart().getLine(),
                            "El indice de un arreglo debe ser ENTERO."
                    );
                }

                dimensionesRestantes--;

                continue;
            }

            if (dimensionesRestantes > 0) {

                error(
                        sufijo.getStart().getLine(),
                        "Debe completar los indices del arreglo antes de acceder a sus miembros."
                );

                return DataType.DESCONOCIDO;
            }

            if (tipoActual != DataType.OBJETO
                    || referenciaActual == null) {

                error(
                        sufijo.getStart().getLine(),
                        "Se intento acceder a un miembro de un valor que no es un objeto."
                );

                return DataType.DESCONOCIDO;
            }

            ClaseImportadaPig clase
                    = registroImports.buscarClase(
                            referenciaActual
                    );

            if (clase == null) {

                error(
                        sufijo.getStart().getLine(),
                        "No existe informacion importada para la clase '"
                        + referenciaActual
                        + "'."
                );

                return DataType.DESCONOCIDO;
            }

            String nombreMiembro
                    = sufijo.IDENTIFICADOR()
                            .getText();

            
            // LLAMADA A METODO
            
            if (sufijo.PARENTESIS_IZQ() != null) {

                List<String> argumentos
                        = new ArrayList<>();

                if (sufijo.listaArgumentos() != null) {

                    for (PigLatinParser.ExpresionContext argumento
                            : sufijo.listaArgumentos()
                                    .expresion()) {

                        DataType tipoArgumento
                                = visit(argumento);

                        argumentos.add(
                                describirArgumentoImportadoZ(
                                        argumento,
                                        tipoArgumento
                                )
                        );
                    }
                }

                String firma
                        = construirFirmaImportadaY(
                                nombreMiembro,
                                argumentos
                        );

                MetodoImportadoPig metodo
                        = clase.buscarMetodoPorFirma(
                                firma
                        );

                if (metodo == null
                        || metodo.esConstructor()) {

                    error(
                            sufijo.getStart().getLine(),
                            "La clase '"
                            + referenciaActual
                            + "' no contiene el metodo '"
                            + firma
                            + "'."
                    );

                    return DataType.DESCONOCIDO;
                }

                String retorno
                        = metodo.getTipoRetorno();

                tipoActual
                        = tipoExternoATipoPig(
                                retorno
                        );

                if (tipoActual == DataType.OBJETO) {

                    referenciaActual
                            = retorno;

                } else {

                    referenciaActual
                            = null;
                }

                dimensionesRestantes = 0;

                continue;
            }

            
            // ATRIBUTO
            
            AtributoImportadoPig atributo
                    = clase.buscarAtributo(
                            nombreMiembro
                    );

            if (atributo == null) {

                error(
                        sufijo.getStart().getLine(),
                        "La clase '"
                        + referenciaActual
                        + "' no contiene el atributo '"
                        + nombreMiembro
                        + "'."
                );

                return DataType.DESCONOCIDO;
            }

            tipoActual
                    = tipoExternoATipoPig(
                            atributo.getTipo()
                    );

            dimensionesRestantes
                    = atributo.getDimensiones();

            if (tipoActual == DataType.OBJETO) {

                referenciaActual
                        = atributo.getTipo();

            } else {

                referenciaActual
                        = null;
            }
        }

        if (dimensionesRestantes > 0) {
            return DataType.ARREGLO;
        }

        return tipoActual;
    }

    
    // INCREMENTO / DECREMENTO
    
    @Override
    public DataType visitIncrementoDecremento(
            PigLatinParser.IncrementoDecrementoContext ctx) {

        DataType tipo
                = visit(ctx.acceso());

        if (!esNumerico(tipo)
                && tipo != DataType.DESCONOCIDO) {

            error(
                    ctx.getStart().getLine(),
                    "Los operadores ++ y -- requieren un valor numerico."
            );
        }

        return tipo;
    }

    
// LECTURA

    @Override
    public DataType visitLectura(
            PigLatinParser.LecturaContext ctx) {

        if (ctx == null) {
            return DataType.DESCONOCIDO;
        }

        // <<;
        // La lectura se realiza, pero su resultado se descarta.
        if (ctx.acceso() == null) {
            return DataType.VOID;
        }

        DataType tipoDestino
                = visit(
                        ctx.acceso()
                );

        if (tipoDestino == DataType.ARREGLO
                || tipoDestino == DataType.OBJETO
                || tipoDestino == DataType.ESTRUCTURA
                || tipoDestino == DataType.VOID) {

            error(
                    ctx.getStart().getLine(),
                    "No se puede guardar una lectura desde consola "
                    + "en un destino de tipo "
                    + tipoDestino
                    + "."
            );
        }

        return DataType.VOID;
    }

    
    // IF
    
    @Override
    public DataType visitSentenciaSi(
            PigLatinParser.SentenciaSiContext ctx) {

        for (PigLatinParser.ExpresionContext condicion
                : ctx.expresion()) {

            DataType tipoCondicion
                    = visit(condicion);

            validarCondicion(
                    condicion.getStart().getLine(),
                    tipoCondicion
            );
        }

        for (PigLatinParser.BloqueContext bloque
                : ctx.bloque()) {

            visit(bloque);
        }

        return DataType.VOID;
    }

    
    // WHILE
    
    @Override
    public DataType visitSentenciaDum(
            PigLatinParser.SentenciaDumContext ctx) {

        DataType condicion
                = visit(ctx.expresion());

        validarCondicion(
                ctx.expresion()
                        .getStart()
                        .getLine(),
                condicion
        );

        profundidadCiclo++;

        visit(ctx.bloque());

        profundidadCiclo--;

        return DataType.VOID;
    }

    
    // DO-WHILE
    
    @Override
    public DataType visitSentenciaFacere(
            PigLatinParser.SentenciaFacereContext ctx) {

        profundidadCiclo++;

        visit(ctx.bloque());

        profundidadCiclo--;

        DataType condicion
                = visit(ctx.expresion());

        validarCondicion(
                ctx.expresion()
                        .getStart()
                        .getLine(),
                condicion
        );

        return DataType.VOID;
    }

    
    // FOR
    
    @Override
    public DataType visitSentenciaPer(
            PigLatinParser.SentenciaPerContext ctx) {

        tabla.entrarAmbito();

        visit(ctx.inicializacionPer());

        DataType condicion
                = visit(ctx.expresion());

        validarCondicion(
                ctx.expresion()
                        .getStart()
                        .getLine(),
                condicion
        );

        visit(ctx.actualizacionPer());

        profundidadCiclo++;

        visit(ctx.bloque());

        profundidadCiclo--;

        tabla.salirAmbito();

        return DataType.VOID;
    }

    @Override
    public DataType visitSentencia(
            PigLatinParser.SentenciaContext ctx) {

        if (ctx.PERGE() != null) {

            if (profundidadCiclo <= 0) {

                error(
                        ctx.getStart().getLine(),
                        "'perge' solo puede utilizarse dentro de un ciclo."
                );
            }

            return DataType.VOID;
        }

        if (ctx.INTERRUMPE() != null) {

            if (profundidadCiclo <= 0) {

                error(
                        ctx.getStart().getLine(),
                        "'interrumpe' solo puede utilizarse dentro de un ciclo."
                );
            }

            return DataType.VOID;
        }

        return visitChildren(ctx);
    }

    
    // INICIALIZACION DEL FOR
    
    @Override
    public DataType visitInicializacionPer(
            PigLatinParser.InicializacionPerContext ctx) {

        if (ctx.ESTO() != null) {

            String nombre
                    = ctx.IDENTIFICADOR()
                            .getText();

            DataType declarado
                    = obtenerTipo(ctx.tipo());

            if (tabla.existeEnAmbitoActual(nombre)) {

                error(
                        ctx.getStart().getLine(),
                        "La variable '"
                        + nombre
                        + "' ya fue declarada en este ambito."
                );

                return DataType.DESCONOCIDO;
            }

            Symbol simbolo
                    = new Symbol(
                            nombre,
                            declarado,
                            SymbolKind.VARIABLE,
                            tabla.getNivelActual(),
                            tabla.getAmbitoActual()
                    );

            tabla.agregar(simbolo);

            DataType valor
                    = visit(ctx.expresion());

            if (!sonCompatibles(
                    declarado,
                    valor)) {

                error(
                        ctx.getStart().getLine(),
                        "Inicializacion incompatible para '"
                        + nombre
                        + "'."
                );
            }

            return declarado;
        }

        DataType destino
                = visit(ctx.acceso());

        DataType valor
                = visit(ctx.expresion());

        if (!sonCompatibles(
                destino,
                valor)) {

            error(
                    ctx.getStart().getLine(),
                    "Asignacion incompatible en inicializacion de per."
            );
        }

        return destino;
    }

    
    // ACTUALIZACION DEL FOR
    
    @Override
    public DataType visitActualizacionPer(
            PigLatinParser.ActualizacionPerContext ctx) {

        DataType destino
                = visit(ctx.acceso());

        if (ctx.INCREMENTO() != null
                || ctx.DECREMENTO() != null) {

            if (!esNumerico(destino)
                    && destino
                    != DataType.DESCONOCIDO) {

                error(
                        ctx.getStart().getLine(),
                        "La actualizacion ++/-- de per requiere un valor numerico."
                );
            }

            return destino;
        }

        if (ctx.expresion() != null) {

            DataType valor
                    = visit(ctx.expresion());

            if (!sonCompatibles(
                    destino,
                    valor)) {

                error(
                        ctx.getStart().getLine(),
                        "Asignacion incompatible en actualizacion de per."
                );
            }
        }

        return destino;
    }

    
    // EXPRESIONES
    
    @Override
    public DataType visitExpresion(
            PigLatinParser.ExpresionContext ctx) {

        return visit(ctx.expresionOr());
    }

    @Override
    public DataType visitExpresionOr(
            PigLatinParser.ExpresionOrContext ctx) {

        if (ctx.expresionOr() == null) {
            return visit(ctx.expresionAnd());
        }

        DataType izquierda
                = visit(ctx.expresionOr());

        DataType derecha
                = visit(ctx.expresionAnd());

        return validarLogico(
                ctx.getStart().getLine(),
                izquierda,
                derecha,
                "||"
        );
    }

    @Override
    public DataType visitExpresionAnd(
            PigLatinParser.ExpresionAndContext ctx) {

        if (ctx.expresionAnd() == null) {
            return visit(ctx.expresionIgualdad());
        }

        DataType izquierda
                = visit(ctx.expresionAnd());

        DataType derecha
                = visit(ctx.expresionIgualdad());

        return validarLogico(
                ctx.getStart().getLine(),
                izquierda,
                derecha,
                "&&"
        );
    }

    @Override
    public DataType visitExpresionIgualdad(
            PigLatinParser.ExpresionIgualdadContext ctx) {

        if (ctx.expresionIgualdad() == null) {
            return visit(ctx.expresionRelacional());
        }

        DataType izquierda
                = visit(ctx.expresionIgualdad());

        DataType derecha
                = visit(ctx.expresionRelacional());

        if (!sonComparables(
                izquierda,
                derecha)) {

            error(
                    ctx.getStart().getLine(),
                    "No se pueden comparar "
                    + izquierda
                    + " y "
                    + derecha
                    + "."
            );
        }

        return DataType.BOOLEANO;
    }

    @Override
    public DataType visitExpresionRelacional(
            PigLatinParser.ExpresionRelacionalContext ctx) {

        if (ctx.expresionRelacional() == null) {
            return visit(ctx.expresionAditiva());
        }

        DataType izquierda
                = visit(ctx.expresionRelacional());

        DataType derecha
                = visit(ctx.expresionAditiva());

        if ((!esNumerico(izquierda)
                || !esNumerico(derecha))
                && izquierda
                != DataType.DESCONOCIDO
                && derecha
                != DataType.DESCONOCIDO) {

            error(
                    ctx.getStart().getLine(),
                    "Los operadores relacionales requieren operandos numericos."
            );
        }

        return DataType.BOOLEANO;
    }

    @Override
    public DataType visitExpresionAditiva(
            PigLatinParser.ExpresionAditivaContext ctx) {

        if (ctx.expresionAditiva() == null) {
            return visit(
                    ctx.expresionMultiplicativa()
            );
        }

        DataType izquierda
                = visit(ctx.expresionAditiva());

        DataType derecha
                = visit(
                        ctx.expresionMultiplicativa()
                );

        if (ctx.MAS() != null
                && (izquierda == DataType.CADENA
                || derecha == DataType.CADENA)) {

            return DataType.CADENA;
        }

        return validarAritmetico(
                ctx.getStart().getLine(),
                izquierda,
                derecha
        );
    }

    @Override
    public DataType visitExpresionMultiplicativa(
            PigLatinParser.ExpresionMultiplicativaContext ctx) {

        if (ctx.expresionMultiplicativa() == null) {
            return visit(ctx.expresionUnaria());
        }

        DataType izquierda
                = visit(
                        ctx.expresionMultiplicativa()
                );

        DataType derecha
                = visit(ctx.expresionUnaria());

        return validarAritmetico(
                ctx.getStart().getLine(),
                izquierda,
                derecha
        );
    }

    @Override
    public DataType visitExpresionUnaria(
            PigLatinParser.ExpresionUnariaContext ctx) {

        if (ctx.primario() != null) {
            return visit(ctx.primario());
        }

        DataType tipo
                = visit(ctx.expresionUnaria());

        if (ctx.NOT() != null
                || ctx.NON() != null) {

            if (tipo != DataType.BOOLEANO
                    && tipo
                    != DataType.DESCONOCIDO) {

                error(
                        ctx.getStart().getLine(),
                        "El operador logico de negacion requiere BOOLEANO."
                );
            }

            return DataType.BOOLEANO;
        }

        if (!esNumerico(tipo)
                && tipo
                != DataType.DESCONOCIDO) {

            error(
                    ctx.getStart().getLine(),
                    "El operador '-' unario requiere un valor numerico."
            );
        }

        return tipo;
    }

    
    // PRIMARIOS
    
    @Override
    public DataType visitPrimario(
            PigLatinParser.PrimarioContext ctx) {

        if (ctx.literal() != null) {
            return visit(ctx.literal());
        }

        if (ctx.creacionObjeto() != null) {

            return visit(
                    ctx.creacionObjeto()
            );
        }

        if (ctx.llamada() != null) {

            return visit(ctx.llamada());
        }

        if (ctx.expresion() != null) {
            return visit(ctx.expresion());
        }

        return DataType.DESCONOCIDO;
    }

    
// CREACION DE OBJETOS IMPORTADOS

    @Override
    public DataType visitCreacionObjeto(
            PigLatinParser.CreacionObjetoContext ctx) {

        String nombreClase
                = ctx.IDENTIFICADOR()
                        .getText();

        int linea
                = ctx.getStart().getLine();

        ClaseImportadaPig clase
                = registroImports.buscarClase(
                        nombreClase
                );

        if (clase == null) {

            error(
                    linea,
                    "No existe una clase importada llamada '"
                    + nombreClase
                    + "'."
            );

            if (ctx.listaArgumentos() != null) {
                visit(ctx.listaArgumentos());
            }

            return DataType.DESCONOCIDO;
        }

        List<DataType> tiposArgumentos
                = new ArrayList<>();

        if (ctx.listaArgumentos() != null) {

            for (PigLatinParser.ExpresionContext argumento
                    : ctx.listaArgumentos()
                            .expresion()) {

                tiposArgumentos.add(
                        visit(argumento)
                );
            }
        }

        String firma
                = construirFirmaExterna(
                        nombreClase,
                        tiposArgumentos
                );

        MetodoImportadoPig constructor
                = clase.buscarMetodoPorFirma(
                        firma
                );

        if (constructor == null
                || !constructor.esConstructor()) {

            error(
                    linea,
                    "No existe el constructor '"
                    + firma
                    + "'."
            );

            return DataType.DESCONOCIDO;
        }

        return DataType.OBJETO;
    }

    
    // LITERALES
    
    @Override
    public DataType visitLiteral(
            PigLatinParser.LiteralContext ctx) {

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

        if (ctx.VERUM() != null
                || ctx.FALSUS() != null) {

            return DataType.BOOLEANO;
        }

        return DataType.DESCONOCIDO;
    }

    
    // LLAMADAS
    
    @Override
    public DataType visitLlamada(
            PigLatinParser.LlamadaContext ctx) {

        int linea
                = ctx.getStart().getLine();

        
        // 1. LLAMADA BASADA EN ACCESO
        
        if (ctx.acceso() != null) {

            return visit(
                    ctx.acceso()
            );
        }

        
        // 2. LLAMADA GLOBAL
        
        String nombre
                = ctx.IDENTIFICADOR() != null
                ? ctx.IDENTIFICADOR().getText()
                : null;

        if (nombre == null
                || nombre.isBlank()) {

            error(
                    linea,
                    "No fue posible determinar el nombre de la funcion."
            );

            return DataType.DESCONOCIDO;
        }

        
        // 3. OBTENER TIPOS DE ARGUMENTOS
        
        List<String> tiposArgumentos
                = new ArrayList<>();

        if (ctx.listaArgumentos() != null) {

            for (PigLatinParser.ExpresionContext argumento
                    : ctx.listaArgumentos()
                            .expresion()) {

                DataType tipoArgumento
                        = visit(argumento);

                tiposArgumentos.add(
                        describirArgumentoImportadoY(
                                argumento,
                                tipoArgumento
                        )
                );
            }
        }

        
        // 4. CONSTRUIR FIRMA
        
        String firma
                = construirFirmaImportadaY(
                        nombre,
                        tiposArgumentos
                );

        
        // 5. BUSCAR CONTENEDOR DE FUNCIONES Y
        
        ClaseImportadaPig funcionesY
                = registroImports.buscarClase(
                        "$Y_GLOBAL"
                );

        if (funcionesY == null) {

            error(
                    linea,
                    "La funcion '"
                    + nombre
                    + "' no ha sido importada."
            );

            return DataType.DESCONOCIDO;
        }

        
        // 6. BUSCAR FIRMA
        
        MetodoImportadoPig funcion
                = funcionesY.buscarMetodoPorFirma(
                        firma
                );

        if (funcion == null) {

            error(
                    linea,
                    "No existe una funcion importada con firma '"
                    + firma
                    + "'."
            );

            return DataType.DESCONOCIDO;
        }

        
        // 7. OBTENER TIPO DE RETORNO
        
        return tipoExternoATipoPig(
                funcion.getTipoRetorno()
        );
    }

    @Override
    public DataType visitListaArgumentos(
            PigLatinParser.ListaArgumentosContext ctx) {

        for (PigLatinParser.ExpresionContext expresion
                : ctx.expresion()) {

            visit(expresion);
        }

        return DataType.DESCONOCIDO;
    }

    
    // INICIALIZACION VARIABLE
    
    @Override
    public DataType visitInicializacionVariable(
            PigLatinParser.InicializacionVariableContext ctx) {

        if (ctx.expresion() != null) {
            return visit(ctx.expresion());
        }

        if (ctx.inicializadorEstructura() != null) {

            visit(ctx.inicializadorEstructura());

            return DataType.OBJETO;
        }

        return DataType.DESCONOCIDO;
    }

    
    // TIPOS
    
    private DataType obtenerTipo(
            PigLatinParser.TipoContext ctx) {

        if (ctx.NUMERUS() != null) {
            return DataType.ENTERO;
        }

        if (ctx.TEXTUM() != null) {
            return DataType.CADENA;
        }

        if (ctx.DECIMALIS() != null) {
            return DataType.DECIMAL;
        }

        if (ctx.LITTERA() != null) {
            return DataType.CARACTER;
        }

        if (ctx.VERUM() != null
                || ctx.FALSUS() != null) {

            return DataType.BOOLEANO;
        }

        if (ctx.IDENTIFICADOR() != null) {

            return DataType.OBJETO;
        }

        return DataType.DESCONOCIDO;
    }

    private void validarInicializadorEstructura(
            PigLatinParser.InicializadorEstructuraContext ctx,
            ClaseImportadaPig clase) {

        if (ctx == null || clase == null) {
            return;
        }

        validarListaAtributosEstructura(
                ctx.listaInicializacion(),
                clase,
                ctx.getStart().getLine()
        );
    }

    private void validarListaAtributosEstructura(
            PigLatinParser.ListaInicializacionContext lista,
            ClaseImportadaPig clase,
            int linea) {

        List<AtributoImportadoPig> atributos
                = new ArrayList<>(
                        clase.getAtributos()
                );

        List<PigLatinParser.ValorInicializacionContext> valores
                = lista != null
                        ? lista.valorInicializacion()
                        : List.of();

        if (valores.size() != atributos.size()) {

            error(
                    linea,
                    "La estructura '"
                    + clase.getNombre()
                    + "' requiere "
                    + atributos.size()
                    + " valor(es), pero recibio "
                    + valores.size()
                    + "."
            );
        }

        int cantidad
                = Math.min(
                        atributos.size(),
                        valores.size()
                );

        for (int i = 0; i < cantidad; i++) {

            AtributoImportadoPig atributo
                    = atributos.get(i);

            PigLatinParser.ValorInicializacionContext valor
                    = valores.get(i);

            validarValorAtributoEstructura(
                    clase,
                    atributo,
                    valor
            );
        }
    }

    private void validarValorAtributoEstructura(
            ClaseImportadaPig claseContenedora,
            AtributoImportadoPig atributo,
            PigLatinParser.ValorInicializacionContext valor) {

        int linea
                = valor.getStart().getLine();

        // Los atributos arreglo se validarán completamente
        // en el bloque dedicado a arreglos de estructuras.
        if (atributo.esArreglo()) {

            if (valor.expresion() == null) {

                error(
                        linea,
                        "El atributo arreglo '"
                        + atributo.getNombre()
                        + "' de la estructura '"
                        + claseContenedora.getNombre()
                        + "' debe recibir un arreglo."
                );

                return;
            }

            DataType tipoValor
                    = visit(
                            valor.expresion()
                    );

            if (tipoValor != DataType.ARREGLO
                    && tipoValor != DataType.DESCONOCIDO) {

                error(
                        linea,
                        "El atributo '"
                        + atributo.getNombre()
                        + "' requiere un arreglo."
                );
            }

            return;
        }

        DataType tipoEsperado
                = tipoExternoATipoPig(
                        atributo.getTipo()
                );

        
        // ATRIBUTO QUE ES OTRA ESTRUCTURA
        
        if (tipoEsperado == DataType.OBJETO) {

            ClaseImportadaPig claseAnidada
                    = registroImports.buscarClase(
                            atributo.getTipo()
                    );

            if (valor.inicializadorLista() != null) {

                if (claseAnidada == null) {

                    error(
                            linea,
                            "No existe informacion importada para la estructura anidada '"
                            + atributo.getTipo()
                            + "'."
                    );

                    return;
                }

                validarListaAtributosEstructura(
                        valor.inicializadorLista()
                                .listaInicializacion(),
                        claseAnidada,
                        linea
                );

                return;
            }

            if (valor.expresion() == null) {

                error(
                        linea,
                        "El atributo '"
                        + atributo.getNombre()
                        + "' requiere una estructura de tipo '"
                        + atributo.getTipo()
                        + "'."
                );

                return;
            }

            DataType tipoRecibido
                    = visit(
                            valor.expresion()
                    );

            if (tipoRecibido != DataType.OBJETO
                    && tipoRecibido != DataType.DESCONOCIDO) {

                error(
                        linea,
                        "El atributo '"
                        + atributo.getNombre()
                        + "' de la estructura '"
                        + claseContenedora.getNombre()
                        + "' requiere un objeto de tipo '"
                        + atributo.getTipo()
                        + "'."
                );
            }

            return;
        }

        
        // ATRIBUTO PRIMITIVO
        
        if (valor.inicializadorLista() != null) {

            error(
                    linea,
                    "El atributo '"
                    + atributo.getNombre()
                    + "' de la estructura '"
                    + claseContenedora.getNombre()
                    + "' no acepta un inicializador { ... }."
            );

            return;
        }

        DataType tipoRecibido
                = valor.expresion() != null
                ? visit(valor.expresion())
                : DataType.DESCONOCIDO;

        if (!sonCompatibles(
                tipoEsperado,
                tipoRecibido)) {

            error(
                    linea,
                    "Tipo incorrecto para el atributo '"
                    + atributo.getNombre()
                    + "' de la estructura '"
                    + claseContenedora.getNombre()
                    + "': se esperaba "
                    + tipoEsperado
                    + " y se obtuvo "
                    + tipoRecibido
                    + "."
            );
        }
    }

    
    // VALIDACIONES AUXILIARES
    
    private void validarCondicion(
            int linea,
            DataType tipo) {

        if (tipo != DataType.BOOLEANO
                && tipo
                != DataType.DESCONOCIDO) {

            error(
                    linea,
                    "La condicion debe ser BOOLEANO y se obtuvo "
                    + tipo
                    + "."
            );
        }
    }

    private DataType validarLogico(
            int linea,
            DataType izquierda,
            DataType derecha,
            String operador) {

        if ((izquierda != DataType.BOOLEANO
                || derecha != DataType.BOOLEANO)
                && izquierda
                != DataType.DESCONOCIDO
                && derecha
                != DataType.DESCONOCIDO) {

            error(
                    linea,
                    "El operador '"
                    + operador
                    + "' requiere operandos BOOLEANO."
            );
        }

        return DataType.BOOLEANO;
    }

    private DataType validarAritmetico(
            int linea,
            DataType izquierda,
            DataType derecha) {

        if (izquierda == DataType.DESCONOCIDO
                || derecha == DataType.DESCONOCIDO) {

            return DataType.DESCONOCIDO;
        }

        if (!esNumerico(izquierda)
                || !esNumerico(derecha)) {

            error(
                    linea,
                    "Operacion aritmetica incompatible entre "
                    + izquierda
                    + " y "
                    + derecha
                    + "."
            );

            return DataType.DESCONOCIDO;
        }

        if (izquierda == DataType.DECIMAL
                || derecha == DataType.DECIMAL) {

            return DataType.DECIMAL;
        }

        return DataType.ENTERO;
    }

    private boolean esNumerico(
            DataType tipo) {

        return tipo == DataType.ENTERO
                || tipo == DataType.DECIMAL;
    }

    private boolean sonCompatibles(
            DataType destino,
            DataType origen) {

        if (destino == DataType.DESCONOCIDO
                || origen == DataType.DESCONOCIDO) {

            /*
             * Evitamos errores en cascada.
             */
            return true;
        }

        if (destino == origen) {
            return true;
        }

        return destino == DataType.DECIMAL
                && origen == DataType.ENTERO;
    }

    private boolean sonComparables(
            DataType izquierda,
            DataType derecha) {

        if (izquierda == DataType.DESCONOCIDO
                || derecha == DataType.DESCONOCIDO) {

            return true;
        }

        if (izquierda == derecha) {
            return true;
        }

        return esNumerico(izquierda)
                && esNumerico(derecha);
    }

    private void validarInicializadorArreglo(
            PigLatinParser.InicializadorListaContext ctx,
            Symbol simbolo,
            int dimensionActual) {

        if (ctx == null
                || simbolo == null) {

            return;
        }

        List<PigLatinParser.ValorInicializacionContext> valores
                = ctx.listaInicializacion() != null
                ? ctx.listaInicializacion()
                        .valorInicializacion()
                : List.of();

        if (dimensionActual
                >= simbolo.getDimensiones().size()) {

            error(
                    ctx.getStart().getLine(),
                    "El inicializador tiene mas niveles que las dimensiones del arreglo '"
                    + simbolo.getNombre()
                    + "'."
            );

            return;
        }

        int esperado
                = simbolo.getDimensiones()
                        .get(dimensionActual);

        if (valores.size() != esperado) {

            error(
                    ctx.getStart().getLine(),
                    "La dimension "
                    + (dimensionActual + 1)
                    + " del arreglo '"
                    + simbolo.getNombre()
                    + "' esperaba "
                    + esperado
                    + " elementos y recibio "
                    + valores.size()
                    + "."
            );
        }

        boolean ultimaDimension
                = dimensionActual
                == simbolo.getDimensiones().size() - 1;

        for (PigLatinParser.ValorInicializacionContext valor
                : valores) {

            if (ultimaDimension) {

                if (valor.inicializadorLista() != null) {

                    error(
                            valor.getStart().getLine(),
                            "Se encontro una lista anidada donde se esperaba un valor para el arreglo '"
                            + simbolo.getNombre()
                            + "'."
                    );

                    continue;
                }

                if (valor.expresion() != null) {

                    DataType tipoValor
                            = visit(
                                    valor.expresion()
                            );

                    if (!sonCompatibles(
                            simbolo.getTipoElemento(),
                            tipoValor)) {

                        error(
                                valor.getStart().getLine(),
                                "Elemento incompatible en arreglo '"
                                + simbolo.getNombre()
                                + "': se esperaba "
                                + simbolo.getTipoElemento()
                                + " y se obtuvo "
                                + tipoValor
                                + "."
                        );
                    }
                }

            } else {

                if (valor.inicializadorLista() == null) {

                    error(
                            valor.getStart().getLine(),
                            "La dimension "
                            + (dimensionActual + 1)
                            + " del arreglo '"
                            + simbolo.getNombre()
                            + "' requiere una lista anidada."
                    );

                    continue;
                }

                validarInicializadorArreglo(
                        valor.inicializadorLista(),
                        simbolo,
                        dimensionActual + 1
                );
            }
        }
    }

    private String convertirImportARuta(
            String importacion) {

        String texto
                = importacion.trim();

        String minuscula
                = texto.toLowerCase();

        String extension;

        if (minuscula.endsWith(".z")) {

            extension = ".z";

        } else if (minuscula.endsWith(".y")) {

            extension = ".y";

        } else {

            return texto;
        }

        String sinExtension
                = texto.substring(
                        0,
                        texto.length() - 2
                );

        sinExtension
                = sinExtension.replace(
                        '.',
                        java.io.File.separatorChar
                );

        return sinExtension + extension;
    }

    private String construirFirmaExterna(
            String nombre,
            List<DataType> parametros) {

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

            sb.append(
                    tipoPigATipoZ(
                            parametros.get(i)
                    )
            );
        }

        sb.append(")");

        return sb.toString();
    }

    private String tipoPigATipoZ(
            DataType tipo) {

        if (tipo == null) {
            return "any";
        }

        return switch (tipo) {

            case ENTERO ->
                "int";

            case DECIMAL ->
                "double";

            case CADENA ->
                "String";

            case CARACTER ->
                "char";

            case BOOLEANO ->
                "boolean";

            default ->
                "any";
        };
    }

    private DataType tipoExternoATipoPig(
            String tipo) {

        if (tipo == null) {
            return DataType.DESCONOCIDO;
        }

        String normalizado
                = tipo.trim();

        return switch (normalizado) {

            case "int", "entero", "numerus" ->
                DataType.ENTERO;

            case "double", "float", "decimal", "flotante", "decimalis" ->
                DataType.DECIMAL;

            case "String", "string", "cadena", "textum" ->
                DataType.CADENA;

            case "char", "caracter", "littera" ->
                DataType.CARACTER;

            case "boolean", "bool", "booleano", "verum", "falsus" ->
                DataType.BOOLEANO;

            case "void" ->
                DataType.VOID;

            case "any" ->
                DataType.DESCONOCIDO;

            default -> {

                if (registroImports.existeClase(
                        normalizado)) {

                    yield DataType.OBJETO;
                }

                yield DataType.DESCONOCIDO;
            }
        };
    }

    private String construirFirmaImportadaY(
            String nombre,
            List<String> parametros) {

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

            sb.append(
                    parametros.get(i)
            );
        }

        sb.append(")");

        return sb.toString();
    }

    private String describirArgumentoImportadoZ(
            PigLatinParser.ExpresionContext argumento,
            DataType tipoArgumento) {

        if (tipoArgumento != DataType.ARREGLO) {

            return tipoPigATipoZ(
                    tipoArgumento
            );
        }

        if (argumento == null) {
            return "any";
        }

        String nombre
                = argumento.getText();

        // Por ahora se soporta el paso directo
        // de una variable arreglo: metodo(arreglo).
        if (nombre == null
                || !nombre.matches(
                        "[a-zA-Z_][a-zA-Z0-9_]*"
                )) {

            return "any";
        }

        Symbol simbolo
                = tabla.buscar(
                        nombre
                );

        if (simbolo == null
                || simbolo.getTipo()
                != DataType.ARREGLO) {

            return "any";
        }

        String tipoBase;

        if (simbolo.getTipoElemento()
                == DataType.OBJETO) {

            tipoBase
                    = simbolo.getTipoReferencia();

        } else {

            tipoBase
                    = tipoPigATipoZ(
                            simbolo.getTipoElemento()
                    );
        }

        if (tipoBase == null
                || tipoBase.isBlank()
                || "any".equals(tipoBase)) {

            return "any";
        }

        int dimensiones
                = simbolo.getDimensiones().size();

        if (dimensiones <= 0) {
            return "any";
        }

        StringBuilder tipoCompleto
                = new StringBuilder(
                        tipoBase
                );

        for (int i = 0;
                i < dimensiones;
                i++) {

            tipoCompleto.append("[]");
        }

        return tipoCompleto.toString();
    }

    private String describirArgumentoImportadoY(
            PigLatinParser.ExpresionContext argumento,
            DataType tipoArgumento) {

        if (argumento == null) {
            return "any";
        }

        String nombre
                = argumento.getText();

        
        // ESTRUCTURA INDIVIDUAL ENVIADA A Y POR REFERENCIA
        
        if (tipoArgumento == DataType.OBJETO) {

            if (nombre == null
                    || !nombre.matches(
                            "[a-zA-Z_][a-zA-Z0-9_]*"
                    )) {

                return "any";
            }

            Symbol simboloObjeto
                    = tabla.buscar(
                            nombre
                    );

            if (simboloObjeto == null
                    || simboloObjeto.getTipo()
                    != DataType.OBJETO
                    || simboloObjeto.getTipoReferencia()
                    == null
                    || simboloObjeto.getTipoReferencia()
                            .isBlank()) {

                return "any";
            }

            return simboloObjeto.getTipoReferencia();
        }

        
        // TIPOS PRIMITIVOS
        
        if (tipoArgumento != DataType.ARREGLO) {

            return tipoPigATipoY(
                    tipoArgumento
            );
        }

        if (nombre == null
                || !nombre.matches(
                        "[a-zA-Z_][a-zA-Z0-9_]*"
                )) {

            return "any";
        }

        Symbol simbolo
                = tabla.buscar(
                        nombre
                );

        if (simbolo == null
                || simbolo.getTipo()
                != DataType.ARREGLO) {

            return "any";
        }

        String tipoBase;

        if (simbolo.getTipoElemento()
                == DataType.OBJETO) {

            tipoBase
                    = simbolo.getTipoReferencia();

        } else {

            tipoBase
                    = tipoPigATipoY(
                            simbolo.getTipoElemento()
                    );
        }

        if (tipoBase == null
                || tipoBase.isBlank()
                || "any".equals(tipoBase)) {

            return "any";
        }

        return tipoBase + "[]";
    }

    private String tipoPigATipoY(
            DataType tipo) {

        if (tipo == null) {
            return "any";
        }

        return switch (tipo) {

            case ENTERO ->
                "int";

            case DECIMAL ->
                "float";

            case CADENA ->
                "string";

            case CARACTER ->
                "char";

            case BOOLEANO ->
                "bool";

            default ->
                "any";
        };
    }
}
