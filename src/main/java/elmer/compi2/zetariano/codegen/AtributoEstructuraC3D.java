package elmer.compi2.zetariano.codegen;

import java.util.List;

/**
 * Metadata de atributo de estructura para calculo de offsets en C3D.
 * Extiende de {@link StructFieldC3D}.
 */
public class AtributoEstructuraC3D extends StructFieldC3D {

    public AtributoEstructuraC3D(String nombre, String tipo, int offset) {
        super(nombre, tipo, offset);
    }

    public AtributoEstructuraC3D(String nombre, String tipo, int offset, List<Integer> dimensiones) {
        super(nombre, tipo, offset, dimensiones);
    }
}
