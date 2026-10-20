package elmer.compi2.zetariano.analysis.semantic;

import java.nio.file.Path;

/**
 * Analizador semántico para el lenguaje Pig Latin.
 * Extiende de {@link PigAnalyzer} para compatibilidad con módulos dependientes.
 */
public class SemanticoPig extends PigAnalyzer {

    public SemanticoPig() {
        super();
    }

    public SemanticoPig(Path directorioBase) {
        super(directorioBase);
    }
}
