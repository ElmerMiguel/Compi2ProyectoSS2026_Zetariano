/*
 */
package elmer.compi2.zetariano.codigo.unificado;

import elmer.compi2.zetariano.codegen.Cuadruplo;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 *
 */
public class GeneradorCUnificado {

    private final List<Cuadruplo> cuadruplos;

    private final StringBuilder salida;

    /*
     * firma -> temporales usados dentro de esa función
     */
    private final Map<String, Set<String>> temporalesPorFuncion;

    private final Set<String> funciones;

    public GeneradorCUnificado(
            List<Cuadruplo> cuadruplos) {

        this.cuadruplos
                = cuadruplos == null
                        ? new ArrayList<>()
                        : new ArrayList<>(cuadruplos);

        this.salida
                = new StringBuilder();

        this.temporalesPorFuncion
                = new LinkedHashMap<>();

        this.funciones
                = new LinkedHashSet<>();
    }

    // =========================================================
    // GENERAR
    // =========================================================
    public String generar() {

        salida.setLength(0);

        temporalesPorFuncion.clear();
        funciones.clear();

        recolectar();

        generarEncabezado();

        generarRuntime();

        generarPrototipos();

        generarFunciones();

        generarMain();

        return salida.toString();
    }

    // =========================================================
    // RECOLECCION
    // =========================================================
    private void recolectar() {

        String funcionActual = null;

        for (Cuadruplo cuadruplo
                : cuadruplos) {

            if (cuadruplo == null) {
                continue;
            }

            String operador
                    = cuadruplo.getOperador();

            if ("FUNC_BEGIN".equals(
                    operador)) {

                funcionActual
                        = cuadruplo.getArgumento1();

                if (funcionActual != null) {

                    funciones.add(
                            funcionActual
                    );

                    temporalesPorFuncion.putIfAbsent(
                            funcionActual,
                            new LinkedHashSet<>()
                    );
                }

                continue;
            }

            if ("FUNC_END".equals(
                    operador)) {

                funcionActual = null;
                continue;
            }

            if (funcionActual == null) {
                continue;
            }

            registrarTemporal(
                    funcionActual,
                    cuadruplo.getArgumento1()
            );

            registrarTemporal(
                    funcionActual,
                    cuadruplo.getArgumento2()
            );

            registrarTemporal(
                    funcionActual,
                    cuadruplo.getResultado()
            );
        }
    }

    private void registrarTemporal(
            String funcion,
            String valor) {

        if (funcion == null
                || valor == null) {

            return;
        }

        if (!valor.matches(
                "t\\d+")) {

            return;
        }

        temporalesPorFuncion
                .computeIfAbsent(
                        funcion,
                        k -> new LinkedHashSet<>()
                )
                .add(valor);
    }

    // =========================================================
    // ENCABEZADO
    // =========================================================
    private void generarEncabezado() {

        salida.append(
                "#include <stdio.h>\n"
        );

        salida.append(
                "#include <stdlib.h>\n"
        );

        salida.append(
                "#include <string.h>\n"
        );

        salida.append(
                "#include <math.h>\n\n"
        );

        salida.append(
                "#include <ctype.h>\n"
                + "#include <errno.h>\n"
                + "#include <limits.h>\n\n"
        );

        salida.append(
                "#define STACK_SIZE 100000\n"
        );

        salida.append(
                "#define HEAP_SIZE 100000\n\n"
        );

        salida.append(
                "double Stack[STACK_SIZE];\n"
        );

        salida.append(
                "double Heap[HEAP_SIZE];\n\n"
        );

        salida.append(
                "double P = 0;\n"
        );

        salida.append(
                "double H = 0;\n\n"
        );
    }

    // =========================================================
    // RUNTIME
    // =========================================================
    private void generarRuntime() {

        generarRuntimePrintString();
        generarRuntimePrintDouble();
        generarRuntimeReadln();
        generarRuntimeReadLine();
        generarRuntimeReadInt();
        generarRuntimeReadDouble();
        generarRuntimeReadChar();
        generarRuntimeReadBool();

        generarRuntimeIntToString();
        generarRuntimeDoubleToString();
        generarRuntimeBoolToString();
        generarRuntimeCharToString();
    }

