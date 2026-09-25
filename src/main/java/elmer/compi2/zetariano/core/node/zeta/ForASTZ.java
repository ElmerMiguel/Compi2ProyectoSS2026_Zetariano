/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class ForASTZ extends SentenciaASTZ {

    private final NodoASTZ inicializacion;
    private final ExpresionASTZ condicion;
    private final NodoASTZ actualizacion;
    private final SentenciaASTZ cuerpo;

    public ForASTZ(
            NodoASTZ inicializacion,
            ExpresionASTZ condicion,
            NodoASTZ actualizacion,
            SentenciaASTZ cuerpo,
            int linea,
            int columna) {

        super(linea, columna);

        this.inicializacion = inicializacion;
        this.condicion = condicion;
        this.actualizacion = actualizacion;
        this.cuerpo = cuerpo;
    }

    public NodoASTZ getInicializacion() {
        return inicializacion;
    }

    public ExpresionASTZ getCondicion() {
        return condicion;
    }

    public NodoASTZ getActualizacion() {
        return actualizacion;
    }

    public SentenciaASTZ getCuerpo() {
        return cuerpo;
    }

    @Override
    public String getNombreNodo() {
        return "FOR";
    }
}
