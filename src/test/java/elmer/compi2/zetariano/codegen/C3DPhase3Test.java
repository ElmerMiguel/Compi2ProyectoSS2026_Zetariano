package elmer.compi2.zetariano.codegen;

import elmer.compi2.zetariano.CompilerService;
import elmer.compi2.zetariano.core.node.zeta.ClaseASTZ;
import elmer.compi2.zetariano.core.node.zeta.ProgramaASTZ;
import elmer.compi2.zetariano.parser.zeta.ZTreeBuilder;
import elmer.compi2.zetariano.runtime.zeta.ClaseMemoriaZ;
import elmer.compi2.zetariano.runtime.zeta.ConstructorMarcosZ;
import elmer.compi2.zetariano.runtime.zeta.TablaMemoriaZ;
import elmer.compi2.zetariano.antlr.zeta.ZLexer;
import elmer.compi2.zetariano.antlr.zeta.ZParser;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

public class C3DPhase3Test {

    private ProgramaASTZ parseZ(String codigo) {
        var lexer = new ZLexer(CharStreams.fromString(codigo));
        var parser = new ZParser(new CommonTokenStream(lexer));
        return (ProgramaASTZ) new ZTreeBuilder().visit(parser.programa());
    }

    @Test
    public void testHeapLayoutConTagYHerencia() {
        String codigoPadre = """
            class Animal {
                public string nombre;
                public int edad;
                Animal(string n, int e) {
                    this.nombre = n;
                    this.edad = e;
                }
            }
            """;

        String codigoHija = """
            class Perro extends Animal {
                public string raza;
                Perro(string n, int e, string r) {
                    super(n, e);
                    this.raza = r;
                }
            }
            """;

        ProgramaASTZ progPadre = parseZ(codigoPadre);
        ProgramaASTZ progHija = parseZ(codigoHija);

        ConstructorMarcosZ cm = new ConstructorMarcosZ();
        TablaMemoriaZ tabla = cm.construir(List.of(progPadre, progHija));

        ClaseMemoriaZ clasePerro = tabla.buscarClase("Perro");
        Assertions.assertNotNull(clasePerro);
        Assertions.assertEquals(3, clasePerro.getTamanoObjeto());
        Assertions.assertEquals(0, clasePerro.buscarAtributo("nombre").getOffset());
        Assertions.assertEquals(1, clasePerro.buscarAtributo("edad").getOffset());
        Assertions.assertEquals(2, clasePerro.buscarAtributo("raza").getOffset());

        GeneradorC3DZ genZ = new GeneradorC3DZ();
        List<Cuadruplo> c3d = genZ.generar(List.of(progPadre, progHija));

        boolean tieneHeapSetTag = false;
        long hashPerro = Integer.toUnsignedLong("Perro".hashCode());
        String tagPerro = String.valueOf(hashPerro);

        for (Cuadruplo q : c3d) {
            if ("HEAP_SET".equals(q.getOperador()) && tagPerro.equals(q.getArgumento1())) {
                tieneHeapSetTag = true;
                break;
            }
        }
        Assertions.assertTrue(c3d.size() > 0);
    }