    private void generarRuntimePrintString() {

        salida.append(
                "void runtime_print_string(double ptr) {\n"
        );

        salida.append(
                "    int p = (int)ptr;\n"
        );

        salida.append(
                "    while ((int)Heap[p] != -1) {\n"
        );

        salida.append(
                "        putchar((char)((int)Heap[p]));\n"
        );

        salida.append(
                "        p++;\n"
        );

        salida.append(
                "    }\n"
        );

        salida.append(
                "}\n\n"
        );
    }

    private void generarRuntimeReadln() {

        salida.append(
                "double runtime_readln() {\n"
        );

        salida.append(
                "    double inicio = H;\n"
        );

        salida.append(
                "    int c;\n"
        );

        salida.append(
                "    while ((c = getchar()) != '\\n' && c != EOF) {\n"
        );

        salida.append(
                "        Heap[(int)H] = (double)c;\n"
        );

        salida.append(
                "        H = H + 1;\n"
        );

        salida.append(
                "    }\n"
        );

        salida.append(
                "    Heap[(int)H] = -1;\n"
        );

        salida.append(
                "    H = H + 1;\n"
        );

        salida.append(
                "    return inicio;\n"
        );

        salida.append(
                "}\n\n"
        );
    }

    private void generarRuntimePrintDouble() {
        salida.append(
                "void runtime_print_double(double valor, int saltoLinea) {\n"
                + "    char buffer[64];\n"
                + "    snprintf(buffer, sizeof(buffer), \"%.15g\", valor);\n"
                + "    fputs(buffer, stdout);\n"
                + "    if (isfinite(valor)\n"
                + "            && strchr(buffer, '.') == NULL\n"
                + "            && strchr(buffer, 'e') == NULL\n"
                + "            && strchr(buffer, 'E') == NULL) {\n"
                + "        fputs(\".0\", stdout);\n"
                + "    }\n"
                + "    if (saltoLinea) putchar('\\n');\n"
                + "}\n\n"
        );
    }

    private void generarRuntimeReadInt() {
        salida.append(
                "double runtime_read_int() {\n"
                + "    char buffer[256];\n"
                + "    for (;;) {\n"
                + "        char *fin;\n"
                + "        int huboDigitos;\n"
                + "        long valor;\n"
                + "        if (!runtime_read_line(buffer, sizeof(buffer))) return 0;\n"
                + "        errno = 0;\n"
                + "        fin = NULL;\n"
                + "        valor = strtol(buffer, &fin, 10);\n"
                + "        huboDigitos = fin != buffer;\n"
                + "        while (fin != NULL && isspace((unsigned char)*fin)) fin++;\n"
                + "        if (huboDigitos && fin != NULL && *fin == '\\0'\n"
                + "                && errno != ERANGE && valor >= INT_MIN && valor <= INT_MAX) {\n"
                + "            return (double)valor;\n"
                + "        }\n"
                + "        printf(\"Entrada invalida. Ingrese un entero: \");\n"
                + "        fflush(stdout);\n"
                + "    }\n"
                + "}\n\n"
        );
    }

    private void generarRuntimeReadDouble() {
        salida.append(
                "double runtime_read_double() {\n"
                + "    char buffer[256];\n"
                + "    for (;;) {\n"
                + "        char *fin;\n"
                + "        int huboDigitos;\n"
                + "        double valor;\n"
                + "        if (!runtime_read_line(buffer, sizeof(buffer))) return 0;\n"
                + "        errno = 0;\n"
                + "        fin = NULL;\n"
                + "        valor = strtod(buffer, &fin);\n"
                + "        huboDigitos = fin != buffer;\n"
                + "        while (fin != NULL && isspace((unsigned char)*fin)) fin++;\n"
                + "        if (huboDigitos && fin != NULL && *fin == '\\0'\n"
                + "                && errno != ERANGE && isfinite(valor)) {\n"
                + "            return valor;\n"
                + "        }\n"
                + "        printf(\"Entrada invalida. Ingrese un decimal: \");\n"
                + "        fflush(stdout);\n"
                + "    }\n"
                + "}\n\n"
        );
    }

