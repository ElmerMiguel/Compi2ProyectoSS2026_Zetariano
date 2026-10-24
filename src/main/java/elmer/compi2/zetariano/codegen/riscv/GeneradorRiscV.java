package elmer.compi2.zetariano.codegen.riscv;

import elmer.compi2.zetariano.codegen.Cuadruplo;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Generador de codigo ensamblador RISC-V RV32 para ejecucion en RARS.
 */
public final class GeneradorRiscV {

    private static final int TAM_CELDA = 8;

    private final List<Cuadruplo> cuadruplos;
    private final StringBuilder salida = new StringBuilder();
    private final Map<String, Funcion> funciones = new LinkedHashMap<>();
    private final Map<String, Integer> aridades = new LinkedHashMap<>();
    private final Map<String, String> literalesDecimal = new LinkedHashMap<>();
    private int contadorRamasLargas;

    public GeneradorRiscV(List<Cuadruplo> cuadruplos) {
        this.cuadruplos = cuadruplos == null
                ? List.of()
                : new ArrayList<>(cuadruplos);
    }

    public String generar() {
        salida.setLength(0);
        funciones.clear();
        aridades.clear();
        literalesDecimal.clear();
        contadorRamasLargas = 0;

        recolectarFunciones();
        validarEtapaInicial();
        generarEncabezado();

        for (Funcion funcion : funciones.values()) {
            generarFuncion(funcion);
        }

        return salida.toString();
    }

    private void recolectarFunciones() {
        Funcion actual = null;
        boolean dentroClase = false;

        for (Cuadruplo q : cuadruplos) {
            if (q == null) {
                continue;
            }

            if ("CLASS_BEGIN".equals(q.getOperador())) {
                dentroClase = true;
                continue;
            }

            if ("CLASS_END".equals(q.getOperador())) {
                dentroClase = false;
                continue;
            }

            if ("FUNC_BEGIN".equals(q.getOperador())) {
                actual = new Funcion(q.getArgumento1(), dentroClase);
                funciones.put(actual.nombre, actual);
                continue;
            }

            if ("FUNC_END".equals(q.getOperador())) {
                actual = null;
                continue;
            }

            if (actual != null) {
                actual.cuadruplos.add(q);
                if ("PARAM".equals(q.getOperador())) {
                    actual.parametrosDeclarados++;
                }
                actual.registrarTemporal(q.getArgumento1());
                actual.registrarTemporal(q.getArgumento2());
                actual.registrarTemporal(q.getResultado());
                registrarDecimal(q.getArgumento1());
                registrarDecimal(q.getArgumento2());

                if ("CALL".equals(q.getOperador())) {
                    int aridad = esEntero(q.getArgumento2())
                            ? Integer.parseInt(q.getArgumento2())
                            : 0;
                    aridades.merge(q.getArgumento1(), aridad, Math::max);
                }
            }
        }

        for (Funcion funcion : funciones.values()) {
            int aridad = funcion.parametrosDeclarados
                    + (funcion.metodoZ ? 1 : 0);
            aridades.merge(funcion.nombre, aridad, Math::max);
        }
    }

    private void validarEtapaInicial() {
        if (!funciones.containsKey("main_pig")) {
            throw new IllegalStateException(
                    "No existe la funcion de entrada main_pig en el C3D enlazado."
            );
        }

        Set<String> permitidos = Set.of(
                "DECL", "PARAM", "ERROR_C3D", "=", "+", "-", "*", "/", "DIV_INT", "%",
                "<", ">", "<=", ">=", "==", "!=", "&&", "||", "!", "non",
                "STACK_GET", "STACK_SET",
                "HEAP_GET", "HEAP_SET",
                "PRINT", "PRINTLN", "PRINT_STRING", "PRINTLN_STRING",
                "PRINT_DOUBLE", "PRINTLN_DOUBLE",
                "PRINT_CHAR", "PRINTLN_CHAR",
                "READ_INT", "READ_DOUBLE", "READ_CHAR", "READ_BOOL", "READLN",
                "INT_TO_STRING", "DOUBLE_TO_STRING",
                "BOOL_TO_STRING", "CHAR_TO_STRING",
                "LABEL", "GOTO", "IF_FALSE", "IF_TRUE", "RETURN", "CALL"
        );

        Set<String> noImplementados = new LinkedHashSet<>();
        for (Funcion funcion : funciones.values()) {
            for (Cuadruplo q : funcion.cuadruplos) {
                if (!permitidos.contains(q.getOperador())) {
                    noImplementados.add(q.getOperador());
                }
            }
        }

        if (!noImplementados.isEmpty()) {
            throw new IllegalStateException(
                    "El backend RISC-V todavia no implementa: "
                    + String.join(", ", noImplementados)
            );
        }
    }

    private void generarEncabezado() {
        salida.append("# Codigo RISC-V RV32 generado para RARS\n");
        salida.append("# Puntero de stack en sp, frame pointer en s0 y heap en s1\n\n");
        salida.append(".data\n");
        salida.append(".align 3\n");
        for (Map.Entry<String, String> literal : literalesDecimal.entrySet()) {
            salida.append(literal.getValue())
                    .append(": .double ")
                    .append(literal.getKey())
                    .append('\n');
        }
        salida.append("heap_riscv: .space 1048576\n");
        salida.append("salto_linea: .asciz \"\\n\"\n\n");
        salida.append("entrada_riscv: .space 1024\n\n");
        salida.append("solicitud_int: .asciz \"__RISC_INPUT__:INT\\n\"\n");
        salida.append("solicitud_double: .asciz \"__RISC_INPUT__:DOUBLE\\n\"\n");
        salida.append("solicitud_char: .asciz \"__RISC_INPUT__:CHAR\\n\"\n");
        salida.append("solicitud_bool: .asciz \"__RISC_INPUT__:BOOL\\n\"\n");
        salida.append("solicitud_text: .asciz \"__RISC_INPUT__:TEXT\\n\"\n\n");
        salida.append(".text\n");
        salida.append(".globl main\n");
        salida.append("main:\n");
        salida.append("    la s1, heap_riscv\n");
        salida.append("    li s2, 0\n");
        salida.append("    jal ra, main_pig\n");
        salida.append("    li a7, 10\n");
        salida.append("    ecall\n\n");
        generarRuntimeCadenas();
    }

