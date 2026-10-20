#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include <ctype.h>
#include <errno.h>
#include <limits.h>

#define STACK_SIZE 100000
#define HEAP_SIZE 100000

double Stack[STACK_SIZE];
double Heap[HEAP_SIZE];

double P = 0;
double H = 0;

void registrar();
void esPar();
void paridad();
void imprimirRegistro();
void Nodo_int();
void ListaDoble_();
void ListaDoble_int();
void estaVacia_();
void insertarInicio_int();
void insertarFinal_int();
void insertarFinal_int_int();
void insertarEn_int_int();
void eliminarInicio_();
void eliminarFinal_();
void eliminarEn_int();
void eliminarValor_int();
void vaciar_();
void obtenerNodo_int();
void obtener_int();
void buscar_int();
void maximo_();
void sumaRecursiva_Nodo();
void suma_();
void invertir_();
void ordenar_();
void imprimirAdelante_();
void imprimirAtras_();
void main_pig();

void registrar() {
    double t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18, t19, t20, t21, t22, t23, t24, t25, t26;
    t1 = P + 1;
    t2 = Stack[(int)t1];
    t3 = t2 + 0;
    t4 = Heap[(int)t3];
    t5 = t4 + 1;
    Heap[(int)t3] = t5;
    t6 = P + 2;
    t7 = Stack[(int)t6];
    t8 = t7 == 1;
    if (!(t8)) goto L6;
    goto L2;
L6:
    ;
    t9 = t7 == 2;
    if (!(t9)) goto L7;
    goto L3;
L7:
    ;
    t10 = t7 == 3;
    if (!(t10)) goto L8;
    goto L4;
L8:
    ;
    goto L5;
L2:
    ;
    t11 = P + 1;
    t12 = Stack[(int)t11];
    t13 = t12 + 1;
    t14 = Heap[(int)t13];
    t15 = t14 + 1;
    Heap[(int)t13] = t15;
    goto L1;
L3:
    ;
    t16 = P + 1;
    t17 = Stack[(int)t16];
    t18 = t17 + 2;
    t19 = Heap[(int)t18];
    t20 = t19 + 1;
    Heap[(int)t18] = t20;
    goto L1;
L4:
    ;
    t21 = P + 1;
    t22 = Stack[(int)t21];
    t23 = t22 + 3;
    t24 = Heap[(int)t23];
    t25 = t24 + 1;
    Heap[(int)t23] = t25;
    goto L1;
L5:
    ;
    t26 = H;
    Heap[(int)H] = 84;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t26);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    goto L1;
L1:
    ;
}

void esPar() {
    double t27, t28, t29, t30, t31, t32, t33, t34, t35;
    t27 = P + 1;
    t28 = Stack[(int)t27];
    t29 = P + 1;
    t30 = Stack[(int)t29];
    t31 = t30 / 2;
    t32 = t31 * 2;
    t33 = t28 - t32;
    t34 = t33 == 0;
    t35 = P + 0;
    Stack[(int)t35] = t34;
    return;
}

void paridad() {
    double t36, t37, t38, t39, t40, t41, t42, t43, t44, t45, t46;
    t36 = P + 1;
    t37 = Stack[(int)t36];
    t38 = P + 2;
    t39 = t38 + 1;
    Stack[(int)t39] = t37;
    P = P + 2;
    esPar();
    t40 = P + 0;
    t41 = Stack[(int)t40];
    P = P - 2;
    t42 = t41 == 1;
    if (!(t42)) goto L10;
    t43 = H;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t44 = P + 0;
    Stack[(int)t44] = t43;
    return;
    goto L9;
L10:
    ;
    t45 = H;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t46 = P + 0;
    Stack[(int)t46] = t45;
    return;
L9:
    ;
}

void imprimirRegistro() {
    double t47, t48, t49, t50, t51, t52, t53, t54, t55, t56, t57, t58, t59, t60, t61, t62, t63, t64, t65, t66, t67, t68, t69, t70, t71, t72, t73, t74, t75, t76, t77, t78, t79, t80, t81, t82, t83, t84, t85, t86, t87, t88, t89, t90, t91, t92, t93, t94, t95, t96, t97, t98, t99;
    t47 = H;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 82;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 71;
    H = H + 1;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 83;
    H = H + 1;
    Heap[(int)H] = 84;
    H = H + 1;
    Heap[(int)H] = 82;
    H = H + 1;
    Heap[(int)H] = 79;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 68;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 79;
    H = H + 1;
    Heap[(int)H] = 80;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 82;
    H = H + 1;
    Heap[(int)H] = 65;
    H = H + 1;
    Heap[(int)H] = 67;
    H = H + 1;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 79;
    H = H + 1;
    Heap[(int)H] = 78;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 83;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t47);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t48 = H;
    Heap[(int)H] = 79;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t49 = P + 1;
    t50 = Stack[(int)t49];
    t51 = t50 + 0;
    t52 = Heap[(int)t51];
    {
        char __buffer[128];
        snprintf(__buffer, sizeof(__buffer), "%d", (int)(t52));
        t53 = H;
        for (int __i = 0; __buffer[__i] != '\0'; __i++) {
            Heap[(int)H] = (double)__buffer[__i];
            H = H + 1;
        }
        Heap[(int)H] = -1;
        H = H + 1;
    }
    t54 = H;
    t55 = t48;
L11:
    ;
    t56 = Heap[(int)t55];
    t57 = t56 == -1;
    if (t57) goto L12;
    Heap[(int)H] = t56;
    H = H + 1;
    t55 = t55 + 1;
    goto L11;
L12:
    ;
    t58 = t53;
L13:
    ;
    t59 = Heap[(int)t58];
    t60 = t59 == -1;
    if (t60) goto L14;
    Heap[(int)H] = t59;
    H = H + 1;
    t58 = t58 + 1;
    goto L13;
L14:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t54);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t61 = H;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t62 = P + 1;
    t63 = Stack[(int)t62];
    t64 = t63 + 1;
    t65 = Heap[(int)t64];
    {
        char __buffer[128];
        snprintf(__buffer, sizeof(__buffer), "%d", (int)(t65));
        t66 = H;
        for (int __i = 0; __buffer[__i] != '\0'; __i++) {
            Heap[(int)H] = (double)__buffer[__i];
            H = H + 1;
        }
        Heap[(int)H] = -1;
        H = H + 1;
    }
    t67 = H;
    t68 = t61;
L15:
    ;
    t69 = Heap[(int)t68];
    t70 = t69 == -1;
    if (t70) goto L16;
    Heap[(int)H] = t69;
    H = H + 1;
    t68 = t68 + 1;
    goto L15;
L16:
    ;
    t71 = t66;
L17:
    ;
    t72 = Heap[(int)t71];
    t73 = t72 == -1;
    if (t73) goto L18;
    Heap[(int)H] = t72;
    H = H + 1;
    t71 = t71 + 1;
    goto L17;
L18:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t67);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t74 = H;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t75 = P + 1;
    t76 = Stack[(int)t75];
    t77 = t76 + 2;
    t78 = Heap[(int)t77];
    {
        char __buffer[128];
        snprintf(__buffer, sizeof(__buffer), "%d", (int)(t78));
        t79 = H;
        for (int __i = 0; __buffer[__i] != '\0'; __i++) {
            Heap[(int)H] = (double)__buffer[__i];
            H = H + 1;
        }
        Heap[(int)H] = -1;
        H = H + 1;
    }
    t80 = H;
    t81 = t74;
L19:
    ;
    t82 = Heap[(int)t81];
    t83 = t82 == -1;
    if (t83) goto L20;
    Heap[(int)H] = t82;
    H = H + 1;
    t81 = t81 + 1;
    goto L19;
L20:
    ;
    t84 = t79;
L21:
    ;
    t85 = Heap[(int)t84];
    t86 = t85 == -1;
    if (t86) goto L22;
    Heap[(int)H] = t85;
    H = H + 1;
    t84 = t84 + 1;
    goto L21;
L22:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t80);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t87 = H;
    Heap[(int)H] = 66;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 113;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 120;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t88 = P + 1;
    t89 = Stack[(int)t88];
    t90 = t89 + 3;
    t91 = Heap[(int)t90];
    {
        char __buffer[128];
        snprintf(__buffer, sizeof(__buffer), "%d", (int)(t91));
        t92 = H;
        for (int __i = 0; __buffer[__i] != '\0'; __i++) {
            Heap[(int)H] = (double)__buffer[__i];
            H = H + 1;
        }
        Heap[(int)H] = -1;
        H = H + 1;
    }
    t93 = H;
    t94 = t87;
L23:
    ;
    t95 = Heap[(int)t94];
    t96 = t95 == -1;
    if (t96) goto L24;
    Heap[(int)H] = t95;
    H = H + 1;
    t94 = t94 + 1;
    goto L23;
L24:
    ;
    t97 = t92;
L25:
    ;
    t98 = Heap[(int)t97];
    t99 = t98 == -1;
    if (t99) goto L26;
    Heap[(int)H] = t98;
    H = H + 1;
    t97 = t97 + 1;
    goto L25;
L26:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t93);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
}

void Nodo_int() {
    double t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11;
    t1 = P + 2;
    t2 = Stack[(int)t1];
    t3 = P + 1;
    t4 = Stack[(int)t3];
    t5 = t4 + 0;
    Heap[(int)t5] = t2;
    t6 = P + 1;
    t7 = Stack[(int)t6];
    t8 = t7 + 1;
    Heap[(int)t8] = 0;
    t9 = P + 1;
    t10 = Stack[(int)t9];
    t11 = t10 + 2;
    Heap[(int)t11] = 0;
}

void ListaDoble_() {
    double t12, t13, t14, t15, t16, t17, t18, t19, t20;
    t12 = P + 1;
    t13 = Stack[(int)t12];
    t14 = t13 + 0;
    Heap[(int)t14] = 0;
    t15 = P + 1;
    t16 = Stack[(int)t15];
    t17 = t16 + 1;
    Heap[(int)t17] = 0;
    t18 = P + 1;
    t19 = Stack[(int)t18];
    t20 = t19 + 2;
    Heap[(int)t20] = 0;
}

void ListaDoble_int() {
    double t21, t22, t23, t24, t25, t26, t27, t28, t29, t30, t31, t32, t33, t34, t35, t36;
    t21 = P + 1;
    t22 = Stack[(int)t21];
    t23 = t22 + 0;
    Heap[(int)t23] = 0;
    t24 = P + 1;
    t25 = Stack[(int)t24];
    t26 = t25 + 1;
    Heap[(int)t26] = 0;
    t27 = P + 1;
    t28 = Stack[(int)t27];
    t29 = t28 + 2;
    Heap[(int)t29] = 0;
    t30 = P + 1;
    t31 = Stack[(int)t30];
    t32 = P + 2;
    t33 = Stack[(int)t32];
    t34 = P + 3;
    t35 = t34 + 1;
    Stack[(int)t35] = t31;
    t36 = t34 + 2;
    Stack[(int)t36] = t33;
    P = P + 3;
    insertarFinal_int();
    P = P - 3;
}

