/*
 */
package elmer.compi2.zetariano.imports;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */
public class MetodoImportadoPig {

    private final String nombre;
    private final String firma;
    private final String tipoRetorno;

    private final List<String> tiposParametros;

    private final boolean constructor;
    private String clasePropietaria;

    public MetodoImportadoPig(
            String nombre,
            String firma,
            String tipoRetorno,
            List<String> tiposParametros,
            boolean constructor) {

        this(nombre, firma, tipoRetorno, tiposParametros, constructor, null);
    }

    public MetodoImportadoPig(
            String nombre,
            String firma,
            String tipoRetorno,
            List<String> tiposParametros,
            boolean constructor,
            String clasePropietaria) {

        this.nombre = nombre;
        this.firma = firma;
        this.tipoRetorno = tipoRetorno;

        this.tiposParametros
                = tiposParametros == null
                        ? new ArrayList<>()
                        : new ArrayList<>(tiposParametros);

        this.constructor = constructor;
        this.clasePropietaria = clasePropietaria;
    }

    public String getNombre() {
        return nombre;
    }

    public String getFirma() {
        return firma;
    }

    public String getTipoRetorno() {
        return tipoRetorno;
    }

    public List<String> getTiposParametros() {
        return Collections.unmodifiableList(
                tiposParametros
        );
    }

    public boolean esConstructor() {
        return constructor;
    }

    public String getClasePropietaria() {
        return clasePropietaria;
    }

    public void setClasePropietaria(String clasePropietaria) {
        this.clasePropietaria = clasePropietaria;
    }

    public String getFirmaEnlace() {
        if (constructor
                || clasePropietaria == null
                || clasePropietaria.isBlank()) {
            return firma;
        }
        return clasePropietaria + "." + firma;
    }

    @Override
    public String toString() {

        return "MetodoImportadoPig{"
                + "firma='" + firma + '\''
                + ", retorno='" + tipoRetorno + '\''
                + ", constructor=" + constructor
                + '}';
    }
}
