/*
 */
package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class ClaseASTZ extends NodoASTZ {

    private final String nombre;
    private final List<MiembroASTZ> miembros;

    public ClaseASTZ(
            String nombre,
            int linea,
            int columna) {

        super(linea, columna);

        this.nombre = nombre;
        this.miembros = new ArrayList<>();
    }

    public String getNombre() {
        return nombre;
    }

    public List<MiembroASTZ> getMiembros() {
        return miembros;
    }

    public void agregarMiembro(
            MiembroASTZ miembro) {

        if (miembro != null) {
            miembros.add(miembro);
        }
    }

    @Override
    public String getNombreNodo() {
        return "CLASE";
    }
}
