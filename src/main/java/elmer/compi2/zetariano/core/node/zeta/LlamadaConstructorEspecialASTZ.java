package elmer.compi2.zetariano.core.node.zeta;

import java.util.ArrayList;
import java.util.List;

/** Representa invocacion a this(...) o super(...) en constructor Z. */
public class LlamadaConstructorEspecialASTZ extends SentenciaASTZ {

    public enum Tipo {
        THIS,
        SUPER
    }

    private final Tipo tipo;
    private final List<ExpresionASTZ> argumentos;

    public LlamadaConstructorEspecialASTZ(
            Tipo tipo,
            List<ExpresionASTZ> argumentos,
            int linea,
            int columna) {

        super(linea, columna);
        this.tipo = tipo;
        this.argumentos = argumentos == null
                ? new ArrayList<>()
                : new ArrayList<>(argumentos);
    }

    public Tipo getTipo() {
        return tipo;
    }

    public List<ExpresionASTZ> getArgumentos() {
        return argumentos;
    }

    @Override
    public String getNombreNodo() {
        return "LLAMADA_CONSTRUCTOR_" + tipo;
    }
}
