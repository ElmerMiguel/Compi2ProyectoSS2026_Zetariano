/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class IdentificadorASTZ extends ExpresionASTZ {

    private final String nombre;

    public IdentificadorASTZ(
            String nombre,
            int linea,
            int columna) {

        super(linea, columna);
        this.nombre = nombre;
    }

    public String getNombre() {
        return nombre;
    }

    @Override
    public String getNombreNodo() {
        return "IDENTIFICADOR";
    }
}
