package elmer.compi2.zetariano.analysis.semantic.zeta;

import elmer.compi2.zetariano.core.node.zeta.ModificadorAccesoZ;

/** Representacion semantica de un atributo de clase en Zetariano. */
public class AtributoZ {

    private final String nombre;
    private final String tipo;
    private final int dimensiones;
    private final ModificadorAccesoZ modificador;
    private final String claseDeclarante;

    public AtributoZ(String nombre, String tipo, int dimensiones) {
        this(nombre, tipo, dimensiones, ModificadorAccesoZ.DEFAULT, null);
    }

    public AtributoZ(
            String nombre,
            String tipo,
            int dimensiones,
            ModificadorAccesoZ modificador,
            String claseDeclarante) {
        this.nombre = nombre;
        this.tipo = tipo;
        this.dimensiones = dimensiones;
        this.modificador = modificador == null ? ModificadorAccesoZ.DEFAULT : modificador;
        this.claseDeclarante = claseDeclarante;
    }

    public String getNombre() {
        return nombre;
    }

    public String getTipo() {
        return tipo;
    }

    public int getDimensiones() {
        return dimensiones;
    }

    public boolean esArreglo() {
        return dimensiones > 0;
    }

    public ModificadorAccesoZ getModificador() {
        return modificador;
    }

    public String getClaseDeclarante() {
        return claseDeclarante;
    }

    @Override
    public String toString() {
        return "AtributoZ{"
                + "nombre='" + nombre + '\''
                + ", tipo='" + tipo + '\''
                + ", dimensiones=" + dimensiones
                + ", modificador=" + modificador
                + ", claseDeclarante='" + claseDeclarante + '\''
                + '}';
    }
}
