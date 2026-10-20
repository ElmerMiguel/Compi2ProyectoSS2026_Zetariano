parser grammar ZParser;

options {
    tokenVocab = ZLexer;
}



// ============================================================
// PROGRAMA
// ============================================================

programa
    : definicionClase EOF
    ;

// ============================================================
// CLASE
// ============================================================

definicionClase
    : PUBLIC CLASS IDENTIFICADOR
      LLAVE_IZQ
      miembroClase*
      LLAVE_DER
    ;

miembroClase
    : atributo
    | constructor
    | metodo
    ;

// ============================================================
// ATRIBUTOS
// ============================================================

atributo
    : tipo dimensionesParametro*
      IDENTIFICADOR dimensiones*
      (ASIGNACION inicializador)?
      PUNTO_COMA
    ;

// ============================================================
// CONSTRUCTOR
// ============================================================

constructor
    : PUBLIC IDENTIFICADOR
      PAREN_IZQ
      listaParametros?
      PAREN_DER
      bloque
    ;

// ============================================================
// DECLARACION DE VARIABLES
// ============================================================

declaracionVariable
    : tipo dimensionesParametro*
      IDENTIFICADOR dimensiones*
      (ASIGNACION inicializador)?
      PUNTO_COMA
    ;

// ============================================================
// METODOS
// ============================================================

metodo
    : PUBLIC tipoRetorno IDENTIFICADOR
      PAREN_IZQ
      listaParametros?
      PAREN_DER
      bloque
    ;

tipoRetorno
    : tipo
    | VOID
    ;

// ============================================================
// PARAMETROS
// ============================================================

listaParametros
    : parametro
      (COMA parametro)*
    ;

parametro
    : tipo dimensionesParametro* IDENTIFICADOR
    ;

dimensionesParametro
    : CORCHETE_IZQ CORCHETE_DER
    ;

// ============================================================
// TIPOS
// ============================================================

tipo
    : tipoPrimitivo
    | IDENTIFICADOR
    ;

tipoPrimitivo
    : INT
    | DOUBLE
    | STRING
    | CHAR
    | BOOLEAN
    ;

// ============================================================
// BLOQUES
// ============================================================

bloque
    : LLAVE_IZQ
      sentencia*
      LLAVE_DER
    ;

// ============================================================
// SENTENCIAS
// ============================================================

sentencia
    : declaracionVariable
    | asignacion
    | incrementoDecremento
    | sentenciaReturn
    | sentenciaIf
    | sentenciaSwitch
    | sentenciaFor
    | sentenciaWhile
    | sentenciaDoWhile
    | BREAK PUNTO_COMA
    | CONTINUE PUNTO_COMA
    | llamadaMetodo PUNTO_COMA
    | llamadaMetodoObjeto PUNTO_COMA
    | impresion PUNTO_COMA
    | bloque
    ;

// ============================================================
// IF / ELSE IF / ELSE
// ============================================================

sentenciaIf
    : IF PAREN_IZQ expresion PAREN_DER
      cuerpoControl
      (
          ELSE IF PAREN_IZQ expresion PAREN_DER
          cuerpoControl
      )*
      (
          ELSE cuerpoControl
      )?
    ;

cuerpoControl
    : bloque
    | sentencia
    ;

// ============================================================
// SWITCH
// ============================================================

sentenciaSwitch
    : SWITCH PAREN_IZQ expresion PAREN_DER
      LLAVE_IZQ
      bloqueCase*
      bloqueDefault?
      LLAVE_DER
    ;

bloqueCase
    : CASE expresion DOS_PUNTOS
      sentencia*
    ;

bloqueDefault
    : DEFAULT DOS_PUNTOS
      sentencia*
    ;

// ============================================================
// FOR
// ============================================================

sentenciaFor
    : FOR PAREN_IZQ
      inicializacionFor?
      PUNTO_COMA
      expresion?
      PUNTO_COMA
      actualizacionFor?
      PAREN_DER
      cuerpoControl
    ;

inicializacionFor
    : tipo IDENTIFICADOR ASIGNACION expresion
    | acceso operadorAsignacion expresion
    ;

actualizacionFor
    : acceso INCREMENTO
    | acceso DECREMENTO
    | acceso operadorAsignacion expresion
    ;

// ============================================================
// WHILE
// ============================================================

sentenciaWhile
    : WHILE PAREN_IZQ expresion PAREN_DER
      cuerpoControl
    ;

// ============================================================
// DO-WHILE
// ============================================================

sentenciaDoWhile
    : DO
      cuerpoControl
      WHILE PAREN_IZQ expresion PAREN_DER
      PUNTO_COMA
    ;

