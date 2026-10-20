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

void sumar();
void restar();
void multiplicar();
void dividir();
void aplicar();
void potencia();
void factorial();
void fibonacci();
void esPrimo();
void mcd();
void contarDigitos();
void sumaImpares();
void sumarArreglo();
void maximoArreglo();
void registrar();
void mostrarHistorial();
void promedioHistorial();
void pedirNumero();
void imprimirMenu();
void main_pig();

void sumar() {
    double t1, t2, t3, t4, t5, t6;
    t1 = P + 1;
    t2 = Stack[(int)t1];
    t3 = P + 2;
    t4 = Stack[(int)t3];
    t5 = t2 + t4;
    t6 = P + 0;
    Stack[(int)t6] = t5;
    return;
}

void restar() {
    double t7, t8, t9, t10, t11, t12;
    t7 = P + 1;
    t8 = Stack[(int)t7];
    t9 = P + 2;
    t10 = Stack[(int)t9];
    t11 = t8 - t10;
    t12 = P + 0;
    Stack[(int)t12] = t11;
    return;
}

void multiplicar() {
    double t13, t14, t15, t16, t17, t18;
    t13 = P + 1;
    t14 = Stack[(int)t13];
    t15 = P + 2;
    t16 = Stack[(int)t15];
    t17 = t14 * t16;
    t18 = P + 0;
    Stack[(int)t18] = t17;
    return;
}

void dividir() {
    double t19, t20, t21, t22, t23, t24, t25, t26, t27, t28, t29;
    t19 = P + 2;
    t20 = Stack[(int)t19];
    t21 = t20 == 0;
    if (!(t21)) goto L2;
    t22 = H;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 44;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 48;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t22);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t23 = P + 0;
    Stack[(int)t23] = 0.0;
    return;
    goto L1;
L2:
    ;
L1:
    ;
    t24 = P + 1;
    t25 = Stack[(int)t24];
    t26 = P + 2;
    t27 = Stack[(int)t26];
    t28 = t25 / t27;
    t29 = P + 0;
    Stack[(int)t29] = t28;
    return;
}

void aplicar() {
    double t30, t31, t32, t33, t34, t35, t36, t37, t38, t39, t40, t41, t42, t43, t44, t45, t46, t47, t48, t49, t50, t51, t52, t53, t54, t55, t56, t57, t58, t59, t60, t61, t62, t63, t64, t65, t66, t67, t68, t69, t70, t71, t72, t73, t74, t75, t76, t77, t78, t79, t80;
    t30 = P + 4;
    Stack[(int)t30] = 0.0;
    t31 = P + 1;
    t32 = Stack[(int)t31];
    t33 = t32 == 1;
    if (!(t33)) goto L9;
    goto L4;
L9:
    ;
    t34 = t32 == 2;
    if (!(t34)) goto L10;
    goto L5;
L10:
    ;
    t35 = t32 == 3;
    if (!(t35)) goto L11;
    goto L6;
L11:
    ;
    t36 = t32 == 4;
    if (!(t36)) goto L12;
    goto L7;
L12:
    ;
    goto L8;
L4:
    ;
    t37 = P + 2;
    t38 = Stack[(int)t37];
    t39 = P + 3;
    t40 = Stack[(int)t39];
    t41 = P + 5;
    t42 = t41 + 1;
    Stack[(int)t42] = t38;
    t43 = t41 + 2;
    Stack[(int)t43] = t40;
    P = P + 5;
    sumar();
    t44 = P + 0;
    t45 = Stack[(int)t44];
    P = P - 5;
    t46 = P + 4;
    Stack[(int)t46] = t45;
    goto L3;
L5:
    ;
    t47 = P + 2;
    t48 = Stack[(int)t47];
    t49 = P + 3;
    t50 = Stack[(int)t49];
    t51 = P + 5;
    t52 = t51 + 1;
    Stack[(int)t52] = t48;
    t53 = t51 + 2;
    Stack[(int)t53] = t50;
    P = P + 5;
    restar();
    t54 = P + 0;
    t55 = Stack[(int)t54];
    P = P - 5;
    t56 = P + 4;
    Stack[(int)t56] = t55;
    goto L3;
L6:
    ;
    t57 = P + 2;
    t58 = Stack[(int)t57];
    t59 = P + 3;
    t60 = Stack[(int)t59];
    t61 = P + 5;
    t62 = t61 + 1;
    Stack[(int)t62] = t58;
    t63 = t61 + 2;
    Stack[(int)t63] = t60;
    P = P + 5;
    multiplicar();
    t64 = P + 0;
    t65 = Stack[(int)t64];
    P = P - 5;
    t66 = P + 4;
    Stack[(int)t66] = t65;
    goto L3;
L7:
    ;
    t67 = P + 2;
    t68 = Stack[(int)t67];
    t69 = P + 3;
    t70 = Stack[(int)t69];
    t71 = P + 5;
    t72 = t71 + 1;
    Stack[(int)t72] = t68;
    t73 = t71 + 2;
    Stack[(int)t73] = t70;
    P = P + 5;
    dividir();
    t74 = P + 0;
    t75 = Stack[(int)t74];
    P = P - 5;
    t76 = P + 4;
    Stack[(int)t76] = t75;
    goto L3;
L8:
    ;
    t77 = H;
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
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t77);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    goto L3;
L3:
    ;
    t78 = P + 4;
    t79 = Stack[(int)t78];
    t80 = P + 0;
    Stack[(int)t80] = t79;
    return;
}

void potencia() {
    double t81, t82, t83, t84, t85, t86, t87, t88, t89, t90, t91, t92, t93, t94, t95, t96, t97, t98, t99, t100, t101, t102, t103, t104, t105, t106, t107, t108, t109, t110, t111, t112, t113, t114, t115, t116, t117;
    t81 = P + 3;
    Stack[(int)t81] = 1.0;
    t82 = P + 2;
    t83 = Stack[(int)t82];
    t84 = P + 4;
    Stack[(int)t84] = t83;
    t85 = P + 4;
    t86 = Stack[(int)t85];
    t87 = t86 < 0;
    if (!(t87)) goto L14;
    t88 = P + 4;
    t89 = Stack[(int)t88];
    t90 = 0 - t89;
    t91 = P + 4;
    Stack[(int)t91] = t90;
    goto L13;
L14:
    ;
L13:
    ;
    t92 = P + 5;
    Stack[(int)t92] = 0;
L15:
    ;
    t93 = P + 5;
    t94 = Stack[(int)t93];
    t95 = P + 4;
    t96 = Stack[(int)t95];
    t97 = t94 < t96;
    if (!(t97)) goto L17;
    t98 = P + 3;
    t99 = Stack[(int)t98];
    t100 = P + 1;
    t101 = Stack[(int)t100];
    t102 = t99 * t101;
    t103 = P + 3;
    Stack[(int)t103] = t102;
L16:
    ;
    t104 = P + 5;
    t105 = Stack[(int)t104];
    t106 = t105 + 1;
    t107 = P + 5;
    Stack[(int)t107] = t106;
    goto L15;
L17:
    ;
    t108 = P + 2;
    t109 = Stack[(int)t108];
    t110 = t109 < 0;
    if (!(t110)) goto L19;
    t111 = P + 3;
    t112 = Stack[(int)t111];
    t113 = 1.0 / t112;
    t114 = P + 0;
    Stack[(int)t114] = t113;
    return;
    goto L18;
L19:
    ;
L18:
    ;
    t115 = P + 3;
    t116 = Stack[(int)t115];
    t117 = P + 0;
    Stack[(int)t117] = t116;
    return;
}

void factorial() {
    double t118, t119, t120, t121, t122, t123, t124, t125, t126, t127, t128, t129, t130, t131, t132;
    t118 = P + 1;
    t119 = Stack[(int)t118];
    t120 = t119 < 2;
    if (!(t120)) goto L21;
    t121 = P + 0;
    Stack[(int)t121] = 1;
    return;
    goto L20;
L21:
    ;
L20:
    ;
    t122 = P + 1;
    t123 = Stack[(int)t122];
    t124 = P + 1;
    t125 = Stack[(int)t124];
    t126 = t125 - 1;
    t127 = P + 2;
    t128 = t127 + 1;
    Stack[(int)t128] = t126;
    P = P + 2;
    factorial();
    t129 = P + 0;
    t130 = Stack[(int)t129];
    P = P - 2;
    t131 = t123 * t130;
    t132 = P + 0;
    Stack[(int)t132] = t131;
    return;
}

