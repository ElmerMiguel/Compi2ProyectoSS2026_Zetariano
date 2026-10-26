package elmer.compi2.zetariano.codegen.riscv;

import elmer.compi2.zetariano.CompilerService;
import elmer.compi2.zetariano.codegen.Cuadruplo;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * Pruebas de emision y ensamble de codigo RISC-V RV32 en RARS.
 */
public class RiscVPhase4Test {

    private final elmer.compi2.zetariano.RarsExecutionService rarsService = new elmer.compi2.zetariano.RarsExecutionService();

    private String ejecutarRars(Path archivoAsm, boolean soloEnsamblar) throws Exception {
        Path rarsPath = rarsService.resolverRarsJar();
        List<String> comando = new ArrayList<>();
        comando.add("java");
        comando.add("-jar");
        comando.add(rarsPath.toString());
        if (soloEnsamblar) {
            comando.add("a");
        }
        comando.add("nc");
        comando.add("sm");
        comando.add(archivoAsm.toAbsolutePath().toString());

        ProcessBuilder pb = new ProcessBuilder(comando);
        pb.redirectErrorStream(true);
        Process proceso = pb.start();

        StringBuilder salida = new StringBuilder();
        try (var reader = new BufferedReader(new InputStreamReader(proceso.getInputStream()))) {
            String linea;
            while ((linea = reader.readLine()) != null) {
                salida.append(linea).append("\n");
            }
        }

        int exitCode = proceso.waitFor();
        Assertions.assertEquals(0, exitCode, "RARS fallo con salida:\n" + salida);
        return salida.toString();
    }

    @Test
    public void testOperacionesAritmeticasBasicas() throws Exception {
        List<Cuadruplo> c3d = List.of(
                new Cuadruplo("FUNC_BEGIN", "main_pig", null, null),
                new Cuadruplo("DECL", "int", null, "t1"),
                new Cuadruplo("=", "10", null, "t1"),
                new Cuadruplo("DECL", "int", null, "t2"),
                new Cuadruplo("=", "20", null, "t2"),
                new Cuadruplo("DECL", "int", null, "t3"),
                new Cuadruplo("+", "t1", "t2", "t3"),
                new Cuadruplo("DECL", "int", null, "t4"),
                new Cuadruplo("-", "t3", "5", "t4"),
                new Cuadruplo("DECL", "int", null, "t5"),
                new Cuadruplo("*", "t4", "2", "t5"),
                new Cuadruplo("PRINTLN", "t5", null, null),
                new Cuadruplo("FUNC_END", "main_pig", null, null)
        );

        GeneradorRiscV gen = new GeneradorRiscV(c3d);
        String asm = gen.generar();

        Assertions.assertTrue(asm.contains("main_pig:"));
        Assertions.assertTrue(asm.contains("fadd.d"));
        Assertions.assertTrue(asm.contains("fsub.d"));
        Assertions.assertTrue(asm.contains("fmul.d"));

        Path tempFile = Files.createTempFile("riscv_aritmetica_", ".s");
        try {
            Files.writeString(tempFile, asm);
            String output = ejecutarRars(tempFile, false);
            Assertions.assertTrue(output.contains("50"), "La salida debe contener 50 ( (10+20-5)*2 )");
        } finally {
            Files.deleteIfExists(tempFile);
        }
    }

