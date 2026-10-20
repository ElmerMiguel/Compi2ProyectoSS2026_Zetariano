/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class ForASTPig
        extends SentenciaASTPig {

    private final SentenciaASTPig inicializacion;
    private final ExpresionASTPig condicion;
    private final SentenciaASTPig actualizacion;
    private final BloqueASTPig cuerpo;

    public ForASTPig(
            SentenciaASTPig inicializacion,
            ExpresionASTPig condicion,
            SentenciaASTPig actualizacion,
            BloqueASTPig cuerpo,
            int linea,
            int columna) {

        super(linea, columna);

        this.inicializacion = inicializacion;
        this.condicion = condicion;
        this.actualizacion = actualizacion;
        this.cuerpo = cuerpo;
    }

    public SentenciaASTPig getInicializacion() {
        return inicializacion;
    }

    public ExpresionASTPig getCondicion() {
        return condicion;
    }

    public SentenciaASTPig getActualizacion() {
        return actualizacion;
    }

    public BloqueASTPig getCuerpo() {
        return cuerpo;
    }

    @Override
    public String generarTexto() {

        return "FOR\n"
                + "  INIT: "
                + (inicializacion == null
                        ? "(vacio)"
                        : inicializacion.generarTexto())
                + "\n  COND: "
                + (condicion == null
                        ? "(vacio)"
                        : condicion.generarTexto())
                + "\n  UPDATE: "
                + (actualizacion == null
                        ? "(vacio)"
                        : actualizacion.generarTexto())
                + "\n  "
                + cuerpo.generarTexto();
    }
}