    private void generarRuntimeCadenas() {
        salida.append("imprimir_cadena:\n");
        linea("slli t0, a0, 3");
        linea("add t0, s1, t0");
        salida.append(".L_imprimir_cadena_ciclo:\n");
        linea("fld ft0, 0(t0)");
        linea("fcvt.w.d t1, ft0");
        linea("li t2, -1");
        linea("beq t1, t2, .L_imprimir_cadena_fin");
        linea("mv a0, t1");
        linea("li a7, 11");
        linea("ecall");
        linea("addi t0, t0, 8");
        linea("j .L_imprimir_cadena_ciclo");
        salida.append(".L_imprimir_cadena_fin:\n");
        linea("ret");
        salida.append('\n');

        salida.append("concatenar_cadenas:\n");
        linea("mv t3, s2");
        linea("li t4, 0");
        salida.append(".L_concatenar_seleccionar:\n");
        linea("beqz t4, .L_concatenar_primera");
        linea("mv t5, a1");
        linea("j .L_concatenar_preparar");
        salida.append(".L_concatenar_primera:\n");
        linea("mv t5, a0");
        salida.append(".L_concatenar_preparar:\n");
        linea("slli t0, t5, 3");
        linea("add t0, s1, t0");
        salida.append(".L_concatenar_copiar:\n");
        linea("fld ft0, 0(t0)");
        linea("fcvt.w.d t1, ft0");
        linea("li t2, -1");
        linea("beq t1, t2, .L_concatenar_fin_fuente");
        linea("slli t2, s2, 3");
        linea("add t2, s1, t2");
        linea("fsd ft0, 0(t2)");
        linea("addi s2, s2, 1");
        linea("addi t0, t0, 8");
        linea("j .L_concatenar_copiar");
        salida.append(".L_concatenar_fin_fuente:\n");
        linea("bnez t4, .L_concatenar_terminar");
        linea("li t4, 1");
        linea("j .L_concatenar_seleccionar");
        salida.append(".L_concatenar_terminar:\n");
        linea("li t1, -1");
        linea("fcvt.d.w ft0, t1");
        linea("slli t2, s2, 3");
        linea("add t2, s1, t2");
        linea("fsd ft0, 0(t2)");
        linea("addi s2, s2, 1");
        linea("mv a0, t3");
        linea("ret");
        salida.append('\n');

        salida.append("leer_cadena:\n");
        linea("la t0, entrada_riscv");
        linea("mv a0, t0");
        linea("li a1, 1024");
        linea("li a7, 8");
        linea("ecall");
        linea("mv t3, s2");
        salida.append(".L_leer_cadena_copiar:\n");
        linea("lbu t1, 0(t0)");
        linea("beqz t1, .L_leer_cadena_fin");
        linea("li t4, 10");
        linea("beq t1, t4, .L_leer_cadena_fin");
        linea("li t4, 13");
        linea("beq t1, t4, .L_leer_cadena_fin");
        linea("fcvt.d.w ft0, t1");
        linea("slli t2, s2, 3");
        linea("add t2, s1, t2");
        linea("fsd ft0, 0(t2)");
        linea("addi s2, s2, 1");
        linea("addi t0, t0, 1");
        linea("j .L_leer_cadena_copiar");
        salida.append(".L_leer_cadena_fin:\n");
        linea("li t1, -1");
        linea("fcvt.d.w ft0, t1");
        linea("slli t2, s2, 3");
        linea("add t2, s1, t2");
        linea("fsd ft0, 0(t2)");
        linea("addi s2, s2, 1");
        linea("mv a0, t3");
        linea("ret");
        salida.append('\n');

        generarRuntimeConversiones();
    }

