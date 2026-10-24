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

calificar:
    addi sp, sp, -160
    sw ra, 156(sp)
    sw s0, 152(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 8
    sw t0, 16(s0)
    lw t0, 16(s0)
    fld ft0, 0(t0)
    fsd ft0, 24(s0)
    fld ft0, 24(s0)
    li t6, 199
    fcvt.d.w ft1, t6
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 32(s0)
    fld ft0, 32(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_0
    j .L_calificar_L2
.L_rama_larga_0:
    fcvt.d.w ft0, s2
    fsd ft0, 40(s0)
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
    li t6, 101
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
    addi t0, s0, 0
    sw t0, 48(s0)
    lw t0, 48(s0)
    fld ft0, 40(s0)
    fsd ft0, 0(t0)
    j .L_fin_calificar
    j .L_calificar_L1
.L_calificar_L2:
    addi t0, s0, 8
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    fld ft0, 64(s0)
    li t6, 99
    fcvt.d.w ft1, t6
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 72(s0)
    fld ft0, 72(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_1
    j .L_calificar_L3
.L_rama_larga_1:
    fcvt.d.w ft0, s2
    fsd ft0, 80(s0)
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
    li t6, 69
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
    addi t0, s0, 0
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 80(s0)
    fsd ft0, 0(t0)
    j .L_fin_calificar
    j .L_calificar_L1
.L_calificar_L3:
    addi t0, s0, 8
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    fld ft0, 104(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 112(s0)
    fld ft0, 112(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_2
    j .L_calificar_L4
.L_rama_larga_2:
    fcvt.d.w ft0, s2
    fsd ft0, 120(s0)
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
    addi t0, s0, 0
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 120(s0)
    fsd ft0, 0(t0)
    j .L_fin_calificar
    j .L_calificar_L1
.L_calificar_L4:
    fcvt.d.w ft0, s2
    fsd ft0, 136(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 0
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 136(s0)
    fsd ft0, 0(t0)
    j .L_fin_calificar
.L_calificar_L1:
.L_fin_calificar:
    fld fa0, 0(s0)
    lw t0, 152(s0)
    lw ra, 156(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 160
    ret

registrarPartida:
    addi sp, sp, -272
    sw ra, 268(sp)
    sw s0, 264(sp)
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
    li t6, 1
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
    li t6, 3
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 64(s0)
    fld ft0, 64(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_3
    j .L_registrarPartida_L6
.L_rama_larga_3:
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
    j .L_registrarPartida_L5
.L_registrarPartida_L6:
.L_registrarPartida_L5:
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
    fld ft0, 192(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 232(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 240(s0)
    fld ft3, 240(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 248(s0)
    fld ft0, 248(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    fld ft3, 240(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 256(s0)
    fsd ft0, 0(t0)
.L_fin_registrarPartida:
    fld fa0, 0(s0)
    lw t0, 264(s0)
    lw ra, 268(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 272
    ret

mejorPuntaje:
    addi sp, sp, -384
    sw ra, 380(sp)
    sw s0, 376(sp)
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
.L_mejorPuntaje_L7:
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
    bnez t0, .L_rama_larga_4
    j .L_mejorPuntaje_L9
.L_rama_larga_4:
    addi t0, s0, 8
    sw t0, 104(s0)
    lw t0, 104(s0)
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    fld ft0, 112(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 120(s0)
    fld ft3, 120(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    fld ft3, 128(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    fld ft0, 136(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    fld ft0, 128(s0)
    fld ft1, 144(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 152(s0)
    addi t0, s0, 24
    sw t0, 160(s0)
    lw t0, 160(s0)
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    fld ft0, 152(s0)
    fld ft1, 168(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 176(s0)
    fld ft3, 176(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 184(s0)
    addi t0, s0, 16
    sw t0, 192(s0)
    lw t0, 192(s0)
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    fld ft0, 184(s0)
    fld ft1, 200(s0)
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 208(s0)
    fld ft0, 208(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_5
    j .L_mejorPuntaje_L11
.L_rama_larga_5:
    addi t0, s0, 8
    sw t0, 216(s0)
    lw t0, 216(s0)
    fld ft0, 0(t0)
    fsd ft0, 224(s0)
    fld ft0, 224(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 232(s0)
    fld ft3, 232(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 240(s0)
    fld ft3, 240(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 248(s0)
    fld ft0, 248(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    fld ft0, 240(s0)
    fld ft1, 256(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 264(s0)
    addi t0, s0, 24
    sw t0, 272(s0)
    lw t0, 272(s0)
    fld ft0, 0(t0)
    fsd ft0, 280(s0)
    fld ft0, 264(s0)
    fld ft1, 280(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 288(s0)
    fld ft3, 288(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 296(s0)
    addi t0, s0, 16
    sw t0, 304(s0)
    lw t0, 304(s0)
    fld ft0, 296(s0)
    fsd ft0, 0(t0)
    j .L_mejorPuntaje_L10
.L_mejorPuntaje_L11:
.L_mejorPuntaje_L10:
.L_mejorPuntaje_L8:
    addi t0, s0, 24
    sw t0, 312(s0)
    lw t0, 312(s0)
    fld ft0, 0(t0)
    fsd ft0, 320(s0)
    fld ft0, 320(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 328(s0)
    addi t0, s0, 24
    sw t0, 336(s0)
    lw t0, 336(s0)
    fld ft0, 328(s0)
    fsd ft0, 0(t0)
    j .L_mejorPuntaje_L7
.L_mejorPuntaje_L9:
    addi t0, s0, 16
    sw t0, 344(s0)
    lw t0, 344(s0)
    fld ft0, 0(t0)
    fsd ft0, 352(s0)
    addi t0, s0, 0
    sw t0, 360(s0)
    lw t0, 360(s0)
    fld ft0, 352(s0)
    fsd ft0, 0(t0)
    j .L_fin_mejorPuntaje
.L_fin_mejorPuntaje:
    fld fa0, 0(s0)
    lw t0, 376(s0)
    lw ra, 380(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 384
    ret

imprimirResumen:
    addi sp, sp, -848
    sw ra, 844(sp)
    sw s0, 840(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 40(s0)
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
    li t6, 82
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
    li t6, 83
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
    li t6, 77
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
    li t6, 78
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    li t6, 69
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    li t6, 73
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
    li t6, 78
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    li t6, 85
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
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    fld ft0, 64(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 72(s0)
    fld ft3, 72(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 88(s0)
    fld ft0, 48(s0)
    fsd ft0, 96(s0)
.L_imprimirResumen_L12:
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
    beqz t0, .L_rama_larga_6
    j .L_imprimirResumen_L13
.L_rama_larga_6:
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
    j .L_imprimirResumen_L12
.L_imprimirResumen_L13:
    fld ft0, 80(s0)
    fsd ft0, 120(s0)
.L_imprimirResumen_L14:
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
    beqz t0, .L_rama_larga_7
    j .L_imprimirResumen_L15
.L_rama_larga_7:
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
    j .L_imprimirResumen_L14
.L_imprimirResumen_L15:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 88(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    fcvt.d.w ft0, s2
    fsd ft0, 144(s0)
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
    sw t0, 152(s0)
    lw t0, 152(s0)
    fld ft0, 0(t0)
    fsd ft0, 160(s0)
    fld ft0, 160(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 168(s0)
    fld ft3, 168(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    fld fa0, 176(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 184(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 192(s0)
    fld ft0, 144(s0)
    fsd ft0, 200(s0)
.L_imprimirResumen_L16:
    fld ft3, 200(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    fld ft0, 208(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 216(s0)
    fld ft0, 216(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_8
    j .L_imprimirResumen_L17
.L_rama_larga_8:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 208(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 200(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 200(s0)
    j .L_imprimirResumen_L16
.L_imprimirResumen_L17:
    fld ft0, 184(s0)
    fsd ft0, 224(s0)
.L_imprimirResumen_L18:
    fld ft3, 224(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 232(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 240(s0)
    fld ft0, 240(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_9
    j .L_imprimirResumen_L19
.L_rama_larga_9:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 232(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 224(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 224(s0)
    j .L_imprimirResumen_L18
.L_imprimirResumen_L19:
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
    addi t0, s0, 16
    sw t0, 248(s0)
    lw t0, 248(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_imprimirResumen_L20:
    addi t0, s0, 16
    sw t0, 256(s0)
    lw t0, 256(s0)
    fld ft0, 0(t0)
    fsd ft0, 264(s0)
    addi t0, s0, 8
    sw t0, 272(s0)
    lw t0, 272(s0)
    fld ft0, 0(t0)
    fsd ft0, 280(s0)
    fld ft0, 280(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 288(s0)
    fld ft3, 288(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 296(s0)
    fld ft0, 264(s0)
    fld ft1, 296(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 304(s0)
    fld ft0, 304(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_10
    j .L_imprimirResumen_L22
.L_rama_larga_10:
    fcvt.d.w ft0, s2
    fsd ft0, 312(s0)
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
    addi t0, s0, 16
    sw t0, 320(s0)
    lw t0, 320(s0)
    fld ft0, 0(t0)
    fsd ft0, 328(s0)
    fld ft0, 328(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 336(s0)
    fld fa0, 336(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 344(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 352(s0)
    fld ft0, 312(s0)
    fsd ft0, 360(s0)
.L_imprimirResumen_L23:
    fld ft3, 360(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 368(s0)
    fld ft0, 368(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 376(s0)
    fld ft0, 376(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_11
    j .L_imprimirResumen_L24
.L_rama_larga_11:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 368(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 360(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 360(s0)
    j .L_imprimirResumen_L23
.L_imprimirResumen_L24:
    fld ft0, 344(s0)
    fsd ft0, 384(s0)
.L_imprimirResumen_L25:
    fld ft3, 384(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 392(s0)
    fld ft0, 392(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 400(s0)
    fld ft0, 400(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_12
    j .L_imprimirResumen_L26
.L_rama_larga_12:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 392(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 384(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 384(s0)
    j .L_imprimirResumen_L25
.L_imprimirResumen_L26:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 408(s0)
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
    fsd ft0, 416(s0)
    fld ft0, 352(s0)
    fsd ft0, 424(s0)
.L_imprimirResumen_L27:
    fld ft3, 424(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 432(s0)
    fld ft0, 432(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 440(s0)
    fld ft0, 440(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_13
    j .L_imprimirResumen_L28
.L_rama_larga_13:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 432(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 424(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 424(s0)
    j .L_imprimirResumen_L27
.L_imprimirResumen_L28:
    fld ft0, 408(s0)
    fsd ft0, 448(s0)
.L_imprimirResumen_L29:
    fld ft3, 448(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 456(s0)
    fld ft0, 456(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 464(s0)
    fld ft0, 464(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_14
    j .L_imprimirResumen_L30
.L_rama_larga_14:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 456(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 448(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 448(s0)
    j .L_imprimirResumen_L29
.L_imprimirResumen_L30:
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
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 488(s0)
    fld ft3, 488(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 496(s0)
    fld ft3, 496(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 504(s0)
    fld ft0, 504(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 512(s0)
    fld ft0, 496(s0)
    fld ft1, 512(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 520(s0)
    addi t0, s0, 16
    sw t0, 528(s0)
    lw t0, 528(s0)
    fld ft0, 0(t0)
    fsd ft0, 536(s0)
    fld ft0, 520(s0)
    fld ft1, 536(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 544(s0)
    fld ft3, 544(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 552(s0)
    fld fa0, 552(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 560(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 568(s0)
    fld ft0, 416(s0)
    fsd ft0, 576(s0)
.L_imprimirResumen_L31:
    fld ft3, 576(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 584(s0)
    fld ft0, 584(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 592(s0)
    fld ft0, 592(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_15
    j .L_imprimirResumen_L32
.L_rama_larga_15:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 584(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 576(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 576(s0)
    j .L_imprimirResumen_L31
.L_imprimirResumen_L32:
    fld ft0, 560(s0)
    fsd ft0, 600(s0)
.L_imprimirResumen_L33:
    fld ft3, 600(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 608(s0)
    fld ft0, 608(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 616(s0)
    fld ft0, 616(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_16
    j .L_imprimirResumen_L34
.L_rama_larga_16:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 608(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 600(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 600(s0)
    j .L_imprimirResumen_L33
.L_imprimirResumen_L34:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
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
    li t6, 112
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
    fcvt.d.w ft0, s2
    fsd ft0, 632(s0)
    fld ft0, 568(s0)
    fsd ft0, 640(s0)
.L_imprimirResumen_L35:
    fld ft3, 640(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 648(s0)
    fld ft0, 648(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 656(s0)
    fld ft0, 656(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_17
    j .L_imprimirResumen_L36
.L_rama_larga_17:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 648(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 640(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 640(s0)
    j .L_imprimirResumen_L35
.L_imprimirResumen_L36:
    fld ft0, 624(s0)
    fsd ft0, 664(s0)
.L_imprimirResumen_L37:
    fld ft3, 664(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 672(s0)
    fld ft0, 672(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 680(s0)
    fld ft0, 680(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_18
    j .L_imprimirResumen_L38
.L_rama_larga_18:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 672(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 664(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 664(s0)
    j .L_imprimirResumen_L37
.L_imprimirResumen_L38:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 632(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
.L_imprimirResumen_L21:
    addi t0, s0, 16
    sw t0, 688(s0)
    lw t0, 688(s0)
    fld ft0, 0(t0)
    fsd ft0, 696(s0)
    fld ft0, 696(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 704(s0)
    addi t0, s0, 16
    sw t0, 712(s0)
    lw t0, 712(s0)
    fld ft0, 704(s0)
    fsd ft0, 0(t0)
    j .L_imprimirResumen_L20
.L_imprimirResumen_L22:
    fcvt.d.w ft0, s2
    fsd ft0, 720(s0)
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
    li t6, 112
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
    sw t0, 728(s0)
    lw t0, 728(s0)
    fld ft0, 0(t0)
    fsd ft0, 736(s0)
    addi t0, s0, 24
    sw t0, 744(s0)
    lw t0, 744(s0)
    addi t0, t0, 8
    sw t0, 752(s0)
    lw t0, 752(s0)
    fld ft0, 736(s0)
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    jal ra, mejorPuntaje
    fsd fa0, 24(s0)
    addi t0, s0, 24
    sw t0, 760(s0)
    lw t0, 760(s0)
    fld ft0, 0(t0)
    fsd ft0, 768(s0)
    fld fa0, 768(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 776(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 784(s0)
    fld ft0, 720(s0)
    fsd ft0, 792(s0)
.L_imprimirResumen_L39:
    fld ft3, 792(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 800(s0)
    fld ft0, 800(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 808(s0)
    fld ft0, 808(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_19
    j .L_imprimirResumen_L40
.L_rama_larga_19:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 800(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 792(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 792(s0)
    j .L_imprimirResumen_L39
.L_imprimirResumen_L40:
    fld ft0, 776(s0)
    fsd ft0, 816(s0)
.L_imprimirResumen_L41:
    fld ft3, 816(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 824(s0)
    fld ft0, 824(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 832(s0)
    fld ft0, 832(s0)
    fcvt.w.d t0, ft0
    beqz t0, .L_rama_larga_20
    j .L_imprimirResumen_L42
.L_rama_larga_20:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 824(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 816(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 816(s0)
    j .L_imprimirResumen_L41
.L_imprimirResumen_L42:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 784(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
.L_fin_imprimirResumen:
    fld fa0, 0(s0)
    lw t0, 840(s0)
    lw ra, 844(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 848
    ret

Jugador_String_int_int_:
    addi sp, sp, -272
    sw ra, 268(sp)
    sw s0, 264(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fsd fa2, 24(s0)
    fsd fa3, 32(s0)
    addi t0, s0, 16
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
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 72(s0)
    fld ft3, 72(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 48(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
    addi t0, s0, 8
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    fld ft0, 104(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 112(s0)
    fld ft3, 112(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 88(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 32
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
    fadd.d ft2, ft0, ft1
    fsd ft2, 152(s0)
    fld ft3, 152(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 128(s0)
    fsd ft0, 0(t0)
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
    li t6, 0
    fcvt.d.w ft0, t6
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
    addi t0, s0, 8
    sw t0, 208(s0)
    lw t0, 208(s0)
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    fld ft0, 216(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 224(s0)
    fld ft3, 224(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 3
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 232(s0)
    lw t0, 232(s0)
    fld ft0, 0(t0)
    fsd ft0, 240(s0)
    fld ft0, 240(s0)
    li t6, 6
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 248(s0)
    fld ft3, 248(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 80
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_fin_Jugador_String_int_int_:
    fld fa0, 0(s0)
    lw t0, 264(s0)
    lw ra, 268(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 272
    ret

Jugador__:
    addi sp, sp, -208
    sw ra, 204(sp)
    sw s0, 200(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 16(s0)
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
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
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
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
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
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    fld ft0, 128(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 136(s0)
    fld ft3, 136(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    fld ft0, 152(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 160(s0)
    fld ft3, 160(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 3
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    fld ft0, 176(s0)
    li t6, 6
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 184(s0)
    fld ft3, 184(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 80
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_fin_Jugador__:
    fld fa0, 0(s0)
    lw t0, 200(s0)
    lw ra, 204(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 208
    ret

Jugador_sumarPuntos_int_:
    addi sp, sp, -96
    sw ra, 92(sp)
    sw s0, 88(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 16
    sw t0, 24(s0)
    lw t0, 24(s0)
    fld ft0, 0(t0)
    fsd ft0, 32(s0)
    addi t0, s0, 8
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    fld ft0, 48(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 56(s0)
    fld ft3, 56(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    fld ft0, 64(s0)
    fld ft1, 32(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 72(s0)
    fld ft3, 56(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 72(s0)
    fsd ft0, 0(t0)
.L_fin_Jugador_sumarPuntos_int_:
    fld fa0, 0(s0)
    lw t0, 88(s0)
    lw ra, 92(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 96
    ret

Jugador_perderVida__:
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
    li t6, 5
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
    li t6, 1
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 48(s0)
    fld ft3, 32(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 48(s0)
    fsd ft0, 0(t0)
.L_fin_Jugador_perderVida__:
    fld fa0, 0(s0)
    lw t0, 56(s0)
    lw ra, 60(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 64
    ret

Jugador_estaVivo__:
    addi sp, sp, -80
    sw ra, 76(sp)
    sw s0, 72(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 16(s0)
    lw t0, 16(s0)
    fld ft0, 0(t0)
    fsd ft0, 24(s0)
    fld ft0, 24(s0)
    li t6, 5
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
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 48(s0)
    addi t0, s0, 0
    sw t0, 56(s0)
    lw t0, 56(s0)
    fld ft0, 48(s0)
    fsd ft0, 0(t0)
    j .L_fin_Jugador_estaVivo__
.L_fin_Jugador_estaVivo__:
    fld fa0, 0(s0)
    lw t0, 72(s0)
    lw ra, 76(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 80
    ret

Jugador_mover_int_int_:
    addi sp, sp, -160
    sw ra, 156(sp)
    sw s0, 152(sp)
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
    li t6, 1
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
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 128(s0)
    fld ft3, 128(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    fld ft0, 136(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    fld ft3, 128(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 144(s0)
    fsd ft0, 0(t0)
.L_fin_Jugador_mover_int_int_:
    fld fa0, 0(s0)
    lw t0, 152(s0)
    lw ra, 156(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 160
    ret

Jugador_mostrarEstado__:
    addi sp, sp, -768
    sw ra, 764(sp)
    sw s0, 760(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 16(s0)
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
    fcvt.d.w ft0, s2
    fsd ft0, 56(s0)
    fld ft0, 16(s0)
    fsd ft0, 64(s0)
.L_Jugador_mostrarEstado___L1:
    fld ft3, 64(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 72(s0)
    fld ft0, 72(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 80(s0)
    fld ft0, 80(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_21
    j .L_Jugador_mostrarEstado___L2
.L_rama_larga_21:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 72(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 64(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 64(s0)
    j .L_Jugador_mostrarEstado___L1
.L_Jugador_mostrarEstado___L2:
    fld ft0, 48(s0)
    fsd ft0, 88(s0)
.L_Jugador_mostrarEstado___L3:
    fld ft3, 88(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 96(s0)
    fld ft0, 96(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 104(s0)
    fld ft0, 104(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_22
    j .L_Jugador_mostrarEstado___L4
.L_rama_larga_22:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 96(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 88(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 88(s0)
    j .L_Jugador_mostrarEstado___L3
.L_Jugador_mostrarEstado___L4:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 112(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    fcvt.d.w ft0, s2
    fsd ft0, 120(s0)
    fld ft0, 56(s0)
    fsd ft0, 128(s0)
.L_Jugador_mostrarEstado___L5:
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
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 144(s0)
    fld ft0, 144(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_23
    j .L_Jugador_mostrarEstado___L6
.L_rama_larga_23:
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
    j .L_Jugador_mostrarEstado___L5
.L_Jugador_mostrarEstado___L6:
    fld ft0, 112(s0)
    fsd ft0, 152(s0)
.L_Jugador_mostrarEstado___L7:
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
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 168(s0)
    fld ft0, 168(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_24
    j .L_Jugador_mostrarEstado___L8
.L_rama_larga_24:
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
    j .L_Jugador_mostrarEstado___L7
.L_Jugador_mostrarEstado___L8:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 0(t0)
    fsd ft0, 184(s0)
    fld ft0, 184(s0)
    li t6, 6
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 192(s0)
    fld ft3, 192(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    fld fa0, 200(s0)
    jal ra, caracter_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 208(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 216(s0)
    fld ft0, 120(s0)
    fsd ft0, 224(s0)
.L_Jugador_mostrarEstado___L9:
    fld ft3, 224(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 232(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 240(s0)
    fld ft0, 240(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_25
    j .L_Jugador_mostrarEstado___L10
.L_rama_larga_25:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 232(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 224(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 224(s0)
    j .L_Jugador_mostrarEstado___L9
.L_Jugador_mostrarEstado___L10:
    fld ft0, 208(s0)
    fsd ft0, 248(s0)
.L_Jugador_mostrarEstado___L11:
    fld ft3, 248(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 256(s0)
    fld ft0, 256(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 264(s0)
    fld ft0, 264(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_26
    j .L_Jugador_mostrarEstado___L12
.L_rama_larga_26:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 256(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 248(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 248(s0)
    j .L_Jugador_mostrarEstado___L11
.L_Jugador_mostrarEstado___L12:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 272(s0)
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
    fcvt.d.w ft0, s2
    fsd ft0, 280(s0)
    fld ft0, 216(s0)
    fsd ft0, 288(s0)
.L_Jugador_mostrarEstado___L13:
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
    bnez t0, .L_rama_larga_27
    j .L_Jugador_mostrarEstado___L14
.L_rama_larga_27:
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
    j .L_Jugador_mostrarEstado___L13
.L_Jugador_mostrarEstado___L14:
    fld ft0, 272(s0)
    fsd ft0, 312(s0)
.L_Jugador_mostrarEstado___L15:
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
    bnez t0, .L_rama_larga_28
    j .L_Jugador_mostrarEstado___L16
.L_rama_larga_28:
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
    j .L_Jugador_mostrarEstado___L15
.L_Jugador_mostrarEstado___L16:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 336(s0)
    lw t0, 336(s0)
    fld ft0, 0(t0)
    fsd ft0, 344(s0)
    fld ft0, 344(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 352(s0)
    fld ft3, 352(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 360(s0)
    fld fa0, 360(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 368(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 376(s0)
    fld ft0, 280(s0)
    fsd ft0, 384(s0)
.L_Jugador_mostrarEstado___L17:
    fld ft3, 384(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 392(s0)
    fld ft0, 392(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 400(s0)
    fld ft0, 400(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_29
    j .L_Jugador_mostrarEstado___L18
.L_rama_larga_29:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 392(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 384(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 384(s0)
    j .L_Jugador_mostrarEstado___L17
.L_Jugador_mostrarEstado___L18:
    fld ft0, 368(s0)
    fsd ft0, 408(s0)
.L_Jugador_mostrarEstado___L19:
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
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 424(s0)
    fld ft0, 424(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_30
    j .L_Jugador_mostrarEstado___L20
.L_rama_larga_30:
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
    j .L_Jugador_mostrarEstado___L19
.L_Jugador_mostrarEstado___L20:
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
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    fsd ft0, 440(s0)
    fld ft0, 376(s0)
    fsd ft0, 448(s0)
.L_Jugador_mostrarEstado___L21:
    fld ft3, 448(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 456(s0)
    fld ft0, 456(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 464(s0)
    fld ft0, 464(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_31
    j .L_Jugador_mostrarEstado___L22
.L_rama_larga_31:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 456(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 448(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 448(s0)
    j .L_Jugador_mostrarEstado___L21
.L_Jugador_mostrarEstado___L22:
    fld ft0, 432(s0)
    fsd ft0, 472(s0)
.L_Jugador_mostrarEstado___L23:
    fld ft3, 472(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 480(s0)
    fld ft0, 480(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 488(s0)
    fld ft0, 488(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_32
    j .L_Jugador_mostrarEstado___L24
.L_rama_larga_32:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 480(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 472(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 472(s0)
    j .L_Jugador_mostrarEstado___L23
.L_Jugador_mostrarEstado___L24:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 496(s0)
    lw t0, 496(s0)
    fld ft0, 0(t0)
    fsd ft0, 504(s0)
    fld ft0, 504(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 512(s0)
    fld ft3, 512(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 520(s0)
    fld fa0, 520(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 528(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 536(s0)
    fld ft0, 440(s0)
    fsd ft0, 544(s0)
.L_Jugador_mostrarEstado___L25:
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
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 560(s0)
    fld ft0, 560(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_33
    j .L_Jugador_mostrarEstado___L26
.L_rama_larga_33:
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
    j .L_Jugador_mostrarEstado___L25
.L_Jugador_mostrarEstado___L26:
    fld ft0, 528(s0)
    fsd ft0, 568(s0)
.L_Jugador_mostrarEstado___L27:
    fld ft3, 568(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 576(s0)
    fld ft0, 576(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 584(s0)
    fld ft0, 584(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_34
    j .L_Jugador_mostrarEstado___L28
.L_rama_larga_34:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 576(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 568(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 568(s0)
    j .L_Jugador_mostrarEstado___L27
.L_Jugador_mostrarEstado___L28:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 592(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    fcvt.d.w ft0, s2
    fsd ft0, 600(s0)
    fld ft0, 536(s0)
    fsd ft0, 608(s0)
.L_Jugador_mostrarEstado___L29:
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
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 624(s0)
    fld ft0, 624(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_35
    j .L_Jugador_mostrarEstado___L30
.L_rama_larga_35:
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
    j .L_Jugador_mostrarEstado___L29
.L_Jugador_mostrarEstado___L30:
    fld ft0, 592(s0)
    fsd ft0, 632(s0)
.L_Jugador_mostrarEstado___L31:
    fld ft3, 632(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 640(s0)
    fld ft0, 640(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 648(s0)
    fld ft0, 648(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_36
    j .L_Jugador_mostrarEstado___L32
.L_rama_larga_36:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 640(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 632(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 632(s0)
    j .L_Jugador_mostrarEstado___L31
.L_Jugador_mostrarEstado___L32:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 656(s0)
    lw t0, 656(s0)
    fld ft0, 0(t0)
    fsd ft0, 664(s0)
    fld ft0, 664(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 672(s0)
    fld ft3, 672(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 680(s0)
    fld fa0, 680(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 688(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 696(s0)
    fld ft0, 600(s0)
    fsd ft0, 704(s0)
.L_Jugador_mostrarEstado___L33:
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
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 720(s0)
    fld ft0, 720(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_37
    j .L_Jugador_mostrarEstado___L34
.L_rama_larga_37:
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
    j .L_Jugador_mostrarEstado___L33
.L_Jugador_mostrarEstado___L34:
    fld ft0, 688(s0)
    fsd ft0, 728(s0)
.L_Jugador_mostrarEstado___L35:
    fld ft3, 728(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 736(s0)
    fld ft0, 736(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 744(s0)
    fld ft0, 744(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_38
    j .L_Jugador_mostrarEstado___L36
.L_rama_larga_38:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 736(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 728(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 728(s0)
    j .L_Jugador_mostrarEstado___L35
.L_Jugador_mostrarEstado___L36:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 696(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
.L_fin_Jugador_mostrarEstado__:
    fld fa0, 0(s0)
    lw t0, 760(s0)
    lw ra, 764(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 768
    ret

Tablero_int_int_:
    addi sp, sp, -336
    sw ra, 332(sp)
    sw s0, 328(sp)
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
    li t6, 2
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
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 104(s0)
    fld ft3, 104(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 80(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    addi t0, s0, 24
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 144(s0)
    fld ft3, 144(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 144(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 152(s0)
    fld ft3, 152(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 120(s0)
    fsd ft0, 0(t0)
    fld ft0, 144(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 160(s0)
    fld ft3, 160(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 136(s0)
    fsd ft0, 0(t0)
    fld ft0, 120(s0)
    fld ft1, 136(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 168(s0)
    fld ft0, 168(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 176(s0)
    fcvt.d.w ft0, s2
    fld ft1, 176(s0)
    fadd.d ft2, ft0, ft1
    fcvt.w.d s2, ft2
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
    fld ft0, 144(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 208(s0)
    lw t0, 208(s0)
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    addi t0, s0, 24
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 240(s0)
    fld ft3, 240(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 240(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 248(s0)
    fld ft3, 248(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 216(s0)
    fsd ft0, 0(t0)
    fld ft0, 240(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    fld ft3, 256(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 232(s0)
    fsd ft0, 0(t0)
    fld ft0, 216(s0)
    fld ft1, 232(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 264(s0)
    fld ft0, 264(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 272(s0)
    fcvt.d.w ft0, s2
    fld ft1, 272(s0)
    fadd.d ft2, ft0, ft1
    fcvt.w.d s2, ft2
    addi t0, s0, 8
    sw t0, 280(s0)
    lw t0, 280(s0)
    fld ft0, 0(t0)
    fsd ft0, 288(s0)
    fld ft0, 288(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 296(s0)
    fld ft3, 296(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 240(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 304(s0)
    lw t0, 304(s0)
    fld ft0, 0(t0)
    fsd ft0, 312(s0)
    fld ft0, 312(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 320(s0)
    fld ft3, 320(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_fin_Tablero_int_int_:
    fld fa0, 0(s0)
    lw t0, 328(s0)
    lw ra, 332(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 336
    ret

Tablero__:
    addi sp, sp, -224
    sw ra, 220(sp)
    sw s0, 216(sp)
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
    li t6, 7
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    fld ft0, 48(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 56(s0)
    fld ft3, 56(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 9
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 64(s0)
    fld ft3, 64(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 64(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 72(s0)
    fld ft3, 72(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 7
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 64(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 80(s0)
    fld ft3, 80(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 9
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    li t6, 7
    fcvt.d.w ft0, t6
    li t6, 9
    fcvt.d.w ft1, t6
    fmul.d ft2, ft0, ft1
    fsd ft2, 88(s0)
    fld ft0, 88(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 96(s0)
    fcvt.d.w ft0, s2
    fld ft1, 96(s0)
    fadd.d ft2, ft0, ft1
    fcvt.w.d s2, ft2
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
    fld ft0, 64(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 128(s0)
    fld ft3, 128(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 128(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 136(s0)
    fld ft3, 136(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 7
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 128(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    fld ft3, 144(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 9
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    li t6, 7
    fcvt.d.w ft0, t6
    li t6, 9
    fcvt.d.w ft1, t6
    fmul.d ft2, ft0, ft1
    fsd ft2, 152(s0)
    fld ft0, 152(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 160(s0)
    fcvt.d.w ft0, s2
    fld ft1, 160(s0)
    fadd.d ft2, ft0, ft1
    fcvt.w.d s2, ft2
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
    fld ft0, 128(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 192(s0)
    lw t0, 192(s0)
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    fld ft0, 200(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 208(s0)
    fld ft3, 208(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_fin_Tablero__:
    fld fa0, 0(s0)
    lw t0, 216(s0)
    lw ra, 220(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 224
    ret

Tablero_esValida_int_int_:
    addi sp, sp, -240
    sw ra, 236(sp)
    sw s0, 232(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fsd fa2, 24(s0)
    addi t0, s0, 16
    sw t0, 32(s0)
    lw t0, 32(s0)
    fld ft0, 0(t0)
    fsd ft0, 40(s0)
    fld ft0, 40(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fle.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 48(s0)
    fld ft0, 48(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_39
    j .L_Tablero_esValida_int_int__L37
.L_rama_larga_39:
    addi t0, s0, 16
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
    fsd ft0, 112(s0)
    j .L_Tablero_esValida_int_int__L38
.L_Tablero_esValida_int_int__L37:
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 112(s0)
.L_Tablero_esValida_int_int__L38:
    fld ft0, 112(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_40
    j .L_Tablero_esValida_int_int__L39
.L_rama_larga_40:
    addi t0, s0, 24
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 0(t0)
    fsd ft0, 128(s0)
    fld ft0, 128(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fle.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 136(s0)
    fld ft0, 136(s0)
    fsd ft0, 144(s0)
    j .L_Tablero_esValida_int_int__L40
.L_Tablero_esValida_int_int__L39:
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 144(s0)
.L_Tablero_esValida_int_int__L40:
    fld ft0, 144(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_41
    j .L_Tablero_esValida_int_int__L41
.L_rama_larga_41:
    addi t0, s0, 24
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
    fld ft0, 160(s0)
    fld ft1, 192(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 200(s0)
    fld ft0, 200(s0)
    fsd ft0, 208(s0)
    j .L_Tablero_esValida_int_int__L42
.L_Tablero_esValida_int_int__L41:
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 208(s0)
.L_Tablero_esValida_int_int__L42:
    addi t0, s0, 0
    sw t0, 216(s0)
    lw t0, 216(s0)
    fld ft0, 208(s0)
    fsd ft0, 0(t0)
    j .L_fin_Tablero_esValida_int_int_
.L_fin_Tablero_esValida_int_int_:
    fld fa0, 0(s0)
    lw t0, 232(s0)
    lw ra, 236(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 240
    ret

Tablero_esPared_int_int_:
    addi sp, sp, -320
    sw ra, 316(sp)
    sw s0, 312(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fsd fa2, 24(s0)
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
    addi t0, s0, 24
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    addi t0, s0, 32
    sw t0, 112(s0)
    lw t0, 112(s0)
    addi t0, t0, 8
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 72(s0)
    fsd ft0, 0(t0)
    lw t0, 112(s0)
    addi t0, t0, 16
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 88(s0)
    fsd ft0, 0(t0)
    lw t0, 112(s0)
    addi t0, t0, 24
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 104(s0)
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    jal ra, Tablero_esValida_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 32
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    fld ft0, 152(s0)
    fcvt.w.d t0, ft0
    seqz t0, t0
    fcvt.d.w ft1, t0
    fsd ft1, 160(s0)
    fld ft0, 160(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_42
    j .L_Tablero_esPared_int_int__L44
.L_rama_larga_42:
    addi t0, s0, 0
    sw t0, 168(s0)
    lw t0, 168(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Tablero_esPared_int_int_
    j .L_Tablero_esPared_int_int__L43
.L_Tablero_esPared_int_int__L44:
.L_Tablero_esPared_int_int__L43:
    addi t0, s0, 8
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 0(t0)
    fsd ft0, 184(s0)
    fld ft0, 184(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 192(s0)
    fld ft3, 192(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    addi t0, s0, 16
    sw t0, 208(s0)
    lw t0, 208(s0)
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    addi t0, s0, 24
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 200(s0)
    li t6, 2
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
    fld ft1, 248(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    fld ft0, 256(s0)
    fld ft1, 232(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 264(s0)
    fld ft0, 200(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 272(s0)
    fld ft0, 272(s0)
    fld ft1, 264(s0)
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
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 296(s0)
    addi t0, s0, 0
    sw t0, 304(s0)
    lw t0, 304(s0)
    fld ft0, 296(s0)
    fsd ft0, 0(t0)
    j .L_fin_Tablero_esPared_int_int_
.L_fin_Tablero_esPared_int_int_:
    fld fa0, 0(s0)
    lw t0, 312(s0)
    lw ra, 316(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 320
    ret

Tablero_colocar_int_int_int_:
    addi sp, sp, -608
    sw ra, 604(sp)
    sw s0, 600(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fsd fa2, 24(s0)
    fsd fa3, 32(s0)
    addi t0, s0, 8
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    addi t0, s0, 16
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 0(t0)
    fsd ft0, 96(s0)
    addi t0, s0, 24
    sw t0, 104(s0)
    lw t0, 104(s0)
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    addi t0, s0, 40
    sw t0, 120(s0)
    lw t0, 120(s0)
    addi t0, t0, 8
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 80(s0)
    fsd ft0, 0(t0)
    lw t0, 120(s0)
    addi t0, t0, 16
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 96(s0)
    fsd ft0, 0(t0)
    lw t0, 120(s0)
    addi t0, t0, 24
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 112(s0)
    fsd ft0, 0(t0)
    fld fa0, 48(s0)
    fld fa1, 56(s0)
    fld fa2, 64(s0)
    jal ra, Tablero_esValida_int_int_
    fsd fa0, 40(s0)
    addi t0, s0, 40
    sw t0, 152(s0)
    lw t0, 152(s0)
    fld ft0, 0(t0)
    fsd ft0, 160(s0)
    fld ft0, 160(s0)
    fcvt.w.d t0, ft0
    seqz t0, t0
    fcvt.d.w ft1, t0
    fsd ft1, 168(s0)
    fld ft0, 168(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_43
    j .L_Tablero_colocar_int_int_int__L46
.L_rama_larga_43:
    fcvt.d.w ft0, s2
    fsd ft0, 176(s0)
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
    addi t0, s0, 16
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    fld fa0, 192(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 200(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 208(s0)
    fld ft0, 176(s0)
    fsd ft0, 216(s0)
.L_Tablero_colocar_int_int_int__L47:
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
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 232(s0)
    fld ft0, 232(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_44
    j .L_Tablero_colocar_int_int_int__L48
.L_rama_larga_44:
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
    j .L_Tablero_colocar_int_int_int__L47
.L_Tablero_colocar_int_int_int__L48:
    fld ft0, 200(s0)
    fsd ft0, 240(s0)
.L_Tablero_colocar_int_int_int__L49:
    fld ft3, 240(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 248(s0)
    fld ft0, 248(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 256(s0)
    fld ft0, 256(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_45
    j .L_Tablero_colocar_int_int_int__L50
.L_rama_larga_45:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 248(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 240(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 240(s0)
    j .L_Tablero_colocar_int_int_int__L49
.L_Tablero_colocar_int_int_int__L50:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 264(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 272(s0)
    fld ft0, 208(s0)
    fsd ft0, 280(s0)
.L_Tablero_colocar_int_int_int__L51:
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
    bnez t0, .L_rama_larga_46
    j .L_Tablero_colocar_int_int_int__L52
.L_rama_larga_46:
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
    j .L_Tablero_colocar_int_int_int__L51
.L_Tablero_colocar_int_int_int__L52:
    fld ft0, 264(s0)
    fsd ft0, 304(s0)
.L_Tablero_colocar_int_int_int__L53:
    fld ft3, 304(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 312(s0)
    fld ft0, 312(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 320(s0)
    fld ft0, 320(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_47
    j .L_Tablero_colocar_int_int_int__L54
.L_rama_larga_47:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 312(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 304(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 304(s0)
    j .L_Tablero_colocar_int_int_int__L53
.L_Tablero_colocar_int_int_int__L54:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 24
    sw t0, 328(s0)
    lw t0, 328(s0)
    fld ft0, 0(t0)
    fsd ft0, 336(s0)
    fld fa0, 336(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 344(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 352(s0)
    fld ft0, 272(s0)
    fsd ft0, 360(s0)
.L_Tablero_colocar_int_int_int__L55:
    fld ft3, 360(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 368(s0)
    fld ft0, 368(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 376(s0)
    fld ft0, 376(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_48
    j .L_Tablero_colocar_int_int_int__L56
.L_rama_larga_48:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 368(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 360(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 360(s0)
    j .L_Tablero_colocar_int_int_int__L55
.L_Tablero_colocar_int_int_int__L56:
    fld ft0, 344(s0)
    fsd ft0, 384(s0)
.L_Tablero_colocar_int_int_int__L57:
    fld ft3, 384(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 392(s0)
    fld ft0, 392(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 400(s0)
    fld ft0, 400(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_49
    j .L_Tablero_colocar_int_int_int__L58
.L_rama_larga_49:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 392(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 384(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 384(s0)
    j .L_Tablero_colocar_int_int_int__L57
.L_Tablero_colocar_int_int_int__L58:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 352(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    j .L_fin_Tablero_colocar_int_int_int_
    j .L_Tablero_colocar_int_int_int__L45
.L_Tablero_colocar_int_int_int__L46:
.L_Tablero_colocar_int_int_int__L45:
    addi t0, s0, 8
    sw t0, 408(s0)
    lw t0, 408(s0)
    fld ft0, 0(t0)
    fsd ft0, 416(s0)
    fld ft0, 416(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 424(s0)
    fld ft3, 424(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 432(s0)
    addi t0, s0, 16
    sw t0, 440(s0)
    lw t0, 440(s0)
    fld ft0, 0(t0)
    fsd ft0, 448(s0)
    addi t0, s0, 24
    sw t0, 456(s0)
    lw t0, 456(s0)
    fld ft0, 0(t0)
    fsd ft0, 464(s0)
    fld ft0, 432(s0)
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
    fld ft0, 448(s0)
    fld ft1, 480(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 488(s0)
    fld ft0, 488(s0)
    fld ft1, 464(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 496(s0)
    fld ft0, 432(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 504(s0)
    fld ft0, 504(s0)
    fld ft1, 496(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 512(s0)
    addi t0, s0, 32
    sw t0, 520(s0)
    lw t0, 520(s0)
    fld ft0, 0(t0)
    fsd ft0, 528(s0)
    fld ft3, 512(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 528(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 32
    sw t0, 536(s0)
    lw t0, 536(s0)
    fld ft0, 0(t0)
    fsd ft0, 544(s0)
    fld ft0, 544(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 552(s0)
    fld ft0, 552(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_50
    j .L_Tablero_colocar_int_int_int__L60
.L_rama_larga_50:
    addi t0, s0, 8
    sw t0, 560(s0)
    lw t0, 560(s0)
    fld ft0, 0(t0)
    fsd ft0, 568(s0)
    fld ft0, 568(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 576(s0)
    fld ft3, 576(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 584(s0)
    fld ft0, 584(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 592(s0)
    fld ft3, 576(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 592(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_colocar_int_int_int__L59
.L_Tablero_colocar_int_int_int__L60:
.L_Tablero_colocar_int_int_int__L59:
.L_fin_Tablero_colocar_int_int_int_:
    fld fa0, 0(s0)
    lw t0, 600(s0)
    lw ra, 604(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 608
    ret

Tablero_inicializar__:
    addi sp, sp, -1504
    sw ra, 1500(sp)
    sw s0, 1496(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    fld ft0, 80(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 88(s0)
    fld ft3, 88(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 96(s0)
    lw t0, 96(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Tablero_inicializar___L61:
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
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 136(s0)
    fld ft3, 136(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 144(s0)
    fld ft0, 112(s0)
    fld ft1, 144(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 152(s0)
    fld ft0, 152(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_51
    j .L_Tablero_inicializar___L63
.L_rama_larga_51:
    addi t0, s0, 24
    sw t0, 160(s0)
    lw t0, 160(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Tablero_inicializar___L64:
    addi t0, s0, 24
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    addi t0, s0, 8
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    fld ft0, 192(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 200(s0)
    fld ft3, 200(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    fld ft0, 176(s0)
    fld ft1, 208(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 216(s0)
    fld ft0, 216(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_52
    j .L_Tablero_inicializar___L66
.L_rama_larga_52:
    addi t0, s0, 16
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 232(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 240(s0)
    fld ft0, 240(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_53
    j .L_Tablero_inicializar___L69
.L_rama_larga_53:
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 248(s0)
    j .L_Tablero_inicializar___L70
.L_Tablero_inicializar___L69:
    addi t0, s0, 24
    sw t0, 256(s0)
    lw t0, 256(s0)
    fld ft0, 0(t0)
    fsd ft0, 264(s0)
    fld ft0, 264(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 272(s0)
    fld ft0, 272(s0)
    fsd ft0, 248(s0)
.L_Tablero_inicializar___L70:
    fld ft0, 248(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_54
    j .L_Tablero_inicializar___L71
.L_rama_larga_54:
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 280(s0)
    j .L_Tablero_inicializar___L72
.L_Tablero_inicializar___L71:
    addi t0, s0, 16
    sw t0, 288(s0)
    lw t0, 288(s0)
    fld ft0, 0(t0)
    fsd ft0, 296(s0)
    addi t0, s0, 8
    sw t0, 304(s0)
    lw t0, 304(s0)
    fld ft0, 0(t0)
    fsd ft0, 312(s0)
    fld ft0, 312(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 320(s0)
    fld ft3, 320(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 328(s0)
    fld ft0, 328(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 336(s0)
    fld ft0, 296(s0)
    fld ft1, 336(s0)
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 344(s0)
    fld ft0, 344(s0)
    fsd ft0, 280(s0)
.L_Tablero_inicializar___L72:
    fld ft0, 280(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_55
    j .L_Tablero_inicializar___L73
.L_rama_larga_55:
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 352(s0)
    j .L_Tablero_inicializar___L74
.L_Tablero_inicializar___L73:
    addi t0, s0, 24
    sw t0, 360(s0)
    lw t0, 360(s0)
    fld ft0, 0(t0)
    fsd ft0, 368(s0)
    addi t0, s0, 8
    sw t0, 376(s0)
    lw t0, 376(s0)
    fld ft0, 0(t0)
    fsd ft0, 384(s0)
    fld ft0, 384(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 392(s0)
    fld ft3, 392(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 400(s0)
    fld ft0, 400(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 408(s0)
    fld ft0, 368(s0)
    fld ft1, 408(s0)
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 416(s0)
    fld ft0, 416(s0)
    fsd ft0, 352(s0)
.L_Tablero_inicializar___L74:
    fld ft0, 352(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_56
    j .L_Tablero_inicializar___L68
.L_rama_larga_56:
    addi t0, s0, 8
    sw t0, 424(s0)
    lw t0, 424(s0)
    fld ft0, 0(t0)
    fsd ft0, 432(s0)
    fld ft0, 432(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 440(s0)
    fld ft3, 440(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 448(s0)
    addi t0, s0, 16
    sw t0, 456(s0)
    lw t0, 456(s0)
    fld ft0, 0(t0)
    fsd ft0, 464(s0)
    addi t0, s0, 24
    sw t0, 472(s0)
    lw t0, 472(s0)
    fld ft0, 0(t0)
    fsd ft0, 480(s0)
    fld ft0, 448(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 488(s0)
    fld ft3, 488(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 496(s0)
    fld ft0, 464(s0)
    fld ft1, 496(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 504(s0)
    fld ft0, 504(s0)
    fld ft1, 480(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 512(s0)
    fld ft0, 448(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 520(s0)
    fld ft0, 520(s0)
    fld ft1, 512(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 528(s0)
    fld ft3, 528(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_Tablero_inicializar___L67
.L_Tablero_inicializar___L68:
    addi t0, s0, 8
    sw t0, 536(s0)
    lw t0, 536(s0)
    fld ft0, 0(t0)
    fsd ft0, 544(s0)
    fld ft0, 544(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 552(s0)
    fld ft3, 552(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 560(s0)
    addi t0, s0, 16
    sw t0, 568(s0)
    lw t0, 568(s0)
    fld ft0, 0(t0)
    fsd ft0, 576(s0)
    addi t0, s0, 24
    sw t0, 584(s0)
    lw t0, 584(s0)
    fld ft0, 0(t0)
    fsd ft0, 592(s0)
    fld ft0, 560(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 600(s0)
    fld ft3, 600(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 608(s0)
    fld ft0, 576(s0)
    fld ft1, 608(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 616(s0)
    fld ft0, 616(s0)
    fld ft1, 592(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 624(s0)
    fld ft0, 560(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 632(s0)
    fld ft0, 632(s0)
    fld ft1, 624(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 640(s0)
    fld ft3, 640(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Tablero_inicializar___L67:
.L_Tablero_inicializar___L65:
    addi t0, s0, 24
    sw t0, 648(s0)
    lw t0, 648(s0)
    fld ft0, 0(t0)
    fsd ft0, 656(s0)
    fld ft0, 656(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 664(s0)
    addi t0, s0, 24
    sw t0, 672(s0)
    lw t0, 672(s0)
    fld ft0, 664(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_inicializar___L64
.L_Tablero_inicializar___L66:
.L_Tablero_inicializar___L62:
    addi t0, s0, 16
    sw t0, 680(s0)
    lw t0, 680(s0)
    fld ft0, 0(t0)
    fsd ft0, 688(s0)
    fld ft0, 688(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 696(s0)
    addi t0, s0, 16
    sw t0, 704(s0)
    lw t0, 704(s0)
    fld ft0, 696(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_inicializar___L61
.L_Tablero_inicializar___L63:
    addi t0, s0, 8
    sw t0, 712(s0)
    lw t0, 712(s0)
    fld ft0, 0(t0)
    fsd ft0, 720(s0)
    addi t0, s0, 32
    sw t0, 728(s0)
    lw t0, 728(s0)
    addi t0, t0, 8
    sw t0, 736(s0)
    lw t0, 736(s0)
    fld ft0, 720(s0)
    fsd ft0, 0(t0)
    lw t0, 728(s0)
    addi t0, t0, 16
    sw t0, 744(s0)
    lw t0, 744(s0)
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 728(s0)
    addi t0, t0, 24
    sw t0, 752(s0)
    lw t0, 752(s0)
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 728(s0)
    addi t0, t0, 32
    sw t0, 760(s0)
    lw t0, 760(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 8
    sw t0, 768(s0)
    lw t0, 768(s0)
    fld ft0, 0(t0)
    fsd ft0, 776(s0)
    addi t0, s0, 32
    sw t0, 784(s0)
    lw t0, 784(s0)
    addi t0, t0, 8
    sw t0, 792(s0)
    lw t0, 792(s0)
    fld ft0, 776(s0)
    fsd ft0, 0(t0)
    lw t0, 784(s0)
    addi t0, t0, 16
    sw t0, 800(s0)
    lw t0, 800(s0)
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 784(s0)
    addi t0, t0, 24
    sw t0, 808(s0)
    lw t0, 808(s0)
    li t6, 3
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 784(s0)
    addi t0, t0, 32
    sw t0, 816(s0)
    lw t0, 816(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 8
    sw t0, 824(s0)
    lw t0, 824(s0)
    fld ft0, 0(t0)
    fsd ft0, 832(s0)
    addi t0, s0, 32
    sw t0, 840(s0)
    lw t0, 840(s0)
    addi t0, t0, 8
    sw t0, 848(s0)
    lw t0, 848(s0)
    fld ft0, 832(s0)
    fsd ft0, 0(t0)
    lw t0, 840(s0)
    addi t0, t0, 16
    sw t0, 856(s0)
    lw t0, 856(s0)
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 840(s0)
    addi t0, t0, 24
    sw t0, 864(s0)
    lw t0, 864(s0)
    li t6, 4
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 840(s0)
    addi t0, t0, 32
    sw t0, 872(s0)
    lw t0, 872(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 8
    sw t0, 880(s0)
    lw t0, 880(s0)
    fld ft0, 0(t0)
    fsd ft0, 888(s0)
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
    li t6, 4
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 896(s0)
    addi t0, t0, 24
    sw t0, 920(s0)
    lw t0, 920(s0)
    li t6, 4
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 896(s0)
    addi t0, t0, 32
    sw t0, 928(s0)
    lw t0, 928(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 8
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
    li t6, 4
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 952(s0)
    addi t0, t0, 24
    sw t0, 976(s0)
    lw t0, 976(s0)
    li t6, 5
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 952(s0)
    addi t0, t0, 32
    sw t0, 984(s0)
    lw t0, 984(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 8
    sw t0, 992(s0)
    lw t0, 992(s0)
    fld ft0, 0(t0)
    fsd ft0, 1000(s0)
    addi t0, s0, 32
    sw t0, 1008(s0)
    lw t0, 1008(s0)
    addi t0, t0, 8
    sw t0, 1016(s0)
    lw t0, 1016(s0)
    fld ft0, 1000(s0)
    fsd ft0, 0(t0)
    lw t0, 1008(s0)
    addi t0, t0, 16
    sw t0, 1024(s0)
    lw t0, 1024(s0)
    li t6, 4
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1008(s0)
    addi t0, t0, 24
    sw t0, 1032(s0)
    lw t0, 1032(s0)
    li t6, 6
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1008(s0)
    addi t0, t0, 32
    sw t0, 1040(s0)
    lw t0, 1040(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 8
    sw t0, 1048(s0)
    lw t0, 1048(s0)
    fld ft0, 0(t0)
    fsd ft0, 1056(s0)
    addi t0, s0, 32
    sw t0, 1064(s0)
    lw t0, 1064(s0)
    addi t0, t0, 8
    sw t0, 1072(s0)
    lw t0, 1072(s0)
    fld ft0, 1056(s0)
    fsd ft0, 0(t0)
    lw t0, 1064(s0)
    addi t0, t0, 16
    sw t0, 1080(s0)
    lw t0, 1080(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1064(s0)
    addi t0, t0, 24
    sw t0, 1088(s0)
    lw t0, 1088(s0)
    li t6, 7
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1064(s0)
    addi t0, t0, 32
    sw t0, 1096(s0)
    lw t0, 1096(s0)
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 8
    sw t0, 1104(s0)
    lw t0, 1104(s0)
    fld ft0, 0(t0)
    fsd ft0, 1112(s0)
    addi t0, s0, 32
    sw t0, 1120(s0)
    lw t0, 1120(s0)
    addi t0, t0, 8
    sw t0, 1128(s0)
    lw t0, 1128(s0)
    fld ft0, 1112(s0)
    fsd ft0, 0(t0)
    lw t0, 1120(s0)
    addi t0, t0, 16
    sw t0, 1136(s0)
    lw t0, 1136(s0)
    li t6, 3
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1120(s0)
    addi t0, t0, 24
    sw t0, 1144(s0)
    lw t0, 1144(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1120(s0)
    addi t0, t0, 32
    sw t0, 1152(s0)
    lw t0, 1152(s0)
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 8
    sw t0, 1160(s0)
    lw t0, 1160(s0)
    fld ft0, 0(t0)
    fsd ft0, 1168(s0)
    addi t0, s0, 32
    sw t0, 1176(s0)
    lw t0, 1176(s0)
    addi t0, t0, 8
    sw t0, 1184(s0)
    lw t0, 1184(s0)
    fld ft0, 1168(s0)
    fsd ft0, 0(t0)
    lw t0, 1176(s0)
    addi t0, t0, 16
    sw t0, 1192(s0)
    lw t0, 1192(s0)
    li t6, 5
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1176(s0)
    addi t0, t0, 24
    sw t0, 1200(s0)
    lw t0, 1200(s0)
    li t6, 4
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1176(s0)
    addi t0, t0, 32
    sw t0, 1208(s0)
    lw t0, 1208(s0)
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 8
    sw t0, 1216(s0)
    lw t0, 1216(s0)
    fld ft0, 0(t0)
    fsd ft0, 1224(s0)
    addi t0, s0, 32
    sw t0, 1232(s0)
    lw t0, 1232(s0)
    addi t0, t0, 8
    sw t0, 1240(s0)
    lw t0, 1240(s0)
    fld ft0, 1224(s0)
    fsd ft0, 0(t0)
    lw t0, 1232(s0)
    addi t0, t0, 16
    sw t0, 1248(s0)
    lw t0, 1248(s0)
    li t6, 5
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1232(s0)
    addi t0, t0, 24
    sw t0, 1256(s0)
    lw t0, 1256(s0)
    li t6, 7
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1232(s0)
    addi t0, t0, 32
    sw t0, 1264(s0)
    lw t0, 1264(s0)
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 8
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
    li t6, 3
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1288(s0)
    addi t0, t0, 24
    sw t0, 1312(s0)
    lw t0, 1312(s0)
    li t6, 3
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1288(s0)
    addi t0, t0, 32
    sw t0, 1320(s0)
    lw t0, 1320(s0)
    li t6, 3
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 8
    sw t0, 1328(s0)
    lw t0, 1328(s0)
    fld ft0, 0(t0)
    fsd ft0, 1336(s0)
    addi t0, s0, 32
    sw t0, 1344(s0)
    lw t0, 1344(s0)
    addi t0, t0, 8
    sw t0, 1352(s0)
    lw t0, 1352(s0)
    fld ft0, 1336(s0)
    fsd ft0, 0(t0)
    lw t0, 1344(s0)
    addi t0, t0, 16
    sw t0, 1360(s0)
    lw t0, 1360(s0)
    li t6, 3
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1344(s0)
    addi t0, t0, 24
    sw t0, 1368(s0)
    lw t0, 1368(s0)
    li t6, 5
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1344(s0)
    addi t0, t0, 32
    sw t0, 1376(s0)
    lw t0, 1376(s0)
    li t6, 3
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 8
    sw t0, 1384(s0)
    lw t0, 1384(s0)
    fld ft0, 0(t0)
    fsd ft0, 1392(s0)
    addi t0, s0, 32
    sw t0, 1400(s0)
    lw t0, 1400(s0)
    addi t0, t0, 8
    sw t0, 1408(s0)
    lw t0, 1408(s0)
    fld ft0, 1392(s0)
    fsd ft0, 0(t0)
    lw t0, 1400(s0)
    addi t0, t0, 16
    sw t0, 1416(s0)
    lw t0, 1416(s0)
    li t6, 5
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1400(s0)
    addi t0, t0, 24
    sw t0, 1424(s0)
    lw t0, 1424(s0)
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1400(s0)
    addi t0, t0, 32
    sw t0, 1432(s0)
    lw t0, 1432(s0)
    li t6, 3
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 8
    sw t0, 1440(s0)
    lw t0, 1440(s0)
    fld ft0, 0(t0)
    fsd ft0, 1448(s0)
    addi t0, s0, 32
    sw t0, 1456(s0)
    lw t0, 1456(s0)
    addi t0, t0, 8
    sw t0, 1464(s0)
    lw t0, 1464(s0)
    fld ft0, 1448(s0)
    fsd ft0, 0(t0)
    lw t0, 1456(s0)
    addi t0, t0, 16
    sw t0, 1472(s0)
    lw t0, 1472(s0)
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1456(s0)
    addi t0, t0, 24
    sw t0, 1480(s0)
    lw t0, 1480(s0)
    li t6, 7
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 1456(s0)
    addi t0, t0, 32
    sw t0, 1488(s0)
    lw t0, 1488(s0)
    li t6, 4
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    fld fa3, 64(s0)
    jal ra, Tablero_colocar_int_int_int_
    fsd fa0, 32(s0)
.L_fin_Tablero_inicializar__:
    fld fa0, 0(s0)
    lw t0, 1496(s0)
    lw ra, 1500(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 1504
    ret

Tablero_puntosPorTipo_int_:
    addi sp, sp, -224
    sw ra, 220(sp)
    sw s0, 216(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 24
    sw t0, 32(s0)
    lw t0, 32(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    fld ft0, 48(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 56(s0)
    fld ft0, 56(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_57
    j .L_Tablero_puntosPorTipo_int__L80
.L_rama_larga_57:
    j .L_Tablero_puntosPorTipo_int__L75
.L_Tablero_puntosPorTipo_int__L80:
    fld ft0, 48(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 64(s0)
    fld ft0, 64(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_58
    j .L_Tablero_puntosPorTipo_int__L81
.L_rama_larga_58:
    j .L_Tablero_puntosPorTipo_int__L76
.L_Tablero_puntosPorTipo_int__L81:
    fld ft0, 48(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 72(s0)
    fld ft0, 72(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_59
    j .L_Tablero_puntosPorTipo_int__L82
.L_rama_larga_59:
    j .L_Tablero_puntosPorTipo_int__L77
.L_Tablero_puntosPorTipo_int__L82:
    j .L_Tablero_puntosPorTipo_int__L78
.L_Tablero_puntosPorTipo_int__L75:
    addi t0, s0, 24
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
    fld ft0, 88(s0)
    li t6, 50
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 96(s0)
    addi t0, s0, 24
    sw t0, 104(s0)
    lw t0, 104(s0)
    fld ft0, 96(s0)
    fsd ft0, 0(t0)
.L_Tablero_puntosPorTipo_int__L76:
    addi t0, s0, 24
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    fld ft0, 120(s0)
    li t6, 10
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 128(s0)
    addi t0, s0, 24
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 128(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_puntosPorTipo_int__L79
.L_Tablero_puntosPorTipo_int__L77:
    addi t0, s0, 24
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    fld ft0, 152(s0)
    li t6, 20
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 160(s0)
    addi t0, s0, 24
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 160(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_puntosPorTipo_int__L79
.L_Tablero_puntosPorTipo_int__L78:
    addi t0, s0, 24
    sw t0, 176(s0)
    lw t0, 176(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Tablero_puntosPorTipo_int__L79:
    addi t0, s0, 24
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 0(t0)
    fsd ft0, 192(s0)
    addi t0, s0, 0
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 192(s0)
    fsd ft0, 0(t0)
    j .L_fin_Tablero_puntosPorTipo_int_
.L_fin_Tablero_puntosPorTipo_int_:
    fld fa0, 0(s0)
    lw t0, 216(s0)
    lw ra, 220(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 224
    ret

Tablero_recoger_int_int_:
    addi sp, sp, -544
    sw ra, 540(sp)
    sw s0, 536(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fsd fa2, 24(s0)
    addi t0, s0, 8
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    fld ft0, 48(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 56(s0)
    fld ft3, 56(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    addi t0, s0, 16
    sw t0, 72(s0)
    lw t0, 72(s0)
    fld ft0, 0(t0)
    fsd ft0, 80(s0)
    addi t0, s0, 24
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 0(t0)
    fsd ft0, 96(s0)
    fld ft0, 64(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 104(s0)
    fld ft3, 104(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    fld ft0, 80(s0)
    fld ft1, 112(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 120(s0)
    fld ft0, 120(s0)
    fld ft1, 96(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 128(s0)
    fld ft0, 64(s0)
    li t6, 3
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
    addi t0, s0, 32
    sw t0, 160(s0)
    lw t0, 160(s0)
    fld ft0, 152(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 32
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    fld ft0, 176(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 184(s0)
    fld ft0, 184(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_60
    j .L_Tablero_recoger_int_int__L84
.L_rama_larga_60:
    addi t0, s0, 8
    sw t0, 192(s0)
    lw t0, 192(s0)
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    fld ft0, 200(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 208(s0)
    fld ft3, 208(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    fld ft0, 216(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 224(s0)
    fld ft3, 208(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 224(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 232(s0)
    lw t0, 232(s0)
    fld ft0, 0(t0)
    fsd ft0, 240(s0)
    fld ft0, 240(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 248(s0)
    fld ft3, 248(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 256(s0)
    addi t0, s0, 16
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 0(t0)
    fsd ft0, 272(s0)
    addi t0, s0, 24
    sw t0, 280(s0)
    lw t0, 280(s0)
    fld ft0, 0(t0)
    fsd ft0, 288(s0)
    fld ft0, 256(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 296(s0)
    fld ft3, 296(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 304(s0)
    fld ft0, 272(s0)
    fld ft1, 304(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 312(s0)
    fld ft0, 312(s0)
    fld ft1, 288(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 320(s0)
    fld ft0, 256(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 328(s0)
    fld ft0, 328(s0)
    fld ft1, 320(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 336(s0)
    fld ft3, 336(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_Tablero_recoger_int_int__L83
.L_Tablero_recoger_int_int__L84:
    addi t0, s0, 32
    sw t0, 344(s0)
    lw t0, 344(s0)
    fld ft0, 0(t0)
    fsd ft0, 352(s0)
    fld ft0, 352(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 360(s0)
    fld ft0, 360(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_61
    j .L_Tablero_recoger_int_int__L86
.L_rama_larga_61:
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 368(s0)
    j .L_Tablero_recoger_int_int__L87
.L_Tablero_recoger_int_int__L86:
    addi t0, s0, 32
    sw t0, 376(s0)
    lw t0, 376(s0)
    fld ft0, 0(t0)
    fsd ft0, 384(s0)
    fld ft0, 384(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 392(s0)
    fld ft0, 392(s0)
    fsd ft0, 368(s0)
.L_Tablero_recoger_int_int__L87:
    fld ft0, 368(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_62
    j .L_Tablero_recoger_int_int__L85
.L_rama_larga_62:
    addi t0, s0, 8
    sw t0, 400(s0)
    lw t0, 400(s0)
    fld ft0, 0(t0)
    fsd ft0, 408(s0)
    fld ft0, 408(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 416(s0)
    fld ft3, 416(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 424(s0)
    addi t0, s0, 16
    sw t0, 432(s0)
    lw t0, 432(s0)
    fld ft0, 0(t0)
    fsd ft0, 440(s0)
    addi t0, s0, 24
    sw t0, 448(s0)
    lw t0, 448(s0)
    fld ft0, 0(t0)
    fsd ft0, 456(s0)
    fld ft0, 424(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 464(s0)
    fld ft3, 464(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 472(s0)
    fld ft0, 440(s0)
    fld ft1, 472(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 480(s0)
    fld ft0, 480(s0)
    fld ft1, 456(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 488(s0)
    fld ft0, 424(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 496(s0)
    fld ft0, 496(s0)
    fld ft1, 488(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 504(s0)
    fld ft3, 504(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_Tablero_recoger_int_int__L83
.L_Tablero_recoger_int_int__L85:
.L_Tablero_recoger_int_int__L83:
    addi t0, s0, 32
    sw t0, 512(s0)
    lw t0, 512(s0)
    fld ft0, 0(t0)
    fsd ft0, 520(s0)
    addi t0, s0, 0
    sw t0, 528(s0)
    lw t0, 528(s0)
    fld ft0, 520(s0)
    fsd ft0, 0(t0)
    j .L_fin_Tablero_recoger_int_int_
.L_fin_Tablero_recoger_int_int_:
    fld fa0, 0(s0)
    lw t0, 536(s0)
    lw ra, 540(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 544
    ret

Tablero_contarTipo_int_:
    addi sp, sp, -464
    sw ra, 460(sp)
    sw s0, 456(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 24
    sw t0, 48(s0)
    lw t0, 48(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 32
    sw t0, 56(s0)
    lw t0, 56(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Tablero_contarTipo_int__L88:
    addi t0, s0, 32
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
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 96(s0)
    fld ft3, 96(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    fld ft0, 72(s0)
    fld ft1, 104(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 112(s0)
    fld ft0, 112(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_63
    j .L_Tablero_contarTipo_int__L90
.L_rama_larga_63:
    addi t0, s0, 40
    sw t0, 120(s0)
    lw t0, 120(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Tablero_contarTipo_int__L91:
    addi t0, s0, 40
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    addi t0, s0, 8
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    fld ft0, 152(s0)
    li t6, 3
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
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 176(s0)
    fld ft0, 176(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_64
    j .L_Tablero_contarTipo_int__L93
.L_rama_larga_64:
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
    addi t0, s0, 32
    sw t0, 216(s0)
    lw t0, 216(s0)
    fld ft0, 0(t0)
    fsd ft0, 224(s0)
    addi t0, s0, 40
    sw t0, 232(s0)
    lw t0, 232(s0)
    fld ft0, 0(t0)
    fsd ft0, 240(s0)
    fld ft0, 208(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 248(s0)
    fld ft3, 248(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 256(s0)
    fld ft0, 224(s0)
    fld ft1, 256(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 264(s0)
    fld ft0, 264(s0)
    fld ft1, 240(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 272(s0)
    fld ft0, 208(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 280(s0)
    fld ft0, 280(s0)
    fld ft1, 272(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 288(s0)
    fld ft3, 288(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 296(s0)
    addi t0, s0, 16
    sw t0, 304(s0)
    lw t0, 304(s0)
    fld ft0, 0(t0)
    fsd ft0, 312(s0)
    fld ft0, 296(s0)
    fld ft1, 312(s0)
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 320(s0)
    fld ft0, 320(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_65
    j .L_Tablero_contarTipo_int__L95
.L_rama_larga_65:
    j .L_Tablero_contarTipo_int__L92
    j .L_Tablero_contarTipo_int__L94
.L_Tablero_contarTipo_int__L95:
.L_Tablero_contarTipo_int__L94:
    addi t0, s0, 24
    sw t0, 328(s0)
    lw t0, 328(s0)
    fld ft0, 0(t0)
    fsd ft0, 336(s0)
    fld ft0, 336(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 344(s0)
    addi t0, s0, 24
    sw t0, 352(s0)
    lw t0, 352(s0)
    fld ft0, 344(s0)
    fsd ft0, 0(t0)
.L_Tablero_contarTipo_int__L92:
    addi t0, s0, 40
    sw t0, 360(s0)
    lw t0, 360(s0)
    fld ft0, 0(t0)
    fsd ft0, 368(s0)
    fld ft0, 368(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 376(s0)
    addi t0, s0, 40
    sw t0, 384(s0)
    lw t0, 384(s0)
    fld ft0, 376(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_contarTipo_int__L91
.L_Tablero_contarTipo_int__L93:
.L_Tablero_contarTipo_int__L89:
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
    j .L_Tablero_contarTipo_int__L88
.L_Tablero_contarTipo_int__L90:
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
    j .L_fin_Tablero_contarTipo_int_
.L_fin_Tablero_contarTipo_int_:
    fld fa0, 0(s0)
    lw t0, 456(s0)
    lw ra, 460(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 464
    ret

Tablero_primeraColumnaLibre_int_:
    addi sp, sp, -304
    sw ra, 300(sp)
    sw s0, 296(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 24
    sw t0, 32(s0)
    lw t0, 32(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Tablero_primeraColumnaLibre_int__L96:
    addi t0, s0, 24
    sw t0, 40(s0)
    lw t0, 40(s0)
    fld ft0, 0(t0)
    fsd ft0, 48(s0)
    fld ft0, 48(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 56(s0)
    addi t0, s0, 24
    sw t0, 64(s0)
    lw t0, 64(s0)
    fld ft0, 56(s0)
    fsd ft0, 0(t0)
.L_Tablero_primeraColumnaLibre_int__L97:
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
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 104(s0)
    fld ft3, 104(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 112(s0)
    fld ft0, 80(s0)
    fld ft1, 112(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 120(s0)
    fld ft0, 120(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_66
    j .L_Tablero_primeraColumnaLibre_int__L99
.L_rama_larga_66:
    addi t0, s0, 8
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 0(t0)
    fsd ft0, 136(s0)
    fld ft0, 136(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    fld ft3, 144(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    addi t0, s0, 16
    sw t0, 160(s0)
    lw t0, 160(s0)
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    addi t0, s0, 24
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 0(t0)
    fsd ft0, 184(s0)
    fld ft0, 152(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 192(s0)
    fld ft3, 192(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    fld ft0, 168(s0)
    fld ft1, 200(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 208(s0)
    fld ft0, 208(s0)
    fld ft1, 184(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 216(s0)
    fld ft0, 152(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 224(s0)
    fld ft0, 224(s0)
    fld ft1, 216(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 232(s0)
    fld ft3, 232(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 240(s0)
    fld ft0, 240(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 248(s0)
    fld ft0, 248(s0)
    fsd ft0, 256(s0)
    j .L_Tablero_primeraColumnaLibre_int__L100
.L_Tablero_primeraColumnaLibre_int__L99:
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 256(s0)
.L_Tablero_primeraColumnaLibre_int__L100:
    fld ft0, 256(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_67
    j .L_Tablero_primeraColumnaLibre_int__L98
.L_rama_larga_67:
    j .L_Tablero_primeraColumnaLibre_int__L96
.L_Tablero_primeraColumnaLibre_int__L98:
    addi t0, s0, 24
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 0(t0)
    fsd ft0, 272(s0)
    addi t0, s0, 0
    sw t0, 280(s0)
    lw t0, 280(s0)
    fld ft0, 272(s0)
    fsd ft0, 0(t0)
    j .L_fin_Tablero_primeraColumnaLibre_int_
.L_fin_Tablero_primeraColumnaLibre_int_:
    fld fa0, 0(s0)
    lw t0, 296(s0)
    lw ra, 300(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 304
    ret

Tablero_distanciaAPared_int_int_int_int_:
    addi sp, sp, -560
    sw ra, 556(sp)
    sw s0, 552(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fsd fa2, 24(s0)
    fsd fa3, 32(s0)
    fsd fa4, 40(s0)
    addi t0, s0, 48
    sw t0, 104(s0)
    lw t0, 104(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    addi t0, s0, 56
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 120(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 0(t0)
    fsd ft0, 144(s0)
    addi t0, s0, 64
    sw t0, 152(s0)
    lw t0, 152(s0)
    fld ft0, 144(s0)
    fsd ft0, 0(t0)
.L_Tablero_distanciaAPared_int_int_int_int__L101:
    addi t0, s0, 32
    sw t0, 160(s0)
    lw t0, 160(s0)
    fld ft0, 0(t0)
    fsd ft0, 168(s0)
    addi t0, s0, 56
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 0(t0)
    fsd ft0, 184(s0)
    fld ft0, 184(s0)
    fld ft1, 168(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 192(s0)
    addi t0, s0, 56
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 192(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 40
    sw t0, 208(s0)
    lw t0, 208(s0)
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    addi t0, s0, 64
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 232(s0)
    fld ft1, 216(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 240(s0)
    addi t0, s0, 64
    sw t0, 248(s0)
    lw t0, 248(s0)
    fld ft0, 240(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 256(s0)
    lw t0, 256(s0)
    fld ft0, 0(t0)
    fsd ft0, 264(s0)
    addi t0, s0, 56
    sw t0, 272(s0)
    lw t0, 272(s0)
    fld ft0, 0(t0)
    fsd ft0, 280(s0)
    addi t0, s0, 64
    sw t0, 288(s0)
    lw t0, 288(s0)
    fld ft0, 0(t0)
    fsd ft0, 296(s0)
    addi t0, s0, 72
    sw t0, 304(s0)
    lw t0, 304(s0)
    addi t0, t0, 8
    sw t0, 312(s0)
    lw t0, 312(s0)
    fld ft0, 264(s0)
    fsd ft0, 0(t0)
    lw t0, 304(s0)
    addi t0, t0, 16
    sw t0, 320(s0)
    lw t0, 320(s0)
    fld ft0, 280(s0)
    fsd ft0, 0(t0)
    lw t0, 304(s0)
    addi t0, t0, 24
    sw t0, 328(s0)
    lw t0, 328(s0)
    fld ft0, 296(s0)
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    fld fa1, 88(s0)
    fld fa2, 96(s0)
    jal ra, Tablero_esValida_int_int_
    fsd fa0, 72(s0)
    addi t0, s0, 72
    sw t0, 336(s0)
    lw t0, 336(s0)
    fld ft0, 0(t0)
    fsd ft0, 344(s0)
    fld ft0, 344(s0)
    fcvt.w.d t0, ft0
    seqz t0, t0
    fcvt.d.w ft1, t0
    fsd ft1, 352(s0)
    fld ft0, 352(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_68
    j .L_Tablero_distanciaAPared_int_int_int_int__L106
.L_rama_larga_68:
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 360(s0)
    j .L_Tablero_distanciaAPared_int_int_int_int__L107
.L_Tablero_distanciaAPared_int_int_int_int__L106:
    addi t0, s0, 8
    sw t0, 368(s0)
    lw t0, 368(s0)
    fld ft0, 0(t0)
    fsd ft0, 376(s0)
    fld ft0, 376(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 384(s0)
    fld ft3, 384(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 392(s0)
    addi t0, s0, 56
    sw t0, 400(s0)
    lw t0, 400(s0)
    fld ft0, 0(t0)
    fsd ft0, 408(s0)
    addi t0, s0, 64
    sw t0, 416(s0)
    lw t0, 416(s0)
    fld ft0, 0(t0)
    fsd ft0, 424(s0)
    fld ft0, 392(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 432(s0)
    fld ft3, 432(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 440(s0)
    fld ft0, 408(s0)
    fld ft1, 440(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 448(s0)
    fld ft0, 448(s0)
    fld ft1, 424(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 456(s0)
    fld ft0, 392(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 464(s0)
    fld ft0, 464(s0)
    fld ft1, 456(s0)
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
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 488(s0)
    fld ft0, 488(s0)
    fsd ft0, 360(s0)
.L_Tablero_distanciaAPared_int_int_int_int__L107:
    fld ft0, 360(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_69
    j .L_Tablero_distanciaAPared_int_int_int_int__L105
.L_rama_larga_69:
    j .L_Tablero_distanciaAPared_int_int_int_int__L103
    j .L_Tablero_distanciaAPared_int_int_int_int__L104
.L_Tablero_distanciaAPared_int_int_int_int__L105:
.L_Tablero_distanciaAPared_int_int_int_int__L104:
    addi t0, s0, 48
    sw t0, 496(s0)
    lw t0, 496(s0)
    fld ft0, 0(t0)
    fsd ft0, 504(s0)
    fld ft0, 504(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 512(s0)
    addi t0, s0, 48
    sw t0, 520(s0)
    lw t0, 520(s0)
    fld ft0, 512(s0)
    fsd ft0, 0(t0)
.L_Tablero_distanciaAPared_int_int_int_int__L102:
    j .L_Tablero_distanciaAPared_int_int_int_int__L101
.L_Tablero_distanciaAPared_int_int_int_int__L103:
    addi t0, s0, 48
    sw t0, 528(s0)
    lw t0, 528(s0)
    fld ft0, 0(t0)
    fsd ft0, 536(s0)
    addi t0, s0, 0
    sw t0, 544(s0)
    lw t0, 544(s0)
    fld ft0, 536(s0)
    fsd ft0, 0(t0)
    j .L_fin_Tablero_distanciaAPared_int_int_int_int_
.L_fin_Tablero_distanciaAPared_int_int_int_int_:
    fld fa0, 0(s0)
    lw t0, 552(s0)
    lw ra, 556(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 560
    ret

Tablero_explorar_int_int_:
    addi sp, sp, -1024
    sw ra, 1020(sp)
    sw s0, 1016(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fsd fa2, 24(s0)
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
    addi t0, s0, 24
    sw t0, 96(s0)
    lw t0, 96(s0)
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    addi t0, s0, 32
    sw t0, 112(s0)
    lw t0, 112(s0)
    addi t0, t0, 8
    sw t0, 120(s0)
    lw t0, 120(s0)
    fld ft0, 72(s0)
    fsd ft0, 0(t0)
    lw t0, 112(s0)
    addi t0, t0, 16
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 88(s0)
    fsd ft0, 0(t0)
    lw t0, 112(s0)
    addi t0, t0, 24
    sw t0, 136(s0)
    lw t0, 136(s0)
    fld ft0, 104(s0)
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    jal ra, Tablero_esValida_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 32
    sw t0, 144(s0)
    lw t0, 144(s0)
    fld ft0, 0(t0)
    fsd ft0, 152(s0)
    fld ft0, 152(s0)
    fcvt.w.d t0, ft0
    seqz t0, t0
    fcvt.d.w ft1, t0
    fsd ft1, 160(s0)
    fld ft0, 160(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_70
    j .L_Tablero_explorar_int_int__L109
.L_rama_larga_70:
    addi t0, s0, 0
    sw t0, 168(s0)
    lw t0, 168(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Tablero_explorar_int_int_
    j .L_Tablero_explorar_int_int__L108
.L_Tablero_explorar_int_int__L109:
.L_Tablero_explorar_int_int__L108:
    addi t0, s0, 8
    sw t0, 176(s0)
    lw t0, 176(s0)
    fld ft0, 0(t0)
    fsd ft0, 184(s0)
    fld ft0, 184(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 192(s0)
    fld ft3, 192(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    addi t0, s0, 16
    sw t0, 208(s0)
    lw t0, 208(s0)
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
    addi t0, s0, 24
    sw t0, 224(s0)
    lw t0, 224(s0)
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 200(s0)
    li t6, 2
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
    fld ft1, 248(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    fld ft0, 256(s0)
    fld ft1, 232(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 264(s0)
    fld ft0, 200(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 272(s0)
    fld ft0, 272(s0)
    fld ft1, 264(s0)
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
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 296(s0)
    fld ft0, 296(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_71
    j .L_Tablero_explorar_int_int__L111
.L_rama_larga_71:
    addi t0, s0, 0
    sw t0, 304(s0)
    lw t0, 304(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Tablero_explorar_int_int_
    j .L_Tablero_explorar_int_int__L110
.L_Tablero_explorar_int_int__L111:
.L_Tablero_explorar_int_int__L110:
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
    addi t0, s0, 16
    sw t0, 344(s0)
    lw t0, 344(s0)
    fld ft0, 0(t0)
    fsd ft0, 352(s0)
    addi t0, s0, 24
    sw t0, 360(s0)
    lw t0, 360(s0)
    fld ft0, 0(t0)
    fsd ft0, 368(s0)
    fld ft0, 336(s0)
    li t6, 2
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
    fmul.d ft2, ft0, ft1
    fsd ft2, 392(s0)
    fld ft0, 392(s0)
    fld ft1, 368(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 400(s0)
    fld ft0, 336(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 408(s0)
    fld ft0, 408(s0)
    fld ft1, 400(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 416(s0)
    fld ft3, 416(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 424(s0)
    fld ft0, 424(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_72
    j .L_Tablero_explorar_int_int__L113
.L_rama_larga_72:
    addi t0, s0, 0
    sw t0, 432(s0)
    lw t0, 432(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Tablero_explorar_int_int_
    j .L_Tablero_explorar_int_int__L112
.L_Tablero_explorar_int_int__L113:
.L_Tablero_explorar_int_int__L112:
    addi t0, s0, 8
    sw t0, 440(s0)
    lw t0, 440(s0)
    fld ft0, 0(t0)
    fsd ft0, 448(s0)
    fld ft0, 448(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 456(s0)
    fld ft3, 456(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 464(s0)
    addi t0, s0, 16
    sw t0, 472(s0)
    lw t0, 472(s0)
    fld ft0, 0(t0)
    fsd ft0, 480(s0)
    addi t0, s0, 24
    sw t0, 488(s0)
    lw t0, 488(s0)
    fld ft0, 0(t0)
    fsd ft0, 496(s0)
    fld ft0, 464(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 504(s0)
    fld ft3, 504(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 512(s0)
    fld ft0, 480(s0)
    fld ft1, 512(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 520(s0)
    fld ft0, 520(s0)
    fld ft1, 496(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 528(s0)
    fld ft0, 464(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 536(s0)
    fld ft0, 536(s0)
    fld ft1, 528(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 544(s0)
    fld ft3, 544(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 552(s0)
    lw t0, 552(s0)
    fld ft0, 0(t0)
    fsd ft0, 560(s0)
    addi t0, s0, 16
    sw t0, 568(s0)
    lw t0, 568(s0)
    fld ft0, 0(t0)
    fsd ft0, 576(s0)
    fld ft0, 576(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 584(s0)
    addi t0, s0, 24
    sw t0, 592(s0)
    lw t0, 592(s0)
    fld ft0, 0(t0)
    fsd ft0, 600(s0)
    addi t0, s0, 32
    sw t0, 608(s0)
    lw t0, 608(s0)
    addi t0, t0, 8
    sw t0, 616(s0)
    lw t0, 616(s0)
    fld ft0, 560(s0)
    fsd ft0, 0(t0)
    lw t0, 608(s0)
    addi t0, t0, 16
    sw t0, 624(s0)
    lw t0, 624(s0)
    fld ft0, 584(s0)
    fsd ft0, 0(t0)
    lw t0, 608(s0)
    addi t0, t0, 24
    sw t0, 632(s0)
    lw t0, 632(s0)
    fld ft0, 600(s0)
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    jal ra, Tablero_explorar_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 32
    sw t0, 640(s0)
    lw t0, 640(s0)
    fld ft0, 0(t0)
    fsd ft0, 648(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fld ft1, 648(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 656(s0)
    addi t0, s0, 8
    sw t0, 664(s0)
    lw t0, 664(s0)
    fld ft0, 0(t0)
    fsd ft0, 672(s0)
    addi t0, s0, 16
    sw t0, 680(s0)
    lw t0, 680(s0)
    fld ft0, 0(t0)
    fsd ft0, 688(s0)
    fld ft0, 688(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 696(s0)
    addi t0, s0, 24
    sw t0, 704(s0)
    lw t0, 704(s0)
    fld ft0, 0(t0)
    fsd ft0, 712(s0)
    addi t0, s0, 32
    sw t0, 720(s0)
    lw t0, 720(s0)
    addi t0, t0, 8
    sw t0, 728(s0)
    lw t0, 728(s0)
    fld ft0, 672(s0)
    fsd ft0, 0(t0)
    lw t0, 720(s0)
    addi t0, t0, 16
    sw t0, 736(s0)
    lw t0, 736(s0)
    fld ft0, 696(s0)
    fsd ft0, 0(t0)
    lw t0, 720(s0)
    addi t0, t0, 24
    sw t0, 744(s0)
    lw t0, 744(s0)
    fld ft0, 712(s0)
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    jal ra, Tablero_explorar_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 32
    sw t0, 752(s0)
    lw t0, 752(s0)
    fld ft0, 0(t0)
    fsd ft0, 760(s0)
    fld ft0, 656(s0)
    fld ft1, 760(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 768(s0)
    addi t0, s0, 8
    sw t0, 776(s0)
    lw t0, 776(s0)
    fld ft0, 0(t0)
    fsd ft0, 784(s0)
    addi t0, s0, 16
    sw t0, 792(s0)
    lw t0, 792(s0)
    fld ft0, 0(t0)
    fsd ft0, 800(s0)
    addi t0, s0, 24
    sw t0, 808(s0)
    lw t0, 808(s0)
    fld ft0, 0(t0)
    fsd ft0, 816(s0)
    fld ft0, 816(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 824(s0)
    addi t0, s0, 32
    sw t0, 832(s0)
    lw t0, 832(s0)
    addi t0, t0, 8
    sw t0, 840(s0)
    lw t0, 840(s0)
    fld ft0, 784(s0)
    fsd ft0, 0(t0)
    lw t0, 832(s0)
    addi t0, t0, 16
    sw t0, 848(s0)
    lw t0, 848(s0)
    fld ft0, 800(s0)
    fsd ft0, 0(t0)
    lw t0, 832(s0)
    addi t0, t0, 24
    sw t0, 856(s0)
    lw t0, 856(s0)
    fld ft0, 824(s0)
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    jal ra, Tablero_explorar_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 32
    sw t0, 864(s0)
    lw t0, 864(s0)
    fld ft0, 0(t0)
    fsd ft0, 872(s0)
    fld ft0, 768(s0)
    fld ft1, 872(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 880(s0)
    addi t0, s0, 8
    sw t0, 888(s0)
    lw t0, 888(s0)
    fld ft0, 0(t0)
    fsd ft0, 896(s0)
    addi t0, s0, 16
    sw t0, 904(s0)
    lw t0, 904(s0)
    fld ft0, 0(t0)
    fsd ft0, 912(s0)
    addi t0, s0, 24
    sw t0, 920(s0)
    lw t0, 920(s0)
    fld ft0, 0(t0)
    fsd ft0, 928(s0)
    fld ft0, 928(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 936(s0)
    addi t0, s0, 32
    sw t0, 944(s0)
    lw t0, 944(s0)
    addi t0, t0, 8
    sw t0, 952(s0)
    lw t0, 952(s0)
    fld ft0, 896(s0)
    fsd ft0, 0(t0)
    lw t0, 944(s0)
    addi t0, t0, 16
    sw t0, 960(s0)
    lw t0, 960(s0)
    fld ft0, 912(s0)
    fsd ft0, 0(t0)
    lw t0, 944(s0)
    addi t0, t0, 24
    sw t0, 968(s0)
    lw t0, 968(s0)
    fld ft0, 936(s0)
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    jal ra, Tablero_explorar_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 32
    sw t0, 976(s0)
    lw t0, 976(s0)
    fld ft0, 0(t0)
    fsd ft0, 984(s0)
    fld ft0, 880(s0)
    fld ft1, 984(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 992(s0)
    addi t0, s0, 0
    sw t0, 1000(s0)
    lw t0, 1000(s0)
    fld ft0, 992(s0)
    fsd ft0, 0(t0)
    j .L_fin_Tablero_explorar_int_int_
.L_fin_Tablero_explorar_int_int_:
    fld fa0, 0(s0)
    lw t0, 1016(s0)
    lw ra, 1020(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 1024
    ret

Tablero_contarAccesibles_int_int_:
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
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 80(s0)
    fld ft3, 80(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
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
    fcvt.d.w ft0, s2
    fsd ft0, 128(s0)
    fld ft3, 128(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 128(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 136(s0)
    fld ft3, 136(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 88(s0)
    fsd ft0, 0(t0)
    fld ft0, 128(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 144(s0)
    fld ft3, 144(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 120(s0)
    fsd ft0, 0(t0)
    fld ft0, 88(s0)
    fld ft1, 120(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 152(s0)
    fld ft0, 152(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 160(s0)
    fcvt.d.w ft0, s2
    fld ft1, 160(s0)
    fadd.d ft2, ft0, ft1
    fcvt.w.d s2, ft2
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
    fld ft0, 128(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 192(s0)
    lw t0, 192(s0)
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    addi t0, s0, 16
    sw t0, 208(s0)
    lw t0, 208(s0)
    fld ft0, 0(t0)
    fsd ft0, 216(s0)
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
    fld ft0, 200(s0)
    fsd ft0, 0(t0)
    lw t0, 240(s0)
    addi t0, t0, 16
    sw t0, 256(s0)
    lw t0, 256(s0)
    fld ft0, 216(s0)
    fsd ft0, 0(t0)
    lw t0, 240(s0)
    addi t0, t0, 24
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 232(s0)
    fsd ft0, 0(t0)
    fld fa0, 40(s0)
    fld fa1, 48(s0)
    fld fa2, 56(s0)
    jal ra, Tablero_explorar_int_int_
    fsd fa0, 32(s0)
    addi t0, s0, 32
    sw t0, 272(s0)
    lw t0, 272(s0)
    fld ft0, 0(t0)
    fsd ft0, 280(s0)
    addi t0, s0, 0
    sw t0, 288(s0)
    lw t0, 288(s0)
    fld ft0, 280(s0)
    fsd ft0, 0(t0)
    j .L_fin_Tablero_contarAccesibles_int_int_
.L_fin_Tablero_contarAccesibles_int_int_:
    fld fa0, 0(s0)
    lw t0, 296(s0)
    lw ra, 300(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 304
    ret

Tablero_imprimir_int_int_:
    addi sp, sp, -1552
    sw ra, 1548(sp)
    sw s0, 1544(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fsd fa2, 24(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 32
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 72(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 40
    sw t0, 88(s0)
    lw t0, 88(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Tablero_imprimir_int_int__L114:
    addi t0, s0, 40
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
    li t6, 3
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
    bnez t0, .L_rama_larga_73
    j .L_Tablero_imprimir_int_int__L116
.L_rama_larga_73:
    addi t0, s0, 32
    sw t0, 152(s0)
    lw t0, 152(s0)
    fld ft0, 0(t0)
    fsd ft0, 160(s0)
    addi t0, s0, 40
    sw t0, 168(s0)
    lw t0, 168(s0)
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    fld fa0, 176(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 184(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 192(s0)
    fld ft0, 160(s0)
    fsd ft0, 200(s0)
.L_Tablero_imprimir_int_int__L117:
    fld ft3, 200(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 208(s0)
    fld ft0, 208(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 216(s0)
    fld ft0, 216(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_74
    j .L_Tablero_imprimir_int_int__L118
.L_rama_larga_74:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 208(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 200(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 200(s0)
    j .L_Tablero_imprimir_int_int__L117
.L_Tablero_imprimir_int_int__L118:
    fld ft0, 184(s0)
    fsd ft0, 224(s0)
.L_Tablero_imprimir_int_int__L119:
    fld ft3, 224(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 232(s0)
    fld ft0, 232(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 240(s0)
    fld ft0, 240(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_75
    j .L_Tablero_imprimir_int_int__L120
.L_rama_larga_75:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 232(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 224(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 224(s0)
    j .L_Tablero_imprimir_int_int__L119
.L_Tablero_imprimir_int_int__L120:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 248(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    fsd ft0, 256(s0)
    fld ft0, 192(s0)
    fsd ft0, 264(s0)
.L_Tablero_imprimir_int_int__L121:
    fld ft3, 264(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 272(s0)
    fld ft0, 272(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 280(s0)
    fld ft0, 280(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_76
    j .L_Tablero_imprimir_int_int__L122
.L_rama_larga_76:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 272(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 264(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 264(s0)
    j .L_Tablero_imprimir_int_int__L121
.L_Tablero_imprimir_int_int__L122:
    fld ft0, 248(s0)
    fsd ft0, 288(s0)
.L_Tablero_imprimir_int_int__L123:
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
    bnez t0, .L_rama_larga_77
    j .L_Tablero_imprimir_int_int__L124
.L_rama_larga_77:
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
    j .L_Tablero_imprimir_int_int__L123
.L_Tablero_imprimir_int_int__L124:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 32
    sw t0, 312(s0)
    lw t0, 312(s0)
    fld ft0, 256(s0)
    fsd ft0, 0(t0)
.L_Tablero_imprimir_int_int__L115:
    addi t0, s0, 40
    sw t0, 320(s0)
    lw t0, 320(s0)
    fld ft0, 0(t0)
    fsd ft0, 328(s0)
    fld ft0, 328(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 336(s0)
    addi t0, s0, 40
    sw t0, 344(s0)
    lw t0, 344(s0)
    fld ft0, 336(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_imprimir_int_int__L114
.L_Tablero_imprimir_int_int__L116:
    addi t0, s0, 32
    sw t0, 352(s0)
    lw t0, 352(s0)
    fld ft0, 0(t0)
    fsd ft0, 360(s0)
    fld ft0, 360(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 48
    sw t0, 368(s0)
    lw t0, 368(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Tablero_imprimir_int_int__L125:
    addi t0, s0, 48
    sw t0, 376(s0)
    lw t0, 376(s0)
    fld ft0, 0(t0)
    fsd ft0, 384(s0)
    addi t0, s0, 8
    sw t0, 392(s0)
    lw t0, 392(s0)
    fld ft0, 0(t0)
    fsd ft0, 400(s0)
    fld ft0, 400(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 408(s0)
    fld ft3, 408(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 416(s0)
    fld ft0, 384(s0)
    fld ft1, 416(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 424(s0)
    fld ft0, 424(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_78
    j .L_Tablero_imprimir_int_int__L127
.L_rama_larga_78:
    addi t0, s0, 48
    sw t0, 432(s0)
    lw t0, 432(s0)
    fld ft0, 0(t0)
    fsd ft0, 440(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 448(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    fld fa0, 440(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 456(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 464(s0)
    fld ft0, 456(s0)
    fsd ft0, 472(s0)
.L_Tablero_imprimir_int_int__L128:
    fld ft3, 472(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 480(s0)
    fld ft0, 480(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 488(s0)
    fld ft0, 488(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_79
    j .L_Tablero_imprimir_int_int__L129
.L_rama_larga_79:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 480(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 472(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 472(s0)
    j .L_Tablero_imprimir_int_int__L128
.L_Tablero_imprimir_int_int__L129:
    fld ft0, 448(s0)
    fsd ft0, 496(s0)
.L_Tablero_imprimir_int_int__L130:
    fld ft3, 496(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 504(s0)
    fld ft0, 504(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 512(s0)
    fld ft0, 512(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_80
    j .L_Tablero_imprimir_int_int__L131
.L_rama_larga_80:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 504(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 496(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 496(s0)
    j .L_Tablero_imprimir_int_int__L130
.L_Tablero_imprimir_int_int__L131:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 56
    sw t0, 520(s0)
    lw t0, 520(s0)
    fld ft0, 464(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 64
    sw t0, 528(s0)
    lw t0, 528(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_Tablero_imprimir_int_int__L132:
    addi t0, s0, 64
    sw t0, 536(s0)
    lw t0, 536(s0)
    fld ft0, 0(t0)
    fsd ft0, 544(s0)
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
    fld ft0, 544(s0)
    fld ft1, 576(s0)
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 584(s0)
    fld ft0, 584(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_81
    j .L_Tablero_imprimir_int_int__L134
.L_rama_larga_81:
    addi t0, s0, 48
    sw t0, 592(s0)
    lw t0, 592(s0)
    fld ft0, 0(t0)
    fsd ft0, 600(s0)
    addi t0, s0, 16
    sw t0, 608(s0)
    lw t0, 608(s0)
    fld ft0, 0(t0)
    fsd ft0, 616(s0)
    fld ft0, 600(s0)
    fld ft1, 616(s0)
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 624(s0)
    fld ft0, 624(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_82
    j .L_Tablero_imprimir_int_int__L137
.L_rama_larga_82:
    addi t0, s0, 64
    sw t0, 632(s0)
    lw t0, 632(s0)
    fld ft0, 0(t0)
    fsd ft0, 640(s0)
    addi t0, s0, 24
    sw t0, 648(s0)
    lw t0, 648(s0)
    fld ft0, 0(t0)
    fsd ft0, 656(s0)
    fld ft0, 640(s0)
    fld ft1, 656(s0)
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 664(s0)
    fld ft0, 664(s0)
    fsd ft0, 672(s0)
    j .L_Tablero_imprimir_int_int__L138
.L_Tablero_imprimir_int_int__L137:
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 672(s0)
.L_Tablero_imprimir_int_int__L138:
    fld ft0, 672(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_83
    j .L_Tablero_imprimir_int_int__L136
.L_rama_larga_83:
    addi t0, s0, 56
    sw t0, 680(s0)
    lw t0, 680(s0)
    fld ft0, 0(t0)
    fsd ft0, 688(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 696(s0)
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
    fsd ft0, 704(s0)
    fld ft0, 688(s0)
    fsd ft0, 712(s0)
.L_Tablero_imprimir_int_int__L139:
    fld ft3, 712(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 720(s0)
    fld ft0, 720(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 728(s0)
    fld ft0, 728(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_84
    j .L_Tablero_imprimir_int_int__L140
.L_rama_larga_84:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 720(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 712(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 712(s0)
    j .L_Tablero_imprimir_int_int__L139
.L_Tablero_imprimir_int_int__L140:
    fld ft0, 696(s0)
    fsd ft0, 736(s0)
.L_Tablero_imprimir_int_int__L141:
    fld ft3, 736(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 744(s0)
    fld ft0, 744(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 752(s0)
    fld ft0, 752(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_85
    j .L_Tablero_imprimir_int_int__L142
.L_rama_larga_85:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 744(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 736(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 736(s0)
    j .L_Tablero_imprimir_int_int__L141
.L_Tablero_imprimir_int_int__L142:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 56
    sw t0, 760(s0)
    lw t0, 760(s0)
    fld ft0, 704(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_imprimir_int_int__L135
.L_Tablero_imprimir_int_int__L136:
    addi t0, s0, 8
    sw t0, 768(s0)
    lw t0, 768(s0)
    fld ft0, 0(t0)
    fsd ft0, 776(s0)
    fld ft0, 776(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 784(s0)
    fld ft3, 784(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 792(s0)
    addi t0, s0, 48
    sw t0, 800(s0)
    lw t0, 800(s0)
    fld ft0, 0(t0)
    fsd ft0, 808(s0)
    addi t0, s0, 64
    sw t0, 816(s0)
    lw t0, 816(s0)
    fld ft0, 0(t0)
    fsd ft0, 824(s0)
    fld ft0, 792(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 832(s0)
    fld ft3, 832(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 840(s0)
    fld ft0, 808(s0)
    fld ft1, 840(s0)
    fmul.d ft2, ft0, ft1
    fsd ft2, 848(s0)
    fld ft0, 848(s0)
    fld ft1, 824(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 856(s0)
    fld ft0, 792(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 864(s0)
    fld ft0, 864(s0)
    fld ft1, 856(s0)
    fadd.d ft2, ft0, ft1
    fsd ft2, 872(s0)
    fld ft3, 872(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 880(s0)
    fld ft0, 880(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 888(s0)
    fld ft0, 888(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_86
    j .L_Tablero_imprimir_int_int__L150
.L_rama_larga_86:
    j .L_Tablero_imprimir_int_int__L143
.L_Tablero_imprimir_int_int__L150:
    fld ft0, 880(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 896(s0)
    fld ft0, 896(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_87
    j .L_Tablero_imprimir_int_int__L151
.L_rama_larga_87:
    j .L_Tablero_imprimir_int_int__L144
.L_Tablero_imprimir_int_int__L151:
    fld ft0, 880(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 904(s0)
    fld ft0, 904(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_88
    j .L_Tablero_imprimir_int_int__L152
.L_rama_larga_88:
    j .L_Tablero_imprimir_int_int__L145
.L_Tablero_imprimir_int_int__L152:
    fld ft0, 880(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 912(s0)
    fld ft0, 912(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_89
    j .L_Tablero_imprimir_int_int__L153
.L_rama_larga_89:
    j .L_Tablero_imprimir_int_int__L146
.L_Tablero_imprimir_int_int__L153:
    fld ft0, 880(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 920(s0)
    fld ft0, 920(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_90
    j .L_Tablero_imprimir_int_int__L154
.L_rama_larga_90:
    j .L_Tablero_imprimir_int_int__L147
.L_Tablero_imprimir_int_int__L154:
    j .L_Tablero_imprimir_int_int__L148
.L_Tablero_imprimir_int_int__L143:
    addi t0, s0, 56
    sw t0, 928(s0)
    lw t0, 928(s0)
    fld ft0, 0(t0)
    fsd ft0, 936(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 944(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 952(s0)
    fld ft0, 936(s0)
    fsd ft0, 960(s0)
.L_Tablero_imprimir_int_int__L155:
    fld ft3, 960(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 968(s0)
    fld ft0, 968(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 976(s0)
    fld ft0, 976(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_91
    j .L_Tablero_imprimir_int_int__L156
.L_rama_larga_91:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 968(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 960(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 960(s0)
    j .L_Tablero_imprimir_int_int__L155
.L_Tablero_imprimir_int_int__L156:
    fld ft0, 944(s0)
    fsd ft0, 984(s0)
.L_Tablero_imprimir_int_int__L157:
    fld ft3, 984(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 992(s0)
    fld ft0, 992(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1000(s0)
    fld ft0, 1000(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_92
    j .L_Tablero_imprimir_int_int__L158
.L_rama_larga_92:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 992(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 984(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 984(s0)
    j .L_Tablero_imprimir_int_int__L157
.L_Tablero_imprimir_int_int__L158:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 56
    sw t0, 1008(s0)
    lw t0, 1008(s0)
    fld ft0, 952(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_imprimir_int_int__L149
.L_Tablero_imprimir_int_int__L144:
    addi t0, s0, 56
    sw t0, 1016(s0)
    lw t0, 1016(s0)
    fld ft0, 0(t0)
    fsd ft0, 1024(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1032(s0)
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
    fsd ft0, 1040(s0)
    fld ft0, 1024(s0)
    fsd ft0, 1048(s0)
.L_Tablero_imprimir_int_int__L159:
    fld ft3, 1048(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1056(s0)
    fld ft0, 1056(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1064(s0)
    fld ft0, 1064(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_93
    j .L_Tablero_imprimir_int_int__L160
.L_rama_larga_93:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1056(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1048(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1048(s0)
    j .L_Tablero_imprimir_int_int__L159
.L_Tablero_imprimir_int_int__L160:
    fld ft0, 1032(s0)
    fsd ft0, 1072(s0)
.L_Tablero_imprimir_int_int__L161:
    fld ft3, 1072(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1080(s0)
    fld ft0, 1080(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1088(s0)
    fld ft0, 1088(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_94
    j .L_Tablero_imprimir_int_int__L162
.L_rama_larga_94:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1080(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1072(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1072(s0)
    j .L_Tablero_imprimir_int_int__L161
.L_Tablero_imprimir_int_int__L162:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 56
    sw t0, 1096(s0)
    lw t0, 1096(s0)
    fld ft0, 1040(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_imprimir_int_int__L149
.L_Tablero_imprimir_int_int__L145:
    addi t0, s0, 56
    sw t0, 1104(s0)
    lw t0, 1104(s0)
    fld ft0, 0(t0)
    fsd ft0, 1112(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1120(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 36
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    fsd ft0, 1128(s0)
    fld ft0, 1112(s0)
    fsd ft0, 1136(s0)
.L_Tablero_imprimir_int_int__L163:
    fld ft3, 1136(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1144(s0)
    fld ft0, 1144(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1152(s0)
    fld ft0, 1152(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_95
    j .L_Tablero_imprimir_int_int__L164
.L_rama_larga_95:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1144(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1136(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1136(s0)
    j .L_Tablero_imprimir_int_int__L163
.L_Tablero_imprimir_int_int__L164:
    fld ft0, 1120(s0)
    fsd ft0, 1160(s0)
.L_Tablero_imprimir_int_int__L165:
    fld ft3, 1160(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1168(s0)
    fld ft0, 1168(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1176(s0)
    fld ft0, 1176(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_96
    j .L_Tablero_imprimir_int_int__L166
.L_rama_larga_96:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1168(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1160(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1160(s0)
    j .L_Tablero_imprimir_int_int__L165
.L_Tablero_imprimir_int_int__L166:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 56
    sw t0, 1184(s0)
    lw t0, 1184(s0)
    fld ft0, 1128(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_imprimir_int_int__L149
.L_Tablero_imprimir_int_int__L146:
    addi t0, s0, 56
    sw t0, 1192(s0)
    lw t0, 1192(s0)
    fld ft0, 0(t0)
    fsd ft0, 1200(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1208(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 88
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    fsd ft0, 1216(s0)
    fld ft0, 1200(s0)
    fsd ft0, 1224(s0)
.L_Tablero_imprimir_int_int__L167:
    fld ft3, 1224(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1232(s0)
    fld ft0, 1232(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1240(s0)
    fld ft0, 1240(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_97
    j .L_Tablero_imprimir_int_int__L168
.L_rama_larga_97:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1232(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1224(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1224(s0)
    j .L_Tablero_imprimir_int_int__L167
.L_Tablero_imprimir_int_int__L168:
    fld ft0, 1208(s0)
    fsd ft0, 1248(s0)
.L_Tablero_imprimir_int_int__L169:
    fld ft3, 1248(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1256(s0)
    fld ft0, 1256(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1264(s0)
    fld ft0, 1264(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_98
    j .L_Tablero_imprimir_int_int__L170
.L_rama_larga_98:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1256(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1248(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1248(s0)
    j .L_Tablero_imprimir_int_int__L169
.L_Tablero_imprimir_int_int__L170:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 56
    sw t0, 1272(s0)
    lw t0, 1272(s0)
    fld ft0, 1216(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_imprimir_int_int__L149
.L_Tablero_imprimir_int_int__L147:
    addi t0, s0, 56
    sw t0, 1280(s0)
    lw t0, 1280(s0)
    fld ft0, 0(t0)
    fsd ft0, 1288(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1296(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 42
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    fsd ft0, 1304(s0)
    fld ft0, 1288(s0)
    fsd ft0, 1312(s0)
.L_Tablero_imprimir_int_int__L171:
    fld ft3, 1312(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1320(s0)
    fld ft0, 1320(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1328(s0)
    fld ft0, 1328(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_99
    j .L_Tablero_imprimir_int_int__L172
.L_rama_larga_99:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1320(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1312(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1312(s0)
    j .L_Tablero_imprimir_int_int__L171
.L_Tablero_imprimir_int_int__L172:
    fld ft0, 1296(s0)
    fsd ft0, 1336(s0)
.L_Tablero_imprimir_int_int__L173:
    fld ft3, 1336(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1344(s0)
    fld ft0, 1344(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1352(s0)
    fld ft0, 1352(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_100
    j .L_Tablero_imprimir_int_int__L174
.L_rama_larga_100:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1344(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1336(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1336(s0)
    j .L_Tablero_imprimir_int_int__L173
.L_Tablero_imprimir_int_int__L174:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 56
    sw t0, 1360(s0)
    lw t0, 1360(s0)
    fld ft0, 1304(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_imprimir_int_int__L149
.L_Tablero_imprimir_int_int__L148:
    addi t0, s0, 56
    sw t0, 1368(s0)
    lw t0, 1368(s0)
    fld ft0, 0(t0)
    fsd ft0, 1376(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1384(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 1392(s0)
    fld ft0, 1376(s0)
    fsd ft0, 1400(s0)
.L_Tablero_imprimir_int_int__L175:
    fld ft3, 1400(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1408(s0)
    fld ft0, 1408(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1416(s0)
    fld ft0, 1416(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_101
    j .L_Tablero_imprimir_int_int__L176
.L_rama_larga_101:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1408(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1400(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1400(s0)
    j .L_Tablero_imprimir_int_int__L175
.L_Tablero_imprimir_int_int__L176:
    fld ft0, 1384(s0)
    fsd ft0, 1424(s0)
.L_Tablero_imprimir_int_int__L177:
    fld ft3, 1424(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1432(s0)
    fld ft0, 1432(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1440(s0)
    fld ft0, 1440(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_102
    j .L_Tablero_imprimir_int_int__L178
.L_rama_larga_102:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1432(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1424(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1424(s0)
    j .L_Tablero_imprimir_int_int__L177
.L_Tablero_imprimir_int_int__L178:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 56
    sw t0, 1448(s0)
    lw t0, 1448(s0)
    fld ft0, 1392(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_imprimir_int_int__L149
.L_Tablero_imprimir_int_int__L149:
.L_Tablero_imprimir_int_int__L135:
.L_Tablero_imprimir_int_int__L133:
    addi t0, s0, 64
    sw t0, 1456(s0)
    lw t0, 1456(s0)
    fld ft0, 0(t0)
    fsd ft0, 1464(s0)
    fld ft0, 1464(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1472(s0)
    addi t0, s0, 64
    sw t0, 1480(s0)
    lw t0, 1480(s0)
    fld ft0, 1472(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_imprimir_int_int__L132
.L_Tablero_imprimir_int_int__L134:
    addi t0, s0, 56
    sw t0, 1488(s0)
    lw t0, 1488(s0)
    fld ft0, 0(t0)
    fsd ft0, 1496(s0)
    fld ft0, 1496(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
.L_Tablero_imprimir_int_int__L126:
    addi t0, s0, 48
    sw t0, 1504(s0)
    lw t0, 1504(s0)
    fld ft0, 0(t0)
    fsd ft0, 1512(s0)
    fld ft0, 1512(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1520(s0)
    addi t0, s0, 48
    sw t0, 1528(s0)
    lw t0, 1528(s0)
    fld ft0, 1520(s0)
    fsd ft0, 0(t0)
    j .L_Tablero_imprimir_int_int__L125
.L_Tablero_imprimir_int_int__L127:
.L_fin_Tablero_imprimir_int_int_:
    fld fa0, 0(s0)
    lw t0, 1544(s0)
    lw ra, 1548(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 1552
    ret

Juego_String_:
    addi sp, sp, -384
    sw ra, 380(sp)
    sw s0, 376(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 111748715
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 64(s0)
    addi s2, s2, 5
    addi t0, s0, 24
    sw t0, 72(s0)
    lw t0, 72(s0)
    addi t0, t0, 8
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 64(s0)
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    jal ra, Tablero__
    fsd fa0, 24(s0)
    addi t0, s0, 8
    sw t0, 88(s0)
    lw t0, 88(s0)
    fld ft0, 0(t0)
    fsd ft0, 96(s0)
    fld ft0, 96(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 104(s0)
    fld ft3, 104(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 64(s0)
    fsd ft0, 0(t0)
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
    addi t0, s0, 24
    sw t0, 144(s0)
    lw t0, 144(s0)
    addi t0, t0, 8
    sw t0, 152(s0)
    lw t0, 152(s0)
    fld ft0, 136(s0)
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    jal ra, Tablero_inicializar__
    fsd fa0, 24(s0)
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
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 192(s0)
    fld ft3, 192(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    addi t0, s0, 24
    sw t0, 208(s0)
    lw t0, 208(s0)
    addi t0, t0, 8
    sw t0, 216(s0)
    lw t0, 216(s0)
    fld ft0, 200(s0)
    fsd ft0, 0(t0)
    lw t0, 208(s0)
    addi t0, t0, 16
    sw t0, 224(s0)
    lw t0, 224(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    fld fa1, 40(s0)
    jal ra, Tablero_primeraColumnaLibre_int_
    fsd fa0, 24(s0)
    addi t0, s0, 24
    sw t0, 232(s0)
    lw t0, 232(s0)
    fld ft0, 0(t0)
    fsd ft0, 240(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 403518370
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 248(s0)
    addi s2, s2, 7
    addi t0, s0, 24
    sw t0, 256(s0)
    lw t0, 256(s0)
    addi t0, t0, 8
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 248(s0)
    fsd ft0, 0(t0)
    lw t0, 256(s0)
    addi t0, t0, 16
    sw t0, 272(s0)
    lw t0, 272(s0)
    fld ft0, 168(s0)
    fsd ft0, 0(t0)
    lw t0, 256(s0)
    addi t0, t0, 24
    sw t0, 280(s0)
    lw t0, 280(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 256(s0)
    addi t0, t0, 32
    sw t0, 288(s0)
    lw t0, 288(s0)
    fld ft0, 240(s0)
    fsd ft0, 0(t0)
    fld fa0, 32(s0)
    fld fa1, 40(s0)
    fld fa2, 48(s0)
    fld fa3, 56(s0)
    jal ra, Jugador_String_int_int_
    fsd fa0, 24(s0)
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
    fld ft0, 248(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 320(s0)
    lw t0, 320(s0)
    fld ft0, 0(t0)
    fsd ft0, 328(s0)
    fld ft0, 328(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 336(s0)
    fld ft3, 336(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 344(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 352(s0)
    lw t0, 352(s0)
    fld ft0, 0(t0)
    fsd ft0, 360(s0)
    fld ft0, 360(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 368(s0)
    fld ft3, 368(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 344(s0)
    fsd ft0, 0(t0)
.L_fin_Juego_String_:
    fld fa0, 0(s0)
    lw t0, 376(s0)
    lw ra, 380(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 384
    ret

Juego_mover_int_:
    li t6, -2240
    add sp, sp, t6
    li t6, 2236
    add t6, sp, t6
    sw ra, 0(t6)
    li t6, 2232
    add t6, sp, t6
    sw s0, 0(t6)
    mv s0, sp
    fsd fa0, 8(s0)
    fsd fa1, 16(s0)
    addi t0, s0, 8
    sw t0, 80(s0)
    lw t0, 80(s0)
    fld ft0, 0(t0)
    fsd ft0, 88(s0)
    fld ft0, 88(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 96(s0)
    fld ft3, 96(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 104(s0)
    fld ft0, 104(s0)
    li t6, 1
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
    fld ft0, 120(s0)
    fsd ft0, 0(t0)
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
    fld ft0, 0(t0)
    fsd ft0, 160(s0)
    fld ft0, 160(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 168(s0)
    fld ft3, 168(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 176(s0)
    addi t0, s0, 32
    sw t0, 184(s0)
    lw t0, 184(s0)
    fld ft0, 176(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 192(s0)
    lw t0, 192(s0)
    fld ft0, 0(t0)
    fsd ft0, 200(s0)
    fld ft0, 200(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 208(s0)
    fld ft0, 208(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_103
    j .L_Juego_mover_int__L185
.L_rama_larga_103:
    j .L_Juego_mover_int__L179
.L_Juego_mover_int__L185:
    fld ft0, 200(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 216(s0)
    fld ft0, 216(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_104
    j .L_Juego_mover_int__L186
.L_rama_larga_104:
    j .L_Juego_mover_int__L180
.L_Juego_mover_int__L186:
    fld ft0, 200(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 224(s0)
    fld ft0, 224(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_105
    j .L_Juego_mover_int__L187
.L_rama_larga_105:
    j .L_Juego_mover_int__L181
.L_Juego_mover_int__L187:
    fld ft0, 200(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 232(s0)
    fld ft0, 232(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_106
    j .L_Juego_mover_int__L188
.L_rama_larga_106:
    j .L_Juego_mover_int__L182
.L_Juego_mover_int__L188:
    j .L_Juego_mover_int__L183
.L_Juego_mover_int__L179:
    addi t0, s0, 24
    sw t0, 240(s0)
    lw t0, 240(s0)
    fld ft0, 0(t0)
    fsd ft0, 248(s0)
    fld ft0, 248(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 256(s0)
    addi t0, s0, 24
    sw t0, 264(s0)
    lw t0, 264(s0)
    fld ft0, 256(s0)
    fsd ft0, 0(t0)
    j .L_Juego_mover_int__L184
.L_Juego_mover_int__L180:
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
    j .L_Juego_mover_int__L184
.L_Juego_mover_int__L181:
    addi t0, s0, 32
    sw t0, 304(s0)
    lw t0, 304(s0)
    fld ft0, 0(t0)
    fsd ft0, 312(s0)
    fld ft0, 312(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fsub.d ft2, ft0, ft1
    fsd ft2, 320(s0)
    addi t0, s0, 32
    sw t0, 328(s0)
    lw t0, 328(s0)
    fld ft0, 320(s0)
    fsd ft0, 0(t0)
    j .L_Juego_mover_int__L184
.L_Juego_mover_int__L182:
    addi t0, s0, 32
    sw t0, 336(s0)
    lw t0, 336(s0)
    fld ft0, 0(t0)
    fsd ft0, 344(s0)
    fld ft0, 344(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 352(s0)
    addi t0, s0, 32
    sw t0, 360(s0)
    lw t0, 360(s0)
    fld ft0, 352(s0)
    fsd ft0, 0(t0)
    j .L_Juego_mover_int__L184
.L_Juego_mover_int__L183:
    fcvt.d.w ft0, s2
    fsd ft0, 368(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 376(s0)
    lw t0, 376(s0)
    fld ft0, 0(t0)
    fsd ft0, 384(s0)
    fld ft0, 384(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 392(s0)
    fld ft3, 392(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 368(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 0
    sw t0, 400(s0)
    lw t0, 400(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Juego_mover_int_
.L_Juego_mover_int__L184:
    addi t0, s0, 8
    sw t0, 408(s0)
    lw t0, 408(s0)
    fld ft0, 0(t0)
    fsd ft0, 416(s0)
    fld ft0, 416(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 424(s0)
    fld ft3, 424(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 432(s0)
    addi t0, s0, 24
    sw t0, 440(s0)
    lw t0, 440(s0)
    fld ft0, 0(t0)
    fsd ft0, 448(s0)
    addi t0, s0, 32
    sw t0, 456(s0)
    lw t0, 456(s0)
    fld ft0, 0(t0)
    fsd ft0, 464(s0)
    addi t0, s0, 48
    sw t0, 472(s0)
    lw t0, 472(s0)
    addi t0, t0, 8
    sw t0, 480(s0)
    lw t0, 480(s0)
    fld ft0, 432(s0)
    fsd ft0, 0(t0)
    lw t0, 472(s0)
    addi t0, t0, 16
    sw t0, 488(s0)
    lw t0, 488(s0)
    fld ft0, 448(s0)
    fsd ft0, 0(t0)
    lw t0, 472(s0)
    addi t0, t0, 24
    sw t0, 496(s0)
    lw t0, 496(s0)
    fld ft0, 464(s0)
    fsd ft0, 0(t0)
    fld fa0, 56(s0)
    fld fa1, 64(s0)
    fld fa2, 72(s0)
    jal ra, Tablero_esValida_int_int_
    fsd fa0, 48(s0)
    addi t0, s0, 48
    sw t0, 504(s0)
    lw t0, 504(s0)
    fld ft0, 0(t0)
    fsd ft0, 512(s0)
    fld ft0, 512(s0)
    fcvt.w.d t0, ft0
    seqz t0, t0
    fcvt.d.w ft1, t0
    fsd ft1, 520(s0)
    fld ft0, 520(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_107
    j .L_Juego_mover_int__L191
.L_rama_larga_107:
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 528(s0)
    j .L_Juego_mover_int__L192
.L_Juego_mover_int__L191:
    addi t0, s0, 8
    sw t0, 536(s0)
    lw t0, 536(s0)
    fld ft0, 0(t0)
    fsd ft0, 544(s0)
    fld ft0, 544(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 552(s0)
    fld ft3, 552(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 560(s0)
    addi t0, s0, 24
    sw t0, 568(s0)
    lw t0, 568(s0)
    fld ft0, 0(t0)
    fsd ft0, 576(s0)
    addi t0, s0, 32
    sw t0, 584(s0)
    lw t0, 584(s0)
    fld ft0, 0(t0)
    fsd ft0, 592(s0)
    addi t0, s0, 48
    sw t0, 600(s0)
    lw t0, 600(s0)
    addi t0, t0, 8
    sw t0, 608(s0)
    lw t0, 608(s0)
    fld ft0, 560(s0)
    fsd ft0, 0(t0)
    lw t0, 600(s0)
    addi t0, t0, 16
    sw t0, 616(s0)
    lw t0, 616(s0)
    fld ft0, 576(s0)
    fsd ft0, 0(t0)
    lw t0, 600(s0)
    addi t0, t0, 24
    sw t0, 624(s0)
    lw t0, 624(s0)
    fld ft0, 592(s0)
    fsd ft0, 0(t0)
    fld fa0, 56(s0)
    fld fa1, 64(s0)
    fld fa2, 72(s0)
    jal ra, Tablero_esPared_int_int_
    fsd fa0, 48(s0)
    addi t0, s0, 48
    sw t0, 632(s0)
    lw t0, 632(s0)
    fld ft0, 0(t0)
    fsd ft0, 640(s0)
    fld ft0, 640(s0)
    fsd ft0, 528(s0)
.L_Juego_mover_int__L192:
    fld ft0, 528(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_108
    j .L_Juego_mover_int__L190
.L_rama_larga_108:
    fcvt.d.w ft0, s2
    fsd ft0, 648(s0)
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
    li t6, 113
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
    li t6, 100
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
    sw t0, 656(s0)
    lw t0, 656(s0)
    fld ft0, 0(t0)
    fsd ft0, 664(s0)
    fld ft0, 664(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 672(s0)
    fld ft3, 672(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 648(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 0
    sw t0, 680(s0)
    lw t0, 680(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Juego_mover_int_
    j .L_Juego_mover_int__L189
.L_Juego_mover_int__L190:
.L_Juego_mover_int__L189:
    addi t0, s0, 8
    sw t0, 688(s0)
    lw t0, 688(s0)
    fld ft0, 0(t0)
    fsd ft0, 696(s0)
    fld ft0, 696(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 704(s0)
    fld ft3, 704(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 712(s0)
    addi t0, s0, 24
    sw t0, 720(s0)
    lw t0, 720(s0)
    fld ft0, 0(t0)
    fsd ft0, 728(s0)
    addi t0, s0, 32
    sw t0, 736(s0)
    lw t0, 736(s0)
    fld ft0, 0(t0)
    fsd ft0, 744(s0)
    addi t0, s0, 48
    sw t0, 752(s0)
    lw t0, 752(s0)
    addi t0, t0, 8
    sw t0, 760(s0)
    lw t0, 760(s0)
    fld ft0, 712(s0)
    fsd ft0, 0(t0)
    lw t0, 752(s0)
    addi t0, t0, 16
    sw t0, 768(s0)
    lw t0, 768(s0)
    fld ft0, 728(s0)
    fsd ft0, 0(t0)
    lw t0, 752(s0)
    addi t0, t0, 24
    sw t0, 776(s0)
    lw t0, 776(s0)
    fld ft0, 744(s0)
    fsd ft0, 0(t0)
    fld fa0, 56(s0)
    fld fa1, 64(s0)
    fld fa2, 72(s0)
    jal ra, Jugador_mover_int_int_
    fsd fa0, 48(s0)
    addi t0, s0, 8
    sw t0, 784(s0)
    lw t0, 784(s0)
    fld ft0, 0(t0)
    fsd ft0, 792(s0)
    fld ft0, 792(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 800(s0)
    fld ft3, 800(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 808(s0)
    addi t0, s0, 24
    sw t0, 816(s0)
    lw t0, 816(s0)
    fld ft0, 0(t0)
    fsd ft0, 824(s0)
    addi t0, s0, 32
    sw t0, 832(s0)
    lw t0, 832(s0)
    fld ft0, 0(t0)
    fsd ft0, 840(s0)
    addi t0, s0, 48
    sw t0, 848(s0)
    lw t0, 848(s0)
    addi t0, t0, 8
    sw t0, 856(s0)
    lw t0, 856(s0)
    fld ft0, 808(s0)
    fsd ft0, 0(t0)
    lw t0, 848(s0)
    addi t0, t0, 16
    sw t0, 864(s0)
    lw t0, 864(s0)
    fld ft0, 824(s0)
    fsd ft0, 0(t0)
    lw t0, 848(s0)
    addi t0, t0, 24
    sw t0, 872(s0)
    lw t0, 872(s0)
    fld ft0, 840(s0)
    fsd ft0, 0(t0)
    fld fa0, 56(s0)
    fld fa1, 64(s0)
    fld fa2, 72(s0)
    jal ra, Tablero_recoger_int_int_
    fsd fa0, 48(s0)
    addi t0, s0, 48
    sw t0, 880(s0)
    lw t0, 880(s0)
    fld ft0, 0(t0)
    fsd ft0, 888(s0)
    addi t0, s0, 40
    sw t0, 896(s0)
    lw t0, 896(s0)
    fld ft0, 888(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 904(s0)
    lw t0, 904(s0)
    fld ft0, 0(t0)
    fsd ft0, 912(s0)
    fld ft0, 912(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 920(s0)
    fld ft3, 920(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 928(s0)
    addi t0, s0, 8
    sw t0, 936(s0)
    lw t0, 936(s0)
    fld ft0, 0(t0)
    fsd ft0, 944(s0)
    fld ft0, 944(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 952(s0)
    fld ft3, 952(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 960(s0)
    addi t0, s0, 40
    sw t0, 968(s0)
    lw t0, 968(s0)
    fld ft0, 0(t0)
    fsd ft0, 976(s0)
    addi t0, s0, 48
    sw t0, 984(s0)
    lw t0, 984(s0)
    addi t0, t0, 8
    sw t0, 992(s0)
    lw t0, 992(s0)
    fld ft0, 960(s0)
    fsd ft0, 0(t0)
    lw t0, 984(s0)
    addi t0, t0, 16
    sw t0, 1000(s0)
    lw t0, 1000(s0)
    fld ft0, 976(s0)
    fsd ft0, 0(t0)
    fld fa0, 56(s0)
    fld fa1, 64(s0)
    jal ra, Tablero_puntosPorTipo_int_
    fsd fa0, 48(s0)
    addi t0, s0, 48
    sw t0, 1008(s0)
    lw t0, 1008(s0)
    fld ft0, 0(t0)
    fsd ft0, 1016(s0)
    addi t0, s0, 48
    sw t0, 1024(s0)
    lw t0, 1024(s0)
    addi t0, t0, 8
    sw t0, 1032(s0)
    lw t0, 1032(s0)
    fld ft0, 928(s0)
    fsd ft0, 0(t0)
    lw t0, 1024(s0)
    addi t0, t0, 16
    sw t0, 1040(s0)
    lw t0, 1040(s0)
    fld ft0, 1016(s0)
    fsd ft0, 0(t0)
    fld fa0, 56(s0)
    fld fa1, 64(s0)
    jal ra, Jugador_sumarPuntos_int_
    fsd fa0, 48(s0)
    addi t0, s0, 40
    sw t0, 1048(s0)
    lw t0, 1048(s0)
    fld ft0, 0(t0)
    fsd ft0, 1056(s0)
    fld ft0, 1056(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1064(s0)
    fld ft0, 1064(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_109
    j .L_Juego_mover_int__L194
.L_rama_larga_109:
    fcvt.d.w ft0, s2
    fsd ft0, 1072(s0)
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
    li t6, 111
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
    li t6, 81
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
    addi t0, s0, 8
    sw t0, 1080(s0)
    lw t0, 1080(s0)
    fld ft0, 0(t0)
    fsd ft0, 1088(s0)
    fld ft0, 1088(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1096(s0)
    fld ft3, 1096(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1104(s0)
    fld ft0, 1104(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1112(s0)
    fld ft3, 1112(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1120(s0)
    fld fa0, 1120(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 1128(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1136(s0)
    fld ft0, 1072(s0)
    fsd ft0, 1144(s0)
.L_Juego_mover_int__L195:
    fld ft3, 1144(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1152(s0)
    fld ft0, 1152(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1160(s0)
    fld ft0, 1160(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_110
    j .L_Juego_mover_int__L196
.L_rama_larga_110:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1152(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1144(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1144(s0)
    j .L_Juego_mover_int__L195
.L_Juego_mover_int__L196:
    fld ft0, 1128(s0)
    fsd ft0, 1168(s0)
.L_Juego_mover_int__L197:
    fld ft3, 1168(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1176(s0)
    fld ft0, 1176(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1184(s0)
    fld ft0, 1184(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_111
    j .L_Juego_mover_int__L198
.L_rama_larga_111:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1176(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1168(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1168(s0)
    j .L_Juego_mover_int__L197
.L_Juego_mover_int__L198:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 1192(s0)
    lw t0, 1192(s0)
    fld ft0, 0(t0)
    fsd ft0, 1200(s0)
    fld ft0, 1200(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1208(s0)
    fld ft3, 1208(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1136(s0)
    fsd ft0, 0(t0)
    j .L_Juego_mover_int__L193
.L_Juego_mover_int__L194:
    addi t0, s0, 40
    sw t0, 1216(s0)
    lw t0, 1216(s0)
    fld ft0, 0(t0)
    fsd ft0, 1224(s0)
    fld ft0, 1224(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1232(s0)
    fld ft0, 1232(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_112
    j .L_Juego_mover_int__L199
.L_rama_larga_112:
    addi t0, s0, 8
    sw t0, 1240(s0)
    lw t0, 1240(s0)
    fld ft0, 0(t0)
    fsd ft0, 1248(s0)
    fld ft0, 1248(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1256(s0)
    fld ft3, 1256(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1264(s0)
    addi t0, s0, 48
    sw t0, 1272(s0)
    lw t0, 1272(s0)
    addi t0, t0, 8
    sw t0, 1280(s0)
    lw t0, 1280(s0)
    fld ft0, 1264(s0)
    fsd ft0, 0(t0)
    fld fa0, 56(s0)
    jal ra, Jugador_perderVida__
    fsd fa0, 48(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1288(s0)
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
    sw t0, 1296(s0)
    lw t0, 1296(s0)
    fld ft0, 0(t0)
    fsd ft0, 1304(s0)
    fld ft0, 1304(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1312(s0)
    fld ft3, 1312(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1320(s0)
    fld ft0, 1320(s0)
    li t6, 5
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1328(s0)
    fld ft3, 1328(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1336(s0)
    fld fa0, 1336(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 1344(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1352(s0)
    fld ft0, 1288(s0)
    fsd ft0, 1360(s0)
.L_Juego_mover_int__L200:
    fld ft3, 1360(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1368(s0)
    fld ft0, 1368(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1376(s0)
    fld ft0, 1376(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_113
    j .L_Juego_mover_int__L201
.L_rama_larga_113:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1368(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1360(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1360(s0)
    j .L_Juego_mover_int__L200
.L_Juego_mover_int__L201:
    fld ft0, 1344(s0)
    fsd ft0, 1384(s0)
.L_Juego_mover_int__L202:
    fld ft3, 1384(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1392(s0)
    fld ft0, 1392(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1400(s0)
    fld ft0, 1400(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_114
    j .L_Juego_mover_int__L203
.L_rama_larga_114:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1392(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1384(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1384(s0)
    j .L_Juego_mover_int__L202
.L_Juego_mover_int__L203:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 1408(s0)
    lw t0, 1408(s0)
    fld ft0, 0(t0)
    fsd ft0, 1416(s0)
    fld ft0, 1416(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1424(s0)
    fld ft3, 1424(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1352(s0)
    fsd ft0, 0(t0)
    j .L_Juego_mover_int__L193
.L_Juego_mover_int__L199:
    addi t0, s0, 40
    sw t0, 1432(s0)
    lw t0, 1432(s0)
    fld ft0, 0(t0)
    fsd ft0, 1440(s0)
    fld ft0, 1440(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1448(s0)
    fld ft0, 1448(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_115
    j .L_Juego_mover_int__L204
.L_rama_larga_115:
    fcvt.d.w ft0, s2
    fsd ft0, 1456(s0)
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
    li t6, 33
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
    sw t0, 1464(s0)
    lw t0, 1464(s0)
    fld ft0, 0(t0)
    fsd ft0, 1472(s0)
    fld ft0, 1472(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1480(s0)
    fld ft3, 1480(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1456(s0)
    fsd ft0, 0(t0)
    j .L_Juego_mover_int__L193
.L_Juego_mover_int__L204:
    fcvt.d.w ft0, s2
    fsd ft0, 1488(s0)
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
    li t6, 110
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 24
    sw t0, 1496(s0)
    lw t0, 1496(s0)
    fld ft0, 0(t0)
    fsd ft0, 1504(s0)
    fld fa0, 1504(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 1512(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1520(s0)
    fld ft0, 1488(s0)
    fsd ft0, 1528(s0)
.L_Juego_mover_int__L205:
    fld ft3, 1528(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1536(s0)
    fld ft0, 1536(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1544(s0)
    fld ft0, 1544(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_116
    j .L_Juego_mover_int__L206
.L_rama_larga_116:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1536(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1528(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1528(s0)
    j .L_Juego_mover_int__L205
.L_Juego_mover_int__L206:
    fld ft0, 1512(s0)
    fsd ft0, 1552(s0)
.L_Juego_mover_int__L207:
    fld ft3, 1552(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1560(s0)
    fld ft0, 1560(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1568(s0)
    fld ft0, 1568(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_117
    j .L_Juego_mover_int__L208
.L_rama_larga_117:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1560(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1552(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1552(s0)
    j .L_Juego_mover_int__L207
.L_Juego_mover_int__L208:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 1576(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 1584(s0)
    fld ft0, 1520(s0)
    fsd ft0, 1592(s0)
.L_Juego_mover_int__L209:
    fld ft3, 1592(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1600(s0)
    fld ft0, 1600(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1608(s0)
    fld ft0, 1608(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_118
    j .L_Juego_mover_int__L210
.L_rama_larga_118:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1600(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1592(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1592(s0)
    j .L_Juego_mover_int__L209
.L_Juego_mover_int__L210:
    fld ft0, 1576(s0)
    fsd ft0, 1616(s0)
.L_Juego_mover_int__L211:
    fld ft3, 1616(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1624(s0)
    fld ft0, 1624(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1632(s0)
    fld ft0, 1632(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_119
    j .L_Juego_mover_int__L212
.L_rama_larga_119:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1624(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1616(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1616(s0)
    j .L_Juego_mover_int__L211
.L_Juego_mover_int__L212:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 32
    sw t0, 1640(s0)
    lw t0, 1640(s0)
    fld ft0, 0(t0)
    fsd ft0, 1648(s0)
    fld fa0, 1648(s0)
    jal ra, entero_a_cadena
    fcvt.d.w ft0, a0
    fsd ft0, 1656(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1664(s0)
    fld ft0, 1584(s0)
    fsd ft0, 1672(s0)
.L_Juego_mover_int__L213:
    fld ft3, 1672(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1680(s0)
    fld ft0, 1680(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1688(s0)
    fld ft0, 1688(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_120
    j .L_Juego_mover_int__L214
.L_rama_larga_120:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1680(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1672(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1672(s0)
    j .L_Juego_mover_int__L213
.L_Juego_mover_int__L214:
    fld ft0, 1656(s0)
    fsd ft0, 1696(s0)
.L_Juego_mover_int__L215:
    fld ft3, 1696(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1704(s0)
    fld ft0, 1704(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1712(s0)
    fld ft0, 1712(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_121
    j .L_Juego_mover_int__L216
.L_rama_larga_121:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1704(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1696(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1696(s0)
    j .L_Juego_mover_int__L215
.L_Juego_mover_int__L216:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 1720(s0)
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
    fcvt.d.w ft0, s2
    fsd ft0, 1728(s0)
    fld ft0, 1664(s0)
    fsd ft0, 1736(s0)
.L_Juego_mover_int__L217:
    fld ft3, 1736(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1744(s0)
    fld ft0, 1744(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1752(s0)
    fld ft0, 1752(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_122
    j .L_Juego_mover_int__L218
.L_rama_larga_122:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1744(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1736(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1736(s0)
    j .L_Juego_mover_int__L217
.L_Juego_mover_int__L218:
    fld ft0, 1720(s0)
    fsd ft0, 1760(s0)
.L_Juego_mover_int__L219:
    fld ft3, 1760(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1768(s0)
    fld ft0, 1768(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1776(s0)
    fld ft0, 1776(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_123
    j .L_Juego_mover_int__L220
.L_rama_larga_123:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1768(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1760(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1760(s0)
    j .L_Juego_mover_int__L219
.L_Juego_mover_int__L220:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 1784(s0)
    lw t0, 1784(s0)
    fld ft0, 0(t0)
    fsd ft0, 1792(s0)
    fld ft0, 1792(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1800(s0)
    fld ft3, 1800(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1728(s0)
    fsd ft0, 0(t0)
.L_Juego_mover_int__L193:
    addi t0, s0, 8
    sw t0, 1808(s0)
    lw t0, 1808(s0)
    fld ft0, 0(t0)
    fsd ft0, 1816(s0)
    fld ft0, 1816(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1824(s0)
    fld ft3, 1824(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1832(s0)
    addi t0, s0, 48
    sw t0, 1840(s0)
    lw t0, 1840(s0)
    addi t0, t0, 8
    sw t0, 1848(s0)
    lw t0, 1848(s0)
    fld ft0, 1832(s0)
    fsd ft0, 0(t0)
    fld fa0, 56(s0)
    jal ra, Jugador_estaVivo__
    fsd fa0, 48(s0)
    addi t0, s0, 48
    sw t0, 1856(s0)
    lw t0, 1856(s0)
    fld ft0, 0(t0)
    fsd ft0, 1864(s0)
    fld ft0, 1864(s0)
    fcvt.w.d t0, ft0
    seqz t0, t0
    fcvt.d.w ft1, t0
    fsd ft1, 1872(s0)
    fld ft0, 1872(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_124
    j .L_Juego_mover_int__L222
.L_rama_larga_124:
    addi t0, s0, 8
    sw t0, 1880(s0)
    lw t0, 1880(s0)
    fld ft0, 0(t0)
    fsd ft0, 1888(s0)
    fld ft0, 1888(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1896(s0)
    fld ft3, 1896(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 1904(s0)
    lw t0, 1904(s0)
    fld ft0, 0(t0)
    fsd ft0, 1912(s0)
    fld ft0, 1912(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1920(s0)
    fld ft3, 1920(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1928(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1936(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    li t6, 32
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
    li t6, 113
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 1944(s0)
    fld ft0, 1928(s0)
    fsd ft0, 1952(s0)
.L_Juego_mover_int__L223:
    fld ft3, 1952(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1960(s0)
    fld ft0, 1960(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1968(s0)
    fld ft0, 1968(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_125
    j .L_Juego_mover_int__L224
.L_rama_larga_125:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1960(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1952(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1952(s0)
    j .L_Juego_mover_int__L223
.L_Juego_mover_int__L224:
    fld ft0, 1936(s0)
    fsd ft0, 1976(s0)
.L_Juego_mover_int__L225:
    fld ft3, 1976(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1984(s0)
    fld ft0, 1984(s0)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    fsd ft2, 1992(s0)
    fld ft0, 1992(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_126
    j .L_Juego_mover_int__L226
.L_rama_larga_126:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1984(s0)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 1976(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1976(s0)
    j .L_Juego_mover_int__L225
.L_Juego_mover_int__L226:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    sw t0, 2000(s0)
    lw t0, 2000(s0)
    fld ft0, 0(t0)
    fsd ft0, 2008(s0)
    fld ft0, 2008(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 2016(s0)
    fld ft3, 2016(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 1944(s0)
    fsd ft0, 0(t0)
    j .L_Juego_mover_int__L221
.L_Juego_mover_int__L222:
    addi t0, s0, 8
    sw t0, 2024(s0)
    lw t0, 2024(s0)
    fld ft0, 0(t0)
    fsd ft0, 2032(s0)
    fld ft0, 2032(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 2040(s0)
    fld ft3, 2040(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    li t6, 2048
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2048
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    li t6, 2056
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2056
    add t6, s0, t6
    fld ft3, 0(t6)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    li t6, 2064
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2064
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    li t6, 2072
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2072
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_127
    j .L_Juego_mover_int__L227
.L_rama_larga_127:
    addi t0, s0, 8
    li t6, 2080
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2080
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2088
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2088
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    li t6, 2096
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2096
    add t6, s0, t6
    fld ft3, 0(t6)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 8
    li t6, 2104
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2104
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2112
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2112
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    li t6, 2120
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2120
    add t6, s0, t6
    fld ft3, 0(t6)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    li t6, 2128
    add t6, s0, t6
    fsd ft0, 0(t6)
    fcvt.d.w ft0, s2
    li t6, 2136
    add t6, s0, t6
    fsd ft0, 0(t6)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    fcvt.d.w ft0, s2
    li t6, 2144
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2128
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 2152
    add t6, s0, t6
    fsd ft0, 0(t6)
.L_Juego_mover_int__L228:
    li t6, 2152
    add t6, s0, t6
    fld ft3, 0(t6)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    li t6, 2160
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2160
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    li t6, 2168
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2168
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_128
    j .L_Juego_mover_int__L229
.L_rama_larga_128:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 2160
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    li t6, 2152
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    li t6, 2152
    add t6, s0, t6
    fsd ft2, 0(t6)
    j .L_Juego_mover_int__L228
.L_Juego_mover_int__L229:
    li t6, 2136
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 2176
    add t6, s0, t6
    fsd ft0, 0(t6)
.L_Juego_mover_int__L230:
    li t6, 2176
    add t6, s0, t6
    fld ft3, 0(t6)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    li t6, 2184
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2184
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, -1
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    xori t0, t0, 1
    fcvt.d.w ft2, t0
    li t6, 2192
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2192
    add t6, s0, t6
    fld ft0, 0(t6)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_129
    j .L_Juego_mover_int__L231
.L_rama_larga_129:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 2184
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    addi s2, s2, 1
    li t6, 2176
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    li t6, 2176
    add t6, s0, t6
    fsd ft2, 0(t6)
    j .L_Juego_mover_int__L230
.L_Juego_mover_int__L231:
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    addi t0, s0, 8
    li t6, 2200
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2200
    add t6, s0, t6
    lw t0, 0(t6)
    fld ft0, 0(t0)
    li t6, 2208
    add t6, s0, t6
    fsd ft0, 0(t6)
    li t6, 2208
    add t6, s0, t6
    fld ft0, 0(t6)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    li t6, 2216
    add t6, s0, t6
    fsd ft2, 0(t6)
    li t6, 2216
    add t6, s0, t6
    fld ft3, 0(t6)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 2144
    add t6, s0, t6
    fld ft0, 0(t6)
    fsd ft0, 0(t0)
    j .L_Juego_mover_int__L221
.L_Juego_mover_int__L227:
.L_Juego_mover_int__L221:
    addi t0, s0, 0
    li t6, 2224
    add t6, s0, t6
    sw t0, 0(t6)
    li t6, 2224
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    j .L_fin_Juego_mover_int_
.L_fin_Juego_mover_int_:
    fld fa0, 0(s0)
    li t6, 2232
    add t6, s0, t6
    lw t0, 0(t6)
    li t6, 2236
    add t6, s0, t6
    lw ra, 0(t6)
    mv sp, s0
    mv s0, t0
    li t6, 2240
    add sp, sp, t6
    ret

Juego_obtenerVeredicto__:
    addi sp, sp, -144
    sw ra, 140(sp)
    sw s0, 136(sp)
    mv s0, sp
    fsd fa0, 8(s0)
    addi t0, s0, 8
    sw t0, 24(s0)
    lw t0, 24(s0)
    fld ft0, 0(t0)
    fsd ft0, 32(s0)
    fld ft0, 32(s0)
    li t6, 1
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
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 56(s0)
    fld ft3, 56(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 64(s0)
    fld ft0, 64(s0)
    li t6, 100
    fcvt.d.w ft1, t6
    fle.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 72(s0)
    fld ft0, 72(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_130
    j .L_Juego_obtenerVeredicto___L232
.L_rama_larga_130:
    fcvt.d.w ft0, s2
    fsd ft0, 80(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 80(s0)
    fsd ft0, 88(s0)
    j .L_Juego_obtenerVeredicto___L233
.L_Juego_obtenerVeredicto___L232:
    fcvt.d.w ft0, s2
    fsd ft0, 96(s0)
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
    fld ft0, 96(s0)
    fsd ft0, 88(s0)
.L_Juego_obtenerVeredicto___L233:
    addi t0, s0, 16
    sw t0, 104(s0)
    lw t0, 104(s0)
    fld ft0, 88(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 112(s0)
    lw t0, 112(s0)
    fld ft0, 0(t0)
    fsd ft0, 120(s0)
    addi t0, s0, 0
    sw t0, 128(s0)
    lw t0, 128(s0)
    fld ft0, 120(s0)
    fsd ft0, 0(t0)
    j .L_fin_Juego_obtenerVeredicto__
.L_fin_Juego_obtenerVeredicto__:
    fld fa0, 0(s0)
    lw t0, 136(s0)
    lw ra, 140(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 144
    ret

main_pig:
    addi sp, sp, -1984
    sw ra, 1980(sp)
    sw s0, 1976(sp)
    mv s0, sp
    addi t0, s0, 0
    sw t0, 120(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 128(s0)
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
    lw t0, 120(s0)
    fld ft0, 128(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 136(s0)
    lw t0, 136(s0)
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 144(s0)
    lw t0, 144(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 24
    sw t0, 152(s0)
    lw t0, 152(s0)
    li t6, 60
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 32
    sw t0, 160(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 71926466
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 168(s0)
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
    lw t0, 160(s0)
    fld ft0, 168(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 176(s0)
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
    addi t0, s0, 72
    sw t0, 184(s0)
    lw t0, 184(s0)
    addi t0, t0, 8
    sw t0, 192(s0)
    lw t0, 192(s0)
    fld ft0, 168(s0)
    fsd ft0, 0(t0)
    lw t0, 184(s0)
    addi t0, t0, 16
    sw t0, 200(s0)
    lw t0, 200(s0)
    fld ft0, 176(s0)
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    fld fa1, 88(s0)
    jal ra, Juego_String_
    fsd fa0, 72(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 208(s0)
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
    li t6, 3
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
    fld ft0, 216(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 224(s0)
    fld ft3, 224(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 216(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 232(s0)
    fld ft3, 232(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld ft0, 216(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 240(s0)
    fld ft3, 240(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 40
    sw t0, 248(s0)
    lw t0, 248(s0)
    fld ft0, 208(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 48
    sw t0, 256(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 264(s0)
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
    lw t0, 256(s0)
    fld ft0, 264(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 272(s0)
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 264(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 280(s0)
    fld ft3, 280(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 272(s0)
    fsd ft0, 0(t0)
    fld ft0, 264(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 288(s0)
    fld ft3, 288(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 40
    sw t0, 296(s0)
    lw t0, 296(s0)
    fld ft0, 0(t0)
    fsd ft0, 304(s0)
    fld ft0, 264(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 312(s0)
    fld ft3, 312(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 304(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 320(s0)
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
    li t6, 66
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
    li t6, 73
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
    li t6, 84
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
    li t6, 68
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
    li t6, 32
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
    li t6, 83
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
    li t6, 79
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 320(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 328(s0)
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
    li t6, 121
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
    li t6, 80
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    li t6, 35
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    li t6, 36
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    li t6, 88
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    li t6, 42
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 32
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
    li t6, -1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fld ft0, 328(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 56
    sw t0, 336(s0)
    lw t0, 336(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_main_pig_L1:
    addi t0, s0, 56
    sw t0, 344(s0)
    lw t0, 344(s0)
    fld ft0, 0(t0)
    fsd ft0, 352(s0)
    fld ft0, 352(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    flt.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 360(s0)
    fld ft0, 360(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_131
    j .L_main_pig_L3
.L_rama_larga_131:
    fcvt.d.w ft0, s2
    fsd ft0, 368(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 92
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
    fld ft0, 368(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 376(s0)
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
    li t6, 82
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
    li t6, 78
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
    li t6, 92
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
    li t6, 92
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
    fld ft0, 376(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 384(s0)
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
    fld ft0, 384(s0)
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
    fsd ft0, 392(s0)
    addi t0, s0, 0
    sw t0, 400(s0)
    lw t0, 400(s0)
    fld ft0, 392(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 0
    sw t0, 408(s0)
    lw t0, 408(s0)
    fld ft0, 0(t0)
    fsd ft0, 416(s0)
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    li t6, 71926466
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft0, s2
    fsd ft0, 424(s0)
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
    addi t0, s0, 72
    sw t0, 432(s0)
    lw t0, 432(s0)
    addi t0, t0, 8
    sw t0, 440(s0)
    lw t0, 440(s0)
    fld ft0, 424(s0)
    fsd ft0, 0(t0)
    lw t0, 432(s0)
    addi t0, t0, 16
    sw t0, 448(s0)
    lw t0, 448(s0)
    fld ft0, 416(s0)
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    fld fa1, 88(s0)
    jal ra, Juego_String_
    fsd fa0, 72(s0)
    addi t0, s0, 32
    sw t0, 456(s0)
    lw t0, 456(s0)
    fld ft0, 424(s0)
    fsd ft0, 0(t0)
    fcvt.d.w ft0, s2
    fsd ft0, 464(s0)
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
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 488(s0)
    fld ft3, 488(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 496(s0)
    addi t0, s0, 32
    sw t0, 504(s0)
    lw t0, 504(s0)
    fld ft0, 0(t0)
    fsd ft0, 512(s0)
    fld ft0, 512(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 520(s0)
    fld ft3, 520(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 528(s0)
    addi t0, s0, 72
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
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 536(s0)
    addi t0, t0, 24
    sw t0, 560(s0)
    lw t0, 560(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    fld fa1, 88(s0)
    fld fa2, 96(s0)
    jal ra, Tablero_contarAccesibles_int_int_
    fsd fa0, 72(s0)
    addi t0, s0, 72
    sw t0, 568(s0)
    lw t0, 568(s0)
    fld ft0, 0(t0)
    fsd ft0, 576(s0)
    fld ft0, 576(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 584(s0)
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
    fld ft0, 584(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 32
    sw t0, 592(s0)
    lw t0, 592(s0)
    fld ft0, 0(t0)
    fsd ft0, 600(s0)
    fld ft0, 600(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 608(s0)
    fld ft3, 608(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 616(s0)
    addi t0, s0, 32
    sw t0, 624(s0)
    lw t0, 624(s0)
    fld ft0, 0(t0)
    fsd ft0, 632(s0)
    fld ft0, 632(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 640(s0)
    fld ft3, 640(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 648(s0)
    addi t0, s0, 72
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
    li t6, 2
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    fld fa1, 88(s0)
    jal ra, Tablero_contarTipo_int_
    fsd fa0, 72(s0)
    addi t0, s0, 72
    sw t0, 680(s0)
    lw t0, 680(s0)
    fld ft0, 0(t0)
    fsd ft0, 688(s0)
    fld ft0, 688(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 696(s0)
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
    fld ft0, 696(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 32
    sw t0, 704(s0)
    lw t0, 704(s0)
    fld ft0, 0(t0)
    fsd ft0, 712(s0)
    fld ft0, 712(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 720(s0)
    fld ft3, 720(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 728(s0)
    addi t0, s0, 32
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
    addi t0, s0, 32
    sw t0, 768(s0)
    lw t0, 768(s0)
    fld ft0, 0(t0)
    fsd ft0, 776(s0)
    fld ft0, 776(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 784(s0)
    fld ft3, 784(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 792(s0)
    fld ft0, 792(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 800(s0)
    fld ft3, 800(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 808(s0)
    addi t0, s0, 32
    sw t0, 816(s0)
    lw t0, 816(s0)
    fld ft0, 0(t0)
    fsd ft0, 824(s0)
    fld ft0, 824(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 832(s0)
    fld ft3, 832(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 840(s0)
    fld ft0, 840(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 848(s0)
    fld ft3, 848(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 856(s0)
    addi t0, s0, 72
    sw t0, 864(s0)
    lw t0, 864(s0)
    addi t0, t0, 8
    sw t0, 872(s0)
    lw t0, 872(s0)
    fld ft0, 760(s0)
    fsd ft0, 0(t0)
    lw t0, 864(s0)
    addi t0, t0, 16
    sw t0, 880(s0)
    lw t0, 880(s0)
    fld ft0, 808(s0)
    fsd ft0, 0(t0)
    lw t0, 864(s0)
    addi t0, t0, 24
    sw t0, 888(s0)
    lw t0, 888(s0)
    fld ft0, 856(s0)
    fsd ft0, 0(t0)
    lw t0, 864(s0)
    addi t0, t0, 32
    sw t0, 896(s0)
    lw t0, 896(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    lw t0, 864(s0)
    addi t0, t0, 40
    sw t0, 904(s0)
    lw t0, 904(s0)
    li t6, 1
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    fld fa1, 88(s0)
    fld fa2, 96(s0)
    fld fa3, 104(s0)
    fld fa4, 112(s0)
    jal ra, Tablero_distanciaAPared_int_int_int_int_
    fsd fa0, 72(s0)
    addi t0, s0, 72
    sw t0, 912(s0)
    lw t0, 912(s0)
    fld ft0, 0(t0)
    fsd ft0, 920(s0)
    fld ft0, 920(s0)
    fcvt.w.d a0, ft0
    li a7, 1
    ecall
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 8
    sw t0, 928(s0)
    lw t0, 928(s0)
    li t6, 99
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 936(s0)
    lw t0, 936(s0)
    li t6, 0
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
.L_main_pig_L4:
    addi t0, s0, 32
    sw t0, 944(s0)
    lw t0, 944(s0)
    fld ft0, 0(t0)
    fsd ft0, 952(s0)
    fld ft0, 952(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 960(s0)
    fld ft3, 960(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 968(s0)
    fld ft0, 968(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 976(s0)
    fld ft0, 976(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_132
    j .L_main_pig_L5
.L_rama_larga_132:
    addi t0, s0, 32
    sw t0, 984(s0)
    lw t0, 984(s0)
    fld ft0, 0(t0)
    fsd ft0, 992(s0)
    fld ft0, 992(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1000(s0)
    fld ft3, 1000(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1008(s0)
    addi t0, s0, 32
    sw t0, 1016(s0)
    lw t0, 1016(s0)
    fld ft0, 0(t0)
    fsd ft0, 1024(s0)
    fld ft0, 1024(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1032(s0)
    fld ft3, 1032(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1040(s0)
    addi t0, s0, 32
    sw t0, 1048(s0)
    lw t0, 1048(s0)
    fld ft0, 0(t0)
    fsd ft0, 1056(s0)
    fld ft0, 1056(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1064(s0)
    fld ft3, 1064(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1072(s0)
    fld ft0, 1072(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1080(s0)
    fld ft3, 1080(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1088(s0)
    addi t0, s0, 32
    sw t0, 1096(s0)
    lw t0, 1096(s0)
    fld ft0, 0(t0)
    fsd ft0, 1104(s0)
    fld ft0, 1104(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1112(s0)
    fld ft3, 1112(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1120(s0)
    fld ft0, 1120(s0)
    li t6, 2
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1128(s0)
    fld ft3, 1128(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1136(s0)
    addi t0, s0, 72
    sw t0, 1144(s0)
    lw t0, 1144(s0)
    addi t0, t0, 8
    sw t0, 1152(s0)
    lw t0, 1152(s0)
    fld ft0, 1040(s0)
    fsd ft0, 0(t0)
    lw t0, 1144(s0)
    addi t0, t0, 16
    sw t0, 1160(s0)
    lw t0, 1160(s0)
    fld ft0, 1088(s0)
    fsd ft0, 0(t0)
    lw t0, 1144(s0)
    addi t0, t0, 24
    sw t0, 1168(s0)
    lw t0, 1168(s0)
    fld ft0, 1136(s0)
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    fld fa1, 88(s0)
    fld fa2, 96(s0)
    jal ra, Tablero_imprimir_int_int_
    fsd fa0, 72(s0)
    addi t0, s0, 32
    sw t0, 1176(s0)
    lw t0, 1176(s0)
    fld ft0, 0(t0)
    fsd ft0, 1184(s0)
    fld ft0, 1184(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1192(s0)
    fld ft3, 1192(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1200(s0)
    addi t0, s0, 32
    sw t0, 1208(s0)
    lw t0, 1208(s0)
    fld ft0, 0(t0)
    fsd ft0, 1216(s0)
    fld ft0, 1216(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1224(s0)
    fld ft3, 1224(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1232(s0)
    addi t0, s0, 72
    sw t0, 1240(s0)
    lw t0, 1240(s0)
    addi t0, t0, 8
    sw t0, 1248(s0)
    lw t0, 1248(s0)
    fld ft0, 1232(s0)
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    jal ra, Jugador_mostrarEstado__
    fsd fa0, 72(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1256(s0)
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
    li t6, 61
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
    li t6, 61
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
    li t6, 51
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
    li t6, 113
    fcvt.d.w ft0, t6
    fsd ft0, 0(t0)
    addi s2, s2, 1
    fcvt.d.w ft3, s2
    fcvt.w.d t0, ft3
    slli t0, t0, 3
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
    li t6, 61
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
    li t6, 48
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
    fld ft0, 1256(s0)
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
    fsd ft0, 1264(s0)
    addi t0, s0, 8
    sw t0, 1272(s0)
    lw t0, 1272(s0)
    fld ft0, 1264(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 8
    sw t0, 1280(s0)
    lw t0, 1280(s0)
    fld ft0, 0(t0)
    fsd ft0, 1288(s0)
    fld ft0, 1288(s0)
    li t6, 0
    fcvt.d.w ft1, t6
    feq.d t0, ft0, ft1
    fcvt.d.w ft2, t0
    fsd ft2, 1296(s0)
    fld ft0, 1296(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_133
    j .L_main_pig_L6
.L_rama_larga_133:
    j .L_main_pig_L5
.L_main_pig_L6:
    addi t0, s0, 32
    sw t0, 1304(s0)
    lw t0, 1304(s0)
    fld ft0, 0(t0)
    fsd ft0, 1312(s0)
    addi t0, s0, 32
    sw t0, 1320(s0)
    lw t0, 1320(s0)
    fld ft0, 0(t0)
    fsd ft0, 1328(s0)
    addi t0, s0, 8
    sw t0, 1336(s0)
    lw t0, 1336(s0)
    fld ft0, 0(t0)
    fsd ft0, 1344(s0)
    addi t0, s0, 72
    sw t0, 1352(s0)
    lw t0, 1352(s0)
    addi t0, t0, 8
    sw t0, 1360(s0)
    lw t0, 1360(s0)
    fld ft0, 1328(s0)
    fsd ft0, 0(t0)
    lw t0, 1352(s0)
    addi t0, t0, 16
    sw t0, 1368(s0)
    lw t0, 1368(s0)
    fld ft0, 1344(s0)
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    fld fa1, 88(s0)
    jal ra, Juego_mover_int_
    fsd fa0, 72(s0)
    addi t0, s0, 72
    sw t0, 1376(s0)
    lw t0, 1376(s0)
    fld ft0, 0(t0)
    fsd ft0, 1384(s0)
    addi t0, s0, 32
    sw t0, 1392(s0)
    lw t0, 1392(s0)
    fld ft0, 0(t0)
    fsd ft0, 1400(s0)
    fld ft0, 1400(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1408(s0)
    fld ft3, 1408(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1416(s0)
    fld ft0, 1416(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 16
    sw t0, 1424(s0)
    lw t0, 1424(s0)
    fld ft0, 0(t0)
    fsd ft0, 1432(s0)
    fld ft0, 1432(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1440(s0)
    addi t0, s0, 16
    sw t0, 1448(s0)
    lw t0, 1448(s0)
    fld ft0, 1440(s0)
    fsd ft0, 0(t0)
    addi t0, s0, 16
    sw t0, 1456(s0)
    lw t0, 1456(s0)
    fld ft0, 0(t0)
    fsd ft0, 1464(s0)
    addi t0, s0, 24
    sw t0, 1472(s0)
    lw t0, 1472(s0)
    fld ft0, 0(t0)
    fsd ft0, 1480(s0)
    fld ft0, 1464(s0)
    fld ft1, 1480(s0)
    flt.d t0, ft1, ft0
    fcvt.d.w ft2, t0
    fsd ft2, 1488(s0)
    fld ft0, 1488(s0)
    fcvt.w.d t0, ft0
    bnez t0, .L_rama_larga_134
    j .L_main_pig_L8
.L_rama_larga_134:
    fcvt.d.w ft0, s2
    fsd ft0, 1496(s0)
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
    li t6, 114
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
    fld ft0, 1496(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    j .L_main_pig_L5
.L_main_pig_L8:
    j .L_main_pig_L4
.L_main_pig_L5:
    fcvt.d.w ft0, s2
    fsd ft0, 1504(s0)
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
    fld ft0, 1504(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 32
    sw t0, 1512(s0)
    lw t0, 1512(s0)
    fld ft0, 0(t0)
    fsd ft0, 1520(s0)
    fld ft0, 1520(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1528(s0)
    fld ft3, 1528(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1536(s0)
    addi t0, s0, 32
    sw t0, 1544(s0)
    lw t0, 1544(s0)
    fld ft0, 0(t0)
    fsd ft0, 1552(s0)
    fld ft0, 1552(s0)
    li t6, 1
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
    addi t0, t0, 8
    sw t0, 1584(s0)
    lw t0, 1584(s0)
    fld ft0, 1568(s0)
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    jal ra, Jugador_mostrarEstado__
    fsd fa0, 72(s0)
    fcvt.d.w ft0, s2
    fsd ft0, 1592(s0)
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
    fld ft0, 1592(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 32
    sw t0, 1600(s0)
    lw t0, 1600(s0)
    fld ft0, 0(t0)
    fsd ft0, 1608(s0)
    addi t0, s0, 32
    sw t0, 1616(s0)
    lw t0, 1616(s0)
    fld ft0, 0(t0)
    fsd ft0, 1624(s0)
    addi t0, s0, 72
    sw t0, 1632(s0)
    lw t0, 1632(s0)
    addi t0, t0, 8
    sw t0, 1640(s0)
    lw t0, 1640(s0)
    fld ft0, 1624(s0)
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    jal ra, Juego_obtenerVeredicto__
    fsd fa0, 72(s0)
    addi t0, s0, 72
    sw t0, 1648(s0)
    lw t0, 1648(s0)
    fld ft0, 0(t0)
    fsd ft0, 1656(s0)
    fld ft0, 1656(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    fcvt.d.w ft0, s2
    fsd ft0, 1664(s0)
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
    li t6, 102
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
    fld ft0, 1664(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 32
    sw t0, 1672(s0)
    lw t0, 1672(s0)
    fld ft0, 0(t0)
    fsd ft0, 1680(s0)
    fld ft0, 1680(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1688(s0)
    fld ft3, 1688(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1696(s0)
    fld ft0, 1696(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1704(s0)
    fld ft3, 1704(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1712(s0)
    addi t0, s0, 32
    sw t0, 1720(s0)
    lw t0, 1720(s0)
    fld ft0, 0(t0)
    fsd ft0, 1728(s0)
    fld ft0, 1728(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1736(s0)
    fld ft3, 1736(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1744(s0)
    fld ft0, 1744(s0)
    li t6, 4
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1752(s0)
    fld ft3, 1752(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1760(s0)
    addi t0, s0, 72
    sw t0, 1768(s0)
    lw t0, 1768(s0)
    addi t0, t0, 8
    sw t0, 1776(s0)
    lw t0, 1776(s0)
    fld ft0, 1712(s0)
    fsd ft0, 0(t0)
    lw t0, 1768(s0)
    addi t0, t0, 16
    sw t0, 1784(s0)
    lw t0, 1784(s0)
    fld ft0, 1760(s0)
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    fld fa1, 88(s0)
    jal ra, calificar
    fsd fa0, 72(s0)
    addi t0, s0, 72
    sw t0, 1792(s0)
    lw t0, 1792(s0)
    fld ft0, 0(t0)
    fsd ft0, 1800(s0)
    fld ft0, 1800(s0)
    fcvt.w.d a0, ft0
    jal ra, imprimir_cadena
    la a0, salto_linea
    li a7, 4
    ecall
    addi t0, s0, 48
    sw t0, 1808(s0)
    lw t0, 1808(s0)
    fld ft0, 0(t0)
    fsd ft0, 1816(s0)
    addi t0, s0, 0
    sw t0, 1824(s0)
    lw t0, 1824(s0)
    fld ft0, 0(t0)
    fsd ft0, 1832(s0)
    addi t0, s0, 32
    sw t0, 1840(s0)
    lw t0, 1840(s0)
    fld ft0, 0(t0)
    fsd ft0, 1848(s0)
    fld ft0, 1848(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1856(s0)
    fld ft3, 1856(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1864(s0)
    fld ft0, 1864(s0)
    li t6, 3
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1872(s0)
    fld ft3, 1872(s0)
    fcvt.w.d t0, ft3
    slli t0, t0, 3
    add t0, s1, t0
    fld ft0, 0(t0)
    fsd ft0, 1880(s0)
    addi t0, s0, 72
    sw t0, 1888(s0)
    lw t0, 1888(s0)
    addi t0, t0, 8
    sw t0, 1896(s0)
    lw t0, 1896(s0)
    fld ft0, 1816(s0)
    fsd ft0, 0(t0)
    lw t0, 1888(s0)
    addi t0, t0, 16
    sw t0, 1904(s0)
    lw t0, 1904(s0)
    fld ft0, 1832(s0)
    fsd ft0, 0(t0)
    lw t0, 1888(s0)
    addi t0, t0, 24
    sw t0, 1912(s0)
    lw t0, 1912(s0)
    fld ft0, 1880(s0)
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    fld fa1, 88(s0)
    fld fa2, 96(s0)
    jal ra, registrarPartida
    fsd fa0, 72(s0)
.L_main_pig_L2:
    addi t0, s0, 56
    sw t0, 1920(s0)
    lw t0, 1920(s0)
    fld ft0, 0(t0)
    fsd ft0, 1928(s0)
    fld ft0, 1928(s0)
    li t6, 1
    fcvt.d.w ft1, t6
    fadd.d ft2, ft0, ft1
    fsd ft2, 1936(s0)
    lw t0, 1920(s0)
    fld ft0, 1936(s0)
    fsd ft0, 0(t0)
    j .L_main_pig_L1
.L_main_pig_L3:
    addi t0, s0, 48
    sw t0, 1944(s0)
    lw t0, 1944(s0)
    fld ft0, 0(t0)
    fsd ft0, 1952(s0)
    addi t0, s0, 72
    sw t0, 1960(s0)
    lw t0, 1960(s0)
    addi t0, t0, 8
    sw t0, 1968(s0)
    lw t0, 1968(s0)
    fld ft0, 1952(s0)
    fsd ft0, 0(t0)
    fld fa0, 80(s0)
    jal ra, imprimirResumen
    fsd fa0, 72(s0)
.L_fin_main_pig:
    lw t0, 1976(s0)
    lw ra, 1980(s0)
    mv sp, s0
    mv s0, t0
    addi sp, sp, 1984
    ret

