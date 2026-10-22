package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/** Nodo AST que representa la definicion de una clase en Zetariano. */
public class ClaseASTZ extends NodoASTZ {

    private final String nombre;
    private final String nombrePadre;
    private final List<MiembroASTZ> miembros;

    public ClaseASTZ(
            String nombre,
            int linea,
            int columna) {

        this(nombre, null, linea, columna);
    }

    public ClaseASTZ(
            String nombre,
            String nombrePadre,
            int linea,
            int columna) {

        super(linea, columna);

        this.nombre = nombre;
        this.nombrePadre = nombrePadre;
        this.miembros = new ArrayList<>();
    }

    public String getNombre() {
        return nombre;
    }

    public String getNombrePadre() {
        return nombrePadre;
    }

    public boolean tienePadre() {
        return nombrePadre != null && !nombrePadre.isBlank();
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