// ============================================================
// ASIGNACION
// ============================================================

asignacion
    : acceso
      operadorAsignacion
      expresion
      PUNTO_COMA
    ;

operadorAsignacion
    : ASIGNACION
    | MAS_IGUAL
    | MENOS_IGUAL
    | POR_IGUAL
    ;

// ============================================================
// INCREMENTO / DECREMENTO
// ============================================================

incrementoDecremento
    : acceso
      (INCREMENTO | DECREMENTO)
      PUNTO_COMA
    ;

// ============================================================
// RETURN
// ============================================================

sentenciaReturn
    : RETURN expresion? PUNTO_COMA
    ;

// ============================================================
// IMPRESION
// ============================================================

impresion
    : PRINTLN
      PAREN_IZQ
      expresion?
      PAREN_DER
    | PRINT
      PAREN_IZQ
      expresion?
      PAREN_DER
    ;

// ============================================================
// INICIALIZADORES
// ============================================================

inicializador
    : expresion
    | inicializadorLista
    ;

inicializadorLista
    : LLAVE_IZQ
      (
          inicializador
          (COMA inicializador)*
      )?
      LLAVE_DER
    ;

// ============================================================
// EXPRESIONES
// ============================================================

expresion
    : expresionOr
      (
          TERNARIO expresion
          DOS_PUNTOS expresion
      )?
    ;

expresionOr
    : expresionOr OR expresionAnd
    | expresionAnd
    ;

expresionAnd
    : expresionAnd AND expresionIgualdad
    | expresionIgualdad
    ;

expresionIgualdad
    : expresionIgualdad
      (IGUAL_IGUAL | DIFERENTE)
      expresionRelacional
    | expresionRelacional
    ;

expresionRelacional
    : expresionRelacional
      (MAYOR | MENOR | MAYOR_IGUAL | MENOR_IGUAL)
      expresionAditiva
    | expresionAditiva
    ;

expresionAditiva
    : expresionAditiva
      (MAS | MENOS)
      expresionMultiplicativa
    | expresionMultiplicativa
    ;

expresionMultiplicativa
    : expresionMultiplicativa
      (POR | DIV | MOD)
      expresionUnaria
    | expresionUnaria
    ;

expresionUnaria
    : NOT expresionUnaria
    | MENOS expresionUnaria
    | primario
    ;

// ============================================================
// PRIMARIOS
// ============================================================

primario
    : literal
    | acceso
    | llamadaMetodo
    | creacionObjeto
    | creacionArreglo
    | READLN PAREN_IZQ PAREN_DER
    | PAREN_IZQ expresion PAREN_DER
    ;

//======================================
// CREACION DE ARREGLOS
//=======================================
creacionArreglo
    : NEW tipo dimensionCreacion+
    ;

dimensionCreacion
    : CORCHETE_IZQ expresion CORCHETE_DER
    ;

// ============================================================
// ACCESOS
// ============================================================

acceso
    : IDENTIFICADOR sufijoAcceso*
    ;

sufijoAcceso
    : PUNTO IDENTIFICADOR
    | PUNTO IDENTIFICADOR
      PAREN_IZQ
      listaArgumentos?
      PAREN_DER
    | CORCHETE_IZQ expresion CORCHETE_DER
    ;

// ============================================================
// LLAMADAS
// ============================================================

llamadaMetodo
    : IDENTIFICADOR
      PAREN_IZQ
      listaArgumentos?
      PAREN_DER
    ;

listaArgumentos
    : expresion
      (COMA expresion)*
    ;

// ============================================================
// LLAMADA A METODO DE UN OBJETO
// ============================================================

llamadaMetodoObjeto
    : IDENTIFICADOR
      sufijoObjeto*
      PUNTO IDENTIFICADOR
      PAREN_IZQ
      listaArgumentos?
      PAREN_DER
    ;

sufijoObjeto
    : PUNTO IDENTIFICADOR
    | CORCHETE_IZQ expresion CORCHETE_DER
    ;

// ============================================================
// OBJETOS
// ============================================================

creacionObjeto
    : NEW IDENTIFICADOR
      PAREN_IZQ
      listaArgumentos?
      PAREN_DER
    ;

// ============================================================
// DIMENSIONES
// ============================================================

dimensiones
    : CORCHETE_IZQ expresion? CORCHETE_DER
    ;

// ============================================================
// LITERALES
// ============================================================

literal
    : ENTERO
    | DECIMAL
    | CADENA
    | CARACTER
    | TRUE
    | FALSE
    | NULL
    ;