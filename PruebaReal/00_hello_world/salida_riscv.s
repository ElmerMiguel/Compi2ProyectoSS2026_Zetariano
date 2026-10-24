# Codigo RISC-V RV32 generado para RARS
# Puntero de stack en sp, frame pointer en s0 y heap en s1

.data
.align 3
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

saludar:
    addi sp, sp, -32
    sw ra, 28(sp)
    sw s0, 24(sp)
    mv s0, sp
    fcvt.d.w ft0, s2
    fsd ft0, 8(s0)
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
    li t6, 115
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
    li t6, 89
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
    fld ft0, 8(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
.L_fin_saludar:
    fld fa0, 0(s0)
    lw t0, 24(s0)
    lw ra, 28(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 32
    ret

saludarA:
    addi sp, sp, -112
    sw ra, 108(sp)
    sw s0, 104(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 16(s0)
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
    addi t0, s0, 8
    sw t0, 24(s0)
    lw t0, 24(s0)
    fld ft0, 0(t0)
    fsd ft0, 32(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 40(s0)
    fld ft0, 16(s0)
    fsd ft0, 48(s0)
.L_saludarA_L1:
    fld ft3, 48(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 56(s0)
    fld ft0, 56(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 64(s0)
    fld ft0, 64(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_0
    j .L_saludarA_L2
.L_rama_larga_0:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 56(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 48(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 48(s0)
    j .L_saludarA_L1
.L_saludarA_L2:
    fld ft0, 32(s0)
    fsd ft0, 72(s0)
.L_saludarA_L3:
    fld ft3, 72(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    fld ft0, 80(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 88(s0)
    fld ft0, 88(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_1
    j .L_saludarA_L4
.L_rama_larga_1:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 80(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 72(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 72(s0)
    j .L_saludarA_L3
.L_saludarA_L4:
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
.L_fin_saludarA:
    fld fa0, 0(s0)
    lw t0, 104(s0)
    lw ra, 108(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 112
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

Hola__:
    addi sp, sp, -64
    sw ra, 60(sp)
    sw s0, 56(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 16(s0)
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
    li t6, 115
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
    li t6, 90
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
    fld ft0, 16(s0)
    fsd ft0, 0(t0)
.L_fin_Hola__:
    fld fa0, 0(s0)
    lw t0, 56(s0)
    lw ra, 60(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 64
    ret

Hola_decir__:
    addi sp, sp, -64
    sw ra, 60(sp)
    sw s0, 56(sp)
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
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
.L_fin_Hola_decir__:
    fld fa0, 0(s0)
    lw t0, 56(s0)
    lw ra, 60(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 64
    ret

Hola_doble_int_:
    addi sp, sp, -64
    sw ra, 60(sp)
    sw s0, 56(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 16
    sw t0, 24(s0)
    lw t0, 24(s0)
    fld ft0, 0(t0)
    fsd ft0, 32(s0)
    fld ft0, 32(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fmul.d ft2, ft0, ft1
    fsd ft2, 40(s0)
    addi t0, s0, 0
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 40(s0)
    fsd ft0, 0(t0)
    j .L_fin_Hola_doble_int_
.L_fin_Hola_doble_int_:
    fld fa0, 0(s0)
    lw t0, 56(s0)
    lw ra, 60(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 64
    ret

main_pig:
    addi sp, sp, -336
    sw ra, 332(sp)
    sw s0, 328(sp)
    mv s0, sp
    addi t0, s0, 0
    sw t0, 48(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 2255068
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 56(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    lw t0, 48(s0)
    fld ft0, 56(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 64(s0)
    lw t0, 64(s0)
    addi t0, t0, 8
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 56(s0)
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    jal ra, Hola__
    fsd fa0, 24(s0)
    addi t0, s0, 8
    sw t0, 80(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 88(s0)
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
    lw t0, 80(s0)
    fld ft0, 88(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 96(s0)
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
    li t6, 115
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
    li t6, 103
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    li t6, 110
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
    fld ft0, 96(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 24
    sw t0, 104(s0)
    jal ra, saludar
    fsd fa0, 24(s0)
    addi t0, s0, 8
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    addi t0, s0, 24
    sw t0, 128(s0)
    lw t0, 128(s0)
    addi t0, t0, 8
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 120(s0)
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    jal ra, saludarA
    fsd fa0, 24(s0)
    addi t0, s0, 0
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    addi t0, s0, 0
    sw t0, 160(s0)
    lw t0, 160(s0)
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    addi t0, s0, 24
    sw t0, 176(s0)
    lw t0, 176(s0)
    addi t0, t0, 8
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 168(s0)
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    jal ra, Hola_decir__
    fsd fa0, 24(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 192(s0)
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
    fld ft0, 192(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 24
    sw t0, 200(s0)
    lw t0, 200(s0)
    addi t0, t0, 8
    sw t0, 208(s0)
    lw t0, 208(s0)
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 200(s0)
    addi t0, t0, 16
    sw t0, 216(s0)
    lw t0, 216(s0)
    li t6, 3
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    fld fa1, 40(s0)
    jal ra, sumar
    fsd fa0, 24(s0)
    addi t0, s0, 24
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 232(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 240(s0)
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
    li t6, 50
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 240(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 0
    sw t0, 248(s0)
    lw t0, 248(s0)
    fld ft0, 0(t0)
    fsd ft0, 256(s0)
    addi t0, s0, 0
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 0(t0)
    fsd ft0, 272(s0)
    addi t0, s0, 24
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
    li t6, 21
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    fld fa1, 40(s0)
    jal ra, Hola_doble_int_
    fsd fa0, 24(s0)
    addi t0, s0, 24
    sw t0, 304(s0)
    lw t0, 304(s0)
    fld ft0, 0(t0)
    fsd ft0, 312(s0)
    fld ft0, 312(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
.L_fin_main_pig:
    lw t0, 328(s0)
    lw ra, 332(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 336
    ret

