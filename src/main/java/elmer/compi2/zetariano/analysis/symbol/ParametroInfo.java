/*
 */
package elmer.compi2.zetariano.analysis.symbol;

/**
 *
 */
public class ParametroInfo {

    private final String nombre;
    private final TipoDato tipo;
    private final TipoDato tipoElemento;
    private final String tipoReferencia;
    private final boolean porReferencia;

    public ParametroInfo(String nombre, TipoDato tipo, TipoDato tipoElemento, String tipoReferencia, boolean porReferencia) {
        this.nombre = nombre;
        this.tipo = tipo;
        this.tipoElemento = tipoElemento;
        this.tipoReferencia = tipoReferencia;
        this.porReferencia = porReferencia;
    }

    public String getNombre() {
        return nombre;
    }

    public TipoDato getTipo() {
        return tipo;
    }

    public TipoDato getTipoElemento() {
        return tipoElemento;
    }

    public String getTipoReferencia() {
        return tipoReferencia;
    }

    public boolean isPorReferencia() {
        return porReferencia;
    }

    @Override
    public String toString() {

        return "ParametroInfo{"
                + "nombre='" + nombre + '\''
                + ", tipo=" + tipo
                + ", tipoElemento=" + tipoElemento
                + ", tipoReferencia='" + tipoReferencia + '\''
                + ", porReferencia=" + porReferencia
                + '}';
    }

}
