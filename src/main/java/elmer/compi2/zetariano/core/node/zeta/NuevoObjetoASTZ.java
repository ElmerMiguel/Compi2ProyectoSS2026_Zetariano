/*
 */
package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class NuevoObjetoASTZ extends ExpresionASTZ {

    private final String tipo;
    private final List<ExpresionASTZ> argumentos;

    public NuevoObjetoASTZ(
            String tipo,
            List<ExpresionASTZ> argumentos,
            int linea,
            int columna) {

        super(linea, columna);

        this.tipo = tipo;

        if (argumentos == null) {
            this.argumentos = new ArrayList<>();
        } else {
            this.argumentos = new ArrayList<>(argumentos);
        }
    }

    public String getTipo() {
        return tipo;
    }

    public List<ExpresionASTZ> getArgumentos() {
        return argumentos;
    }

    @Override
    public String getNombreNodo() {
        return "NUEVO_OBJETO";
    }
}
