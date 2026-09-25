/*
 */
package elmer.compi2.zetariano.analysis.semantic.zeta;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 */
public class ClaseZ {

    private final String nombre;

    private final Map<String, AtributoZ> atributos;
    private final Map<String, MetodoZ> metodos;
    private final Map<String, ConstructorZ> constructores;

    public ClaseZ(String nombre) {
        this.nombre = nombre;

        this.atributos = new LinkedHashMap<>();
        this.metodos = new LinkedHashMap<>();
        this.constructores = new LinkedHashMap<>();
    }

    public String getNombre() {
        return nombre;
    }

    // =========================================================
    // ATRIBUTOS
    // =========================================================
    public boolean registrarAtributo(AtributoZ atributo) {

        if (atributo == null) {
            return false;
        }

        if (atributos.containsKey(atributo.getNombre())) {
            return false;
        }

        atributos.put(atributo.getNombre(), atributo);
        return true;
    }

    public AtributoZ buscarAtributo(String nombre) {
        return atributos.get(nombre);
    }

    public Collection<AtributoZ> getAtributos() {
        return atributos.values();
    }

    // =========================================================
    // METODOS
    // =========================================================
    public boolean registrarMetodo(MetodoZ metodo) {

        if (metodo == null) {
            return false;
        }

        String firma = metodo.obtenerFirma();

        if (metodos.containsKey(firma)) {
            return false;
        }

        metodos.put(firma, metodo);
        return true;
    }

    public MetodoZ buscarMetodoPorFirma(String firma) {
        return metodos.get(firma);
    }

    public Collection<MetodoZ> getMetodos() {
        return metodos.values();
    }

    // =========================================================
    // CONSTRUCTORES
    // =========================================================
    public boolean registrarConstructor(ConstructorZ constructor) {

        if (constructor == null) {
            return false;
        }

        String firma = constructor.obtenerFirma();

        if (constructores.containsKey(firma)) {
            return false;
        }

        constructores.put(firma, constructor);
        return true;
    }

    public ConstructorZ buscarConstructorPorFirma(String firma) {
        return constructores.get(firma);
    }

    public Collection<ConstructorZ> getConstructores() {
        return constructores.values();
    }
}
