package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/** Nodo AST para constructores en Zetariano. */
public class ConstructorASTZ extends MiembroASTZ {

    private final String nombre;
    private final List<ParametroASTZ> parametros;
    private final BloqueASTZ cuerpo;
    private final ModificadorAccesoZ modificador;

    public ConstructorASTZ(
            String nombre,
            List<ParametroASTZ> parametros,
            BloqueASTZ cuerpo,
            int linea,
            int columna) {

        this(nombre, parametros, cuerpo, ModificadorAccesoZ.PUBLIC, linea, columna);
    }

    public ConstructorASTZ(
            String nombre,
            List<ParametroASTZ> parametros,
            BloqueASTZ cuerpo,
            ModificadorAccesoZ modificador,
            int linea,
            int columna) {

        super(linea, columna);

        this.nombre = nombre;
        this.parametros = parametros == null ? new ArrayList<>() : new ArrayList<>(parametros);
        this.cuerpo = cuerpo;
        this.modificador = modificador == null ? ModificadorAccesoZ.DEFAULT : modificador;
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

    public ModificadorAccesoZ getModificador() {
        return modificador;
    }

    @Override
    public String getNombreNodo() {
        return "CONSTRUCTOR";
    }
}