void estaVacia_() {
    double t37, t38, t39, t40, t41, t42;
    t37 = P + 1;
    t38 = Stack[(int)t37];
    t39 = t38 + 0;
    t40 = Heap[(int)t39];
    t41 = t40 == 0;
    t42 = P + 0;
    Stack[(int)t42] = t41;
    return;
}

void insertarInicio_int() {
    double t43, t44, t45, t46, t47, t48, t49, t50, t51, t52, t53, t54, t55, t56, t57, t58, t59, t60, t61, t62, t63, t64, t65, t66, t67, t68, t69, t70, t71, t72, t73, t74, t75, t76, t77, t78, t79, t80, t81, t82, t83, t84, t85, t86, t87, t88;
    t43 = P + 2;
    t44 = Stack[(int)t43];
    t45 = H;
    H = H + 3;
    t46 = P + 4;
    t47 = t46 + 1;
    Stack[(int)t47] = t45;
    t48 = t46 + 2;
    Stack[(int)t48] = t44;
    P = P + 4;
    Nodo_int();
    P = P - 4;
    t49 = P + 3;
    Stack[(int)t49] = t45;
    t50 = P + 1;
    t51 = Stack[(int)t50];
    t52 = t51 + 0;
    t53 = Heap[(int)t52];
    t54 = t53 == 0;
    if (!(t54)) goto L2;
    t55 = P + 3;
    t56 = Stack[(int)t55];
    t57 = P + 1;
    t58 = Stack[(int)t57];
    t59 = t58 + 0;
    Heap[(int)t59] = t56;
    t60 = P + 3;
    t61 = Stack[(int)t60];
    t62 = P + 1;
    t63 = Stack[(int)t62];
    t64 = t63 + 1;
    Heap[(int)t64] = t61;
    goto L1;
L2:
    ;
    t65 = P + 3;
    t66 = Stack[(int)t65];
    t67 = t66 + 1;
    t68 = P + 1;
    t69 = Stack[(int)t68];
    t70 = t69 + 0;
    t71 = Heap[(int)t70];
    Heap[(int)t67] = t71;
    t72 = P + 1;
    t73 = Stack[(int)t72];
    t74 = t73 + 0;
    t75 = Heap[(int)t74];
    t76 = t75 + 2;
    t77 = P + 3;
    t78 = Stack[(int)t77];
    Heap[(int)t76] = t78;
    t79 = P + 3;
    t80 = Stack[(int)t79];
    t81 = P + 1;
    t82 = Stack[(int)t81];
    t83 = t82 + 0;
    Heap[(int)t83] = t80;
L1:
    ;
    t84 = P + 1;
    t85 = Stack[(int)t84];
    t86 = t85 + 2;
    t87 = Heap[(int)t86];
    t88 = t87 + 1;
    Heap[(int)t86] = t88;
}

void insertarFinal_int() {
    double t89, t90, t91, t92, t93, t94, t95, t96, t97, t98, t99, t100, t101, t102, t103, t104, t105, t106, t107, t108, t109, t110, t111, t112, t113, t114, t115, t116, t117, t118, t119, t120, t121, t122, t123, t124, t125, t126, t127, t128, t129, t130, t131, t132, t133, t134;
    t89 = P + 2;
    t90 = Stack[(int)t89];
    t91 = H;
    H = H + 3;
    t92 = P + 4;
    t93 = t92 + 1;
    Stack[(int)t93] = t91;
    t94 = t92 + 2;
    Stack[(int)t94] = t90;
    P = P + 4;
    Nodo_int();
    P = P - 4;
    t95 = P + 3;
    Stack[(int)t95] = t91;
    t96 = P + 1;
    t97 = Stack[(int)t96];
    t98 = t97 + 1;
    t99 = Heap[(int)t98];
    t100 = t99 == 0;
    if (!(t100)) goto L4;
    t101 = P + 3;
    t102 = Stack[(int)t101];
    t103 = P + 1;
    t104 = Stack[(int)t103];
    t105 = t104 + 0;
    Heap[(int)t105] = t102;
    t106 = P + 3;
    t107 = Stack[(int)t106];
    t108 = P + 1;
    t109 = Stack[(int)t108];
    t110 = t109 + 1;
    Heap[(int)t110] = t107;
    goto L3;
L4:
    ;
    t111 = P + 3;
    t112 = Stack[(int)t111];
    t113 = t112 + 2;
    t114 = P + 1;
    t115 = Stack[(int)t114];
    t116 = t115 + 1;
    t117 = Heap[(int)t116];
    Heap[(int)t113] = t117;
    t118 = P + 1;
    t119 = Stack[(int)t118];
    t120 = t119 + 1;
    t121 = Heap[(int)t120];
    t122 = t121 + 1;
    t123 = P + 3;
    t124 = Stack[(int)t123];
    Heap[(int)t122] = t124;
    t125 = P + 3;
    t126 = Stack[(int)t125];
    t127 = P + 1;
    t128 = Stack[(int)t127];
    t129 = t128 + 1;
    Heap[(int)t129] = t126;
L3:
    ;
    t130 = P + 1;
    t131 = Stack[(int)t130];
    t132 = t131 + 2;
    t133 = Heap[(int)t132];
    t134 = t133 + 1;
    Heap[(int)t132] = t134;
}

void insertarFinal_int_int() {
    double t135, t136, t137, t138, t139, t140, t141, t142, t143, t144, t145, t146, t147, t148;
    t135 = P + 1;
    t136 = Stack[(int)t135];
    t137 = P + 2;
    t138 = Stack[(int)t137];
    t139 = P + 4;
    t140 = t139 + 1;
    Stack[(int)t140] = t136;
    t141 = t139 + 2;
    Stack[(int)t141] = t138;
    P = P + 4;
    insertarFinal_int();
    P = P - 4;
    t142 = P + 1;
    t143 = Stack[(int)t142];
    t144 = P + 3;
    t145 = Stack[(int)t144];
    t146 = P + 4;
    t147 = t146 + 1;
    Stack[(int)t147] = t143;
    t148 = t146 + 2;
    Stack[(int)t148] = t145;
    P = P + 4;
    insertarFinal_int();
    P = P - 4;
}

void insertarEn_int_int() {
    double t149, t150, t151, t152, t153, t154, t155, t156, t157, t158, t159, t160, t161, t162, t163, t164, t165, t166, t167, t168, t169, t170, t171, t172, t173, t174, t175, t176, t177, t178, t179, t180, t181, t182, t183, t184, t185, t186, t187, t188, t189, t190, t191, t192, t193, t194, t195, t196, t197, t198, t199, t200, t201, t202, t203, t204, t205, t206, t207, t208, t209, t210, t211, t212, t213, t214, t215, t216, t217, t218, t219, t220, t221, t222, t223, t224, t225, t226, t227, t228, t229, t230, t231, t232, t233;
    t149 = P + 2;
    t150 = Stack[(int)t149];
    t151 = t150 < 0;
    if (!(t151)) goto L7;
    t152 = 1;
    goto L8;
L7:
    ;
    t153 = P + 2;
    t154 = Stack[(int)t153];
    t155 = P + 1;
    t156 = Stack[(int)t155];
    t157 = t156 + 2;
    t158 = Heap[(int)t157];
    t159 = t154 > t158;
    t152 = t159;
L8:
    ;
    if (!(t152)) goto L6;
    t160 = P + 0;
    Stack[(int)t160] = 0;
    return;
    goto L5;
L6:
    ;
L5:
    ;
    t161 = P + 2;
    t162 = Stack[(int)t161];
    t163 = t162 == 0;
    if (!(t163)) goto L10;
    t164 = P + 1;
    t165 = Stack[(int)t164];
    t166 = P + 3;
    t167 = Stack[(int)t166];
    t168 = P + 6;
    t169 = t168 + 1;
    Stack[(int)t169] = t165;
    t170 = t168 + 2;
    Stack[(int)t170] = t167;
    P = P + 6;
    insertarInicio_int();
    P = P - 6;
    t171 = P + 0;
    Stack[(int)t171] = 1;
    return;
    goto L9;
L10:
    ;
L9:
    ;
    t172 = P + 2;
    t173 = Stack[(int)t172];
    t174 = P + 1;
    t175 = Stack[(int)t174];
    t176 = t175 + 2;
    t177 = Heap[(int)t176];
    t178 = t173 == t177;
    if (!(t178)) goto L12;
    t179 = P + 1;
    t180 = Stack[(int)t179];
    t181 = P + 3;
    t182 = Stack[(int)t181];
    t183 = P + 6;
    t184 = t183 + 1;
    Stack[(int)t184] = t180;
    t185 = t183 + 2;
    Stack[(int)t185] = t182;
    P = P + 6;
    insertarFinal_int();
    P = P - 6;
    t186 = P + 0;
    Stack[(int)t186] = 1;
    return;
    goto L11;
L12:
    ;
L11:
    ;
    t187 = P + 1;
    t188 = Stack[(int)t187];
    t189 = P + 2;
    t190 = Stack[(int)t189];
    t191 = P + 6;
    t192 = t191 + 1;
    Stack[(int)t192] = t188;
    t193 = t191 + 2;
    Stack[(int)t193] = t190;
    P = P + 6;
    obtenerNodo_int();
    t194 = P + 0;
    t195 = Stack[(int)t194];
    P = P - 6;
    t196 = P + 4;
    Stack[(int)t196] = t195;
    t197 = P + 3;
    t198 = Stack[(int)t197];
    t199 = H;
    H = H + 3;
    t200 = P + 6;
    t201 = t200 + 1;
    Stack[(int)t201] = t199;
    t202 = t200 + 2;
    Stack[(int)t202] = t198;
    P = P + 6;
    Nodo_int();
    P = P - 6;
    t203 = P + 5;
    Stack[(int)t203] = t199;
    t204 = P + 5;
    t205 = Stack[(int)t204];
    t206 = t205 + 2;
    t207 = P + 4;
    t208 = Stack[(int)t207];
    t209 = t208 + 2;
    t210 = Heap[(int)t209];
    Heap[(int)t206] = t210;
    t211 = P + 5;
    t212 = Stack[(int)t211];
    t213 = t212 + 1;
    t214 = P + 4;
    t215 = Stack[(int)t214];
    Heap[(int)t213] = t215;
    t216 = P + 4;
    t217 = Stack[(int)t216];
    t218 = t217 + 2;
    t219 = Heap[(int)t218];
    t220 = t219 + 1;
    t221 = P + 5;
    t222 = Stack[(int)t221];
    Heap[(int)t220] = t222;
    t223 = P + 4;
    t224 = Stack[(int)t223];
    t225 = t224 + 2;
    t226 = P + 5;
    t227 = Stack[(int)t226];
    Heap[(int)t225] = t227;
    t228 = P + 1;
    t229 = Stack[(int)t228];
    t230 = t229 + 2;
    t231 = Heap[(int)t230];
    t232 = t231 + 1;
    Heap[(int)t230] = t232;
    t233 = P + 0;
    Stack[(int)t233] = 1;
    return;
}

