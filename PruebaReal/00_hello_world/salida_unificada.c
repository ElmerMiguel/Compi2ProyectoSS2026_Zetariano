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

void saludar();
void saludarA();
void sumar();
void Hola_();
void decir_();
void doble_int();
void main_pig();

void saludar() {
    double t1;
    t1 = H;
    Heap[(int)H] = 72;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 77;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 110;
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
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 89;
    H = H + 1;
    Heap[(int)H] = 63;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t1);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
}

void saludarA() {
    double t2, t3, t4, t5, t6, t7, t8, t9, t10, t11;
    t2 = H;
    Heap[(int)H] = 72;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t3 = P + 1;
    t4 = Stack[(int)t3];
    t5 = H;
    t6 = t2;
L1:
    ;
    t7 = Heap[(int)t6];
    t8 = t7 == -1;
    if (t8) goto L2;
    Heap[(int)H] = t7;
    H = H + 1;
    t6 = t6 + 1;
    goto L1;
L2:
    ;
    t9 = t4;
L3:
    ;
    t10 = Heap[(int)t9];
    t11 = t10 == -1;
    if (t11) goto L4;
    Heap[(int)H] = t10;
    H = H + 1;
    t9 = t9 + 1;
    goto L3;
L4:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t5);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
}

void sumar() {
    double t12, t13, t14, t15, t16, t17;
    t12 = P + 1;
    t13 = Stack[(int)t12];
    t14 = P + 2;
    t15 = Stack[(int)t14];
    t16 = t13 + t15;
    t17 = P + 0;
    Stack[(int)t17] = t16;
    return;
}

void Hola_() {
    double t1, t2, t3, t4;
    t1 = H;
    Heap[(int)H] = 72;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 77;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 110;
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
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 90;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t2 = P + 1;
    t3 = Stack[(int)t2];
    t4 = t3 + 0;
    Heap[(int)t4] = t1;
}

void decir_() {
    double t5, t6, t7, t8;
    t5 = P + 1;
    t6 = Stack[(int)t5];
    t7 = t6 + 0;
    t8 = Heap[(int)t7];
    {
        int __pos = (int)(t8);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
}

void doble_int() {
    double t9, t10, t11, t12;
    t9 = P + 2;
    t10 = Stack[(int)t9];
    t11 = t10 * 2;
    t12 = P + 0;
    Stack[(int)t12] = t11;
    return;
}

void main_pig() {
    double t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18, t19, t20, t21, t22, t23, t24, t25, t26, t27, t28, t29, t30, t31, t32, t33, t34;
    t1 = H;
    Heap[(int)H] = 0;
    H = H + 1;
    t2 = P + 0;
    Stack[(int)t2] = t1;
    t3 = P + 3;
    t4 = t3 + 1;
    Stack[(int)t4] = t1;
    P = P + 3;
    Hola_();
    P = P - 3;
    t5 = P + 1;
    t6 = H;
    Heap[(int)H] = 67;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    Stack[(int)t5] = t6;
    t7 = H;
    Heap[(int)H] = 72;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 77;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 110;
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
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 80;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t7);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t8 = P + 3;
    P = P + 3;
    saludar();
    P = P - 3;
    t9 = P + 1;
    t10 = Stack[(int)t9];
    t11 = P + 3;
    t12 = t11 + 1;
    Stack[(int)t12] = t10;
    P = P + 3;
    saludarA();
    P = P - 3;
    t13 = P + 0;
    t14 = Stack[(int)t13];
    t15 = P + 0;
    t16 = Stack[(int)t15];
    t17 = P + 3;
    t18 = t17 + 1;
    Stack[(int)t18] = t16;
    P = P + 3;
    decir_();
    P = P - 3;
    t19 = H;
    Heap[(int)H] = 50;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 43;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 51;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t19);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t20 = P + 3;
    t21 = t20 + 1;
    Stack[(int)t21] = 2;
    t22 = t20 + 2;
    Stack[(int)t22] = 3;
    P = P + 3;
    sumar();
    t23 = P + 0;
    t24 = Stack[(int)t23];
    P = P - 3;
    printf("%g\n", (double)(t24));
    t25 = H;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 98;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 50;
    H = H + 1;
    Heap[(int)H] = 49;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t25);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t26 = P + 0;
    t27 = Stack[(int)t26];
    t28 = P + 0;
    t29 = Stack[(int)t28];
    t30 = P + 3;
    t31 = t30 + 1;
    Stack[(int)t31] = t29;
    t32 = t30 + 2;
    Stack[(int)t32] = 21;
    P = P + 3;
    doble_int();
    t33 = P + 0;
    t34 = Stack[(int)t33];
    P = P - 3;
    printf("%g\n", (double)(t34));
}

int main() {
    P = 0;
    H = 0;
    main_pig();
    return 0;
}