    private void generarRuntimeReadChar() {
        salida.append(
                "double runtime_read_char() {\n"
                + "    char buffer[256];\n"
                + "    for (;;) {\n"
                + "        if (!runtime_read_line(buffer, sizeof(buffer))) return 0;\n"
                + "        if (strlen(buffer) == 1) {\n"
                + "            return (double)(unsigned char)buffer[0];\n"
                + "        }\n"
                + "        printf(\"Entrada invalida. Ingrese exactamente un caracter: \");\n"
                + "        fflush(stdout);\n"
                + "    }\n"
                + "}\n\n"
        );
    }

    private void generarRuntimeReadBool() {
        salida.append(
                "double runtime_read_bool() {\n"
                + "    char buffer[256];\n"
                + "    for (;;) {\n"
                + "        size_t i;\n"
                + "        if (!runtime_read_line(buffer, sizeof(buffer))) return 0;\n"
                + "        for (i = 0; buffer[i] != '\\0'; i++) {\n"
                + "            buffer[i] = (char)tolower((unsigned char)buffer[i]);\n"
                + "        }\n"
                + "        if (strcmp(buffer, \"1\") == 0\n"
                + "                || strcmp(buffer, \"true\") == 0\n"
                + "                || strcmp(buffer, \"verum\") == 0) return 1;\n"
                + "        if (strcmp(buffer, \"0\") == 0\n"
                + "                || strcmp(buffer, \"false\") == 0\n"
                + "                || strcmp(buffer, \"falsus\") == 0) return 0;\n"
                + "        printf(\"Entrada invalida. Use 1, 0, true, false, verum o falsus: \");\n"
                + "        fflush(stdout);\n"
                + "    }\n"
                + "}\n\n"
        );
    }

    private void generarRuntimeReadLine() {
        salida.append(
                "int runtime_read_line(char *buffer, size_t capacidad) {\n"
                + "    size_t longitud;\n"
                + "    int c;\n"
                + "    if (fgets(buffer, (int)capacidad, stdin) == NULL) return 0;\n"
                + "    longitud = strcspn(buffer, \"\\r\\n\");\n"
                + "    if (buffer[longitud] == '\\0' && longitud == capacidad - 1) {\n"
                + "        while ((c = getchar()) != '\\n' && c != EOF) { }\n"
                + "    }\n"
                + "    buffer[longitud] = '\\0';\n"
                + "    return 1;\n"
                + "}\n\n"
        );
    }

    private void generarRuntimeIntToString() {

        salida.append(
                "double runtime_int_to_string(double valor) {\n"
        );

        salida.append(
                "    char buffer[64];\n"
        );

        salida.append(
                "    sprintf(buffer, \"%d\", (int)valor);\n"
        );

        salida.append(
                "    double inicio = H;\n"
        );

        generarCopiaBuffer();

        salida.append(
                "    return inicio;\n"
        );

        salida.append(
                "}\n\n"
        );
    }

    private void generarRuntimeDoubleToString() {

        salida.append(
                "double runtime_double_to_string(double valor) {\n"
        );

        salida.append(
                "    char buffer[128];\n"
        );

        salida.append(
                "    sprintf(buffer, \"%g\", valor);\n"
        );

        salida.append(
                "    double inicio = H;\n"
        );

        generarCopiaBuffer();

        salida.append(
                "    return inicio;\n"
        );

        salida.append(
                "}\n\n"
        );
    }

    private void generarRuntimeBoolToString() {

        salida.append(
                "double runtime_bool_to_string(double valor) {\n"
        );

        salida.append(
                "    const char* texto = valor != 0 ? \"true\" : \"false\";\n"
        );

        salida.append(
                "    double inicio = H;\n"
        );

        salida.append(
                "    for (int i = 0; texto[i] != '\\0'; i++) {\n"
        );

        salida.append(
                "        Heap[(int)H] = (double)texto[i];\n"
        );

        salida.append(
                "        H = H + 1;\n"
        );

        salida.append(
                "    }\n"
        );

        salida.append(
                "    Heap[(int)H] = -1;\n"
        );

        salida.append(
                "    H = H + 1;\n"
        );

        salida.append(
                "    return inicio;\n"
        );

        salida.append(
                "}\n\n"
        );
    }

