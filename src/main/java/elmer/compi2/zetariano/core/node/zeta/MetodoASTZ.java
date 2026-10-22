package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/** Nodo AST para metodos de clase en Zetariano. */
public class MetodoASTZ extends MiembroASTZ {

    private final String nombre;
    private final String tipoRetorno;
    private final List<ParametroASTZ> parametros;
    private final BloqueASTZ cuerpo;
    private final ModificadorAccesoZ modificador;
    private final boolean esOverride;

    public MetodoASTZ(
            String nombre,
            String tipoRetorno,
            List<ParametroASTZ> parametros,
            BloqueASTZ cuerpo,
            int linea,
            int columna) {

        this(nombre, tipoRetorno, parametros, cuerpo, ModificadorAccesoZ.PUBLIC, false, linea, columna);
    }

    public MetodoASTZ(
            String nombre,
            String tipoRetorno,
            List<ParametroASTZ> parametros,
            BloqueASTZ cuerpo,
            ModificadorAccesoZ modificador,
            boolean esOverride,
            int linea,
            int columna) {

        super(linea, columna);

        this.nombre = nombre;
        this.tipoRetorno = tipoRetorno;
        this.parametros = parametros == null ? new ArrayList<>() : new ArrayList<>(parametros);
        this.cuerpo = cuerpo;
        this.modificador = modificador == null ? ModificadorAccesoZ.DEFAULT : modificador;
        this.esOverride = esOverride;
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

    public ModificadorAccesoZ getModificador() {
        return modificador;
    }

    public boolean isOverride() {
        return esOverride;
    }

    @Override
    public String getNombreNodo() {
        return "METODO";
    }
}
