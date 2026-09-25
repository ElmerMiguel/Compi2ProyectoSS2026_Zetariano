/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */
public class InicializadorListaASTPig
        extends ExpresionASTPig {

    private final List<ExpresionASTPig> valores;

    public InicializadorListaASTPig(
            int linea,
            int columna) {

        super(linea, columna);

        this.valores
                = new ArrayList<>();
    }

    public void agregarValor(
            ExpresionASTPig valor) {

        if (valor != null) {
            valores.add(valor);
        }
    }

    public List<ExpresionASTPig> getValores() {

        return Collections.unmodifiableList(
                valores
        );
    }

    @Override
    public String generarTexto() {

        StringBuilder sb
                = new StringBuilder();

        sb.append("LISTA{");

        for (int i = 0;
                i < valores.size();
                i++) {

            if (i > 0) {
                sb.append(", ");
            }

            sb.append(
                    valores.get(i)
                            .generarTexto()
            );
        }

        sb.append("}");

        return sb.toString();
    }
}