    @Test
    public void testComparacionesYControlDeFlujo() throws Exception {
        List<Cuadruplo> c3d = List.of(
                new Cuadruplo("FUNC_BEGIN", "main_pig", null, null),
                new Cuadruplo("DECL", "int", null, "t1"),
                new Cuadruplo("=", "15", null, "t1"),
                new Cuadruplo("DECL", "int", null, "t2"),
                new Cuadruplo("=", "20", null, "t2"),
                new Cuadruplo("DECL", "bool", null, "t3"),
                new Cuadruplo("<", "t1", "t2", "t3"),
                new Cuadruplo("IF_FALSE", "t3", null, "L_ELSE"),
                new Cuadruplo("PRINTLN", "1", null, null),
                new Cuadruplo("GOTO", null, null, "L_FIN"),
                new Cuadruplo("LABEL", null, null, "L_ELSE"),
                new Cuadruplo("PRINTLN", "0", null, null),
                new Cuadruplo("LABEL", null, null, "L_FIN"),
                new Cuadruplo("FUNC_END", "main_pig", null, null)
        );

        GeneradorRiscV gen = new GeneradorRiscV(c3d);
        String asm = gen.generar();

        Path tempFile = Files.createTempFile("riscv_control_", ".s");
        try {
            Files.writeString(tempFile, asm);
            String output = ejecutarRars(tempFile, false);
            Assertions.assertTrue(output.contains("1"), "La condicion 15 < 20 es verdadera, imprime 1");
        } finally {
            Files.deleteIfExists(tempFile);
        }
    }

    @Test
    public void testLlamadaFuncionYRetorno() throws Exception {
        List<Cuadruplo> c3d = List.of(
                new Cuadruplo("FUNC_BEGIN", "sumar_numeros", null, null),
                new Cuadruplo("PARAM", "int", null, "a"),
                new Cuadruplo("PARAM", "int", null, "b"),
                new Cuadruplo("+", "P", "1", "t1"),
                new Cuadruplo("STACK_GET", "t1", null, "t2"),
                new Cuadruplo("+", "P", "2", "t3"),
                new Cuadruplo("STACK_GET", "t3", null, "t4"),
                new Cuadruplo("+", "t2", "t4", "t5"),
                new Cuadruplo("+", "P", "0", "t6"),
                new Cuadruplo("STACK_SET", "t5", null, "t6"),
                new Cuadruplo("RETURN", null, null, null),
                new Cuadruplo("FUNC_END", "sumar_numeros", null, null),

                new Cuadruplo("FUNC_BEGIN", "main_pig", null, null),
                new Cuadruplo("+", "P", "1", "t10"),
                new Cuadruplo("+", "t10", "1", "t11"),
                new Cuadruplo("STACK_SET", "7", null, "t11"),
                new Cuadruplo("+", "t10", "2", "t12"),
                new Cuadruplo("STACK_SET", "8", null, "t12"),
                new Cuadruplo("+", "P", "1", "P"),
                new Cuadruplo("CALL", "sumar_numeros", "2", null),
                new Cuadruplo("+", "P", "0", "t13"),
                new Cuadruplo("STACK_GET", "t13", null, "t14"),
                new Cuadruplo("-", "P", "1", "P"),
                new Cuadruplo("PRINTLN", "t14", null, null),
                new Cuadruplo("FUNC_END", "main_pig", null, null)
        );

        GeneradorRiscV gen = new GeneradorRiscV(c3d);
        String asm = gen.generar();

        Path tempFile = Files.createTempFile("riscv_call_", ".s");
        try {
            Files.writeString(tempFile, asm);
            String output = ejecutarRars(tempFile, false);
            Assertions.assertTrue(output.contains("15"), "La suma de 7 y 8 debe ser 15");
        } finally {
            Files.deleteIfExists(tempFile);
        }
    }

    @Test
    public void testConversionesYStrings() throws Exception {
        List<Cuadruplo> c3d = List.of(
                new Cuadruplo("FUNC_BEGIN", "main_pig", null, null),
                new Cuadruplo("DECL", "int", null, "t1"),
                new Cuadruplo("=", "42", null, "t1"),
                new Cuadruplo("INT_TO_STRING", "t1", null, "t2"),
                new Cuadruplo("PRINTLN_STRING", "t2", null, null),
                new Cuadruplo("BOOL_TO_STRING", "1", null, "t3"),
                new Cuadruplo("PRINTLN_STRING", "t3", null, null),
                new Cuadruplo("FUNC_END", "main_pig", null, null)
        );

        GeneradorRiscV gen = new GeneradorRiscV(c3d);
        String asm = gen.generar();

        Path tempFile = Files.createTempFile("riscv_string_", ".s");
        try {
            Files.writeString(tempFile, asm);
            String output = ejecutarRars(tempFile, false);
            Assertions.assertTrue(output.contains("42"), "Debe imprimir 42");
            Assertions.assertTrue(output.contains("true"), "Debe imprimir true");
        } finally {
            Files.deleteIfExists(tempFile);
        }
    }