void fibonacci() {
    double t133, t134, t135, t136, t137, t138, t139, t140, t141, t142, t143, t144, t145, t146, t147, t148, t149, t150, t151, t152, t153, t154;
    t133 = P + 1;
    t134 = Stack[(int)t133];
    t135 = t134 < 2;
    if (!(t135)) goto L23;
    t136 = P + 1;
    t137 = Stack[(int)t136];
    t138 = P + 0;
    Stack[(int)t138] = t137;
    return;
    goto L22;
L23:
    ;
L22:
    ;
    t139 = P + 1;
    t140 = Stack[(int)t139];
    t141 = t140 - 1;
    t142 = P + 2;
    t143 = t142 + 1;
    Stack[(int)t143] = t141;
    P = P + 2;
    fibonacci();
    t144 = P + 0;
    t145 = Stack[(int)t144];
    P = P - 2;
    t146 = P + 1;
    t147 = Stack[(int)t146];
    t148 = t147 - 2;
    t149 = P + 2;
    t150 = t149 + 1;
    Stack[(int)t150] = t148;
    P = P + 2;
    fibonacci();
    t151 = P + 0;
    t152 = Stack[(int)t151];
    P = P - 2;
    t153 = t145 + t152;
    t154 = P + 0;
    Stack[(int)t154] = t153;
    return;
}

void esPrimo() {
    double t155, t156, t157, t158, t159, t160, t161, t162, t163, t164, t165, t166, t167, t168, t169, t170, t171, t172, t173, t174, t175, t176, t177, t178, t179, t180, t181, t182, t183, t184, t185, t186;
    t155 = P + 1;
    t156 = Stack[(int)t155];
    t157 = t156 < 2;
    if (!(t157)) goto L25;
    t158 = P + 0;
    Stack[(int)t158] = 0;
    return;
    goto L24;
L25:
    ;
L24:
    ;
    t159 = P + 2;
    Stack[(int)t159] = 2;
L26:
    ;
    t160 = P + 2;
    t161 = Stack[(int)t160];
    t162 = P + 2;
    t163 = Stack[(int)t162];
    t164 = t161 * t163;
    t165 = P + 1;
    t166 = Stack[(int)t165];
    t167 = t166 + 1;
    t168 = t164 < t167;
    if (!(t168)) goto L27;
    t169 = P + 1;
    t170 = Stack[(int)t169];
    t171 = P + 1;
    t172 = Stack[(int)t171];
    t173 = P + 2;
    t174 = Stack[(int)t173];
    t175 = t172 / t174;
    t176 = P + 2;
    t177 = Stack[(int)t176];
    t178 = t175 * t177;
    t179 = t170 - t178;
    t180 = t179 == 0;
    if (!(t180)) goto L29;
    t181 = P + 0;
    Stack[(int)t181] = 0;
    return;
    goto L28;
L29:
    ;
L28:
    ;
    t182 = P + 2;
    t183 = Stack[(int)t182];
    t184 = t183 + 1;
    t185 = P + 2;
    Stack[(int)t185] = t184;
    goto L26;
L27:
    ;
    t186 = P + 0;
    Stack[(int)t186] = 1;
    return;
}

void mcd() {
    double t187, t188, t189, t190, t191, t192, t193, t194, t195, t196, t197, t198, t199, t200, t201, t202, t203, t204, t205, t206, t207, t208, t209, t210, t211, t212, t213, t214, t215, t216, t217;
    t187 = P + 1;
    t188 = Stack[(int)t187];
    t189 = P + 3;
    Stack[(int)t189] = t188;
    t190 = P + 2;
    t191 = Stack[(int)t190];
    t192 = P + 4;
    Stack[(int)t192] = t191;
    t193 = P + 5;
    Stack[(int)t193] = 0;
L30:
    ;
    t194 = P + 4;
    t195 = Stack[(int)t194];
    t196 = t195 != 0;
    if (!(t196)) goto L31;
    t197 = P + 4;
    t198 = Stack[(int)t197];
    t199 = P + 5;
    Stack[(int)t199] = t198;
    t200 = P + 3;
    t201 = Stack[(int)t200];
    t202 = P + 3;
    t203 = Stack[(int)t202];
    t204 = P + 4;
    t205 = Stack[(int)t204];
    t206 = t203 / t205;
    t207 = P + 4;
    t208 = Stack[(int)t207];
    t209 = t206 * t208;
    t210 = t201 - t209;
    t211 = P + 4;
    Stack[(int)t211] = t210;
    t212 = P + 5;
    t213 = Stack[(int)t212];
    t214 = P + 3;
    Stack[(int)t214] = t213;
    goto L30;
L31:
    ;
    t215 = P + 3;
    t216 = Stack[(int)t215];
    t217 = P + 0;
    Stack[(int)t217] = t216;
    return;
}

void contarDigitos() {
    double t218, t219, t220, t221, t222, t223, t224, t225, t226, t227, t228, t229, t230, t231, t232, t233, t234, t235, t236, t237, t238, t239, t240, t241, t242;
    t218 = P + 2;
    Stack[(int)t218] = 0;
    t219 = P + 1;
    t220 = Stack[(int)t219];
    t221 = P + 3;
    Stack[(int)t221] = t220;
    t222 = P + 3;
    t223 = Stack[(int)t222];
    t224 = t223 < 0;
    if (!(t224)) goto L33;
    t225 = P + 3;
    t226 = Stack[(int)t225];
    t227 = 0 - t226;
    t228 = P + 3;
    Stack[(int)t228] = t227;
    goto L32;
L33:
    ;
L32:
    ;
L34:
    ;
    t229 = P + 3;
    t230 = Stack[(int)t229];
    t231 = t230 / 10;
    t232 = P + 3;
    Stack[(int)t232] = t231;
    t233 = P + 2;
    t234 = Stack[(int)t233];
    t235 = t234 + 1;
    t236 = P + 2;
    Stack[(int)t236] = t235;
L35:
    ;
    t237 = P + 3;
    t238 = Stack[(int)t237];
    t239 = t238 > 0;
    if (t239) goto L34;
L36:
    ;
    t240 = P + 2;
    t241 = Stack[(int)t240];
    t242 = P + 0;
    Stack[(int)t242] = t241;
    return;
}

void sumaImpares() {
    double t243, t244, t245, t246, t247, t248, t249, t250, t251, t252, t253, t254, t255, t256, t257, t258, t259, t260, t261, t262, t263, t264, t265, t266, t267, t268, t269, t270, t271, t272, t273, t274;
    t243 = P + 2;
    Stack[(int)t243] = 0;
    t244 = P + 3;
    Stack[(int)t244] = 1;
L37:
    ;
    t245 = P + 3;
    t246 = Stack[(int)t245];
    t247 = P + 1;
    t248 = Stack[(int)t247];
    t249 = t248 + 1;
    t250 = t246 < t249;
    if (!(t250)) goto L39;
    t251 = P + 3;
    t252 = Stack[(int)t251];
    t253 = P + 3;
    t254 = Stack[(int)t253];
    t255 = t254 / 2;
    t256 = t255 * 2;
    t257 = t252 - t256;
    t258 = t257 == 0;
    if (!(t258)) goto L41;
    goto L38;
    goto L40;
L41:
    ;
L40:
    ;
    t259 = P + 2;
    t260 = Stack[(int)t259];
    t261 = t260 > 1000;
    if (!(t261)) goto L43;
    goto L39;
    goto L42;
L43:
    ;
L42:
    ;
    t262 = P + 2;
    t263 = Stack[(int)t262];
    t264 = P + 3;
    t265 = Stack[(int)t264];
    t266 = t263 + t265;
    t267 = P + 2;
    Stack[(int)t267] = t266;
L38:
    ;
    t268 = P + 3;
    t269 = Stack[(int)t268];
    t270 = t269 + 1;
    t271 = P + 3;
    Stack[(int)t271] = t270;
    goto L37;
L39:
    ;
    t272 = P + 2;
    t273 = Stack[(int)t272];
    t274 = P + 0;
    Stack[(int)t274] = t273;
    return;
}

