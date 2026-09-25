/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class ProgramaASTZ extends NodoASTZ {

    private final ClaseASTZ clase;

    public ProgramaASTZ(
            ClaseASTZ clase,
            int linea,
            int columna) {

        super(linea, columna);
        this.clase = clase;
    }

    public ClaseASTZ getClase() {
        return clase;
    }

    @Override
    public String getNombreNodo() {
        return "PROGRAMA";
    }
}