    private void generarRuntimeConversiones() {
        salida.append("entero_a_cadena:\n");
        linea("mv t3, s2");
        linea("fcvt.w.d t0, fa0, rtz");
        linea("bnez t0, .L_entero_no_cero");
        linea("li t2, 48");
        guardarCaracterHeap("t2");
        linea("j .L_entero_terminar");
        salida.append(".L_entero_no_cero:\n");
        linea("bgez t0, .L_entero_preparar");
        linea("li t2, 45");
        guardarCaracterHeap("t2");
        linea("neg t0, t0");
        salida.append(".L_entero_preparar:\n");
        linea("addi sp, sp, -32");
        linea("mv t1, sp");
        linea("li t4, 0");
        salida.append(".L_entero_extraer:\n");
        linea("li t5, 10");
        linea("remu t2, t0, t5");
        linea("addi t2, t2, 48");
        linea("sb t2, 0(t1)");
        linea("addi t1, t1, 1");
        linea("addi t4, t4, 1");
        linea("divu t0, t0, t5");
        linea("bnez t0, .L_entero_extraer");
        salida.append(".L_entero_copiar:\n");
        linea("addi t1, t1, -1");
        linea("lbu t2, 0(t1)");
        guardarCaracterHeap("t2");
        linea("addi t4, t4, -1");
        linea("bnez t4, .L_entero_copiar");
        linea("addi sp, sp, 32");
        salida.append(".L_entero_terminar:\n");
        guardarTerminadorHeap();
        linea("mv a0, t3");
        linea("ret");
        salida.append('\n');

        salida.append("decimal_a_cadena:\n");
        linea("addi sp, sp, -16");
        linea("sw ra, 12(sp)");
        linea("mv t3, s2");
        linea("fmv.d ft5, fa0");
        linea("fcvt.w.d t0, ft5, rtz");
        linea("bgez t0, .L_decimal_absoluto");
        linea("li t2, 45");
        guardarCaracterHeap("t2");
        linea("fneg.d ft5, ft5");
        salida.append(".L_decimal_absoluto:\n");
        linea("fcvt.w.d t0, ft5, rtz");
        linea("fcvt.d.w fa0, t0");
        linea("fsd ft5, 0(sp)");
        linea("sw t3, 8(sp)");
        linea("jal ra, entero_a_cadena");
        linea("fld ft5, 0(sp)");
        linea("lw t3, 8(sp)");
        linea("addi s2, s2, -1");
        linea("fcvt.w.d t0, ft5, rtz");
        linea("fcvt.d.w ft1, t0");
        linea("fsub.d ft2, ft5, ft1");
        linea("fcvt.w.d t1, ft2, rtz");
        linea("fcvt.d.w ft3, t1");
        linea("feq.d t1, ft2, ft3");
        linea("bnez t1, .L_decimal_terminar");
        linea("li t2, 46");
        guardarCaracterHeap("t2");
        linea("li t4, 0");
        linea("li t0, 1");
        linea("fcvt.d.w ft3, t0");
        linea("li t0, 2000000");
        linea("fcvt.d.w ft4, t0");
        linea("fdiv.d ft3, ft3, ft4");
        linea("fadd.d ft2, ft2, ft3");
        linea("li t5, 10");
        linea("fcvt.d.w ft4, t5");
        salida.append(".L_decimal_digitos:\n");
        linea("fmul.d ft2, ft2, ft4");
        linea("fcvt.w.d t2, ft2, rtz");
        linea("addi t6, t2, 48");
        guardarCaracterHeap("t6");
        linea("fcvt.d.w ft1, t2");
        linea("fsub.d ft2, ft2, ft1");
        linea("addi t4, t4, 1");
        linea("li t5, 6");
        linea("blt t4, t5, .L_decimal_digitos");
        salida.append(".L_decimal_recortar:\n");
        linea("addi t0, s2, -1");
        linea("slli t1, t0, 3");
        linea("add t1, s1, t1");
        linea("fld ft0, 0(t1)");
        linea("fcvt.w.d t2, ft0");
        linea("li t5, 48");
        linea("bne t2, t5, .L_decimal_terminar");
        linea("addi s2, s2, -1");
        linea("addi t4, t4, -1");
        linea("bnez t4, .L_decimal_recortar");
        salida.append(".L_decimal_terminar:\n");
        guardarTerminadorHeap();
        linea("mv a0, t3");
        linea("lw ra, 12(sp)");
        linea("addi sp, sp, 16");
        linea("ret");
        salida.append('\n');

        salida.append("booleano_a_cadena:\n");
        linea("mv t3, s2");
        linea("fcvt.w.d t0, fa0");
        linea("beqz t0, .L_booleano_falso");
        for (int caracter : new int[]{116, 114, 117, 101}) {
            linea("li t2, " + caracter);
            guardarCaracterHeap("t2");
        }
        linea("j .L_booleano_terminar");
        salida.append(".L_booleano_falso:\n");
        for (int caracter : new int[]{102, 97, 108, 115, 101}) {
            linea("li t2, " + caracter);
            guardarCaracterHeap("t2");
        }
        salida.append(".L_booleano_terminar:\n");
        guardarTerminadorHeap();
        linea("mv a0, t3");
        linea("ret");
        salida.append('\n');

        salida.append("caracter_a_cadena:\n");
        linea("mv t3, s2");
        linea("fcvt.w.d t2, fa0");
        guardarCaracterHeap("t2");
        guardarTerminadorHeap();
        linea("mv a0, t3");
        linea("ret");
        salida.append('\n');
    }

    private void guardarCaracterHeap(String registro) {
        linea("fcvt.d.w ft0, " + registro);
        linea("slli t5, s2, 3");
        linea("add t5, s1, t5");
        linea("fsd ft0, 0(t5)");
        linea("addi s2, s2, 1");
    }

    private void guardarTerminadorHeap() {
        linea("li t2, -1");
        guardarCaracterHeap("t2");
    }

    private void generarFuncion(Funcion funcion) {
        funcion.prepararMarco();
        salida.append(sanitizar(funcion.nombre)).append(":\n");
        emitirSumaInmediata("sp", "sp", -funcion.tamanoMarco);
        emitirStoreWord("ra", "sp", funcion.tamanoMarco - 4);
        emitirStoreWord("s0", "sp", funcion.tamanoMarco - 8);
        linea("mv s0, sp");

        int aridad = aridades.getOrDefault(funcion.nombre, 0);
        for (int i = 0; i < aridad; i++) {
            int destino = (i + 1) * TAM_CELDA;
            if (i < 8) {
                emitirStoreDouble("fa" + i, "s0", destino);
            } else {
                int origen = funcion.tamanoMarco + (i - 8) * TAM_CELDA;
                emitirLoadDouble("ft0", "s0", origen);
                emitirStoreDouble("ft0", "s0", destino);
            }
        }

        for (int i = 0; i < funcion.cuadruplos.size(); i++) {
            Cuadruplo q = funcion.cuadruplos.get(i);
            try {
                traducir(funcion, q);
            } catch (IllegalStateException ex) {
                throw new IllegalStateException(
                        ex.getMessage()
                        + "\nFuncion C3D: " + funcion.nombre
                        + "\nCuadruplo local: " + (i + 1)
                        + "\nOperacion: " + q.getOperador()
                        + " | arg1=" + q.getArgumento1()
                        + " | arg2=" + q.getArgumento2()
                        + " | resultado=" + q.getResultado(),
                        ex
                );
            }
        }

        emitirEpilogo(funcion);
        salida.append('\n');
    }

