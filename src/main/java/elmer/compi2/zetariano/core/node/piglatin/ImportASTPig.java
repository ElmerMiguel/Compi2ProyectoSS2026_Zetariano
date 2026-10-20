/*
 */
package elmer.compi2.zetariano.core.node.piglatin;

/**
 *
 */
public class ImportASTPig
        extends NodoASTPig {

    private final String ruta;
    private final String extension;

    public ImportASTPig(
            String ruta,
            String extension,
            int linea,
            int columna) {

        super(
                linea,
                columna
        );

        this.ruta = ruta;
        this.extension = extension;
    }

    public String getRuta() {
        return ruta;
    }

    public String getExtension() {
        return extension;
    }

    public boolean esY() {

        return ".y".equalsIgnoreCase(
                extension
        );
    }

    public boolean esZ() {

        return ".z".equalsIgnoreCase(
                extension
        );
    }

    @Override
    public String generarTexto() {

        return "IMPORT: "
                + ruta
                + extension;
    }

    @Override
    public String toString() {
        return generarTexto();
    }
}
