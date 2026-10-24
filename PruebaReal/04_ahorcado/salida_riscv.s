# Codigo RISC-V RV32 generado para RARS
# Puntero de stack en sp, frame pointer en s0 y heap en s1

.data
.align 3
decimal_riscv_0: .double 0.0
decimal_riscv_1: .double 100.0
heap_riscv: .space 1048576
salto_linea: .asciz "\n"

entrada_riscv: .space 1024

solicitud_int: .asciz "__RISC_INPUT__:INT\n"
solicitud_double: .asciz "__RISC_INPUT__:DOUBLE\n"
solicitud_char: .asciz "__RISC_INPUT__:CHAR\n"
solicitud_bool: .asciz "__RISC_INPUT__:BOOL\n"
solicitud_text: .asciz "__RISC_INPUT__:TEXT\n"

.text
.globl main
main:
    la s1, heap_riscv
    li s2, 0
    jal ra, main_pig
    li a7, 10
    ecall

imprimir_cadena:
    slli t0, a0, 3
    add t0, s1, t0
.L_imprimir_cadena_ciclo:
    fld ft0, 0(t0)
    fcvt.w.d t1, ft0
    li t2, -1
    beq t1, t2, .L_imprimir_cadena_fin
    mv a0, t1
    li a7, 11
    ecall
    addi t0, t0, 8
    j .L_imprimir_cadena_ciclo
.L_imprimir_cadena_fin:
    ret

concatenar_cadenas:
    mv t3, s2
    li t4, 0
.L_concatenar_seleccionar:
    beqz t4, .L_concatenar_primera
    mv t5, a1
    j .L_concatenar_preparar
.L_concatenar_primera:
    mv t5, a0
.L_concatenar_preparar:
    slli t0, t5, 3
    add t0, s1, t0
.L_concatenar_copiar:
    fld ft0, 0(t0)
    fcvt.w.d t1, ft0
    li t2, -1
    beq t1, t2, .L_concatenar_fin_fuente
    slli t2, s2, 3
    add t2, s1, t2
    fsd ft0, 0(t2)
    addi s2, s2, 1
    addi t0, t0, 8
    j .L_concatenar_copiar
.L_concatenar_fin_fuente:
    bnez t4, .L_concatenar_terminar
    li t4, 1
    j .L_concatenar_seleccionar
.L_concatenar_terminar:
    li t1, -1
    fcvt.d.w ft0, t1
    slli t2, s2, 3
    add t2, s1, t2
    fsd ft0, 0(t2)
    addi s2, s2, 1
    mv a0, t3
    ret

leer_cadena:
    la t0, entrada_riscv
    mv a0, t0
    li a1, 1024
    li a7, 8
    ecall
    mv t3, s2
.L_leer_cadena_copiar:
    lbu t1, 0(t0)
    beqz t1, .L_leer_cadena_fin
    li t4, 10
    beq t1, t4, .L_leer_cadena_fin
    li t4, 13
    beq t1, t4, .L_leer_cadena_fin
    fcvt.d.w ft0, t1
    slli t2, s2, 3
    add t2, s1, t2
    fsd ft0, 0(t2)
    addi s2, s2, 1
    addi t0, t0, 1
    j .L_leer_cadena_copiar
.L_leer_cadena_fin:
    li t1, -1
    fcvt.d.w ft0, t1
    slli t2, s2, 3
    add t2, s1, t2
    fsd ft0, 0(t2)
    addi s2, s2, 1
    mv a0, t3
    ret

entero_a_cadena:
    mv t3, s2
    fcvt.w.d t0, fa0, rtz
    bnez t0, .L_entero_no_cero
    li t2, 48
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    j .L_entero_terminar
.L_entero_no_cero:
    bgez t0, .L_entero_preparar
    li t2, 45
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    neg t0, t0
.L_entero_preparar:
    addi sp, sp, -32
    mv t1, sp
    li t4, 0
.L_entero_extraer:
    li t5, 10
    remu t2, t0, t5
    addi t2, t2, 48
    sb t2, 0(t1)
    addi t1, t1, 1
    addi t4, t4, 1
    divu t0, t0, t5
    bnez t0, .L_entero_extraer
.L_entero_copiar:
    addi t1, t1, -1
    lbu t2, 0(t1)
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    addi t4, t4, -1
    bnez t4, .L_entero_copiar
    addi sp, sp, 32
.L_entero_terminar:
    li t2, -1
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    mv a0, t3
    ret

decimal_a_cadena:
    addi sp, sp, -16
    sw ra, 12(sp)
    mv t3, s2
    fmv.d ft5, fa0
    fcvt.w.d t0, ft5, rtz
    bgez t0, .L_decimal_absoluto
    li t2, 45
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    fneg.d ft5, ft5
.L_decimal_absoluto:
    fcvt.w.d t0, ft5, rtz
    fcvt.d.w fa0, t0
    fsd ft5, 0(sp)
    sw t3, 8(sp)
    jal ra, entero_a_cadena
    fld ft5, 0(sp)
    lw t3, 8(sp)
    addi s2, s2, -1
    fcvt.w.d t0, ft5, rtz
    fcvt.d.w ft1, t0
    fsub.d ft2, ft5, ft1
    fcvt.w.d t1, ft2, rtz
    fcvt.d.w ft3, t1
    feq.d t1, ft2, ft3
    bnez t1, .L_decimal_terminar
    li t2, 46
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    li t4, 0
    li t0, 1
    fcvt.d.w ft3, t0
    li t0, 2000000
    fcvt.d.w ft4, t0
    fdiv.d ft3, ft3, ft4
    fadd.d ft2, ft2, ft3
    li t5, 10
    fcvt.d.w ft4, t5
.L_decimal_digitos:
    fmul.d ft2, ft2, ft4
    fcvt.w.d t2, ft2, rtz
    addi t6, t2, 48
    fcvt.d.w ft0, t6
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    fcvt.d.w ft1, t2
    fsub.d ft2, ft2, ft1
    addi t4, t4, 1
    li t5, 6
    blt t4, t5, .L_decimal_digitos
.L_decimal_recortar:
    addi t0, s2, -1
    slli t1, t0, 3
    add t1, s1, t1
    fld ft0, 0(t1)
    fcvt.w.d t2, ft0
    li t5, 48
    bne t2, t5, .L_decimal_terminar
    addi s2, s2, -1
    addi t4, t4, -1
    bnez t4, .L_decimal_recortar
.L_decimal_terminar:
    li t2, -1
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    mv a0, t3
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

booleano_a_cadena:
    mv t3, s2
    fcvt.w.d t0, fa0
    beqz t0, .L_booleano_falso
    li t2, 116
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    li t2, 114
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    li t2, 117
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    li t2, 101
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    j .L_booleano_terminar
.L_booleano_falso:
    li t2, 102
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    li t2, 97
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    li t2, 108
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    li t2, 115
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    li t2, 101
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
.L_booleano_terminar:
    li t2, -1
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    mv a0, t3
    ret

caracter_a_cadena:
    mv t3, s2
    fcvt.w.d t2, fa0
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    li t2, -1
    fcvt.d.w ft0, t2
    slli t5, s2, 3
    add t5, s1, t5
    fsd ft0, 0(t5)
    addi s2, s2, 1
    mv a0, t3
    ret