void sumarArreglo() {
    double t275, t276, t277, t278, t279, t280, t281, t282, t283, t284, t285, t286, t287, t288, t289, t290, t291, t292, t293, t294, t295, t296, t297, t298, t299, t300, t301;
    t275 = P + 3;
    Stack[(int)t275] = 0.0;
    t276 = P + 4;
    Stack[(int)t276] = 0;
L44:
    ;
    t277 = P + 4;
    t278 = Stack[(int)t277];
    t279 = P + 2;
    t280 = Stack[(int)t279];
    t281 = t278 < t280;
    if (!(t281)) goto L46;
    t282 = P + 3;
    t283 = Stack[(int)t282];
    t284 = P + 1;
    t285 = Stack[(int)t284];
    t286 = Heap[(int)t285];
    t287 = t286 + 1;
    t288 = t285 + t287;
    t289 = P + 4;
    t290 = Stack[(int)t289];
    t291 = t288 + t290;
    t292 = Heap[(int)t291];
    t293 = t283 + t292;
    t294 = P + 3;
    Stack[(int)t294] = t293;
L45:
    ;
    t295 = P + 4;
    t296 = Stack[(int)t295];
    t297 = t296 + 1;
    t298 = P + 4;
    Stack[(int)t298] = t297;
    goto L44;
L46:
    ;
    t299 = P + 3;
    t300 = Stack[(int)t299];
    t301 = P + 0;
    Stack[(int)t301] = t300;
    return;
}

void maximoArreglo() {
    double t302, t303, t304, t305, t306, t307, t308, t309, t310, t311, t312, t313, t314, t315, t316, t317, t318, t319, t320, t321, t322, t323, t324, t325, t326, t327, t328, t329, t330, t331, t332, t333, t334, t335, t336, t337, t338, t339, t340, t341, t342, t343, t344;
    t302 = P + 1;
    t303 = Stack[(int)t302];
    t304 = Heap[(int)t303];
    t305 = t304 + 1;
    t306 = t303 + t305;
    t307 = t306 + 0;
    t308 = Heap[(int)t307];
    t309 = P + 3;
    Stack[(int)t309] = t308;
    t310 = P + 4;
    Stack[(int)t310] = 1;
L47:
    ;
    t311 = P + 4;
    t312 = Stack[(int)t311];
    t313 = P + 2;
    t314 = Stack[(int)t313];
    t315 = t312 < t314;
    if (!(t315)) goto L49;
    t316 = P + 1;
    t317 = Stack[(int)t316];
    t318 = Heap[(int)t317];
    t319 = t318 + 1;
    t320 = t317 + t319;
    t321 = P + 4;
    t322 = Stack[(int)t321];
    t323 = t320 + t322;
    t324 = Heap[(int)t323];
    t325 = P + 3;
    t326 = Stack[(int)t325];
    t327 = t324 > t326;
    if (!(t327)) goto L51;
    t328 = P + 1;
    t329 = Stack[(int)t328];
    t330 = Heap[(int)t329];
    t331 = t330 + 1;
    t332 = t329 + t331;
    t333 = P + 4;
    t334 = Stack[(int)t333];
    t335 = t332 + t334;
    t336 = Heap[(int)t335];
    t337 = P + 3;
    Stack[(int)t337] = t336;
    goto L50;
L51:
    ;
L50:
    ;
L48:
    ;
    t338 = P + 4;
    t339 = Stack[(int)t338];
    t340 = t339 + 1;
    t341 = P + 4;
    Stack[(int)t341] = t340;
    goto L47;
L49:
    ;
    t342 = P + 3;
    t343 = Stack[(int)t342];
    t344 = P + 0;
    Stack[(int)t344] = t343;
    return;
}

void registrar() {
    double t345, t346, t347, t348, t349, t350, t351, t352, t353, t354, t355, t356, t357, t358, t359, t360, t361, t362, t363, t364, t365, t366, t367, t368, t369, t370, t371, t372, t373, t374, t375, t376, t377, t378, t379, t380, t381, t382, t383, t384, t385, t386, t387, t388, t389, t390, t391, t392, t393, t394, t395, t396, t397, t398, t399, t400, t401, t402, t403, t404, t405, t406, t407, t408;
    t345 = P + 1;
    t346 = Stack[(int)t345];
    t347 = t346 + 0;
    t348 = Heap[(int)t347];
    t349 = t348 < 10;
    if (!(t349)) goto L53;
    t350 = P + 2;
    t351 = Stack[(int)t350];
    t352 = P + 1;
    t353 = Stack[(int)t352];
    t354 = t353 + 1;
    t355 = Heap[(int)t354];
    t356 = Heap[(int)t355];
    t357 = t356 + 1;
    t358 = t355 + t357;
    t359 = P + 1;
    t360 = Stack[(int)t359];
    t361 = t360 + 0;
    t362 = Heap[(int)t361];
    t363 = t358 + t362;
    Heap[(int)t363] = t351;
    t364 = P + 1;
    t365 = Stack[(int)t364];
    t366 = t365 + 0;
    t367 = Heap[(int)t366];
    t368 = t367 + 1;
    Heap[(int)t366] = t368;
    goto L52;
L53:
    ;
    t369 = P + 3;
    Stack[(int)t369] = 1;
L54:
    ;
    t370 = P + 3;
    t371 = Stack[(int)t370];
    t372 = t371 < 10;
    if (!(t372)) goto L56;
    t373 = P + 1;
    t374 = Stack[(int)t373];
    t375 = t374 + 1;
    t376 = Heap[(int)t375];
    t377 = Heap[(int)t376];
    t378 = t377 + 1;
    t379 = t376 + t378;
    t380 = P + 3;
    t381 = Stack[(int)t380];
    t382 = t379 + t381;
    t383 = Heap[(int)t382];
    t384 = P + 1;
    t385 = Stack[(int)t384];
    t386 = t385 + 1;
    t387 = Heap[(int)t386];
    t388 = Heap[(int)t387];
    t389 = t388 + 1;
    t390 = t387 + t389;
    t391 = P + 3;
    t392 = Stack[(int)t391];
    t393 = t392 - 1;
    t394 = t390 + t393;
    Heap[(int)t394] = t383;
L55:
    ;
    t395 = P + 3;
    t396 = Stack[(int)t395];
    t397 = t396 + 1;
    t398 = P + 3;
    Stack[(int)t398] = t397;
    goto L54;
L56:
    ;
    t399 = P + 2;
    t400 = Stack[(int)t399];
    t401 = P + 1;
    t402 = Stack[(int)t401];
    t403 = t402 + 1;
    t404 = Heap[(int)t403];
    t405 = Heap[(int)t404];
    t406 = t405 + 1;
    t407 = t404 + t406;
    t408 = t407 + 9;
    Heap[(int)t408] = t400;
L52:
    ;
}

void mostrarHistorial() {
    double t409, t410, t411, t412, t413, t414, t415, t416, t417, t418, t419, t420, t421, t422, t423, t424, t425, t426, t427, t428, t429, t430, t431, t432, t433, t434, t435, t436, t437, t438, t439, t440, t441, t442, t443, t444, t445, t446, t447, t448, t449, t450, t451, t452, t453, t454, t455, t456, t457, t458, t459, t460, t461, t462, t463, t464, t465, t466, t467, t468, t469, t470, t471, t472, t473, t474, t475, t476, t477, t478, t479, t480, t481, t482, t483, t484, t485;
    t409 = P + 1;
    t410 = Stack[(int)t409];
    t411 = t410 + 0;
    t412 = Heap[(int)t411];
    t413 = t412 == 0;
    if (!(t413)) goto L58;
    t414 = H;
    Heap[(int)H] = 72;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
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
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t414);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    goto L57;
L58:
    ;
    t415 = H;
    Heap[(int)H] = 45;
    H = H + 1;
    Heap[(int)H] = 45;
    H = H + 1;
    Heap[(int)H] = 45;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 72;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
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
    Heap[(int)H] = -1;
    H = H + 1;
    t416 = P + 1;
    t417 = Stack[(int)t416];
    t418 = t417 + 0;
    t419 = Heap[(int)t418];
    {
        char __buffer[128];
        snprintf(__buffer, sizeof(__buffer), "%d", (int)(t419));
        t420 = H;
        for (int __i = 0; __buffer[__i] != '\0'; __i++) {
            Heap[(int)H] = (double)__buffer[__i];
            H = H + 1;
        }
        Heap[(int)H] = -1;
        H = H + 1;
    }
    t421 = H;
    t422 = t415;