    private void traducir(Funcion f, Cuadruplo q) {
        String op = q.getOperador();
        String a1 = q.getArgumento1();
        String a2 = q.getArgumento2();
        String r = q.getResultado();

        switch (op) {
            case "DECL", "PARAM", "ERROR_C3D" -> {
                // No genera instrucciones operativas
            }
            case "+" -> traducirSuma(f, a1, a2, r);
            case "-" -> traducirResta(f, a1, a2, r);
            case "*" -> traducirAritmetica(f, a1, a2, r, "fmul.d");
            case "/" -> traducirAritmetica(f, a1, a2, r, "fdiv.d");
            case "DIV_INT" -> traducirDivisionEntera(f, a1, a2, r);
            case "%" -> traducirModulo(f, a1, a2, r);
            case "<", ">", "<=", ">=", "==", "!=" ->
                traducirComparacion(f, op, a1, a2, r);
            case "&&", "||" -> traducirLogica(f, op, a1, a2, r);
            case "!", "non" -> traducirNot(f, a1, r);
            case "=" -> {
                cargarNumero(f, a1, "ft0");
                guardarNumero(f, r, "ft0");
            }
            case "STACK_SET" -> {
                cargarDireccion(f, r, "t0");
                cargarNumero(f, a1, "ft0");
                linea("fsd ft0, 0(t0)");
            }
            case "STACK_GET" -> {
                cargarDireccion(f, a1, "t0");
                linea("fld ft0, 0(t0)");
                guardarNumero(f, r, "ft0");
            }
            case "HEAP_SET" -> {
                cargarDireccionHeap(f, r, "t0");
                cargarNumero(f, a1, "ft0");
                linea("fsd ft0, 0(t0)");
            }
            case "HEAP_GET" -> {
                cargarDireccionHeap(f, a1, "t0");
                linea("fld ft0, 0(t0)");
                guardarNumero(f, r, "ft0");
            }
            case "PRINT", "PRINTLN" -> {
                cargarNumero(f, a1, "ft0");
                linea("fcvt.w.d a0, ft0");
                linea("li a7, 1");
                linea("ecall");
                if ("PRINTLN".equals(op)) {
                    linea("la a0, salto_linea");
                    linea("li a7, 4");
                    linea("ecall");
                }
            }
            case "PRINT_DOUBLE", "PRINTLN_DOUBLE" -> {
                cargarNumero(f, a1, "fa0");
                linea("li a7, 3");
                linea("ecall");
                if ("PRINTLN_DOUBLE".equals(op)) {
                    linea("la a0, salto_linea");
                    linea("li a7, 4");
                    linea("ecall");
                }
            }
            case "PRINT_CHAR", "PRINTLN_CHAR" -> {
                cargarNumero(f, a1, "ft0");
                linea("fcvt.w.d a0, ft0");
                linea("li a7, 11");
                linea("ecall");
                if ("PRINTLN_CHAR".equals(op)) {
                    linea("la a0, salto_linea");
                    linea("li a7, 4");
                    linea("ecall");
                }
            }
            case "PRINT_STRING", "PRINTLN_STRING" -> {
                cargarNumero(f, a1, "ft0");
                linea("fcvt.w.d a0, ft0");
                linea("jal ra, imprimir_cadena");
                if ("PRINTLN_STRING".equals(op)) {
                    linea("la a0, salto_linea");
                    linea("li a7, 4");
                    linea("ecall");
                }
            }
            case "READ_INT" -> {
                emitirSolicitudEntrada("int");
                linea("li a7, 5");
                linea("ecall");
                linea("fcvt.d.w ft0, a0");
                guardarNumero(f, r, "ft0");
            }
            case "READ_DOUBLE" -> {
                emitirSolicitudEntrada("double");
                linea("li a7, 7");
                linea("ecall");
                guardarNumero(f, r, "fa0");
            }
            case "READ_CHAR" -> {
                emitirSolicitudEntrada("char");
                linea("li a7, 12");
                linea("ecall");
                linea("fcvt.d.w ft0, a0");
                guardarNumero(f, r, "ft0");
            }
            case "READ_BOOL" -> {
                emitirSolicitudEntrada("bool");
                linea("li a7, 5");
                linea("ecall");
                linea("snez t0, a0");
                linea("fcvt.d.w ft0, t0");
                guardarNumero(f, r, "ft0");
            }
            case "READLN" -> {
                emitirSolicitudEntrada("text");
                linea("jal ra, leer_cadena");
                linea("fcvt.d.w ft0, a0");
                guardarNumero(f, r, "ft0");
            }
            case "INT_TO_STRING", "DOUBLE_TO_STRING",
                    "BOOL_TO_STRING", "CHAR_TO_STRING" -> {
                cargarNumero(f, a1, "fa0");
                String rutina = switch (op) {
                    case "INT_TO_STRING" -> "entero_a_cadena";
                    case "DOUBLE_TO_STRING" -> "decimal_a_cadena";
                    case "BOOL_TO_STRING" -> "booleano_a_cadena";
                    default -> "caracter_a_cadena";
                };
                linea("jal ra, " + rutina);
                linea("fcvt.d.w ft0, a0");
                guardarNumero(f, r, "ft0");
            }
            case "LABEL" -> salida.append(etiqueta(f, r)).append(":\n");
            case "GOTO" -> linea("j " + etiqueta(f, r));
            case "IF_FALSE", "IF_TRUE" -> {
                cargarNumero(f, a1, "ft0");
                linea("fcvt.w.d t0, ft0");
                emitirRamaLarga(
                        "IF_TRUE".equals(op),
                        "t0",
                        etiqueta(f, r)
                );
            }
            case "CALL" -> traducirLlamada(f, a1, a2);
            case "RETURN" -> linea("j .L_fin_" + sanitizar(f.nombre));
            default -> throw new IllegalStateException(
                    "Operacion RISC-V no implementada: " + op
            );
        }
    }

