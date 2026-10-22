package elmer.compi2.zetariano.core.node.zeta;

/** Nodo AST para declaracion de atributo de clase en Zetariano. */
public class AtributoASTZ extends MiembroASTZ {

    private final String nombre;
    private final String tipo;
    private final int dimensiones;
    private final ExpresionASTZ inicializador;
    private final ModificadorAccesoZ modificador;

    public AtributoASTZ(
            String nombre,
            String tipo,
            int dimensiones,
            ExpresionASTZ inicializador,
            int linea,
            int columna) {

        this(nombre, tipo, dimensiones, inicializador, ModificadorAccesoZ.DEFAULT, linea, columna);
    }

    public AtributoASTZ(
            String nombre,
            String tipo,
            int dimensiones,
            ExpresionASTZ inicializador,
            ModificadorAccesoZ modificador,
            int linea,
            int columna) {

        super(linea, columna);

        this.nombre = nombre;
        this.tipo = tipo;
        this.dimensiones = dimensiones;
        this.inicializador = inicializador;
        this.modificador = modificador == null ? ModificadorAccesoZ.DEFAULT : modificador;
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

    public ModificadorAccesoZ getModificador() {
        return modificador;
    }

    @Override
    public String getNombreNodo() {
        return "ATRIBUTO";
    }
}
