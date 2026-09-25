/*
 */
package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class InicializadorListaASTZ extends ExpresionASTZ {

    private final List<ExpresionASTZ> elementos;

    public InicializadorListaASTZ(
            List<ExpresionASTZ> elementos,
            int linea,
            int columna) {

        super(linea, columna);

        if (elementos == null) {
            this.elementos = new ArrayList<>();
        } else {
            this.elementos = new ArrayList<>(elementos);
        }
    }

    public List<ExpresionASTZ> getElementos() {
        return elementos;
    }

    @Override
    public String getNombreNodo() {
        return "INICIALIZADOR_LISTA";
    }
}
