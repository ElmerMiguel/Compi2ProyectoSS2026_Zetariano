package elmer.compi2.zetariano.codegen.piglatin;

import elmer.compi2.zetariano.codegen.GeneradorC3DPig;
import elmer.compi2.zetariano.core.node.piglatin.ProgramaASTPig;
import elmer.compi2.zetariano.imports.RegistroImportsPig;
import elmer.compi2.zetariano.runtime.piglatin.MarcoPrincipalPig;

/**
 * Emisor de Codigo de Tres Direcciones (C3D) para el lenguaje Pig Latin.
 * Extiende de {@link GeneradorC3DPig}.
 */
public class PigC3DEmitter extends GeneradorC3DPig {

    public PigC3DEmitter(
            ProgramaASTPig ast,
            MarcoPrincipalPig marcoPrincipal,
            RegistroImportsPig registroImports) {
        super(ast, marcoPrincipal, registroImports);
    }
}
