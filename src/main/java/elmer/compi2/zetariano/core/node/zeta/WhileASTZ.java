/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class WhileASTZ extends SentenciaASTZ {

    private final ExpresionASTZ condicion;
    private final SentenciaASTZ cuerpo;

    public WhileASTZ(
            ExpresionASTZ condicion,
            SentenciaASTZ cuerpo,
            int linea,
            int columna) {

        super(linea, columna);

        this.condicion = condicion;
        this.cuerpo = cuerpo;
    }

    public ExpresionASTZ getCondicion() {
        return condicion;
    }

    public SentenciaASTZ getCuerpo() {
        return cuerpo;
    }

    @Override
    public String getNombreNodo() {
        return "WHILE";
    }
}
