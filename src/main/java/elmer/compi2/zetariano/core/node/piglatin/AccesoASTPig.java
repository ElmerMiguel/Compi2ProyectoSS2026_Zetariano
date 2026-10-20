/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */
public class AccesoASTPig
        extends ExpresionASTPig {

    private final String identificador;

    private final List<PasoAccesoASTPig> pasos;

    public AccesoASTPig(
            String identificador,
            int linea,
            int columna) {

        super(linea, columna);

        this.identificador
                = identificador;

        this.pasos
                = new ArrayList<>();
    }

    public String getIdentificador() {
        return identificador;
    }

    public void agregarPaso(
            PasoAccesoASTPig paso) {

        if (paso != null) {
            pasos.add(paso);
        }
    }

    public List<PasoAccesoASTPig> getPasos() {

        return Collections.unmodifiableList(
                pasos
        );
    }

    public boolean esSimple() {
        return pasos.isEmpty();
    }

    @Override
    public String generarTexto() {

        StringBuilder sb
                = new StringBuilder(
                        identificador
                );

        for (PasoAccesoASTPig paso
                : pasos) {

            sb.append(
                    paso.generarTexto()
            );
        }

        return "ACCESO: " + sb;
    }

    @Override
    public String toString() {
        return generarTexto();
    }
}