void eliminarInicio_() {
    double t234, t235, t236, t237, t238, t239, t240, t241, t242, t243, t244, t245, t246, t247, t248, t249, t250, t251, t252, t253, t254, t255, t256, t257, t258, t259, t260, t261, t262, t263, t264, t265, t266, t267, t268, t269, t270, t271, t272, t273, t274;
    t234 = P + 1;
    t235 = Stack[(int)t234];
    t236 = t235 + 0;
    t237 = Heap[(int)t236];
    t238 = t237 == 0;
    if (!(t238)) goto L14;
    t239 = P + 0;
    Stack[(int)t239] = 0;
    return;
    goto L13;
L14:
    ;
L13:
    ;
    t240 = P + 1;
    t241 = Stack[(int)t240];
    t242 = t241 + 0;
    t243 = Heap[(int)t242];
    t244 = P + 1;
    t245 = Stack[(int)t244];
    t246 = t245 + 1;
    t247 = Heap[(int)t246];
    t248 = t243 == t247;
    if (!(t248)) goto L16;
    t249 = P + 1;
    t250 = Stack[(int)t249];
    t251 = t250 + 0;
    Heap[(int)t251] = 0;
    t252 = P + 1;
    t253 = Stack[(int)t252];
    t254 = t253 + 1;
    Heap[(int)t254] = 0;
    goto L15;
L16:
    ;
    t255 = P + 1;
    t256 = Stack[(int)t255];
    t257 = t256 + 0;
    t258 = Heap[(int)t257];
    t259 = t258 + 1;
    t260 = Heap[(int)t259];
    t261 = P + 1;
    t262 = Stack[(int)t261];
    t263 = t262 + 0;
    Heap[(int)t263] = t260;
    t264 = P + 1;
    t265 = Stack[(int)t264];
    t266 = t265 + 0;
    t267 = Heap[(int)t266];
    t268 = t267 + 2;
    Heap[(int)t268] = 0;
L15:
    ;
    t269 = P + 1;
    t270 = Stack[(int)t269];
    t271 = t270 + 2;
    t272 = Heap[(int)t271];
    t273 = t272 - 1;
    Heap[(int)t271] = t273;
    t274 = P + 0;
    Stack[(int)t274] = 1;
    return;
}

void eliminarFinal_() {
    double t275, t276, t277, t278, t279, t280, t281, t282, t283, t284, t285, t286, t287, t288, t289, t290, t291, t292, t293, t294, t295, t296, t297, t298, t299, t300, t301, t302, t303, t304, t305, t306, t307, t308, t309, t310, t311, t312, t313, t314, t315;
    t275 = P + 1;
    t276 = Stack[(int)t275];
    t277 = t276 + 1;
    t278 = Heap[(int)t277];
    t279 = t278 == 0;
    if (!(t279)) goto L18;
    t280 = P + 0;
    Stack[(int)t280] = 0;
    return;
    goto L17;
L18:
    ;
L17:
    ;
    t281 = P + 1;
    t282 = Stack[(int)t281];
    t283 = t282 + 0;
    t284 = Heap[(int)t283];
    t285 = P + 1;
    t286 = Stack[(int)t285];
    t287 = t286 + 1;
    t288 = Heap[(int)t287];
    t289 = t284 == t288;
    if (!(t289)) goto L20;
    t290 = P + 1;
    t291 = Stack[(int)t290];
    t292 = t291 + 0;
    Heap[(int)t292] = 0;
    t293 = P + 1;
    t294 = Stack[(int)t293];
    t295 = t294 + 1;
    Heap[(int)t295] = 0;
    goto L19;
L20:
    ;
    t296 = P + 1;
    t297 = Stack[(int)t296];
    t298 = t297 + 1;
    t299 = Heap[(int)t298];
    t300 = t299 + 2;
    t301 = Heap[(int)t300];
    t302 = P + 1;
    t303 = Stack[(int)t302];
    t304 = t303 + 1;
    Heap[(int)t304] = t301;
    t305 = P + 1;
    t306 = Stack[(int)t305];
    t307 = t306 + 1;
    t308 = Heap[(int)t307];
    t309 = t308 + 1;
    Heap[(int)t309] = 0;
L19:
    ;
    t310 = P + 1;
    t311 = Stack[(int)t310];
    t312 = t311 + 2;
    t313 = Heap[(int)t312];
    t314 = t313 - 1;
    Heap[(int)t312] = t314;
    t315 = P + 0;
    Stack[(int)t315] = 1;
    return;
}

void eliminarEn_int() {
    double t316, t317, t318, t319, t320, t321, t322, t323, t324, t325, t326, t327, t328, t329, t330, t331, t332, t333, t334, t335, t336, t337, t338, t339, t340, t341, t342, t343, t344, t345, t346, t347, t348, t349, t350, t351, t352, t353, t354, t355, t356, t357, t358, t359, t360, t361, t362, t363, t364, t365, t366, t367, t368, t369, t370, t371, t372, t373, t374, t375, t376, t377, t378, t379, t380, t381, t382, t383, t384, t385, t386;
    t316 = P + 2;
    t317 = Stack[(int)t316];
    t318 = t317 < 0;
    if (!(t318)) goto L23;
    t319 = 1;
    goto L24;
L23:
    ;
    t320 = P + 2;
    t321 = Stack[(int)t320];
    t322 = P + 1;
    t323 = Stack[(int)t322];
    t324 = t323 + 2;
    t325 = Heap[(int)t324];
    t326 = t321 >= t325;
    t319 = t326;
L24:
    ;
    if (!(t319)) goto L22;
    t327 = P + 0;
    Stack[(int)t327] = 0;
    return;
    goto L21;
L22:
    ;
L21:
    ;
    t328 = P + 2;
    t329 = Stack[(int)t328];
    t330 = t329 == 0;
    if (!(t330)) goto L26;
    t331 = P + 1;
    t332 = Stack[(int)t331];
    t333 = P + 4;
    t334 = t333 + 1;
    Stack[(int)t334] = t332;
    P = P + 4;
    eliminarInicio_();
    t335 = P + 0;
    t336 = Stack[(int)t335];
    P = P - 4;
    t337 = P + 0;
    Stack[(int)t337] = t336;
    return;
    goto L25;
L26:
    ;
L25:
    ;
    t338 = P + 2;
    t339 = Stack[(int)t338];
    t340 = P + 1;
    t341 = Stack[(int)t340];
    t342 = t341 + 2;
    t343 = Heap[(int)t342];
    t344 = t343 - 1;
    t345 = t339 == t344;
    if (!(t345)) goto L28;
    t346 = P + 1;
    t347 = Stack[(int)t346];
    t348 = P + 4;
    t349 = t348 + 1;
    Stack[(int)t349] = t347;
    P = P + 4;
    eliminarFinal_();
    t350 = P + 0;
    t351 = Stack[(int)t350];
    P = P - 4;
    t352 = P + 0;
    Stack[(int)t352] = t351;
    return;
    goto L27;
L28:
    ;
L27:
    ;
    t353 = P + 1;
    t354 = Stack[(int)t353];
    t355 = P + 2;
    t356 = Stack[(int)t355];
    t357 = P + 4;
    t358 = t357 + 1;
    Stack[(int)t358] = t354;
    t359 = t357 + 2;
    Stack[(int)t359] = t356;
    P = P + 4;
    obtenerNodo_int();
    t360 = P + 0;
    t361 = Stack[(int)t360];
    P = P - 4;
    t362 = P + 3;
    Stack[(int)t362] = t361;
    t363 = P + 3;
    t364 = Stack[(int)t363];
    t365 = t364 + 2;
    t366 = Heap[(int)t365];
    t367 = t366 + 1;
    t368 = P + 3;
    t369 = Stack[(int)t368];
    t370 = t369 + 1;
    t371 = Heap[(int)t370];
    Heap[(int)t367] = t371;
    t372 = P + 3;
    t373 = Stack[(int)t372];
    t374 = t373 + 1;
    t375 = Heap[(int)t374];
    t376 = t375 + 2;
    t377 = P + 3;
    t378 = Stack[(int)t377];
    t379 = t378 + 2;
    t380 = Heap[(int)t379];
    Heap[(int)t376] = t380;
    t381 = P + 1;
    t382 = Stack[(int)t381];
    t383 = t382 + 2;
    t384 = Heap[(int)t383];
    t385 = t384 - 1;
    Heap[(int)t383] = t385;
    t386 = P + 0;
    Stack[(int)t386] = 1;
    return;
}

void eliminarValor_int() {
    double t387, t388, t389, t390, t391, t392, t393, t394, t395, t396, t397, t398, t399, t400, t401, t402, t403, t404, t405, t406, t407, t408, t409, t410, t411;
    t387 = P + 1;
    t388 = Stack[(int)t387];
    t389 = P + 2;
    t390 = Stack[(int)t389];
    t391 = P + 4;
    t392 = t391 + 1;
    Stack[(int)t392] = t388;
    t393 = t391 + 2;
    Stack[(int)t393] = t390;
    P = P + 4;
    buscar_int();
    t394 = P + 0;
    t395 = Stack[(int)t394];
    P = P - 4;
    t396 = P + 3;
    Stack[(int)t396] = t395;
    t397 = P + 3;
    t398 = Stack[(int)t397];
    t399 = -(1);
    t400 = t398 == t399;
    if (!(t400)) goto L30;
    t401 = P + 0;
    Stack[(int)t401] = 0;
    return;
    goto L29;
L30:
    ;
L29:
    ;
    t402 = P + 1;
    t403 = Stack[(int)t402];
    t404 = P + 3;
    t405 = Stack[(int)t404];
    t406 = P + 4;
    t407 = t406 + 1;
    Stack[(int)t407] = t403;
    t408 = t406 + 2;
    Stack[(int)t408] = t405;
    P = P + 4;
    eliminarEn_int();
    t409 = P + 0;
    t410 = Stack[(int)t409];
    P = P - 4;
    t411 = P + 0;
    Stack[(int)t411] = t410;
    return;
}

void vaciar_() {
    double t412, t413, t414, t415, t416, t417, t418, t419, t420;
    t412 = P + 1;
    t413 = Stack[(int)t412];
    t414 = t413 + 0;
    Heap[(int)t414] = 0;
    t415 = P + 1;
    t416 = Stack[(int)t415];
    t417 = t416 + 1;
    Heap[(int)t417] = 0;
    t418 = P + 1;
    t419 = Stack[(int)t418];
    t420 = t419 + 2;
    Heap[(int)t420] = 0;
}

