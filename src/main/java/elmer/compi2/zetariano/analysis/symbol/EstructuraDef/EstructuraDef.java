/*
 */
package elmer.compi2.zetariano.analysis.symbol.EstructuraDef;

import elmer.compi2.zetariano.analysis.symbol.Simbolo.Simbolo;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class EstructuraDef {

    private final String nombre;

    private final Map<String, Simbolo> atributos
            = new LinkedHashMap<>();

    public EstructuraDef(String nombre) {
        this.nombre = nombre;
    }

    public String getNombre() {
        return nombre;
    }

    public Map<String, Simbolo> getAtributos() {
        return atributos;
    }

    public List<Simbolo> getAtributosOrdenados() {

        return new ArrayList<>(
                atributos.values()
        );
    }

    public boolean existeAtributo(
            String nombre) {

        return atributos.containsKey(nombre);
    }

    public void agregarAtributo(
            Simbolo atributo) {

        atributos.put(
                atributo.getNombre(),
                atributo
        );
    }

    public Simbolo buscarAtributo(
            String nombre) {

        return atributos.get(nombre);
    }

    @Override
    public String toString() {

        return "EstructuraDef{"
                + "nombre='" + nombre + '\''
                + ", atributos="
                + atributos
                + '}';
    }
}
