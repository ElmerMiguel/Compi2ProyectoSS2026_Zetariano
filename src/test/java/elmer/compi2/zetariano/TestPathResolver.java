package elmer.compi2.zetariano;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Utilidad para resolver rutas de archivos de prueba dinámicamente.
 * 1. Revisa si la ruta por defecto existe.
 * 2. Si no existe, revisa si está configurada por propiedad de sistema o variable de entorno (TEST_SUITE_DIR).
 * 3. Si no existe, busca archivos homólogos o equivalentes dentro de PruebaReal/ o en la ruta alternativa conocida.
 * 4. Si aún no existe, solicita interactivamente por consola la nueva ruta o directorio base.
 */
public final class TestPathResolver {

    private static final Map<String, Path> OVERRIDE_CACHE = new ConcurrentHashMap<>();
    private static Path customBaseDir = null;

    private TestPathResolver() {}

    /**
     * Resuelve un archivo dado su path relativo sugerido (e.g. "docs/Pruebas/ArchivosProyectoFinal/02_escuela/Escuela.pig").
     */
    public static Path resolve(String defaultPathStr) {
        Path direct = Path.of(defaultPathStr);
        if (Files.exists(direct)) {
            return direct;
        }

        String fileName = direct.getFileName().toString();
        if (OVERRIDE_CACHE.containsKey(fileName)) {
            Path cached = OVERRIDE_CACHE.get(fileName);
            if (Files.exists(cached)) {
                return cached;
            }
        }

        // 1. Revisar si hay un base dir personalizado establecido
        if (customBaseDir != null && Files.isDirectory(customBaseDir)) {
            Path candidate = customBaseDir.resolve(defaultPathStr);
            if (Files.exists(candidate)) {
                return candidate;
            }
            Path candidateFile = buscarArchivoRecursivo(customBaseDir, fileName);
            if (candidateFile != null) {
                return candidateFile;
            }
        }

        // 2. Revisar variable de entorno o propiedad de sistema
        String envOrProp = System.getProperty("test.suite.dir", System.getenv("TEST_SUITE_DIR"));
        if (envOrProp != null && !envOrProp.isBlank()) {
            Path envBase = Path.of(envOrProp.trim());
            if (Files.exists(envBase)) {
                Path candidate = envBase.resolve(defaultPathStr);
                if (Files.exists(candidate)) {
                    OVERRIDE_CACHE.put(fileName, candidate);
                    return candidate;
                }
                Path found = buscarArchivoRecursivo(envBase, fileName);
                if (found != null) {
                    OVERRIDE_CACHE.put(fileName, found);
                    return found;
                }
            }
        }

        // 3. Revisar en backup original primero si la ruta original contenía docs/Pruebas
        if (defaultPathStr.contains("docs/Pruebas")) {
            Path backupDir = Path.of("src/backup_original/Pruebas");
            if (Files.exists(backupDir)) {
                Path candidateInBackup = buscarArchivoRecursivo(backupDir, fileName);
                if (candidateInBackup != null) {
                    OVERRIDE_CACHE.put(fileName, candidateInBackup);
                    return candidateInBackup;
                }
            }
        }

        // Revisar en PruebaReal (directorio por defecto en el proyecto)
        Path pruebaRealDir = Path.of("PruebaReal");
        if (Files.exists(pruebaRealDir)) {
            Path candidateInPruebaReal = buscarArchivoRecursivo(pruebaRealDir, fileName);
            if (candidateInPruebaReal != null) {
                OVERRIDE_CACHE.put(fileName, candidateInPruebaReal);
                return candidateInPruebaReal;
            }
        }

        // Revisar también en backup original si aplica (por ejemplo Prueba.z o Utilidades.y)
        Path backupDir = Path.of("src/backup_original/Pruebas");
        if (Files.exists(backupDir)) {
            Path candidateInBackup = buscarArchivoRecursivo(backupDir, fileName);
            if (candidateInBackup != null) {
                OVERRIDE_CACHE.put(fileName, candidateInBackup);
                return candidateInBackup;
            }
        }

        // 4. Si no se encontró en ninguna ruta predeterminada, pedir la ruta por consola
        Path promptPath = pedirRutaPorConsola(defaultPathStr, fileName);
        if (promptPath != null && Files.exists(promptPath)) {
            OVERRIDE_CACHE.put(fileName, promptPath);
            return promptPath;
        }

        // Retornar la ruta por defecto para que las aserciones de JUnit reporten claramente si faltara
        return direct;
    }

    /**
     * Resuelve un directorio base (e.g. "docs/Pruebas").
     */
    public static Path resolveDirectory(String defaultDirStr) {
        Path direct = Path.of(defaultDirStr);
        if (Files.isDirectory(direct)) {
            return direct;
        }

        // 1. Revisar si PruebaReal o backup pueden servir como fallback para directorios base
        if (defaultDirStr.contains("docs/Pruebas")) {
            Path backupDir = Path.of("src/backup_original/Pruebas");
            if (Files.isDirectory(backupDir)) {
                return backupDir;
            }
            Path pruebaReal = Path.of("PruebaReal");
            if (Files.isDirectory(pruebaReal)) {
                return pruebaReal;
            }
        }

        String envOrProp = System.getProperty("test.suite.dir", System.getenv("TEST_SUITE_DIR"));
        if (envOrProp != null && !envOrProp.isBlank()) {
            Path envBase = Path.of(envOrProp.trim());
            if (Files.isDirectory(envBase)) {
                return envBase;
            }
        }

        Path promptPath = pedirRutaPorConsola(defaultDirStr, defaultDirStr);
        if (promptPath != null && Files.isDirectory(promptPath)) {
            customBaseDir = promptPath;
            return promptPath;
        }

        return direct;
    }

    private static Path buscarArchivoRecursivo(Path dir, String fileName) {
        if (!Files.isDirectory(dir)) return null;
        try (var stream = Files.walk(dir, 5)) {
            return stream.filter(p -> p.getFileName() != null && p.getFileName().toString().equals(fileName))
                    .findFirst()
                    .orElse(null);
        } catch (Exception e) {
            return null;
        }
    }

    private static Path pedirRutaPorConsola(String originalPath, String targetName) {
        // Si no hay consola interactiva ni System.in disponible, no bloquear indefinidamente
        try {
            System.out.println("\n[TestPathResolver] ADVERTENCIA: No se encontro el recurso de prueba: " + originalPath);
            System.out.println("[TestPathResolver] Ingrese la ruta absoluta o relativa hacia '" + targetName + "' (o directorio contenedor): ");
            System.out.flush();

            // Verificar si System.in tiene bytes listos o leer una linea
            BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
            // Dar oportunidad si hay entrada interactiva
            if (System.console() != null || br.ready()) {
                String input = br.readLine();
                if (input != null && !input.isBlank()) {
                    Path p = Path.of(input.trim());
                    if (Files.exists(p)) {
                        if (Files.isDirectory(p)) {
                            customBaseDir = p;
                            Path found = buscarArchivoRecursivo(p, targetName);
                            return found != null ? found : p;
                        }
                        return p;
                    }
                }
            }
        } catch (Exception ignored) {
        }
        return null;
    }
}