L59:
    ;
    t423 = Heap[(int)t422];
    t424 = t423 == -1;
    if (t424) goto L60;
    Heap[(int)H] = t423;
    H = H + 1;
    t422 = t422 + 1;
    goto L59;
L60:
    ;
    t425 = t420;
L61:
    ;
    t426 = Heap[(int)t425];
    t427 = t426 == -1;
    if (t427) goto L62;
    Heap[(int)H] = t426;
    H = H + 1;
    t425 = t425 + 1;
    goto L61;
L62:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    t428 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 41;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 45;
    H = H + 1;
    Heap[(int)H] = 45;
    H = H + 1;
    Heap[(int)H] = 45;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t429 = H;
    t430 = t421;
L63:
    ;
    t431 = Heap[(int)t430];
    t432 = t431 == -1;
    if (t432) goto L64;
    Heap[(int)H] = t431;
    H = H + 1;
    t430 = t430 + 1;
    goto L63;
L64:
    ;
    t433 = t428;
L65:
    ;
    t434 = Heap[(int)t433];
    t435 = t434 == -1;
    if (t435) goto L66;
    Heap[(int)H] = t434;
    H = H + 1;
    t433 = t433 + 1;
    goto L65;
L66:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t429);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t436 = P + 2;
    Stack[(int)t436] = 0;
L67:
    ;
    t437 = P + 2;
    t438 = Stack[(int)t437];
    t439 = P + 1;
    t440 = Stack[(int)t439];
    t441 = t440 + 0;
    t442 = Heap[(int)t441];
    t443 = t438 < t442;
    if (!(t443)) goto L69;
    t444 = H;
    Heap[(int)H] = 35;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t445 = P + 2;
    t446 = Stack[(int)t445];
    {
        char __buffer[128];
        snprintf(__buffer, sizeof(__buffer), "%d", (int)(t446));
        t447 = H;
        for (int __i = 0; __buffer[__i] != '\0'; __i++) {
            Heap[(int)H] = (double)__buffer[__i];
            H = H + 1;
        }
        Heap[(int)H] = -1;
        H = H + 1;
    }
    t448 = H;
    t449 = t444;
L70:
    ;
    t450 = Heap[(int)t449];
    t451 = t450 == -1;
    if (t451) goto L71;
    Heap[(int)H] = t450;
    H = H + 1;
    t449 = t449 + 1;
    goto L70;
L71:
    ;
    t452 = t447;
L72:
    ;
    t453 = Heap[(int)t452];
    t454 = t453 == -1;
    if (t454) goto L73;
    Heap[(int)H] = t453;
    H = H + 1;
    t452 = t452 + 1;
    goto L72;
L73:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    t455 = H;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t456 = H;
    t457 = t448;
L74:
    ;
    t458 = Heap[(int)t457];
    t459 = t458 == -1;
    if (t459) goto L75;
    Heap[(int)H] = t458;
    H = H + 1;
    t457 = t457 + 1;
    goto L74;
L75:
    ;
    t460 = t455;
L76:
    ;
    t461 = Heap[(int)t460];
    t462 = t461 == -1;
    if (t462) goto L77;
    Heap[(int)H] = t461;
    H = H + 1;
    t460 = t460 + 1;
    goto L76;
L77:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    t463 = P + 1;
    t464 = Stack[(int)t463];
    t465 = t464 + 1;
    t466 = Heap[(int)t465];
    t467 = Heap[(int)t466];
    t468 = t467 + 1;
    t469 = t466 + t468;
    t470 = P + 2;
    t471 = Stack[(int)t470];
    t472 = t469 + t471;
    t473 = Heap[(int)t472];
    {
        char __buffer[128];
        snprintf(__buffer, sizeof(__buffer), "%g", (double)(t473));
        t474 = H;
        for (int __i = 0; __buffer[__i] != '\0'; __i++) {
            Heap[(int)H] = (double)__buffer[__i];
            H = H + 1;
        }
        Heap[(int)H] = -1;
        H = H + 1;
    }
    t475 = H;
    t476 = t456;
L78:
    ;
    t477 = Heap[(int)t476];
    t478 = t477 == -1;
    if (t478) goto L79;
    Heap[(int)H] = t477;
    H = H + 1;
    t476 = t476 + 1;
    goto L78;
L79:
    ;
    t479 = t474;
L80:
    ;
    t480 = Heap[(int)t479];
    t481 = t480 == -1;
    if (t481) goto L81;
    Heap[(int)H] = t480;
    H = H + 1;
    t479 = t479 + 1;
    goto L80;
L81:
    ;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t475);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
L68:
    ;
    t482 = P + 2;
    t483 = Stack[(int)t482];
    t484 = t483 + 1;
    t485 = P + 2;
    Stack[(int)t485] = t484;
    goto L67;
L69:
    ;
L57:
    ;
}

void promedioHistorial() {
    double t486, t487, t488, t489, t490, t491, t492, t493, t494, t495, t496, t497, t498, t499, t500, t501, t502, t503, t504, t505, t506, t507, t508, t509, t510, t511, t512, t513, t514, t515, t516, t517, t518, t519, t520, t521, t522, t523, t524, t525, t526, t527;
    t486 = P + 1;
    t487 = Stack[(int)t486];
    t488 = t487 + 0;
    t489 = Heap[(int)t488];
    t490 = t489 == 0;
    if (!(t490)) goto L83;
    t491 = P + 0;
    Stack[(int)t491] = 0.0;
    return;
    goto L82;
L83:
    ;
L82:
    ;
    t492 = P + 2;
    Stack[(int)t492] = 0.0;
    t493 = P + 3;
    Stack[(int)t493] = 0;
L84:
    ;
    t494 = P + 3;
    t495 = Stack[(int)t494];
    t496 = P + 1;
    t497 = Stack[(int)t496];
    t498 = t497 + 0;
    t499 = Heap[(int)t498];
    t500 = t495 < t499;
    if (!(t500)) goto L86;
    t501 = P + 2;
    t502 = Stack[(int)t501];
    t503 = P + 1;
    t504 = Stack[(int)t503];
    t505 = t504 + 1;
    t506 = Heap[(int)t505];
    t507 = Heap[(int)t506];
    t508 = t507 + 1;
    t509 = t506 + t508;
    t510 = P + 3;
    t511 = Stack[(int)t510];
    t512 = t509 + t511;
    t513 = Heap[(int)t512];
    t514 = t502 + t513;
    t515 = P + 2;
    Stack[(int)t515] = t514;
L85:
    ;
    t516 = P + 3;
    t517 = Stack[(int)t516];
    t518 = t517 + 1;
    t519 = P + 3;
    Stack[(int)t519] = t518;
    goto L84;
L86:
    ;
    t520 = P + 2;
    t521 = Stack[(int)t520];
    t522 = P + 1;
    t523 = Stack[(int)t522];
    t524 = t523 + 0;
    t525 = Heap[(int)t524];
    t526 = t521 / t525;
    t527 = P + 0;
    Stack[(int)t527] = t526;
    return;
}