    private void traducirSuma(Funcion f, String a1, String a2, String r) {
        if ("H".equals(a1) && "H".equals(r) && esEntero(a2)) {
            emitirSumaInmediata("s2", "s2", Integer.parseInt(a2));
            return;
        }

        if ("P".equals(a1) && "P".equals(r) && esEntero(a2)) {
            f.desplazamientoP += Integer.parseInt(a2);
            return;
        }

        if ("P".equals(a1) && esEntero(a2)) {
            int desplazamiento = (f.desplazamientoP
                    + Integer.parseInt(a2)) * TAM_CELDA;
            emitirSumaInmediata("t0", "s0", desplazamiento);
            guardarDireccion(f, r, "t0");
            return;
        }

        if (f.temporalesDireccion.contains(a1) && esEntero(a2)) {
            cargarDireccion(f, a1, "t0");
            emitirSumaInmediata(
                    "t0", "t0", Integer.parseInt(a2) * TAM_CELDA);
            guardarDireccion(f, r, "t0");
            return;
        }

        if (f.temporalesCadena.contains(r)
                && f.temporalesCadena.contains(a1)
                && f.temporalesCadena.contains(a2)
                && !esLiteralNumerico(a1)
                && !esLiteralNumerico(a2)
                && !Funcion.esIncrementoDePuntero(a1, a2, r)) {
            cargarNumero(f, a1, "ft0");
            cargarNumero(f, a2, "ft1");
            linea("fcvt.w.d a0, ft0");
            linea("fcvt.w.d a1, ft1");
            linea("jal ra, concatenar_cadenas");
            linea("fcvt.d.w ft0, a0");
            guardarNumero(f, r, "ft0");
            return;
        }

        cargarNumero(f, a1, "ft0");
        cargarNumero(f, a2, "ft1");
        linea("fadd.d ft2, ft0, ft1");
        guardarNumero(f, r, "ft2");
    }

    private void traducirResta(
            Funcion f,
            String a1,
            String a2,
            String resultado) {
        if ("P".equals(a1) && "P".equals(resultado) && esEntero(a2)) {
            f.desplazamientoP -= Integer.parseInt(a2);
            return;
        }

        cargarNumero(f, a1, "ft0");

        if (a2 == null || a2.isBlank() || "-".equals(a2)) {
            linea("fneg.d ft1, ft0");
            guardarNumero(f, resultado, "ft1");
            return;
        }

        cargarNumero(f, a2, "ft1");
        linea("fsub.d ft2, ft0, ft1");
        guardarNumero(f, resultado, "ft2");
    }

    private void traducirAritmetica(
            Funcion f,
            String a1,
            String a2,
            String resultado,
            String instruccion) {
        cargarNumero(f, a1, "ft0");
        cargarNumero(f, a2, "ft1");
        linea(instruccion + " ft2, ft0, ft1");
        guardarNumero(f, resultado, "ft2");
    }

    private void traducirModulo(
            Funcion f,
            String a1,
            String a2,
            String resultado) {
        cargarNumero(f, a1, "ft0");
        cargarNumero(f, a2, "ft1");
        linea("fcvt.w.d t0, ft0");
        linea("fcvt.w.d t1, ft1");
        linea("rem t2, t0, t1");
        linea("fcvt.d.w ft2, t2");
        guardarNumero(f, resultado, "ft2");
    }

    private void traducirDivisionEntera(
            Funcion f,
            String a1,
            String a2,
            String resultado) {
        cargarNumero(f, a1, "ft0");
        cargarNumero(f, a2, "ft1");
        linea("fcvt.w.d t0, ft0, rtz");
        linea("fcvt.w.d t1, ft1, rtz");
        linea("div t2, t0, t1");
        linea("fcvt.d.w ft2, t2");
        guardarNumero(f, resultado, "ft2");
    }

    private void traducirComparacion(
            Funcion f,
            String operador,
            String a1,
            String a2,
            String resultado) {
        cargarNumero(f, a1, "ft0");
        cargarNumero(f, a2, "ft1");

        switch (operador) {
            case "<" -> linea("flt.d t0, ft0, ft1");
            case ">" -> linea("flt.d t0, ft1, ft0");
            case "<=" -> linea("fle.d t0, ft0, ft1");
            case ">=" -> linea("fle.d t0, ft1, ft0");
            case "==" -> linea("feq.d t0, ft0, ft1");
            case "!=" -> {
                linea("feq.d t0, ft0, ft1");
                linea("xori t0, t0, 1");
            }
            default -> throw new IllegalStateException(
                    "Comparacion RISC-V no implementada: " + operador
            );
        }

        linea("fcvt.d.w ft2, t0");
        guardarNumero(f, resultado, "ft2");
    }

    private void traducirLogica(
            Funcion f,
            String operador,
            String a1,
            String a2,
            String resultado) {
        cargarNumero(f, a1, "ft0");
        cargarNumero(f, a2, "ft1");
        linea("fcvt.w.d t0, ft0");
        linea("fcvt.w.d t1, ft1");
        linea("snez t0, t0");
        linea("snez t1, t1");
        linea(("&&".equals(operador) ? "and" : "or")
                + " t2, t0, t1");
        linea("snez t2, t2");
        linea("fcvt.d.w ft2, t2");
        guardarNumero(f, resultado, "ft2");
    }

