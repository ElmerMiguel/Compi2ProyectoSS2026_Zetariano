/*
 */
package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class SwitchASTZ extends SentenciaASTZ {

    private final ExpresionASTZ expresion;
    private final List<CasoSwitchASTZ> casos;
    private final List<SentenciaASTZ> defecto;

    public SwitchASTZ(
            ExpresionASTZ expresion,
            List<CasoSwitchASTZ> casos,
            List<SentenciaASTZ> defecto,
            int linea,
            int columna) {

        super(linea, columna);

        this.expresion = expresion;

        if (casos == null) {
            this.casos = new ArrayList<>();
        } else {
            this.casos = new ArrayList<>(casos);
        }

        if (defecto == null) {
            this.defecto = new ArrayList<>();
        } else {
            this.defecto = new ArrayList<>(defecto);
        }
    }

    public ExpresionASTZ getExpresion() {
        return expresion;
    }

    public List<CasoSwitchASTZ> getCasos() {
        return casos;
    }

    public List<SentenciaASTZ> getDefecto() {
        return defecto;
    }

    @Override
    public String getNombreNodo() {
        return "SWITCH";
    }
}
