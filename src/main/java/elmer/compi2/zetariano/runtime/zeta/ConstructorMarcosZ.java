/*
 */
package elmer.compi2.zetariano.runtime.zeta;

import elmer.compi2.zetariano.core.node.zeta.*;

/**
 *
 */
public class ConstructorMarcosZ {

    private final TablaMemoriaZ tabla;

    private MarcoMetodoZ marcoActual;
    private String nombreClaseActual;

    public ConstructorMarcosZ() {

        this.tabla
                = new TablaMemoriaZ();

        this.marcoActual = null;
        this.nombreClaseActual = null;
    }

    public TablaMemoriaZ construir(
            ProgramaASTZ programa) {

        if (programa == null
                || programa.getClase() == null) {

            return tabla;
        }

        return construir(java.util.Collections.singletonList(programa));
    }

    public TablaMemoriaZ construir(
            java.util.List<ProgramaASTZ> programas) {

        if (programas == null || programas.isEmpty()) {
            return tabla;
        }

        java.util.Map<String, ClaseASTZ> clasesAST = new java.util.LinkedHashMap<>();
        for (ProgramaASTZ programa : programas) {
            if (programa != null && programa.getClase() != null) {
                clasesAST.put(programa.getClase().getNombre(), programa.getClase());
            }
        }

        for (String nombreClase : clasesAST.keySet()) {
            construirLayoutClase(nombreClase, clasesAST, new java.util.HashSet<>());
        }

        for (ProgramaASTZ programa : programas) {
            if (programa == null || programa.getClase() == null) {
                continue;
            }

            ClaseASTZ clase = programa.getClase();
            nombreClaseActual = clase.getNombre();

            for (MiembroASTZ miembro : clase.getMiembros()) {
                if (miembro instanceof ConstructorASTZ constructor) {
                    procesarConstructor(constructor);
                } else if (miembro instanceof MetodoASTZ metodo) {
                    procesarMetodo(metodo);
                }
            }
        }

        return tabla;
    }

    public ClaseMemoriaZ construirLayoutClase(
            String nombreClase,
            java.util.Map<String, ClaseASTZ> clasesAST,
            java.util.Set<String> visitadas) {

        ClaseMemoriaZ existente = tabla.buscarClase(nombreClase);
        if (existente != null) {
            return existente;
        }

        if (nombreClase == null || !visitadas.add(nombreClase)) {
            return null;
        }

        ClaseASTZ claseAST = clasesAST.get(nombreClase);
        if (claseAST == null) {
            visitadas.remove(nombreClase);
            return null;
        }

        ClaseMemoriaZ layout = new ClaseMemoriaZ(nombreClase);
        layout.setNombrePadre(claseAST.getNombrePadre());

        if (claseAST.tienePadre()) {
            ClaseMemoriaZ padre = construirLayoutClase(
                    claseAST.getNombrePadre(),
                    clasesAST,
                    visitadas
            );
            if (padre != null) {
                for (AtributoMemoriaZ atributo : padre.getAtributos().values()) {
                    layout.registrarAtributo(
                            atributo.getNombre(),
                            atributo.getTipo(),
                            atributo.getDimensiones()
                    );
                }
            }
        }

        for (MiembroASTZ miembro : claseAST.getMiembros()) {
            if (miembro instanceof AtributoASTZ atributo) {
                layout.registrarAtributo(
                        atributo.getNombre(),
                        atributo.getTipo(),
                        atributo.getDimensiones()
                );
            }
        }

        tabla.registrarClase(layout);
        visitadas.remove(nombreClase);
        return layout;
    }

