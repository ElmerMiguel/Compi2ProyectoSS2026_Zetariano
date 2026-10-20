package elmer.compi2.zetariano.codegen;

/**
 * Representacion de una instruccion de Codigo de Tres Direcciones (Cuarteto).
 * Extiende de {@link Instruction} para interoperabilidad.
 */
public class Cuadruplo extends Instruction {

    public Cuadruplo(
            String operador,
            String argumento1,
            String argumento2,
            String resultado) {
        super(operador, argumento1, argumento2, resultado);
    }
}