    private void traducirNot(
            Funcion f,
            String argumento,
            String resultado) {
        cargarNumero(f, argumento, "ft0");
        linea("fcvt.w.d t0, ft0");
        linea("seqz t0, t0");
        linea("fcvt.d.w ft1, t0");
        guardarNumero(f, resultado, "ft1");
    }

    private void traducirLlamada(
            Funcion f,
            String nombre,
            String cantidadTexto) {
        if (!funciones.containsKey(nombre)) {
            throw new IllegalStateException(
                    "Funcion RISC-V no encontrada: " + nombre
            );
        }

        int cantidad = esEntero(cantidadTexto)
                ? Integer.parseInt(cantidadTexto)
                : aridades.getOrDefault(nombre, 0);
        for (int i = 0; i < Math.min(cantidad, 8); i++) {
            int offset = (f.desplazamientoP + i + 1) * TAM_CELDA;
            emitirLoadDouble("fa" + i, "s0", offset);
        }

        int adicionales = Math.max(0, cantidad - 8);
        int espacioArgumentos = alinear16(adicionales * TAM_CELDA);
        if (espacioArgumentos > 0) {
            emitirSumaInmediata("sp", "sp", -espacioArgumentos);
            for (int i = 8; i < cantidad; i++) {
                int offset = (f.desplazamientoP + i + 1) * TAM_CELDA;
                emitirLoadDouble("ft0", "s0", offset);
                emitirStoreDouble("ft0", "sp", (i - 8) * TAM_CELDA);
            }
        }

        linea("jal ra, " + sanitizar(nombre));
        if (espacioArgumentos > 0) {
            emitirSumaInmediata("sp", "sp", espacioArgumentos);
        }
        emitirStoreDouble("fa0", "s0", f.desplazamientoP * TAM_CELDA);
    }

    private void cargarNumero(Funcion f, String valor, String registro) {
        if ("H".equals(valor)) {
            linea("fcvt.d.w " + registro + ", s2");
            return;
        }

        if (esEntero(valor)) {
            linea("li t6, " + normalizarInmediatoRv32(valor));
            linea("fcvt.d.w " + registro + ", t6");
            return;
        }

        Integer codigoCaracter = decodificarLiteralCaracter(valor);
        if (codigoCaracter != null) {
            linea("li t6, " + codigoCaracter);
            linea("fcvt.d.w " + registro + ", t6");
            return;
        }

        if (esDecimal(valor)) {
            String etiqueta = literalesDecimal.get(valor);
            linea("la t6, " + etiqueta);
            linea("fld " + registro + ", 0(t6)");
            return;
        }

        Integer offset = f.offsetTemporales.get(valor);
        if (offset == null || f.temporalesDireccion.contains(valor)) {
            throw new IllegalStateException(
                    "Se esperaba un valor numerico RISC-V y se encontro: " + valor
            );
        }
        emitirLoadDouble(registro, "s0", offset);
    }

    private void guardarNumero(Funcion f, String temporal, String registro) {
        if ("H".equals(temporal)) {
            linea("fcvt.w.d s2, " + registro);
            return;
        }

        Integer offset = f.offsetTemporales.get(temporal);
        if (offset == null) {
            throw new IllegalStateException("Temporal no registrado: " + temporal);
        }
        emitirStoreDouble(registro, "s0", offset);
    }

    private void cargarDireccion(Funcion f, String temporal, String registro) {
        Integer offset = f.offsetTemporales.get(temporal);
        if (offset == null || !f.temporalesDireccion.contains(temporal)) {
            throw new IllegalStateException(
                    "Se esperaba un temporal de direccion y se encontro: " + temporal
            );
        }
        emitirLoadWord(registro, "s0", offset);
    }

    private void guardarDireccion(Funcion f, String temporal, String registro) {
        Integer offset = f.offsetTemporales.get(temporal);
        if (offset == null) {
            throw new IllegalStateException("Temporal no registrado: " + temporal);
        }
        emitirStoreWord(registro, "s0", offset);
    }

    private void cargarDireccionHeap(
            Funcion f,
            String indice,
            String registro) {
        cargarNumero(f, indice, "ft3");
        linea("fcvt.w.d " + registro + ", ft3");
        linea("slli " + registro + ", " + registro + ", 3");
        linea("add " + registro + ", s1, " + registro);
    }

    private void emitirEpilogo(Funcion f) {
        String etiqueta = ".L_fin_" + sanitizar(f.nombre);
        if (!f.epilogoEmitido) {
            f.epilogoEmitido = true;
            salida.append(etiqueta).append(":\n");
            if (!"main_pig".equals(f.nombre)) {
                linea("fld fa0, 0(s0)");
            }
            emitirLoadWord("t0", "s0", f.tamanoMarco - 8);
            emitirLoadWord("ra", "s0", f.tamanoMarco - 4);
            linea("mv sp, s0");
            linea("mv s0, t0");
            emitirSumaInmediata("sp", "sp", f.tamanoMarco);
            linea("ret");
        } else {
            linea("j " + etiqueta);
        }
    }

    private void linea(String texto) {
        salida.append("    ").append(texto).append('\n');
    }

    private void emitirRamaLarga(
            boolean saltarSiVerdadero,
            String registro,
            String destino) {
        String continuar = ".L_rama_larga_" + contadorRamasLargas++;

        if (saltarSiVerdadero) {
            linea("beqz " + registro + ", " + continuar);
        } else {
            linea("bnez " + registro + ", " + continuar);
        }

        linea("j " + destino);
        salida.append(continuar).append(":\n");
    }