void pedirNumero() {
    double t528, t529, t530, t531, t532, t533, t534;
    t528 = P + 1;
    t529 = Stack[(int)t528];
    {
        int __pos = (int)(t529);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t530 = 0;
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
            double __valor = strtod(__buffer, &__fin);
            int __huboDigitos = __fin != __buffer;
            while (__fin != NULL && isspace((unsigned char)*__fin)) __fin++;
            if (__huboDigitos && __fin != NULL && *__fin == '\0'
                    && errno != ERANGE && isfinite(__valor)) {
                t530 = __valor;
                break;
            }
            printf("Entrada invalida. Ingrese un decimal: "
            );
            fflush(stdout);
        }
    }
    t531 = P + 2;
    Stack[(int)t531] = t530;
    t532 = P + 2;
    t533 = Stack[(int)t532];
    t534 = P + 0;
    Stack[(int)t534] = t533;
    return;
}

void imprimirMenu() {
    double t535, t536, t537, t538, t539, t540, t541, t542, t543, t544;
    t535 = H;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t535);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t536 = H;
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
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 67;
    H = H + 1;
    Heap[(int)H] = 65;
    H = H + 1;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 67;
    H = H + 1;
    Heap[(int)H] = 85;
    H = H + 1;
    Heap[(int)H] = 76;
    H = H + 1;
    Heap[(int)H] = 65;
    H = H + 1;
    Heap[(int)H] = 68;
    H = H + 1;
    Heap[(int)H] = 79;
    H = H + 1;
    Heap[(int)H] = 82;
    H = H + 1;
    Heap[(int)H] = 65;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 90;
    H = H + 1;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 84;
    H = H + 1;
    Heap[(int)H] = 65;
    H = H + 1;
    Heap[(int)H] = 82;
    H = H + 1;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 65;
    H = H + 1;
    Heap[(int)H] = 78;
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
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t536);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t537 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 49;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 83;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 109;
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
    Heap[(int)H] = 50;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 82;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t537);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t538 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 51;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 77;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 99;
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
    Heap[(int)H] = 52;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 68;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t538);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t539 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 53;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 80;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 97;
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
    Heap[(int)H] = 54;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 70;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t539);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t540 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 55;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 83;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 70;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 98;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
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
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 63;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t540);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t541 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 57;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 77;
    H = H + 1;
    Heap[(int)H] = 67;
    H = H + 1;
    Heap[(int)H] = 68;
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
    Heap[(int)H] = 48;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
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
    Heap[(int)H] = 40;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 47;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 120;
    H = H + 1;
    Heap[(int)H] = 41;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t541);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t542 = H;
    Heap[(int)H] = 49;
    H = H + 1;
    Heap[(int)H] = 49;
    H = H + 1;
    Heap[(int)H] = 46;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 72;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 105;
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
    Heap[(int)H] = 68;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 121;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
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
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t542);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t543 = H;
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
        int __pos = (int)(t543);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
    t544 = H;
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
        int __pos = (int)(t544);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
    }
}

void main_pig() {
    double t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18, t19, t20, t21, t22, t23, t24, t25, t26, t27, t28, t29, t30, t31, t32, t33, t34, t35, t36, t37, t38, t39, t40, t41, t42, t43, t44, t45, t46, t47, t48, t49, t50, t51, t52, t53, t54, t55, t56, t57, t58, t59, t60, t61, t62, t63, t64, t65, t66, t67, t68, t69, t70, t71, t72, t73, t74, t75, t76, t77, t78, t79, t80, t81, t82, t83, t84, t85, t86, t87, t88, t89, t90, t91, t92, t93, t94, t95, t96, t97, t98, t99, t100, t101, t102, t103, t104, t105, t106, t107, t108, t109, t110, t111, t112, t113, t114, t115, t116, t117, t118, t119, t120, t121, t122, t123, t124, t125, t126, t127, t128, t129, t130, t131, t132, t133, t134, t135, t136, t137, t138, t139, t140, t141, t142, t143, t144, t145, t146, t147, t148, t149, t150, t151, t152, t153, t154, t155, t156, t157, t158, t159, t160, t161, t162, t163, t164, t165, t166, t167, t168, t169, t170, t171, t172, t173, t174, t175, t176, t177, t178, t179, t180, t181, t182, t183, t184, t185, t186, t187, t188, t189, t190, t191, t192, t193, t194, t195, t196, t197, t198, t199, t200, t201, t202, t203, t204, t205, t206, t207, t208, t209, t210, t211, t212, t213, t214, t215, t216, t217, t218, t219, t220, t221, t222, t223, t224, t225, t226, t227, t228, t229, t230, t231, t232, t233, t234, t235, t236, t237, t238, t239, t240, t241, t242, t243, t244, t245, t246, t247, t248, t249, t250, t251, t252, t253, t254, t255, t256, t257, t258, t259, t260, t261, t262, t263, t264, t265, t266, t267, t268, t269, t270, t271, t272, t273, t274, t275, t276, t277, t278, t279, t280, t281, t282, t283, t284, t285, t286, t287, t288, t289, t290, t291, t292, t293, t294, t295, t296, t297, t298, t299, t300, t301, t302, t303, t304, t305, t306, t307, t308, t309, t310, t311, t312, t313, t314, t315, t316, t317, t318, t319, t320, t321, t322, t323, t324, t325, t326, t327, t328, t329, t330, t331, t332, t333, t334, t335, t336, t337, t338, t339, t340, t341, t342, t343, t344, t345, t346, t347, t348, t349, t350, t351, t352, t353, t354, t355, t356, t357, t358, t359, t360, t361, t362, t363, t364, t365, t366, t367, t368, t369, t370, t371, t372, t373;
    t1 = P + 0;
    Stack[(int)t1] = 0;
    t2 = P + 1;
    Stack[(int)t2] = 0;
    t3 = P + 2;
    Stack[(int)t3] = 0;
    t4 = P + 3;
    Stack[(int)t4] = 0;
    t5 = P + 4;
    Stack[(int)t5] = 3;
    t6 = P + 5;
    Stack[(int)t6] = 0.0;
    t7 = P + 6;
    Stack[(int)t7] = 0.0;
    t8 = P + 7;
    Stack[(int)t8] = 0.0;
    t9 = P + 8;
    t10 = H;
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
    Stack[(int)t9] = t10;
    t11 = P + 9;
    Stack[(int)t11] = 0;
    t12 = H;
    Heap[(int)H] = 1;
    H = H + 1;
    Heap[(int)H] = 10;
    H = H + 1;
    t13 = H;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    t14 = t13 + 0;
    Heap[(int)t14] = 0.0;
    t15 = t13 + 1;
    Heap[(int)t15] = 0.0;
    t16 = t13 + 2;
    Heap[(int)t16] = 0.0;
    t17 = t13 + 3;
    Heap[(int)t17] = 0.0;
    t18 = t13 + 4;
    Heap[(int)t18] = 0.0;
    t19 = t13 + 5;
    Heap[(int)t19] = 0.0;
    t20 = t13 + 6;
    Heap[(int)t20] = 0.0;
    t21 = t13 + 7;
    Heap[(int)t21] = 0.0;
    t22 = t13 + 8;
    Heap[(int)t22] = 0.0;
    t23 = t13 + 9;
    Heap[(int)t23] = 0.0;
    t24 = P + 10;
    Stack[(int)t24] = t12;
    t25 = H;
    Heap[(int)H] = 1;
    H = H + 1;
    Heap[(int)H] = 10;
    H = H + 1;
    t26 = H;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    t27 = t26 + 0;
    Heap[(int)t27] = 0.0;
    t28 = t26 + 1;
    Heap[(int)t28] = 0.0;
    t29 = t26 + 2;
    Heap[(int)t29] = 0.0;
    t30 = t26 + 3;
    Heap[(int)t30] = 0.0;
    t31 = t26 + 4;
    Heap[(int)t31] = 0.0;
    t32 = t26 + 5;
    Heap[(int)t32] = 0.0;
    t33 = t26 + 6;
    Heap[(int)t33] = 0.0;
    t34 = t26 + 7;
    Heap[(int)t34] = 0.0;
    t35 = t26 + 8;
    Heap[(int)t35] = 0.0;
    t36 = t26 + 9;
    Heap[(int)t36] = 0.0;
    t37 = P + 11;
    Stack[(int)t37] = t25;
    t38 = H;
    Heap[(int)H] = 0;
    H = H + 1;
    Heap[(int)H] = 0;
    H = H + 1;
    t39 = P + 12;
    Stack[(int)t39] = t38;
    t40 = t38 + 0;
    Heap[(int)t40] = 0;
    t41 = P + 11;
    t42 = Stack[(int)t41];
    t43 = t38 + 1;
    Heap[(int)t43] = t42;
    t44 = H;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 98;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t44);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    {
        int __c;
        t45 = H;
        while ((__c = getchar()) != '\n' && __c != EOF) {
            Heap[(int)H] = (double)__c;
            H = H + 1;
        }
        Heap[(int)H] = -1;
        H = H + 1;
    }
    t46 = P + 8;
    Stack[(int)t46] = t45;
    t47 = H;
    Heap[(int)H] = 66;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
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
    t48 = P + 8;
    t49 = Stack[(int)t48];
    {
        int __pos = (int)(t49);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
L1:
    ;
    t50 = P + 4;
    t51 = Stack[(int)t50];
    t52 = t51 > 0;
    if (!(t52)) goto L2;
    t53 = H;
    Heap[(int)H] = 73;
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
    Heap[(int)H] = 110;
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
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t53);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t54 = P + 4;
    t55 = Stack[(int)t54];
    printf("%g\n", (double)(t55));
    t56 = P + 4;
    t57 = Stack[(int)t56];
    t58 = t57 - 1;
    t59 = P + 4;
    Stack[(int)t59] = t58;
    goto L1;
