package elmer.compi2.zetariano;

import elmer.compi2.zetariano.analysis.semantic.SemanticoPig;
import elmer.compi2.zetariano.analysis.semantic.SemanticoZ;
import elmer.compi2.zetariano.antlr.piglatin.PigLatinLexer;
import elmer.compi2.zetariano.antlr.piglatin.PigLatinParser;
import elmer.compi2.zetariano.antlr.zeta.ZLexer;
import elmer.compi2.zetariano.antlr.zeta.ZParser;
import elmer.compi2.zetariano.imports.AtributoImportadoPig;
import elmer.compi2.zetariano.imports.ClaseImportadaPig;
import elmer.compi2.zetariano.imports.MetodoImportadoPig;
import elmer.compi2.zetariano.imports.RegistroImportsPig;
import elmer.compi2.zetariano.imports.TipoImportPig;
import java.util.List;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

/** Pruebas unitarias de analisis semantico para herencia, encapsulamiento y polimorfismo. */
public class SemanticPhase2Test {

    private SemanticoZ analizarZ(String codigo) {
        var lexer = new ZLexer(CharStreams.fromString(codigo));
        var parser = new ZParser(new CommonTokenStream(lexer));
        var semantico = new SemanticoZ();
        semantico.analizar(parser.programa());
        return semantico;
    }

    private SemanticoZ analizarAcumulandoZ(SemanticoZ semantico, String codigo) {
        var lexer = new ZLexer(CharStreams.fromString(codigo));
        var parser = new ZParser(new CommonTokenStream(lexer));
        semantico.analizarAcumulando(parser.programa());
        return semantico;
    }

    private SemanticoPig analizarPig(String codigo, RegistroImportsPig registro) {
        var lexer = new PigLatinLexer(CharStreams.fromString(codigo));
        var parser = new PigLatinParser(new CommonTokenStream(lexer));
        var semantico = new SemanticoPig(registro);
        semantico.analizar(parser.programa());
        return semantico;
    }

    @Test
    public void testHerenciaYOverrideValido() {
        var sem = new SemanticoZ();
        analizarAcumulandoZ(sem, """
            public class Animal {
                protected String nombre;
                public Animal() {
                    nombre = "Animal";
                }
                public void hablar() {
                    println("Sonido");
                }
            }
        """);
        Assertions.assertFalse(sem.tieneErrores(), "Animal no debe tener errores: " + sem.getErrores());

        analizarAcumulandoZ(sem, """
            public class Perro extends Animal {
                public Perro() {
                    nombre = "Perro";
                }
                @Override
                public void hablar() {
                    println("Guau");
                }
            }
        """);
        Assertions.assertFalse(sem.tieneErrores(), "Perro no debe tener errores: " + sem.getErrores());
    }

    @Test
    public void testOverrideSinMetodoEnSuperclase() {
        var sem = new SemanticoZ();
        analizarAcumulandoZ(sem, """
            public class Base {
                public Base() {}
            }
        """);
        analizarAcumulandoZ(sem, """
            public class Derivada extends Base {
                public Derivada() {}
                @Override
                public void noExiste() {}
            }
        """);
        Assertions.assertTrue(sem.tieneErrores(), "Debe fallar @Override cuando el metodo no existe en superclase.");
    }

    @Test
    public void testSobreescrituraSinAnotacionOverride() {
        var sem = new SemanticoZ();
        analizarAcumulandoZ(sem, """
            public class Base {
                public Base() {}
                public void saludar() {}
            }
        """);
        analizarAcumulandoZ(sem, """
            public class Hija extends Base {
                public Hija() {}
                public void saludar() {}
            }
        """);
        Assertions.assertTrue(sem.tieneErrores(), "Debe requerir anotacion @Override al sobreescribir.");
    }

    @Test
    public void testAutoHerenciaDetectada() {
        var sem = analizarZ("""
            public class Ciclo extends Ciclo {
                public Ciclo() {}
            }
        """);
        Assertions.assertTrue(sem.tieneErrores(), "Debe fallar si una clase hereda de si misma.");
    }

    @Test
    public void testHerenciaCiclicaDetectada() {
        var sem = new SemanticoZ();
        analizarAcumulandoZ(sem, """
            public class NodoA extends NodoB {
                public NodoA() {}
            }
        """);
        analizarAcumulandoZ(sem, """
            public class NodoB extends NodoA {
                public NodoB() {}
            }
        """);
        Assertions.assertTrue(sem.tieneErrores(), "Debe detectar herencia ciclica.");
    }

    @Test
    public void testViolacionMiembroPrivado() {
        var sem = new SemanticoZ();
        analizarAcumulandoZ(sem, """
            public class Boveda {
                private int secreto;
                public Boveda() {
                    secreto = 42;
                }
            }
        """);
        analizarAcumulandoZ(sem, """
            public class Ladron {
                public Ladron() {}
                public void robar() {
                    Boveda b = new Boveda();
                    int x = b.secreto;
                }
            }
        """);
        Assertions.assertTrue(sem.tieneErrores(), "Debe fallar acceso a atributo privado desde otra clase.");
    }

    @Test
    public void testAccesoProtegidoDesdeSubclase() {
        var sem = new SemanticoZ();
        analizarAcumulandoZ(sem, """
            public class Base {
                protected int valor;
                public Base() {
                    valor = 10;
                }
            }
        """);
        analizarAcumulandoZ(sem, """
            public class Sub extends Base {
                public Sub() {
                    valor = 20;
                }
                public int obtener() {
                    return valor;
                }
            }
        """);
        Assertions.assertFalse(sem.tieneErrores(), "Acceso a miembro protected desde subclase debe ser valido: " + sem.getErrores());
    }

