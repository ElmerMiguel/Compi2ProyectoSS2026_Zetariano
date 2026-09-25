parser grammar PigLatinParser;

options {
    tokenVocab = PigLatinLexer;
}



// ============================================================
// PROGRAMA
// ============================================================

programa
    : importacion*
      seccionVariables?
      seccionPrincipal
      EOF
    ;

// ============================================================
// IMPORTACIONES
// ============================================================

importacion
    : IMPORT rutaImportacion
    ;

rutaImportacion
    : IDENTIFICADOR
      (PUNTO IDENTIFICADOR)*
    ;

// ============================================================
// SECCION DE VARIABLES GLOBALES
// ============================================================

seccionVariables
    : VARIABILES MAYOR
      declaracionGlobal*
    ;

declaracionGlobal
    : declaracionVariable
    | declaracionArreglo
    ;

// ============================================================
// SECCION PRINCIPAL
// ============================================================

seccionPrincipal
    : MAIOR MAYOR
      sentencia*
      FINIS PUNTO_COMA
    ;

// ============================================================
// SENTENCIAS
// ============================================================

sentencia
    : declaracionVariable
    | declaracionArreglo
    | asignacion
    | incrementoDecremento
    | llamadaSentencia
    | lectura
    | escritura
    | sentenciaSi
    | sentenciaDum
    | sentenciaFacere
    | sentenciaPer
    | PERGE PUNTO_COMA
    | INTERRUMPE PUNTO_COMA
    ;

// ============================================================
// DECLARACION VARIABLE
// ============================================================

declaracionVariable
    : ESTO IDENTIFICADOR DOS_PUNTOS tipo inicializacionVariable? PUNTO_COMA
    ;

inicializacionVariable
    : expresion
    | inicializadorEstructura
    ;

// ============================================================
// DECLARACION ARREGLO
// ============================================================

declaracionArreglo
    : SERIES IDENTIFICADOR dimensionesDeclaracion DOS_PUNTOS tipo
      inicializadorArreglo?
      PUNTO_COMA
    ;

dimensionesDeclaracion
    : dimensionDeclaracion+
    ;

dimensionDeclaracion
    : CORCHETE_IZQ ENTERO CORCHETE_DER
    ;

inicializadorArreglo
    : inicializadorLista
    ;

// ============================================================
// TIPOS
// ============================================================

tipo
    : NUMERUS
    | TEXTUM
    | DECIMALIS
    | LITTERA
    | VERUM
    | FALSUS
    | IDENTIFICADOR
    ;

// ============================================================
// ASIGNACION
// ============================================================

asignacion
    : acceso IGUAL expresion PUNTO_COMA
    ;

// ============================================================
// INCREMENTO / DECREMENTO
// ============================================================

incrementoDecremento
    : acceso INCREMENTO PUNTO_COMA
    | acceso DECREMENTO PUNTO_COMA
    ;

// ============================================================
// LLAMADA COMO SENTENCIA
// ============================================================

llamadaSentencia
    : llamada PUNTO_COMA
    ;

// ============================================================
// ENTRADA
// ============================================================

lectura
    : LECTURA PUNTO_COMA
    | acceso LECTURA PUNTO_COMA
    ;

// ============================================================
// SALIDA
// ============================================================

escritura
    : ESCRITURA expresion
      (ESCRITURA expresion)*
      PUNTO_COMA
    ;

// ============================================================
// IF / ELSE IF / ELSE
// ============================================================

sentenciaSi
    : SI PARENTESIS_IZQ expresion PARENTESIS_DER
      bloque
      (
          ALITER PARENTESIS_IZQ expresion PARENTESIS_DER
          bloque
      )*
      (
          ALITER bloque
      )?
      FINIS_BLOQUE PUNTO_COMA
    ;

// ============================================================
// WHILE
// ============================================================

sentenciaDum
    : DUM PARENTESIS_IZQ expresion PARENTESIS_DER
      bloque
      FINIS_BLOQUE PUNTO_COMA
    ;

// ============================================================
// DO WHILE
// ============================================================

sentenciaFacere
    : FACERE
      bloque
      DUM PARENTESIS_IZQ expresion PARENTESIS_DER
      PUNTO_COMA
    ;

// ============================================================
// FOR
// ============================================================

sentenciaPer
    : PER PARENTESIS_IZQ
      inicializacionPer
      PUNTO_COMA
      expresion
      PUNTO_COMA
      actualizacionPer
      PARENTESIS_DER
      bloque
    ;

inicializacionPer
    : ESTO IDENTIFICADOR DOS_PUNTOS tipo expresion
    | acceso IGUAL expresion
    ;

actualizacionPer
    : acceso INCREMENTO
    | acceso DECREMENTO
    | acceso IGUAL expresion
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
// ACCESOS
// ============================================================

acceso
    : IDENTIFICADOR sufijoAcceso*
    ;

sufijoAcceso
    : CORCHETE_IZQ expresion CORCHETE_DER
    | PUNTO IDENTIFICADOR
    | PUNTO IDENTIFICADOR
      PARENTESIS_IZQ listaArgumentos? PARENTESIS_DER
    ;

// ============================================================
// LLAMADAS
// ============================================================

llamada
    : IDENTIFICADOR
      PARENTESIS_IZQ listaArgumentos? PARENTESIS_DER
    | acceso
    ;

listaArgumentos
    : expresion
      (COMA expresion)*
    ;

// ============================================================
// CREACION DE OBJETO
// ============================================================

creacionObjeto
    : NOVUS IDENTIFICADOR
      PARENTESIS_IZQ listaArgumentos? PARENTESIS_DER
    ;

// ============================================================
// INICIALIZADORES
// ============================================================

inicializadorEstructura
    : LLAVE_IZQ
      listaInicializacion?
      LLAVE_DER
    ;

inicializadorLista
    : LLAVE_IZQ
      listaInicializacion?
      LLAVE_DER
    ;

listaInicializacion
    : valorInicializacion
      (COMA valorInicializacion)*
    ;

valorInicializacion
    : expresion
    | inicializadorLista
    ;

// ============================================================
// EXPRESIONES
// ============================================================

expresion
    : expresionOr
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
      (MENOR | MAYOR | MENOR_IGUAL | MAYOR_IGUAL)
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
      (MULTIPLICACION | DIVISION | MODULO)
      expresionUnaria
    | expresionUnaria
    ;

expresionUnaria
    : NOT expresionUnaria
    | NON expresionUnaria
    | MENOS expresionUnaria
    | primario
    ;

primario
    : literal
    | creacionObjeto
    | llamada
    | PARENTESIS_IZQ expresion PARENTESIS_DER
    ;

// ============================================================
// LITERALES
// ============================================================

literal
    : ENTERO
    | DECIMAL
    | CADENA
    | CARACTER
    | VERUM
    | FALSUS
    ;