L2:
    ;
L3:
    ;
    t60 = P + 16;
    P = P + 16;
    imprimirMenu();
    P = P - 16;
    t61 = H;
    Heap[(int)H] = 69;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 111;
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
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t62 = 0;
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
                t62 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t63 = P + 0;
    Stack[(int)t63] = t62;
    t64 = P + 0;
    t65 = Stack[(int)t64];
    t66 = t65 < 0;
    t67 = P + 0;
    t68 = Stack[(int)t67];
    t69 = t68 > 12;
    t70 = t66 || t69;
    if (!(t70)) goto L6;
    t71 = H;
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
    Heap[(int)H] = 44;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 111;
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
    goto L4;
L6:
    ;
    t72 = P + 0;
    t73 = Stack[(int)t72];
    t74 = t73 >= 1;
    t75 = P + 0;
    t76 = Stack[(int)t75];
    t77 = t76 <= 4;
    t78 = t74 && t77;
    if (!(t78)) goto L8;
    t79 = H;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 112;
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
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 117;
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
    Heap[(int)H] = -1;
    H = H + 1;
    t80 = P + 16;
    t81 = t80 + 1;
    Stack[(int)t81] = t79;
    P = P + 16;
    pedirNumero();
    t82 = P + 0;
    t83 = Stack[(int)t82];
    P = P - 16;
    t84 = P + 5;
    Stack[(int)t84] = t83;
    t85 = H;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 103;
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
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 117;
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
    Heap[(int)H] = -1;
    H = H + 1;
    t86 = P + 16;
    t87 = t86 + 1;
    Stack[(int)t87] = t85;
    P = P + 16;
    pedirNumero();
    t88 = P + 0;
    t89 = Stack[(int)t88];
    P = P - 16;
    t90 = P + 6;
    Stack[(int)t90] = t89;
    t91 = P + 0;
    t92 = Stack[(int)t91];
    t93 = P + 5;
    t94 = Stack[(int)t93];
    t95 = P + 6;
    t96 = Stack[(int)t95];
    t97 = P + 16;
    t98 = t97 + 1;
    Stack[(int)t98] = t92;
    t99 = t97 + 2;
    Stack[(int)t99] = t94;
    t100 = t97 + 3;
    Stack[(int)t100] = t96;
    P = P + 16;
    aplicar();
    t101 = P + 0;
    t102 = Stack[(int)t101];
    P = P - 16;
    t103 = P + 7;
    Stack[(int)t103] = t102;
    t104 = H;
    Heap[(int)H] = 82;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
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
        int __pos = (int)(t104);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t105 = P + 7;
    t106 = Stack[(int)t105];
    {
        char __buffer[64];
        double __valor = (double)(t106);
        snprintf(__buffer, sizeof(__buffer), "%.15g", __valor);
        fputs(__buffer, stdout);
        if (isfinite(__valor) && strchr(__buffer, '.') == NULL
                && strchr(__buffer, 'e') == NULL
                && strchr(__buffer, 'E') == NULL) fputs(".0", stdout);
        putchar('\n');
    }
    t107 = P + 12;
    t108 = Stack[(int)t107];
    t109 = P + 7;
    t110 = Stack[(int)t109];
    t111 = P + 16;
    t112 = t111 + 1;
    Stack[(int)t112] = t108;
    t113 = t111 + 2;
    Stack[(int)t113] = t110;
    P = P + 16;
    registrar();
    P = P - 16;
    goto L9;
L8:
    ;
    t114 = P + 0;
    t115 = Stack[(int)t114];
    t116 = t115 == 5;
    if (!(t116)) goto L10;
    t117 = H;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 98;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    t118 = P + 16;
    t119 = t118 + 1;
    Stack[(int)t119] = t117;
    P = P + 16;
    pedirNumero();
    t120 = P + 0;
    t121 = Stack[(int)t120];
    P = P - 16;
    t122 = P + 5;
    Stack[(int)t122] = t121;
    t123 = H;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 97;
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
    Heap[(int)H] = 120;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 40;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 41;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t123);
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
                t124 = 0;
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
                t124 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t125 = P + 1;
    Stack[(int)t125] = t124;
    t126 = P + 5;
    t127 = Stack[(int)t126];
    t128 = P + 1;
    t129 = Stack[(int)t128];
    t130 = P + 16;
    t131 = t130 + 1;
    Stack[(int)t131] = t127;
    t132 = t130 + 2;
    Stack[(int)t132] = t129;
    P = P + 16;
    potencia();
    t133 = P + 0;
    t134 = Stack[(int)t133];
    P = P - 16;
    t135 = P + 7;
    Stack[(int)t135] = t134;
    t136 = P + 5;
    t137 = Stack[(int)t136];
    {
        char __buffer[64];
        double __valor = (double)(t137);
        snprintf(__buffer, sizeof(__buffer), "%.15g", __valor);
        fputs(__buffer, stdout);
        if (isfinite(__valor) && strchr(__buffer, '.') == NULL
                && strchr(__buffer, 'e') == NULL
                && strchr(__buffer, 'E') == NULL) fputs(".0", stdout);
        putchar('\n');
    }
    t138 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 94;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t138);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t139 = P + 1;
    t140 = Stack[(int)t139];
    printf("%g\n", (double)(t140));
    t141 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 61;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t141);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t142 = P + 7;
    t143 = Stack[(int)t142];
    {
        char __buffer[64];
        double __valor = (double)(t143);
        snprintf(__buffer, sizeof(__buffer), "%.15g", __valor);
        fputs(__buffer, stdout);
        if (isfinite(__valor) && strchr(__buffer, '.') == NULL
                && strchr(__buffer, 'e') == NULL
                && strchr(__buffer, 'E') == NULL) fputs(".0", stdout);
        putchar('\n');
    }
    t144 = P + 12;
    t145 = Stack[(int)t144];
    t146 = P + 7;
    t147 = Stack[(int)t146];
    t148 = P + 16;
    t149 = t148 + 1;
    Stack[(int)t149] = t145;
    t150 = t148 + 2;
    Stack[(int)t150] = t147;
    P = P + 16;
    registrar();
    P = P - 16;
    goto L11;