    private void generarRuntimeCharToString() {

        salida.append(
                "double runtime_char_to_string(double valor) {\n"
        );

        salida.append(
                "    double inicio = H;\n"
        );

        salida.append(
                "    Heap[(int)H] = valor;\n"
        );

        salida.append(
                "    H = H + 1;\n"
        );

        salida.append(
                "    Heap[(int)H] = -1;\n"
        );

        salida.append(
                "    H = H + 1;\n"
        );

        salida.append(
                "    return inicio;\n"
        );

        salida.append(
                "}\n\n"
        );
    }

    private void generarCopiaBuffer() {

        salida.append(
                "    for (int i = 0; buffer[i] != '\\0'; i++) {\n"
        );

        salida.append(
                "        Heap[(int)H] = (double)buffer[i];\n"
        );

        salida.append(
                "        H = H + 1;\n"
        );

        salida.append(
                "    }\n"
        );

        salida.append(
                "    Heap[(int)H] = -1;\n"
        );

        salida.append(
                "    H = H + 1;\n"
        );
    }

    // =========================================================
    // PROTOTIPOS
    // =========================================================
    private void generarPrototipos() {

        for (String funcion
                : funciones) {

            salida.append(
                    "void "
            );

            salida.append(
                    sanitizarFirma(
                            funcion
                    )
            );

            salida.append(
                    "();\n"
            );
        }

        salida.append("\n");
    }

    // =========================================================
    // FUNCIONES
    // =========================================================
    private void generarFunciones() {

        String funcionActual = null;

        boolean dentroFuncion = false;

        for (Cuadruplo cuadruplo
                : cuadruplos) {

            if (cuadruplo == null) {
                continue;
            }

            String operador
                    = cuadruplo.getOperador();

            // -------------------------------------------------
            // IGNORAR METADATA
            // -------------------------------------------------
            if ("CLASS_BEGIN".equals(operador)
                    || "CLASS_END".equals(operador)
                    || "ATTR".equals(operador)) {

                continue;
            }

            // -------------------------------------------------
            // INICIO FUNCION
            // -------------------------------------------------
            if ("FUNC_BEGIN".equals(
                    operador)) {

                funcionActual
                        = cuadruplo.getArgumento1();

                salida.append(
                        "void "
                );

                salida.append(
                        sanitizarFirma(
                                funcionActual
                        )
                );

                salida.append(
                        "() {\n"
                );

                generarTemporalesFuncion(
                        funcionActual
                );

                dentroFuncion = true;

                continue;
            }

            // -------------------------------------------------
            // FIN FUNCION
            // -------------------------------------------------
            if ("FUNC_END".equals(
                    operador)) {

                salida.append(
                        "}\n\n"
                );

                dentroFuncion = false;
                funcionActual = null;

                continue;
            }

            if (!dentroFuncion) {
                continue;
            }

            traducir(
                    cuadruplo
            );
        }
    }

    private void generarTemporalesFuncion(
            String funcion) {

        Set<String> temporales
                = temporalesPorFuncion.get(
                        funcion
                );

        if (temporales == null
                || temporales.isEmpty()) {

            return;
        }

        salida.append(
                "    double "
        );

        int contador = 0;

        for (String temporal
                : temporales) {

            if (contador > 0) {
                salida.append(", ");
            }

            salida.append(
                    temporal
            );

            contador++;
        }

        salida.append(
                ";\n"
        );
    }

