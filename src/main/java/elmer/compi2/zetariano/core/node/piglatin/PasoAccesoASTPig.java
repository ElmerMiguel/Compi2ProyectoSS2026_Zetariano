/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */
public class PasoAccesoASTPig {

    public enum TipoPaso {
        ATRIBUTO,
        INDICE,
        LLAMADA
    }

    private final TipoPaso tipo;
    private final String nombre;
    private final ExpresionASTPig indice;
    private final List<ExpresionASTPig> argumentos;

    private PasoAccesoASTPig(
            TipoPaso tipo,
            String nombre,
            ExpresionASTPig indice,
            List<ExpresionASTPig> argumentos) {

        this.tipo = tipo;
        this.nombre = nombre;
        this.indice = indice;

        this.argumentos
                = argumentos == null
                        ? new ArrayList<>()
                        : new ArrayList<>(argumentos);
    }

    // =========================================================
    // ATRIBUTO
    // =========================================================
    public static PasoAccesoASTPig atributo(
            String nombre) {

        return new PasoAccesoASTPig(
                TipoPaso.ATRIBUTO,
                nombre,
                null,
                null
        );
    }

    // =========================================================
    // INDICE
    // =========================================================
    public static PasoAccesoASTPig indice(
            ExpresionASTPig indice) {

        return new PasoAccesoASTPig(
                TipoPaso.INDICE,
                null,
                indice,
                null
        );
    }

    // =========================================================
    // LLAMADA
    // =========================================================
    public static PasoAccesoASTPig llamada(
            String nombre,
            List<ExpresionASTPig> argumentos) {

        return new PasoAccesoASTPig(
                TipoPaso.LLAMADA,
                nombre,
                null,
                argumentos
        );
    }

    public TipoPaso getTipo() {
        return tipo;
    }

    public String getNombre() {
        return nombre;
    }

    public ExpresionASTPig getIndice() {
        return indice;
    }

    public List<ExpresionASTPig> getArgumentos() {

        return Collections.unmodifiableList(
                argumentos
        );
    }

    public String generarTexto() {

        return switch (tipo) {

            case ATRIBUTO ->
                "." + nombre;

            case INDICE ->
                "["
                + (indice == null
                ? "?"
                : indice.generarTexto())
                + "]";

            case LLAMADA -> {

                StringBuilder sb
                        = new StringBuilder();

                sb.append(".")
                        .append(nombre)
                        .append("(");

                for (int i = 0;
                        i < argumentos.size();
                        i++) {

                    if (i > 0) {
                        sb.append(", ");
                    }

                    sb.append(
                            argumentos.get(i)
                                    .generarTexto()
                    );
                }

                sb.append(")");

                yield sb.toString();
            }
        };
    }
}