L10:
    ;
    t151 = P + 0;
    t152 = Stack[(int)t151];
    t153 = t152 == 6;
    if (!(t153)) goto L12;
    t154 = H;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 33;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t154);
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
                t155 = 0;
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
                t155 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t156 = P + 1;
    Stack[(int)t156] = t155;
    t157 = P + 1;
    t158 = Stack[(int)t157];
    t159 = t158 < 0;
    if (!(t159)) goto L14;
    t160 = H;
    Heap[(int)H] = 78;
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
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 102;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 118;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t160);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    goto L15;
L14:
    ;
    t161 = P + 1;
    t162 = Stack[(int)t161];
    printf("%g\n", (double)(t162));
    t163 = H;
    Heap[(int)H] = 33;
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
        int __pos = (int)(t163);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t164 = P + 1;
    t165 = Stack[(int)t164];
    t166 = P + 16;
    t167 = t166 + 1;
    Stack[(int)t167] = t165;
    P = P + 16;
    factorial();
    t168 = P + 0;
    t169 = Stack[(int)t168];
    P = P - 16;
    printf("%g\n", (double)(t169));
    t170 = P + 12;
    t171 = Stack[(int)t170];
    t172 = P + 1;
    t173 = Stack[(int)t172];
    t174 = P + 16;
    t175 = t174 + 1;
    Stack[(int)t175] = t173;
    P = P + 16;
    factorial();
    t176 = P + 0;
    t177 = Stack[(int)t176];
    P = P - 16;
    t178 = P + 16;
    t179 = t178 + 1;
    Stack[(int)t179] = t171;
    t180 = t178 + 2;
    Stack[(int)t180] = t177;
    P = P + 16;
    registrar();
    P = P - 16;
L15:
    ;
    goto L13;
L12:
    ;
    t181 = P + 0;
    t182 = Stack[(int)t181];
    t183 = t182 == 7;
    if (!(t183)) goto L16;
    t184 = H;
    Heap[(int)H] = 67;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 70;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 98;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 63;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 40;
    H = H + 1;
    Heap[(int)H] = 49;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 50;
    H = H + 1;
    Heap[(int)H] = 48;
    H = H + 1;
    Heap[(int)H] = 41;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t184);
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
                t185 = 0;
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
                t185 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t186 = P + 1;
    Stack[(int)t186] = t185;
    t187 = P + 1;
    t188 = Stack[(int)t187];
    t189 = t188 < 1;
    t190 = P + 1;
    t191 = Stack[(int)t190];
    t192 = t191 > 20;
    t193 = t189 || t192;
    if (!(t193)) goto L18;
    t194 = H;
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
    Heap[(int)H] = 102;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t194);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    goto L19;
L18:
    ;
    t195 = P + 13;
    Stack[(int)t195] = 0;
L20:
    ;
    t196 = P + 14;
    t197 = Stack[(int)t196];
    t198 = P + 1;
    t199 = Stack[(int)t198];
    t200 = t197 < t199;
    if (!(t200)) goto L22;
    t201 = H;
    Heap[(int)H] = 70;
    H = H + 1;
    Heap[(int)H] = 40;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t201);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t202 = P + 14;
    t203 = Stack[(int)t202];
    printf("%g\n", (double)(t203));
    t204 = H;
    Heap[(int)H] = 41;
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
        int __pos = (int)(t204);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t205 = P + 14;
    t206 = Stack[(int)t205];
    t207 = P + 16;
    t208 = t207 + 1;
    Stack[(int)t208] = t206;
    P = P + 16;
    fibonacci();
    t209 = P + 0;
    t210 = Stack[(int)t209];
    P = P - 16;
    printf("%g\n", (double)(t210));
L21:
    ;
    t211 = P + 14;
    t212 = Stack[(int)t211];
    t213 = t212 + 1;
    Stack[(int)t211] = t213;
    goto L20;
L22:
    ;
L19:
    ;
    goto L17;
L16:
    ;
    t214 = P + 0;
    t215 = Stack[(int)t214];
    t216 = t215 == 8;
    if (!(t216)) goto L23;
    t217 = H;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 58;
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
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t218 = 0;
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
                t218 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t219 = P + 1;
    Stack[(int)t219] = t218;
    t220 = P + 1;
    t221 = Stack[(int)t220];
    t222 = P + 16;
    t223 = t222 + 1;
    Stack[(int)t223] = t221;
    P = P + 16;
    esPrimo();
    t224 = P + 0;
    t225 = Stack[(int)t224];
    P = P - 16;
    t226 = P + 9;
    Stack[(int)t226] = t225;
    t227 = P + 9;
    t228 = Stack[(int)t227];
    t229 = t228 == 1;
    if (!(t229)) goto L25;
    t230 = P + 1;
    t231 = Stack[(int)t230];
    printf("%g\n", (double)(t231));
    t232 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t232);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    goto L26;
L25:
    ;
    t233 = P + 1;
    t234 = Stack[(int)t233];
    printf("%g\n", (double)(t234));
    t235 = H;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 78;
    H = H + 1;
    Heap[(int)H] = 79;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t235);
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
    t236 = P + 0;
    t237 = Stack[(int)t236];
    t238 = t237 == 9;
    if (!(t238)) goto L27;
    t239 = H;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 112;
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
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 58;
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
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t240 = 0;
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
                t240 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t241 = P + 1;
    Stack[(int)t241] = t240;
    t242 = H;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 103;
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
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 58;
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
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t243 = 0;
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
                t243 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t244 = P + 2;
    Stack[(int)t244] = t243;
    t245 = H;
    Heap[(int)H] = 77;
    H = H + 1;
    Heap[(int)H] = 67;
    H = H + 1;
    Heap[(int)H] = 68;
    H = H + 1;
    Heap[(int)H] = 40;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t245);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t246 = P + 1;
    t247 = Stack[(int)t246];
    printf("%g\n", (double)(t247));
    t248 = H;
    Heap[(int)H] = 44;
    H = H + 1;
    Heap[(int)H] = 32;
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
    t249 = P + 2;
    t250 = Stack[(int)t249];
    printf("%g\n", (double)(t250));
    t251 = H;
    Heap[(int)H] = 41;
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
        int __pos = (int)(t251);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t252 = P + 1;
    t253 = Stack[(int)t252];
    t254 = P + 2;
    t255 = Stack[(int)t254];
    t256 = P + 16;
    t257 = t256 + 1;
    Stack[(int)t257] = t253;
    t258 = t256 + 2;
    Stack[(int)t258] = t255;
    P = P + 16;
    mcd();
    t259 = P + 0;
    t260 = Stack[(int)t259];
    P = P - 16;
    printf("%g\n", (double)(t260));
    goto L28;
L27:
    ;
    t261 = P + 0;
    t262 = Stack[(int)t261];
    t263 = t262 == 10;
    if (!(t263)) goto L29;
    t264 = P + 3;
    Stack[(int)t264] = 0;
    t265 = H;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 104;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 49;
    H = H + 1;
    Heap[(int)H] = 48;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 40;
    H = H + 1;
    Heap[(int)H] = 48;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 112;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
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
    Heap[(int)H] = 41;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t265);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t266 = P + 14;
    Stack[(int)t266] = 0;
L31:
    ;
    t267 = P + 14;
    t268 = Stack[(int)t267];
    t269 = t268 < 10;
    if (!(t269)) goto L33;
    {
        char __buffer[256];
        for (;;) {
            size_t __longitud;
            int __c;
            if (fgets(__buffer, sizeof(__buffer), stdin) == NULL) {
                t270 = 0;
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
            double __valor = strtod(__buffer, &__fin);
            int __huboDigitos = __fin != __buffer;
            while (__fin != NULL && isspace((unsigned char)*__fin)) __fin++;
            if (__huboDigitos && __fin != NULL && *__fin == '\0'
                    && errno != ERANGE && isfinite(__valor)) {
                t270 = __valor;
                break;
            }
            printf("Entrada invalida. Ingrese un decimal: "
            );
            fflush(stdout);
        }
    }
    t271 = P + 5;
    Stack[(int)t271] = t270;
    t272 = P + 5;
    t273 = Stack[(int)t272];
    t274 = t273 == 0;
    if (!(t274)) goto L34;
    goto L33;
L34:
    ;
    t275 = P + 5;
    t276 = Stack[(int)t275];
    t277 = P + 10;
    t278 = Stack[(int)t277];
    t279 = P + 14;
    t280 = Stack[(int)t279];
    t281 = t278 + 2;
    t282 = t281 + t280;
    Heap[(int)t282] = t276;
    t283 = P + 3;
    t284 = Stack[(int)t283];
    t285 = t284 + 1;
    t286 = P + 3;
    Stack[(int)t286] = t285;
L32:
    ;
    t287 = P + 14;
    t288 = Stack[(int)t287];
    t289 = t288 + 1;
    Stack[(int)t287] = t289;
    goto L31;
L33:
    ;
    t290 = P + 3;
    t291 = Stack[(int)t290];
    t292 = t291 == 0;
    if (!(t292)) goto L36;
    t293 = H;
    Heap[(int)H] = 78;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t293);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    goto L37;
