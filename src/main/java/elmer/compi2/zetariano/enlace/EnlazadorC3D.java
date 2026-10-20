/*
 */
package elmer.compi2.zetariano.enlace;

import elmer.compi2.zetariano.codegen.Cuadruplo;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/**
 *
 */
public class EnlazadorC3D {

    private final List<List<Cuadruplo>> modulosY;
    private final List<List<Cuadruplo>> modulosZ;

    private List<Cuadruplo> moduloPig;

    private final List<String> errores;

    public EnlazadorC3D() {

        this.modulosY = new ArrayList<>();
        this.modulosZ = new ArrayList<>();

        this.moduloPig = new ArrayList<>();

        this.errores = new ArrayList<>();
    }

    // =========================================================
    // AGREGAR MODULO Y
    // =========================================================
    public void agregarModuloY(
            List<Cuadruplo> modulo) {

        if (modulo == null) {
            return;
        }

        modulosY.add(
                new ArrayList<>(modulo)
        );
    }

    // =========================================================
    // AGREGAR MODULO Z
    // =========================================================
    public void agregarModuloZ(
            List<Cuadruplo> modulo) {

        if (modulo == null) {
            return;
        }

        modulosZ.add(
                new ArrayList<>(modulo)
        );
    }

    // =========================================================
    // ESTABLECER PIG
    // =========================================================
    public void establecerModuloPig(
            List<Cuadruplo> modulo) {

        this.moduloPig
                = modulo == null
                        ? new ArrayList<>()
                        : new ArrayList<>(modulo);
    }

    // =========================================================
    // ENLAZAR
    // =========================================================
    public List<Cuadruplo> enlazar() {

        errores.clear();

        List<Cuadruplo> combinado
                = new ArrayList<>();

        // =====================================================
        // 1. Y
        // =====================================================
        for (List<Cuadruplo> modulo
                : modulosY) {

            copiarModulo(
                    modulo,
                    combinado
            );
        }

        // =====================================================
        // 2. Z
        // =====================================================
        for (List<Cuadruplo> modulo
                : modulosZ) {

            copiarModulo(
                    modulo,
                    combinado
            );
        }

        // =====================================================
        // 3. PIG
        //
        // Lo dejamos al final porque main_pig será
        // nuestro punto de entrada final.
        // =====================================================
        copiarModulo(
                moduloPig,
                combinado
        );

        // =====================================================
        // 4. VALIDAR FUNCIONES
        // =====================================================
        validarFunciones(
                combinado
        );

        return combinado;
    }

    // =========================================================
    // COPIAR Y NORMALIZAR MODULO
    // =========================================================
    private void copiarModulo(
            List<Cuadruplo> origen,
            List<Cuadruplo> destino) {

        if (origen == null) {
            return;
        }

        for (Cuadruplo cuadruplo
                : origen) {

            if (cuadruplo == null) {
                continue;
            }

            destino.add(
                    normalizarCuadruplo(
                            cuadruplo
                    )
            );
        }
    }

    // =========================================================
    // NORMALIZAR CUADRUPLO
    // =========================================================
    private Cuadruplo normalizarCuadruplo(
            Cuadruplo original) {

        String operador
                = original.getOperador();

        String argumento1
                = original.getArgumento1();

        String argumento2
                = original.getArgumento2();

        String resultado
                = original.getResultado();

        if ("LABEL".equals(operador)) {

            String etiqueta
                    = primerValorValido(
                            resultado,
                            argumento1
                    );

            return new Cuadruplo(
                    "LABEL",
                    null,
                    null,
                    etiqueta
            );
        }

        if ("GOTO".equals(operador)) {

            String etiqueta
                    = primerValorValido(
                            resultado,
                            argumento1
                    );

            return new Cuadruplo(
                    "GOTO",
                    null,
                    null,
                    etiqueta
            );
        }

        if ("IF_FALSE".equals(operador)
                || "IF_TRUE".equals(operador)) {

            String etiqueta
                    = resultado;

            if (!esEtiqueta(etiqueta)
                    && esEtiqueta(argumento2)) {

                etiqueta = argumento2;
                argumento2 = null;
            }

            return new Cuadruplo(
                    operador,
                    argumento1,
                    null,
                    etiqueta
            );
        }

        // =====================================================
        // RESTO
        // =====================================================
        return new Cuadruplo(
                operador,
                argumento1,
                argumento2,
                resultado
        );
    }

    // =========================================================
    // VALIDACION DE FUNCIONES
    // =========================================================
    private void validarFunciones(
            List<Cuadruplo> cuadruplos) {

        Set<String> funciones
                = new LinkedHashSet<>();

        Set<String> llamadas
                = new LinkedHashSet<>();

        // =====================================================
        // RECOLECTAR
        // =====================================================
        for (Cuadruplo cuadruplo
                : cuadruplos) {

            if (cuadruplo == null) {
                continue;
            }

            String operador
                    = cuadruplo.getOperador();

            if ("FUNC_BEGIN".equals(
                    operador)) {

                String nombre
                        = cuadruplo.getArgumento1();

                if (nombre != null
                        && !nombre.isBlank()) {

                    if (!funciones.add(
                            nombre)) {

                        errores.add(
                                "Funcion duplicada en enlace: "
                                + nombre
                        );
                    }
                }
            }

            if ("CALL".equals(
                    operador)) {

                String destino
                        = cuadruplo.getArgumento1();

                if (destino != null
                        && !destino.isBlank()) {

                    llamadas.add(
                            destino
                    );
                }
            }
        }

        // =====================================================
        // VERIFICAR CALLS
        // =====================================================
        for (String llamada
                : llamadas) {

            if (!funciones.contains(
                    llamada)) {

                errores.add(
                        "CALL sin funcion enlazada: "
                        + llamada
                );
            }
        }

        // =====================================================
        // VERIFICAR MAIN PIG
        // =====================================================
        if (!funciones.contains(
                "main_pig")) {

            errores.add(
                    "No se encontro la funcion de entrada main_pig."
            );
        }
    }

    // =========================================================
    // UTILIDADES
    // =========================================================
    private String primerValorValido(
            String primero,
            String segundo) {

        if (primero != null
                && !primero.isBlank()
                && !"-".equals(primero)) {

            return primero;
        }

        return segundo;
    }

    private boolean esEtiqueta(
            String valor) {

        if (valor == null) {
            return false;
        }

        return valor.matches(
                "L\\d+"
        );
    }

    // =========================================================
    // ERRORES
    // =========================================================
    public boolean tieneErrores() {
        return !errores.isEmpty();
    }

    public List<String> getErrores() {

        return Collections.unmodifiableList(
                errores
        );
    }

    public void imprimirErrores() {

        if (errores.isEmpty()) {

            System.out.println(
                    "Enlace C3D correcto."
            );

            return;
        }

        System.out.println(
                "=== ERRORES DE ENLACE ==="
        );

        for (String error
                : errores) {

            System.out.println(
                    error
            );
        }

        System.out.println(
                "========================="
        );
    }
}