void obtenerNodo_int() {
    double t421, t422, t423, t424, t425, t426, t427, t428, t429, t430, t431, t432, t433, t434, t435, t436, t437, t438, t439, t440, t441, t442, t443, t444, t445, t446, t447, t448, t449, t450, t451, t452, t453, t454, t455, t456, t457, t458, t459, t460, t461, t462, t463, t464, t465, t466, t467, t468, t469, t470, t471, t472, t473, t474, t475, t476, t477, t478, t479, t480, t481, t482, t483, t484, t485, t486, t487, t488, t489;
    t421 = P + 2;
    t422 = Stack[(int)t421];
    t423 = t422 < 0;
    if (!(t423)) goto L33;
    t424 = 1;
    goto L34;
L33:
    ;
    t425 = P + 2;
    t426 = Stack[(int)t425];
    t427 = P + 1;
    t428 = Stack[(int)t427];
    t429 = t428 + 2;
    t430 = Heap[(int)t429];
    t431 = t426 >= t430;
    t424 = t431;
L34:
    ;
    if (!(t424)) goto L32;
    t432 = P + 0;
    Stack[(int)t432] = 0;
    return;
    goto L31;
L32:
    ;
L31:
    ;
    t433 = P + 3;
    Stack[(int)t433] = 0;
    t434 = P + 2;
    t435 = Stack[(int)t434];
    t436 = P + 1;
    t437 = Stack[(int)t436];
    t438 = t437 + 2;
    t439 = Heap[(int)t438];
    t440 = t439 / 2;
    t441 = t435 < t440;
    if (!(t441)) goto L36;
    t442 = P + 1;
    t443 = Stack[(int)t442];
    t444 = t443 + 0;
    t445 = Heap[(int)t444];
    t446 = P + 3;
    Stack[(int)t446] = t445;
    t447 = P + 4;
    Stack[(int)t447] = 0;
L37:
    ;
    t448 = P + 4;
    t449 = Stack[(int)t448];
    t450 = P + 2;
    t451 = Stack[(int)t450];
    t452 = t449 < t451;
    if (!(t452)) goto L39;
    t453 = P + 3;
    t454 = Stack[(int)t453];
    t455 = t454 + 1;
    t456 = Heap[(int)t455];
    t457 = P + 3;
    Stack[(int)t457] = t456;
L38:
    ;
    t458 = P + 4;
    t459 = Stack[(int)t458];
    t460 = t459 + 1;
    t461 = P + 4;
    Stack[(int)t461] = t460;
    goto L37;
L39:
    ;
    goto L35;
L36:
    ;
    t462 = P + 1;
    t463 = Stack[(int)t462];
    t464 = t463 + 1;
    t465 = Heap[(int)t464];
    t466 = P + 3;
    Stack[(int)t466] = t465;
    t467 = P + 1;
    t468 = Stack[(int)t467];
    t469 = t468 + 2;
    t470 = Heap[(int)t469];
    t471 = t470 - 1;
    t472 = P + 5;
    Stack[(int)t472] = t471;
L40:
    ;
    t473 = P + 5;
    t474 = Stack[(int)t473];
    t475 = P + 2;
    t476 = Stack[(int)t475];
    t477 = t474 > t476;
    if (!(t477)) goto L42;
    t478 = P + 3;
    t479 = Stack[(int)t478];
    t480 = t479 + 2;
    t481 = Heap[(int)t480];
    t482 = P + 3;
    Stack[(int)t482] = t481;
L41:
    ;
    t483 = P + 5;
    t484 = Stack[(int)t483];
    t485 = t484 - 1;
    t486 = P + 5;
    Stack[(int)t486] = t485;
    goto L40;
L42:
    ;
L35:
    ;
    t487 = P + 3;
    t488 = Stack[(int)t487];
    t489 = P + 0;
    Stack[(int)t489] = t488;
    return;
}

void obtener_int() {
    double t490, t491, t492, t493, t494, t495, t496, t497, t498, t499, t500, t501, t502, t504, t503, t505, t506, t507, t508, t509;
    t490 = P + 1;
    t491 = Stack[(int)t490];
    t492 = P + 2;
    t493 = Stack[(int)t492];
    t494 = P + 4;
    t495 = t494 + 1;
    Stack[(int)t495] = t491;
    t496 = t494 + 2;
    Stack[(int)t496] = t493;
    P = P + 4;
    obtenerNodo_int();
    t497 = P + 0;
    t498 = Stack[(int)t497];
    P = P - 4;
    t499 = P + 3;
    Stack[(int)t499] = t498;
    t500 = P + 3;
    t501 = Stack[(int)t500];
    t502 = t501 == 0;
    if (!(t502)) goto L43;
    t504 = -(1);
    t503 = t504;
    goto L44;
L43:
    ;
    t505 = P + 3;
    t506 = Stack[(int)t505];
    t507 = t506 + 0;
    t508 = Heap[(int)t507];
    t503 = t508;
L44:
    ;
    t509 = P + 0;
    Stack[(int)t509] = t503;
    return;
}

void buscar_int() {
    double t510, t511, t512, t513, t514, t515, t516, t517, t518, t519, t520, t521, t522, t523, t524, t525, t526, t527, t528, t529, t530, t531, t532, t533, t534, t535, t536, t537, t538, t539;
    t510 = P + 1;
    t511 = Stack[(int)t510];
    t512 = t511 + 0;
    t513 = Heap[(int)t512];
    t514 = P + 3;
    Stack[(int)t514] = t513;
    t515 = P + 4;
    Stack[(int)t515] = 0;
L45:
    ;
    t516 = P + 3;
    t517 = Stack[(int)t516];
    t518 = t517 != 0;
    if (!(t518)) goto L46;
    t519 = P + 3;
    t520 = Stack[(int)t519];
    t521 = t520 + 0;
    t522 = Heap[(int)t521];
    t523 = P + 2;
    t524 = Stack[(int)t523];
    t525 = t522 == t524;
    if (!(t525)) goto L48;
    t526 = P + 4;
    t527 = Stack[(int)t526];
    t528 = P + 0;
    Stack[(int)t528] = t527;
    return;
    goto L47;
L48:
    ;
L47:
    ;
    t529 = P + 3;
    t530 = Stack[(int)t529];
    t531 = t530 + 1;
    t532 = Heap[(int)t531];
    t533 = P + 3;
    Stack[(int)t533] = t532;
    t534 = P + 4;
    t535 = Stack[(int)t534];
    t536 = t535 + 1;
    t537 = P + 4;
    Stack[(int)t537] = t536;
    goto L45;
L46:
    ;
    t538 = -(1);
    t539 = P + 0;
    Stack[(int)t539] = t538;
    return;
}

void maximo_() {
    double t540, t541, t542, t543, t544, t545, t546, t547, t548, t549, t550, t551, t552, t553, t554, t555, t556, t557, t558, t559, t560, t561, t562, t563, t564, t565, t566, t567, t568, t569, t570, t571, t572, t573, t574, t575, t576, t577, t578, t579, t580, t581, t582;
    t540 = P + 1;
    t541 = Stack[(int)t540];
    t542 = t541 + 0;
    t543 = Heap[(int)t542];
    t544 = t543 == 0;
    if (!(t544)) goto L50;
    t545 = P + 0;
    Stack[(int)t545] = 0;
    return;
    goto L49;
L50:
    ;
L49:
    ;
    t546 = P + 1;
    t547 = Stack[(int)t546];
    t548 = t547 + 0;
    t549 = Heap[(int)t548];
    t550 = t549 + 0;
    t551 = Heap[(int)t550];
    t552 = P + 2;
    Stack[(int)t552] = t551;
    t553 = P + 1;
    t554 = Stack[(int)t553];
    t555 = t554 + 0;
    t556 = Heap[(int)t555];
    t557 = t556 + 1;
    t558 = Heap[(int)t557];
    t559 = P + 3;
    Stack[(int)t559] = t558;
L51:
    ;
    t560 = P + 3;
    t561 = Stack[(int)t560];
    t562 = t561 != 0;
    if (!(t562)) goto L52;
    t563 = P + 3;
    t564 = Stack[(int)t563];
    t565 = t564 + 0;
    t566 = Heap[(int)t565];
    t567 = P + 2;
    t568 = Stack[(int)t567];
    t569 = t566 > t568;
    if (!(t569)) goto L54;
    t570 = P + 3;
    t571 = Stack[(int)t570];
    t572 = t571 + 0;
    t573 = Heap[(int)t572];
    t574 = P + 2;
    Stack[(int)t574] = t573;
    goto L53;
L54:
    ;
L53:
    ;
    t575 = P + 3;
    t576 = Stack[(int)t575];
    t577 = t576 + 1;
    t578 = Heap[(int)t577];
    t579 = P + 3;
    Stack[(int)t579] = t578;
    goto L51;
L52:
    ;
    t580 = P + 2;
    t581 = Stack[(int)t580];
    t582 = P + 0;
    Stack[(int)t582] = t581;
    return;
}

void sumaRecursiva_Nodo() {
    double t583, t584, t585, t586, t587, t588, t589, t590, t591, t592, t593, t594, t595, t596, t597, t598, t599, t600, t601, t602, t603;
    t583 = P + 2;
    t584 = Stack[(int)t583];
    t585 = t584 == 0;
    if (!(t585)) goto L56;
    t586 = P + 0;
    Stack[(int)t586] = 0;
    return;
    goto L55;
L56:
    ;
L55:
    ;
    t587 = P + 2;
    t588 = Stack[(int)t587];
    t589 = t588 + 0;
    t590 = Heap[(int)t589];
    t591 = P + 1;
    t592 = Stack[(int)t591];
    t593 = P + 2;
    t594 = Stack[(int)t593];
    t595 = t594 + 1;
    t596 = Heap[(int)t595];
    t597 = P + 3;
    t598 = t597 + 1;
    Stack[(int)t598] = t592;
    t599 = t597 + 2;
    Stack[(int)t599] = t596;
    P = P + 3;
    sumaRecursiva_Nodo();
    t600 = P + 0;
    t601 = Stack[(int)t600];
    P = P - 3;
    t602 = t590 + t601;
    t603 = P + 0;
    Stack[(int)t603] = t602;
    return;
}

void suma_() {
    double t604, t605, t606, t607, t608, t609, t610, t611, t612, t613, t614, t615;
    t604 = P + 1;
    t605 = Stack[(int)t604];
    t606 = P + 1;
    t607 = Stack[(int)t606];
    t608 = t607 + 0;
    t609 = Heap[(int)t608];
    t610 = P + 2;
    t611 = t610 + 1;
    Stack[(int)t611] = t605;
    t612 = t610 + 2;
    Stack[(int)t612] = t609;
    P = P + 2;
    sumaRecursiva_Nodo();
    t613 = P + 0;
    t614 = Stack[(int)t613];
    P = P - 2;
    t615 = P + 0;
    Stack[(int)t615] = t614;
    return;
}

