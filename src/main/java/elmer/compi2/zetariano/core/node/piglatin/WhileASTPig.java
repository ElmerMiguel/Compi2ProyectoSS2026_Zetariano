/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class WhileASTPig
        extends SentenciaASTPig {

    private final ExpresionASTPig condicion;
    private final BloqueASTPig cuerpo;

    public WhileASTPig(
            ExpresionASTPig condicion,
            BloqueASTPig cuerpo,
            int linea,
            int columna) {

        super(linea, columna);

        this.condicion = condicion;
        this.cuerpo = cuerpo;
    }

    public ExpresionASTPig getCondicion() {
        return condicion;
    }

    public BloqueASTPig getCuerpo() {
        return cuerpo;
    }

    @Override
    public String generarTexto() {

        return "WHILE "
                + condicion.generarTexto()
                + "\n  "
                + cuerpo.generarTexto();
    }
}