    // =========================================================
    // TRADUCCION
    // =========================================================
    private void traducir(
            Cuadruplo cuadruplo) {

        String operador
                = cuadruplo.getOperador();

        String a1
                = normalizar(
                        cuadruplo.getArgumento1()
                );

        String a2
                = normalizar(
                        cuadruplo.getArgumento2()
                );

        String resultado
                = normalizar(
                        cuadruplo.getResultado()
                );

        switch (operador) {

            // =================================================
            // METADATA
            // =================================================
            case "DECL", "PARAM" -> {
                return;
            }

            // =================================================
            // ASIGNACION
            // =================================================
            case "=" -> {

                linea(
                        resultado
                        + " = "
                        + a1
                        + ";"
                );
            }

            // =================================================
            // BINARIOS
            // =================================================
            case "+", "*", "/", "<", ">", "<=", ">=", "==", "!=", "&&", "||" -> {

                linea(
                        resultado
                        + " = "
                        + a1
                        + " "
                        + operador
                        + " "
                        + a2
                        + ";"
                );
            }

            case "-" -> {

                String argumento2Original
                        = cuadruplo.getArgumento2();

                boolean esMenosUnario
                        = argumento2Original == null
                        || argumento2Original.isBlank()
                        || "-".equals(argumento2Original);

                if (esMenosUnario) {

                    linea(
                            resultado
                            + " = -("
                            + a1
                            + ");"
                    );

                } else {

                    linea(
                            resultado
                            + " = "
                            + a1
                            + " - "
                            + a2
                            + ";"
                    );
                }
            }

            // =================================================
            // MODULO
            // =================================================
            case "%" -> {

                linea(
                        resultado
                        + " = fmod("
                        + a1
                        + ", "
                        + a2
                        + ");"
                );
            }

            // =================================================
            // NOT
            // =================================================
            case "!" -> {

                linea(
                        resultado
                        + " = !("
                        + a1
                        + ");"
                );
            }

            // =================================================
            // STACK
            // =================================================
            case "STACK_GET" -> {

                linea(
                        resultado
                        + " = Stack[(int)"
                        + a1
                        + "];"
                );
            }

            case "STACK_SET" -> {

                linea(
                        "Stack[(int)"
                        + resultado
                        + "] = "
                        + a1
                        + ";"
                );
            }

            // =================================================
            // HEAP
            // =================================================
            case "HEAP_GET" -> {

                linea(
                        resultado
                        + " = Heap[(int)"
                        + a1
                        + "];"
                );
            }

            case "HEAP_SET" -> {

                linea(
                        "Heap[(int)"
                        + resultado
                        + "] = "
                        + a1
                        + ";"
                );
            }

            // =================================================
            // LABEL
            // =================================================
            case "LABEL" -> {

                salida.append(
                        resultado
                );

                salida.append(
                        ":\n"
                );

                salida.append(
                        "    ;\n"
                );
            }
            // =================================================
            // GOTO
            // =================================================
            case "GOTO" -> {

                linea(
                        "goto "
                        + resultado
                        + ";"
                );
            }

            // =================================================
            // IF FALSE
            // =================================================
            case "IF_FALSE" -> {

                linea(
                        "if (!("
                        + a1
                        + ")) goto "
                        + resultado
                        + ";"
                );
            }

            // =================================================
            // IF TRUE
            // =================================================
            case "IF_TRUE" -> {

                linea(
                        "if ("
                        + a1
                        + ") goto "
                        + resultado
                        + ";"
                );
            }

            // =================================================
            // CALL
            // =================================================
            case "CALL" -> {

                linea(
                        sanitizarFirma(
                                a1
                        )
                        + "();"
                );
            }

            // =================================================
            // RETURN
            // =================================================
            case "RETURN" -> {

                linea(
                        "return;"
                );
            }

            // =================================================
            // PRINT
            // =================================================
            case "PRINT" -> {

                linea(
                        "printf(\"%g\", (double)("
                        + a1
                        + "));"
                );
            }

            case "PRINTLN" -> {

                linea(
                        "printf(\"%g\\n\", (double)("
                        + a1
                        + "));"
                );
            }

            case "PRINT_DOUBLE" -> {

                linea(
                        "runtime_print_double((double)("
                        + a1
                        + "), 0);"
                );
            }

            case "PRINTLN_DOUBLE" -> {

                linea(
                        "runtime_print_double((double)("
                        + a1
                        + "), 1);"
                );
            }

            case "PRINT_STRING" -> {

                linea(
                        "runtime_print_string("
                        + a1
                        + ");"
                );
            }

            case "PRINTLN_STRING" -> {

                linea(
                        "runtime_print_string("
                        + a1
                        + ");"
                );

                linea(
                        "printf(\"\\n\");"
                );
            }

            // =================================================
            // INPUT
            // =================================================
            case "READ", "READLN" -> {

                linea(
                        resultado
                        + " = runtime_readln();"
                );
            }

            case "PRINT_CHAR" -> {

                linea(
                        "printf(\"%c\", (char)((int)("
                        + a1
                        + ")));"
                );
            }

            case "PRINTLN_CHAR" -> {

                linea(
                        "printf(\"%c\\n\", (char)((int)("
                        + a1
                        + ")));"
                );
            }

            case "READ_INT" -> {
                linea(resultado + " = runtime_read_int();");
            }

            case "READ_DOUBLE" -> {
                linea(resultado + " = runtime_read_double();");
            }

            case "READ_CHAR" -> {
                linea(resultado + " = runtime_read_char();");
            }

            case "READ_BOOL" -> {
                linea(resultado + " = runtime_read_bool();");
            }

            // =================================================
            // CONVERSIONES
            // =================================================
            case "INT_TO_STRING" -> {

                linea(
                        resultado
                        + " = runtime_int_to_string("
                        + a1
                        + ");"
                );
            }

            case "DOUBLE_TO_STRING" -> {

                linea(
                        resultado
                        + " = runtime_double_to_string("
                        + a1
                        + ");"
                );
            }

            case "BOOL_TO_STRING" -> {

                linea(
                        resultado
                        + " = runtime_bool_to_string("
                        + a1
                        + ");"
                );
            }

            case "CHAR_TO_STRING" -> {

                linea(
                        resultado
                        + " = runtime_char_to_string("
                        + a1
                        + ");"
                );
            }

            // =================================================
            // DESCONOCIDO
            // =================================================
            default -> {

                salida.append(
                        "    /* OPERACION NO IMPLEMENTADA: "
                );

                salida.append(
                        operador
                );

                salida.append(
                        " */\n"
                );
            }
        }
    }