L36:
    ;
    t294 = H;
    Heap[(int)H] = 67;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t294);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t295 = P + 3;
    t296 = Stack[(int)t295];
    printf("%g\n", (double)(t296));
    t297 = H;
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
        int __pos = (int)(t297);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t298 = P + 10;
    t299 = Stack[(int)t298];
    t300 = P + 3;
    t301 = Stack[(int)t300];
    t302 = P + 16;
    t303 = t302 + 1;
    Stack[(int)t303] = t299;
    t304 = t302 + 2;
    Stack[(int)t304] = t301;
    P = P + 16;
    sumarArreglo();
    t305 = P + 0;
    t306 = Stack[(int)t305];
    P = P - 16;
    {
        char __buffer[64];
        double __valor = (double)(t306);
        snprintf(__buffer, sizeof(__buffer), "%.15g", __valor);
        fputs(__buffer, stdout);
        if (isfinite(__valor) && strchr(__buffer, '.') == NULL
                && strchr(__buffer, 'e') == NULL
                && strchr(__buffer, 'E') == NULL) fputs(".0", stdout);
        putchar('\n');
    }
    t307 = H;
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
        int __pos = (int)(t307);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t308 = P + 10;
    t309 = Stack[(int)t308];
    t310 = P + 3;
    t311 = Stack[(int)t310];
    t312 = P + 16;
    t313 = t312 + 1;
    Stack[(int)t313] = t309;
    t314 = t312 + 2;
    Stack[(int)t314] = t311;
    P = P + 16;
    maximoArreglo();
    t315 = P + 0;
    t316 = Stack[(int)t315];
    P = P - 16;
    {
        char __buffer[64];
        double __valor = (double)(t316);
        snprintf(__buffer, sizeof(__buffer), "%.15g", __valor);
        fputs(__buffer, stdout);
        if (isfinite(__valor) && strchr(__buffer, '.') == NULL
                && strchr(__buffer, 'e') == NULL
                && strchr(__buffer, 'E') == NULL) fputs(".0", stdout);
        putchar('\n');
    }
    t317 = H;
    Heap[(int)H] = 80;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 105;
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
        int __pos = (int)(t317);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t318 = P + 10;
    t319 = Stack[(int)t318];
    t320 = P + 3;
    t321 = Stack[(int)t320];
    t322 = P + 16;
    t323 = t322 + 1;
    Stack[(int)t323] = t319;
    t324 = t322 + 2;
    Stack[(int)t324] = t321;
    P = P + 16;
    sumarArreglo();
    t325 = P + 0;
    t326 = Stack[(int)t325];
    P = P - 16;
    t327 = P + 3;
    t328 = Stack[(int)t327];
    t329 = t326 / t328;
    {
        char __buffer[64];
        double __valor = (double)(t329);
        snprintf(__buffer, sizeof(__buffer), "%.15g", __valor);
        fputs(__buffer, stdout);
        if (isfinite(__valor) && strchr(__buffer, '.') == NULL
                && strchr(__buffer, 'e') == NULL
                && strchr(__buffer, 'E') == NULL) fputs(".0", stdout);
        putchar('\n');
    }
L37:
    ;
    goto L30;
L29:
    ;
    t330 = P + 0;
    t331 = Stack[(int)t330];
    t332 = t331 == 11;
    if (!(t332)) goto L38;
    t333 = P + 12;
    t334 = Stack[(int)t333];
    t335 = P + 16;
    t336 = t335 + 1;
    Stack[(int)t336] = t334;
    P = P + 16;
    mostrarHistorial();
    P = P - 16;
    t337 = H;
    Heap[(int)H] = 80;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 105;
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
    Heap[(int)H] = 104;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t337);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t338 = P + 12;
    t339 = Stack[(int)t338];
    t340 = P + 16;
    t341 = t340 + 1;
    Stack[(int)t341] = t339;
    P = P + 16;
    promedioHistorial();
    t342 = P + 0;
    t343 = Stack[(int)t342];
    P = P - 16;
    {
        char __buffer[64];
        double __valor = (double)(t343);
        snprintf(__buffer, sizeof(__buffer), "%.15g", __valor);
        fputs(__buffer, stdout);
        if (isfinite(__valor) && strchr(__buffer, '.') == NULL
                && strchr(__buffer, 'e') == NULL
                && strchr(__buffer, 'E') == NULL) fputs(".0", stdout);
        putchar('\n');
    }
    goto L39;
L38:
    ;
    t344 = P + 0;
    t345 = Stack[(int)t344];
    t346 = t345 == 12;
    if (!(t346)) goto L40;
    t347 = H;
    Heap[(int)H] = 73;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 110;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t347);
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
                t348 = 0;
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
                t348 = (double)__valor;
                break;
            }
            printf("Entrada invalida. Ingrese un entero: "
            );
            fflush(stdout);
        }
    }
    t349 = P + 1;
    Stack[(int)t349] = t348;
    t350 = H;
    Heap[(int)H] = 68;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 105;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t350);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t351 = P + 1;
    t352 = Stack[(int)t351];
    t353 = P + 16;
    t354 = t353 + 1;
    Stack[(int)t354] = t352;
    P = P + 16;
    contarDigitos();
    t355 = P + 0;
    t356 = Stack[(int)t355];
    P = P - 16;
    printf("%g\n", (double)(t356));
    t357 = H;
    Heap[(int)H] = 83;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 109;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
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
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 104;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t357);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t358 = P + 1;
    t359 = Stack[(int)t358];
    printf("%g\n", (double)(t359));
    t360 = H;
    Heap[(int)H] = 58;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t360);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t361 = P + 1;
    t362 = Stack[(int)t361];
    t363 = P + 16;
    t364 = t363 + 1;
    Stack[(int)t364] = t362;
    P = P + 16;
    sumaImpares();
    t365 = P + 0;
    t366 = Stack[(int)t365];
    P = P - 16;
    printf("%g\n", (double)(t366));
    goto L41;
L40:
    ;
    t367 = H;
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
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 99;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 100;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 114;
    H = H + 1;
    Heap[(int)H] = 97;
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
        int __pos = (int)(t367);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
L41:
    ;
L39:
    ;
L30:
    ;
L28:
    ;
L24:
    ;
L17:
    ;
L13:
    ;
L11:
    ;
L9:
    ;
L4:
    ;
    t368 = P + 0;
    t369 = Stack[(int)t368];
    t370 = t369 != 0;
    if (!(t370)) goto L5;
    goto L3;
L5:
    ;
    t371 = H;
    Heap[(int)H] = 72;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 115;
    H = H + 1;
    Heap[(int)H] = 116;
    H = H + 1;
    Heap[(int)H] = 97;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = 108;
    H = H + 1;
    Heap[(int)H] = 117;
    H = H + 1;
    Heap[(int)H] = 101;
    H = H + 1;
    Heap[(int)H] = 103;
    H = H + 1;
    Heap[(int)H] = 111;
    H = H + 1;
    Heap[(int)H] = 44;
    H = H + 1;
    Heap[(int)H] = 32;
    H = H + 1;
    Heap[(int)H] = -1;
    H = H + 1;
    {
        int __pos = (int)(t371);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
    t372 = P + 8;
    t373 = Stack[(int)t372];
    {
        int __pos = (int)(t373);
        while ((int)Heap[__pos] != -1) {
            putchar((char)((int)Heap[__pos]));
            __pos++;
        }
        putchar('\n');
    }
}

int main() {
    P = 0;
    H = 0;
    main_pig();
    return 0;
}
