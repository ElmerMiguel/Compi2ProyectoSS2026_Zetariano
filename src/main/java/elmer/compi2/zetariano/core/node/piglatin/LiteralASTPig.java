/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class LiteralASTPig extends ExpresionASTPig{

    private final Object valor;
    private final String tipo;

    public LiteralASTPig(
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
    public String generarTexto() {

        return "LITERAL("
                + tipo
                + "): "
                + String.valueOf(valor);
    }

    @Override
    public String toString() {
        return generarTexto();
    }
}
