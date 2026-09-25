/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class ParametroASTZ extends NodoASTZ {

    private final String nombre;
    private final String tipo;
    private final int dimensiones;

    public ParametroASTZ(
            String nombre,
            String tipo,
            int dimensiones,
            int linea,
            int columna) {

        super(linea, columna);

        this.nombre = nombre;
        this.tipo = tipo;
        this.dimensiones = dimensiones;
    }

    public String getNombre() {
        return nombre;
    }

    public String getTipo() {
        return tipo;
    }

    public int getDimensiones() {
        return dimensiones;
    }

    @Override
    public String getNombreNodo() {
        return "PARAMETRO";
    }
}
