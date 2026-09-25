/*
 */
package elmer.compi2.zetariano.core.node;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */
public class NodoAST {

    private final TipoNodoAST tipo;

    private String valor;

    private final List<NodoAST> hijos;

    private int linea;
    private int columna;

    public NodoAST(
            TipoNodoAST tipo) {

        this(
                tipo,
                null,
                -1,
                -1
        );
    }

    public NodoAST(
            TipoNodoAST tipo,
            String valor) {

        this(
                tipo,
                valor,
                -1,
                -1
        );
    }

    public NodoAST(
            TipoNodoAST tipo,
            String valor,
            int linea,
            int columna) {

        this.tipo = tipo;
        this.valor = valor;
        this.linea = linea;
        this.columna = columna;

        this.hijos = new ArrayList<>();
    }

    // ============================================================
    // HIJOS
    // ============================================================
    public void agregarHijo(
            NodoAST hijo) {

        if (hijo != null) {
            hijos.add(hijo);
        }
    }

    public void agregarHijos(
            List<NodoAST> nuevosHijos) {

        if (nuevosHijos == null) {
            return;
        }

        for (NodoAST hijo : nuevosHijos) {

            agregarHijo(hijo);
        }
    }

    public List<NodoAST> getHijos() {

        return Collections.unmodifiableList(
                hijos
        );
    }

    public NodoAST getHijo(
            int indice) {

        return hijos.get(indice);
    }

    public int cantidadHijos() {

        return hijos.size();
    }

    // ============================================================
    // GETTERS / SETTERS
    // ============================================================
    public TipoNodoAST getTipo() {

        return tipo;
    }

    public String getValor() {

        return valor;
    }

    public void setValor(
            String valor) {

        this.valor = valor;
    }

    public int getLinea() {

        return linea;
    }

    public void setLinea(
            int linea) {

        this.linea = linea;
    }

    public int getColumna() {

        return columna;
    }

    public void setColumna(
            int columna) {

        this.columna = columna;
    }

    // ============================================================
    // REPRESENTACION
    // ============================================================
    @Override
    public String toString() {

        if (valor == null
                || valor.isBlank()) {

            return tipo.name();
        }

        return tipo.name()
                + "("
                + valor
                + ")";
    }

}
