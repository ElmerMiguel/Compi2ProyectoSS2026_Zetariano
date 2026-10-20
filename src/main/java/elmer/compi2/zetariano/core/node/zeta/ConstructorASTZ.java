/*
 */
package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class ConstructorASTZ extends MiembroASTZ {

    private final String nombre;
    private final List<ParametroASTZ> parametros;
    private final BloqueASTZ cuerpo;

    public ConstructorASTZ(
            String nombre,
            List<ParametroASTZ> parametros,
            BloqueASTZ cuerpo,
            int linea,
            int columna) {

        super(linea, columna);

        this.nombre = nombre;

        if (parametros == null) {
            this.parametros = new ArrayList<>();
        } else {
            this.parametros = new ArrayList<>(parametros);
        }

        this.cuerpo = cuerpo;
    }

    public String getNombre() {
        return nombre;
    }

    public List<ParametroASTZ> getParametros() {
        return parametros;
    }

    public BloqueASTZ getCuerpo() {
        return cuerpo;
    }

    @Override
    public String getNombreNodo() {
        return "CONSTRUCTOR";
    }
}
