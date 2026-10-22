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
    private String nombrePadre;

    private final Map<String, AtributoImportadoPig> atributos;
    private final Map<String, MetodoImportadoPig> metodos;

    public ClaseImportadaPig(
            String nombre,
            TipoImportPig origen) {

        this.nombre = nombre;
        this.origen = origen;
        this.nombrePadre = null;

        this.atributos = new LinkedHashMap<>();
        this.metodos = new LinkedHashMap<>();
    }

    public String getNombrePadre() {
        return nombrePadre;
    }

    public void setNombrePadre(String nombrePadre) {
        this.nombrePadre = nombrePadre;
    }

    public boolean tienePadre() {
        return nombrePadre != null && !nombrePadre.isBlank();
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

    public AtributoImportadoPig buscarAtributo(
            String nombre,
            RegistroImportsPig registro) {

        AtributoImportadoPig local = atributos.get(nombre);
        if (local != null) {
            return local;
        }
        if (tienePadre() && registro != null) {
            ClaseImportadaPig padre = registro.buscarClase(nombrePadre);
            if (padre != null) {
                return padre.buscarAtributo(nombre, registro);
            }
        }
        return null;
    }

    public MetodoImportadoPig buscarMetodoPorFirma(
            String firma) {

        return metodos.get(firma);
    }

    public MetodoImportadoPig buscarMetodoPorFirma(
            String firma,
            RegistroImportsPig registro) {

        MetodoImportadoPig local = metodos.get(firma);
        if (local != null) {
            return local;
        }
        if (tienePadre() && registro != null) {
            ClaseImportadaPig padre = registro.buscarClase(nombrePadre);
            if (padre != null) {
                return padre.buscarMetodoPorFirma(firma, registro);
            }
        }
        return null;
    }

    public boolean esSubclaseDe(
            String posiblePadre,
            RegistroImportsPig registro) {

        if (posiblePadre == null) {
            return false;
        }
        if (this.nombre.equals(posiblePadre)) {
            return true;
        }
        if (tienePadre() && registro != null) {
            ClaseImportadaPig padre = registro.buscarClase(nombrePadre);
            if (padre != null) {
                return padre.esSubclaseDe(posiblePadre, registro);
            }
        }
        return false;
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