    private void emitirSumaInmediata(
            String destino,
            String base,
            int inmediato) {
        if (cabeInmediato12(inmediato)) {
            linea("addi " + destino + ", " + base + ", " + inmediato);
            return;
        }

        String auxiliar = elegirAuxiliar(destino, base);
        linea("li " + auxiliar + ", " + inmediato);
        linea("add " + destino + ", " + base + ", " + auxiliar);
    }

    private void emitirLoadDouble(
            String destino,
            String base,
            int offset) {
        if (cabeInmediato12(offset)) {
            linea("fld " + destino + ", " + offset + "(" + base + ")");
            return;
        }

        String auxiliar = elegirAuxiliar(base);
        linea("li " + auxiliar + ", " + offset);
        linea("add " + auxiliar + ", " + base + ", " + auxiliar);
        linea("fld " + destino + ", 0(" + auxiliar + ")");
    }

    private void emitirStoreDouble(
            String origen,
            String base,
            int offset) {
        if (cabeInmediato12(offset)) {
            linea("fsd " + origen + ", " + offset + "(" + base + ")");
            return;
        }

        String auxiliar = elegirAuxiliar(base);
        linea("li " + auxiliar + ", " + offset);
        linea("add " + auxiliar + ", " + base + ", " + auxiliar);
        linea("fsd " + origen + ", 0(" + auxiliar + ")");
    }

    private void emitirLoadWord(
            String destino,
            String base,
            int offset) {
        if (cabeInmediato12(offset)) {
            linea("lw " + destino + ", " + offset + "(" + base + ")");
            return;
        }

        String auxiliar = elegirAuxiliar(destino, base);
        linea("li " + auxiliar + ", " + offset);
        linea("add " + auxiliar + ", " + base + ", " + auxiliar);
        linea("lw " + destino + ", 0(" + auxiliar + ")");
    }

    private void emitirStoreWord(
            String origen,
            String base,
            int offset) {
        if (cabeInmediato12(offset)) {
            linea("sw " + origen + ", " + offset + "(" + base + ")");
            return;
        }

        String auxiliar = elegirAuxiliar(origen, base);
        linea("li " + auxiliar + ", " + offset);
        linea("add " + auxiliar + ", " + base + ", " + auxiliar);
        linea("sw " + origen + ", 0(" + auxiliar + ")");
    }

    private static boolean cabeInmediato12(int valor) {
        return valor >= -2048 && valor <= 2047;
    }

    private static String elegirAuxiliar(String... usados) {
        String[] candidatos = {"t6", "t5", "t4"};

        for (String candidato : candidatos) {
            boolean disponible = true;
            for (String usado : usados) {
                if (candidato.equals(usado)) {
                    disponible = false;
                    break;
                }
            }
            if (disponible) {
                return candidato;
            }
        }

        throw new IllegalStateException(
                "No existe un registro auxiliar disponible para formar la direccion."
        );
    }

    private void emitirSolicitudEntrada(String tipo) {
        linea("la a0, solicitud_" + tipo);
        linea("li a7, 4");
        linea("ecall");
    }

    private static boolean esEntero(String valor) {
        return valor != null && valor.matches("-?\\d+");
    }

    private static boolean esDecimal(String valor) {
        return valor != null
                && valor.matches("-?(?:\\d+\\.\\d*|\\d*\\.\\d+)(?:[eE][+-]?\\d+)?");
    }

    private static boolean esLiteralNumerico(String valor) {
        return esEntero(valor)
                || esDecimal(valor)
                || decodificarLiteralCaracter(valor) != null;
    }

    private static Integer decodificarLiteralCaracter(String valor) {
        if (valor == null
                || valor.length() < 3
                || valor.charAt(0) != '\''
                || valor.charAt(valor.length() - 1) != '\'') {
            return null;
        }

        String contenido = valor.substring(1, valor.length() - 1);
        if (contenido.length() == 1) {
            return (int) contenido.charAt(0);
        }

        if (!contenido.startsWith("\\")) {
            return null;
        }

        if (contenido.length() == 2) {
            return switch (contenido.charAt(1)) {
                case 'b' -> (int) '\b';
                case 't' -> (int) '\t';
                case 'n' -> (int) '\n';
                case 'f' -> (int) '\f';
                case 'r' -> (int) '\r';
                case '\"' -> (int) '\"';
                case '\'' -> (int) '\'';
                case '\\' -> (int) '\\';
                case '0' -> 0;
                default -> null;
            };
        }

        if (contenido.matches("\\\\u[0-9a-fA-F]{4}")) {
            return Integer.parseInt(contenido.substring(2), 16);
        }

        return null;
    }

    private void registrarDecimal(String valor) {
        if (esDecimal(valor)) {
            literalesDecimal.computeIfAbsent(
                    valor,
                    clave -> "decimal_riscv_" + literalesDecimal.size()
            );
        }
    }

    private static String normalizarInmediatoRv32(String valor) {
        long numero = Long.parseLong(valor);

        if (numero >= Integer.MIN_VALUE
                && numero <= Integer.MAX_VALUE) {
            return Long.toString(numero);
        }

        if (numero >= 0 && numero <= 0xFFFFFFFFL) {
            return Integer.toString((int) numero);
        }

        throw new IllegalStateException(
                "El inmediato no puede representarse en RV32: " + valor
        );
    }

    private static String sanitizar(String texto) {
        if (texto == null || texto.isBlank()) {
            return "anonimo";
        }
        return texto.replaceAll("[^A-Za-z0-9_]", "_");
    }

    private static String etiqueta(Funcion funcion, String nombre) {
        return ".L_" + sanitizar(funcion.nombre) + "_" + sanitizar(nombre);
    }

    private static int alinear16(int valor) {
        return ((valor + 15) / 16) * 16;
    }

    private static final class Funcion {

