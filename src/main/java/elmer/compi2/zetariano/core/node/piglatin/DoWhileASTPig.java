/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class DoWhileASTPig
        extends SentenciaASTPig {

    private final BloqueASTPig cuerpo;
    private final ExpresionASTPig condicion;

    public DoWhileASTPig(
            BloqueASTPig cuerpo,
            ExpresionASTPig condicion,
            int linea,
            int columna) {

        super(linea, columna);

        this.cuerpo = cuerpo;
        this.condicion = condicion;
    }

    public BloqueASTPig getCuerpo() {
        return cuerpo;
    }

    public ExpresionASTPig getCondicion() {
        return condicion;
    }

    @Override
    public String generarTexto() {

        return "DO\n  "
                + cuerpo.generarTexto()
                + "\nWHILE "
                + condicion.generarTexto();
    }
}
