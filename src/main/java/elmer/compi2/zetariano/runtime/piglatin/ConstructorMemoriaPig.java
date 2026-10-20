/*
 */
package elmer.compi2.zetariano.runtime.piglatin;

import elmer.compi2.zetariano.core.node.piglatin.BloqueASTPig;
import elmer.compi2.zetariano.core.node.piglatin.DeclaracionASTPig;
import elmer.compi2.zetariano.core.node.piglatin.DoWhileASTPig;
import elmer.compi2.zetariano.core.node.piglatin.ForASTPig;
import elmer.compi2.zetariano.core.node.piglatin.IfASTPig;
import elmer.compi2.zetariano.core.node.piglatin.ProgramaASTPig;
import elmer.compi2.zetariano.core.node.piglatin.SentenciaASTPig;
import elmer.compi2.zetariano.core.node.piglatin.WhileASTPig;

/**
 *
 */
public class ConstructorMemoriaPig {

    private final MarcoPrincipalPig marco;

    public ConstructorMemoriaPig() {

        this.marco
                = new MarcoPrincipalPig();
    }

    public MarcoPrincipalPig construir(
            ProgramaASTPig programa) {

        if (programa == null) {
            return marco;
        }

        // =====================================================
        // VARIABLES GLOBALES
        // =====================================================
        for (SentenciaASTPig sentencia
                : programa.getVariablesGlobales()) {

            procesarSentencia(
                    sentencia
            );
        }

        // =====================================================
        // MAIOR
        // =====================================================
        for (SentenciaASTPig sentencia
                : programa.getPrincipal()) {

            procesarSentencia(
                    sentencia
            );
        }

        return marco;
    }

    // =========================================================
    // RECORRIDO
    // =========================================================
    private void procesarSentencia(
            SentenciaASTPig sentencia) {

        if (sentencia == null) {
            return;
        }

        // -----------------------------------------------------
        // DECLARACION
        // -----------------------------------------------------
        if (sentencia instanceof DeclaracionASTPig declaracion) {

            marco.registrar(
                    declaracion
            );

            return;
        }

        // -----------------------------------------------------
        // BLOQUE
        // -----------------------------------------------------
        if (sentencia instanceof BloqueASTPig bloque) {

            procesarBloque(
                    bloque
            );

            return;
        }

        // -----------------------------------------------------
        // IF
        // -----------------------------------------------------
        if (sentencia instanceof IfASTPig sentenciaIf) {

            procesarBloque(
                    sentenciaIf.getBloqueVerdadero()
            );

            if (sentenciaIf.getBloqueFalso()
                    != null) {

                procesarBloque(
                        sentenciaIf.getBloqueFalso()
                );
            }

            return;
        }

        // -----------------------------------------------------
        // WHILE
        // -----------------------------------------------------
        if (sentencia instanceof WhileASTPig whileAST) {

            procesarBloque(
                    whileAST.getCuerpo()
            );

            return;
        }

        // -----------------------------------------------------
        // DO WHILE
        // -----------------------------------------------------
        if (sentencia instanceof DoWhileASTPig doWhile) {

            procesarBloque(
                    doWhile.getCuerpo()
            );

            return;
        }

        // -----------------------------------------------------
        // FOR
        // -----------------------------------------------------
        if (sentencia instanceof ForASTPig forAST) {

            procesarSentencia(
                    forAST.getInicializacion()
            );

            procesarBloque(
                    forAST.getCuerpo()
            );
        }
    }

    private void procesarBloque(
            BloqueASTPig bloque) {

        if (bloque == null) {
            return;
        }

        for (SentenciaASTPig sentencia
                : bloque.getSentencias()) {

            procesarSentencia(
                    sentencia
            );
        }
    }
}
