/*
 */
package elmer.compi2.zetariano.analysis.symbol.Simbolo;

import elmer.compi2.zetariano.analysis.symbol.CategoriaSimbolo;
import elmer.compi2.zetariano.analysis.symbol.ParametroInfo;
import elmer.compi2.zetariano.analysis.symbol.TipoDato;
import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class Simbolo {

    private String nombre;
    private TipoDato tipo;
    private CategoriaSimbolo categoria;
    private int nivelAmbito;
    private int idAmbito;
    private String tipoReferencia;
    private TipoDato tipoElemento;

    private final List<Integer> dimensiones
            = new ArrayList<>();

    private final List<TipoDato> parametros
            = new ArrayList<>();

    private final List<ParametroInfo> parametrosInfo
            = new ArrayList<>();

    public Simbolo(
            String nombre,
            TipoDato tipo,
            CategoriaSimbolo categoria,
            int nivelAmbito,
            int idAmbito) {

        this.nombre = nombre;
        this.tipo = tipo;
        this.categoria = categoria;
        this.nivelAmbito = nivelAmbito;
        this.idAmbito = idAmbito;
    }

    public String getNombre() {
        return nombre;
    }

    public TipoDato getTipo() {
        return tipo;
    }

    public CategoriaSimbolo getCategoria() {
        return categoria;
    }

    public int getNivelAmbito() {
        return nivelAmbito;
    }

    public List<TipoDato> getParametros() {
        return parametros;
    }

    public int getIdAmbito() {
        return idAmbito;
    }

    public String getTipoReferencia() {
        return tipoReferencia;
    }

    public void setTipoReferencia(
            String tipoReferencia) {

        this.tipoReferencia = tipoReferencia;
    }

    public TipoDato getTipoElemento() {
        return tipoElemento;
    }

    public void setTipoElemento(
            TipoDato tipoElemento) {

        this.tipoElemento = tipoElemento;
    }

    public List<Integer> getDimensiones() {
        return dimensiones;
    }

    public List<ParametroInfo> getParametrosInfo() {
        return parametrosInfo;
    }

    @Override
    public String toString() {

        return "Simbolo{"
                + "nombre='" + nombre + '\''
                + ", tipo=" + tipo
                + ", categoria=" + categoria
                + ", nivelAmbito=" + nivelAmbito
                + ", idAmbito=" + idAmbito
                + ", tipoReferencia='" + tipoReferencia + '\''
                + ", tipoElemento=" + tipoElemento
                + ", dimensiones=" + dimensiones
                + ", parametros=" + parametros
                + '}';
    }
}
