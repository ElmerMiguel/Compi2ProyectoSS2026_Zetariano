/*
 */
package elmer.compi2.zetariano.runtime.zeta;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 */
public class ClaseMemoriaZ {

    private final String nombre;

    private final Map<String, AtributoMemoriaZ> atributos;

    private int siguienteOffset;

    public ClaseMemoriaZ(
            String nombre) {

        this.nombre = nombre;
        this.atributos
                = new LinkedHashMap<>();

        this.siguienteOffset = 0;
    }

    public AtributoMemoriaZ registrarAtributo(
            String nombre,
            String tipo,
            int dimensiones) {

        AtributoMemoriaZ atributo
                = new AtributoMemoriaZ(
                        nombre,
                        tipo,
                        dimensiones,
                        siguienteOffset++
                );

        atributos.put(
                nombre,
                atributo
        );

        return atributo;
    }

    public AtributoMemoriaZ buscarAtributo(
            String nombre) {

        return atributos.get(nombre);
    }

    public String getNombre() {
        return nombre;
    }

    public int getTamanoObjeto() {
        return siguienteOffset;
    }

    public Map<String, AtributoMemoriaZ> getAtributos() {

        return Collections.unmodifiableMap(
                atributos
        );
    }

    @Override
    public String toString() {

        StringBuilder sb
                = new StringBuilder();

        sb.append("ClaseMemoriaZ{nombre='")
                .append(nombre)
                .append("', tamanoObjeto=")
                .append(getTamanoObjeto())
                .append("}");

        for (AtributoMemoriaZ atributo
                : atributos.values()) {

            sb.append("\n    ")
                    .append(atributo);
        }

        return sb.toString();
    }
}
