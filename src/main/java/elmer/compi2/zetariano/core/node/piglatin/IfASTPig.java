/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class IfASTPig
        extends SentenciaASTPig {

    private final ExpresionASTPig condicion;
    private final BloqueASTPig bloqueVerdadero;
    private final BloqueASTPig bloqueFalso;

    public IfASTPig(
            ExpresionASTPig condicion,
            BloqueASTPig bloqueVerdadero,
            BloqueASTPig bloqueFalso,
            int linea,
            int columna) {

        super(linea, columna);

        this.condicion = condicion;
        this.bloqueVerdadero = bloqueVerdadero;
        this.bloqueFalso = bloqueFalso;
    }

    public ExpresionASTPig getCondicion() {
        return condicion;
    }

    public BloqueASTPig getBloqueVerdadero() {
        return bloqueVerdadero;
    }

    public BloqueASTPig getBloqueFalso() {
        return bloqueFalso;
    }

    @Override
    public String generarTexto() {

        StringBuilder sb
                = new StringBuilder();

        sb.append("IF ")
                .append(
                        condicion.generarTexto()
                );

        sb.append("\n  ")
                .append(
                        bloqueVerdadero.generarTexto()
                );

        if (bloqueFalso != null) {

            sb.append("\nELSE\n  ")
                    .append(
                            bloqueFalso.generarTexto()
                    );
        }

        return sb.toString();
    }
}