    public static String construirFirmaEnlaceMetodo(
            String nombreClase,
            String firmaMetodo) {

        if (nombreClase == null || nombreClase.isBlank()) {
            return firmaMetodo;
        }

        return nombreClase + "." + firmaMetodo;
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

        marcoActual
                = new MarcoMetodoZ(
                        firma
                );

        registrarParametros(
                constructor.getParametros()
        );

        procesarSentencia(
                constructor.getCuerpo()
        );

        tabla.registrar(
                marcoActual
        );

        marcoActual = null;
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

        marcoActual
                = new MarcoMetodoZ(
                        construirFirmaEnlaceMetodo(
                                nombreClaseActual,
                                firma
                        ),
                        metodo.getTipoRetorno()
                );

        registrarParametros(
                metodo.getParametros()
        );

        procesarSentencia(
                metodo.getCuerpo()
        );

        tabla.registrar(
                marcoActual
        );

        marcoActual = null;
    }

    // =========================================================
    // PARAMETROS
    // =========================================================
    private void registrarParametros(
            java.util.List<ParametroASTZ> parametros) {

        for (ParametroASTZ parametro
                : parametros) {

            marcoActual.registrarParametro(
                    parametro.getNombre(),
                    parametro.getTipo(),
                    parametro.getDimensiones()
            );
        }
    }

    // =========================================================
    // SENTENCIAS
    // =========================================================
    private void procesarSentencia(
            SentenciaASTZ sentencia) {

        if (sentencia == null
                || marcoActual == null) {

            return;
        }

        // -----------------------------------------------------
        // BLOQUE
        // -----------------------------------------------------
        if (sentencia instanceof BloqueASTZ bloque) {

            for (SentenciaASTZ hijo
                    : bloque.getSentencias()) {

                procesarSentencia(
                        hijo
                );
            }

            return;
        }

        // -----------------------------------------------------
        // DECLARACION
        // -----------------------------------------------------
        if (sentencia instanceof DeclaracionASTZ declaracion) {

            registrarDeclaracion(
                    declaracion
            );

            return;
        }

        // -----------------------------------------------------
        // IF
        // -----------------------------------------------------
        if (sentencia instanceof IfASTZ sentenciaIf) {

            for (IfASTZ.RamaIf rama
                    : sentenciaIf.getRamas()) {

                procesarSentencia(
                        rama.getCuerpo()
                );
            }

            if (sentenciaIf.getCuerpoElse() != null) {

                procesarSentencia(
                        sentenciaIf.getCuerpoElse()
                );
            }

            return;
        }

        // -----------------------------------------------------
        // WHILE
        // -----------------------------------------------------
        if (sentencia instanceof WhileASTZ ciclo) {

            procesarSentencia(
                    ciclo.getCuerpo()
            );

            return;
        }

        // -----------------------------------------------------
        // DO WHILE
        // -----------------------------------------------------
        if (sentencia instanceof DoWhileASTZ ciclo) {

            procesarSentencia(
                    ciclo.getCuerpo()
            );

            return;
        }

        // -----------------------------------------------------
        // FOR
        // -----------------------------------------------------
        if (sentencia instanceof ForASTZ ciclo) {

            if (ciclo.getInicializacion() instanceof DeclaracionASTZ declaracion) {

                registrarDeclaracion(
                        declaracion
                );
            }

            procesarSentencia(
                    ciclo.getCuerpo()
            );

            return;
        }

        // -----------------------------------------------------
        // SWITCH
        // -----------------------------------------------------
        if (sentencia instanceof SwitchASTZ seleccion) {

            for (CasoSwitchASTZ caso
                    : seleccion.getCasos()) {

                for (SentenciaASTZ sentenciaCaso
                        : caso.getSentencias()) {

                    procesarSentencia(
                            sentenciaCaso
                    );
                }
            }

            for (SentenciaASTZ sentenciaDefault
                    : seleccion.getDefecto()) {

                procesarSentencia(
                        sentenciaDefault
                );
            }
        }
    }

    // =========================================================
    // DECLARACION
    // =========================================================
    private void registrarDeclaracion(
            DeclaracionASTZ declaracion) {

        if (declaracion == null
                || marcoActual == null) {

            return;
        }

        marcoActual.registrarLocal(
                declaracion
        );
    }

    // =========================================================
    // FIRMA
    // =========================================================
    private String construirFirma(
            String nombre,
            java.util.List<ParametroASTZ> parametros) {

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
}
