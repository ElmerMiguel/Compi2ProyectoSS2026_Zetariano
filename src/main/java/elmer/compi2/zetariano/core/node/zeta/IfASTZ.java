/*
 */
package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class IfASTZ extends SentenciaASTZ {

    public static class RamaIf {

        private final ExpresionASTZ condicion;
        private final SentenciaASTZ cuerpo;

        public RamaIf(
                ExpresionASTZ condicion,
                SentenciaASTZ cuerpo) {

            this.condicion = condicion;
            this.cuerpo = cuerpo;
        }

        public ExpresionASTZ getCondicion() {
            return condicion;
        }

        public SentenciaASTZ getCuerpo() {
            return cuerpo;
        }
    }

    private final List<RamaIf> ramas;
    private final SentenciaASTZ cuerpoElse;

    public IfASTZ(
            List<RamaIf> ramas,
            SentenciaASTZ cuerpoElse,
            int linea,
            int columna) {

        super(linea, columna);

        if (ramas == null) {
            this.ramas = new ArrayList<>();
        } else {
            this.ramas = new ArrayList<>(ramas);
        }

        this.cuerpoElse = cuerpoElse;
    }

    public List<RamaIf> getRamas() {
        return ramas;
    }

    public SentenciaASTZ getCuerpoElse() {
        return cuerpoElse;
    }

    @Override
    public String getNombreNodo() {
        return "IF";
    }
}