void invertir_() {
    double t616, t617, t618, t619, t620, t621, t622, t623, t624, t625, t626, t627, t628, t629, t630, t631, t632, t633, t634, t635, t636, t637, t638, t639, t640, t641, t642, t643, t644, t645, t646, t647, t648, t649, t650, t651, t652, t653, t654, t655, t656, t657, t658, t659, t660, t661, t662, t663;
    t616 = P + 1;
    t617 = Stack[(int)t616];
    t618 = t617 + 0;
    t619 = Heap[(int)t618];
    t620 = P + 2;
    Stack[(int)t620] = t619;
    t621 = P + 3;
    Stack[(int)t621] = 0;
L57:
    ;
    t622 = P + 2;
    t623 = Stack[(int)t622];
    t624 = t623 != 0;
    if (!(t624)) goto L58;
    t625 = P + 2;
    t626 = Stack[(int)t625];
    t627 = t626 + 2;
    t628 = Heap[(int)t627];
    t629 = P + 3;
    Stack[(int)t629] = t628;
    t630 = P + 2;
    t631 = Stack[(int)t630];
    t632 = t631 + 2;
    t633 = P + 2;
    t634 = Stack[(int)t633];
    t635 = t634 + 1;
    t636 = Heap[(int)t635];
    Heap[(int)t632] = t636;
    t637 = P + 2;
    t638 = Stack[(int)t637];
    t639 = t638 + 1;
    t640 = P + 3;
    t641 = Stack[(int)t640];
    Heap[(int)t639] = t641;
    t642 = P + 2;
    t643 = Stack[(int)t642];
    t644 = t643 + 2;
    t645 = Heap[(int)t644];
    t646 = P + 2;
    Stack[(int)t646] = t645;
    goto L57;
L58:
    ;
    t647 = P + 1;
    t648 = Stack[(int)t647];
    t649 = t648 + 0;
    t650 = Heap[(int)t649];
    t651 = P + 3;
    Stack[(int)t651] = t650;
    t652 = P + 1;
    t653 = Stack[(int)t652];
    t654 = t653 + 1;
    t655 = Heap[(int)t654];
    t656 = P + 1;
    t657 = Stack[(int)t656];
    t658 = t657 + 0;
    Heap[(int)t658] = t655;
    t659 = P + 3;
    t660 = Stack[(int)t659];
    t661 = P + 1;
    t662 = Stack[(int)t661];
    t663 = t662 + 1;
    Heap[(int)t663] = t660;
}

void ordenar_() {
    double t664, t665, t666, t667, t668, t669, t670, t671, t672, t674, t675, t676, t677, t678, t673, t679, t680, t681, t682, t683, t684, t685, t686, t687, t688, t689, t690, t691, t692, t693, t694, t695, t696, t697, t698, t699, t700, t701, t702, t703, t704, t705, t706, t707, t708, t709, t710, t711, t712, t713, t714, t715, t716, t717, t718;
L59:
    ;
    t664 = P + 2;
    Stack[(int)t664] = 0;
    t665 = P + 1;
    t666 = Stack[(int)t665];
    t667 = t666 + 0;
    t668 = Heap[(int)t667];
    t669 = P + 3;
    Stack[(int)t669] = t668;
L62:
    ;
    t670 = P + 3;
    t671 = Stack[(int)t670];
    t672 = t671 != 0;
    if (!(t672)) goto L64;
    t674 = P + 3;
    t675 = Stack[(int)t674];
    t676 = t675 + 1;
    t677 = Heap[(int)t676];
    t678 = t677 != 0;
    t673 = t678;
    goto L65;
L64:
    ;
    t673 = 0;
L65:
    ;
    if (!(t673)) goto L63;
    t679 = P + 3;
    t680 = Stack[(int)t679];
    t681 = t680 + 0;
    t682 = Heap[(int)t681];
    t683 = P + 3;
    t684 = Stack[(int)t683];
    t685 = t684 + 1;
    t686 = Heap[(int)t685];
    t687 = t686 + 0;
    t688 = Heap[(int)t687];
    t689 = t682 > t688;
    if (!(t689)) goto L67;
    t690 = P + 3;
    t691 = Stack[(int)t690];
    t692 = t691 + 0;
    t693 = Heap[(int)t692];
    t694 = P + 4;
    Stack[(int)t694] = t693;
    t695 = P + 3;
    t696 = Stack[(int)t695];
    t697 = t696 + 0;
    t698 = P + 3;
    t699 = Stack[(int)t698];
    t700 = t699 + 1;
    t701 = Heap[(int)t700];
    t702 = t701 + 0;
    t703 = Heap[(int)t702];
    Heap[(int)t697] = t703;
    t704 = P + 3;
    t705 = Stack[(int)t704];
    t706 = t705 + 1;
    t707 = Heap[(int)t706];
    t708 = t707 + 0;
    t709 = P + 4;
    t710 = Stack[(int)t709];
    Heap[(int)t708] = t710;
    t711 = P + 2;
    Stack[(int)t711] = 1;
    goto L66;
L67:
    ;
L66:
    ;
    t712 = P + 3;
    t713 = Stack[(int)t712];
    t714 = t713 + 1;
    t715 = Heap[(int)t714];
    t716 = P + 3;
    Stack[(int)t716] = t715;
    goto L62;
L63:
    ;
L60:
    ;
    t717 = P + 2;
    t718 = Stack[(int)t717];
    if (!(t718)) goto L61;
    goto L59;
L61:
    ;
}

