/*
 */
package elmer.compi2.zetariano.imports;

import java.util.Collection;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 */
public class ClaseImportadaPig {

    private final String nombre;
    private final TipoImportPig origen;

    private final Map<String, AtributoImportadoPig> atributos;
    private final Map<String, MetodoImportadoPig> metodos;

    public ClaseImportadaPig(
            String nombre,
            TipoImportPig origen) {

        this.nombre = nombre;
        this.origen = origen;

        this.atributos = new LinkedHashMap<>();
        this.metodos = new LinkedHashMap<>();
    }

    public void registrarAtributo(
            AtributoImportadoPig atributo) {

        if (atributo == null) {
            return;
        }

        atributos.put(
                atributo.getNombre(),
                atributo
        );
    }

    public void registrarMetodo(
            MetodoImportadoPig metodo) {

        if (metodo == null) {
            return;
        }

        metodos.put(
                metodo.getFirma(),
                metodo
        );
    }

    public AtributoImportadoPig buscarAtributo(
            String nombre) {

        return atributos.get(nombre);
    }

    public MetodoImportadoPig buscarMetodoPorFirma(
            String firma) {

        return metodos.get(firma);
    }

    public String getNombre() {
        return nombre;
    }

    public TipoImportPig getOrigen() {
        return origen;
    }

    public Collection<AtributoImportadoPig> getAtributos() {

        return Collections.unmodifiableCollection(
                atributos.values()
        );
    }

    public Collection<MetodoImportadoPig> getMetodos() {

        return Collections.unmodifiableCollection(
                metodos.values()
        );
    }

    @Override
    public String toString() {

        return "ClaseImportadaPig{"
                + "nombre='" + nombre + '\''
                + ", origen=" + origen
                + ", atributos=" + atributos.size()
                + ", metodos=" + metodos.size()
                + '}';
    }
}
