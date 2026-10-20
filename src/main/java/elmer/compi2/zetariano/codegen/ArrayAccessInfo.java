/*
 */
package elmer.compi2.zetariano.codegen;

import elmer.compi2.zetariano.core.node.NodoAST;
import java.util.List;

/**
 *
 */
public class ArrayAccessInfo {

    private final NodoAST base;
    private final List<NodoAST> indices;

    public ArrayAccessInfo(
            NodoAST base,
            List<NodoAST> indices) {

        this.base = base;
        this.indices = indices;
    }

    public NodoAST getBase() {
        return base;
    }

    public List<NodoAST> getIndices() {
        return indices;
    }
}
