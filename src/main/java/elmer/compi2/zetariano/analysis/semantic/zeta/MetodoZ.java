package elmer.compi2.zetariano.analysis.semantic.zeta;

import elmer.compi2.zetariano.core.node.zeta.ModificadorAccesoZ;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/** Representacion semantica de un metodo en Zetariano. */
public class MetodoZ {

    private final String nombre;
    private final String tipoRetorno;
    private final List<ParametroZ> parametros;
    private final ModificadorAccesoZ modificador;
    private final boolean overrideDeclarado;
    private final String claseDeclarante;

    public MetodoZ(
            String nombre,
            String tipoRetorno,
            List<ParametroZ> parametros) {

        this(nombre, tipoRetorno, parametros, ModificadorAccesoZ.PUBLIC, false, null);
    }

    public MetodoZ(
            String nombre,
            String tipoRetorno,
            List<ParametroZ> parametros,
            ModificadorAccesoZ modificador,
            boolean overrideDeclarado,
            String claseDeclarante) {

        this.nombre = nombre;
        this.tipoRetorno = tipoRetorno;
        this.parametros = parametros == null
                ? new ArrayList<>()
                : new ArrayList<>(parametros);
        this.modificador = modificador == null ? ModificadorAccesoZ.DEFAULT : modificador;
        this.overrideDeclarado = overrideDeclarado;
        this.claseDeclarante = claseDeclarante;
    }

    public String getNombre() {
        return nombre;
    }

    public String getTipoRetorno() {
        return tipoRetorno;
    }

    public List<ParametroZ> getParametros() {
        return Collections.unmodifiableList(parametros);
    }

    public ModificadorAccesoZ getModificador() {
        return modificador;
    }

    public boolean isOverrideDeclarado() {
        return overrideDeclarado;
    }

    public String getClaseDeclarante() {
        return claseDeclarante;
    }

    public String obtenerFirma() {
        StringBuilder sb = new StringBuilder();
        sb.append(nombre).append("(");
        for (int i = 0; i < parametros.size(); i++) {
            if (i > 0) {
                sb.append(",");
            }
            ParametroZ parametro = parametros.get(i);
            sb.append(parametro.getTipo());
            for (int j = 0; j < parametro.getDimensiones(); j++) {
                sb.append("[]");
            }
        }
        sb.append(")");
        return sb.toString();
    }

    @Override
    public String toString() {
        return "MetodoZ{"
                + "nombre='" + nombre + '\''
                + ", tipoRetorno='" + tipoRetorno + '\''
                + ", parametros=" + parametros
                + ", modificador=" + modificador
                + ", override=" + overrideDeclarado
                + ", claseDeclarante='" + claseDeclarante + '\''
                + '}';
    }
}
