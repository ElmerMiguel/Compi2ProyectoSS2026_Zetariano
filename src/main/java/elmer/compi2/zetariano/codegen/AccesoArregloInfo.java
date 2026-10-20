package elmer.compi2.zetariano.codegen;

import elmer.compi2.zetariano.core.node.NodoAST;
import java.util.List;

/**
 * Informacion de acceso a arreglo en C3D.
 * Extiende de {@link ArrayAccessInfo}.
 */
public class AccesoArregloInfo extends ArrayAccessInfo {

    public AccesoArregloInfo(NodoAST base, List<NodoAST> indices) {
        super(base, indices);
    }
}
