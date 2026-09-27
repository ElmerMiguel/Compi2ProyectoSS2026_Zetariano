package elmer.compi2.zetariano.analysis.symbol;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Definicion de una estructura con sus atributos asociados.
 */
public class StructDef {

    private final String name;
    private final Map<String, Symbol> fields = new LinkedHashMap<>();

    public StructDef(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public Map<String, Symbol> getFields() {
        return fields;
    }

    public List<Symbol> getOrderedFields() {
        return new ArrayList<>(fields.values());
    }

    public boolean hasField(String fieldName) {
        return fields.containsKey(fieldName);
    }

    public void addField(Symbol field) {
        fields.put(field.getName(), field);
    }

    public Symbol findField(String fieldName) {
        return fields.get(fieldName);
    }

    public String getNombre() { return name; }
    public Map<String, Symbol> getAtributos() { return fields; }
    public List<Symbol> getAtributosOrdenados() { return getOrderedFields(); }
    public boolean existeAtributo(String nombre) { return hasField(nombre); }
    public void agregarAtributo(Symbol atributo) { addField(atributo); }
    public Symbol buscarAtributo(String nombre) { return findField(nombre); }

    @Override
    public String toString() {
        return "StructDef{" +
                "name='" + name + '\'' +
                ", fields=" + fields +
                '}';
    }
}
