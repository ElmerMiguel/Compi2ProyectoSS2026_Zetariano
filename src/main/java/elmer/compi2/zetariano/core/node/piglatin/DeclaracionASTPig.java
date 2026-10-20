/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */

public class DeclaracionASTPig
        extends SentenciaASTPig {

    private final String nombre;
    private final String tipo;
    private final String tipoReferencia;

    private final List<Integer> dimensiones;

    private final ExpresionASTPig inicializador;

    public DeclaracionASTPig(
            String nombre,
            String tipo,
            String tipoReferencia,
            List<Integer> dimensiones,
            ExpresionASTPig inicializador,
            int linea,
            int columna) {

        super(linea, columna);

        this.nombre = nombre;
        this.tipo = tipo;
        this.tipoReferencia = tipoReferencia;

        this.dimensiones
                = dimensiones == null
                        ? new ArrayList<>()
                        : new ArrayList<>(dimensiones);

        this.inicializador
                = inicializador;
    }

    public String getNombre() {
        return nombre;
    }

    public String getTipo() {
        return tipo;
    }

    public String getTipoReferencia() {
        return tipoReferencia;
    }

    public List<Integer> getDimensiones() {

        return Collections.unmodifiableList(
                dimensiones
        );
    }

    public ExpresionASTPig getInicializador() {
        return inicializador;
    }

    public boolean esArreglo() {
        return !dimensiones.isEmpty();
    }

    @Override
    public String generarTexto() {

        StringBuilder sb
                = new StringBuilder();

        sb.append("DECLARACION: ")
                .append(nombre)
                .append(" : ");

        if (tipoReferencia != null) {
            sb.append(tipoReferencia);
        } else {
            sb.append(tipo);
        }

        for (Integer dimension
                : dimensiones) {

            sb.append("[")
                    .append(dimension)
                    .append("]");
        }

        if (inicializador != null) {

            sb.append(" = ")
                    .append(
                            inicializador.generarTexto()
                    );
        }

        return sb.toString();
    }
}
