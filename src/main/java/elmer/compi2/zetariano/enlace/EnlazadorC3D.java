
package elmer.compi2.zetariano.enlace;

import elmer.compi2.zetariano.codegen.Instruction;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;


public class EnlazadorC3D {

    private final List<List<Instruction>> modulosY;
    private final List<List<Instruction>> modulosZ;

    private List<Instruction> moduloPig;

    private final List<String> errores;

    public EnlazadorC3D() {

        this.modulosY = new ArrayList<>();
        this.modulosZ = new ArrayList<>();

        this.moduloPig = new ArrayList<>();

        this.errores = new ArrayList<>();
    }

    // --------------------
    // AGREGAR MODULO Y
    // --------------------
    public void agregarModuloY(
            List<Instruction> modulo) {

        if (modulo == null) {
            return;
        }

        modulosY.add(
                new ArrayList<>(modulo)
        );
    }

    // --------------------
    // AGREGAR MODULO Z
    // --------------------
    public void agregarModuloZ(
            List<Instruction> modulo) {

        if (modulo == null) {
            return;
        }

        modulosZ.add(
                new ArrayList<>(modulo)
        );
    }

    // --------------------
    // ESTABLECER PIG
    // --------------------
    public void establecerModuloPig(
            List<Instruction> modulo) {

        this.moduloPig
                = modulo == null
                        ? new ArrayList<>()
                        : new ArrayList<>(modulo);
    }

    // --------------------
    // ENLAZAR
    // --------------------
    public List<Instruction> enlazar() {

        errores.clear();

        List<Instruction> combinado
                = new ArrayList<>();

        
        // 1. Y
        
        for (List<Instruction> modulo
                : modulosY) {

            copiarModulo(
                    modulo,
                    combinado
            );
        }

        
        // 2. Z
        
        for (List<Instruction> modulo
                : modulosZ) {

            copiarModulo(
                    modulo,
                    combinado
            );
        }

        
        // 3. PIG
        //
        // main_ping ptEntrada final
        
        copiarModulo(
                moduloPig,
                combinado
        );

        
        // 4. VALIDAR FUNCIONES
        
        validarFunciones(
                combinado
        );

        return combinado;
    }

    // --------------------
    // COPIAR Y NORMALIZAR MODULO
    // --------------------
    private void copiarModulo(
            List<Instruction> origen,
            List<Instruction> destino) {

        if (origen == null) {
            return;
        }

        for (Instruction cuadruplo
                : origen) {

            if (cuadruplo == null) {
                continue;
            }

            destino.add(
                    normalizarInstruction(
                            cuadruplo
                    )
            );
        }
    }

    // --------------------
    // NORMALIZAR CUADRUPLO
    // --------------------
    private Instruction normalizarInstruction(
            Instruction original) {

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

            return new Instruction(
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

            return new Instruction(
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

            return new Instruction(
                    operador,
                    argumento1,
                    null,
                    etiqueta
            );
        }

        
        // RESTO
        
        return new Instruction(
                operador,
                argumento1,
                argumento2,
                resultado
        );
    }

    // --------------------
    // VALIDACION DE FUNCIONES
    // --------------------
    private void validarFunciones(
            List<Instruction> cuadruplos) {

        Set<String> funciones
                = new LinkedHashSet<>();

        Set<String> llamadas
                = new LinkedHashSet<>();

        
        // RECOLECTAR
        
        for (Instruction cuadruplo
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

        
        // VERIFICAR CALLS
        
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

        
        // VERIFICAR MAIN PIG
        
        if (!funciones.contains(
                "main_pig")) {

            errores.add(
                    "No se encontro la funcion de entrada main_pig."
            );
        }
    }

    // --------------------
    // UTILIDADES
    // --------------------
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

    // --------------------
    // ERRORES
    // --------------------
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
