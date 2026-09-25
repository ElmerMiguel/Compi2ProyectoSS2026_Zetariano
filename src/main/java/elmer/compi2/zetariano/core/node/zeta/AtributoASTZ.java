/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class AtributoASTZ extends MiembroASTZ {

    private final String nombre;
    private final String tipo;
    private final int dimensiones;
    private final ExpresionASTZ inicializador;

    public AtributoASTZ(
            String nombre,
            String tipo,
            int dimensiones,
            ExpresionASTZ inicializador,
            int linea,
            int columna) {

        super(linea, columna);

        this.nombre = nombre;
        this.tipo = tipo;
        this.dimensiones = dimensiones;
        this.inicializador = inicializador;
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

    public ExpresionASTZ getInicializador() {
        return inicializador;
    }

    @Override
    public String getNombreNodo() {
        return "ATRIBUTO";
    }
}
