# Codigo RISC-V RV32 generado para RARS
# Puntero de stack en sp, frame pointer en s0 y heap en s1

.data
.align 3
decimal_riscv_0: .double 0.0
decimal_riscv_1: .double 1.0
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

sumar:
    addi sp, sp, -80
    sw ra, 76(sp)
    sw s0, 72(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 8
    sw t0, 24(s0)
    lw t0, 24(s0)
    fld ft0, 0(t0)
    fsd ft0, 32(s0)
    addi t0, s0, 16
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    fld ft0, 32(s0)
    fld ft1, 48(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 56(s0)
    addi t0, s0, 0
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 56(s0)
    fsd ft0, 0(t0)
    j .L_fin_sumar
.L_fin_sumar:
    fld fa0, 0(s0)
    lw t0, 72(s0)
    lw ra, 76(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 80
    ret

restar:
    addi sp, sp, -80
    sw ra, 76(sp)
    sw s0, 72(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 8
    sw t0, 24(s0)
    lw t0, 24(s0)
    fld ft0, 0(t0)
    fsd ft0, 32(s0)
    addi t0, s0, 16
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    fld ft0, 32(s0)
    fld ft1, 48(s0)
    fsub.d ft2, ft0, ft1
    fsd ft2, 56(s0)
    addi t0, s0, 0
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 56(s0)
    fsd ft0, 0(t0)
    j .L_fin_restar
.L_fin_restar:
    fld fa0, 0(s0)
    lw t0, 72(s0)
    lw ra, 76(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 80
    ret

multiplicar:
    addi sp, sp, -80
    sw ra, 76(sp)
    sw s0, 72(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 8
    sw t0, 24(s0)
    lw t0, 24(s0)
    fld ft0, 0(t0)
    fsd ft0, 32(s0)
    addi t0, s0, 16
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    fld ft0, 32(s0)
    fld ft1, 48(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 56(s0)
    addi t0, s0, 0
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 56(s0)
    fsd ft0, 0(t0)
    j .L_fin_multiplicar
.L_fin_multiplicar:
    fld fa0, 0(s0)
    lw t0, 72(s0)
    lw ra, 76(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 80
    ret

dividir:
    addi sp, sp, -128
    sw ra, 124(sp)
    sw s0, 120(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 16
    sw t0, 24(s0)
    lw t0, 24(s0)
    fld ft0, 0(t0)
    fsd ft0, 32(s0)
    fld ft0, 32(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 40(s0)
    fld ft0, 40(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_0
    j .L_dividir_L2
.L_rama_larga_0:
    fcvt.d.w ft0, s2
    fsd ft0, 48(s0)
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
    li t6, 118
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
    li t6, 108
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
    fld ft0, 48(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    addi t0, s0, 0
    sw t0, 56(s0)
    lw t0, 56(s0)
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    j .L_fin_dividir
    j .L_dividir_L1
.L_dividir_L2:
.L_dividir_L1:
    addi t0, s0, 8
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    addi t0, s0, 16
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
    fld ft0, 72(s0)
    fld ft1, 88(s0)
    fdiv.d ft2, ft0, ft1
    fsd ft2, 96(s0)
    addi t0, s0, 0
    sw t0, 104(s0)
    lw t0, 104(s0)
    fld ft0, 96(s0)
    fsd ft0, 0(t0)
    j .L_fin_dividir
.L_fin_dividir:
    fld fa0, 0(s0)
    lw t0, 120(s0)
    lw ra, 124(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 128
    ret

aplicar:
    addi sp, sp, -480
    sw ra, 476(sp)
    sw s0, 472(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fsd fa2, 24(s0)
    addi t0, s0, 32
    sw t0, 64(s0)
    lw t0, 64(s0)
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    fld ft0, 80(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 88(s0)
    fld ft0, 88(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_1
    j .L_aplicar_L9
.L_rama_larga_1:
    j .L_aplicar_L4
.L_aplicar_L9:
    fld ft0, 80(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 96(s0)
    fld ft0, 96(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_2
    j .L_aplicar_L10
.L_rama_larga_2:
    j .L_aplicar_L5
.L_aplicar_L10:
    fld ft0, 80(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 104(s0)
    fld ft0, 104(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_3
    j .L_aplicar_L11
.L_rama_larga_3:
    j .L_aplicar_L6
.L_aplicar_L11:
    fld ft0, 80(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 112(s0)
    fld ft0, 112(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_4
    j .L_aplicar_L12
.L_rama_larga_4:
    j .L_aplicar_L7
.L_aplicar_L12:
    j .L_aplicar_L8
.L_aplicar_L4:
    addi t0, s0, 16
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    addi t0, s0, 24
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 0(t0)
    fsd ft0, 144(s0)
    addi t0, s0, 40
    sw t0, 152(s0)
    lw t0, 152(s0)
    addi t0, t0, 8
    sw t0, 160(s0)
    lw t0, 160(s0)
    fld ft0, 128(s0)
    fsd ft0, 0(t0)
    lw t0, 152(s0)
    addi t0, t0, 16
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 144(s0)
    fsd ft0, 0(t0)
    fld fa0, 48(s0)
    fld fa1, 56(s0)
    jal ra, sumar
    fsd fa0, 40(s0)
    addi t0, s0, 40
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 0(t0)
    fsd ft0, 184(s0)
    addi t0, s0, 32
    sw t0, 192(s0)
    lw t0, 192(s0)
    fld ft0, 184(s0)
    fsd ft0, 0(t0)
    j .L_aplicar_L3
.L_aplicar_L5:
    addi t0, s0, 16
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    addi t0, s0, 24
    sw t0, 216(s0)
    lw t0, 216(s0)
    fld ft0, 0(t0)
    fsd ft0, 224(s0)
    addi t0, s0, 40
    sw t0, 232(s0)
    lw t0, 232(s0)
    addi t0, t0, 8
    sw t0, 240(s0)
    lw t0, 240(s0)
    fld ft0, 208(s0)
    fsd ft0, 0(t0)
    lw t0, 232(s0)
    addi t0, t0, 16
    sw t0, 248(s0)
    lw t0, 248(s0)
    fld ft0, 224(s0)
    fsd ft0, 0(t0)
    fld fa0, 48(s0)
    fld fa1, 56(s0)
    jal ra, restar
    fsd fa0, 40(s0)
    addi t0, s0, 40
    sw t0, 256(s0)
    lw t0, 256(s0)
    fld ft0, 0(t0)
    fsd ft0, 264(s0)
    addi t0, s0, 32
    sw t0, 272(s0)
    lw t0, 272(s0)
    fld ft0, 264(s0)
    fsd ft0, 0(t0)
    j .L_aplicar_L3
.L_aplicar_L6:
    addi t0, s0, 16
    sw t0, 280(s0)
    lw t0, 280(s0)
    fld ft0, 0(t0)
    fsd ft0, 288(s0)
    addi t0, s0, 24
    sw t0, 296(s0)
    lw t0, 296(s0)
    fld ft0, 0(t0)
    fsd ft0, 304(s0)
    addi t0, s0, 40
    sw t0, 312(s0)
    lw t0, 312(s0)
    addi t0, t0, 8
    sw t0, 320(s0)
    lw t0, 320(s0)
    fld ft0, 288(s0)
    fsd ft0, 0(t0)
    lw t0, 312(s0)
    addi t0, t0, 16
    sw t0, 328(s0)
    lw t0, 328(s0)
    fld ft0, 304(s0)
    fsd ft0, 0(t0)
    fld fa0, 48(s0)
    fld fa1, 56(s0)
    jal ra, multiplicar
    fsd fa0, 40(s0)
    addi t0, s0, 40
    sw t0, 336(s0)
    lw t0, 336(s0)
    fld ft0, 0(t0)
    fsd ft0, 344(s0)
    addi t0, s0, 32
    sw t0, 352(s0)
    lw t0, 352(s0)
    fld ft0, 344(s0)
    fsd ft0, 0(t0)
    j .L_aplicar_L3
.L_aplicar_L7:
    addi t0, s0, 16
    sw t0, 360(s0)
    lw t0, 360(s0)
    fld ft0, 0(t0)
    fsd ft0, 368(s0)
    addi t0, s0, 24
    sw t0, 376(s0)
    lw t0, 376(s0)
    fld ft0, 0(t0)
    fsd ft0, 384(s0)
    addi t0, s0, 40
    sw t0, 392(s0)
    lw t0, 392(s0)
    addi t0, t0, 8
    sw t0, 400(s0)
    lw t0, 400(s0)
    fld ft0, 368(s0)
    fsd ft0, 0(t0)
    lw t0, 392(s0)
    addi t0, t0, 16
    sw t0, 408(s0)
    lw t0, 408(s0)
    fld ft0, 384(s0)
    fsd ft0, 0(t0)
    fld fa0, 48(s0)
    fld fa1, 56(s0)
    jal ra, dividir
    fsd fa0, 40(s0)
    addi t0, s0, 40
    sw t0, 416(s0)
    lw t0, 416(s0)
    fld ft0, 0(t0)
    fsd ft0, 424(s0)
    addi t0, s0, 32
    sw t0, 432(s0)
    lw t0, 432(s0)
    fld ft0, 424(s0)
    fsd ft0, 0(t0)
    j .L_aplicar_L3
.L_aplicar_L8:
    fcvt.d.w ft0, s2
    fsd ft0, 440(s0)
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
    li t6, 112
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
    li t6, 111
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
    fld ft0, 440(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    j .L_aplicar_L3
.L_aplicar_L3:
    addi t0, s0, 32
    sw t0, 448(s0)
    lw t0, 448(s0)
    fld ft0, 0(t0)
    fsd ft0, 456(s0)
    addi t0, s0, 0
    sw t0, 464(s0)
    lw t0, 464(s0)
    fld ft0, 456(s0)
    fsd ft0, 0(t0)
    j .L_fin_aplicar
.L_fin_aplicar:
    fld fa0, 0(s0)
    lw t0, 472(s0)
    lw ra, 476(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 480
    ret

potencia:
    addi sp, sp, -352
    sw ra, 348(sp)
    sw s0, 344(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 24
    sw t0, 48(s0)
    lw t0, 48(s0)
    la t6, decimal_riscv_1
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    addi t0, s0, 32
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 64(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 32
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
    fld ft0, 88(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 96(s0)
    fld ft0, 96(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_5
    j .L_potencia_L14
.L_rama_larga_5:
    addi t0, s0, 32
    sw t0, 104(s0)
    lw t0, 104(s0)
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fld ft1, 112(s0)
    fsub.d ft2, ft0, ft1
    fsd ft2, 120(s0)
    addi t0, s0, 32
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 120(s0)
    fsd ft0, 0(t0)
    j .L_potencia_L13
.L_potencia_L14:
.L_potencia_L13:
    addi t0, s0, 40
    sw t0, 136(s0)
    lw t0, 136(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_potencia_L15:
    addi t0, s0, 40
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    addi t0, s0, 32
    sw t0, 160(s0)
    lw t0, 160(s0)
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    fld ft0, 152(s0)
    fld ft1, 168(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 176(s0)
    fld ft0, 176(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_6
    j .L_potencia_L17
.L_rama_larga_6:
    addi t0, s0, 24
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    addi t0, s0, 8
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    fld ft0, 192(s0)
    fld ft1, 208(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    addi t0, s0, 24
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 216(s0)
    fsd ft0, 0(t0)
.L_potencia_L16:
    addi t0, s0, 40
    sw t0, 232(s0)
    lw t0, 232(s0)
    fld ft0, 0(t0)
    fsd ft0, 240(s0)
    fld ft0, 240(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 248(s0)
    addi t0, s0, 40
    sw t0, 256(s0)
    lw t0, 256(s0)
    fld ft0, 248(s0)
    fsd ft0, 0(t0)
    j .L_potencia_L15
.L_potencia_L17:
    addi t0, s0, 16
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 0(t0)
    fsd ft0, 272(s0)
    fld ft0, 272(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 280(s0)
    fld ft0, 280(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_7
    j .L_potencia_L19
.L_rama_larga_7:
    addi t0, s0, 24
    sw t0, 288(s0)
    lw t0, 288(s0)
    fld ft0, 0(t0)
    fsd ft0, 296(s0)
    la t6, decimal_riscv_1
    fld ft0, 0(t6)
    fld ft1, 296(s0)
    fdiv.d ft2, ft0, ft1
    fsd ft2, 304(s0)
    addi t0, s0, 0
    sw t0, 312(s0)
    lw t0, 312(s0)
    fld ft0, 304(s0)
    fsd ft0, 0(t0)
    j .L_fin_potencia
    j .L_potencia_L18
.L_potencia_L19:
.L_potencia_L18:
    addi t0, s0, 24
    sw t0, 320(s0)
    lw t0, 320(s0)
    fld ft0, 0(t0)
    fsd ft0, 328(s0)
    addi t0, s0, 0
    sw t0, 336(s0)
    lw t0, 336(s0)
    fld ft0, 328(s0)
    fsd ft0, 0(t0)
    j .L_fin_potencia
.L_fin_potencia:
    fld fa0, 0(s0)
    lw t0, 344(s0)
    lw ra, 348(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 352
    ret

factorial:
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
    fld ft0, 40(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 48(s0)
    fld ft0, 48(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_8
    j .L_factorial_L21
.L_rama_larga_8:
    addi t0, s0, 0
    sw t0, 56(s0)
    lw t0, 56(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_factorial
    j .L_factorial_L20
.L_factorial_L21:
.L_factorial_L20:
    addi t0, s0, 8
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    addi t0, s0, 8
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
    fld ft0, 88(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 96(s0)
    addi t0, s0, 16
    sw t0, 104(s0)
    lw t0, 104(s0)
    addi t0, t0, 8
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 96(s0)
    fsd ft0, 0(t0)
    fld fa0, 24(s0)
    jal ra, factorial
    fsd fa0, 16(s0)
    addi t0, s0, 16
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    fld ft0, 72(s0)
    fld ft1, 128(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 136(s0)
    addi t0, s0, 0
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 136(s0)
    fsd ft0, 0(t0)
    j .L_fin_factorial
.L_fin_factorial:
    fld fa0, 0(s0)
    lw t0, 152(s0)
    lw ra, 156(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 160
    ret

fibonacci:
    addi sp, sp, -224
    sw ra, 220(sp)
    sw s0, 216(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 32(s0)
    lw t0, 32(s0)
    fld ft0, 0(t0)
    fsd ft0, 40(s0)
    fld ft0, 40(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 48(s0)
    fld ft0, 48(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_9
    j .L_fibonacci_L23
.L_rama_larga_9:
    addi t0, s0, 8
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    addi t0, s0, 0
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 64(s0)
    fsd ft0, 0(t0)
    j .L_fin_fibonacci
    j .L_fibonacci_L22
.L_fibonacci_L23:
.L_fibonacci_L22:
    addi t0, s0, 8
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
    fld ft0, 88(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 96(s0)
    addi t0, s0, 16
    sw t0, 104(s0)
    lw t0, 104(s0)
    addi t0, t0, 8
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 96(s0)
    fsd ft0, 0(t0)
    fld fa0, 24(s0)
    jal ra, fibonacci
    fsd fa0, 16(s0)
    addi t0, s0, 16
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    addi t0, s0, 8
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 0(t0)
    fsd ft0, 144(s0)
    fld ft0, 144(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 152(s0)
    addi t0, s0, 16
    sw t0, 160(s0)
    lw t0, 160(s0)
    addi t0, t0, 8
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 152(s0)
    fsd ft0, 0(t0)
    fld fa0, 24(s0)
    jal ra, fibonacci
    fsd fa0, 16(s0)
    addi t0, s0, 16
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 0(t0)
    fsd ft0, 184(s0)
    fld ft0, 128(s0)
    fld ft1, 184(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 192(s0)
    addi t0, s0, 0
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 192(s0)
    fsd ft0, 0(t0)
    j .L_fin_fibonacci
.L_fin_fibonacci:
    fld fa0, 0(s0)
    lw t0, 216(s0)
    lw ra, 220(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 224
    ret

esPrimo:
    addi sp, sp, -288
    sw ra, 284(sp)
    sw s0, 280(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 24(s0)
    lw t0, 24(s0)
    fld ft0, 0(t0)
    fsd ft0, 32(s0)
    fld ft0, 32(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 40(s0)
    fld ft0, 40(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_10
    j .L_esPrimo_L25
.L_rama_larga_10:
    addi t0, s0, 0
    sw t0, 48(s0)
    lw t0, 48(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_esPrimo
    j .L_esPrimo_L24
.L_esPrimo_L25:
.L_esPrimo_L24:
    addi t0, s0, 16
    sw t0, 56(s0)
    lw t0, 56(s0)
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_esPrimo_L26:
    addi t0, s0, 16
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    addi t0, s0, 16
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
    fld ft0, 72(s0)
    fld ft1, 88(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 96(s0)
    addi t0, s0, 8
    sw t0, 104(s0)
    lw t0, 104(s0)
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    fld ft0, 112(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 120(s0)
    fld ft0, 96(s0)
    fld ft1, 120(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 128(s0)
    fld ft0, 128(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_11
    j .L_esPrimo_L27
.L_rama_larga_11:
    addi t0, s0, 8
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 0(t0)
    fsd ft0, 144(s0)
    addi t0, s0, 8
    sw t0, 152(s0)
    lw t0, 152(s0)
    fld ft0, 0(t0)
    fsd ft0, 160(s0)
    addi t0, s0, 16
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    fld ft0, 160(s0)
    fld ft1, 176(s0)
    fdiv.d ft2, ft0, ft1
    fsd ft2, 184(s0)
    addi t0, s0, 16
    sw t0, 192(s0)
    lw t0, 192(s0)
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    fld ft0, 184(s0)
    fld ft1, 200(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 208(s0)
    fld ft0, 144(s0)
    fld ft1, 208(s0)
    fsub.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    fld ft0, 216(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 224(s0)
    fld ft0, 224(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_12
    j .L_esPrimo_L29
.L_rama_larga_12:
    addi t0, s0, 0
    sw t0, 232(s0)
    lw t0, 232(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_esPrimo
    j .L_esPrimo_L28
.L_esPrimo_L29:
.L_esPrimo_L28:
    addi t0, s0, 16
    sw t0, 240(s0)
    lw t0, 240(s0)
    fld ft0, 0(t0)
    fsd ft0, 248(s0)
    fld ft0, 248(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    addi t0, s0, 16
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 256(s0)
    fsd ft0, 0(t0)
    j .L_esPrimo_L26
.L_esPrimo_L27:
    addi t0, s0, 0
    sw t0, 272(s0)
    lw t0, 272(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_esPrimo
.L_fin_esPrimo:
    fld fa0, 0(s0)
    lw t0, 280(s0)
    lw ra, 284(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 288
    ret

mcd:
    addi sp, sp, -304
    sw ra, 300(sp)
    sw s0, 296(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 8
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    addi t0, s0, 24
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 56(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    addi t0, s0, 32
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 80(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 40
    sw t0, 96(s0)
    lw t0, 96(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_mcd_L30:
    addi t0, s0, 32
    sw t0, 104(s0)
    lw t0, 104(s0)
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    fld ft0, 112(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 120(s0)
    fld ft0, 120(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_13
    j .L_mcd_L31
.L_rama_larga_13:
    addi t0, s0, 32
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    addi t0, s0, 40
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 136(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 152(s0)
    lw t0, 152(s0)
    fld ft0, 0(t0)
    fsd ft0, 160(s0)
    addi t0, s0, 24
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    addi t0, s0, 32
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    fld ft0, 176(s0)
    fld ft1, 192(s0)
    fdiv.d ft2, ft0, ft1
    fsd ft2, 200(s0)
    addi t0, s0, 32
    sw t0, 208(s0)
    lw t0, 208(s0)
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    fld ft0, 200(s0)
    fld ft1, 216(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 224(s0)
    fld ft0, 160(s0)
    fld ft1, 224(s0)
    fsub.d ft2, ft0, ft1
    fsd ft2, 232(s0)
    addi t0, s0, 32
    sw t0, 240(s0)
    lw t0, 240(s0)
    fld ft0, 232(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 40
    sw t0, 248(s0)
    lw t0, 248(s0)
    fld ft0, 0(t0)
    fsd ft0, 256(s0)
    addi t0, s0, 24
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 256(s0)
    fsd ft0, 0(t0)
    j .L_mcd_L30
.L_mcd_L31:
    addi t0, s0, 24
    sw t0, 272(s0)
    lw t0, 272(s0)
    fld ft0, 0(t0)
    fsd ft0, 280(s0)
    addi t0, s0, 0
    sw t0, 288(s0)
    lw t0, 288(s0)
    fld ft0, 280(s0)
    fsd ft0, 0(t0)
    j .L_fin_mcd
.L_fin_mcd:
    fld fa0, 0(s0)
    lw t0, 296(s0)
    lw ra, 300(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 304
    ret

contarDigitos:
    addi sp, sp, -240
    sw ra, 236(sp)
    sw s0, 232(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 16
    sw t0, 32(s0)
    lw t0, 32(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    addi t0, s0, 24
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 48(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    fld ft0, 72(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 80(s0)
    fld ft0, 80(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_14
    j .L_contarDigitos_L33
.L_rama_larga_14:
    addi t0, s0, 24
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 0(t0)
    fsd ft0, 96(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fld ft1, 96(s0)
    fsub.d ft2, ft0, ft1
    fsd ft2, 104(s0)
    addi t0, s0, 24
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 104(s0)
    fsd ft0, 0(t0)
    j .L_contarDigitos_L32
.L_contarDigitos_L33:
.L_contarDigitos_L32:
.L_contarDigitos_L34:
    addi t0, s0, 24
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    fld ft0, 128(s0)
    li t6, 10
    fcvt.d.w ft1, t6
    fdiv.d ft2, ft0, ft1
    fsd ft2, 136(s0)
    addi t0, s0, 24
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 136(s0)
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
.L_contarDigitos_L35:
    addi t0, s0, 24
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    fld ft0, 192(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 200(s0)
    fld ft0, 200(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_15
    j .L_contarDigitos_L34
.L_rama_larga_15:
.L_contarDigitos_L36:
    addi t0, s0, 16
    sw t0, 208(s0)
    lw t0, 208(s0)
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    addi t0, s0, 0
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 216(s0)
    fsd ft0, 0(t0)
    j .L_fin_contarDigitos
.L_fin_contarDigitos:
    fld fa0, 0(s0)
    lw t0, 232(s0)
    lw ra, 236(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 240
    ret

sumaImpares:
    addi sp, sp, -304
    sw ra, 300(sp)
    sw s0, 296(sp)
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
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_sumaImpares_L37:
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
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 80(s0)
    fld ft0, 56(s0)
    fld ft1, 80(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 88(s0)
    fld ft0, 88(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_16
    j .L_sumaImpares_L39
.L_rama_larga_16:
    addi t0, s0, 24
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    addi t0, s0, 24
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    fld ft0, 120(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fdiv.d ft2, ft0, ft1
    fsd ft2, 128(s0)
    fld ft0, 128(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fmul.d ft2, ft0, ft1
    fsd ft2, 136(s0)
    fld ft0, 104(s0)
    fld ft1, 136(s0)
    fsub.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    fld ft0, 144(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 152(s0)
    fld ft0, 152(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_17
    j .L_sumaImpares_L41
.L_rama_larga_17:
    j .L_sumaImpares_L38
    j .L_sumaImpares_L40
.L_sumaImpares_L41:
.L_sumaImpares_L40:
    addi t0, s0, 16
    sw t0, 160(s0)
    lw t0, 160(s0)
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    fld ft0, 168(s0)
    li t6, 1000
    fcvt.d.w ft1, t6
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 176(s0)
    fld ft0, 176(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_18
    j .L_sumaImpares_L43
.L_rama_larga_18:
    j .L_sumaImpares_L39
    j .L_sumaImpares_L42
.L_sumaImpares_L43:
.L_sumaImpares_L42:
    addi t0, s0, 16
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    addi t0, s0, 24
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    fld ft0, 192(s0)
    fld ft1, 208(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    addi t0, s0, 16
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 216(s0)
    fsd ft0, 0(t0)
.L_sumaImpares_L38:
    addi t0, s0, 24
    sw t0, 232(s0)
    lw t0, 232(s0)
    fld ft0, 0(t0)
    fsd ft0, 240(s0)
    fld ft0, 240(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 248(s0)
    addi t0, s0, 24
    sw t0, 256(s0)
    lw t0, 256(s0)
    fld ft0, 248(s0)
    fsd ft0, 0(t0)
    j .L_sumaImpares_L37
.L_sumaImpares_L39:
    addi t0, s0, 16
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 0(t0)
    fsd ft0, 272(s0)
    addi t0, s0, 0
    sw t0, 280(s0)
    lw t0, 280(s0)
    fld ft0, 272(s0)
    fsd ft0, 0(t0)
    j .L_fin_sumaImpares
.L_fin_sumaImpares:
    fld fa0, 0(s0)
    lw t0, 296(s0)
    lw ra, 300(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 304
    ret

sumarArreglo:
    addi sp, sp, -272
    sw ra, 268(sp)
    sw s0, 264(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 24
    sw t0, 40(s0)
    lw t0, 40(s0)
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    addi t0, s0, 32
    sw t0, 48(s0)
    lw t0, 48(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_sumarArreglo_L44:
    addi t0, s0, 32
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    addi t0, s0, 16
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    fld ft0, 64(s0)
    fld ft1, 80(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 88(s0)
    fld ft0, 88(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_19
    j .L_sumarArreglo_L46
.L_rama_larga_19:
    addi t0, s0, 24
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    addi t0, s0, 8
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    fld ft3, 120(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    fld ft0, 128(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 136(s0)
    fld ft0, 120(s0)
    fld ft1, 136(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    addi t0, s0, 32
    sw t0, 152(s0)
    lw t0, 152(s0)
    fld ft0, 0(t0)
    fsd ft0, 160(s0)
    fld ft0, 144(s0)
    fld ft1, 160(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 168(s0)
    fld ft3, 168(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    fld ft0, 104(s0)
    fld ft1, 176(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 184(s0)
    addi t0, s0, 24
    sw t0, 192(s0)
    lw t0, 192(s0)
    fld ft0, 184(s0)
    fsd ft0, 0(t0)
.L_sumarArreglo_L45:
    addi t0, s0, 32
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    fld ft0, 208(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    addi t0, s0, 32
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 216(s0)
    fsd ft0, 0(t0)
    j .L_sumarArreglo_L44
.L_sumarArreglo_L46:
    addi t0, s0, 24
    sw t0, 232(s0)
    lw t0, 232(s0)
    fld ft0, 0(t0)
    fsd ft0, 240(s0)
    addi t0, s0, 0
    sw t0, 248(s0)
    lw t0, 248(s0)
    fld ft0, 240(s0)
    fsd ft0, 0(t0)
    j .L_fin_sumarArreglo
.L_fin_sumarArreglo:
    fld fa0, 0(s0)
    lw t0, 264(s0)
    lw ra, 268(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 272
    ret

maximoArreglo:
    addi sp, sp, -400
    sw ra, 396(sp)
    sw s0, 392(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 8
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    fld ft3, 48(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    fld ft0, 56(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 64(s0)
    fld ft0, 48(s0)
    fld ft1, 64(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 72(s0)
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
    addi t0, s0, 24
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 88(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 32
    sw t0, 104(s0)
    lw t0, 104(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_maximoArreglo_L47:
    addi t0, s0, 32
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    addi t0, s0, 16
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    fld ft0, 120(s0)
    fld ft1, 136(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 144(s0)
    fld ft0, 144(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_20
    j .L_maximoArreglo_L49
.L_rama_larga_20:
    addi t0, s0, 8
    sw t0, 152(s0)
    lw t0, 152(s0)
    fld ft0, 0(t0)
    fsd ft0, 160(s0)
    fld ft3, 160(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    fld ft0, 168(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 176(s0)
    fld ft0, 160(s0)
    fld ft1, 176(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 184(s0)
    addi t0, s0, 32
    sw t0, 192(s0)
    lw t0, 192(s0)
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    fld ft0, 184(s0)
    fld ft1, 200(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 208(s0)
    fld ft3, 208(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    addi t0, s0, 24
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 216(s0)
    fld ft1, 232(s0)
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 240(s0)
    fld ft0, 240(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_21
    j .L_maximoArreglo_L51
.L_rama_larga_21:
    addi t0, s0, 8
    sw t0, 248(s0)
    lw t0, 248(s0)
    fld ft0, 0(t0)
    fsd ft0, 256(s0)
    fld ft3, 256(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 264(s0)
    fld ft0, 264(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 272(s0)
    fld ft0, 256(s0)
    fld ft1, 272(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 280(s0)
    addi t0, s0, 32
    sw t0, 288(s0)
    lw t0, 288(s0)
    fld ft0, 0(t0)
    fsd ft0, 296(s0)
    fld ft0, 280(s0)
    fld ft1, 296(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 304(s0)
    fld ft3, 304(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 312(s0)
    addi t0, s0, 24
    sw t0, 320(s0)
    lw t0, 320(s0)
    fld ft0, 312(s0)
    fsd ft0, 0(t0)
    j .L_maximoArreglo_L50
.L_maximoArreglo_L51:
.L_maximoArreglo_L50:
.L_maximoArreglo_L48:
    addi t0, s0, 32
    sw t0, 328(s0)
    lw t0, 328(s0)
    fld ft0, 0(t0)
    fsd ft0, 336(s0)
    fld ft0, 336(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 344(s0)
    addi t0, s0, 32
    sw t0, 352(s0)
    lw t0, 352(s0)
    fld ft0, 344(s0)
    fsd ft0, 0(t0)
    j .L_maximoArreglo_L47
.L_maximoArreglo_L49:
    addi t0, s0, 24
    sw t0, 360(s0)
    lw t0, 360(s0)
    fld ft0, 0(t0)
    fsd ft0, 368(s0)
    addi t0, s0, 0
    sw t0, 376(s0)
    lw t0, 376(s0)
    fld ft0, 368(s0)
    fsd ft0, 0(t0)
    j .L_fin_maximoArreglo
.L_fin_maximoArreglo:
    fld fa0, 0(s0)
    lw t0, 392(s0)
    lw ra, 396(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 400
    ret

registrar:
    addi sp, sp, -560
    sw ra, 556(sp)
    sw s0, 552(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
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
    li t6, 10
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 64(s0)
    fld ft0, 64(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_22
    j .L_registrar_L53
.L_rama_larga_22:
    addi t0, s0, 16
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
    j .L_registrar_L52
.L_registrar_L53:
    addi t0, s0, 24
    sw t0, 224(s0)
    lw t0, 224(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_registrar_L54:
    addi t0, s0, 24
    sw t0, 232(s0)
    lw t0, 232(s0)
    fld ft0, 0(t0)
    fsd ft0, 240(s0)
    fld ft0, 240(s0)
    li t6, 10
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 248(s0)
    fld ft0, 248(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_23
    j .L_registrar_L56
.L_rama_larga_23:
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
    fld ft0, 280(s0)
    fld ft1, 296(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 304(s0)
    addi t0, s0, 24
    sw t0, 312(s0)
    lw t0, 312(s0)
    fld ft0, 0(t0)
    fsd ft0, 320(s0)
    fld ft0, 304(s0)
    fld ft1, 320(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 328(s0)
    fld ft3, 328(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 336(s0)
    addi t0, s0, 8
    sw t0, 344(s0)
    lw t0, 344(s0)
    fld ft0, 0(t0)
    fsd ft0, 352(s0)
    fld ft0, 352(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 360(s0)
    fld ft3, 360(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 368(s0)
    fld ft3, 368(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 376(s0)
    fld ft0, 376(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 384(s0)
    fld ft0, 368(s0)
    fld ft1, 384(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 392(s0)
    addi t0, s0, 24
    sw t0, 400(s0)
    lw t0, 400(s0)
    fld ft0, 0(t0)
    fsd ft0, 408(s0)
    fld ft0, 408(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 416(s0)
    fld ft0, 392(s0)
    fld ft1, 416(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 424(s0)
    fld ft3, 424(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 336(s0)
    fsd ft0, 0(t0)
.L_registrar_L55:
    addi t0, s0, 24
    sw t0, 432(s0)
    lw t0, 432(s0)
    fld ft0, 0(t0)
    fsd ft0, 440(s0)
    fld ft0, 440(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 448(s0)
    addi t0, s0, 24
    sw t0, 456(s0)
    lw t0, 456(s0)
    fld ft0, 448(s0)
    fsd ft0, 0(t0)
    j .L_registrar_L54
.L_registrar_L56:
    addi t0, s0, 16
    sw t0, 464(s0)
    lw t0, 464(s0)
    fld ft0, 0(t0)
    fsd ft0, 472(s0)
    addi t0, s0, 8
    sw t0, 480(s0)
    lw t0, 480(s0)
    fld ft0, 0(t0)
    fsd ft0, 488(s0)
    fld ft0, 488(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 496(s0)
    fld ft3, 496(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 504(s0)
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
    fld ft0, 504(s0)
    fld ft1, 520(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 528(s0)
    fld ft0, 528(s0)
    li t6, 9
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 536(s0)
    fld ft3, 536(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 472(s0)
    fsd ft0, 0(t0)
.L_registrar_L52:
.L_fin_registrar:
    fld fa0, 0(s0)
    lw t0, 552(s0)
    lw ra, 556(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 560
    ret

mostrarHistorial:
    addi sp, sp, -656
    sw ra, 652(sp)
    sw s0, 648(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 24(s0)
    lw t0, 24(s0)
    fld ft0, 0(t0)
    fsd ft0, 32(s0)
    fld ft0, 32(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 40(s0)
    fld ft3, 40(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    fld ft0, 48(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 56(s0)
    fld ft0, 56(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_24
    j .L_mostrarHistorial_L58
.L_rama_larga_24:
    fcvt.d.w ft0, s2
    fsd ft0, 64(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 64(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    j .L_mostrarHistorial_L57
.L_mostrarHistorial_L58:
    fcvt.d.w ft0, s2
    fsd ft0, 72(s0)
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
    li t6, 72
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
    li t6, 40
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
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
    fld ft0, 88(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 96(s0)
    fld ft3, 96(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    fld fa0, 104(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 112(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 120(s0)
    fld ft0, 72(s0)
    fsd ft0, 128(s0)
.L_mostrarHistorial_L59:
    fld ft3, 128(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    fld ft0, 136(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 144(s0)
    fld ft0, 144(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_25
    j .L_mostrarHistorial_L60
.L_rama_larga_25:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 136(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 128(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 128(s0)
    j .L_mostrarHistorial_L59
.L_mostrarHistorial_L60:
    fld ft0, 112(s0)
    fsd ft0, 152(s0)
.L_mostrarHistorial_L61:
    fld ft3, 152(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 160(s0)
    fld ft0, 160(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 168(s0)
    fld ft0, 168(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_26
    j .L_mostrarHistorial_L62
.L_rama_larga_26:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 160(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 152(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 152(s0)
    j .L_mostrarHistorial_L61
.L_mostrarHistorial_L62:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 176(s0)
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
    li t6, 115
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 184(s0)
    fld ft0, 120(s0)
    fsd ft0, 192(s0)
.L_mostrarHistorial_L63:
    fld ft3, 192(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    fld ft0, 200(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 208(s0)
    fld ft0, 208(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_27
    j .L_mostrarHistorial_L64
.L_rama_larga_27:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 200(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 192(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 192(s0)
    j .L_mostrarHistorial_L63
.L_mostrarHistorial_L64:
    fld ft0, 176(s0)
    fsd ft0, 216(s0)
.L_mostrarHistorial_L65:
    fld ft3, 216(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 224(s0)
    fld ft0, 224(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 232(s0)
    fld ft0, 232(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_28
    j .L_mostrarHistorial_L66
.L_rama_larga_28:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 224(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 216(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    j .L_mostrarHistorial_L65
.L_mostrarHistorial_L66:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 184(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    addi t0, s0, 16
    sw t0, 240(s0)
    lw t0, 240(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_mostrarHistorial_L67:
    addi t0, s0, 16
    sw t0, 248(s0)
    lw t0, 248(s0)
    fld ft0, 0(t0)
    fsd ft0, 256(s0)
    addi t0, s0, 8
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 0(t0)
    fsd ft0, 272(s0)
    fld ft0, 272(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 280(s0)
    fld ft3, 280(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 288(s0)
    fld ft0, 256(s0)
    fld ft1, 288(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 296(s0)
    fld ft0, 296(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_29
    j .L_mostrarHistorial_L69
.L_rama_larga_29:
    fcvt.d.w ft0, s2
    fsd ft0, 304(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 35
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
    sw t0, 312(s0)
    lw t0, 312(s0)
    fld ft0, 0(t0)
    fsd ft0, 320(s0)
    fld fa0, 320(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 328(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 336(s0)
    fld ft0, 304(s0)
    fsd ft0, 344(s0)
.L_mostrarHistorial_L70:
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
    beqz t0, .L_rama_larga_30
    j .L_mostrarHistorial_L71
.L_rama_larga_30:
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
    j .L_mostrarHistorial_L70
.L_mostrarHistorial_L71:
    fld ft0, 328(s0)
    fsd ft0, 368(s0)
.L_mostrarHistorial_L72:
    fld ft3, 368(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 376(s0)
    fld ft0, 376(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 384(s0)
    fld ft0, 384(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_31
    j .L_mostrarHistorial_L73
.L_rama_larga_31:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 376(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 368(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 368(s0)
    j .L_mostrarHistorial_L72
.L_mostrarHistorial_L73:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 392(s0)
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
    fsd ft0, 400(s0)
    fld ft0, 336(s0)
    fsd ft0, 408(s0)
.L_mostrarHistorial_L74:
    fld ft3, 408(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 416(s0)
    fld ft0, 416(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 424(s0)
    fld ft0, 424(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_32
    j .L_mostrarHistorial_L75
.L_rama_larga_32:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 416(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 408(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 408(s0)
    j .L_mostrarHistorial_L74
.L_mostrarHistorial_L75:
    fld ft0, 392(s0)
    fsd ft0, 432(s0)
.L_mostrarHistorial_L76:
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
    fcvt.d.w ft2, t0
    fsd ft2, 448(s0)
    fld ft0, 448(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_33
    j .L_mostrarHistorial_L77
.L_rama_larga_33:
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
    j .L_mostrarHistorial_L76
.L_mostrarHistorial_L77:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 456(s0)
    lw t0, 456(s0)
    fld ft0, 0(t0)
    fsd ft0, 464(s0)
    fld ft0, 464(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 472(s0)
    fld ft3, 472(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 480(s0)
    fld ft3, 480(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 488(s0)
    fld ft0, 488(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 496(s0)
    fld ft0, 480(s0)
    fld ft1, 496(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 504(s0)
    addi t0, s0, 16
    sw t0, 512(s0)
    lw t0, 512(s0)
    fld ft0, 0(t0)
    fsd ft0, 520(s0)
    fld ft0, 504(s0)
    fld ft1, 520(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 528(s0)
    fld ft3, 528(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 536(s0)
    fld fa0, 536(s0)
    jal ra, decimal_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 544(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 552(s0)
    fld ft0, 400(s0)
    fsd ft0, 560(s0)
.L_mostrarHistorial_L78:
    fld ft3, 560(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 568(s0)
    fld ft0, 568(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 576(s0)
    fld ft0, 576(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_34
    j .L_mostrarHistorial_L79
.L_rama_larga_34:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 568(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 560(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 560(s0)
    j .L_mostrarHistorial_L78
.L_mostrarHistorial_L79:
    fld ft0, 544(s0)
    fsd ft0, 584(s0)
.L_mostrarHistorial_L80:
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
    beqz t0, .L_rama_larga_35
    j .L_mostrarHistorial_L81
.L_rama_larga_35:
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
    j .L_mostrarHistorial_L80
.L_mostrarHistorial_L81:
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
.L_mostrarHistorial_L68:
    addi t0, s0, 16
    sw t0, 608(s0)
    lw t0, 608(s0)
    fld ft0, 0(t0)
    fsd ft0, 616(s0)
    fld ft0, 616(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 624(s0)
    addi t0, s0, 16
    sw t0, 632(s0)
    lw t0, 632(s0)
    fld ft0, 624(s0)
    fsd ft0, 0(t0)
    j .L_mostrarHistorial_L67
.L_mostrarHistorial_L69:
.L_mostrarHistorial_L57:
.L_fin_mostrarHistorial:
    fld fa0, 0(s0)
    lw t0, 648(s0)
    lw ra, 652(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 656
    ret

promedioHistorial:
    addi sp, sp, -384
    sw ra, 380(sp)
    sw s0, 376(sp)
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
    fld ft0, 56(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 64(s0)
    fld ft0, 64(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_36
    j .L_promedioHistorial_L83
.L_rama_larga_36:
    addi t0, s0, 0
    sw t0, 72(s0)
    lw t0, 72(s0)
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    j .L_fin_promedioHistorial
    j .L_promedioHistorial_L82
.L_promedioHistorial_L83:
.L_promedioHistorial_L82:
    addi t0, s0, 16
    sw t0, 80(s0)
    lw t0, 80(s0)
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 88(s0)
    lw t0, 88(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_promedioHistorial_L84:
    addi t0, s0, 24
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
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
    fld ft0, 104(s0)
    fld ft1, 136(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 144(s0)
    fld ft0, 144(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_37
    j .L_promedioHistorial_L86
.L_rama_larga_37:
    addi t0, s0, 16
    sw t0, 152(s0)
    lw t0, 152(s0)
    fld ft0, 0(t0)
    fsd ft0, 160(s0)
    addi t0, s0, 8
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    fld ft0, 176(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 184(s0)
    fld ft3, 184(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    fld ft3, 192(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    fld ft0, 200(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 208(s0)
    fld ft0, 192(s0)
    fld ft1, 208(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    addi t0, s0, 24
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 216(s0)
    fld ft1, 232(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 240(s0)
    fld ft3, 240(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 248(s0)
    fld ft0, 160(s0)
    fld ft1, 248(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    addi t0, s0, 16
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 256(s0)
    fsd ft0, 0(t0)
.L_promedioHistorial_L85:
    addi t0, s0, 24
    sw t0, 272(s0)
    lw t0, 272(s0)
    fld ft0, 0(t0)
    fsd ft0, 280(s0)
    fld ft0, 280(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 288(s0)
    addi t0, s0, 24
    sw t0, 296(s0)
    lw t0, 296(s0)
    fld ft0, 288(s0)
    fsd ft0, 0(t0)
    j .L_promedioHistorial_L84
.L_promedioHistorial_L86:
    addi t0, s0, 16
    sw t0, 304(s0)
    lw t0, 304(s0)
    fld ft0, 0(t0)
    fsd ft0, 312(s0)
    addi t0, s0, 8
    sw t0, 320(s0)
    lw t0, 320(s0)
    fld ft0, 0(t0)
    fsd ft0, 328(s0)
    fld ft0, 328(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 336(s0)
    fld ft3, 336(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 344(s0)
    fld ft0, 312(s0)
    fld ft1, 344(s0)
    fdiv.d ft2, ft0, ft1
    fsd ft2, 352(s0)
    addi t0, s0, 0
    sw t0, 360(s0)
    lw t0, 360(s0)
    fld ft0, 352(s0)
    fsd ft0, 0(t0)
    j .L_fin_promedioHistorial
.L_fin_promedioHistorial:
    fld fa0, 0(s0)
    lw t0, 376(s0)
    lw ra, 380(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 384
    ret

pedirNumero:
    addi sp, sp, -96
    sw ra, 92(sp)
    sw s0, 88(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 24(s0)
    lw t0, 24(s0)
    fld ft0, 0(t0)
    fsd ft0, 32(s0)
    fld ft0, 32(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, solicitud_double
    li a7, 4
    ecall
    li a7, 7
    ecall
    fsd fa0, 40(s0)
    addi t0, s0, 16
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 40(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    addi t0, s0, 0
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 64(s0)
    fsd ft0, 0(t0)
    j .L_fin_pedirNumero
.L_fin_pedirNumero:
    fld fa0, 0(s0)
    lw t0, 88(s0)
    lw ra, 92(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 96
    ret

imprimirMenu:
    addi sp, sp, -96
    sw ra, 92(sp)
    sw s0, 88(sp)
    mv s0, sp
    fcvt.d.w ft0, s2
    fsd ft0, 8(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 8(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    fcvt.d.w ft0, s2
    fsd ft0, 16(s0)
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
    li t6, 32
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
    li t6, 76
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
    li t6, 85
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
    li t6, 65
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
    li t6, 65
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
    fld ft0, 16(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    fcvt.d.w ft0, s2
    fsd ft0, 24(s0)
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
    li t6, 49
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
    li t6, 83
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
    li t6, 109
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
    li t6, 50
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
    li t6, 82
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
    fld ft0, 24(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    fcvt.d.w ft0, s2
    fsd ft0, 32(s0)
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
    li t6, 51
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
    li t6, 77
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
    li t6, 112
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
    li t6, 52
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
    li t6, 68
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
    fld ft0, 32(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
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
    li t6, 53
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
    li t6, 80
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
    li t6, 54
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
    li t6, 108
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
    fld ft0, 40(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    fcvt.d.w ft0, s2
    fsd ft0, 48(s0)
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
    li t6, 55
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
    li t6, 83
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
    li t6, 32
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
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
    li t6, 105
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
    li t6, 56
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
    li t6, 69
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
    li t6, 109
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
    li t6, 63
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
    fld ft0, 48(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
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
    li t6, 57
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
    li t6, 77
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
    li t6, 68
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
    li t6, 49
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
    li t6, 115
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
    li t6, 109
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
    li t6, 47
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
    li t6, 97
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 120
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
    fld ft0, 56(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    fcvt.d.w ft0, s2
    fsd ft0, 64(s0)
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
    li t6, 49
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
    li t6, 72
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
    li t6, 49
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 50
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
    li t6, 68
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
    li t6, 121
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
    li t6, 117
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
    li t6, 105
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 64(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
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
    li t6, 48
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
    li t6, 83
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
    fld ft0, 72(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    fcvt.d.w ft0, s2
    fsd ft0, 80(s0)
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
    fld ft0, 80(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
.L_fin_imprimirMenu:
    fld fa0, 0(s0)
    lw t0, 88(s0)
    lw ra, 92(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 96
    ret

main_pig:
    li t6, -3152
    add sp, sp, t6
    li t6, 3148
    add t6, sp, t6
    sw ra, 0(t6)
    li t6, 3144
    add t6, sp, t6
    sw s0, 0(t6)
    mv s0, sp
    addi t0, s0, 0
    sw t0, 160(s0)
    lw t0, 160(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 168(s0)
    lw t0, 168(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 176(s0)
    lw t0, 176(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 184(s0)
    lw t0, 184(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 32
    sw t0, 192(s0)
    lw t0, 192(s0)
    li t6, 3
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 40
    sw t0, 200(s0)
    lw t0, 200(s0)
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    addi t0, s0, 48
    sw t0, 208(s0)
    lw t0, 208(s0)
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    addi t0, s0, 56
    sw t0, 216(s0)
    lw t0, 216(s0)
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    addi t0, s0, 64
    sw t0, 224(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 232(s0)
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
    lw t0, 224(s0)
    fld ft0, 232(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 72
    sw t0, 240(s0)
    lw t0, 240(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 248(s0)
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
    li t6, 10
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 256(s0)
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
    fld ft0, 256(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 264(s0)
    fld ft3, 264(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 256(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 272(s0)
    fld ft3, 272(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 256(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 280(s0)
    fld ft3, 280(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 256(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 288(s0)
    fld ft3, 288(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 256(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 296(s0)
    fld ft3, 296(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 256(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 304(s0)
    fld ft3, 304(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 256(s0)
    li t6, 6
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 312(s0)
    fld ft3, 312(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 256(s0)
    li t6, 7
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 320(s0)
    fld ft3, 320(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 256(s0)
    li t6, 8
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 328(s0)
    fld ft3, 328(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 256(s0)
    li t6, 9
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 336(s0)
    fld ft3, 336(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    addi t0, s0, 80
    sw t0, 344(s0)
    lw t0, 344(s0)
    fld ft0, 248(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 352(s0)
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
    li t6, 10
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 360(s0)
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
    fld ft0, 360(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 368(s0)
    fld ft3, 368(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 360(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 376(s0)
    fld ft3, 376(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 360(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 384(s0)
    fld ft3, 384(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 360(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 392(s0)
    fld ft3, 392(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 360(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 400(s0)
    fld ft3, 400(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 360(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 408(s0)
    fld ft3, 408(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 360(s0)
    li t6, 6
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 416(s0)
    fld ft3, 416(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 360(s0)
    li t6, 7
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 424(s0)
    fld ft3, 424(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 360(s0)
    li t6, 8
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 432(s0)
    fld ft3, 432(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld ft0, 360(s0)
    li t6, 9
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 440(s0)
    fld ft3, 440(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    la t6, decimal_riscv_0
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    addi t0, s0, 88
    sw t0, 448(s0)
    lw t0, 448(s0)
    fld ft0, 352(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 96
    sw t0, 456(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 464(s0)
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
    lw t0, 456(s0)
    fld ft0, 464(s0)
    fsd ft0, 0(t0)
    fld ft0, 464(s0)
    li t6, 0
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
    addi t0, s0, 88
    sw t0, 480(s0)
    lw t0, 480(s0)
    fld ft0, 0(t0)
    fsd ft0, 488(s0)
    fld ft0, 464(s0)
    li t6, 1
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
    fld ft0, 504(s0)
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
    fsd ft0, 512(s0)
    addi t0, s0, 64
    sw t0, 520(s0)
    lw t0, 520(s0)
    fld ft0, 512(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 528(s0)
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
    fld ft0, 528(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 64
    sw t0, 536(s0)
    lw t0, 536(s0)
    fld ft0, 0(t0)
    fsd ft0, 544(s0)
    fld ft0, 544(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
.L_main_pig_L1:
    addi t0, s0, 32
    sw t0, 552(s0)
    lw t0, 552(s0)
    fld ft0, 0(t0)
    fsd ft0, 560(s0)
    fld ft0, 560(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 568(s0)
    fld ft0, 568(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_38
    j .L_main_pig_L2
.L_rama_larga_38:
    fcvt.d.w ft0, s2
    fsd ft0, 576(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 576(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 32
    sw t0, 584(s0)
    lw t0, 584(s0)
    fld ft0, 0(t0)
    fsd ft0, 592(s0)
    fld ft0, 592(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 32
    sw t0, 600(s0)
    lw t0, 600(s0)
    fld ft0, 0(t0)
    fsd ft0, 608(s0)
    fld ft0, 608(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 616(s0)
    addi t0, s0, 32
    sw t0, 624(s0)
    lw t0, 624(s0)
    fld ft0, 616(s0)
    fsd ft0, 0(t0)
    j .L_main_pig_L1
.L_main_pig_L2:
.L_main_pig_L3:
    addi t0, s0, 128
    sw t0, 632(s0)
    jal ra, imprimirMenu
    fsd fa0, 128(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 640(s0)
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
    li t6, 111
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
    fld ft0, 640(s0)
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
    fsd ft0, 648(s0)
    addi t0, s0, 0
    sw t0, 656(s0)
    lw t0, 656(s0)
    fld ft0, 648(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 0
    sw t0, 664(s0)
    lw t0, 664(s0)
    fld ft0, 0(t0)
    fsd ft0, 672(s0)
    fld ft0, 672(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 680(s0)
    addi t0, s0, 0
    sw t0, 688(s0)
    lw t0, 688(s0)
    fld ft0, 0(t0)
    fsd ft0, 696(s0)
    fld ft0, 696(s0)
    li t6, 12
    fcvt.d.w ft1, t6
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 704(s0)
    fld ft0, 680(s0)
    fld ft1, 704(s0)
    fcvt.w.d t0, ft0
    fcvt.w.d t1, ft1
    snez t0, t0
    snez t1, t1
    or t2, t0, t1
    snez t2, t2
    fcvt.d.w ft2, t2
    fsd ft2, 712(s0)
    fld ft0, 712(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_39
    j .L_main_pig_L6
.L_rama_larga_39:
    fcvt.d.w ft0, s2
    fsd ft0, 720(s0)
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
    li t6, 112
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
    li t6, 101
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
    fld ft0, 720(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    j .L_main_pig_L4
.L_main_pig_L6:
    addi t0, s0, 0
    sw t0, 728(s0)
    lw t0, 728(s0)
    fld ft0, 0(t0)
    fsd ft0, 736(s0)
    fld ft0, 736(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fle.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 744(s0)
    addi t0, s0, 0
    sw t0, 752(s0)
    lw t0, 752(s0)
    fld ft0, 0(t0)
    fsd ft0, 760(s0)
    fld ft0, 760(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fle.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 768(s0)
    fld ft0, 744(s0)
    fld ft1, 768(s0)
    fcvt.w.d t0, ft0
    fcvt.w.d t1, ft1
    snez t0, t0
    snez t1, t1
    and t2, t0, t1
    snez t2, t2
    fcvt.d.w ft2, t2
    fsd ft2, 776(s0)
    fld ft0, 776(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_40
    j .L_main_pig_L8
.L_rama_larga_40:
    fcvt.d.w ft0, s2
    fsd ft0, 784(s0)
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
    li t6, 105
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
    addi t0, s0, 128
    sw t0, 792(s0)
    lw t0, 792(s0)
    addi t0, t0, 8
    sw t0, 800(s0)
    lw t0, 800(s0)
    fld ft0, 784(s0)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    jal ra, pedirNumero
    fsd fa0, 128(s0)
    addi t0, s0, 128
    sw t0, 808(s0)
    lw t0, 808(s0)
    fld ft0, 0(t0)
    fsd ft0, 816(s0)
    addi t0, s0, 40
    sw t0, 824(s0)
    lw t0, 824(s0)
    fld ft0, 816(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 832(s0)
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
    addi t0, s0, 128
    sw t0, 840(s0)
    lw t0, 840(s0)
    addi t0, t0, 8
    sw t0, 848(s0)
    lw t0, 848(s0)
    fld ft0, 832(s0)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    jal ra, pedirNumero
    fsd fa0, 128(s0)
    addi t0, s0, 128
    sw t0, 856(s0)
    lw t0, 856(s0)
    fld ft0, 0(t0)
    fsd ft0, 864(s0)
    addi t0, s0, 48
    sw t0, 872(s0)
    lw t0, 872(s0)
    fld ft0, 864(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 0
    sw t0, 880(s0)
    lw t0, 880(s0)
    fld ft0, 0(t0)
    fsd ft0, 888(s0)
    addi t0, s0, 40
    sw t0, 896(s0)
    lw t0, 896(s0)
    fld ft0, 0(t0)
    fsd ft0, 904(s0)
    addi t0, s0, 48
    sw t0, 912(s0)
    lw t0, 912(s0)
    fld ft0, 0(t0)
    fsd ft0, 920(s0)
    addi t0, s0, 128
    sw t0, 928(s0)
    lw t0, 928(s0)
    addi t0, t0, 8
    sw t0, 936(s0)
    lw t0, 936(s0)
    fld ft0, 888(s0)
    fsd ft0, 0(t0)
    lw t0, 928(s0)
    addi t0, t0, 16
    sw t0, 944(s0)
    lw t0, 944(s0)
    fld ft0, 904(s0)
    fsd ft0, 0(t0)
    lw t0, 928(s0)
    addi t0, t0, 24
    sw t0, 952(s0)
    lw t0, 952(s0)
    fld ft0, 920(s0)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    fld fa1, 144(s0)
    fld fa2, 152(s0)
    jal ra, aplicar
    fsd fa0, 128(s0)
    addi t0, s0, 128
    sw t0, 960(s0)
    lw t0, 960(s0)
    fld ft0, 0(t0)
    fsd ft0, 968(s0)
    addi t0, s0, 56
    sw t0, 976(s0)
    lw t0, 976(s0)
    fld ft0, 968(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 984(s0)
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
    fld ft0, 984(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 56
    sw t0, 992(s0)
    lw t0, 992(s0)
    fld ft0, 0(t0)
    fsd ft0, 1000(s0)
    fld fa0, 1000(s0)
    li a7, 3
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 96
    sw t0, 1008(s0)
    lw t0, 1008(s0)
    fld ft0, 0(t0)
    fsd ft0, 1016(s0)
    addi t0, s0, 56
    sw t0, 1024(s0)
    lw t0, 1024(s0)
    fld ft0, 0(t0)
    fsd ft0, 1032(s0)
    addi t0, s0, 128
    sw t0, 1040(s0)
    lw t0, 1040(s0)
    addi t0, t0, 8
    sw t0, 1048(s0)
    lw t0, 1048(s0)
    fld ft0, 1016(s0)
    fsd ft0, 0(t0)
    lw t0, 1040(s0)
    addi t0, t0, 16
    sw t0, 1056(s0)
    lw t0, 1056(s0)
    fld ft0, 1032(s0)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    fld fa1, 144(s0)
    jal ra, registrar
    fsd fa0, 128(s0)
    j .L_main_pig_L9
.L_main_pig_L8:
    addi t0, s0, 0
    sw t0, 1064(s0)
    lw t0, 1064(s0)
    fld ft0, 0(t0)
    fsd ft0, 1072(s0)
    fld ft0, 1072(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1080(s0)
    fld ft0, 1080(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_41
    j .L_main_pig_L10
.L_rama_larga_41:
    fcvt.d.w ft0, s2
    fsd ft0, 1088(s0)
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
    li t6, 98
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
    addi t0, s0, 128
    sw t0, 1096(s0)
    lw t0, 1096(s0)
    addi t0, t0, 8
    sw t0, 1104(s0)
    lw t0, 1104(s0)
    fld ft0, 1088(s0)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    jal ra, pedirNumero
    fsd fa0, 128(s0)
    addi t0, s0, 128
    sw t0, 1112(s0)
    lw t0, 1112(s0)
    fld ft0, 0(t0)
    fsd ft0, 1120(s0)
    addi t0, s0, 40
    sw t0, 1128(s0)
    lw t0, 1128(s0)
    fld ft0, 1120(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 1136(s0)
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
    li t6, 101
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 120
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
    li t6, 40
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
    fld ft0, 1136(s0)
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
    fsd ft0, 1144(s0)
    addi t0, s0, 8
    sw t0, 1152(s0)
    lw t0, 1152(s0)
    fld ft0, 1144(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 40
    sw t0, 1160(s0)
    lw t0, 1160(s0)
    fld ft0, 0(t0)
    fsd ft0, 1168(s0)
    addi t0, s0, 8
    sw t0, 1176(s0)
    lw t0, 1176(s0)
    fld ft0, 0(t0)
    fsd ft0, 1184(s0)
    addi t0, s0, 128
    sw t0, 1192(s0)
    lw t0, 1192(s0)
    addi t0, t0, 8
    sw t0, 1200(s0)
    lw t0, 1200(s0)
    fld ft0, 1168(s0)
    fsd ft0, 0(t0)
    lw t0, 1192(s0)
    addi t0, t0, 16
    sw t0, 1208(s0)
    lw t0, 1208(s0)
    fld ft0, 1184(s0)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    fld fa1, 144(s0)
    jal ra, potencia
    fsd fa0, 128(s0)
    addi t0, s0, 128
    sw t0, 1216(s0)
    lw t0, 1216(s0)
    fld ft0, 0(t0)
    fsd ft0, 1224(s0)
    addi t0, s0, 56
    sw t0, 1232(s0)
    lw t0, 1232(s0)
    fld ft0, 1224(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 40
    sw t0, 1240(s0)
    lw t0, 1240(s0)
    fld ft0, 0(t0)
    fsd ft0, 1248(s0)
    fld fa0, 1248(s0)
    li a7, 3
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 1256(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1256(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 8
    sw t0, 1264(s0)
    lw t0, 1264(s0)
    fld ft0, 0(t0)
    fsd ft0, 1272(s0)
    fld ft0, 1272(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 1280(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1280(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 56
    sw t0, 1288(s0)
    lw t0, 1288(s0)
    fld ft0, 0(t0)
    fsd ft0, 1296(s0)
    fld fa0, 1296(s0)
    li a7, 3
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 96
    sw t0, 1304(s0)
    lw t0, 1304(s0)
    fld ft0, 0(t0)
    fsd ft0, 1312(s0)
    addi t0, s0, 56
    sw t0, 1320(s0)
    lw t0, 1320(s0)
    fld ft0, 0(t0)
    fsd ft0, 1328(s0)
    addi t0, s0, 128
    sw t0, 1336(s0)
    lw t0, 1336(s0)
    addi t0, t0, 8
    sw t0, 1344(s0)
    lw t0, 1344(s0)
    fld ft0, 1312(s0)
    fsd ft0, 0(t0)
    lw t0, 1336(s0)
    addi t0, t0, 16
    sw t0, 1352(s0)
    lw t0, 1352(s0)
    fld ft0, 1328(s0)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    fld fa1, 144(s0)
    jal ra, registrar
    fsd fa0, 128(s0)
    j .L_main_pig_L11
.L_main_pig_L10:
    addi t0, s0, 0
    sw t0, 1360(s0)
    lw t0, 1360(s0)
    fld ft0, 0(t0)
    fsd ft0, 1368(s0)
    fld ft0, 1368(s0)
    li t6, 6
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1376(s0)
    fld ft0, 1376(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_42
    j .L_main_pig_L12
.L_rama_larga_42:
    fcvt.d.w ft0, s2
    fsd ft0, 1384(s0)
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
    li t6, 108
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
    fld ft0, 1384(s0)
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
    fsd ft0, 1392(s0)
    addi t0, s0, 8
    sw t0, 1400(s0)
    lw t0, 1400(s0)
    fld ft0, 1392(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 1408(s0)
    lw t0, 1408(s0)
    fld ft0, 0(t0)
    fsd ft0, 1416(s0)
    fld ft0, 1416(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1424(s0)
    fld ft0, 1424(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_43
    j .L_main_pig_L14
.L_rama_larga_43:
    fcvt.d.w ft0, s2
    fsd ft0, 1432(s0)
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
    li t6, 120
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
    li t6, 102
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
    li t6, 101
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
    li t6, 118
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
    fld ft0, 1432(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    j .L_main_pig_L15
.L_main_pig_L14:
    addi t0, s0, 8
    sw t0, 1440(s0)
    lw t0, 1440(s0)
    fld ft0, 0(t0)
    fsd ft0, 1448(s0)
    fld ft0, 1448(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 1456(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1456(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 8
    sw t0, 1464(s0)
    lw t0, 1464(s0)
    fld ft0, 0(t0)
    fsd ft0, 1472(s0)
    addi t0, s0, 128
    sw t0, 1480(s0)
    lw t0, 1480(s0)
    addi t0, t0, 8
    sw t0, 1488(s0)
    lw t0, 1488(s0)
    fld ft0, 1472(s0)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    jal ra, factorial
    fsd fa0, 128(s0)
    addi t0, s0, 128
    sw t0, 1496(s0)
    lw t0, 1496(s0)
    fld ft0, 0(t0)
    fsd ft0, 1504(s0)
    fld ft0, 1504(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 96
    sw t0, 1512(s0)
    lw t0, 1512(s0)
    fld ft0, 0(t0)
    fsd ft0, 1520(s0)
    addi t0, s0, 8
    sw t0, 1528(s0)
    lw t0, 1528(s0)
    fld ft0, 0(t0)
    fsd ft0, 1536(s0)
    addi t0, s0, 128
    sw t0, 1544(s0)
    lw t0, 1544(s0)
    addi t0, t0, 8
    sw t0, 1552(s0)
    lw t0, 1552(s0)
    fld ft0, 1536(s0)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    jal ra, factorial
    fsd fa0, 128(s0)
    addi t0, s0, 128
    sw t0, 1560(s0)
    lw t0, 1560(s0)
    fld ft0, 0(t0)
    fsd ft0, 1568(s0)
    addi t0, s0, 128
    sw t0, 1576(s0)
    lw t0, 1576(s0)
    addi t0, t0, 8
    sw t0, 1584(s0)
    lw t0, 1584(s0)
    fld ft0, 1520(s0)
    fsd ft0, 0(t0)
    lw t0, 1576(s0)
    addi t0, t0, 16
    sw t0, 1592(s0)
    lw t0, 1592(s0)
    fld ft0, 1568(s0)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    fld fa1, 144(s0)
    jal ra, registrar
    fsd fa0, 128(s0)
.L_main_pig_L15:
    j .L_main_pig_L13
.L_main_pig_L12:
    addi t0, s0, 0
    sw t0, 1600(s0)
    lw t0, 1600(s0)
    fld ft0, 0(t0)
    fsd ft0, 1608(s0)
    fld ft0, 1608(s0)
    li t6, 7
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1616(s0)
    fld ft0, 1616(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_44
    j .L_main_pig_L16
.L_rama_larga_44:
    fcvt.d.w ft0, s2
    fsd ft0, 1624(s0)
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
    li t6, 70
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
    li t6, 98
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
    li t6, 50
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
    fld ft0, 1624(s0)
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
    fsd ft0, 1632(s0)
    addi t0, s0, 8
    sw t0, 1640(s0)
    lw t0, 1640(s0)
    fld ft0, 1632(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 1648(s0)
    lw t0, 1648(s0)
    fld ft0, 0(t0)
    fsd ft0, 1656(s0)
    fld ft0, 1656(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1664(s0)
    addi t0, s0, 8
    sw t0, 1672(s0)
    lw t0, 1672(s0)
    fld ft0, 0(t0)
    fsd ft0, 1680(s0)
    fld ft0, 1680(s0)
    li t6, 20
    fcvt.d.w ft1, t6
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 1688(s0)
    fld ft0, 1664(s0)
    fld ft1, 1688(s0)
    fcvt.w.d t0, ft0
    fcvt.w.d t1, ft1
    snez t0, t0
    snez t1, t1
    or t2, t0, t1
    snez t2, t2
    fcvt.d.w ft2, t2
    fsd ft2, 1696(s0)
    fld ft0, 1696(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_45
    j .L_main_pig_L18
.L_rama_larga_45:
    fcvt.d.w ft0, s2
    fsd ft0, 1704(s0)
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
    j .L_main_pig_L19
.L_main_pig_L18:
    addi t0, s0, 104
    sw t0, 1712(s0)
    lw t0, 1712(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_main_pig_L20:
    addi t0, s0, 112
    sw t0, 1720(s0)
    lw t0, 1720(s0)
    fld ft0, 0(t0)
    fsd ft0, 1728(s0)
    addi t0, s0, 8
    sw t0, 1736(s0)
    lw t0, 1736(s0)
    fld ft0, 0(t0)
    fsd ft0, 1744(s0)
    fld ft0, 1728(s0)
    fld ft1, 1744(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1752(s0)
    fld ft0, 1752(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_46
    j .L_main_pig_L22
.L_rama_larga_46:
    fcvt.d.w ft0, s2
    fsd ft0, 1760(s0)
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
    li t6, 40
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
    fld ft0, 1760(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 112
    sw t0, 1768(s0)
    lw t0, 1768(s0)
    fld ft0, 0(t0)
    fsd ft0, 1776(s0)
    fld ft0, 1776(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 1784(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1784(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 112
    sw t0, 1792(s0)
    lw t0, 1792(s0)
    fld ft0, 0(t0)
    fsd ft0, 1800(s0)
    addi t0, s0, 128
    sw t0, 1808(s0)
    lw t0, 1808(s0)
    addi t0, t0, 8
    sw t0, 1816(s0)
    lw t0, 1816(s0)
    fld ft0, 1800(s0)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    jal ra, fibonacci
    fsd fa0, 128(s0)
    addi t0, s0, 128
    sw t0, 1824(s0)
    lw t0, 1824(s0)
    fld ft0, 0(t0)
    fsd ft0, 1832(s0)
    fld ft0, 1832(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
.L_main_pig_L21:
    addi t0, s0, 112
    sw t0, 1840(s0)
    lw t0, 1840(s0)
    fld ft0, 0(t0)
    fsd ft0, 1848(s0)
    fld ft0, 1848(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1856(s0)
    lw t0, 1840(s0)
    fld ft0, 1856(s0)
    fsd ft0, 0(t0)
    j .L_main_pig_L20
.L_main_pig_L22:
.L_main_pig_L19:
    j .L_main_pig_L17
.L_main_pig_L16:
    addi t0, s0, 0
    sw t0, 1864(s0)
    lw t0, 1864(s0)
    fld ft0, 0(t0)
    fsd ft0, 1872(s0)
    fld ft0, 1872(s0)
    li t6, 8
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1880(s0)
    fld ft0, 1880(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_47
    j .L_main_pig_L23
.L_rama_larga_47:
    fcvt.d.w ft0, s2
    fsd ft0, 1888(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1888(s0)
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
    fsd ft0, 1896(s0)
    addi t0, s0, 8
    sw t0, 1904(s0)
    lw t0, 1904(s0)
    fld ft0, 1896(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 1912(s0)
    lw t0, 1912(s0)
    fld ft0, 0(t0)
    fsd ft0, 1920(s0)
    addi t0, s0, 128
    sw t0, 1928(s0)
    lw t0, 1928(s0)
    addi t0, t0, 8
    sw t0, 1936(s0)
    lw t0, 1936(s0)
    fld ft0, 1920(s0)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    jal ra, esPrimo
    fsd fa0, 128(s0)
    addi t0, s0, 128
    sw t0, 1944(s0)
    lw t0, 1944(s0)
    fld ft0, 0(t0)
    fsd ft0, 1952(s0)
    addi t0, s0, 72
    sw t0, 1960(s0)
    lw t0, 1960(s0)
    fld ft0, 1952(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 72
    sw t0, 1968(s0)
    lw t0, 1968(s0)
    fld ft0, 0(t0)
    fsd ft0, 1976(s0)
    fld ft0, 1976(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1984(s0)
    fld ft0, 1984(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_48
    j .L_main_pig_L25
.L_rama_larga_48:
    addi t0, s0, 8
    sw t0, 1992(s0)
    lw t0, 1992(s0)
    fld ft0, 0(t0)
    fsd ft0, 2000(s0)
    fld ft0, 2000(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 2008(s0)
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
    li t6, 109
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
    fld ft0, 2008(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    j .L_main_pig_L26
.L_main_pig_L25:
    addi t0, s0, 8
    sw t0, 2016(s0)
    lw t0, 2016(s0)
    fld ft0, 0(t0)
    fsd ft0, 2024(s0)
    fld ft0, 2024(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 2032(s0)
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
    li t6, 109
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
    fld ft0, 2032(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
.L_main_pig_L26:
    j .L_main_pig_L24
.L_main_pig_L23:
    addi t0, s0, 0
    sw t0, 2040(s0)
    lw t0, 2040(s0)
    fld ft0, 0(t0)
    li t6, 2048
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2048
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 9
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    li t6, 2056
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2056
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_49
    j .L_main_pig_L27
.L_rama_larga_49:
    fcvt.d.w ft0, s2
    li t6, 2064
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 105
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
    li t6, 2064
    add t6, s0, t6
    fld ft0, 0(t6)
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
    li t6, 2072
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 8
    li t6, 2080
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2080
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2072
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    li t6, 2088
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    li t6, 2088
    add t6, s0, t6
    fld ft0, 0(t6)
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
    li t6, 2096
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 16
    li t6, 2104
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2104
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2096
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    li t6, 2112
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 67
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
    li t6, 40
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
    li t6, 2112
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 8
    li t6, 2120
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2120
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2128
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2128
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    li t6, 2136
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 2136
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 16
    li t6, 2144
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2144
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2152
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2152
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    li t6, 2160
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    li t6, 2160
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 8
    li t6, 2168
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2168
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2176
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 16
    li t6, 2184
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2184
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2192
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 128
    li t6, 2200
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2200
    add t6, s0, t6
    lw t0, 0(t6)
    addi t0, t0, 8
    li t6, 2208
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2208
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2176
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    li t6, 2200
    add t6, s0, t6
    lw t0, 0(t6)
    addi t0, t0, 16
    li t6, 2216
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2216
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2192
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    fld fa1, 144(s0)
    jal ra, mcd
    fsd fa0, 128(s0)
    addi t0, s0, 128
    li t6, 2224
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2224
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2232
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2232
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    j .L_main_pig_L28
.L_main_pig_L27:
    addi t0, s0, 0
    li t6, 2240
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2240
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2248
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2248
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 10
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    li t6, 2256
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2256
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_50
    j .L_main_pig_L29
.L_rama_larga_50:
    addi t0, s0, 24
    li t6, 2264
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2264
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    li t6, 2272
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 49
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
    li t6, 2272
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 112
    li t6, 2280
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2280
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_main_pig_L31:
    addi t0, s0, 112
    li t6, 2288
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2288
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2296
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2296
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 10
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    li t6, 2304
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2304
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_51
    j .L_main_pig_L33
.L_rama_larga_51:
    la a0, solicitud_double
    li a7, 4
    ecall
    li a7, 7
    ecall
    li t6, 2312
    add t6, s0, t6
    fsd fa0, 0(t6)
    addi t0, s0, 40
    li t6, 2320
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2320
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2312
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    addi t0, s0, 40
    li t6, 2328
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2328
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2336
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2336
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    li t6, 2344
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2344
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_52
    j .L_main_pig_L34
.L_rama_larga_52:
    j .L_main_pig_L33
.L_main_pig_L34:
    addi t0, s0, 40
    li t6, 2352
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2352
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2360
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 80
    li t6, 2368
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2368
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2376
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 112
    li t6, 2384
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2384
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2392
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2376
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    li t6, 2400
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2400
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 2392
    add t6, s0, t6
    fld ft1, 0(t6)
    fadd.d ft2, ft0, ft1
    li t6, 2408
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2408
    add t6, s0, t6
    fld ft3, 0(t6)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 2360
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    li t6, 2416
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2416
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2424
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2424
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    li t6, 2432
    add t6, s0, t6
    fsd ft2, 0(t6)
    addi t0, s0, 24
    li t6, 2440
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2440
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2432
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
.L_main_pig_L32:
    addi t0, s0, 112
    li t6, 2448
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2448
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2456
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2456
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    li t6, 2464
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2448
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2464
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    j .L_main_pig_L31
.L_main_pig_L33:
    addi t0, s0, 24
    li t6, 2472
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2472
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2480
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2480
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    li t6, 2488
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2488
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_53
    j .L_main_pig_L36
.L_rama_larga_53:
    fcvt.d.w ft0, s2
    li t6, 2496
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 115
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
    li t6, 2496
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    j .L_main_pig_L37
.L_main_pig_L36:
    fcvt.d.w ft0, s2
    li t6, 2504
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 100
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
    li t6, 2504
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 24
    li t6, 2512
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2512
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2520
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2520
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    li t6, 2528
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 117
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
    li t6, 2528
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 80
    li t6, 2536
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2536
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2544
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 24
    li t6, 2552
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2552
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2560
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 128
    li t6, 2568
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2568
    add t6, s0, t6
    lw t0, 0(t6)
    addi t0, t0, 8
    li t6, 2576
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2576
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2544
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    li t6, 2568
    add t6, s0, t6
    lw t0, 0(t6)
    addi t0, t0, 16
    li t6, 2584
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2584
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2560
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    fld fa1, 144(s0)
    jal ra, sumarArreglo
    fsd fa0, 128(s0)
    addi t0, s0, 128
    li t6, 2592
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2592
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2600
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2600
    add t6, s0, t6
    fld fa0, 0(t6)
    li a7, 3
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    li t6, 2608
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 120
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
    li t6, 109
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
    li t6, 2608
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 80
    li t6, 2616
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2616
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2624
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 24
    li t6, 2632
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2632
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2640
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 128
    li t6, 2648
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2648
    add t6, s0, t6
    lw t0, 0(t6)
    addi t0, t0, 8
    li t6, 2656
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2656
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2624
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    li t6, 2648
    add t6, s0, t6
    lw t0, 0(t6)
    addi t0, t0, 16
    li t6, 2664
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2664
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2640
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    fld fa1, 144(s0)
    jal ra, maximoArreglo
    fsd fa0, 128(s0)
    addi t0, s0, 128
    li t6, 2672
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2672
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2680
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2680
    add t6, s0, t6
    fld fa0, 0(t6)
    li a7, 3
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    li t6, 2688
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 2688
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 80
    li t6, 2696
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2696
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2704
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 24
    li t6, 2712
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2712
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2720
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 128
    li t6, 2728
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2728
    add t6, s0, t6
    lw t0, 0(t6)
    addi t0, t0, 8
    li t6, 2736
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2736
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2704
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    li t6, 2728
    add t6, s0, t6
    lw t0, 0(t6)
    addi t0, t0, 16
    li t6, 2744
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2744
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2720
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    fld fa1, 144(s0)
    jal ra, sumarArreglo
    fsd fa0, 128(s0)
    addi t0, s0, 128
    li t6, 2752
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2752
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2760
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 24
    li t6, 2768
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2768
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2776
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2760
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 2776
    add t6, s0, t6
    fld ft1, 0(t6)
    fdiv.d ft2, ft0, ft1
    li t6, 2784
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2784
    add t6, s0, t6
    fld fa0, 0(t6)
    li a7, 3
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
.L_main_pig_L37:
    j .L_main_pig_L30
.L_main_pig_L29:
    addi t0, s0, 0
    li t6, 2792
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2792
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2800
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2800
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 11
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    li t6, 2808
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2808
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_54
    j .L_main_pig_L38
.L_rama_larga_54:
    addi t0, s0, 96
    li t6, 2816
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2816
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2824
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 128
    li t6, 2832
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2832
    add t6, s0, t6
    lw t0, 0(t6)
    addi t0, t0, 8
    li t6, 2840
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2840
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2824
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    jal ra, mostrarHistorial
    fsd fa0, 128(s0)
    fcvt.d.w ft0, s2
    li t6, 2848
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 104
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
    li t6, 2848
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 96
    li t6, 2856
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2856
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2864
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 128
    li t6, 2872
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2872
    add t6, s0, t6
    lw t0, 0(t6)
    addi t0, t0, 8
    li t6, 2880
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2880
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2864
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    jal ra, promedioHistorial
    fsd fa0, 128(s0)
    addi t0, s0, 128
    li t6, 2888
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2888
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2896
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2896
    add t6, s0, t6
    fld fa0, 0(t6)
    li a7, 3
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    j .L_main_pig_L39
.L_main_pig_L38:
    addi t0, s0, 0
    li t6, 2904
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2904
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2912
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2912
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 12
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    li t6, 2920
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2920
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_55
    j .L_main_pig_L40
.L_rama_larga_55:
    fcvt.d.w ft0, s2
    li t6, 2928
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    li t6, 2928
    add t6, s0, t6
    fld ft0, 0(t6)
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
    li t6, 2936
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 8
    li t6, 2944
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2944
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2936
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    li t6, 2952
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 2952
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 8
    li t6, 2960
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2960
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2968
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 128
    li t6, 2976
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2976
    add t6, s0, t6
    lw t0, 0(t6)
    addi t0, t0, 8
    li t6, 2984
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2984
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2968
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    jal ra, contarDigitos
    fsd fa0, 128(s0)
    addi t0, s0, 128
    li t6, 2992
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2992
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 3000
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 3000
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    li t6, 3008
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 117
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
    li t6, 105
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
    li t6, 32
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    li t6, 3008
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 8
    li t6, 3016
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 3016
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 3024
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 3024
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    li t6, 3032
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 3032
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 8
    li t6, 3040
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 3040
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 3048
    add t6, s0, t6
    fsd ft0, 0(t6)
    addi t0, s0, 128
    li t6, 3056
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 3056
    add t6, s0, t6
    lw t0, 0(t6)
    addi t0, t0, 8
    li t6, 3064
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 3064
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 3048
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    fld fa0, 136(s0)
    jal ra, sumaImpares
    fsd fa0, 128(s0)
    addi t0, s0, 128
    li t6, 3072
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 3072
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 3080
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 3080
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    j .L_main_pig_L41
.L_main_pig_L40:
    fcvt.d.w ft0, s2
    li t6, 3088
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, 108
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
    li t6, 97
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
    li t6, 46
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    li t6, 3088
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
.L_main_pig_L41:
.L_main_pig_L39:
.L_main_pig_L30:
.L_main_pig_L28:
.L_main_pig_L24:
.L_main_pig_L17:
.L_main_pig_L13:
.L_main_pig_L11:
.L_main_pig_L9:
.L_main_pig_L4:
    addi t0, s0, 0
    li t6, 3096
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 3096
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 3104
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 3104
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    li t6, 3112
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 3112
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_56
    j .L_main_pig_L5
.L_rama_larga_56:
    j .L_main_pig_L3
.L_main_pig_L5:
    fcvt.d.w ft0, s2
    li t6, 3120
    add t6, s0, t6
    fsd ft0, 0(t6)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    li t6, 3120
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 64
    li t6, 3128
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 3128
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 3136
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 3136
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
.L_fin_main_pig:
    li t6, 3144
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 3148
    add t6, s0, t6
    lw ra, 0(t6)
    mv sp, s0
    mv s0, t0
    li t6, 3152
    add sp, sp, t6
    ret