void imprimirAdelante_() {
    double t719, t720, t721, t722, t723, t724, t725, t726, t727, t728, t729, t730, t731, t732, t733, t734, t735, t736, t737, t738, t739, t740, t741, t742, t743, t744, t745, t746, t747, t748, t749, t750, t751, t752, t753, t754, t755, t756, t757, t758, t759, t760, t761, t762, t763, t764, t765, t766, t767, t768, t769, t770, t771, t772, t773, t774, t775, t776, t777;
    t719 = H;
    Heap[(int)H] = 91;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t720 = P + 2;
    Stack[(int)t720] = t719;
    t721 = P + 1;
    t722 = Stack[(int)t721];
    t723 = t722 + 0;
    t724 = Heap[(int)t723];
    t725 = P + 3;
    Stack[(int)t725] = t724;
L68:
    ;
    t726 = P + 3;
    t727 = Stack[(int)t726];
    t728 = t727 != 0;
    if (!(t728)) goto L69;
    t729 = P + 2;
    t730 = Stack[(int)t729];
    t731 = P + 3;
    t732 = Stack[(int)t731];
    t733 = t732 + 0;
    t734 = Heap[(int)t733];
    {
        char __buffer[128];
        snprintf(__buffer, sizeof(__buffer), "%d", (int)(t734));
        t735 = H;
        for (int __i = 0; __buffer[__i] != '\0'; __i++) {
            Heap[(int)H] = (double)__buffer[__i];
            H = H + 1;
        }
        Heap[(int)H] = -1;
        H = H + 1;
    }
    t736 = H;
    t737 = t730;
L70:
    ;
    t738 = Heap[(int)t737];
    t739 = t738 != -1;
    if (!(t739)) goto L71;
    Heap[(int)H] = t738;
    H = H + 1;
    t737 = t737 + 1;
    goto L70;
L71:
    ;
    t740 = t735;
L72:
    ;
    t741 = Heap[(int)t740];
    t742 = t741 != -1;
    if (!(t742)) goto L73;
    Heap[(int)H] = t741;
    H = H + 1;
    t740 = t740 + 1;
    goto L72;
L73:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    t743 = P + 2;
    Stack[(int)t743] = t736;
    t744 = P + 3;
    t745 = Stack[(int)t744];
    t746 = t745 + 1;
    t747 = Heap[(int)t746];
    t748 = t747 != 0;
    if (!(t748)) goto L75;
    t749 = P + 2;
    t750 = Stack[(int)t749];
    t751 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 60;
    H = H + 1;
    Heap[(int)H] = 45;
    H = H + 1;
    Heap[(int)H] = 62;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t752 = H;
    t753 = t750;
L76:
    ;
    t754 = Heap[(int)t753];
    t755 = t754 != -1;
    if (!(t755)) goto L77;
    Heap[(int)H] = t754;
    H = H + 1;
    t753 = t753 + 1;
    goto L76;
L77:
    ;
    t756 = t751;
L78:
    ;
    t757 = Heap[(int)t756];
    t758 = t757 != -1;
    if (!(t758)) goto L79;
    Heap[(int)H] = t757;
    H = H + 1;
    t756 = t756 + 1;
    goto L78;
L79:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    t759 = P + 2;
    Stack[(int)t759] = t752;
    goto L74;
L75:
    ;
L74:
    ;
    t760 = P + 3;
    t761 = Stack[(int)t760];
    t762 = t761 + 1;
    t763 = Heap[(int)t762];
    t764 = P + 3;
    Stack[(int)t764] = t763;
    goto L68;
L69:
    ;
    t765 = P + 2;
    t766 = Stack[(int)t765];
    t767 = H;
    Heap[(int)H] = 93;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t768 = H;
    t769 = t766;
L80:
    ;
    t770 = Heap[(int)t769];
    t771 = t770 != -1;
    if (!(t771)) goto L81;
    Heap[(int)H] = t770;
    H = H + 1;
    t769 = t769 + 1;
    goto L80;
L81:
    ;
    t772 = t767;
L82:
    ;
    t773 = Heap[(int)t772];
    t774 = t773 != -1;
    if (!(t774)) goto L83;
    Heap[(int)H] = t773;
    H = H + 1;
    t772 = t772 + 1;
    goto L82;
L83:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    t775 = P + 2;
    Stack[(int)t775] = t768;
    t776 = P + 2;
    t777 = Stack[(int)t776];
    {
        int __pos = (int)(t777);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
}

void imprimirAtras_() {
    double t778, t779, t780, t781, t782, t783, t784, t785, t786, t787, t788, t789, t790, t791, t792, t793, t794, t795, t796, t797, t798, t799, t800, t801, t802, t803, t804, t805, t806, t807, t808, t809, t810, t811, t812, t813, t814, t815, t816, t817, t818, t819, t820, t821, t822, t823, t824, t825, t826, t827, t828, t829, t830, t831, t832, t833, t834, t835, t836;
    t778 = H;
    Heap[(int)H] = 91;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t779 = P + 2;
    Stack[(int)t779] = t778;
    t780 = P + 1;
    t781 = Stack[(int)t780];
    t782 = t781 + 1;
    t783 = Heap[(int)t782];
    t784 = P + 3;
    Stack[(int)t784] = t783;
L84:
    ;
    t785 = P + 3;
    t786 = Stack[(int)t785];
    t787 = t786 != 0;
    if (!(t787)) goto L85;
    t788 = P + 2;
    t789 = Stack[(int)t788];
    t790 = P + 3;
    t791 = Stack[(int)t790];
    t792 = t791 + 0;
    t793 = Heap[(int)t792];
    {
        char __buffer[128];
        snprintf(__buffer, sizeof(__buffer), "%d", (int)(t793));
        t794 = H;
        for (int __i = 0; __buffer[__i] != '\0'; __i++) {
            Heap[(int)H] = (double)__buffer[__i];
            H = H + 1;
        }
        Heap[(int)H] = -1;
        H = H + 1;
    }
    t795 = H;
    t796 = t789;
L86:
    ;
    t797 = Heap[(int)t796];
    t798 = t797 != -1;
    if (!(t798)) goto L87;
    Heap[(int)H] = t797;
    H = H + 1;
    t796 = t796 + 1;
    goto L86;
L87:
    ;
    t799 = t794;
L88:
    ;
    t800 = Heap[(int)t799];
    t801 = t800 != -1;
    if (!(t801)) goto L89;
    Heap[(int)H] = t800;
    H = H + 1;
    t799 = t799 + 1;
    goto L88;
L89:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    t802 = P + 2;
    Stack[(int)t802] = t795;
    t803 = P + 3;
    t804 = Stack[(int)t803];
    t805 = t804 + 2;
    t806 = Heap[(int)t805];
    t807 = t806 != 0;
    if (!(t807)) goto L91;
    t808 = P + 2;
    t809 = Stack[(int)t808];
    t810 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 60;
    H = H + 1;
    Heap[(int)H] = 45;
    H = H + 1;
    Heap[(int)H] = 62;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t811 = H;
    t812 = t809;
L92:
    ;
    t813 = Heap[(int)t812];
    t814 = t813 != -1;
    if (!(t814)) goto L93;
    Heap[(int)H] = t813;
    H = H + 1;
    t812 = t812 + 1;
    goto L92;
L93:
    ;
    t815 = t810;
L94:
    ;
    t816 = Heap[(int)t815];
    t817 = t816 != -1;
    if (!(t817)) goto L95;
    Heap[(int)H] = t816;
    H = H + 1;
    t815 = t815 + 1;
    goto L94;
L95:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    t818 = P + 2;
    Stack[(int)t818] = t811;
    goto L90;
L91:
    ;
L90:
    ;
    t819 = P + 3;
    t820 = Stack[(int)t819];
    t821 = t820 + 2;
    t822 = Heap[(int)t821];
    t823 = P + 3;
    Stack[(int)t823] = t822;
    goto L84;
L85:
    ;
    t824 = P + 2;
    t825 = Stack[(int)t824];
    t826 = H;
    Heap[(int)H] = 93;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t827 = H;
    t828 = t825;
L96:
    ;
    t829 = Heap[(int)t828];
    t830 = t829 != -1;
    if (!(t830)) goto L97;
    Heap[(int)H] = t829;
    H = H + 1;
    t828 = t828 + 1;
    goto L96;
L97:
    ;
    t831 = t826;
L98:
    ;
    t832 = Heap[(int)t831];
    t833 = t832 != -1;
    if (!(t833)) goto L99;
    Heap[(int)H] = t832;
    H = H + 1;
    t831 = t831 + 1;
    goto L98;
L99:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    t834 = P + 2;
    Stack[(int)t834] = t827;
    t835 = P + 2;
    t836 = Stack[(int)t835];
    {
        int __pos = (int)(t836);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
}

void main_pig() {
    double t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18, t19, t20, t21, t22, t23, t24, t25, t26, t27, t28, t29, t30, t31, t32, t33, t34, t35, t36, t37, t38, t39, t40, t41, t42, t43, t44, t45, t46, t47, t48, t49, t50, t51, t52, t53, t54, t55, t56, t57, t58, t59, t60, t61, t62, t63, t64, t65, t66, t67, t68, t69, t70, t71, t72, t73, t74, t75, t76, t77, t78, t79, t80, t81, t82, t83, t84, t85, t86, t87, t88, t89, t90, t91, t92, t93, t94, t95, t96, t97, t98, t99, t100, t101, t102, t103, t104, t105, t106, t107, t108, t109, t110, t111, t112, t113, t114, t115, t116, t117, t118, t119, t120, t121, t122, t123, t124, t125, t126, t127, t128, t129, t130, t131, t132, t133, t134, t135, t136, t137, t138, t139, t140, t141, t142, t143, t144, t145, t146, t147, t148, t149, t150, t151, t152, t153, t154, t155, t156, t157, t158, t159, t160, t161, t162, t163, t164, t165, t166, t167, t168, t169, t170, t171, t172, t173, t174, t175, t176, t177, t178, t179, t180, t181, t182, t183, t184, t185, t186, t187, t188, t189, t190, t191, t192, t193, t194, t195, t196, t197, t198, t199, t200, t201, t202, t203, t204, t205, t206, t207, t208, t209, t210, t211, t212, t213, t214, t215, t216, t217, t218, t219, t220, t221, t222, t223, t224, t225, t226, t227, t228, t229, t230, t231, t232, t233, t234, t235, t236, t237, t238, t239, t240, t241, t242, t243, t244, t245, t246, t247, t248, t249, t250, t251, t252, t253, t254, t255, t256, t257, t258, t259, t260, t261, t262, t263, t264, t265, t266, t267, t268, t269, t270, t271, t272, t273, t274, t275, t276, t277, t278, t279, t280, t281, t282, t283, t284, t285, t286, t287, t288, t289, t290, t291, t292, t293, t294, t295, t296, t297, t298, t299, t300, t301, t302, t303, t304, t305, t306, t307, t308, t309, t310, t311, t312, t313, t314, t315, t316, t317, t318, t319, t320, t321, t322, t323, t324, t325, t326, t327, t328, t329, t330, t331, t332, t333, t334, t335, t336, t337, t338, t339, t340, t341, t342, t343, t344, t345, t346, t347, t348, t349, t350, t351, t352, t353, t354, t355, t356, t357, t358, t359, t360, t361, t362, t363, t364, t365, t366, t367, t368, t369, t370, t371, t372, t373, t374, t375, t376, t377, t378, t379, t380, t381, t382, t383, t384, t385, t386, t387, t388, t389, t390, t391, t392, t393, t394, t395, t396, t397, t398, t399, t400, t401, t402, t403, t404, t405, t406, t407, t408, t409;
    t1 = P + 0;
    Stack[(int)t1] = 0;
    t2 = P + 1;
    Stack[(int)t2] = 0;
    t3 = P + 2;
    Stack[(int)t3] = 0;
    t4 = P + 3;
    Stack[(int)t4] = 0;
    t5 = P + 4;
    Stack[(int)t5] = 0;
    t6 = H;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    t7 = P + 5;
    Stack[(int)t7] = t6;
    t8 = P + 10;
    t9 = t8 + 1;
    Stack[(int)t9] = t6;
    P = P + 10;
    ListaDoble_();
    P = P - 10;
    t10 = H;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    t11 = P + 6;
    Stack[(int)t11] = t10;
    t12 = P + 10;
    t13 = t12 + 1;
    Stack[(int)t13] = t10;
    t14 = t12 + 2;
    Stack[(int)t14] = 7;
    P = P + 10;
    ListaDoble_int();
    P = P - 10;
    t15 = H;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    t16 = P + 7;
    Stack[(int)t16] = t15;
    t17 = t15 + 0;
    Heap[(int)t17] = 0;
    t18 = t15 + 1;
    Heap[(int)t18] = 0;
    t19 = t15 + 2;
    Heap[(int)t19] = 0;
    t20 = t15 + 3;
    Heap[(int)t20] = 0;
    t21 = H;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 83;
    H = H + 1;
    Heap[(int)H] = 84;
    H = H + 1;
    Heap[(int)H] = 65;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 68;
    H = H + 1;
    Heap[(int)H] = 79;
    H = H + 1;
    Heap[(int)H] = 66;
    H = H + 1;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 77;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 78;
    H = H + 1;
    Heap[(int)H] = 84;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 78;
    H = H + 1;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 65;
    H = H + 1;
    Heap[(int)H] = 90;
    H = H + 1;
    Heap[(int)H] = 65;
    H = H + 1;
    Heap[(int)H] = 68;
    H = H + 1;
    Heap[(int)H] = 65;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t21);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t22 = P + 8;
    Stack[(int)t22] = 1;
L1:
    ;
    t23 = P + 8;
    t24 = Stack[(int)t23];
    t25 = t24 < 6;
    if (!(t25)) goto L3;
    t26 = P + 5;
    t27 = Stack[(int)t26];
    t28 = P + 5;
    t29 = Stack[(int)t28];
    t30 = P + 8;
    t31 = Stack[(int)t30];
    t32 = t31 * 10;
    t33 = P + 10;
    t34 = t33 + 1;
    Stack[(int)t34] = t29;
    t35 = t33 + 2;
    Stack[(int)t35] = t32;
    P = P + 10;
    insertarFinal_int();
    P = P - 10;
L2:
    ;
    t36 = P + 8;
    t37 = Stack[(int)t36];
    t38 = t37 + 1;
    Stack[(int)t36] = t38;
    goto L1;
L3:
    ;
    t39 = P + 6;
    t40 = Stack[(int)t39];
    t41 = P + 6;
    t42 = Stack[(int)t41];
    t43 = P + 10;
    t44 = t43 + 1;
    Stack[(int)t44] = t42;
    t45 = t43 + 2;
    Stack[(int)t45] = 8;
    t46 = t43 + 3;
    Stack[(int)t46] = 9;
    P = P + 10;
    insertarFinal_int_int();
    P = P - 10;
    t47 = H;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 40;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 41;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t47);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t48 = P + 5;
    t49 = Stack[(int)t48];
    t50 = P + 5;
    t51 = Stack[(int)t50];
    t52 = P + 10;
    t53 = t52 + 1;
    Stack[(int)t53] = t51;
    P = P + 10;
    imprimirAdelante_();
    P = P - 10;
    t54 = H;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 40;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 41;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t54);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t55 = P + 5;
    t56 = Stack[(int)t55];
    t57 = P + 5;
    t58 = Stack[(int)t57];
    t59 = P + 10;
    t60 = t59 + 1;
    Stack[(int)t60] = t58;
    P = P + 10;
    imprimirAtras_();
    P = P - 10;
    t61 = H;
    Heap[(int)H] = 79;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t61);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t62 = P + 6;
    t63 = Stack[(int)t62];
    t64 = P + 6;
    t65 = Stack[(int)t64];
    t66 = P + 10;
    t67 = t66 + 1;
    Stack[(int)t67] = t65;
    P = P + 10;
    imprimirAdelante_();
    P = P - 10;
