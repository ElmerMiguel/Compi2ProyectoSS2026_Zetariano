package elmer.compi2.zetariano.analysis.semantic.zeta;

import elmer.compi2.zetariano.core.node.zeta.ModificadorAccesoZ;
import java.util.Collection;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

/** Representacion semantica de una clase en Zetariano con herencia. */
public class ClaseZ {

    private final String nombre;
    private final String nombrePadre;
    private ClaseZ clasePadre;
    private final int linea;
    private final int columna;

    private final Map<String, AtributoZ> atributos;
    private final Map<String, MetodoZ> metodos;
    private final Map<String, ConstructorZ> constructores;

    public ClaseZ(String nombre) {
        this(nombre, null, 0, 0);
    }

    public ClaseZ(
            String nombre,
            String nombrePadre,
            int linea,
            int columna) {
        this.nombre = nombre;
        this.nombrePadre = nombrePadre;
        this.linea = linea;
        this.columna = columna;

        this.atributos = new LinkedHashMap<>();
        this.metodos = new LinkedHashMap<>();
        this.constructores = new LinkedHashMap<>();
    }

    public String getNombre() {
        return nombre;
    }

    public String getNombrePadre() {
        return nombrePadre;
    }

    public boolean tienePadre() {
        return nombrePadre != null && !nombrePadre.isBlank();
    }

    public boolean esSubclaseDe(String posiblePadre) {
        if (posiblePadre == null || posiblePadre.isBlank()) {
            return false;
        }
        if (this.nombre.equals(posiblePadre)) {
            return true;
        }
        return clasePadre != null && clasePadre.esSubclaseDe(posiblePadre);
    }

    public ClaseZ getClasePadre() {
        return clasePadre;
    }

    public void setClasePadre(ClaseZ clasePadre) {
        this.clasePadre = clasePadre;
    }

    public int getLinea() {
        return linea;
    }

    public int getColumna() {
        return columna;
    }

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
        return buscarAtributo(nombre, new HashSet<>(), true);
    }

    public AtributoZ buscarAtributoLocal(String nombre) {
        return atributos.get(nombre);
    }

    public AtributoZ buscarAtributoDeclaradoEnJerarquia(String nombre) {
        ClaseZ cursor = this;
        Set<String> visitadas = new HashSet<>();
        while (cursor != null && visitadas.add(cursor.nombre)) {
            AtributoZ atributo = cursor.atributos.get(nombre);
            if (atributo != null) {
                return atributo;
            }
            cursor = cursor.clasePadre;
        }
        return null;
    }

    private AtributoZ buscarAtributo(
            String nombre,
            Set<String> visitadas,
            boolean claseInicial) {

        if (!visitadas.add(this.nombre)) {
            return null;
        }

        AtributoZ local = atributos.get(nombre);
        if (local != null && (claseInicial || local.getModificador() != ModificadorAccesoZ.PRIVATE)) {
            return local;
        }

        return clasePadre == null ? null : clasePadre.buscarAtributo(nombre, visitadas, false);
    }

    public Collection<AtributoZ> getAtributos() {
        return atributos.values();
    }

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
        return buscarMetodoPorFirma(firma, new HashSet<>(), true);
    }

    public MetodoZ buscarMetodoLocalPorFirma(String firma) {
        return metodos.get(firma);
    }

    public MetodoZ buscarMetodoHeredablePorFirma(String firma) {
        return clasePadre == null ? null : clasePadre.buscarMetodoPorFirma(firma, new HashSet<>(), false);
    }

    private MetodoZ buscarMetodoPorFirma(
            String firma,
            Set<String> visitadas,
            boolean claseInicial) {

        if (!visitadas.add(this.nombre)) {
            return null;
        }

        MetodoZ local = metodos.get(firma);
        if (local != null && (claseInicial || local.getModificador() != ModificadorAccesoZ.PRIVATE)) {
            return local;
        }

        return clasePadre == null ? null : clasePadre.buscarMetodoPorFirma(firma, visitadas, false);
    }

    public Collection<MetodoZ> getMetodos() {
        return metodos.values();
    }

    public Collection<MetodoZ> getMetodosJerarquia() {
        Map<String, MetodoZ> resultado = new LinkedHashMap<>();
        recolectarMetodos(resultado, new HashSet<>(), true);
        return resultado.values();
    }

    private void recolectarMetodos(
            Map<String, MetodoZ> resultado,
            Set<String> visitadas,
            boolean claseInicial) {

        if (!visitadas.add(nombre)) {
            return;
        }

        for (MetodoZ metodo : metodos.values()) {
            if (claseInicial || metodo.getModificador() != ModificadorAccesoZ.PRIVATE) {
                resultado.putIfAbsent(metodo.obtenerFirma(), metodo);
            }
        }

        if (clasePadre != null) {
            clasePadre.recolectarMetodos(resultado, visitadas, false);
        }
    }

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
