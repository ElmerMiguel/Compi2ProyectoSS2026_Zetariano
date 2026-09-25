/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */
public class LlamadaASTPig extends ExpresionASTPig {

    private final ExpresionASTPig receptor;
    private final String nombre;
    private final List<ExpresionASTPig> argumentos;

    public LlamadaASTPig(
            ExpresionASTPig receptor,
            String nombre,
            int linea,
            int columna) {

        super(linea, columna);

        this.receptor = receptor;
        this.nombre = nombre;
        this.argumentos = new ArrayList<>();
    }

    public ExpresionASTPig getReceptor() {
        return receptor;
    }

    public String getNombre() {
        return nombre;
    }

    public void agregarArgumento(
            ExpresionASTPig argumento) {

        if (argumento != null) {

            argumentos.add(argumento);
        }
    }

    public List<ExpresionASTPig> getArgumentos() {

        return Collections.unmodifiableList(
                argumentos
        );
    }

    public boolean esGlobal() {
        return receptor == null;
    }

    @Override
    public String generarTexto() {

        StringBuilder sb
                = new StringBuilder();

        sb.append("LLAMADA: ");

        if (receptor != null) {

            sb.append(
                    receptor.generarTexto()
            );

            sb.append(".");
        }

        sb.append(nombre)
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