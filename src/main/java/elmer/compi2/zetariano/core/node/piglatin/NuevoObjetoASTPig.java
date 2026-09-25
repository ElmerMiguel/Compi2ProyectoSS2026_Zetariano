/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */
public class NuevoObjetoASTPig
        extends ExpresionASTPig {

    private final String tipoObjeto;

    private final List<ExpresionASTPig> argumentos;

    public NuevoObjetoASTPig(
            String tipoObjeto,
            int linea,
            int columna) {

        super(linea, columna);

        this.tipoObjeto = tipoObjeto;

        this.argumentos
                = new ArrayList<>();
    }

    public String getTipoObjeto() {
        return tipoObjeto;
    }

    public void agregarArgumento(
            ExpresionASTPig argumento) {

        if (argumento != null) {

            argumentos.add(
                    argumento
            );
        }
    }

    public List<ExpresionASTPig> getArgumentos() {

        return Collections.unmodifiableList(
                argumentos
        );
    }

    @Override
    public String generarTexto() {

        StringBuilder sb
                = new StringBuilder();

        sb.append("NOVUS ")
                .append(tipoObjeto)
                .append("(");

        for (int i = 0;
                i < argumentos.size();
                i++) {

            if (i > 0) {
                sb.append(", ");
            }

            sb.append(
                    argumentos
                            .get(i)
                            .generarTexto()
            );
        }

        sb.append(")");

        return sb.toString();
    }

    @Override
    public String toString() {
        return generarTexto();
    }
}
