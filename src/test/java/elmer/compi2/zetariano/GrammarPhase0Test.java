package elmer.compi2.zetariano;

import elmer.compi2.zetariano.antlr.piglatin.PigLatinLexer;
import elmer.compi2.zetariano.antlr.piglatin.PigLatinParser;
import elmer.compi2.zetariano.antlr.ypython.YLexer;
import elmer.compi2.zetariano.antlr.ypython.YParser;
import elmer.compi2.zetariano.antlr.zeta.ZLexer;
import elmer.compi2.zetariano.antlr.zeta.ZParser;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/** Verifica el reconocimiento de tokens y reglas de gramatica de la Fase 0. */
public class GrammarPhase0Test {

    @Test
    public void testZetaGrammarOopTokens() {
        String code = """
            public class Perro extends Animal {
                private int edad;
                protected String raza;
                public Perro(String nombre) {
                    super();
                    this.raza = "Canino";
                }
                @Override
                public void hacerSonido() {
                    println("Guau");
                }
            }
            """;
        var lexer = new ZLexer(CharStreams.fromString(code));
        var parser = new ZParser(new CommonTokenStream(lexer));
        parser.programa();
        assertEquals(0, parser.getNumberOfSyntaxErrors());
    }

    @Test
    public void testPigLatinNullAndTypedObject() {
        String code = """
            VARIABILES>
            esto perro : novus Perro("Firulais") : Animal;
            esto fantasma : null : Animal;
            MAIOR>
            si (fantasma == null) {
                >> "Es nulo";
            } finis;
            FINIS;
            """;
        var lexer = new PigLatinLexer(CharStreams.fromString(code));
        var parser = new PigLatinParser(new CommonTokenStream(lexer));
        parser.programa();
        assertEquals(0, parser.getNumberOfSyntaxErrors());
    }

    @Test
    public void testYPythonRelationalOperators() {
        String code = """
            %funciones
            definir validar(entero x) -> bool:
                si(x <= 10 && x >= 5) entonces
                    retornar verdadero
                contrario
                    retornar falso
            """;
        var lexer = new YLexer(CharStreams.fromString(code));
        var parser = new YParser(new CommonTokenStream(lexer));
        parser.programa();
        assertEquals(0, parser.getNumberOfSyntaxErrors());
    }
}
