/*
 */
package elmer.compi2.zetariano.analysis.semantic.zeta;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */
public class ConstructorZ {

    private final String nombre;
    private final List<ParametroZ> parametros;

    public ConstructorZ(
            String nombre,
            List<ParametroZ> parametros) {

        this.nombre = nombre;

        this.parametros = parametros == null
                ? new ArrayList<>()
                : new ArrayList<>(parametros);
    }

    public String getNombre() {
        return nombre;
    }

    public List<ParametroZ> getParametros() {
        return Collections.unmodifiableList(parametros);
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
                + "firma='" + obtenerFirma() + '\''
                + '}';
    }
}
