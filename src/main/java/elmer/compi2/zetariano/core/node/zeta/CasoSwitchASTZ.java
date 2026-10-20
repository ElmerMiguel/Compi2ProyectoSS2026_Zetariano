/*
 */
package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class CasoSwitchASTZ extends NodoASTZ {

    private final ExpresionASTZ valor;
    private final List<SentenciaASTZ> sentencias;

    public CasoSwitchASTZ(
            ExpresionASTZ valor,
            List<SentenciaASTZ> sentencias,
            int linea,
            int columna) {

        super(linea, columna);

        this.valor = valor;

        if (sentencias == null) {
            this.sentencias = new ArrayList<>();
        } else {
            this.sentencias = new ArrayList<>(sentencias);
        }
    }

    public ExpresionASTZ getValor() {
        return valor;
    }

    public List<SentenciaASTZ> getSentencias() {
        return sentencias;
    }

    @Override
    public String getNombreNodo() {
        return "CASE";
    }
}
