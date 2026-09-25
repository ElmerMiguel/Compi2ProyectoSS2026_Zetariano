/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class DoWhileASTZ extends SentenciaASTZ {

    private final SentenciaASTZ cuerpo;
    private final ExpresionASTZ condicion;

    public DoWhileASTZ(
            SentenciaASTZ cuerpo,
            ExpresionASTZ condicion,
            int linea,
            int columna) {

        super(linea, columna);

        this.cuerpo = cuerpo;
        this.condicion = condicion;
    }

    public SentenciaASTZ getCuerpo() {
        return cuerpo;
    }

    public ExpresionASTZ getCondicion() {
        return condicion;
    }

    @Override
    public String getNombreNodo() {
        return "DO_WHILE";
    }
}
