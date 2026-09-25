/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class TernariaASTZ extends ExpresionASTZ {

    private final ExpresionASTZ condicion;
    private final ExpresionASTZ verdadero;
    private final ExpresionASTZ falso;

    public TernariaASTZ(
            ExpresionASTZ condicion,
            ExpresionASTZ verdadero,
            ExpresionASTZ falso,
            int linea,
            int columna) {

        super(linea, columna);

        this.condicion = condicion;
        this.verdadero = verdadero;
        this.falso = falso;
    }

    public ExpresionASTZ getCondicion() {
        return condicion;
    }

    public ExpresionASTZ getVerdadero() {
        return verdadero;
    }

    public ExpresionASTZ getFalso() {
        return falso;
    }

    @Override
    public String getNombreNodo() {
        return "TERNARIA";
    }
}
