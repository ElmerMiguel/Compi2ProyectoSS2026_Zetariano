/*
 */
package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class NuevoArregloASTZ extends ExpresionASTZ {

    private final String tipoBase;
    private final List<ExpresionASTZ> dimensiones;

    public NuevoArregloASTZ(
            String tipoBase,
            List<ExpresionASTZ> dimensiones,
            int linea,
            int columna) {

        super(linea, columna);

        this.tipoBase = tipoBase;

        if (dimensiones == null) {
            this.dimensiones = new ArrayList<>();
        } else {
            this.dimensiones = new ArrayList<>(dimensiones);
        }
    }

    public String getTipoBase() {
        return tipoBase;
    }

    public List<ExpresionASTZ> getDimensiones() {
        return dimensiones;
    }

    @Override
    public String getNombreNodo() {
        return "NUEVO_ARREGLO";
    }
}
