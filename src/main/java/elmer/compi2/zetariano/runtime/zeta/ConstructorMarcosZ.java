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

    public ConstructorMarcosZ() {

        this.tabla
                = new TablaMemoriaZ();

        this.marcoActual = null;
    }

    public TablaMemoriaZ construir(
            ProgramaASTZ programa) {

        if (programa == null
                || programa.getClase() == null) {

            return tabla;
        }

        ClaseASTZ clase
                = programa.getClase();

        ClaseMemoriaZ claseMemoria
                = new ClaseMemoriaZ(
                        clase.getNombre()
                );
        for (MiembroASTZ miembro
                : clase.getMiembros()) {

            if (miembro instanceof AtributoASTZ atributo) {

                claseMemoria.registrarAtributo(
                        atributo.getNombre(),
                        atributo.getTipo(),
                        atributo.getDimensiones()
                );
            }
        }

        tabla.registrarClase(
                claseMemoria
        );

        for (MiembroASTZ miembro
                : clase.getMiembros()) {

            if (miembro instanceof ConstructorASTZ constructor) {

                procesarConstructor(
                        constructor
                );

            } else if (miembro instanceof MetodoASTZ metodo) {

                procesarMetodo(
                        metodo
                );
            }
        }

        return tabla;
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
                        firma,
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
