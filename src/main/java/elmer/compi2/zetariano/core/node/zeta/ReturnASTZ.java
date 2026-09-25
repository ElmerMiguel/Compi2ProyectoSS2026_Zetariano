/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class ReturnASTZ extends SentenciaASTZ {

    private final ExpresionASTZ expresion;

    public ReturnASTZ(
            ExpresionASTZ expresion,
            int linea,
            int columna) {

        super(linea, columna);

        this.expresion = expresion;
    }

    public ExpresionASTZ getExpresion() {
        return expresion;
    }

    @Override
    public String getNombreNodo() {
        return "RETURN";
    }
}
