/*
 */
package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class PasoAccesoASTZ {

    public enum TipoPaso {
        ATRIBUTO,
        INDICE,
        LLAMADA
    }

    private final TipoPaso tipo;
    private final String nombre;
    private final ExpresionASTZ indice;
    private final List<ExpresionASTZ> argumentos;

    private PasoAccesoASTZ(
            TipoPaso tipo,
            String nombre,
            ExpresionASTZ indice,
            List<ExpresionASTZ> argumentos) {

        this.tipo = tipo;
        this.nombre = nombre;
        this.indice = indice;

        if (argumentos == null) {
            this.argumentos = new ArrayList<>();
        } else {
            this.argumentos = new ArrayList<>(argumentos);
        }
    }

    public static PasoAccesoASTZ atributo(
            String nombre) {

        return new PasoAccesoASTZ(
                TipoPaso.ATRIBUTO,
                nombre,
                null,
                null
        );
    }

    public static PasoAccesoASTZ indice(
            ExpresionASTZ indice) {

        return new PasoAccesoASTZ(
                TipoPaso.INDICE,
                null,
                indice,
                null
        );
    }

    public static PasoAccesoASTZ llamada(
            String nombre,
            List<ExpresionASTZ> argumentos) {

        return new PasoAccesoASTZ(
                TipoPaso.LLAMADA,
                nombre,
                null,
                argumentos
        );
    }

    public TipoPaso getTipo() {
        return tipo;
    }

    public String getNombre() {
        return nombre;
    }

    public ExpresionASTZ getIndice() {
        return indice;
    }

    public List<ExpresionASTZ> getArgumentos() {
        return argumentos;
    }
}