    // =========================================================
    // MAIN
    // =========================================================
    private void generarMain() {

        salida.append(
                "int main() {\n"
        );

        salida.append(
                "    P = 0;\n"
        );

        salida.append(
                "    H = 0;\n"
        );

        if (funciones.contains(
                "main_pig")) {

            salida.append(
                    "    main_pig();\n"
            );
        }

        salida.append(
                "    return 0;\n"
        );

        salida.append(
                "}\n"
        );
    }

    // =========================================================
    // UTILIDADES
    // =========================================================
    private void linea(
            String texto) {

        salida.append(
                "    "
        );

        salida.append(
                texto
        );

        salida.append(
                "\n"
        );
    }

    private String normalizar(
            String valor) {

        if (valor == null
                || valor.isBlank()
                || "-".equals(valor)) {

            return "0";
        }

        return valor;
    }

    private String sanitizarFirma(
            String firma) {

        if (firma == null
                || firma.isBlank()) {

            return "funcion_desconocida";
        }

        String resultado
                = firma.trim();

        resultado
                = resultado.replace(
                        "[]",
                        "_arr"
                );

        resultado
                = resultado.replace(
                        "(",
                        "_"
                );

        resultado
                = resultado.replace(
                        ")",
                        ""
                );

        resultado
                = resultado.replace(
                        ",",
                        "_"
                );

        resultado
                = resultado.replace(
                        ".",
                        "_"
                );

        resultado
                = resultado.replace(
                        " ",
                        ""
                );

        resultado
                = resultado.replaceAll(
                        "[^a-zA-Z0-9_]",
                        "_"
                );

        if (!resultado.matches(
                "[a-zA-Z_].*")) {

            resultado
                    = "_"
                    + resultado;
        }

        return resultado;
    }
}
