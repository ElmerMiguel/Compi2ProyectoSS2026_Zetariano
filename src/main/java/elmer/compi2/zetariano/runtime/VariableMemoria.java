/*
 */
package elmer.compi2.zetariano.runtime;

/**
 *
 */
public class VariableMemoria {

    private final String nombre;
    private final String tipo;
    private final int offset;
    private final boolean referenciaHeap;

    public VariableMemoria(
            String nombre,
            String tipo,
            int offset,
            boolean referenciaHeap) {

        this.nombre = nombre;
        this.tipo = tipo;
        this.offset = offset;
        this.referenciaHeap = referenciaHeap;
    }

    public String getNombre() {
        return nombre;
    }

    public String getTipo() {
        return tipo;
    }

    public int getOffset() {
        return offset;
    }

    public boolean isReferenciaHeap() {
        return referenciaHeap;
    }

    @Override
    public String toString() {
        return nombre
                + " : "
                + tipo
                + " | offset="
                + offset
                + " | heap="
                + referenciaHeap;
    }
}
