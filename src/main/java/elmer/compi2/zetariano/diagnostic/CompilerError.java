package elmer.compi2.zetariano.diagnostic;

public class CompilerError {
    public enum Tipo { LEXICO, SINTACTICO, SEMANTICO }
    private final Tipo tipo;
    private final String mensaje;
    private final int linea;
    private final int columna;

    public CompilerError(Tipo tipo, String mensaje, int linea, int columna) {
        this.tipo = tipo;
        this.mensaje = mensaje;
        this.linea = linea;
        this.columna = columna;
    }
    public Tipo getTipo() { return tipo; }
    public String getMensaje() { return mensaje; }
    public int getLinea() { return linea; }
    public int getColumna() { return columna; }
}
