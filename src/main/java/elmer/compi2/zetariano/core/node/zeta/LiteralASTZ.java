/*
 */
package elmer.compi2.zetariano.core.node.zeta;

/**
 *
 */
public class LiteralASTZ extends ExpresionASTZ {

    private final Object valor;
    private final String tipo;

    public LiteralASTZ(
            Object valor,
            String tipo,
            int linea,
            int columna) {

        super(linea, columna);

        this.valor = valor;
        this.tipo = tipo;
    }

    public Object getValor() {
        return valor;
    }

    public String getTipo() {
        return tipo;
    }

    @Override
    public String getNombreNodo() {
        return "LITERAL";
    }
}