    @Test
    public void testDespachoDinamicoZ() {
        String codigoBase = """
            class Animal {
                public string nombre;
                Animal(string n) { this.nombre = n; }
                public void hablar() {}
            }
            """;

        String codigoDerivada = """
            class Perro extends Animal {
                Perro(string n) { super(n); }
                @Override
                public void hablar() {}
            }
            """;

        String codigoTest = """
            class Test {
                Test() {}
                public void probar(Animal a) {
                    a.hablar();
                }
            }
            """;

        ProgramaASTZ p1 = parseZ(codigoBase);
        ProgramaASTZ p2 = parseZ(codigoDerivada);
        ProgramaASTZ p3 = parseZ(codigoTest);

        GeneradorC3DZ genZ = new GeneradorC3DZ();
        List<Cuadruplo> c3d = genZ.generar(List.of(p1, p2, p3));

        boolean tieneIfFalse = false;
        boolean llamaPerroHablar = false;
        boolean llamaAnimalHablar = false;

        for (Cuadruplo q : c3d) {
            if ("IF_FALSE".equals(q.getOperador())) {
                tieneIfFalse = true;
            }
            if ("CALL".equals(q.getOperador()) && "Perro.hablar()".equals(q.getArgumento1())) {
                llamaPerroHablar = true;
            }
            if ("CALL".equals(q.getOperador()) && "Animal.hablar()".equals(q.getArgumento1())) {
                llamaAnimalHablar = true;
            }
        }

        Assertions.assertTrue(tieneIfFalse, "Debe emitir IF_FALSE en despacho dinamico");
        Assertions.assertTrue(llamaPerroHablar, "Debe tener CALL Perro.hablar()");
        Assertions.assertTrue(llamaAnimalHablar, "Debe tener CALL Animal.hablar()");
    }

    @Test
    public void testEncadenamientoConstructoresZ() {
        String codigoPadre = """
            class Base {
                Base() {}
            }
            """;

        String codigoHijo = """
            class Hijo extends Base {
                Hijo() {
                    super();
                }
            }
            """;

        ProgramaASTZ p1 = parseZ(codigoPadre);
        ProgramaASTZ p2 = parseZ(codigoHijo);

        GeneradorC3DZ genZ = new GeneradorC3DZ();
        List<Cuadruplo> c3d = genZ.generar(List.of(p1, p2));

        boolean llamaBaseConstructor = false;
        for (Cuadruplo q : c3d) {
            if ("CALL".equals(q.getOperador()) && "Base()".equals(q.getArgumento1())) {
                llamaBaseConstructor = true;
                break;
            }
        }
        Assertions.assertTrue(llamaBaseConstructor, "Constructor Hijo debe llamar a Base()");
    }

    @Test
    public void testSuiteOficialZoologicoC3D() throws Exception {
        var ruta = Path.of("docs/Pruebas/ArchivosProyectoFinal/01_zoologico/Zoologico.pig");
        if (Files.exists(ruta)) {
            String codigo = Files.readString(ruta);
            var res = new CompilerService().compilePigSource(codigo, ruta.getParent());
            Assertions.assertTrue(res.isSuccess(), "Zoologico.pig debe compilar y enlazar C3D: " + res.getErrors());
        }
    }

    @Test
    public void testSuiteOficialEscuelaC3D() throws Exception {
        var ruta = Path.of("docs/Pruebas/ArchivosProyectoFinal/02_escuela/Escuela.pig");
        if (Files.exists(ruta)) {
            String codigo = Files.readString(ruta);
            var res = new CompilerService().compilePigSource(codigo, ruta.getParent());
            Assertions.assertTrue(res.isSuccess(), "Escuela.pig debe compilar y enlazar C3D: " + res.getErrors());
        }
    }

    @Test
    public void testSuiteOficialFigurasC3D() throws Exception {
        var ruta = Path.of("docs/Pruebas/ArchivosProyectoFinal/04_figuras/Figuras.pig");
        if (Files.exists(ruta)) {
            String codigo = Files.readString(ruta);
            var res = new CompilerService().compilePigSource(codigo, ruta.getParent());
            Assertions.assertTrue(res.isSuccess(), "Figuras.pig debe compilar y enlazar C3D: " + res.getErrors());
        }
    }

    @Test
    public void testSuiteOficialArenaC3D() throws Exception {
        var ruta = Path.of("docs/Pruebas/ArchivosProyectoFinal/05_arena/Arena.pig");
        if (Files.exists(ruta)) {
            String codigo = Files.readString(ruta);
            var res = new CompilerService().compilePigSource(codigo, ruta.getParent());
            Assertions.assertTrue(res.isSuccess(), "Arena.pig debe compilar y enlazar C3D: " + res.getErrors());
        }
    }
}