        private final String nombre;
        private final List<Cuadruplo> cuadruplos = new ArrayList<>();
        private final Set<String> temporales = new LinkedHashSet<>();
        private final Set<String> temporalesDireccion = new LinkedHashSet<>();
        private final Set<String> temporalesCadena = new LinkedHashSet<>();
        private final Map<String, Integer> offsetTemporales = new LinkedHashMap<>();
        private final Map<String, Integer> offsetDirecciones = new LinkedHashMap<>();
        private int maximoOffsetP;
        private int desplazamientoP;
        private int tamanoMarco;
        private boolean epilogoEmitido;
        private final boolean metodoZ;
        private int parametrosDeclarados;

        private Funcion(String nombre, boolean metodoZ) {
            this.nombre = nombre;
            this.metodoZ = metodoZ;
        }

        private void registrarTemporal(String valor) {
            if (valor != null && valor.matches("t\\d+")) {
                temporales.add(valor);
            }
        }

        private void prepararMarco() {
            analizarDirecciones();
            analizarCadenas();
            int parametros = parametrosDeclarados + (metodoZ ? 1 : 0);
            int ultimoOffset = Math.max(maximoOffsetP, parametros);
            int inicioTemporales = (ultimoOffset + 1) * TAM_CELDA;
            int cursor = inicioTemporales;
            for (String temporal : temporales) {
                offsetTemporales.put(temporal, cursor);
                cursor += TAM_CELDA;
            }
            tamanoMarco = alinear16(cursor + 8);
            desplazamientoP = 0;
        }

        private void analizarDirecciones() {
            int baseP = 0;
            Map<String, Integer> direcciones = new LinkedHashMap<>();

            for (Cuadruplo q : cuadruplos) {
                String op = q.getOperador();
                String a1 = q.getArgumento1();
                String a2 = q.getArgumento2();
                String resultado = q.getResultado();

                if ("+".equals(op) && "P".equals(a1)
                        && "P".equals(resultado) && esEntero(a2)) {
                    baseP += Integer.parseInt(a2);
                    maximoOffsetP = Math.max(maximoOffsetP, baseP);
                    continue;
                }

                if ("-".equals(op) && "P".equals(a1)
                        && "P".equals(resultado) && esEntero(a2)) {
                    baseP -= Integer.parseInt(a2);
                    continue;
                }

                if ("+".equals(op) && "P".equals(a1)
                        && esEntero(a2) && resultado != null) {
                    int offset = baseP + Integer.parseInt(a2);
                    direcciones.put(resultado, offset);
                    maximoOffsetP = Math.max(maximoOffsetP, offset);
                    continue;
                }

                if ("+".equals(op) && direcciones.containsKey(a1)
                        && esEntero(a2) && resultado != null) {
                    int offset = direcciones.get(a1) + Integer.parseInt(a2);
                    direcciones.put(resultado, offset);
                    maximoOffsetP = Math.max(maximoOffsetP, offset);
                }
            }

            temporalesDireccion.clear();
            temporalesDireccion.addAll(direcciones.keySet());
            offsetDirecciones.clear();
            offsetDirecciones.putAll(direcciones);
        }

        private void analizarCadenas() {
            Set<Integer> espaciosCadena = new LinkedHashSet<>();
            boolean cambio;

            do {
                cambio = false;

                for (Cuadruplo q : cuadruplos) {
                    String op = q.getOperador();
                    String a1 = q.getArgumento1();
                    String a2 = q.getArgumento2();
                    String resultado = q.getResultado();

                    if ("PRINT_STRING".equals(op)
                            || "PRINTLN_STRING".equals(op)) {
                        cambio |= temporalesCadena.add(a1);
                        continue;
                    }

                    if ("INT_TO_STRING".equals(op)
                            || "DOUBLE_TO_STRING".equals(op)
                            || "BOOL_TO_STRING".equals(op)
                            || "CHAR_TO_STRING".equals(op)) {
                        cambio |= temporalesCadena.add(resultado);
                        continue;
                    }

                    if ("STACK_SET".equals(op)) {
                        Integer offset = offsetDirecciones.get(resultado);
                        if (offset == null) {
                            continue;
                        }
                        if (temporalesCadena.contains(a1)) {
                            cambio |= espaciosCadena.add(offset);
                        }
                        if (espaciosCadena.contains(offset)) {
                            cambio |= temporalesCadena.add(a1);
                        }
                        continue;
                    }

                    if ("STACK_GET".equals(op)) {
                        Integer offset = offsetDirecciones.get(a1);
                        if (offset == null) {
                            continue;
                        }
                        if (temporalesCadena.contains(resultado)) {
                            cambio |= espaciosCadena.add(offset);
                        }
                        if (espaciosCadena.contains(offset)) {
                            cambio |= temporalesCadena.add(resultado);
                        }
                        continue;
                    }

                    if ("=".equals(op)) {
                        if (temporalesCadena.contains(resultado)) {
                            cambio |= temporalesCadena.add(a1);
                        }
                        if (temporalesCadena.contains(a1)) {
                            cambio |= temporalesCadena.add(resultado);
                        }
                        continue;
                    }

                    if ("+".equals(op)
                            && temporalesCadena.contains(resultado)
                            && !"P".equals(a1)
                            && !"H".equals(a1)
                            && !temporalesDireccion.contains(a1)
                            && !esLiteralNumerico(a1)
                            && !esLiteralNumerico(a2)
                            && !esIncrementoDePuntero(a1, a2, resultado)) {
                        cambio |= temporalesCadena.add(a1);
                        cambio |= temporalesCadena.add(a2);
                    }
                }
            } while (cambio);
        }

        private static boolean esIncrementoDePuntero(
                String argumento1,
                String argumento2,
                String resultado) {
            return argumento1 != null
                    && argumento1.equals(resultado)
                    && esEntero(argumento2);
        }
    }
}