L4:
    ;
    t68 = H;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t68);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t69 = H;
    Heap[(int)H] = 49;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 50;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 102;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 51;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t69);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t70 = H;
    Heap[(int)H] = 52;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 53;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 102;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 54;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t70);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t71 = H;
    Heap[(int)H] = 55;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 56;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 66;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 57;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t71);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t72 = H;
    Heap[(int)H] = 49;
    H = H + 1;
    Heap[(int)H] = 48;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 79;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 49;
    H = H + 1;
    Heap[(int)H] = 49;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 49;
    H = H + 1;
    Heap[(int)H] = 50;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t72);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t73 = H;
    Heap[(int)H] = 49;
    H = H + 1;
    Heap[(int)H] = 51;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 86;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 48;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 83;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t73);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t74 = 0;
                break;
            }
            __longitud = strcspn(__buffer, "\r\n");
            if (__buffer[__longitud] == '\0'
                    && __longitud == sizeof(__buffer) - 1) {
                while ((__c = getchar()) != '\n' && __c != EOF) { }
            }
            __buffer[__longitud] = '\0';
            char *__fin = NULL;
            errno = 0;
            long __valor = strtol(__buffer, &__fin, 10);
            int __huboDigitos = __fin != __buffer;
            while (__fin != NULL && isspace((unsigned char)*__fin)) __fin++;
            if (__huboDigitos && __fin != NULL && *__fin == '\0'
                    && errno != ERANGE && __valor >= INT_MIN && __valor <= INT_MAX) {
                t74 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t75 = P + 0;
    Stack[(int)t75] = t74;
    t76 = P + 0;
    t77 = Stack[(int)t76];
    t78 = t77 == 1;
    if (!(t78)) goto L7;
    t79 = H;
    Heap[(int)H] = 86;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t79);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t80 = 0;
                break;
            }
            __longitud = strcspn(__buffer, "\r\n");
            if (__buffer[__longitud] == '\0'
                    && __longitud == sizeof(__buffer) - 1) {
                while ((__c = getchar()) != '\n' && __c != EOF) { }
            }
            __buffer[__longitud] = '\0';
            char *__fin = NULL;
            errno = 0;
            long __valor = strtol(__buffer, &__fin, 10);
            int __huboDigitos = __fin != __buffer;
            while (__fin != NULL && isspace((unsigned char)*__fin)) __fin++;
            if (__huboDigitos && __fin != NULL && *__fin == '\0'
                    && errno != ERANGE && __valor >= INT_MIN && __valor <= INT_MAX) {
                t80 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t81 = P + 1;
    Stack[(int)t81] = t80;
    t82 = P + 5;
    t83 = Stack[(int)t82];
    t84 = P + 5;
    t85 = Stack[(int)t84];
    t86 = P + 1;
    t87 = Stack[(int)t86];
    t88 = P + 10;
    t89 = t88 + 1;
    Stack[(int)t89] = t85;
    t90 = t88 + 2;
    Stack[(int)t90] = t87;
    P = P + 10;
    insertarInicio_int();
    P = P - 10;
    t91 = P + 7;
    t92 = Stack[(int)t91];
    t93 = P + 10;
    t94 = t93 + 1;
    Stack[(int)t94] = t92;
    t95 = t93 + 2;
    Stack[(int)t95] = 1;
    P = P + 10;
    registrar();
    P = P - 10;
    goto L8;
L7:
    ;
    t96 = P + 0;
    t97 = Stack[(int)t96];
    t98 = t97 == 2;
    if (!(t98)) goto L9;
    t99 = H;
    Heap[(int)H] = 86;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t99);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t100 = 0;
                break;
            }
            __longitud = strcspn(__buffer, "\r\n");
            if (__buffer[__longitud] == '\0'
                    && __longitud == sizeof(__buffer) - 1) {
                while ((__c = getchar()) != '\n' && __c != EOF) { }
            }
            __buffer[__longitud] = '\0';
            char *__fin = NULL;
            errno = 0;
            long __valor = strtol(__buffer, &__fin, 10);
            int __huboDigitos = __fin != __buffer;
            while (__fin != NULL && isspace((unsigned char)*__fin)) __fin++;
            if (__huboDigitos && __fin != NULL && *__fin == '\0'
                    && errno != ERANGE && __valor >= INT_MIN && __valor <= INT_MAX) {
                t100 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t101 = P + 1;
    Stack[(int)t101] = t100;
    t102 = P + 5;
    t103 = Stack[(int)t102];
    t104 = P + 5;
    t105 = Stack[(int)t104];
    t106 = P + 1;
    t107 = Stack[(int)t106];
    t108 = P + 10;
    t109 = t108 + 1;
    Stack[(int)t109] = t105;
    t110 = t108 + 2;
    Stack[(int)t110] = t107;
    P = P + 10;
    insertarFinal_int();
    P = P - 10;
    t111 = P + 7;
    t112 = Stack[(int)t111];
    t113 = P + 10;
    t114 = t113 + 1;
    Stack[(int)t114] = t112;
    t115 = t113 + 2;
    Stack[(int)t115] = 1;
    P = P + 10;
    registrar();
    P = P - 10;
    goto L10;
L9:
    ;
    t116 = P + 0;
    t117 = Stack[(int)t116];
    t118 = t117 == 3;
    if (!(t118)) goto L11;
    t119 = H;
    Heap[(int)H] = 80;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t119);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t120 = 0;
                break;
            }
            __longitud = strcspn(__buffer, "\r\n");
            if (__buffer[__longitud] == '\0'
                    && __longitud == sizeof(__buffer) - 1) {
                while ((__c = getchar()) != '\n' && __c != EOF) { }
            }
            __buffer[__longitud] = '\0';
            char *__fin = NULL;
            errno = 0;
            long __valor = strtol(__buffer, &__fin, 10);
            int __huboDigitos = __fin != __buffer;
            while (__fin != NULL && isspace((unsigned char)*__fin)) __fin++;
            if (__huboDigitos && __fin != NULL && *__fin == '\0'
                    && errno != ERANGE && __valor >= INT_MIN && __valor <= INT_MAX) {
                t120 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t121 = P + 2;
    Stack[(int)t121] = t120;
    t122 = H;
    Heap[(int)H] = 86;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t122);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t123 = 0;
                break;
            }
            __longitud = strcspn(__buffer, "\r\n");
            if (__buffer[__longitud] == '\0'
                    && __longitud == sizeof(__buffer) - 1) {
                while ((__c = getchar()) != '\n' && __c != EOF) { }
            }
            __buffer[__longitud] = '\0';
            char *__fin = NULL;
            errno = 0;
            long __valor = strtol(__buffer, &__fin, 10);
            int __huboDigitos = __fin != __buffer;
            while (__fin != NULL && isspace((unsigned char)*__fin)) __fin++;
            if (__huboDigitos && __fin != NULL && *__fin == '\0'
                    && errno != ERANGE && __valor >= INT_MIN && __valor <= INT_MAX) {
                t123 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t124 = P + 1;
    Stack[(int)t124] = t123;
    t125 = P + 5;
    t126 = Stack[(int)t125];
    t127 = P + 5;
    t128 = Stack[(int)t127];
    t129 = P + 2;
    t130 = Stack[(int)t129];
    t131 = P + 1;
    t132 = Stack[(int)t131];
    t133 = P + 10;
    t134 = t133 + 1;
    Stack[(int)t134] = t128;
    t135 = t133 + 2;
    Stack[(int)t135] = t130;
    t136 = t133 + 3;
    Stack[(int)t136] = t132;
    P = P + 10;
    insertarEn_int_int();
    t137 = P + 0;
    t138 = Stack[(int)t137];
    P = P - 10;
    t139 = P + 4;
    Stack[(int)t139] = t138;
    t140 = P + 4;
    t141 = Stack[(int)t140];
    t142 = t141 == 1;
    if (!(t142)) goto L13;
    t143 = H;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t143);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t144 = P + 2;
    t145 = Stack[(int)t144];
    printf("%g\n", (double)(t145));
    t146 = P + 7;
    t147 = Stack[(int)t146];
    t148 = P + 10;
    t149 = t148 + 1;
    Stack[(int)t149] = t147;
    t150 = t148 + 2;
    Stack[(int)t150] = 1;
    P = P + 10;
    registrar();
    P = P - 10;
    goto L14;
L13:
    ;
    t151 = H;
    Heap[(int)H] = 80;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t151);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
L14:
    ;
    goto L12;
L11:
    ;
    t152 = P + 0;
    t153 = Stack[(int)t152];
    t154 = t153 == 4;
    if (!(t154)) goto L15;
    t155 = P + 5;
    t156 = Stack[(int)t155];
    t157 = P + 5;
    t158 = Stack[(int)t157];
    t159 = P + 10;
    t160 = t159 + 1;
    Stack[(int)t160] = t158;
    P = P + 10;
    eliminarInicio_();
    t161 = P + 0;
    t162 = Stack[(int)t161];
    P = P - 10;
    if (!(t162)) goto L17;
    t163 = H;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t163);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t164 = P + 7;
    t165 = Stack[(int)t164];
    t166 = P + 10;
    t167 = t166 + 1;
    Stack[(int)t167] = t165;
    t168 = t166 + 2;
    Stack[(int)t168] = 2;
    P = P + 10;
    registrar();
    P = P - 10;
    goto L18;
L17:
    ;
    t169 = H;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t169);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
L18:
    ;
    goto L16;
L15:
    ;
    t170 = P + 0;
    t171 = Stack[(int)t170];
    t172 = t171 == 5;
    if (!(t172)) goto L19;
    t173 = P + 5;
    t174 = Stack[(int)t173];
    t175 = P + 5;
    t176 = Stack[(int)t175];
    t177 = P + 10;
    t178 = t177 + 1;
    Stack[(int)t178] = t176;
    P = P + 10;
    eliminarFinal_();
    t179 = P + 0;
    t180 = Stack[(int)t179];
    P = P - 10;
    if (!(t180)) goto L21;
    t181 = H;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 102;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t181);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t182 = P + 7;
    t183 = Stack[(int)t182];
    t184 = P + 10;
    t185 = t184 + 1;
    Stack[(int)t185] = t183;
    t186 = t184 + 2;
    Stack[(int)t186] = 2;
    P = P + 10;
    registrar();
    P = P - 10;
    goto L22;
L21:
    ;
    t187 = H;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t187);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
L22:
    ;
    goto L20;
L19:
    ;
    t188 = P + 0;
    t189 = Stack[(int)t188];
    t190 = t189 == 6;
    if (!(t190)) goto L23;
    t191 = H;
    Heap[(int)H] = 80;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t191);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t192 = 0;
                break;
            }
            __longitud = strcspn(__buffer, "\r\n");
            if (__buffer[__longitud] == '\0'
                    && __longitud == sizeof(__buffer) - 1) {
                while ((__c = getchar()) != '\n' && __c != EOF) { }
            }
            __buffer[__longitud] = '\0';
            char *__fin = NULL;
            errno = 0;
            long __valor = strtol(__buffer, &__fin, 10);
            int __huboDigitos = __fin != __buffer;
            while (__fin != NULL && isspace((unsigned char)*__fin)) __fin++;
            if (__huboDigitos && __fin != NULL && *__fin == '\0'
                    && errno != ERANGE && __valor >= INT_MIN && __valor <= INT_MAX) {
                t192 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t193 = P + 2;
    Stack[(int)t193] = t192;
    t194 = P + 5;
    t195 = Stack[(int)t194];
    t196 = P + 5;
    t197 = Stack[(int)t196];
    t198 = P + 2;
    t199 = Stack[(int)t198];
    t200 = P + 10;
    t201 = t200 + 1;
    Stack[(int)t201] = t197;
    t202 = t200 + 2;
    Stack[(int)t202] = t199;
    P = P + 10;
    eliminarEn_int();
    t203 = P + 0;
    t204 = Stack[(int)t203];
    P = P - 10;
    t205 = P + 4;
    Stack[(int)t205] = t204;
    t206 = P + 4;
    t207 = Stack[(int)t206];
    t208 = t207 == 1;
    if (!(t208)) goto L25;
    t209 = H;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t209);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t210 = P + 2;
    t211 = Stack[(int)t210];
    printf("%g\n", (double)(t211));
    t212 = P + 7;
    t213 = Stack[(int)t212];
    t214 = P + 10;
    t215 = t214 + 1;
    Stack[(int)t215] = t213;
    t216 = t214 + 2;
    Stack[(int)t216] = 2;
    P = P + 10;
    registrar();
    P = P - 10;
    goto L26;
L25:
    ;
    t217 = H;
    Heap[(int)H] = 80;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t217);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
L26:
    ;
    goto L24;
