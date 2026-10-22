package elmer.compi2.zetariano;

import elmer.compi2.zetariano.antlr.piglatin.PigLatinLexer;
import elmer.compi2.zetariano.antlr.piglatin.PigLatinParser;
import elmer.compi2.zetariano.antlr.zeta.ZLexer;
import elmer.compi2.zetariano.antlr.zeta.ZParser;
import elmer.compi2.zetariano.core.node.piglatin.DeclaracionASTPig;
import elmer.compi2.zetariano.core.node.piglatin.LiteralASTPig;
import elmer.compi2.zetariano.core.node.piglatin.ProgramaASTPig;
import elmer.compi2.zetariano.core.node.zeta.*;
import elmer.compi2.zetariano.parser.piglatin.PigTreeBuilder;
import elmer.compi2.zetariano.parser.zeta.ZTreeBuilder;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/** Pruebas unitarias para construccion del AST en la Fase 1. */
public class ASTPhase1Test {

    @Test
    public void testZetaASTInheritanceAndModifiers() {
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
        var builder = new ZTreeBuilder();
        var ast = (ProgramaASTZ) builder.visit(parser.programa());

        assertNotNull(ast);
        ClaseASTZ clase = ast.getClase();
        assertNotNull(clase);
        assertEquals("Perro", clase.getNombre());
        assertTrue(clase.tienePadre());
        assertEquals("Animal", clase.getNombrePadre());

        // Verificar miembros
        assertEquals(4, clase.getMiembros().size());

        AtributoASTZ edad = (AtributoASTZ) clase.getMiembros().get(0);
        assertEquals("edad", edad.getNombre());
        assertEquals(ModificadorAccesoZ.PRIVATE, edad.getModificador());

        AtributoASTZ raza = (AtributoASTZ) clase.getMiembros().get(1);
        assertEquals("raza", raza.getNombre());
        assertEquals(ModificadorAccesoZ.PROTECTED, raza.getModificador());

        ConstructorASTZ constructor = (ConstructorASTZ) clase.getMiembros().get(2);
        assertEquals("Perro", constructor.getNombre());
        assertEquals(ModificadorAccesoZ.PUBLIC, constructor.getModificador());
        assertTrue(constructor.getCuerpo().getSentencias().get(0) instanceof LlamadaConstructorEspecialASTZ);
        var llamadaEspecial = (LlamadaConstructorEspecialASTZ) constructor.getCuerpo().getSentencias().get(0);
        assertEquals(LlamadaConstructorEspecialASTZ.Tipo.SUPER, llamadaEspecial.getTipo());

        MetodoASTZ metodo = (MetodoASTZ) clase.getMiembros().get(3);
        assertEquals("hacerSonido", metodo.getNombre());
        assertEquals(ModificadorAccesoZ.PUBLIC, metodo.getModificador());
        assertTrue(metodo.isOverride());
    }

    @Test
    public void testPigLatinASTNullAndTypedObjects() {
        String code = """
            VARIABILES>
            esto perro : novus Perro("Firulais") : Animal;
            esto fantasma : null : Animal;
            MAIOR>
            FINIS;
            """;
        var lexer = new PigLatinLexer(CharStreams.fromString(code));
        var parser = new PigLatinParser(new CommonTokenStream(lexer));
        var builder = new PigTreeBuilder();
        var ast = (ProgramaASTPig) builder.visit(parser.programa());

        assertNotNull(ast);
        assertEquals(2, ast.getVariablesGlobales().size());

        DeclaracionASTPig perro = (DeclaracionASTPig) ast.getVariablesGlobales().get(0);
        assertEquals("perro", perro.getNombre());
        assertEquals("Animal", perro.getTipo());
        assertNotNull(perro.getInicializador());

        DeclaracionASTPig fantasma = (DeclaracionASTPig) ast.getVariablesGlobales().get(1);
        assertEquals("fantasma", fantasma.getNombre());
        assertEquals("Animal", fantasma.getTipo());
        assertTrue(fantasma.getInicializador() instanceof LiteralASTPig);
        LiteralASTPig literalNull = (LiteralASTPig) fantasma.getInicializador();
        assertNull(literalNull.getValor());
        assertEquals("null", literalNull.getTipo());
    }
}
