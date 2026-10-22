package elmer.compi2.zetariano.analysis.semantic;

import elmer.compi2.zetariano.imports.RegistroImportsPig;
import java.nio.file.Path;

/**
 * Analizador semántico para el lenguaje Pig Latin.
 * Extiende de {@link PigAnalyzer} para compatibilidad con módulos dependientes.
 */
public class SemanticoPig extends PigAnalyzer {

    public SemanticoPig() {
        super();
    }

    public SemanticoPig(RegistroImportsPig registro) {
        super(registro);
    }

    public SemanticoPig(Path directorioBase) {
        super(directorioBase);
    }
}