validarLetra:
    addi sp, sp, -96
    sw ra, 92(sp)
    sw s0, 88(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 16(s0)
    lw t0, 16(s0)
    fld ft0, 0(t0)
    fsd ft0, 24(s0)
    fld ft0, 24(s0)
    li t6, 97
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 32(s0)
    addi t0, s0, 8
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    fld ft0, 48(s0)
    li t6, 122
    fcvt.d.w ft1, t6
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 56(s0)
    fld ft0, 32(s0)
    fld ft1, 56(s0)
    fcvt.w.d t0, ft0
    fcvt.w.d t1, ft1
    snez t0, t0
    snez t1, t1
    or t2, t0, t1
    snez t2, t2
    fcvt.d.w ft2, t2
    fsd ft2, 64(s0)
    fld ft0, 64(s0)
    fcvt.w.d t0, ft0
    seqz t0, t0
    fcvt.d.w ft1, t0
    fsd ft1, 72(s0)
    addi t0, s0, 0
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 72(s0)
    fsd ft0, 0(t0)
    j .L_fin_validarLetra
.L_fin_validarLetra:
    fld fa0, 0(s0)
    lw t0, 88(s0)
    lw ra, 92(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 96
    ret

calcularPuntaje:
    addi sp, sp, -304
    sw ra, 300(sp)
    sw s0, 296(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fsd fa2, 24(s0)
    addi t0, s0, 8
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    fld ft0, 72(s0)
    li t6, 10
    fcvt.d.w ft1, t6
    fmul.d ft2, ft0, ft1
    fsd ft2, 80(s0)
    addi t0, s0, 32
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 80(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    fld ft0, 104(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    fmul.d ft2, ft0, ft1
    fsd ft2, 112(s0)
    addi t0, s0, 40
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 112(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 48
    sw t0, 128(s0)
    lw t0, 128(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 0(t0)
    fsd ft0, 144(s0)
    fld ft0, 144(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 152(s0)
    fld ft0, 152(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_0
    j .L_calcularPuntaje_L2
.L_rama_larga_0:
    addi t0, s0, 48
    sw t0, 160(s0)
    lw t0, 160(s0)
    li t6, 50
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_calcularPuntaje_L1
.L_calcularPuntaje_L2:
.L_calcularPuntaje_L1:
    addi t0, s0, 32
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    addi t0, s0, 40
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    fld ft0, 176(s0)
    fld ft1, 192(s0)
    fsub.d ft2, ft0, ft1
    fsd ft2, 200(s0)
    addi t0, s0, 48
    sw t0, 208(s0)
    lw t0, 208(s0)
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    fld ft0, 200(s0)
    fld ft1, 216(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 224(s0)
    addi t0, s0, 56
    sw t0, 232(s0)
    lw t0, 232(s0)
    fld ft0, 224(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 56
    sw t0, 240(s0)
    lw t0, 240(s0)
    fld ft0, 0(t0)
    fsd ft0, 248(s0)
    fld ft0, 248(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 256(s0)
    fld ft0, 256(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_1
    j .L_calcularPuntaje_L4
.L_rama_larga_1:
    addi t0, s0, 56
    sw t0, 264(s0)
    lw t0, 264(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_calcularPuntaje_L3
.L_calcularPuntaje_L4:
.L_calcularPuntaje_L3:
    addi t0, s0, 56
    sw t0, 272(s0)
    lw t0, 272(s0)
    fld ft0, 0(t0)
    fsd ft0, 280(s0)
    addi t0, s0, 0
    sw t0, 288(s0)
    lw t0, 288(s0)
    fld ft0, 280(s0)
    fsd ft0, 0(t0)
    j .L_fin_calcularPuntaje
.L_fin_calcularPuntaje:
    fld fa0, 0(s0)
    lw t0, 296(s0)
    lw ra, 300(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 304
    ret

registrarResultado:
    addi sp, sp, -528
    sw ra, 524(sp)
    sw s0, 520(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fsd fa2, 24(s0)
    addi t0, s0, 8
    sw t0, 32(s0)
    lw t0, 32(s0)
    fld ft0, 0(t0)
    fsd ft0, 40(s0)
    fld ft0, 40(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 48(s0)
    fld ft3, 48(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    fld ft0, 56(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 64(s0)
    fld ft0, 64(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_2
    j .L_registrarResultado_L6
.L_rama_larga_2:
    addi t0, s0, 24
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    addi t0, s0, 8
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 0(t0)
    fsd ft0, 96(s0)
    fld ft0, 96(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 104(s0)
    fld ft3, 104(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    fld ft3, 112(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    fld ft0, 120(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 128(s0)
    fld ft0, 112(s0)
    fld ft1, 128(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 136(s0)
    addi t0, s0, 8
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    fld ft0, 152(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 160(s0)
    fld ft3, 160(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    fld ft0, 136(s0)
    fld ft1, 168(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 176(s0)
    fld ft3, 176(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 80(s0)
    fsd ft0, 0(t0)
    j .L_registrarResultado_L5
.L_registrarResultado_L6:
.L_registrarResultado_L5:
    addi t0, s0, 8
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    fld ft0, 192(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 200(s0)
    fld ft3, 200(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    fld ft0, 208(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    fld ft3, 200(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 216(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 232(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 240(s0)
    fld ft0, 240(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_3
    j .L_registrarResultado_L8
.L_rama_larga_3:
    addi t0, s0, 8
    sw t0, 248(s0)
    lw t0, 248(s0)
    fld ft0, 0(t0)
    fsd ft0, 256(s0)
    fld ft0, 256(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 264(s0)
    fld ft3, 264(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 272(s0)
    fld ft0, 272(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 280(s0)
    fld ft3, 264(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 280(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 288(s0)
    lw t0, 288(s0)
    fld ft0, 0(t0)
    fsd ft0, 296(s0)
    fld ft0, 296(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 304(s0)
    fld ft3, 304(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 312(s0)
    fld ft0, 312(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 320(s0)
    fld ft3, 304(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 320(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 328(s0)
    lw t0, 328(s0)
    fld ft0, 0(t0)
    fsd ft0, 336(s0)
    fld ft0, 336(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 344(s0)
    fld ft3, 344(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 352(s0)
    addi t0, s0, 8
    sw t0, 360(s0)
    lw t0, 360(s0)
    fld ft0, 0(t0)
    fsd ft0, 368(s0)
    fld ft0, 368(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 376(s0)
    fld ft3, 376(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 384(s0)
    fld ft0, 352(s0)
    fld ft1, 384(s0)
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 392(s0)
    fld ft0, 392(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_4
    j .L_registrarResultado_L10
.L_rama_larga_4:
    addi t0, s0, 8
    sw t0, 400(s0)
    lw t0, 400(s0)
    fld ft0, 0(t0)
    fsd ft0, 408(s0)
    fld ft0, 408(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 416(s0)
    fld ft3, 416(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 424(s0)
    addi t0, s0, 8
    sw t0, 432(s0)
    lw t0, 432(s0)
    fld ft0, 0(t0)
    fsd ft0, 440(s0)
    fld ft0, 440(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 448(s0)
    fld ft3, 448(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 424(s0)
    fsd ft0, 0(t0)
    j .L_registrarResultado_L9
.L_registrarResultado_L10:
.L_registrarResultado_L9:
    j .L_registrarResultado_L7
.L_registrarResultado_L8:
    addi t0, s0, 8
    sw t0, 456(s0)
    lw t0, 456(s0)
    fld ft0, 0(t0)
    fsd ft0, 464(s0)
    fld ft0, 464(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 472(s0)
    fld ft3, 472(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 480(s0)
    fld ft0, 480(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 488(s0)
    fld ft3, 472(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 488(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 496(s0)
    lw t0, 496(s0)
    fld ft0, 0(t0)
    fsd ft0, 504(s0)
    fld ft0, 504(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 512(s0)
    fld ft3, 512(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_registrarResultado_L7:
.L_fin_registrarResultado:
    fld fa0, 0(s0)
    lw t0, 520(s0)
    lw ra, 524(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 528
    ret

sumarPuntajes:
    addi sp, sp, -288
    sw ra, 284(sp)
    sw s0, 280(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 16
    sw t0, 32(s0)
    lw t0, 32(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 40(s0)
    lw t0, 40(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_sumarPuntajes_L11:
    addi t0, s0, 24
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    addi t0, s0, 8
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    fld ft0, 72(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 80(s0)
    fld ft3, 80(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
    fld ft0, 56(s0)
    fld ft1, 88(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 96(s0)
    fld ft0, 96(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_5
    j .L_sumarPuntajes_L13
.L_rama_larga_5:
    addi t0, s0, 16
    sw t0, 104(s0)
    lw t0, 104(s0)
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    addi t0, s0, 8
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    fld ft0, 128(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 136(s0)
    fld ft3, 136(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 144(s0)
    fld ft3, 144(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    fld ft0, 152(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 160(s0)
    fld ft0, 144(s0)
    fld ft1, 160(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 168(s0)
    addi t0, s0, 24
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 0(t0)
    fsd ft0, 184(s0)
    fld ft0, 168(s0)
    fld ft1, 184(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 192(s0)
    fld ft3, 192(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    fld ft0, 112(s0)
    fld ft1, 200(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 208(s0)
    addi t0, s0, 16
    sw t0, 216(s0)
    lw t0, 216(s0)
    fld ft0, 208(s0)
    fsd ft0, 0(t0)
.L_sumarPuntajes_L12:
    addi t0, s0, 24
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 232(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 240(s0)
    addi t0, s0, 24
    sw t0, 248(s0)
    lw t0, 248(s0)
    fld ft0, 240(s0)
    fsd ft0, 0(t0)
    j .L_sumarPuntajes_L11
.L_sumarPuntajes_L13:
    addi t0, s0, 16
    sw t0, 256(s0)
    lw t0, 256(s0)
    fld ft0, 0(t0)
    fsd ft0, 264(s0)
    addi t0, s0, 0
    sw t0, 272(s0)
    lw t0, 272(s0)
    fld ft0, 264(s0)
    fsd ft0, 0(t0)
    j .L_fin_sumarPuntajes
.L_fin_sumarPuntajes:
    fld fa0, 0(s0)
    lw t0, 280(s0)
    lw ra, 284(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 288
    ret

porcentajeVictorias:
    addi sp, sp, -160
    sw ra, 156(sp)
    sw s0, 152(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 16(s0)
    lw t0, 16(s0)
    fld ft0, 0(t0)
    fsd ft0, 24(s0)
    fld ft0, 24(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 32(s0)
    fld ft3, 32(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 40(s0)
    fld ft0, 40(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 48(s0)
    fld ft0, 48(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_6
    j .L_porcentajeVictorias_L15
.L_rama_larga_6:
    addi t0, s0, 0
    sw t0, 56(s0)
    lw t0, 56(s0)
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    j .L_fin_porcentajeVictorias
    j .L_porcentajeVictorias_L14
.L_porcentajeVictorias_L15:
.L_porcentajeVictorias_L14:
    addi t0, s0, 8
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    fld ft0, 72(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 80(s0)
    fld ft3, 80(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
    fld ft0, 88(s0)
    la t6, decimal_riscv_1
    fld ft1, 0(t6)
    fmul.d ft2, ft0, ft1
    fsd ft2, 96(s0)
    addi t0, s0, 8
    sw t0, 104(s0)
    lw t0, 104(s0)
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    fld ft0, 112(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 120(s0)
    fld ft3, 120(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    fld ft0, 96(s0)
    fld ft1, 128(s0)
    fdiv.d ft2, ft0, ft1
    fsd ft2, 136(s0)
    addi t0, s0, 0
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 136(s0)
    fsd ft0, 0(t0)
    j .L_fin_porcentajeVictorias
.L_fin_porcentajeVictorias:
    fld fa0, 0(s0)
    lw t0, 152(s0)
    lw ra, 156(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 160
    ret

titulo:
    addi sp, sp, -192
    sw ra, 188(sp)
    sw s0, 184(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 32(s0)
    lw t0, 32(s0)
    fld ft0, 0(t0)
    fsd ft0, 40(s0)
    fld ft0, 40(s0)
    li t6, 100
    fcvt.d.w ft1, t6
    fdiv.d ft2, ft0, ft1
    fsd ft2, 48(s0)
    addi t0, s0, 16
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 48(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 64(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 78
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 118
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 24
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 64(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
    fld ft0, 88(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 96(s0)
    fld ft0, 96(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_7
    j .L_titulo_L20
.L_rama_larga_7:
    j .L_titulo_L17
.L_titulo_L20:
    fld ft0, 88(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 104(s0)
    fld ft0, 104(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_8
    j .L_titulo_L21
.L_rama_larga_8:
    j .L_titulo_L18
.L_titulo_L21:
    j .L_titulo_L19
.L_titulo_L17:
    fcvt.d.w ft0, s2
    fsd ft0, 112(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 78
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 118
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 24
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 112(s0)
    fsd ft0, 0(t0)
    j .L_titulo_L16
.L_titulo_L18:
    fcvt.d.w ft0, s2
    fsd ft0, 128(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 65
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 112
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 122
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 24
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 128(s0)
    fsd ft0, 0(t0)
    j .L_titulo_L16
.L_titulo_L19:
    fcvt.d.w ft0, s2
    fsd ft0, 144(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 77
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 104
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 24
    sw t0, 152(s0)
    lw t0, 152(s0)
    fld ft0, 144(s0)
    fsd ft0, 0(t0)
    j .L_titulo_L16
.L_titulo_L16:
    addi t0, s0, 24
    sw t0, 160(s0)
    lw t0, 160(s0)
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    addi t0, s0, 0
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 168(s0)
    fsd ft0, 0(t0)
    j .L_fin_titulo
.L_fin_titulo:
    fld fa0, 0(s0)
    lw t0, 184(s0)
    lw ra, 188(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 192
    ret

mostrarMarcador:
    addi sp, sp, -928
    sw ra, 924(sp)
    sw s0, 920(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 32(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 77
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 65
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 82
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 67
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 65
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 68
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 79
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 82
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 32(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    fcvt.d.w ft0, s2
    fsd ft0, 40(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 80
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    fld ft0, 56(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 64(s0)
    fld ft3, 64(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    fld fa0, 72(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 80(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 88(s0)
    fld ft0, 40(s0)
    fsd ft0, 96(s0)
.L_mostrarMarcador_L22:
    fld ft3, 96(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    fld ft0, 104(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 112(s0)
    fld ft0, 112(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_9
    j .L_mostrarMarcador_L23
.L_rama_larga_9:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 104(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 96(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 96(s0)
    j .L_mostrarMarcador_L22
.L_mostrarMarcador_L23:
    fld ft0, 80(s0)
    fsd ft0, 120(s0)
.L_mostrarMarcador_L24:
    fld ft3, 120(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    fld ft0, 128(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 136(s0)
    fld ft0, 136(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_10
    j .L_mostrarMarcador_L25
.L_rama_larga_10:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 128(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 120(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 120(s0)
    j .L_mostrarMarcador_L24
.L_mostrarMarcador_L25:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 144(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 71
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 152(s0)
    fld ft0, 88(s0)
    fsd ft0, 160(s0)
.L_mostrarMarcador_L26:
    fld ft3, 160(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    fld ft0, 168(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 176(s0)
    fld ft0, 176(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_11
    j .L_mostrarMarcador_L27
.L_rama_larga_11:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 168(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 160(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 160(s0)
    j .L_mostrarMarcador_L26
.L_mostrarMarcador_L27:
    fld ft0, 144(s0)
    fsd ft0, 184(s0)
.L_mostrarMarcador_L28:
    fld ft3, 184(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    fld ft0, 192(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 200(s0)
    fld ft0, 200(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_12
    j .L_mostrarMarcador_L29
.L_rama_larga_12:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 192(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 184(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 184(s0)
    j .L_mostrarMarcador_L28
.L_mostrarMarcador_L29:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 208(s0)
    lw t0, 208(s0)
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    fld ft0, 216(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 224(s0)
    fld ft3, 224(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld fa0, 232(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 240(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 248(s0)
    fld ft0, 152(s0)
    fsd ft0, 256(s0)
.L_mostrarMarcador_L30:
    fld ft3, 256(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 264(s0)
    fld ft0, 264(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 272(s0)
    fld ft0, 272(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_13
    j .L_mostrarMarcador_L31
.L_rama_larga_13:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 264(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 256(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    j .L_mostrarMarcador_L30
.L_mostrarMarcador_L31:
    fld ft0, 240(s0)
    fsd ft0, 280(s0)
.L_mostrarMarcador_L32:
    fld ft3, 280(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 288(s0)
    fld ft0, 288(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 296(s0)
    fld ft0, 296(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_14
    j .L_mostrarMarcador_L33
.L_rama_larga_14:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 288(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 280(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 280(s0)
    j .L_mostrarMarcador_L32
.L_mostrarMarcador_L33:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 304(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 80
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 312(s0)
    fld ft0, 248(s0)
    fsd ft0, 320(s0)
.L_mostrarMarcador_L34:
    fld ft3, 320(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 328(s0)
    fld ft0, 328(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 336(s0)
    fld ft0, 336(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_15
    j .L_mostrarMarcador_L35
.L_rama_larga_15:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 328(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 320(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 320(s0)
    j .L_mostrarMarcador_L34
.L_mostrarMarcador_L35:
    fld ft0, 304(s0)
    fsd ft0, 344(s0)
.L_mostrarMarcador_L36:
    fld ft3, 344(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 352(s0)
    fld ft0, 352(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 360(s0)
    fld ft0, 360(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_16
    j .L_mostrarMarcador_L37
.L_rama_larga_16:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 352(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 344(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 344(s0)
    j .L_mostrarMarcador_L36
.L_mostrarMarcador_L37:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 368(s0)
    lw t0, 368(s0)
    fld ft0, 0(t0)
    fsd ft0, 376(s0)
    fld ft0, 376(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 384(s0)
    fld ft3, 384(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 392(s0)
    fld fa0, 392(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 400(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 408(s0)
    fld ft0, 312(s0)
    fsd ft0, 416(s0)
.L_mostrarMarcador_L38:
    fld ft3, 416(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 424(s0)
    fld ft0, 424(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 432(s0)
    fld ft0, 432(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_17
    j .L_mostrarMarcador_L39
.L_rama_larga_17:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 424(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 416(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 416(s0)
    j .L_mostrarMarcador_L38
.L_mostrarMarcador_L39:
    fld ft0, 400(s0)
    fsd ft0, 440(s0)
.L_mostrarMarcador_L40:
    fld ft3, 440(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 448(s0)
    fld ft0, 448(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 456(s0)
    fld ft0, 456(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_18
    j .L_mostrarMarcador_L41
.L_rama_larga_18:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 448(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 440(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 440(s0)
    j .L_mostrarMarcador_L40
.L_mostrarMarcador_L41:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 408(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    fcvt.d.w ft0, s2
    fsd ft0, 464(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 82
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 104
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 472(s0)
    lw t0, 472(s0)
    fld ft0, 0(t0)
    fsd ft0, 480(s0)
    fld ft0, 480(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 488(s0)
    fld ft3, 488(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 496(s0)
    fld fa0, 496(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 504(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 512(s0)
    fld ft0, 464(s0)
    fsd ft0, 520(s0)
.L_mostrarMarcador_L42:
    fld ft3, 520(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 528(s0)
    fld ft0, 528(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 536(s0)
    fld ft0, 536(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_19
    j .L_mostrarMarcador_L43
.L_rama_larga_19:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 528(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 520(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 520(s0)
    j .L_mostrarMarcador_L42
.L_mostrarMarcador_L43:
    fld ft0, 504(s0)
    fsd ft0, 544(s0)
.L_mostrarMarcador_L44:
    fld ft3, 544(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 552(s0)
    fld ft0, 552(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 560(s0)
    fld ft0, 560(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_20
    j .L_mostrarMarcador_L45
.L_rama_larga_20:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 552(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 544(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 544(s0)
    j .L_mostrarMarcador_L44
.L_mostrarMarcador_L45:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 568(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 77
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 106
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 104
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 576(s0)
    fld ft0, 512(s0)
    fsd ft0, 584(s0)
.L_mostrarMarcador_L46:
    fld ft3, 584(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 592(s0)
    fld ft0, 592(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 600(s0)
    fld ft0, 600(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_21
    j .L_mostrarMarcador_L47
.L_rama_larga_21:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 592(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 584(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 584(s0)
    j .L_mostrarMarcador_L46
.L_mostrarMarcador_L47:
    fld ft0, 568(s0)
    fsd ft0, 608(s0)
.L_mostrarMarcador_L48:
    fld ft3, 608(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 616(s0)
    fld ft0, 616(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 624(s0)
    fld ft0, 624(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_22
    j .L_mostrarMarcador_L49
.L_rama_larga_22:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 616(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 608(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 608(s0)
    j .L_mostrarMarcador_L48
.L_mostrarMarcador_L49:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 632(s0)
    lw t0, 632(s0)
    fld ft0, 0(t0)
    fsd ft0, 640(s0)
    fld ft0, 640(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 648(s0)
    fld ft3, 648(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 656(s0)
    fld fa0, 656(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 664(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 672(s0)
    fld ft0, 576(s0)
    fsd ft0, 680(s0)
.L_mostrarMarcador_L50:
    fld ft3, 680(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 688(s0)
    fld ft0, 688(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 696(s0)
    fld ft0, 696(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_23
    j .L_mostrarMarcador_L51
.L_rama_larga_23:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 688(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 680(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 680(s0)
    j .L_mostrarMarcador_L50
.L_mostrarMarcador_L51:
    fld ft0, 664(s0)
    fsd ft0, 704(s0)
.L_mostrarMarcador_L52:
    fld ft3, 704(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 712(s0)
    fld ft0, 712(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 720(s0)
    fld ft0, 720(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_24
    j .L_mostrarMarcador_L53
.L_rama_larga_24:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 712(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 704(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 704(s0)
    j .L_mostrarMarcador_L52
.L_mostrarMarcador_L53:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 672(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    fcvt.d.w ft0, s2
    fsd ft0, 728(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 86
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 736(s0)
    lw t0, 736(s0)
    fld ft0, 0(t0)
    fsd ft0, 744(s0)
    addi t0, s0, 16
    sw t0, 752(s0)
    lw t0, 752(s0)
    addi t0, t0, 8
    sw t0, 760(s0)
    lw t0, 760(s0)
    fld ft0, 744(s0)
    fsd ft0, 0(t0)
    fld fa0, 24(s0)
    jal ra, porcentajeVictorias
    fsd fa0, 16(s0)
    addi t0, s0, 16
    sw t0, 768(s0)
    lw t0, 768(s0)
    fld ft0, 0(t0)
    fsd ft0, 776(s0)
    fld fa0, 776(s0)
    jal ra, decimal_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 784(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 792(s0)
    fld ft0, 728(s0)
    fsd ft0, 800(s0)
.L_mostrarMarcador_L54:
    fld ft3, 800(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 808(s0)
    fld ft0, 808(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 816(s0)
    fld ft0, 816(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_25
    j .L_mostrarMarcador_L55
.L_rama_larga_25:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 808(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 800(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 800(s0)
    j .L_mostrarMarcador_L54
.L_mostrarMarcador_L55:
    fld ft0, 784(s0)
    fsd ft0, 824(s0)
.L_mostrarMarcador_L56:
    fld ft3, 824(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 832(s0)
    fld ft0, 832(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 840(s0)
    fld ft0, 840(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_26
    j .L_mostrarMarcador_L57
.L_rama_larga_26:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 832(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 824(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 824(s0)
    j .L_mostrarMarcador_L56
.L_mostrarMarcador_L57:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 848(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 37
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 856(s0)
    fld ft0, 792(s0)
    fsd ft0, 864(s0)
.L_mostrarMarcador_L58:
    fld ft3, 864(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 872(s0)
    fld ft0, 872(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 880(s0)
    fld ft0, 880(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_27
    j .L_mostrarMarcador_L59
.L_rama_larga_27:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 872(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 864(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 864(s0)
    j .L_mostrarMarcador_L58
.L_mostrarMarcador_L59:
    fld ft0, 848(s0)
    fsd ft0, 888(s0)
.L_mostrarMarcador_L60:
    fld ft3, 888(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 896(s0)
    fld ft0, 896(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 904(s0)
    fld ft0, 904(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_28
    j .L_mostrarMarcador_L61
.L_rama_larga_28:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 896(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 888(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 888(s0)
    j .L_mostrarMarcador_L60
.L_mostrarMarcador_L61:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 856(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
.L_fin_mostrarMarcador:
    fld fa0, 0(s0)
    lw t0, 920(s0)
    lw ra, 924(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 928
    ret

Palabra_int_String_:
    addi sp, sp, -272
    sw ra, 268(sp)
    sw s0, 264(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fsd fa2, 24(s0)
    addi t0, s0, 16
    sw t0, 32(s0)
    lw t0, 32(s0)
    fld ft0, 0(t0)
    fsd ft0, 40(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 48(s0)
    fld ft3, 48(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 48(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 56(s0)
    fld ft3, 56(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 40(s0)
    fsd ft0, 0(t0)
    fld ft0, 40(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 64(s0)
    fcvt.d.w ft0, s2
    fld ft1, 64(s0)
    fadd.d ft2, ft0, ft1
    fcvt.w.d s2, ft2
    addi t0, s0, 8
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    fld ft0, 80(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 88(s0)
    fld ft3, 88(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 48(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 112(s0)
    fld ft3, 112(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 112(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 120(s0)
    fld ft3, 120(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 104(s0)
    fsd ft0, 0(t0)
    fld ft0, 104(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 128(s0)
    fcvt.d.w ft0, s2
    fld ft1, 128(s0)
    fadd.d ft2, ft0, ft1
    fcvt.w.d s2, ft2
    addi t0, s0, 8
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 0(t0)
    fsd ft0, 144(s0)
    fld ft0, 144(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 152(s0)
    fld ft3, 152(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 112(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 160(s0)
    lw t0, 160(s0)
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    addi t0, s0, 8
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 0(t0)
    fsd ft0, 184(s0)
    fld ft0, 184(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 192(s0)
    fld ft3, 192(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 168(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    fld ft0, 208(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    fld ft3, 216(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    addi t0, s0, 8
    sw t0, 240(s0)
    lw t0, 240(s0)
    fld ft0, 0(t0)
    fsd ft0, 248(s0)
    fld ft0, 248(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    fld ft3, 256(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 232(s0)
    fsd ft0, 0(t0)
.L_fin_Palabra_int_String_:
    fld fa0, 0(s0)
    lw t0, 264(s0)
    lw ra, 268(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 272
    ret

Palabra_agregarLetra_char_:
    addi sp, sp, -320
    sw ra, 316(sp)
    sw s0, 312(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 8
    sw t0, 24(s0)
    lw t0, 24(s0)
    fld ft0, 0(t0)
    fsd ft0, 32(s0)
    fld ft0, 32(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 40(s0)
    fld ft3, 40(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    addi t0, s0, 8
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    fld ft0, 64(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 72(s0)
    fld ft3, 72(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    fld ft0, 48(s0)
    fld ft1, 80(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 88(s0)
    fld ft0, 88(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_29
    j .L_Palabra_agregarLetra_char__L2
.L_rama_larga_29:
    addi t0, s0, 8
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    fld ft0, 104(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 112(s0)
    fld ft3, 112(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    addi t0, s0, 8
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    fld ft0, 136(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    fld ft3, 144(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    fld ft0, 120(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 160(s0)
    fld ft0, 160(s0)
    fld ft1, 152(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 168(s0)
    addi t0, s0, 16
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 0(t0)
    fsd ft0, 184(s0)
    fld ft3, 168(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 184(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 192(s0)
    lw t0, 192(s0)
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    fld ft0, 200(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 208(s0)
    fld ft3, 208(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    addi t0, s0, 8
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 232(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 240(s0)
    fld ft3, 240(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 248(s0)
    fld ft0, 216(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    fld ft0, 256(s0)
    fld ft1, 248(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 264(s0)
    fld ft3, 264(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 272(s0)
    lw t0, 272(s0)
    fld ft0, 0(t0)
    fsd ft0, 280(s0)
    fld ft0, 280(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 288(s0)
    fld ft3, 288(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 296(s0)
    fld ft0, 296(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 304(s0)
    fld ft3, 288(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 304(s0)
    fsd ft0, 0(t0)
    j .L_Palabra_agregarLetra_char__L1
.L_Palabra_agregarLetra_char__L2:
.L_Palabra_agregarLetra_char__L1:
.L_fin_Palabra_agregarLetra_char_:
    fld fa0, 0(s0)
    lw t0, 312(s0)
    lw ra, 316(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 320
    ret

Palabra_contiene_char_:
    addi sp, sp, -256
    sw ra, 252(sp)
    sw s0, 248(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 24
    sw t0, 32(s0)
    lw t0, 32(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Palabra_contiene_char__L3:
    addi t0, s0, 24
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    addi t0, s0, 8
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    fld ft0, 64(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 72(s0)
    fld ft3, 72(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    fld ft0, 48(s0)
    fld ft1, 80(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 88(s0)
    fld ft0, 88(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_30
    j .L_Palabra_contiene_char__L5
.L_rama_larga_30:
    addi t0, s0, 8
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    fld ft0, 104(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 112(s0)
    fld ft3, 112(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    addi t0, s0, 24
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    fld ft0, 120(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    fld ft0, 144(s0)
    fld ft1, 136(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 152(s0)
    fld ft3, 152(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 160(s0)
    addi t0, s0, 16
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    fld ft0, 160(s0)
    fld ft1, 176(s0)
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 184(s0)
    fld ft0, 184(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_31
    j .L_Palabra_contiene_char__L7
.L_rama_larga_31:
    addi t0, s0, 0
    sw t0, 192(s0)
    lw t0, 192(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Palabra_contiene_char_
    j .L_Palabra_contiene_char__L6
.L_Palabra_contiene_char__L7:
.L_Palabra_contiene_char__L6:
.L_Palabra_contiene_char__L4:
    addi t0, s0, 24
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    fld ft0, 208(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    addi t0, s0, 24
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 216(s0)
    fsd ft0, 0(t0)
    j .L_Palabra_contiene_char__L3
.L_Palabra_contiene_char__L5:
    addi t0, s0, 0
    sw t0, 232(s0)
    lw t0, 232(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Palabra_contiene_char_
.L_fin_Palabra_contiene_char_:
    fld fa0, 0(s0)
    lw t0, 248(s0)
    lw ra, 252(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 256
    ret

Palabra_revelar_char_:
    addi sp, sp, -464
    sw ra, 460(sp)
    sw s0, 456(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 24
    sw t0, 40(s0)
    lw t0, 40(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 32
    sw t0, 48(s0)
    lw t0, 48(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Palabra_revelar_char__L8:
    addi t0, s0, 32
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    addi t0, s0, 8
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    fld ft0, 80(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 88(s0)
    fld ft3, 88(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 96(s0)
    fld ft0, 64(s0)
    fld ft1, 96(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 104(s0)
    fld ft0, 104(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_32
    j .L_Palabra_revelar_char__L10
.L_rama_larga_32:
    addi t0, s0, 8
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    fld ft0, 120(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 128(s0)
    fld ft3, 128(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    addi t0, s0, 32
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    fld ft0, 136(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 160(s0)
    fld ft0, 160(s0)
    fld ft1, 152(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 168(s0)
    fld ft3, 168(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    addi t0, s0, 16
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    fld ft0, 176(s0)
    fld ft1, 192(s0)
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 200(s0)
    fld ft0, 200(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_33
    j .L_Palabra_revelar_char__L13
.L_rama_larga_33:
    addi t0, s0, 8
    sw t0, 208(s0)
    lw t0, 208(s0)
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    fld ft0, 216(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 224(s0)
    fld ft3, 224(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    addi t0, s0, 32
    sw t0, 240(s0)
    lw t0, 240(s0)
    fld ft0, 0(t0)
    fsd ft0, 248(s0)
    fld ft0, 232(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    fld ft0, 256(s0)
    fld ft1, 248(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 264(s0)
    fld ft3, 264(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 272(s0)
    fld ft0, 272(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 280(s0)
    fld ft0, 280(s0)
    fsd ft0, 288(s0)
    j .L_Palabra_revelar_char__L14
.L_Palabra_revelar_char__L13:
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 288(s0)
.L_Palabra_revelar_char__L14:
    fld ft0, 288(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_34
    j .L_Palabra_revelar_char__L12
.L_rama_larga_34:
    addi t0, s0, 8
    sw t0, 296(s0)
    lw t0, 296(s0)
    fld ft0, 0(t0)
    fsd ft0, 304(s0)
    fld ft0, 304(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 312(s0)
    fld ft3, 312(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 320(s0)
    addi t0, s0, 32
    sw t0, 328(s0)
    lw t0, 328(s0)
    fld ft0, 0(t0)
    fsd ft0, 336(s0)
    fld ft0, 320(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 344(s0)
    fld ft0, 344(s0)
    fld ft1, 336(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 352(s0)
    fld ft3, 352(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 360(s0)
    lw t0, 360(s0)
    fld ft0, 0(t0)
    fsd ft0, 368(s0)
    fld ft0, 368(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 376(s0)
    addi t0, s0, 24
    sw t0, 384(s0)
    lw t0, 384(s0)
    fld ft0, 376(s0)
    fsd ft0, 0(t0)
    j .L_Palabra_revelar_char__L11
.L_Palabra_revelar_char__L12:
.L_Palabra_revelar_char__L11:
.L_Palabra_revelar_char__L9:
    addi t0, s0, 32
    sw t0, 392(s0)
    lw t0, 392(s0)
    fld ft0, 0(t0)
    fsd ft0, 400(s0)
    fld ft0, 400(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 408(s0)
    addi t0, s0, 32
    sw t0, 416(s0)
    lw t0, 416(s0)
    fld ft0, 408(s0)
    fsd ft0, 0(t0)
    j .L_Palabra_revelar_char__L8
.L_Palabra_revelar_char__L10:
    addi t0, s0, 24
    sw t0, 424(s0)
    lw t0, 424(s0)
    fld ft0, 0(t0)
    fsd ft0, 432(s0)
    addi t0, s0, 0
    sw t0, 440(s0)
    lw t0, 440(s0)
    fld ft0, 432(s0)
    fsd ft0, 0(t0)
    j .L_fin_Palabra_revelar_char_
.L_fin_Palabra_revelar_char_:
    fld fa0, 0(s0)
    lw t0, 456(s0)
    lw ra, 460(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 464
    ret

Palabra_estaCompleta__:
    addi sp, sp, -224
    sw ra, 220(sp)
    sw s0, 216(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 16
    sw t0, 24(s0)
    lw t0, 24(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Palabra_estaCompleta___L15:
    addi t0, s0, 16
    sw t0, 32(s0)
    lw t0, 32(s0)
    fld ft0, 0(t0)
    fsd ft0, 40(s0)
    addi t0, s0, 8
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    fld ft0, 56(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 64(s0)
    fld ft3, 64(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    fld ft0, 40(s0)
    fld ft1, 72(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 80(s0)
    fld ft0, 80(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_35
    j .L_Palabra_estaCompleta___L17
.L_rama_larga_35:
    addi t0, s0, 8
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 0(t0)
    fsd ft0, 96(s0)
    fld ft0, 96(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 104(s0)
    fld ft3, 104(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    addi t0, s0, 16
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    fld ft0, 112(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 136(s0)
    fld ft0, 136(s0)
    fld ft1, 128(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    fld ft3, 144(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    fld ft0, 152(s0)
    fcvt.w.d t0, ft0
    seqz t0, t0
    fcvt.d.w ft1, t0
    fsd ft1, 160(s0)
    fld ft0, 160(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_36
    j .L_Palabra_estaCompleta___L19
.L_rama_larga_36:
    addi t0, s0, 0
    sw t0, 168(s0)
    lw t0, 168(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Palabra_estaCompleta__
    j .L_Palabra_estaCompleta___L18
.L_Palabra_estaCompleta___L19:
.L_Palabra_estaCompleta___L18:
.L_Palabra_estaCompleta___L16:
    addi t0, s0, 16
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 0(t0)
    fsd ft0, 184(s0)
    fld ft0, 184(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 192(s0)
    addi t0, s0, 16
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 192(s0)
    fsd ft0, 0(t0)
    j .L_Palabra_estaCompleta___L15
.L_Palabra_estaCompleta___L17:
    addi t0, s0, 0
    sw t0, 208(s0)
    lw t0, 208(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Palabra_estaCompleta__
.L_fin_Palabra_estaCompleta__:
    fld fa0, 0(s0)
    lw t0, 216(s0)
    lw ra, 220(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 224
    ret

Palabra_revelarTodo__:
    addi sp, sp, -192
    sw ra, 188(sp)
    sw s0, 184(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 16
    sw t0, 24(s0)
    lw t0, 24(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Palabra_revelarTodo___L20:
    addi t0, s0, 16
    sw t0, 32(s0)
    lw t0, 32(s0)
    fld ft0, 0(t0)
    fsd ft0, 40(s0)
    addi t0, s0, 8
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    fld ft0, 56(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 64(s0)
    fld ft3, 64(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    fld ft0, 40(s0)
    fld ft1, 72(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 80(s0)
    fld ft0, 80(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_37
    j .L_Palabra_revelarTodo___L21
.L_rama_larga_37:
    addi t0, s0, 8
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 0(t0)
    fsd ft0, 96(s0)
    fld ft0, 96(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 104(s0)
    fld ft3, 104(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    addi t0, s0, 16
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    fld ft0, 112(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 136(s0)
    fld ft0, 136(s0)
    fld ft1, 128(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    fld ft3, 144(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 152(s0)
    lw t0, 152(s0)
    fld ft0, 0(t0)
    fsd ft0, 160(s0)
    fld ft0, 160(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 168(s0)
    addi t0, s0, 16
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 168(s0)
    fsd ft0, 0(t0)
    j .L_Palabra_revelarTodo___L20
.L_Palabra_revelarTodo___L21:
.L_fin_Palabra_revelarTodo__:
    fld fa0, 0(s0)
    lw t0, 184(s0)
    lw ra, 188(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 192
    ret

Palabra_imprimirProgreso__:
    addi sp, sp, -560
    sw ra, 556(sp)
    sw s0, 552(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 32(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 16
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 32(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 48(s0)
    lw t0, 48(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Palabra_imprimirProgreso___L22:
    addi t0, s0, 24
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    addi t0, s0, 8
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    fld ft0, 80(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 88(s0)
    fld ft3, 88(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 96(s0)
    fld ft0, 64(s0)
    fld ft1, 96(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 104(s0)
    fld ft0, 104(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_38
    j .L_Palabra_imprimirProgreso___L24
.L_rama_larga_38:
    addi t0, s0, 8
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    fld ft0, 120(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 128(s0)
    fld ft3, 128(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    addi t0, s0, 24
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    fld ft0, 136(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 160(s0)
    fld ft0, 160(s0)
    fld ft1, 152(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 168(s0)
    fld ft3, 168(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    fld ft0, 176(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_39
    j .L_Palabra_imprimirProgreso___L26
.L_rama_larga_39:
    addi t0, s0, 16
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    addi t0, s0, 8
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    fld ft0, 208(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    fld ft3, 216(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 224(s0)
    addi t0, s0, 24
    sw t0, 232(s0)
    lw t0, 232(s0)
    fld ft0, 0(t0)
    fsd ft0, 240(s0)
    fld ft0, 224(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 248(s0)
    fld ft0, 248(s0)
    fld ft1, 240(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    fld ft3, 256(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 264(s0)
    fld fa0, 264(s0)
    jal ra, caracter_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 272(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 280(s0)
    fld ft0, 192(s0)
    fsd ft0, 288(s0)
.L_Palabra_imprimirProgreso___L27:
    fld ft3, 288(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 296(s0)
    fld ft0, 296(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 304(s0)
    fld ft0, 304(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_40
    j .L_Palabra_imprimirProgreso___L28
.L_rama_larga_40:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 296(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 288(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 288(s0)
    j .L_Palabra_imprimirProgreso___L27
.L_Palabra_imprimirProgreso___L28:
    fld ft0, 272(s0)
    fsd ft0, 312(s0)
.L_Palabra_imprimirProgreso___L29:
    fld ft3, 312(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 320(s0)
    fld ft0, 320(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 328(s0)
    fld ft0, 328(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_41
    j .L_Palabra_imprimirProgreso___L30
.L_rama_larga_41:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 320(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 312(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 312(s0)
    j .L_Palabra_imprimirProgreso___L29
.L_Palabra_imprimirProgreso___L30:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 336(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 344(s0)
    fld ft0, 280(s0)
    fsd ft0, 352(s0)
.L_Palabra_imprimirProgreso___L31:
    fld ft3, 352(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 360(s0)
    fld ft0, 360(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 368(s0)
    fld ft0, 368(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_42
    j .L_Palabra_imprimirProgreso___L32
.L_rama_larga_42:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 360(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 352(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 352(s0)
    j .L_Palabra_imprimirProgreso___L31
.L_Palabra_imprimirProgreso___L32:
    fld ft0, 336(s0)
    fsd ft0, 376(s0)
.L_Palabra_imprimirProgreso___L33:
    fld ft3, 376(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 384(s0)
    fld ft0, 384(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 392(s0)
    fld ft0, 392(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_43
    j .L_Palabra_imprimirProgreso___L34
.L_rama_larga_43:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 384(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 376(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 376(s0)
    j .L_Palabra_imprimirProgreso___L33
.L_Palabra_imprimirProgreso___L34:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 16
    sw t0, 400(s0)
    lw t0, 400(s0)
    fld ft0, 344(s0)
    fsd ft0, 0(t0)
    j .L_Palabra_imprimirProgreso___L25
.L_Palabra_imprimirProgreso___L26:
    addi t0, s0, 16
    sw t0, 408(s0)
    lw t0, 408(s0)
    fld ft0, 0(t0)
    fsd ft0, 416(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 424(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 95
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 432(s0)
    fld ft0, 416(s0)
    fsd ft0, 440(s0)
.L_Palabra_imprimirProgreso___L35:
    fld ft3, 440(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 448(s0)
    fld ft0, 448(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 456(s0)
    fld ft0, 456(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_44
    j .L_Palabra_imprimirProgreso___L36
.L_rama_larga_44:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 448(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 440(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 440(s0)
    j .L_Palabra_imprimirProgreso___L35
.L_Palabra_imprimirProgreso___L36:
    fld ft0, 424(s0)
    fsd ft0, 464(s0)
.L_Palabra_imprimirProgreso___L37:
    fld ft3, 464(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 472(s0)
    fld ft0, 472(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 480(s0)
    fld ft0, 480(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_45
    j .L_Palabra_imprimirProgreso___L38
.L_rama_larga_45:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 472(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 464(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 464(s0)
    j .L_Palabra_imprimirProgreso___L37
.L_Palabra_imprimirProgreso___L38:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 16
    sw t0, 488(s0)
    lw t0, 488(s0)
    fld ft0, 432(s0)
    fsd ft0, 0(t0)
.L_Palabra_imprimirProgreso___L25:
.L_Palabra_imprimirProgreso___L23:
    addi t0, s0, 24
    sw t0, 496(s0)
    lw t0, 496(s0)
    fld ft0, 0(t0)
    fsd ft0, 504(s0)
    fld ft0, 504(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 512(s0)
    addi t0, s0, 24
    sw t0, 520(s0)
    lw t0, 520(s0)
    fld ft0, 512(s0)
    fsd ft0, 0(t0)
    j .L_Palabra_imprimirProgreso___L22
.L_Palabra_imprimirProgreso___L24:
    addi t0, s0, 16
    sw t0, 528(s0)
    lw t0, 528(s0)
    fld ft0, 0(t0)
    fsd ft0, 536(s0)
    fld ft0, 536(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
.L_fin_Palabra_imprimirProgreso__:
    fld fa0, 0(s0)
    lw t0, 552(s0)
    lw ra, 556(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 560
    ret

Diccionario__:
    addi sp, sp, -48
    sw ra, 44(sp)
    sw s0, 40(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 16(s0)
    lw t0, 16(s0)
    fld ft0, 0(t0)
    fsd ft0, 24(s0)
    fld ft0, 24(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 32(s0)
    fld ft3, 32(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 5
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_fin_Diccionario__:
    fld fa0, 0(s0)
    lw t0, 40(s0)
    lw ra, 44(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 48
    ret

Diccionario_obtener_int_:
    addi sp, sp, -2032
    sw ra, 2028(sp)
    sw s0, 2024(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 24
    sw t0, 64(s0)
    lw t0, 64(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    fld ft0, 80(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 88(s0)
    fld ft0, 88(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_46
    j .L_Diccionario_obtener_int__L46
.L_rama_larga_46:
    j .L_Diccionario_obtener_int__L39
.L_Diccionario_obtener_int__L46:
    fld ft0, 80(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 96(s0)
    fld ft0, 96(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_47
    j .L_Diccionario_obtener_int__L47
.L_rama_larga_47:
    j .L_Diccionario_obtener_int__L40
.L_Diccionario_obtener_int__L47:
    fld ft0, 80(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 104(s0)
    fld ft0, 104(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_48
    j .L_Diccionario_obtener_int__L48
.L_rama_larga_48:
    j .L_Diccionario_obtener_int__L41
.L_Diccionario_obtener_int__L48:
    fld ft0, 80(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 112(s0)
    fld ft0, 112(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_49
    j .L_Diccionario_obtener_int__L49
.L_rama_larga_49:
    j .L_Diccionario_obtener_int__L42
.L_Diccionario_obtener_int__L49:
    fld ft0, 80(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 120(s0)
    fld ft0, 120(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_50
    j .L_Diccionario_obtener_int__L50
.L_rama_larga_50:
    j .L_Diccionario_obtener_int__L43
.L_Diccionario_obtener_int__L50:
    j .L_Diccionario_obtener_int__L44
.L_Diccionario_obtener_int__L39:
    fcvt.d.w ft0, s2
    fsd ft0, 128(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 76
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 103
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 106
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 109
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 98
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 112
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 865605899
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 136(s0)
    addi s2, s2, 5
    addi t0, s0, 32
    sw t0, 144(s0)
    lw t0, 144(s0)
    addi t0, t0, 8
    sw t0, 152(s0)
    lw t0, 152(s0)
    fld ft0, 136(s0)
    fsd ft0, 0(t0)
    lw t0, 144(s0)
    addi t0, t0, 16
    sw t0, 160(s0)
    lw t0, 160(s0)
    li t6, 6
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 144(s0)
    addi t0, t0, 24
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 128(s0)
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    jal ra, Palabra_int_String_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 136(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    addi t0, s0, 32
    sw t0, 200(s0)
    lw t0, 200(s0)
    addi t0, t0, 8
    sw t0, 208(s0)
    lw t0, 208(s0)
    fld ft0, 192(s0)
    fsd ft0, 0(t0)
    lw t0, 200(s0)
    addi t0, t0, 16
    sw t0, 216(s0)
    lw t0, 216(s0)
    li t6, 112
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    addi t0, s0, 32
    sw t0, 240(s0)
    lw t0, 240(s0)
    addi t0, t0, 8
    sw t0, 248(s0)
    lw t0, 248(s0)
    fld ft0, 232(s0)
    fsd ft0, 0(t0)
    lw t0, 240(s0)
    addi t0, t0, 16
    sw t0, 256(s0)
    lw t0, 256(s0)
    li t6, 121
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 0(t0)
    fsd ft0, 272(s0)
    addi t0, s0, 32
    sw t0, 280(s0)
    lw t0, 280(s0)
    addi t0, t0, 8
    sw t0, 288(s0)
    lw t0, 288(s0)
    fld ft0, 272(s0)
    fsd ft0, 0(t0)
    lw t0, 280(s0)
    addi t0, t0, 16
    sw t0, 296(s0)
    lw t0, 296(s0)
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 304(s0)
    lw t0, 304(s0)
    fld ft0, 0(t0)
    fsd ft0, 312(s0)
    addi t0, s0, 32
    sw t0, 320(s0)
    lw t0, 320(s0)
    addi t0, t0, 8
    sw t0, 328(s0)
    lw t0, 328(s0)
    fld ft0, 312(s0)
    fsd ft0, 0(t0)
    lw t0, 320(s0)
    addi t0, t0, 16
    sw t0, 336(s0)
    lw t0, 336(s0)
    li t6, 104
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 344(s0)
    lw t0, 344(s0)
    fld ft0, 0(t0)
    fsd ft0, 352(s0)
    addi t0, s0, 32
    sw t0, 360(s0)
    lw t0, 360(s0)
    addi t0, t0, 8
    sw t0, 368(s0)
    lw t0, 368(s0)
    fld ft0, 352(s0)
    fsd ft0, 0(t0)
    lw t0, 360(s0)
    addi t0, t0, 16
    sw t0, 376(s0)
    lw t0, 376(s0)
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 384(s0)
    lw t0, 384(s0)
    fld ft0, 0(t0)
    fsd ft0, 392(s0)
    addi t0, s0, 32
    sw t0, 400(s0)
    lw t0, 400(s0)
    addi t0, t0, 8
    sw t0, 408(s0)
    lw t0, 408(s0)
    fld ft0, 392(s0)
    fsd ft0, 0(t0)
    lw t0, 400(s0)
    addi t0, t0, 16
    sw t0, 416(s0)
    lw t0, 416(s0)
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    j .L_Diccionario_obtener_int__L45
.L_Diccionario_obtener_int__L40:
    fcvt.d.w ft0, s2
    fsd ft0, 424(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 84
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 103
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 102
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 103
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 106
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 865605899
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 432(s0)
    addi s2, s2, 5
    addi t0, s0, 32
    sw t0, 440(s0)
    lw t0, 440(s0)
    addi t0, t0, 8
    sw t0, 448(s0)
    lw t0, 448(s0)
    fld ft0, 432(s0)
    fsd ft0, 0(t0)
    lw t0, 440(s0)
    addi t0, t0, 16
    sw t0, 456(s0)
    lw t0, 456(s0)
    li t6, 10
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 440(s0)
    addi t0, t0, 24
    sw t0, 464(s0)
    lw t0, 464(s0)
    fld ft0, 424(s0)
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    jal ra, Palabra_int_String_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 472(s0)
    lw t0, 472(s0)
    fld ft0, 432(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 480(s0)
    lw t0, 480(s0)
    fld ft0, 0(t0)
    fsd ft0, 488(s0)
    addi t0, s0, 32
    sw t0, 496(s0)
    lw t0, 496(s0)
    addi t0, t0, 8
    sw t0, 504(s0)
    lw t0, 504(s0)
    fld ft0, 488(s0)
    fsd ft0, 0(t0)
    lw t0, 496(s0)
    addi t0, t0, 16
    sw t0, 512(s0)
    lw t0, 512(s0)
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 520(s0)
    lw t0, 520(s0)
    fld ft0, 0(t0)
    fsd ft0, 528(s0)
    addi t0, s0, 32
    sw t0, 536(s0)
    lw t0, 536(s0)
    addi t0, t0, 8
    sw t0, 544(s0)
    lw t0, 544(s0)
    fld ft0, 528(s0)
    fsd ft0, 0(t0)
    lw t0, 536(s0)
    addi t0, t0, 16
    sw t0, 552(s0)
    lw t0, 552(s0)
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 560(s0)
    lw t0, 560(s0)
    fld ft0, 0(t0)
    fsd ft0, 568(s0)
    addi t0, s0, 32
    sw t0, 576(s0)
    lw t0, 576(s0)
    addi t0, t0, 8
    sw t0, 584(s0)
    lw t0, 584(s0)
    fld ft0, 568(s0)
    fsd ft0, 0(t0)
    lw t0, 576(s0)
    addi t0, t0, 16
    sw t0, 592(s0)
    lw t0, 592(s0)
    li t6, 109
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 600(s0)
    lw t0, 600(s0)
    fld ft0, 0(t0)
    fsd ft0, 608(s0)
    addi t0, s0, 32
    sw t0, 616(s0)
    lw t0, 616(s0)
    addi t0, t0, 8
    sw t0, 624(s0)
    lw t0, 624(s0)
    fld ft0, 608(s0)
    fsd ft0, 0(t0)
    lw t0, 616(s0)
    addi t0, t0, 16
    sw t0, 632(s0)
    lw t0, 632(s0)
    li t6, 112
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 640(s0)
    lw t0, 640(s0)
    fld ft0, 0(t0)
    fsd ft0, 648(s0)
    addi t0, s0, 32
    sw t0, 656(s0)
    lw t0, 656(s0)
    addi t0, t0, 8
    sw t0, 664(s0)
    lw t0, 664(s0)
    fld ft0, 648(s0)
    fsd ft0, 0(t0)
    lw t0, 656(s0)
    addi t0, t0, 16
    sw t0, 672(s0)
    lw t0, 672(s0)
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 680(s0)
    lw t0, 680(s0)
    fld ft0, 0(t0)
    fsd ft0, 688(s0)
    addi t0, s0, 32
    sw t0, 696(s0)
    lw t0, 696(s0)
    addi t0, t0, 8
    sw t0, 704(s0)
    lw t0, 704(s0)
    fld ft0, 688(s0)
    fsd ft0, 0(t0)
    lw t0, 696(s0)
    addi t0, t0, 16
    sw t0, 712(s0)
    lw t0, 712(s0)
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 720(s0)
    lw t0, 720(s0)
    fld ft0, 0(t0)
    fsd ft0, 728(s0)
    addi t0, s0, 32
    sw t0, 736(s0)
    lw t0, 736(s0)
    addi t0, t0, 8
    sw t0, 744(s0)
    lw t0, 744(s0)
    fld ft0, 728(s0)
    fsd ft0, 0(t0)
    lw t0, 736(s0)
    addi t0, t0, 16
    sw t0, 752(s0)
    lw t0, 752(s0)
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 760(s0)
    lw t0, 760(s0)
    fld ft0, 0(t0)
    fsd ft0, 768(s0)
    addi t0, s0, 32
    sw t0, 776(s0)
    lw t0, 776(s0)
    addi t0, t0, 8
    sw t0, 784(s0)
    lw t0, 784(s0)
    fld ft0, 768(s0)
    fsd ft0, 0(t0)
    lw t0, 776(s0)
    addi t0, t0, 16
    sw t0, 792(s0)
    lw t0, 792(s0)
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 800(s0)
    lw t0, 800(s0)
    fld ft0, 0(t0)
    fsd ft0, 808(s0)
    addi t0, s0, 32
    sw t0, 816(s0)
    lw t0, 816(s0)
    addi t0, t0, 8
    sw t0, 824(s0)
    lw t0, 824(s0)
    fld ft0, 808(s0)
    fsd ft0, 0(t0)
    lw t0, 816(s0)
    addi t0, t0, 16
    sw t0, 832(s0)
    lw t0, 832(s0)
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 840(s0)
    lw t0, 840(s0)
    fld ft0, 0(t0)
    fsd ft0, 848(s0)
    addi t0, s0, 32
    sw t0, 856(s0)
    lw t0, 856(s0)
    addi t0, t0, 8
    sw t0, 864(s0)
    lw t0, 864(s0)
    fld ft0, 848(s0)
    fsd ft0, 0(t0)
    lw t0, 856(s0)
    addi t0, t0, 16
    sw t0, 872(s0)
    lw t0, 872(s0)
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    j .L_Diccionario_obtener_int__L45
.L_Diccionario_obtener_int__L41:
    fcvt.d.w ft0, s2
    fsd ft0, 880(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 69
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 109
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 103
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 865605899
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 888(s0)
    addi s2, s2, 5
    addi t0, s0, 32
    sw t0, 896(s0)
    lw t0, 896(s0)
    addi t0, t0, 8
    sw t0, 904(s0)
    lw t0, 904(s0)
    fld ft0, 888(s0)
    fsd ft0, 0(t0)
    lw t0, 896(s0)
    addi t0, t0, 16
    sw t0, 912(s0)
    lw t0, 912(s0)
    li t6, 5
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 896(s0)
    addi t0, t0, 24
    sw t0, 920(s0)
    lw t0, 920(s0)
    fld ft0, 880(s0)
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    jal ra, Palabra_int_String_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 928(s0)
    lw t0, 928(s0)
    fld ft0, 888(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 936(s0)
    lw t0, 936(s0)
    fld ft0, 0(t0)
    fsd ft0, 944(s0)
    addi t0, s0, 32
    sw t0, 952(s0)
    lw t0, 952(s0)
    addi t0, t0, 8
    sw t0, 960(s0)
    lw t0, 960(s0)
    fld ft0, 944(s0)
    fsd ft0, 0(t0)
    lw t0, 952(s0)
    addi t0, t0, 16
    sw t0, 968(s0)
    lw t0, 968(s0)
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 976(s0)
    lw t0, 976(s0)
    fld ft0, 0(t0)
    fsd ft0, 984(s0)
    addi t0, s0, 32
    sw t0, 992(s0)
    lw t0, 992(s0)
    addi t0, t0, 8
    sw t0, 1000(s0)
    lw t0, 1000(s0)
    fld ft0, 984(s0)
    fsd ft0, 0(t0)
    lw t0, 992(s0)
    addi t0, t0, 16
    sw t0, 1008(s0)
    lw t0, 1008(s0)
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1016(s0)
    lw t0, 1016(s0)
    fld ft0, 0(t0)
    fsd ft0, 1024(s0)
    addi t0, s0, 32
    sw t0, 1032(s0)
    lw t0, 1032(s0)
    addi t0, t0, 8
    sw t0, 1040(s0)
    lw t0, 1040(s0)
    fld ft0, 1024(s0)
    fsd ft0, 0(t0)
    lw t0, 1032(s0)
    addi t0, t0, 16
    sw t0, 1048(s0)
    lw t0, 1048(s0)
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1056(s0)
    lw t0, 1056(s0)
    fld ft0, 0(t0)
    fsd ft0, 1064(s0)
    addi t0, s0, 32
    sw t0, 1072(s0)
    lw t0, 1072(s0)
    addi t0, t0, 8
    sw t0, 1080(s0)
    lw t0, 1080(s0)
    fld ft0, 1064(s0)
    fsd ft0, 0(t0)
    lw t0, 1072(s0)
    addi t0, t0, 16
    sw t0, 1088(s0)
    lw t0, 1088(s0)
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1096(s0)
    lw t0, 1096(s0)
    fld ft0, 0(t0)
    fsd ft0, 1104(s0)
    addi t0, s0, 32
    sw t0, 1112(s0)
    lw t0, 1112(s0)
    addi t0, t0, 8
    sw t0, 1120(s0)
    lw t0, 1120(s0)
    fld ft0, 1104(s0)
    fsd ft0, 0(t0)
    lw t0, 1112(s0)
    addi t0, t0, 16
    sw t0, 1128(s0)
    lw t0, 1128(s0)
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    j .L_Diccionario_obtener_int__L45
.L_Diccionario_obtener_int__L42:
    fcvt.d.w ft0, s2
    fsd ft0, 1136(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 67
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 118
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 122
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 865605899
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 1144(s0)
    addi s2, s2, 5
    addi t0, s0, 32
    sw t0, 1152(s0)
    lw t0, 1152(s0)
    addi t0, t0, 8
    sw t0, 1160(s0)
    lw t0, 1160(s0)
    fld ft0, 1144(s0)
    fsd ft0, 0(t0)
    lw t0, 1152(s0)
    addi t0, t0, 16
    sw t0, 1168(s0)
    lw t0, 1168(s0)
    li t6, 9
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1152(s0)
    addi t0, t0, 24
    sw t0, 1176(s0)
    lw t0, 1176(s0)
    fld ft0, 1136(s0)
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    jal ra, Palabra_int_String_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1184(s0)
    lw t0, 1184(s0)
    fld ft0, 1144(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 1192(s0)
    lw t0, 1192(s0)
    fld ft0, 0(t0)
    fsd ft0, 1200(s0)
    addi t0, s0, 32
    sw t0, 1208(s0)
    lw t0, 1208(s0)
    addi t0, t0, 8
    sw t0, 1216(s0)
    lw t0, 1216(s0)
    fld ft0, 1200(s0)
    fsd ft0, 0(t0)
    lw t0, 1208(s0)
    addi t0, t0, 16
    sw t0, 1224(s0)
    lw t0, 1224(s0)
    li t6, 122
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1232(s0)
    lw t0, 1232(s0)
    fld ft0, 0(t0)
    fsd ft0, 1240(s0)
    addi t0, s0, 32
    sw t0, 1248(s0)
    lw t0, 1248(s0)
    addi t0, t0, 8
    sw t0, 1256(s0)
    lw t0, 1256(s0)
    fld ft0, 1240(s0)
    fsd ft0, 0(t0)
    lw t0, 1248(s0)
    addi t0, t0, 16
    sw t0, 1264(s0)
    lw t0, 1264(s0)
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1272(s0)
    lw t0, 1272(s0)
    fld ft0, 0(t0)
    fsd ft0, 1280(s0)
    addi t0, s0, 32
    sw t0, 1288(s0)
    lw t0, 1288(s0)
    addi t0, t0, 8
    sw t0, 1296(s0)
    lw t0, 1296(s0)
    fld ft0, 1280(s0)
    fsd ft0, 0(t0)
    lw t0, 1288(s0)
    addi t0, t0, 16
    sw t0, 1304(s0)
    lw t0, 1304(s0)
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1312(s0)
    lw t0, 1312(s0)
    fld ft0, 0(t0)
    fsd ft0, 1320(s0)
    addi t0, s0, 32
    sw t0, 1328(s0)
    lw t0, 1328(s0)
    addi t0, t0, 8
    sw t0, 1336(s0)
    lw t0, 1336(s0)
    fld ft0, 1320(s0)
    fsd ft0, 0(t0)
    lw t0, 1328(s0)
    addi t0, t0, 16
    sw t0, 1344(s0)
    lw t0, 1344(s0)
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1352(s0)
    lw t0, 1352(s0)
    fld ft0, 0(t0)
    fsd ft0, 1360(s0)
    addi t0, s0, 32
    sw t0, 1368(s0)
    lw t0, 1368(s0)
    addi t0, t0, 8
    sw t0, 1376(s0)
    lw t0, 1376(s0)
    fld ft0, 1360(s0)
    fsd ft0, 0(t0)
    lw t0, 1368(s0)
    addi t0, t0, 16
    sw t0, 1384(s0)
    lw t0, 1384(s0)
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1392(s0)
    lw t0, 1392(s0)
    fld ft0, 0(t0)
    fsd ft0, 1400(s0)
    addi t0, s0, 32
    sw t0, 1408(s0)
    lw t0, 1408(s0)
    addi t0, t0, 8
    sw t0, 1416(s0)
    lw t0, 1416(s0)
    fld ft0, 1400(s0)
    fsd ft0, 0(t0)
    lw t0, 1408(s0)
    addi t0, t0, 16
    sw t0, 1424(s0)
    lw t0, 1424(s0)
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1432(s0)
    lw t0, 1432(s0)
    fld ft0, 0(t0)
    fsd ft0, 1440(s0)
    addi t0, s0, 32
    sw t0, 1448(s0)
    lw t0, 1448(s0)
    addi t0, t0, 8
    sw t0, 1456(s0)
    lw t0, 1456(s0)
    fld ft0, 1440(s0)
    fsd ft0, 0(t0)
    lw t0, 1448(s0)
    addi t0, t0, 16
    sw t0, 1464(s0)
    lw t0, 1464(s0)
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1472(s0)
    lw t0, 1472(s0)
    fld ft0, 0(t0)
    fsd ft0, 1480(s0)
    addi t0, s0, 32
    sw t0, 1488(s0)
    lw t0, 1488(s0)
    addi t0, t0, 8
    sw t0, 1496(s0)
    lw t0, 1496(s0)
    fld ft0, 1480(s0)
    fsd ft0, 0(t0)
    lw t0, 1488(s0)
    addi t0, t0, 16
    sw t0, 1504(s0)
    lw t0, 1504(s0)
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1512(s0)
    lw t0, 1512(s0)
    fld ft0, 0(t0)
    fsd ft0, 1520(s0)
    addi t0, s0, 32
    sw t0, 1528(s0)
    lw t0, 1528(s0)
    addi t0, t0, 8
    sw t0, 1536(s0)
    lw t0, 1536(s0)
    fld ft0, 1520(s0)
    fsd ft0, 0(t0)
    lw t0, 1528(s0)
    addi t0, t0, 16
    sw t0, 1544(s0)
    lw t0, 1544(s0)
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    j .L_Diccionario_obtener_int__L45
.L_Diccionario_obtener_int__L43:
    fcvt.d.w ft0, s2
    fsd ft0, 1552(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 67
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 103
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 109
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 106
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 98
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 865605899
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 1560(s0)
    addi s2, s2, 5
    addi t0, s0, 32
    sw t0, 1568(s0)
    lw t0, 1568(s0)
    addi t0, t0, 8
    sw t0, 1576(s0)
    lw t0, 1576(s0)
    fld ft0, 1560(s0)
    fsd ft0, 0(t0)
    lw t0, 1568(s0)
    addi t0, t0, 16
    sw t0, 1584(s0)
    lw t0, 1584(s0)
    li t6, 8
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1568(s0)
    addi t0, t0, 24
    sw t0, 1592(s0)
    lw t0, 1592(s0)
    fld ft0, 1552(s0)
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    jal ra, Palabra_int_String_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1600(s0)
    lw t0, 1600(s0)
    fld ft0, 1560(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 1608(s0)
    lw t0, 1608(s0)
    fld ft0, 0(t0)
    fsd ft0, 1616(s0)
    addi t0, s0, 32
    sw t0, 1624(s0)
    lw t0, 1624(s0)
    addi t0, t0, 8
    sw t0, 1632(s0)
    lw t0, 1632(s0)
    fld ft0, 1616(s0)
    fsd ft0, 0(t0)
    lw t0, 1624(s0)
    addi t0, t0, 16
    sw t0, 1640(s0)
    lw t0, 1640(s0)
    li t6, 98
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1648(s0)
    lw t0, 1648(s0)
    fld ft0, 0(t0)
    fsd ft0, 1656(s0)
    addi t0, s0, 32
    sw t0, 1664(s0)
    lw t0, 1664(s0)
    addi t0, t0, 8
    sw t0, 1672(s0)
    lw t0, 1672(s0)
    fld ft0, 1656(s0)
    fsd ft0, 0(t0)
    lw t0, 1664(s0)
    addi t0, t0, 16
    sw t0, 1680(s0)
    lw t0, 1680(s0)
    li t6, 121
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1688(s0)
    lw t0, 1688(s0)
    fld ft0, 0(t0)
    fsd ft0, 1696(s0)
    addi t0, s0, 32
    sw t0, 1704(s0)
    lw t0, 1704(s0)
    addi t0, t0, 8
    sw t0, 1712(s0)
    lw t0, 1712(s0)
    fld ft0, 1696(s0)
    fsd ft0, 0(t0)
    lw t0, 1704(s0)
    addi t0, t0, 16
    sw t0, 1720(s0)
    lw t0, 1720(s0)
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1728(s0)
    lw t0, 1728(s0)
    fld ft0, 0(t0)
    fsd ft0, 1736(s0)
    addi t0, s0, 32
    sw t0, 1744(s0)
    lw t0, 1744(s0)
    addi t0, t0, 8
    sw t0, 1752(s0)
    lw t0, 1752(s0)
    fld ft0, 1736(s0)
    fsd ft0, 0(t0)
    lw t0, 1744(s0)
    addi t0, t0, 16
    sw t0, 1760(s0)
    lw t0, 1760(s0)
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1768(s0)
    lw t0, 1768(s0)
    fld ft0, 0(t0)
    fsd ft0, 1776(s0)
    addi t0, s0, 32
    sw t0, 1784(s0)
    lw t0, 1784(s0)
    addi t0, t0, 8
    sw t0, 1792(s0)
    lw t0, 1792(s0)
    fld ft0, 1776(s0)
    fsd ft0, 0(t0)
    lw t0, 1784(s0)
    addi t0, t0, 16
    sw t0, 1800(s0)
    lw t0, 1800(s0)
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1808(s0)
    lw t0, 1808(s0)
    fld ft0, 0(t0)
    fsd ft0, 1816(s0)
    addi t0, s0, 32
    sw t0, 1824(s0)
    lw t0, 1824(s0)
    addi t0, t0, 8
    sw t0, 1832(s0)
    lw t0, 1832(s0)
    fld ft0, 1816(s0)
    fsd ft0, 0(t0)
    lw t0, 1824(s0)
    addi t0, t0, 16
    sw t0, 1840(s0)
    lw t0, 1840(s0)
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1848(s0)
    lw t0, 1848(s0)
    fld ft0, 0(t0)
    fsd ft0, 1856(s0)
    addi t0, s0, 32
    sw t0, 1864(s0)
    lw t0, 1864(s0)
    addi t0, t0, 8
    sw t0, 1872(s0)
    lw t0, 1872(s0)
    fld ft0, 1856(s0)
    fsd ft0, 0(t0)
    lw t0, 1864(s0)
    addi t0, t0, 16
    sw t0, 1880(s0)
    lw t0, 1880(s0)
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    addi t0, s0, 24
    sw t0, 1888(s0)
    lw t0, 1888(s0)
    fld ft0, 0(t0)
    fsd ft0, 1896(s0)
    addi t0, s0, 32
    sw t0, 1904(s0)
    lw t0, 1904(s0)
    addi t0, t0, 8
    sw t0, 1912(s0)
    lw t0, 1912(s0)
    fld ft0, 1896(s0)
    fsd ft0, 0(t0)
    lw t0, 1904(s0)
    addi t0, t0, 16
    sw t0, 1920(s0)
    lw t0, 1920(s0)
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Palabra_agregarLetra_char_
    fsd fa0, 32(s0)
    j .L_Diccionario_obtener_int__L45
.L_Diccionario_obtener_int__L44:
    fcvt.d.w ft0, s2
    fsd ft0, 1928(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 73
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 102
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 103
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 44
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 112
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 98
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 48
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1928(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 8
    sw t0, 1936(s0)
    lw t0, 1936(s0)
    fld ft0, 0(t0)
    fsd ft0, 1944(s0)
    addi t0, s0, 32
    sw t0, 1952(s0)
    lw t0, 1952(s0)
    addi t0, t0, 8
    sw t0, 1960(s0)
    lw t0, 1960(s0)
    fld ft0, 1944(s0)
    fsd ft0, 0(t0)
    lw t0, 1952(s0)
    addi t0, t0, 16
    sw t0, 1968(s0)
    lw t0, 1968(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    jal ra, Diccionario_obtener_int_
    fsd fa0, 32(s0)
    addi t0, s0, 32
    sw t0, 1976(s0)
    lw t0, 1976(s0)
    fld ft0, 0(t0)
    fsd ft0, 1984(s0)
    addi t0, s0, 24
    sw t0, 1992(s0)
    lw t0, 1992(s0)
    fld ft0, 1984(s0)
    fsd ft0, 0(t0)
    j .L_Diccionario_obtener_int__L45
.L_Diccionario_obtener_int__L45:
    addi t0, s0, 24
    sw t0, 2000(s0)
    lw t0, 2000(s0)
    fld ft0, 0(t0)
    fsd ft0, 2008(s0)
    addi t0, s0, 0
    sw t0, 2016(s0)
    lw t0, 2016(s0)
    fld ft0, 2008(s0)
    fsd ft0, 0(t0)
    j .L_fin_Diccionario_obtener_int_
.L_fin_Diccionario_obtener_int_:
    fld fa0, 0(s0)
    lw t0, 2024(s0)
    lw ra, 2028(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 2032
    ret

Ahorcado_Palabra_int_:
    addi sp, sp, -224
    sw ra, 220(sp)
    sw s0, 216(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fsd fa2, 24(s0)
    addi t0, s0, 16
    sw t0, 32(s0)
    lw t0, 32(s0)
    fld ft0, 0(t0)
    fsd ft0, 40(s0)
    addi t0, s0, 8
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    fld ft0, 56(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 64(s0)
    fld ft3, 64(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 40(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    addi t0, s0, 8
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 0(t0)
    fsd ft0, 96(s0)
    fld ft0, 96(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 104(s0)
    fld ft3, 104(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 80(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    fld ft0, 120(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 128(s0)
    fld ft3, 128(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 136(s0)
    fld ft3, 136(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 136(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    fld ft3, 144(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 40
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    li t6, 40
    fcvt.d.w ft0, t6
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 152(s0)
    fcvt.d.w ft0, s2
    fld ft1, 152(s0)
    fadd.d ft2, ft0, ft1
    fcvt.w.d s2, ft2
    addi t0, s0, 8
    sw t0, 160(s0)
    lw t0, 160(s0)
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    fld ft0, 168(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 176(s0)
    fld ft3, 176(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 136(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    fld ft0, 192(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 200(s0)
    fld ft3, 200(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_fin_Ahorcado_Palabra_int_:
    fld fa0, 0(s0)
    lw t0, 216(s0)
    lw ra, 220(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 224
    ret

Ahorcado_yaUsada_char_:
    addi sp, sp, -256
    sw ra, 252(sp)
    sw s0, 248(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 24
    sw t0, 32(s0)
    lw t0, 32(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Ahorcado_yaUsada_char__L51:
    addi t0, s0, 24
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    addi t0, s0, 8
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    fld ft0, 64(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 72(s0)
    fld ft3, 72(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    fld ft0, 48(s0)
    fld ft1, 80(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 88(s0)
    fld ft0, 88(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_51
    j .L_Ahorcado_yaUsada_char__L53
.L_rama_larga_51:
    addi t0, s0, 8
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    fld ft0, 104(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 112(s0)
    fld ft3, 112(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    addi t0, s0, 24
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    fld ft0, 120(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    fld ft0, 144(s0)
    fld ft1, 136(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 152(s0)
    fld ft3, 152(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 160(s0)
    addi t0, s0, 16
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    fld ft0, 160(s0)
    fld ft1, 176(s0)
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 184(s0)
    fld ft0, 184(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_52
    j .L_Ahorcado_yaUsada_char__L55
.L_rama_larga_52:
    addi t0, s0, 0
    sw t0, 192(s0)
    lw t0, 192(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Ahorcado_yaUsada_char_
    j .L_Ahorcado_yaUsada_char__L54
.L_Ahorcado_yaUsada_char__L55:
.L_Ahorcado_yaUsada_char__L54:
.L_Ahorcado_yaUsada_char__L52:
    addi t0, s0, 24
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    fld ft0, 208(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    addi t0, s0, 24
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 216(s0)
    fsd ft0, 0(t0)
    j .L_Ahorcado_yaUsada_char__L51
.L_Ahorcado_yaUsada_char__L53:
    addi t0, s0, 0
    sw t0, 232(s0)
    lw t0, 232(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Ahorcado_yaUsada_char_
.L_fin_Ahorcado_yaUsada_char_:
    fld fa0, 0(s0)
    lw t0, 248(s0)
    lw ra, 252(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 256
    ret

Ahorcado_intentar_char_:
    addi sp, sp, -544
    sw ra, 540(sp)
    sw s0, 536(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 8
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    addi t0, s0, 16
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    addi t0, s0, 24
    sw t0, 80(s0)
    lw t0, 80(s0)
    addi t0, t0, 8
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 56(s0)
    fsd ft0, 0(t0)
    lw t0, 80(s0)
    addi t0, t0, 16
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 72(s0)
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    fld fa1, 40(s0)
    jal ra, Ahorcado_yaUsada_char_
    fsd fa0, 24(s0)
    addi t0, s0, 24
    sw t0, 104(s0)
    lw t0, 104(s0)
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    fld ft0, 112(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_53
    j .L_Ahorcado_intentar_char__L57
.L_rama_larga_53:
    addi t0, s0, 0
    sw t0, 120(s0)
    lw t0, 120(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Ahorcado_intentar_char_
    j .L_Ahorcado_intentar_char__L56
.L_Ahorcado_intentar_char__L57:
.L_Ahorcado_intentar_char__L56:
    addi t0, s0, 8
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    fld ft0, 136(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    fld ft3, 144(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    fld ft0, 152(s0)
    li t6, 40
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 160(s0)
    fld ft0, 160(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_54
    j .L_Ahorcado_intentar_char__L59
.L_rama_larga_54:
    addi t0, s0, 8
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    fld ft0, 176(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 184(s0)
    fld ft3, 184(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    addi t0, s0, 8
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    fld ft0, 208(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    fld ft3, 216(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 224(s0)
    fld ft0, 192(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 232(s0)
    fld ft0, 232(s0)
    fld ft1, 224(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 240(s0)
    addi t0, s0, 16
    sw t0, 248(s0)
    lw t0, 248(s0)
    fld ft0, 0(t0)
    fsd ft0, 256(s0)
    fld ft3, 240(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 256(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 0(t0)
    fsd ft0, 272(s0)
    fld ft0, 272(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 280(s0)
    fld ft3, 280(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 288(s0)
    fld ft0, 288(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 296(s0)
    fld ft3, 280(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 296(s0)
    fsd ft0, 0(t0)
    j .L_Ahorcado_intentar_char__L58
.L_Ahorcado_intentar_char__L59:
.L_Ahorcado_intentar_char__L58:
    addi t0, s0, 8
    sw t0, 304(s0)
    lw t0, 304(s0)
    fld ft0, 0(t0)
    fsd ft0, 312(s0)
    fld ft0, 312(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 320(s0)
    fld ft3, 320(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 328(s0)
    addi t0, s0, 16
    sw t0, 336(s0)
    lw t0, 336(s0)
    fld ft0, 0(t0)
    fsd ft0, 344(s0)
    addi t0, s0, 24
    sw t0, 352(s0)
    lw t0, 352(s0)
    addi t0, t0, 8
    sw t0, 360(s0)
    lw t0, 360(s0)
    fld ft0, 328(s0)
    fsd ft0, 0(t0)
    lw t0, 352(s0)
    addi t0, t0, 16
    sw t0, 368(s0)
    lw t0, 368(s0)
    fld ft0, 344(s0)
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    fld fa1, 40(s0)
    jal ra, Palabra_contiene_char_
    fsd fa0, 24(s0)
    addi t0, s0, 24
    sw t0, 376(s0)
    lw t0, 376(s0)
    fld ft0, 0(t0)
    fsd ft0, 384(s0)
    fld ft0, 384(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_55
    j .L_Ahorcado_intentar_char__L61
.L_rama_larga_55:
    addi t0, s0, 8
    sw t0, 392(s0)
    lw t0, 392(s0)
    fld ft0, 0(t0)
    fsd ft0, 400(s0)
    fld ft0, 400(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 408(s0)
    fld ft3, 408(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 416(s0)
    addi t0, s0, 16
    sw t0, 424(s0)
    lw t0, 424(s0)
    fld ft0, 0(t0)
    fsd ft0, 432(s0)
    addi t0, s0, 24
    sw t0, 440(s0)
    lw t0, 440(s0)
    addi t0, t0, 8
    sw t0, 448(s0)
    lw t0, 448(s0)
    fld ft0, 416(s0)
    fsd ft0, 0(t0)
    lw t0, 440(s0)
    addi t0, t0, 16
    sw t0, 456(s0)
    lw t0, 456(s0)
    fld ft0, 432(s0)
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    fld fa1, 40(s0)
    jal ra, Palabra_revelar_char_
    fsd fa0, 24(s0)
    addi t0, s0, 24
    sw t0, 464(s0)
    lw t0, 464(s0)
    fld ft0, 0(t0)
    fsd ft0, 472(s0)
    addi t0, s0, 0
    sw t0, 480(s0)
    lw t0, 480(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Ahorcado_intentar_char_
    j .L_Ahorcado_intentar_char__L60
.L_Ahorcado_intentar_char__L61:
.L_Ahorcado_intentar_char__L60:
    addi t0, s0, 8
    sw t0, 488(s0)
    lw t0, 488(s0)
    fld ft0, 0(t0)
    fsd ft0, 496(s0)
    fld ft0, 496(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 504(s0)
    fld ft3, 504(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 512(s0)
    fld ft0, 512(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 520(s0)
    fld ft3, 504(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 520(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 0
    sw t0, 528(s0)
    lw t0, 528(s0)
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Ahorcado_intentar_char_
.L_fin_Ahorcado_intentar_char_:
    fld fa0, 0(s0)
    lw t0, 536(s0)
    lw ra, 540(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 544
    ret

Ahorcado_gano__:
    addi sp, sp, -112
    sw ra, 108(sp)
    sw s0, 104(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 32(s0)
    lw t0, 32(s0)
    fld ft0, 0(t0)
    fsd ft0, 40(s0)
    fld ft0, 40(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 48(s0)
    fld ft3, 48(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    addi t0, s0, 16
    sw t0, 64(s0)
    lw t0, 64(s0)
    addi t0, t0, 8
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 56(s0)
    fsd ft0, 0(t0)
    fld fa0, 24(s0)
    jal ra, Palabra_estaCompleta__
    fsd fa0, 16(s0)
    addi t0, s0, 16
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
    addi t0, s0, 0
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 88(s0)
    fsd ft0, 0(t0)
    j .L_fin_Ahorcado_gano__
.L_fin_Ahorcado_gano__:
    fld fa0, 0(s0)
    lw t0, 104(s0)
    lw ra, 108(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 112
    ret

Ahorcado_perdio__:
    addi sp, sp, -112
    sw ra, 108(sp)
    sw s0, 104(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 16(s0)
    lw t0, 16(s0)
    fld ft0, 0(t0)
    fsd ft0, 24(s0)
    fld ft0, 24(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 32(s0)
    fld ft3, 32(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 40(s0)
    addi t0, s0, 8
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    fld ft0, 56(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 64(s0)
    fld ft3, 64(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    fld ft0, 40(s0)
    fld ft1, 72(s0)
    fle.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 80(s0)
    addi t0, s0, 0
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 80(s0)
    fsd ft0, 0(t0)
    j .L_fin_Ahorcado_perdio__
.L_fin_Ahorcado_perdio__:
    fld fa0, 0(s0)
    lw t0, 104(s0)
    lw ra, 108(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 112
    ret

Ahorcado_terminoJuego__:
    addi sp, sp, -160
    sw ra, 156(sp)
    sw s0, 152(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 32(s0)
    lw t0, 32(s0)
    fld ft0, 0(t0)
    fsd ft0, 40(s0)
    addi t0, s0, 16
    sw t0, 48(s0)
    lw t0, 48(s0)
    addi t0, t0, 8
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 40(s0)
    fsd ft0, 0(t0)
    fld fa0, 24(s0)
    jal ra, Ahorcado_gano__
    fsd fa0, 16(s0)
    addi t0, s0, 16
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    fld ft0, 72(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_56
    j .L_Ahorcado_terminoJuego___L62
.L_rama_larga_56:
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 80(s0)
    j .L_Ahorcado_terminoJuego___L63
.L_Ahorcado_terminoJuego___L62:
    addi t0, s0, 8
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 0(t0)
    fsd ft0, 96(s0)
    addi t0, s0, 16
    sw t0, 104(s0)
    lw t0, 104(s0)
    addi t0, t0, 8
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 96(s0)
    fsd ft0, 0(t0)
    fld fa0, 24(s0)
    jal ra, Ahorcado_perdio__
    fsd fa0, 16(s0)
    addi t0, s0, 16
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    fld ft0, 128(s0)
    fsd ft0, 80(s0)
.L_Ahorcado_terminoJuego___L63:
    addi t0, s0, 0
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 80(s0)
    fsd ft0, 0(t0)
    j .L_fin_Ahorcado_terminoJuego__
.L_fin_Ahorcado_terminoJuego__:
    fld fa0, 0(s0)
    lw t0, 152(s0)
    lw ra, 156(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 160
    ret

Ahorcado_intentosRestantes__:
    addi sp, sp, -112
    sw ra, 108(sp)
    sw s0, 104(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 16(s0)
    lw t0, 16(s0)
    fld ft0, 0(t0)
    fsd ft0, 24(s0)
    fld ft0, 24(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 32(s0)
    fld ft3, 32(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 40(s0)
    addi t0, s0, 8
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    fld ft0, 56(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 64(s0)
    fld ft3, 64(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    fld ft0, 40(s0)
    fld ft1, 72(s0)
    fsub.d ft2, ft0, ft1
    fsd ft2, 80(s0)
    addi t0, s0, 0
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 80(s0)
    fsd ft0, 0(t0)
    j .L_fin_Ahorcado_intentosRestantes__
.L_fin_Ahorcado_intentosRestantes__:
    fld fa0, 0(s0)
    lw t0, 104(s0)
    lw ra, 108(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 112
    ret

Ahorcado_dibujar__:
    addi sp, sp, -512
    sw ra, 508(sp)
    sw s0, 504(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 40(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 16
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 40(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 56(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 24
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 56(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 72(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 32
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 72(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 0(t0)
    fsd ft0, 96(s0)
    fld ft0, 96(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 104(s0)
    fld ft3, 104(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    fld ft0, 112(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 120(s0)
    fld ft0, 120(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_57
    j .L_Ahorcado_dibujar___L65
.L_rama_larga_57:
    fcvt.d.w ft0, s2
    fsd ft0, 128(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 79
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 16
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 128(s0)
    fsd ft0, 0(t0)
    j .L_Ahorcado_dibujar___L64
.L_Ahorcado_dibujar___L65:
.L_Ahorcado_dibujar___L64:
    addi t0, s0, 8
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    fld ft0, 152(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 160(s0)
    fld ft3, 160(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    fld ft0, 168(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 176(s0)
    fld ft0, 176(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_58
    j .L_Ahorcado_dibujar___L67
.L_rama_larga_58:
    fcvt.d.w ft0, s2
    fsd ft0, 184(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 24
    sw t0, 192(s0)
    lw t0, 192(s0)
    fld ft0, 184(s0)
    fsd ft0, 0(t0)
    j .L_Ahorcado_dibujar___L66
.L_Ahorcado_dibujar___L67:
    addi t0, s0, 8
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    fld ft0, 208(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    fld ft3, 216(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 224(s0)
    fld ft0, 224(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 232(s0)
    fld ft0, 232(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_59
    j .L_Ahorcado_dibujar___L68
.L_rama_larga_59:
    fcvt.d.w ft0, s2
    fsd ft0, 240(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 24
    sw t0, 248(s0)
    lw t0, 248(s0)
    fld ft0, 240(s0)
    fsd ft0, 0(t0)
    j .L_Ahorcado_dibujar___L66
.L_Ahorcado_dibujar___L68:
    addi t0, s0, 8
    sw t0, 256(s0)
    lw t0, 256(s0)
    fld ft0, 0(t0)
    fsd ft0, 264(s0)
    fld ft0, 264(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 272(s0)
    fld ft3, 272(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 280(s0)
    fld ft0, 280(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 288(s0)
    fld ft0, 288(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_60
    j .L_Ahorcado_dibujar___L69
.L_rama_larga_60:
    fcvt.d.w ft0, s2
    fsd ft0, 296(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 24
    sw t0, 304(s0)
    lw t0, 304(s0)
    fld ft0, 296(s0)
    fsd ft0, 0(t0)
    j .L_Ahorcado_dibujar___L66
.L_Ahorcado_dibujar___L69:
.L_Ahorcado_dibujar___L66:
    addi t0, s0, 8
    sw t0, 312(s0)
    lw t0, 312(s0)
    fld ft0, 0(t0)
    fsd ft0, 320(s0)
    fld ft0, 320(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 328(s0)
    fld ft3, 328(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 336(s0)
    fld ft0, 336(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 344(s0)
    fld ft0, 344(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_61
    j .L_Ahorcado_dibujar___L71
.L_rama_larga_61:
    fcvt.d.w ft0, s2
    fsd ft0, 352(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 94
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 32
    sw t0, 360(s0)
    lw t0, 360(s0)
    fld ft0, 352(s0)
    fsd ft0, 0(t0)
    j .L_Ahorcado_dibujar___L70
.L_Ahorcado_dibujar___L71:
    addi t0, s0, 8
    sw t0, 368(s0)
    lw t0, 368(s0)
    fld ft0, 0(t0)
    fsd ft0, 376(s0)
    fld ft0, 376(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 384(s0)
    fld ft3, 384(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 392(s0)
    fld ft0, 392(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 400(s0)
    fld ft0, 400(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_62
    j .L_Ahorcado_dibujar___L72
.L_rama_larga_62:
    fcvt.d.w ft0, s2
    fsd ft0, 408(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 94
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 94
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 32
    sw t0, 416(s0)
    lw t0, 416(s0)
    fld ft0, 408(s0)
    fsd ft0, 0(t0)
    j .L_Ahorcado_dibujar___L70
.L_Ahorcado_dibujar___L72:
.L_Ahorcado_dibujar___L70:
    fcvt.d.w ft0, s2
    fsd ft0, 424(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 43
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 45
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 43
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 424(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 432(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 432(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 16
    sw t0, 440(s0)
    lw t0, 440(s0)
    fld ft0, 0(t0)
    fsd ft0, 448(s0)
    fld ft0, 448(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 24
    sw t0, 456(s0)
    lw t0, 456(s0)
    fld ft0, 0(t0)
    fsd ft0, 464(s0)
    fld ft0, 464(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 32
    sw t0, 472(s0)
    lw t0, 472(s0)
    fld ft0, 0(t0)
    fsd ft0, 480(s0)
    fld ft0, 480(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 488(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 488(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 496(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 496(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
.L_fin_Ahorcado_dibujar__:
    fld fa0, 0(s0)
    lw t0, 504(s0)
    lw ra, 508(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 512
    ret

Ahorcado_mostrarEstado__:
    addi sp, sp, -800
    sw ra, 796(sp)
    sw s0, 792(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 40(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 69
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    fld ft0, 56(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 64(s0)
    fld ft3, 64(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    fld fa0, 72(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 80(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 88(s0)
    fld ft0, 40(s0)
    fsd ft0, 96(s0)
.L_Ahorcado_mostrarEstado___L73:
    fld ft3, 96(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    fld ft0, 104(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 112(s0)
    fld ft0, 112(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_63
    j .L_Ahorcado_mostrarEstado___L74
.L_rama_larga_63:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 104(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 96(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 96(s0)
    j .L_Ahorcado_mostrarEstado___L73
.L_Ahorcado_mostrarEstado___L74:
    fld ft0, 80(s0)
    fsd ft0, 120(s0)
.L_Ahorcado_mostrarEstado___L75:
    fld ft3, 120(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    fld ft0, 128(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 136(s0)
    fld ft0, 136(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_64
    j .L_Ahorcado_mostrarEstado___L76
.L_rama_larga_64:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 128(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 120(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 120(s0)
    j .L_Ahorcado_mostrarEstado___L75
.L_Ahorcado_mostrarEstado___L76:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 144(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 47
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 152(s0)
    fld ft0, 88(s0)
    fsd ft0, 160(s0)
.L_Ahorcado_mostrarEstado___L77:
    fld ft3, 160(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    fld ft0, 168(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 176(s0)
    fld ft0, 176(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_65
    j .L_Ahorcado_mostrarEstado___L78
.L_rama_larga_65:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 168(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 160(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 160(s0)
    j .L_Ahorcado_mostrarEstado___L77
.L_Ahorcado_mostrarEstado___L78:
    fld ft0, 144(s0)
    fsd ft0, 184(s0)
.L_Ahorcado_mostrarEstado___L79:
    fld ft3, 184(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    fld ft0, 192(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 200(s0)
    fld ft0, 200(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_66
    j .L_Ahorcado_mostrarEstado___L80
.L_rama_larga_66:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 192(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 184(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 184(s0)
    j .L_Ahorcado_mostrarEstado___L79
.L_Ahorcado_mostrarEstado___L80:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 208(s0)
    lw t0, 208(s0)
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    fld ft0, 216(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 224(s0)
    fld ft3, 224(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld fa0, 232(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 240(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 248(s0)
    fld ft0, 152(s0)
    fsd ft0, 256(s0)
.L_Ahorcado_mostrarEstado___L81:
    fld ft3, 256(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 264(s0)
    fld ft0, 264(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 272(s0)
    fld ft0, 272(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_67
    j .L_Ahorcado_mostrarEstado___L82
.L_rama_larga_67:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 264(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 256(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    j .L_Ahorcado_mostrarEstado___L81
.L_Ahorcado_mostrarEstado___L82:
    fld ft0, 240(s0)
    fsd ft0, 280(s0)
.L_Ahorcado_mostrarEstado___L83:
    fld ft3, 280(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 288(s0)
    fld ft0, 288(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 296(s0)
    fld ft0, 296(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_68
    j .L_Ahorcado_mostrarEstado___L84
.L_rama_larga_68:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 288(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 280(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 280(s0)
    j .L_Ahorcado_mostrarEstado___L83
.L_Ahorcado_mostrarEstado___L84:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 304(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 124
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 73
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 312(s0)
    fld ft0, 248(s0)
    fsd ft0, 320(s0)
.L_Ahorcado_mostrarEstado___L85:
    fld ft3, 320(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 328(s0)
    fld ft0, 328(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 336(s0)
    fld ft0, 336(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_69
    j .L_Ahorcado_mostrarEstado___L86
.L_rama_larga_69:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 328(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 320(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 320(s0)
    j .L_Ahorcado_mostrarEstado___L85
.L_Ahorcado_mostrarEstado___L86:
    fld ft0, 304(s0)
    fsd ft0, 344(s0)
.L_Ahorcado_mostrarEstado___L87:
    fld ft3, 344(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 352(s0)
    fld ft0, 352(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 360(s0)
    fld ft0, 360(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_70
    j .L_Ahorcado_mostrarEstado___L88
.L_rama_larga_70:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 352(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 344(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 344(s0)
    j .L_Ahorcado_mostrarEstado___L87
.L_Ahorcado_mostrarEstado___L88:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 368(s0)
    lw t0, 368(s0)
    fld ft0, 0(t0)
    fsd ft0, 376(s0)
    addi t0, s0, 24
    sw t0, 384(s0)
    lw t0, 384(s0)
    addi t0, t0, 8
    sw t0, 392(s0)
    lw t0, 392(s0)
    fld ft0, 376(s0)
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    jal ra, Ahorcado_intentosRestantes__
    fsd fa0, 24(s0)
    addi t0, s0, 24
    sw t0, 400(s0)
    lw t0, 400(s0)
    fld ft0, 0(t0)
    fsd ft0, 408(s0)
    fld fa0, 408(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 416(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 424(s0)
    fld ft0, 312(s0)
    fsd ft0, 432(s0)
.L_Ahorcado_mostrarEstado___L89:
    fld ft3, 432(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 440(s0)
    fld ft0, 440(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 448(s0)
    fld ft0, 448(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_71
    j .L_Ahorcado_mostrarEstado___L90
.L_rama_larga_71:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 440(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 432(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 432(s0)
    j .L_Ahorcado_mostrarEstado___L89
.L_Ahorcado_mostrarEstado___L90:
    fld ft0, 416(s0)
    fsd ft0, 456(s0)
.L_Ahorcado_mostrarEstado___L91:
    fld ft3, 456(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 464(s0)
    fld ft0, 464(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 472(s0)
    fld ft0, 472(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_72
    j .L_Ahorcado_mostrarEstado___L92
.L_rama_larga_72:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 464(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 456(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 456(s0)
    j .L_Ahorcado_mostrarEstado___L91
.L_Ahorcado_mostrarEstado___L92:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 424(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 480(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 76
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 480(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    addi t0, s0, 16
    sw t0, 488(s0)
    lw t0, 488(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Ahorcado_mostrarEstado___L93:
    addi t0, s0, 16
    sw t0, 496(s0)
    lw t0, 496(s0)
    fld ft0, 0(t0)
    fsd ft0, 504(s0)
    addi t0, s0, 8
    sw t0, 512(s0)
    lw t0, 512(s0)
    fld ft0, 0(t0)
    fsd ft0, 520(s0)
    fld ft0, 520(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 528(s0)
    fld ft3, 528(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 536(s0)
    fld ft0, 504(s0)
    fld ft1, 536(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 544(s0)
    fld ft0, 544(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_73
    j .L_Ahorcado_mostrarEstado___L95
.L_rama_larga_73:
    addi t0, s0, 8
    sw t0, 552(s0)
    lw t0, 552(s0)
    fld ft0, 0(t0)
    fsd ft0, 560(s0)
    fld ft0, 560(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 568(s0)
    fld ft3, 568(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 576(s0)
    addi t0, s0, 16
    sw t0, 584(s0)
    lw t0, 584(s0)
    fld ft0, 0(t0)
    fsd ft0, 592(s0)
    fld ft0, 576(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 600(s0)
    fld ft0, 600(s0)
    fld ft1, 592(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 608(s0)
    fld ft3, 608(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 616(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 624(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld fa0, 616(s0)
    jal ra, caracter_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 632(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 640(s0)
    fld ft0, 632(s0)
    fsd ft0, 648(s0)
.L_Ahorcado_mostrarEstado___L96:
    fld ft3, 648(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 656(s0)
    fld ft0, 656(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 664(s0)
    fld ft0, 664(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_74
    j .L_Ahorcado_mostrarEstado___L97
.L_rama_larga_74:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 656(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 648(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 648(s0)
    j .L_Ahorcado_mostrarEstado___L96
.L_Ahorcado_mostrarEstado___L97:
    fld ft0, 624(s0)
    fsd ft0, 672(s0)
.L_Ahorcado_mostrarEstado___L98:
    fld ft3, 672(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 680(s0)
    fld ft0, 680(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 688(s0)
    fld ft0, 688(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_75
    j .L_Ahorcado_mostrarEstado___L99
.L_rama_larga_75:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 680(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 672(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 672(s0)
    j .L_Ahorcado_mostrarEstado___L98
.L_Ahorcado_mostrarEstado___L99:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 640(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
.L_Ahorcado_mostrarEstado___L94:
    addi t0, s0, 16
    sw t0, 696(s0)
    lw t0, 696(s0)
    fld ft0, 0(t0)
    fsd ft0, 704(s0)
    fld ft0, 704(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 712(s0)
    addi t0, s0, 16
    sw t0, 720(s0)
    lw t0, 720(s0)
    fld ft0, 712(s0)
    fsd ft0, 0(t0)
    j .L_Ahorcado_mostrarEstado___L93
.L_Ahorcado_mostrarEstado___L95:
    fcvt.d.w ft0, s2
    fsd ft0, 728(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 728(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 8
    sw t0, 736(s0)
    lw t0, 736(s0)
    fld ft0, 0(t0)
    fsd ft0, 744(s0)
    fld ft0, 744(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 752(s0)
    fld ft3, 752(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 760(s0)
    addi t0, s0, 24
    sw t0, 768(s0)
    lw t0, 768(s0)
    addi t0, t0, 8
    sw t0, 776(s0)
    lw t0, 776(s0)
    fld ft0, 760(s0)
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    jal ra, Palabra_imprimirProgreso__
    fsd fa0, 24(s0)
.L_fin_Ahorcado_mostrarEstado__:
    fld fa0, 0(s0)
    lw t0, 792(s0)
    lw ra, 796(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 800
    ret

main_pig:
    li t6, -2064
    add sp, sp, t6
    li t6, 2060
    add t6, sp, t6
    sw ra, 0(t6)
    li t6, 2056
    add t6, sp, t6
    sw s0, 0(t6)
    mv s0, sp
    addi t0, s0, 0
    sw t0, 136(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 144(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 74
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 103
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    lw t0, 136(s0)
    fld ft0, 144(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 152(s0)
    lw t0, 152(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 160(s0)
    lw t0, 160(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 168(s0)
    lw t0, 168(s0)
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 32
    sw t0, 176(s0)
    lw t0, 176(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 40
    sw t0, 184(s0)
    lw t0, 184(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 48
    sw t0, 192(s0)
    lw t0, 192(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 56
    sw t0, 200(s0)
    lw t0, 200(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 64
    sw t0, 208(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1216459334
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 216(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    lw t0, 208(s0)
    fld ft0, 216(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 104
    sw t0, 224(s0)
    lw t0, 224(s0)
    addi t0, t0, 8
    sw t0, 232(s0)
    lw t0, 232(s0)
    fld ft0, 216(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    jal ra, Diccionario__
    fsd fa0, 104(s0)
    addi t0, s0, 72
    sw t0, 240(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1584180013
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 248(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    lw t0, 240(s0)
    fld ft0, 248(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 64
    sw t0, 256(s0)
    lw t0, 256(s0)
    fld ft0, 0(t0)
    fsd ft0, 264(s0)
    addi t0, s0, 64
    sw t0, 272(s0)
    lw t0, 272(s0)
    fld ft0, 0(t0)
    fsd ft0, 280(s0)
    addi t0, s0, 104
    sw t0, 288(s0)
    lw t0, 288(s0)
    addi t0, t0, 8
    sw t0, 296(s0)
    lw t0, 296(s0)
    fld ft0, 280(s0)
    fsd ft0, 0(t0)
    lw t0, 288(s0)
    addi t0, t0, 16
    sw t0, 304(s0)
    lw t0, 304(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    fld fa1, 120(s0)
    jal ra, Diccionario_obtener_int_
    fsd fa0, 104(s0)
    addi t0, s0, 104
    sw t0, 312(s0)
    lw t0, 312(s0)
    fld ft0, 0(t0)
    fsd ft0, 320(s0)
    addi t0, s0, 104
    sw t0, 328(s0)
    lw t0, 328(s0)
    addi t0, t0, 8
    sw t0, 336(s0)
    lw t0, 336(s0)
    fld ft0, 248(s0)
    fsd ft0, 0(t0)
    lw t0, 328(s0)
    addi t0, t0, 16
    sw t0, 344(s0)
    lw t0, 344(s0)
    fld ft0, 320(s0)
    fsd ft0, 0(t0)
    lw t0, 328(s0)
    addi t0, t0, 24
    sw t0, 352(s0)
    lw t0, 352(s0)
    li t6, 6
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    fld fa1, 120(s0)
    fld fa2, 128(s0)
    jal ra, Ahorcado_Palabra_int_
    fsd fa0, 104(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 360(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 5
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 368(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 368(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 376(s0)
    fld ft3, 376(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 368(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 384(s0)
    fld ft3, 384(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 368(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 392(s0)
    fld ft3, 392(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 368(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 400(s0)
    fld ft3, 400(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 368(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 408(s0)
    fld ft3, 408(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 80
    sw t0, 416(s0)
    lw t0, 416(s0)
    fld ft0, 360(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 88
    sw t0, 424(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 432(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    lw t0, 424(s0)
    fld ft0, 432(s0)
    fsd ft0, 0(t0)
    fld ft0, 432(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 440(s0)
    fld ft3, 440(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 432(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 448(s0)
    fld ft3, 448(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 432(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 456(s0)
    fld ft3, 456(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 432(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 464(s0)
    fld ft3, 464(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 432(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 472(s0)
    fld ft3, 472(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 80
    sw t0, 480(s0)
    lw t0, 480(s0)
    fld ft0, 0(t0)
    fsd ft0, 488(s0)
    fld ft0, 432(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 496(s0)
    fld ft3, 496(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 488(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 504(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 504(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 512(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 65
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 72
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 79
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 82
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 67
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 65
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 68
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 79
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 90
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 69
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 84
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 65
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 82
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 73
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 65
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 78
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 79
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 512(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 520(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 520(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 528(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 73
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 103
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 109
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 98
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 528(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    la a0, solicitud_text
    li a7, 4
    ecall
    jal ra, leer_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 536(s0)
    addi t0, s0, 0
    sw t0, 544(s0)
    lw t0, 544(s0)
    fld ft0, 536(s0)
    fsd ft0, 0(t0)
.L_main_pig_L1:
    fcvt.d.w ft0, s2
    fsd ft0, 552(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 69
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 103
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 112
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 98
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 40
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 48
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 52
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 41
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 552(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    la a0, solicitud_int
    li a7, 4
    ecall
    li a7, 5
    ecall
    fcvt.d.w ft0, a0
    fsd ft0, 560(s0)
    addi t0, s0, 8
    sw t0, 568(s0)
    lw t0, 568(s0)
    fld ft0, 560(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 64
    sw t0, 576(s0)
    lw t0, 576(s0)
    fld ft0, 0(t0)
    fsd ft0, 584(s0)
    addi t0, s0, 64
    sw t0, 592(s0)
    lw t0, 592(s0)
    fld ft0, 0(t0)
    fsd ft0, 600(s0)
    addi t0, s0, 8
    sw t0, 608(s0)
    lw t0, 608(s0)
    fld ft0, 0(t0)
    fsd ft0, 616(s0)
    addi t0, s0, 104
    sw t0, 624(s0)
    lw t0, 624(s0)
    addi t0, t0, 8
    sw t0, 632(s0)
    lw t0, 632(s0)
    fld ft0, 600(s0)
    fsd ft0, 0(t0)
    lw t0, 624(s0)
    addi t0, t0, 16
    sw t0, 640(s0)
    lw t0, 640(s0)
    fld ft0, 616(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    fld fa1, 120(s0)
    jal ra, Diccionario_obtener_int_
    fsd fa0, 104(s0)
    addi t0, s0, 104
    sw t0, 648(s0)
    lw t0, 648(s0)
    fld ft0, 0(t0)
    fsd ft0, 656(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1584180013
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 664(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 104
    sw t0, 672(s0)
    lw t0, 672(s0)
    addi t0, t0, 8
    sw t0, 680(s0)
    lw t0, 680(s0)
    fld ft0, 664(s0)
    fsd ft0, 0(t0)
    lw t0, 672(s0)
    addi t0, t0, 16
    sw t0, 688(s0)
    lw t0, 688(s0)
    fld ft0, 656(s0)
    fsd ft0, 0(t0)
    lw t0, 672(s0)
    addi t0, t0, 24
    sw t0, 696(s0)
    lw t0, 696(s0)
    li t6, 6
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    fld fa1, 120(s0)
    fld fa2, 128(s0)
    jal ra, Ahorcado_Palabra_int_
    fsd fa0, 104(s0)
    addi t0, s0, 72
    sw t0, 704(s0)
    lw t0, 704(s0)
    fld ft0, 664(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 712(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 80
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 712(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 72
    sw t0, 720(s0)
    lw t0, 720(s0)
    fld ft0, 0(t0)
    fsd ft0, 728(s0)
    fld ft0, 728(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 736(s0)
    fld ft3, 736(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 744(s0)
    fld ft0, 744(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 752(s0)
    fld ft3, 752(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 760(s0)
    fld ft0, 760(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
.L_main_pig_L4:
    addi t0, s0, 72
    sw t0, 768(s0)
    lw t0, 768(s0)
    fld ft0, 0(t0)
    fsd ft0, 776(s0)
    addi t0, s0, 72
    sw t0, 784(s0)
    lw t0, 784(s0)
    fld ft0, 0(t0)
    fsd ft0, 792(s0)
    addi t0, s0, 104
    sw t0, 800(s0)
    lw t0, 800(s0)
    addi t0, t0, 8
    sw t0, 808(s0)
    lw t0, 808(s0)
    fld ft0, 792(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    jal ra, Ahorcado_terminoJuego__
    fsd fa0, 104(s0)
    addi t0, s0, 104
    sw t0, 816(s0)
    lw t0, 816(s0)
    fld ft0, 0(t0)
    fsd ft0, 824(s0)
    fld ft0, 824(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 832(s0)
    fld ft0, 832(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_76
    j .L_main_pig_L5
.L_rama_larga_76:
    addi t0, s0, 72
    sw t0, 840(s0)
    lw t0, 840(s0)
    fld ft0, 0(t0)
    fsd ft0, 848(s0)
    addi t0, s0, 72
    sw t0, 856(s0)
    lw t0, 856(s0)
    fld ft0, 0(t0)
    fsd ft0, 864(s0)
    addi t0, s0, 104
    sw t0, 872(s0)
    lw t0, 872(s0)
    addi t0, t0, 8
    sw t0, 880(s0)
    lw t0, 880(s0)
    fld ft0, 864(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    jal ra, Ahorcado_dibujar__
    fsd fa0, 104(s0)
    addi t0, s0, 72
    sw t0, 888(s0)
    lw t0, 888(s0)
    fld ft0, 0(t0)
    fsd ft0, 896(s0)
    addi t0, s0, 72
    sw t0, 904(s0)
    lw t0, 904(s0)
    fld ft0, 0(t0)
    fsd ft0, 912(s0)
    addi t0, s0, 104
    sw t0, 920(s0)
    lw t0, 920(s0)
    addi t0, t0, 8
    sw t0, 928(s0)
    lw t0, 928(s0)
    fld ft0, 912(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    jal ra, Ahorcado_mostrarEstado__
    fsd fa0, 104(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 936(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 73
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 103
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 109
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 936(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    la a0, solicitud_char
    li a7, 4
    ecall
    li a7, 12
    ecall
    fcvt.d.w ft0, a0
    fsd ft0, 944(s0)
    addi t0, s0, 24
    sw t0, 952(s0)
    lw t0, 952(s0)
    fld ft0, 944(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 960(s0)
    lw t0, 960(s0)
    fld ft0, 0(t0)
    fsd ft0, 968(s0)
    addi t0, s0, 104
    sw t0, 976(s0)
    lw t0, 976(s0)
    addi t0, t0, 8
    sw t0, 984(s0)
    lw t0, 984(s0)
    fld ft0, 968(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    jal ra, validarLetra
    fsd fa0, 104(s0)
    addi t0, s0, 104
    sw t0, 992(s0)
    lw t0, 992(s0)
    fld ft0, 0(t0)
    fsd ft0, 1000(s0)
    fld ft0, 1000(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1008(s0)
    fld ft0, 1008(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_77
    j .L_main_pig_L6
.L_rama_larga_77:
    fcvt.d.w ft0, s2
    fsd ft0, 1016(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 69
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 118
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 44
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 122
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1016(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    j .L_main_pig_L4
.L_main_pig_L6:
    addi t0, s0, 72
    sw t0, 1024(s0)
    lw t0, 1024(s0)
    fld ft0, 0(t0)
    fsd ft0, 1032(s0)
    addi t0, s0, 72
    sw t0, 1040(s0)
    lw t0, 1040(s0)
    fld ft0, 0(t0)
    fsd ft0, 1048(s0)
    addi t0, s0, 24
    sw t0, 1056(s0)
    lw t0, 1056(s0)
    fld ft0, 0(t0)
    fsd ft0, 1064(s0)
    addi t0, s0, 104
    sw t0, 1072(s0)
    lw t0, 1072(s0)
    addi t0, t0, 8
    sw t0, 1080(s0)
    lw t0, 1080(s0)
    fld ft0, 1048(s0)
    fsd ft0, 0(t0)
    lw t0, 1072(s0)
    addi t0, t0, 16
    sw t0, 1088(s0)
    lw t0, 1088(s0)
    fld ft0, 1064(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    fld fa1, 120(s0)
    jal ra, Ahorcado_intentar_char_
    fsd fa0, 104(s0)
    addi t0, s0, 104
    sw t0, 1096(s0)
    lw t0, 1096(s0)
    fld ft0, 0(t0)
    fsd ft0, 1104(s0)
    addi t0, s0, 32
    sw t0, 1112(s0)
    lw t0, 1112(s0)
    fld ft0, 1104(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 32
    sw t0, 1120(s0)
    lw t0, 1120(s0)
    fld ft0, 0(t0)
    fsd ft0, 1128(s0)
    fld ft0, 1128(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1136(s0)
    fld ft0, 1136(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_78
    j .L_main_pig_L8
.L_rama_larga_78:
    fcvt.d.w ft0, s2
    fsd ft0, 1144(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 89
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1144(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 24
    sw t0, 1152(s0)
    lw t0, 1152(s0)
    fld ft0, 0(t0)
    fsd ft0, 1160(s0)
    fld ft0, 1160(s0)
    fcvt.w.d a0, ft0
    li a7, 11
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    j .L_main_pig_L9
.L_main_pig_L8:
    addi t0, s0, 32
    sw t0, 1168(s0)
    lw t0, 1168(s0)
    fld ft0, 0(t0)
    fsd ft0, 1176(s0)
    fld ft0, 1176(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1184(s0)
    fld ft0, 1184(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_79
    j .L_main_pig_L10
.L_rama_larga_79:
    fcvt.d.w ft0, s2
    fsd ft0, 1192(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 66
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 33
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 76
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1192(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 24
    sw t0, 1200(s0)
    lw t0, 1200(s0)
    fld ft0, 0(t0)
    fsd ft0, 1208(s0)
    fld ft0, 1208(s0)
    fcvt.w.d a0, ft0
    li a7, 11
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 1216(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 112
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 98
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1216(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    j .L_main_pig_L11
.L_main_pig_L10:
    fcvt.d.w ft0, s2
    fsd ft0, 1224(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 70
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 33
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 76
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1224(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 24
    sw t0, 1232(s0)
    lw t0, 1232(s0)
    fld ft0, 0(t0)
    fsd ft0, 1240(s0)
    fld ft0, 1240(s0)
    fcvt.w.d a0, ft0
    li a7, 11
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 1248(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1248(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
.L_main_pig_L11:
.L_main_pig_L9:
    j .L_main_pig_L4
.L_main_pig_L5:
    addi t0, s0, 40
    sw t0, 1256(s0)
    lw t0, 1256(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 72
    sw t0, 1264(s0)
    lw t0, 1264(s0)
    fld ft0, 0(t0)
    fsd ft0, 1272(s0)
    addi t0, s0, 72
    sw t0, 1280(s0)
    lw t0, 1280(s0)
    fld ft0, 0(t0)
    fsd ft0, 1288(s0)
    addi t0, s0, 104
    sw t0, 1296(s0)
    lw t0, 1296(s0)
    addi t0, t0, 8
    sw t0, 1304(s0)
    lw t0, 1304(s0)
    fld ft0, 1288(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    jal ra, Ahorcado_gano__
    fsd fa0, 104(s0)
    addi t0, s0, 104
    sw t0, 1312(s0)
    lw t0, 1312(s0)
    fld ft0, 0(t0)
    fsd ft0, 1320(s0)
    fld ft0, 1320(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_80
    j .L_main_pig_L12
.L_rama_larga_80:
    addi t0, s0, 56
    sw t0, 1328(s0)
    lw t0, 1328(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 72
    sw t0, 1336(s0)
    lw t0, 1336(s0)
    fld ft0, 0(t0)
    fsd ft0, 1344(s0)
    fld ft0, 1344(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1352(s0)
    fld ft3, 1352(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1360(s0)
    fld ft0, 1360(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1368(s0)
    fld ft3, 1368(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1376(s0)
    addi t0, s0, 72
    sw t0, 1384(s0)
    lw t0, 1384(s0)
    fld ft0, 0(t0)
    fsd ft0, 1392(s0)
    fld ft0, 1392(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1400(s0)
    fld ft3, 1400(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1408(s0)
    addi t0, s0, 104
    sw t0, 1416(s0)
    lw t0, 1416(s0)
    addi t0, t0, 8
    sw t0, 1424(s0)
    lw t0, 1424(s0)
    fld ft0, 1376(s0)
    fsd ft0, 0(t0)
    lw t0, 1416(s0)
    addi t0, t0, 16
    sw t0, 1432(s0)
    lw t0, 1432(s0)
    fld ft0, 1408(s0)
    fsd ft0, 0(t0)
    lw t0, 1416(s0)
    addi t0, t0, 24
    sw t0, 1440(s0)
    lw t0, 1440(s0)
    li t6, 6
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    fld fa1, 120(s0)
    fld fa2, 128(s0)
    jal ra, calcularPuntaje
    fsd fa0, 104(s0)
    addi t0, s0, 104
    sw t0, 1448(s0)
    lw t0, 1448(s0)
    fld ft0, 0(t0)
    fsd ft0, 1456(s0)
    addi t0, s0, 40
    sw t0, 1464(s0)
    lw t0, 1464(s0)
    fld ft0, 1456(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 1472(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 71
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 65
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 78
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 65
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 83
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 84
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 69
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 33
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 76
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 112
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 98
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1472(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    j .L_main_pig_L13
.L_main_pig_L12:
    addi t0, s0, 56
    sw t0, 1480(s0)
    lw t0, 1480(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 1488(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 80
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 69
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 82
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 68
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 73
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 83
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 84
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 69
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 46
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 76
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 112
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 98
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1488(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
.L_main_pig_L13:
    addi t0, s0, 72
    sw t0, 1496(s0)
    lw t0, 1496(s0)
    fld ft0, 0(t0)
    fsd ft0, 1504(s0)
    addi t0, s0, 72
    sw t0, 1512(s0)
    lw t0, 1512(s0)
    fld ft0, 0(t0)
    fsd ft0, 1520(s0)
    addi t0, s0, 104
    sw t0, 1528(s0)
    lw t0, 1528(s0)
    addi t0, t0, 8
    sw t0, 1536(s0)
    lw t0, 1536(s0)
    fld ft0, 1520(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    jal ra, Ahorcado_dibujar__
    fsd fa0, 104(s0)
    addi t0, s0, 72
    sw t0, 1544(s0)
    lw t0, 1544(s0)
    fld ft0, 0(t0)
    fsd ft0, 1552(s0)
    fld ft0, 1552(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1560(s0)
    fld ft3, 1560(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1568(s0)
    addi t0, s0, 72
    sw t0, 1576(s0)
    lw t0, 1576(s0)
    fld ft0, 0(t0)
    fsd ft0, 1584(s0)
    fld ft0, 1584(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1592(s0)
    fld ft3, 1592(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1600(s0)
    addi t0, s0, 104
    sw t0, 1608(s0)
    lw t0, 1608(s0)
    addi t0, t0, 8
    sw t0, 1616(s0)
    lw t0, 1616(s0)
    fld ft0, 1600(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    jal ra, Palabra_revelarTodo__
    fsd fa0, 104(s0)
    addi t0, s0, 72
    sw t0, 1624(s0)
    lw t0, 1624(s0)
    fld ft0, 0(t0)
    fsd ft0, 1632(s0)
    fld ft0, 1632(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1640(s0)
    fld ft3, 1640(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1648(s0)
    addi t0, s0, 72
    sw t0, 1656(s0)
    lw t0, 1656(s0)
    fld ft0, 0(t0)
    fsd ft0, 1664(s0)
    fld ft0, 1664(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1672(s0)
    fld ft3, 1672(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1680(s0)
    addi t0, s0, 104
    sw t0, 1688(s0)
    lw t0, 1688(s0)
    addi t0, t0, 8
    sw t0, 1696(s0)
    lw t0, 1696(s0)
    fld ft0, 1680(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    jal ra, Palabra_imprimirProgreso__
    fsd fa0, 104(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1704(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 80
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 106
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 112
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1704(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 40
    sw t0, 1712(s0)
    lw t0, 1712(s0)
    fld ft0, 0(t0)
    fsd ft0, 1720(s0)
    fld ft0, 1720(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 88
    sw t0, 1728(s0)
    lw t0, 1728(s0)
    fld ft0, 0(t0)
    fsd ft0, 1736(s0)
    addi t0, s0, 56
    sw t0, 1744(s0)
    lw t0, 1744(s0)
    fld ft0, 0(t0)
    fsd ft0, 1752(s0)
    addi t0, s0, 40
    sw t0, 1760(s0)
    lw t0, 1760(s0)
    fld ft0, 0(t0)
    fsd ft0, 1768(s0)
    addi t0, s0, 104
    sw t0, 1776(s0)
    lw t0, 1776(s0)
    addi t0, t0, 8
    sw t0, 1784(s0)
    lw t0, 1784(s0)
    fld ft0, 1736(s0)
    fsd ft0, 0(t0)
    lw t0, 1776(s0)
    addi t0, t0, 16
    sw t0, 1792(s0)
    lw t0, 1792(s0)
    fld ft0, 1752(s0)
    fsd ft0, 0(t0)
    lw t0, 1776(s0)
    addi t0, t0, 24
    sw t0, 1800(s0)
    lw t0, 1800(s0)
    fld ft0, 1768(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    fld fa1, 120(s0)
    fld fa2, 128(s0)
    jal ra, registrarResultado
    fsd fa0, 104(s0)
    addi t0, s0, 88
    sw t0, 1808(s0)
    lw t0, 1808(s0)
    fld ft0, 0(t0)
    fsd ft0, 1816(s0)
    addi t0, s0, 104
    sw t0, 1824(s0)
    lw t0, 1824(s0)
    addi t0, t0, 8
    sw t0, 1832(s0)
    lw t0, 1832(s0)
    fld ft0, 1816(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    jal ra, mostrarMarcador
    fsd fa0, 104(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1840(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 74
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 103
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 118
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 122
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 63
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 40
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 49
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 44
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 48
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 61
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 41
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1840(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    la a0, solicitud_int
    li a7, 4
    ecall
    li a7, 5
    ecall
    fcvt.d.w ft0, a0
    fsd ft0, 1848(s0)
    addi t0, s0, 16
    sw t0, 1856(s0)
    lw t0, 1856(s0)
    fld ft0, 1848(s0)
    fsd ft0, 0(t0)
.L_main_pig_L2:
    addi t0, s0, 16
    sw t0, 1864(s0)
    lw t0, 1864(s0)
    fld ft0, 0(t0)
    fsd ft0, 1872(s0)
    fld ft0, 1872(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1880(s0)
    fld ft0, 1880(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_81
    j .L_main_pig_L3
.L_rama_larga_81:
    j .L_main_pig_L1
.L_main_pig_L3:
    addi t0, s0, 88
    sw t0, 1888(s0)
    lw t0, 1888(s0)
    fld ft0, 0(t0)
    fsd ft0, 1896(s0)
    addi t0, s0, 104
    sw t0, 1904(s0)
    lw t0, 1904(s0)
    addi t0, t0, 8
    sw t0, 1912(s0)
    lw t0, 1912(s0)
    fld ft0, 1896(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    jal ra, sumarPuntajes
    fsd fa0, 104(s0)
    addi t0, s0, 104
    sw t0, 1920(s0)
    lw t0, 1920(s0)
    fld ft0, 0(t0)
    fsd ft0, 1928(s0)
    addi t0, s0, 48
    sw t0, 1936(s0)
    lw t0, 1936(s0)
    fld ft0, 1928(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 1944(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 80
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 106
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1944(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 48
    sw t0, 1952(s0)
    lw t0, 1952(s0)
    fld ft0, 0(t0)
    fsd ft0, 1960(s0)
    fld ft0, 1960(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 1968(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 84
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 108
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 98
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 116
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 110
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 100
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 58
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1968(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 48
    sw t0, 1976(s0)
    lw t0, 1976(s0)
    fld ft0, 0(t0)
    fsd ft0, 1984(s0)
    addi t0, s0, 104
    sw t0, 1992(s0)
    lw t0, 1992(s0)
    addi t0, t0, 8
    sw t0, 2000(s0)
    lw t0, 2000(s0)
    fld ft0, 1984(s0)
    fsd ft0, 0(t0)
    fld fa0, 112(s0)
    jal ra, titulo
    fsd fa0, 104(s0)
    addi t0, s0, 104
    sw t0, 2008(s0)
    lw t0, 2008(s0)
    fld ft0, 0(t0)
    fsd ft0, 2016(s0)
    fld ft0, 2016(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 2024(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 71
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 105
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 115
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 112
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 106
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 117
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 103
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 114
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 44
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 2024(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 0
    sw t0, 2032(s0)
    lw t0, 2032(s0)
    fld ft0, 0(t0)
    fsd ft0, 2040(s0)
    fld ft0, 2040(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
.L_fin_main_pig:
    li t6, 2056
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2060
    add t6, s0, t6
    lw ra, 0(t6)
    mv sp, s0
    mv s0, t0
    li t6, 2064
    add sp, sp, t6
    ret

