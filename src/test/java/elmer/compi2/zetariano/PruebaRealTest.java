package elmer.compi2.zetariano;

import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.*;

public class PruebaRealTest {

    private final CompilerService compilerService = new CompilerService();

    @Test
    public void testHelloWorld() throws Exception {
        Path path = Path.of("PruebaReal/00_hello_world/HolaMundo.pig");
        if (Files.exists(path)) {
            String code = Files.readString(path);
            CompilerService.CompilationResult result = compilerService.compilePigSource(code, path.getParent());
            assertTrue(result.isSuccess(), "HolaMundo.pig debe compilar exitosamente: " + result.getConsoleLog());
            assertNotNull(result.getGeneratedCCode());
            assertFalse(result.getGeneratedCCode().isBlank());
        }
    }

    @Test
    public void testCalculadora() throws Exception {
        Path path = Path.of("PruebaReal/01_calculadora/Calculadora.pig");
        if (Files.exists(path)) {
            String code = Files.readString(path);
            CompilerService.CompilationResult result = compilerService.compilePigSource(code, path.getParent());
            assertTrue(result.isSuccess(), "Calculadora.pig debe compilar exitosamente: " + result.getConsoleLog());
            assertNotNull(result.getGeneratedCCode());
            assertFalse(result.getGeneratedCCode().isBlank());
        }
    }

    @Test
    public void testListaDoble() throws Exception {
        Path path = Path.of("PruebaReal/02_lista_doble/ListaDobleMain.pig");
        if (Files.exists(path)) {
            String code = Files.readString(path);
            CompilerService.CompilationResult result = compilerService.compilePigSource(code, path.getParent());
            assertTrue(result.isSuccess(), "ListaDobleMain.pig debe compilar exitosamente: " + result.getConsoleLog());
            assertNotNull(result.getGeneratedCCode());
            assertFalse(result.getGeneratedCCode().isBlank());
        }
    }

    @Test
    public void testLaberinto() throws Exception {
        Path path = Path.of("PruebaReal/03_laberinto/Laberinto.pig");
        if (Files.exists(path)) {
            String code = Files.readString(path);
            CompilerService.CompilationResult result = compilerService.compilePigSource(code, path.getParent());
            assertTrue(result.isSuccess(), "Laberinto.pig debe compilar exitosamente: " + result.getConsoleLog());
            assertNotNull(result.getGeneratedCCode());
            assertFalse(result.getGeneratedCCode().isBlank());
        }
    }

    @Test
    public void testAhorcado() throws Exception {
        Path path = Path.of("PruebaReal/04_ahorcado/JuegoAhorcado.pig");
        if (Files.exists(path)) {
            String code = Files.readString(path);
            CompilerService.CompilationResult result = compilerService.compilePigSource(code, path.getParent());
            assertTrue(result.isSuccess(), "JuegoAhorcado.pig debe compilar exitosamente: " + result.getConsoleLog());
            assertNotNull(result.getGeneratedCCode());
            assertFalse(result.getGeneratedCCode().isBlank());
        }
    }
}
