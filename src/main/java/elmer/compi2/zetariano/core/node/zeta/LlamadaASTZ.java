/*
 */
package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class LlamadaASTZ extends ExpresionASTZ {

    private final String nombre;
    private final List<ExpresionASTZ> argumentos;

    public LlamadaASTZ(
            String nombre,
            List<ExpresionASTZ> argumentos,
            int linea,
            int columna) {

        super(linea, columna);

        this.nombre = nombre;

        if (argumentos == null) {
            this.argumentos = new ArrayList<>();
        } else {
            this.argumentos = new ArrayList<>(argumentos);
        }
    }

    public String getNombre() {
        return nombre;
    }

    public List<ExpresionASTZ> getArgumentos() {
        return argumentos;
    }

    @Override
    public String getNombreNodo() {
        return "LLAMADA";
    }
}
