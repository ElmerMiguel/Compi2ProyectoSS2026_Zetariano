/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */
public class ProgramaASTPig
        extends NodoASTPig {

    private final List<ImportASTPig> imports;

    private final List<SentenciaASTPig> variablesGlobales;

    private final List<SentenciaASTPig> principal;

    public ProgramaASTPig(
            int linea,
            int columna) {

        super(
                linea,
                columna
        );

        this.imports
                = new ArrayList<>();

        this.variablesGlobales
                = new ArrayList<>();

        this.principal
                = new ArrayList<>();
    }

    // =========================================================
    // IMPORTS
    // =========================================================
    public void agregarImport(
            ImportASTPig importacion) {

        if (importacion != null) {

            imports.add(
                    importacion
            );
        }
    }

    public List<ImportASTPig> getImports() {

        return Collections.unmodifiableList(
                imports
        );
    }

    // =========================================================
    // VARIABLES GLOBALES
    // =========================================================
    public void agregarVariableGlobal(
            SentenciaASTPig sentencia) {

        if (sentencia != null) {

            variablesGlobales.add(
                    sentencia
            );
        }
    }

    public List<SentenciaASTPig> getVariablesGlobales() {

        return Collections.unmodifiableList(
                variablesGlobales
        );
    }

    // =========================================================
    // PRINCIPAL
    // =========================================================
    public void agregarSentenciaPrincipal(
            SentenciaASTPig sentencia) {

        if (sentencia != null) {

            principal.add(
                    sentencia
            );
        }
    }

    public List<SentenciaASTPig> getPrincipal() {

        return Collections.unmodifiableList(
                principal
        );
    }

    // =========================================================
    // TEXTO
    // =========================================================
    @Override
    public String generarTexto() {

        StringBuilder sb
                = new StringBuilder();

        sb.append("PROGRAMA PIG\n");

        // -----------------------------------------------------
        // IMPORTS
        // -----------------------------------------------------
        sb.append("  IMPORTS\n");

        if (imports.isEmpty()) {

            sb.append(
                    "    (vacio)\n"
            );

        } else {

            for (ImportASTPig importacion
                    : imports) {

                sb.append("    ")
                        .append(
                                importacion.generarTexto()
                        )
                        .append("\n");
            }
        }

        // -----------------------------------------------------
        // VARIABLES
        // -----------------------------------------------------
        sb.append(
                "  VARIABLES GLOBALES\n"
        );

        if (variablesGlobales.isEmpty()) {

            sb.append(
                    "    (vacio)\n"
            );

        } else {

            for (SentenciaASTPig sentencia
                    : variablesGlobales) {

                sb.append("    ")
                        .append(
                                sentencia.generarTexto()
                        )
                        .append("\n");
            }
        }

        // -----------------------------------------------------
        // PRINCIPAL
        // -----------------------------------------------------
        sb.append(
                "  MAIOR\n"
        );

        if (principal.isEmpty()) {

            sb.append(
                    "    (vacio)\n"
            );

        } else {

            for (SentenciaASTPig sentencia
                    : principal) {

                sb.append("    ")
                        .append(
                                sentencia.generarTexto()
                        )
                        .append("\n");
            }
        }

        return sb.toString();
    }

    @Override
    public String toString() {
        return generarTexto();
    }
}
