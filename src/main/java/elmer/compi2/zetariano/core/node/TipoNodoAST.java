/*
 */
package elmer.compi2.zetariano.core.node;

/**
 *
 */
public enum TipoNodoAST {

    // ============================================================
    // PROGRAMA
    // ============================================================
    PROGRAMA,
    SECCION_ESTRUCTURAS,
    SECCION_FUNCIONES,
    // ============================================================
    // ESTRUCTURAS
    // ============================================================
    ESTRUCTURA,
    ATRIBUTO_ESTRUCTURA,
    // ============================================================
    // FUNCIONES
    // ============================================================
    FUNCION,
    PARAMETRO,
    TIPO_PARAMETRO,
    MODO_PARAMETRO,
    BLOQUE,
    // ============================================================
    // DECLARACIONES
    // ============================================================
    DECLARACION_VARIABLE,
    DECLARACION_ARREGLO,
    // ============================================================
    // SENTENCIAS
    // ============================================================
    ASIGNACION,
    RETORNO,
    IMPRIMIR,
    LEER,
    IF,
    ELSE,
    WHILE,
    DO_WHILE,
    FOR,
    INICIALIZACION_FOR,
    CONDICION_FOR,
    ACTUALIZACION_FOR,
    ELEGIR,
    CASO,
    SIEMPRE,
    BREAK,
    CONTINUE,
    // ============================================================
    // EXPRESIONES
    // ============================================================
    EXPRESION_BINARIA,
    EXPRESION_UNARIA,
    LLAMADA_FUNCION,
    ACCESO_VARIABLE,
    ACCESO_ATRIBUTO,
    ACCESO_ARREGLO,
    INCREMENTO,
    DECREMENTO,
    // ============================================================
    // LITERALES
    // ============================================================
    LITERAL_ENTERO,
    LITERAL_DECIMAL,
    LITERAL_CADENA,
    LITERAL_CARACTER,
    LITERAL_BOOLEANO,
    // ============================================================
    // INICIALIZADORES
    // ============================================================
    INICIALIZADOR_LISTA,
    // ============================================================
    // AUXILIAR
    // ============================================================
    TIPO_RETORNO,
    OPERADOR,
    DIMENSION,
    LECTURA,
    DESCONOCIDO
}