    @Test
    public void testLlamadaConstructorEspecialNoAlInicio() {
        var sem = analizarZ("""
            public class Especial {
                public Especial() {}
                public Especial(int x) {
                    int a = 1;
                    this();
                }
            }
        """);
        Assertions.assertTrue(sem.tieneErrores(), "this() no ubicado en la primera sentencia debe reportar error.");
    }

    @Test
    public void testCicloDelegacionConstructores() {
        var sem = analizarZ("""
            public class Recur {
                public Recur() {
                    this(1);
                }
                public Recur(int x) {
                    this();
                }
            }
        """);
        Assertions.assertTrue(sem.tieneErrores(), "Ciclo de delegacion de constructores debe reportar error.");
    }

    @Test
    public void testFaltaConstructorPadreImplicito() {
        var sem = new SemanticoZ();
        analizarAcumulandoZ(sem, """
            public class PadreSinVacio {
                public PadreSinVacio(int required) {}
            }
        """);
        analizarAcumulandoZ(sem, """
            public class HijaSinSuper extends PadreSinVacio {
                public HijaSinSuper() {}
            }
        """);
        Assertions.assertTrue(sem.tieneErrores(), "Debe requerir super(...) si el padre no tiene constructor vacio.");
    }

    @Test
    public void testPigLatinPolimorfismoYNull() {
        var registro = new RegistroImportsPig();
        var animal = new ClaseImportadaPig("Animal", TipoImportPig.Z);
        animal.registrarMetodo(new MetodoImportadoPig("Animal", "Animal()", "Animal", List.of(), true));
        animal.registrarMetodo(new MetodoImportadoPig("hablar", "hablar()", "void", List.of(), false));
        registro.registrarClase(animal);

        var perro = new ClaseImportadaPig("Perro", TipoImportPig.Z);
        perro.setNombrePadre("Animal");
        perro.registrarMetodo(new MetodoImportadoPig("Perro", "Perro()", "Perro", List.of(), true));
        perro.registrarMetodo(new MetodoImportadoPig("hablar", "hablar()", "void", List.of(), false));
        registro.registrarClase(perro);

        String pigCode = """
            VARIABILES>
            esto p : novus Perro() : Animal;
            esto fantasma : null : Animal;
            series zoo[2] : Animal;
            MAIOR>
            zoo[0] = p;
            si (fantasma == null) {
                p.hablar();
            } finis;
            FINIS;
        """;

        var semPig = analizarPig(pigCode, registro);
        Assertions.assertFalse(semPig.tieneErrores(), "Pig Latin polimorfico no debe tener errores: " + semPig.getErrores());
    }

    @Test
    public void testSuiteOficialZoologicoSemantico() throws Exception {
        var ruta = java.nio.file.Path.of("docs/Pruebas/ArchivosProyectoFinal/01_zoologico/Zoologico.pig");
        if (java.nio.file.Files.exists(ruta)) {
            String codigo = java.nio.file.Files.readString(ruta);
            var lexer = new PigLatinLexer(CharStreams.fromString(codigo));
            var parser = new PigLatinParser(new CommonTokenStream(lexer));
            var sem = new SemanticoPig(ruta.getParent());
            sem.analizar(parser.programa());
            Assertions.assertFalse(sem.tieneErrores(), "Zoologico.pig no debe tener errores: " + sem.getErrores());
        }
    }

    @Test
    public void testSuiteOficialEscuelaSemantico() throws Exception {
        var ruta = java.nio.file.Path.of("docs/Pruebas/ArchivosProyectoFinal/02_escuela/Escuela.pig");
        if (java.nio.file.Files.exists(ruta)) {
            String codigo = java.nio.file.Files.readString(ruta);
            var lexer = new PigLatinLexer(CharStreams.fromString(codigo));
            var parser = new PigLatinParser(new CommonTokenStream(lexer));
            var sem = new SemanticoPig(ruta.getParent());
            sem.analizar(parser.programa());
            Assertions.assertFalse(sem.tieneErrores(), "Escuela.pig no debe tener errores: " + sem.getErrores());
        }
    }

    @Test
    public void testSuiteOficialFigurasSemantico() throws Exception {
        var ruta = java.nio.file.Path.of("docs/Pruebas/ArchivosProyectoFinal/04_figuras/Figuras.pig");
        if (java.nio.file.Files.exists(ruta)) {
            String codigo = java.nio.file.Files.readString(ruta);
            var lexer = new PigLatinLexer(CharStreams.fromString(codigo));
            var parser = new PigLatinParser(new CommonTokenStream(lexer));
            var sem = new SemanticoPig(ruta.getParent());
            sem.analizar(parser.programa());
            Assertions.assertFalse(sem.tieneErrores(), "Figuras.pig no debe tener errores: " + sem.getErrores());
        }
    }

    @Test
    public void testSuiteOficialArenaSemantico() throws Exception {
        var ruta = java.nio.file.Path.of("docs/Pruebas/ArchivosProyectoFinal/05_arena/Arena.pig");
        if (java.nio.file.Files.exists(ruta)) {
            String codigo = java.nio.file.Files.readString(ruta);
            var lexer = new PigLatinLexer(CharStreams.fromString(codigo));
            var parser = new PigLatinParser(new CommonTokenStream(lexer));
            var sem = new SemanticoPig(ruta.getParent());
            sem.analizar(parser.programa());
            Assertions.assertFalse(sem.tieneErrores(), "Arena.pig no debe tener errores: " + sem.getErrores());
        }
    }
}
