/*
 */
package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class AccesoASTZ extends ExpresionASTZ {

    private final String base;
    private final List<PasoAccesoASTZ> pasos;

    public AccesoASTZ(
            String base,
            int linea,
            int columna) {

        super(linea, columna);

        this.base = base;
        this.pasos = new ArrayList<>();
    }

    public String getBase() {
        return base;
    }

    public List<PasoAccesoASTZ> getPasos() {
        return pasos;
    }

    public void agregarPaso(
            PasoAccesoASTZ paso) {

        if (paso != null) {
            pasos.add(paso);
        }
    }

    @Override
    public String getNombreNodo() {
        return "ACCESO";
    }
}
