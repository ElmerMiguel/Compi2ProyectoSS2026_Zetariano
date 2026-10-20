/*
 */
package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class MetodoASTZ extends MiembroASTZ {

    private final String nombre;
    private final String tipoRetorno;
    private final List<ParametroASTZ> parametros;
    private final BloqueASTZ cuerpo;

    public MetodoASTZ(
            String nombre,
            String tipoRetorno,
            List<ParametroASTZ> parametros,
            BloqueASTZ cuerpo,
            int linea,
            int columna) {

        super(linea, columna);

        this.nombre = nombre;
        this.tipoRetorno = tipoRetorno;

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

    public String getTipoRetorno() {
        return tipoRetorno;
    }

    public List<ParametroASTZ> getParametros() {
        return parametros;
    }

    public BloqueASTZ getCuerpo() {
        return cuerpo;
    }

    @Override
    public String getNombreNodo() {
        return "METODO";
    }
}
