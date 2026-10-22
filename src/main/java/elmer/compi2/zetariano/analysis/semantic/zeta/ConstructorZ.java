package elmer.compi2.zetariano.analysis.semantic.zeta;

import elmer.compi2.zetariano.core.node.zeta.ModificadorAccesoZ;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/** Representacion semantica de un constructor en Zetariano. */
public class ConstructorZ {

    private final String nombre;
    private final List<ParametroZ> parametros;
    private final ModificadorAccesoZ modificador;
    private final String claseDeclarante;

    public ConstructorZ(
            String nombre,
            List<ParametroZ> parametros) {

        this(nombre, parametros, ModificadorAccesoZ.PUBLIC, null);
    }

    public ConstructorZ(
            String nombre,
            List<ParametroZ> parametros,
            ModificadorAccesoZ modificador,
            String claseDeclarante) {

        this.nombre = nombre;
        this.parametros = parametros == null
                ? new ArrayList<>()
                : new ArrayList<>(parametros);
        this.modificador = modificador == null ? ModificadorAccesoZ.DEFAULT : modificador;
        this.claseDeclarante = claseDeclarante;
    }

    public String getNombre() {
        return nombre;
    }

    public List<ParametroZ> getParametros() {
        return Collections.unmodifiableList(parametros);
    }

    public ModificadorAccesoZ getModificador() {
        return modificador;
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
        return "ConstructorZ{"
                + "nombre='" + nombre + '\''
                + ", parametros=" + parametros
                + ", modificador=" + modificador
                + ", claseDeclarante='" + claseDeclarante + '\''
                + '}';
    }
}