L23:
    ;
    t218 = P + 0;
    t219 = Stack[(int)t218];
    t220 = t219 == 7;
    if (!(t220)) goto L27;
    t221 = H;
    Heap[(int)H] = 86;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t221);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t222 = 0;
                break;
            }
            __longitud = strcspn(__buffer, "\r\n");
            if (__buffer[__longitud] == '\0'
                    && __longitud == sizeof(__buffer) - 1) {
                while ((__c = getchar()) != '\n' && __c != EOF) { }
            }
            __buffer[__longitud] = '\0';
            char *__fin = NULL;
            errno = 0;
            long __valor = strtol(__buffer, &__fin, 10);
            int __huboDigitos = __fin != __buffer;
            while (__fin != NULL && isspace((unsigned char)*__fin)) __fin++;
            if (__huboDigitos && __fin != NULL && *__fin == '\0'
                    && errno != ERANGE && __valor >= INT_MIN && __valor <= INT_MAX) {
                t222 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t223 = P + 1;
    Stack[(int)t223] = t222;
    t224 = P + 5;
    t225 = Stack[(int)t224];
    t226 = P + 5;
    t227 = Stack[(int)t226];
    t228 = P + 1;
    t229 = Stack[(int)t228];
    t230 = P + 10;
    t231 = t230 + 1;
    Stack[(int)t231] = t227;
    t232 = t230 + 2;
    Stack[(int)t232] = t229;
    P = P + 10;
    eliminarValor_int();
    t233 = P + 0;
    t234 = Stack[(int)t233];
    P = P - 10;
    t235 = P + 4;
    Stack[(int)t235] = t234;
    t236 = P + 4;
    t237 = Stack[(int)t236];
    t238 = t237 == 1;
    if (!(t238)) goto L29;
    t239 = H;
    Heap[(int)H] = 86;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t239);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t240 = P + 1;
    t241 = Stack[(int)t240];
    printf("%g\n", (double)(t241));
    t242 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t242);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t243 = P + 7;
    t244 = Stack[(int)t243];
    t245 = P + 10;
    t246 = t245 + 1;
    Stack[(int)t246] = t244;
    t247 = t245 + 2;
    Stack[(int)t247] = 2;
    P = P + 10;
    registrar();
    P = P - 10;
    goto L30;
L29:
    ;
    t248 = H;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 120;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t248);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
L30:
    ;
    goto L28;
L27:
    ;
    t249 = P + 0;
    t250 = Stack[(int)t249];
    t251 = t250 == 8;
    if (!(t251)) goto L31;
    t252 = H;
    Heap[(int)H] = 86;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 98;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t252);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t253 = 0;
                break;
            }
            __longitud = strcspn(__buffer, "\r\n");
            if (__buffer[__longitud] == '\0'
                    && __longitud == sizeof(__buffer) - 1) {
                while ((__c = getchar()) != '\n' && __c != EOF) { }
            }
            __buffer[__longitud] = '\0';
            char *__fin = NULL;
            errno = 0;
            long __valor = strtol(__buffer, &__fin, 10);
            int __huboDigitos = __fin != __buffer;
            while (__fin != NULL && isspace((unsigned char)*__fin)) __fin++;
            if (__huboDigitos && __fin != NULL && *__fin == '\0'
                    && errno != ERANGE && __valor >= INT_MIN && __valor <= INT_MAX) {
                t253 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t254 = P + 1;
    Stack[(int)t254] = t253;
    t255 = P + 5;
    t256 = Stack[(int)t255];
    t257 = P + 5;
    t258 = Stack[(int)t257];
    t259 = P + 1;
    t260 = Stack[(int)t259];
    t261 = P + 10;
    t262 = t261 + 1;
    Stack[(int)t262] = t258;
    t263 = t261 + 2;
    Stack[(int)t263] = t260;
    P = P + 10;
    buscar_int();
    t264 = P + 0;
    t265 = Stack[(int)t264];
    P = P - 10;
    t266 = P + 3;
    Stack[(int)t266] = t265;
    t267 = P + 3;
    t268 = Stack[(int)t267];
    t269 = -(1);
    t270 = t268 == t269;
    if (!(t270)) goto L33;
    t271 = H;
    Heap[(int)H] = 78;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t271);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    goto L34;
L33:
    ;
    t272 = H;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t272);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t273 = P + 3;
    t274 = Stack[(int)t273];
    printf("%g\n", (double)(t274));
    t275 = P + 7;
    t276 = Stack[(int)t275];
    t277 = P + 10;
    t278 = t277 + 1;
    Stack[(int)t278] = t276;
    t279 = t277 + 2;
    Stack[(int)t279] = 3;
    P = P + 10;
    registrar();
    P = P - 10;
L34:
    ;
    goto L32;
L31:
    ;
    t280 = P + 0;
    t281 = Stack[(int)t280];
    t282 = t281 == 9;
    if (!(t282)) goto L35;
    t283 = P + 5;
    t284 = Stack[(int)t283];
    t285 = P + 5;
    t286 = Stack[(int)t285];
    t287 = P + 10;
    t288 = t287 + 1;
    Stack[(int)t288] = t286;
    P = P + 10;
    invertir_();
    P = P - 10;
    t289 = H;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t289);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t290 = P + 5;
    t291 = Stack[(int)t290];
    t292 = P + 5;
    t293 = Stack[(int)t292];
    t294 = P + 10;
    t295 = t294 + 1;
    Stack[(int)t295] = t293;
    P = P + 10;
    imprimirAdelante_();
    P = P - 10;
    goto L36;
L35:
    ;
    t296 = P + 0;
    t297 = Stack[(int)t296];
    t298 = t297 == 10;
    if (!(t298)) goto L37;
    t299 = P + 5;
    t300 = Stack[(int)t299];
    t301 = P + 5;
    t302 = Stack[(int)t301];
    t303 = P + 10;
    t304 = t303 + 1;
    Stack[(int)t304] = t302;
    P = P + 10;
    ordenar_();
    P = P - 10;
    t305 = H;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t305);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t306 = P + 5;
    t307 = Stack[(int)t306];
    t308 = P + 5;
    t309 = Stack[(int)t308];
    t310 = P + 10;
    t311 = t310 + 1;
    Stack[(int)t311] = t309;
    P = P + 10;
    imprimirAdelante_();
    P = P - 10;
    goto L38;
L37:
    ;
    t312 = P + 0;
    t313 = Stack[(int)t312];
    t314 = t313 == 11;
    if (!(t314)) goto L39;
    t315 = H;
    Heap[(int)H] = 65;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t315);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t316 = P + 5;
    t317 = Stack[(int)t316];
    t318 = P + 5;
    t319 = Stack[(int)t318];
    t320 = P + 10;
    t321 = t320 + 1;
    Stack[(int)t321] = t319;
    P = P + 10;
    imprimirAdelante_();
    P = P - 10;
    t322 = H;
    Heap[(int)H] = 65;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t322);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t323 = P + 5;
    t324 = Stack[(int)t323];
    t325 = P + 5;
    t326 = Stack[(int)t325];
    t327 = P + 10;
    t328 = t327 + 1;
    Stack[(int)t328] = t326;
    P = P + 10;
    imprimirAtras_();
    P = P - 10;
    goto L40;
L39:
    ;
    t329 = P + 0;
    t330 = Stack[(int)t329];
    t331 = t330 == 12;
    if (!(t331)) goto L41;
    t332 = P + 5;
    t333 = Stack[(int)t332];
    t334 = P + 5;
    t335 = Stack[(int)t334];
    t336 = P + 10;
    t337 = t336 + 1;
    Stack[(int)t337] = t335;
    P = P + 10;
    estaVacia_();
    t338 = P + 0;
    t339 = Stack[(int)t338];
    P = P - 10;
    if (!(t339)) goto L43;
    t340 = H;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t340);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    goto L44;
L43:
    ;
    t341 = H;
    Heap[(int)H] = 84;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t341);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t342 = P + 5;
    t343 = Stack[(int)t342];
    t344 = t343 + 2;
    t345 = Heap[(int)t344];
    printf("%g\n", (double)(t345));
    t346 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 40;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t346);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t347 = P + 5;
    t348 = Stack[(int)t347];
    t349 = t348 + 2;
    t350 = Heap[(int)t349];
    t351 = P + 10;
    t352 = t351 + 1;
    Stack[(int)t352] = t350;
    P = P + 10;
    paridad();
    t353 = P + 0;
    t354 = Stack[(int)t353];
    P = P - 10;
    {
        int __pos = (int)(t354);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t355 = H;
    Heap[(int)H] = 41;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t355);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t356 = H;
    Heap[(int)H] = 83;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t356);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t357 = P + 5;
    t358 = Stack[(int)t357];
    t359 = P + 5;
    t360 = Stack[(int)t359];
    t361 = P + 10;
    t362 = t361 + 1;
    Stack[(int)t362] = t360;
    P = P + 10;
    suma_();
    t363 = P + 0;
    t364 = Stack[(int)t363];
    P = P - 10;
    printf("%g\n", (double)(t364));
    t365 = H;
    Heap[(int)H] = 77;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 120;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t365);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t366 = P + 5;
    t367 = Stack[(int)t366];
    t368 = P + 5;
    t369 = Stack[(int)t368];
    t370 = P + 10;
    t371 = t370 + 1;
    Stack[(int)t371] = t369;
    P = P + 10;
    maximo_();
    t372 = P + 0;
    t373 = Stack[(int)t372];
    P = P - 10;
    printf("%g\n", (double)(t373));
    t374 = H;
    Heap[(int)H] = 80;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t374);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t375 = P + 5;
    t376 = Stack[(int)t375];
    t377 = t376 + 0;
    t378 = Heap[(int)t377];
    t379 = t378 + 0;
    t380 = Heap[(int)t379];
    printf("%g\n", (double)(t380));
    t381 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 124;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 85;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t381);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t382 = P + 5;
    t383 = Stack[(int)t382];
    t384 = t383 + 1;
    t385 = Heap[(int)t384];
    t386 = t385 + 0;
    t387 = Heap[(int)t386];
    printf("%g\n", (double)(t387));
L44:
    ;
    goto L42;
L41:
    ;
    t388 = P + 0;
    t389 = Stack[(int)t388];
    t390 = t389 == 13;
    if (!(t390)) goto L45;
    t391 = P + 5;
    t392 = Stack[(int)t391];
    t393 = P + 5;
    t394 = Stack[(int)t393];
    t395 = P + 10;
    t396 = t395 + 1;
    Stack[(int)t396] = t394;
    P = P + 10;
    vaciar_();
    P = P - 10;
    t397 = H;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t397);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    goto L46;
L45:
    ;
    t398 = P + 0;
    t399 = Stack[(int)t398];
    t400 = t399 == 0;
    if (!(t400)) goto L47;
    t401 = H;
    Heap[(int)H] = 83;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t401);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    goto L48;
L47:
    ;
    t402 = H;
    Heap[(int)H] = 79;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t402);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
L48:
    ;
L46:
    ;
L42:
    ;
L40:
    ;
L38:
    ;
L36:
    ;
L32:
    ;
L28:
    ;
L24:
    ;
L20:
    ;
L16:
    ;
L12:
    ;
L10:
    ;
L8:
    ;
L5:
    ;
    t403 = P + 0;
    t404 = Stack[(int)t403];
    t405 = t404 != 0;
    if (!(t405)) goto L6;
    goto L4;
L6:
    ;
    t406 = P + 7;
    t407 = Stack[(int)t406];
    t408 = P + 10;
    t409 = t408 + 1;
    Stack[(int)t409] = t407;
    P = P + 10;
    imprimirRegistro();
    P = P - 10;
}

int main() {
    P = 0;
    H = 0;
    main_pig();
    return 0;
}