    @Test
    public void testSuiteOficialZoologicoRiscV() throws Exception {
        var ruta = Path.of("docs/Pruebas/ArchivosProyectoFinal/01_zoologico/Zoologico.pig");
        if (Files.exists(ruta)) {
            String codigo = Files.readString(ruta);
            var res = new CompilerService().compilePigSource(codigo, ruta.getParent());
            Assertions.assertTrue(res.isSuccess(), "Zoologico.pig debe compilar: " + res.getErrors());

            GeneradorRiscV gen = new GeneradorRiscV(res.getC3dInstructions());
            String asm = gen.generar();
            Assertions.assertFalse(asm.isBlank());

            Path tempFile = Files.createTempFile("riscv_zoologico_", ".s");
            try {
                Files.writeString(tempFile, asm);
                ejecutarRars(tempFile, true);
            } finally {
                Files.deleteIfExists(tempFile);
            }
        }
    }

    @Test
    public void testSuiteOficialEscuelaRiscV() throws Exception {
        var ruta = Path.of("docs/Pruebas/ArchivosProyectoFinal/02_escuela/Escuela.pig");
        if (Files.exists(ruta)) {
            String codigo = Files.readString(ruta);
            var res = new CompilerService().compilePigSource(codigo, ruta.getParent());
            Assertions.assertTrue(res.isSuccess(), "Escuela.pig debe compilar: " + res.getErrors());

            GeneradorRiscV gen = new GeneradorRiscV(res.getC3dInstructions());
            String asm = gen.generar();
            Assertions.assertFalse(asm.isBlank());

            Path tempFile = Files.createTempFile("riscv_escuela_", ".s");
            try {
                Files.writeString(tempFile, asm);
                ejecutarRars(tempFile, true);
            } finally {
                Files.deleteIfExists(tempFile);
            }
        }
    }

    @Test
    public void testSuiteOficialFigurasRiscV() throws Exception {
        var ruta = Path.of("docs/Pruebas/ArchivosProyectoFinal/04_figuras/Figuras.pig");
        if (Files.exists(ruta)) {
            String codigo = Files.readString(ruta);
            var res = new CompilerService().compilePigSource(codigo, ruta.getParent());
            Assertions.assertTrue(res.isSuccess(), "Figuras.pig debe compilar: " + res.getErrors());

            GeneradorRiscV gen = new GeneradorRiscV(res.getC3dInstructions());
            String asm = gen.generar();
            Assertions.assertFalse(asm.isBlank());

            Path tempFile = Files.createTempFile("riscv_figuras_", ".s");
            try {
                Files.writeString(tempFile, asm);
                ejecutarRars(tempFile, true);
            } finally {
                Files.deleteIfExists(tempFile);
            }
        }
    }

    @Test
    public void testSuiteOficialArenaRiscV() throws Exception {
        var ruta = Path.of("docs/Pruebas/ArchivosProyectoFinal/05_arena/Arena.pig");
        if (Files.exists(ruta)) {
            String codigo = Files.readString(ruta);
            var res = new CompilerService().compilePigSource(codigo, ruta.getParent());
            Assertions.assertTrue(res.isSuccess(), "Arena.pig debe compilar: " + res.getErrors());

            GeneradorRiscV gen = new GeneradorRiscV(res.getC3dInstructions());
            String asm = gen.generar();
            Assertions.assertFalse(asm.isBlank());

            Path tempFile = Files.createTempFile("riscv_arena_", ".s");
            try {
                Files.writeString(tempFile, asm);
                ejecutarRars(tempFile, true);
            } finally {
                Files.deleteIfExists(tempFile);
            }
        }
    }
}
