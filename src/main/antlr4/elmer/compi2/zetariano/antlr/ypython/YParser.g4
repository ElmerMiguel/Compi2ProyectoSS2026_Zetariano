parser grammar YParser;

options {
    tokenVocab = YLexer;
}



// ============================================================
// PROGRAMA
// ============================================================

programa
    : NEWLINE*
    seccionEstructuras?
    NEWLINE*
    seccionFunciones
    NEWLINE*
    EOF
    ;


// ============================================================
// SECCIÓN DE ESTRUCTURAS
// ============================================================

seccionEstructuras
    : ESTRUCTURAS
    NEWLINE+
    (
    definicionEstructura
    NEWLINE*
    )*
    ;


// ============================================================
// ESTRUCTURAS
// ============================================================

definicionEstructura
    : ESTRUCTURA
    IDENTIFICADOR
    DOS_PUNTOS
    NEWLINE
    INDENT
    (
    atributoEstructura
    |
    NEWLINE
    )+
    DEDENT
    ;


atributoEstructura
    : tipo
    IDENTIFICADOR
    dimensionConstante*
    NEWLINE
    ;


dimensionConstante
    : CORCHETE_IZQ
    ENTERO
    CORCHETE_DER
    ;


// ============================================================
// SECCIÓN DE FUNCIONES
// ============================================================

seccionFunciones
    : FUNCIONES
    NEWLINE+
    (
    definicionFuncion
    NEWLINE*
    )+
    ;


// ============================================================
// FUNCIONES
// ============================================================

definicionFuncion
    : DEFINIR
    IDENTIFICADOR
    PARENTESIS_IZQ
    parametros?
    PARENTESIS_DER
    retornoFuncion?
    DOS_PUNTOS
    NEWLINE+
    INDENT
    bloqueFuncion
    DEDENT
    ;


retornoFuncion
    : FLECHA
    tipo
    ;


// ============================================================
// PARÁMETROS
// ============================================================

parametros
    : parametro
    (
    COMA
    parametro
    )*
    ;


parametro
    : parametroValor
    | parametroArreglo
    | parametroEstructura
    ;


parametroValor
    : tipoPrimitivo
    IDENTIFICADOR
    ;


parametroArreglo
    : CORCHETE_IZQ
    CORCHETE_DER
    tipo
    IDENTIFICADOR
    ;


parametroEstructura
    : LLAVE_IZQ
    LLAVE_DER
    IDENTIFICADOR
    IDENTIFICADOR
    ;


// ============================================================
// BLOQUES
// ============================================================

bloqueFuncion
    : (
        definicionEstructura
        |
        sentencia
        |
        NEWLINE
      )+
    ;

bloque
    : NEWLINE+
    INDENT
    (
    sentencia
    |
    NEWLINE
    )+
    DEDENT
    ;


// ============================================================
// SENTENCIAS
// ============================================================

sentencia
    : declaracionVariable NEWLINE
    | asignacion NEWLINE
    | retorno NEWLINE
    | llamadaFuncion NEWLINE
    | incrementoDecremento NEWLINE
    | impresion NEWLINE
    | lectura NEWLINE
    | sentenciaSi
    | sentenciaElegir
    | sentenciaMientras
    | sentenciaHacerMientras
    | sentenciaPara
    | CONTINUAR NEWLINE
    | ROMPER NEWLINE
    ;

// ============================================================
// CONDICIONAL SI
// ============================================================

sentenciaSi
    : SI
    PARENTESIS_IZQ
    expresion
    PARENTESIS_DER
    ENTONCES
    bloque
    bloqueSino*
    bloqueContrario?
    ;

bloqueSino
    : SINO
    PARENTESIS_IZQ
    expresion
    PARENTESIS_DER
    ENTONCES
    bloque
    ;

bloqueContrario
    : CONTRARIO
    bloque
    ;

// ============================================================
// ELEGIR / CASO / SIEMPRE
// ============================================================

sentenciaElegir
    : ELEGIR
    PARENTESIS_IZQ
    expresion
    PARENTESIS_DER
    DOS_PUNTOS
    NEWLINE+
    INDENT
    casoElegir+
    siempreElegir?
    DEDENT
    ;


casoElegir
    : CASO
    expresion
    DOS_PUNTOS
    bloque
    ;


siempreElegir
    : SIEMPRE
    DOS_PUNTOS
    bloque
    ;

// ============================================================
// WHILE
// ============================================================

sentenciaMientras
    : MIENTRAS
    PARENTESIS_IZQ
    expresion
    PARENTESIS_DER
    HACER
    bloque
    ;


// ============================================================
// DO-WHILE
// ============================================================

sentenciaHacerMientras
    : HACER
    DOS_PUNTOS
    bloque
    MIENTRAS
    PARENTESIS_IZQ
    expresion
    PARENTESIS_DER
    NEWLINE
    ;


// ============================================================
// FOR
// ============================================================

sentenciaPara
    : PARA
    PARENTESIS_IZQ
    inicializacionPara?
    PUNTO_COMA
    expresion?
    PUNTO_COMA
    actualizacionPara?
    PARENTESIS_DER
    DOS_PUNTOS
    bloque
    ;


inicializacionPara
    : declaracionVariable
    | asignacion
    ;


actualizacionPara
    : asignacion
    | incrementoDecremento
    ;


incrementoDecremento
    : acceso (INCREMENTO | DECREMENTO)
    ;

// ============================================================
// VARIABLES
// ============================================================

declaracionVariable
    : tipo
      IDENTIFICADOR
      dimensiones*
      (
          ASIGNACION
          inicializador
      )?
    ;

dimensiones
    : CORCHETE_IZQ
    expresion
    CORCHETE_DER
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
      NEWLINE*
      INDENT?
      (
          inicializador
          (
              COMA
              NEWLINE*
              inicializador
          )*
      )?
      NEWLINE*
      DEDENT?
      LLAVE_DER
    ;

// ============================================================
// ASIGNACIONES
// ============================================================

asignacion
    : acceso
    ASIGNACION
    expresion
    ;


// ============================================================
// RETORNO
// ============================================================

retorno
    : RETORNAR
    expresion
    ;


// ============================================================
// IMPRESIÓN
// ============================================================

impresion
    : IMPRIMIR
    PARENTESIS_IZQ
    argumentos?
    PARENTESIS_DER
    ;

// ============================================================
// LECTURA
// ============================================================

lectura
    : LEER
    PARENTESIS_IZQ
    PARENTESIS_DER
    ;

// ============================================================
// LLAMADAS
// ============================================================

llamadaFuncion
    : IDENTIFICADOR
    PARENTESIS_IZQ
    argumentos?
    PARENTESIS_DER
    ;


argumentos
    : expresion
    (
    COMA
    expresion
    )*
    ;


// ============================================================
// EXPRESIONES
// ============================================================

expresion
    : expresionOr
    ;


expresionOr
    : expresionAnd
    (
    OR
    expresionAnd
    )*
    ;


expresionAnd
    : expresionIgualdad
    (
    AND
    expresionIgualdad
    )*
    ;


expresionIgualdad
    : expresionRelacional
    (
    (
    IGUAL_IGUAL
    |
    DIFERENTE
    )
    expresionRelacional
    )*
    ;


expresionRelacional
    : expresionAditiva
    (
    (
    MENOR
    |
    MAYOR
    )
    expresionAditiva
    )*
    ;


expresionAditiva
    : expresionMultiplicativa
    (
    (
    MAS
    |
    MENOS
    )
    expresionMultiplicativa
    )*
    ;


expresionMultiplicativa
    : expresionUnaria
    (
    (
    MULTIPLICACION
    |
    DIVISION
    )
    expresionUnaria
    )*
    ;


expresionUnaria
    : NOT
    expresionUnaria
    
    | MENOS
    expresionUnaria
    
    | expresionPrimaria
    ;


expresionPrimaria
    : ENTERO
    | DECIMAL
    | CADENA
    | CARACTER
    | VERDADERO
    | FALSO
    
    | acceso
    
    | llamadaFuncion
    
    | lectura
    
    | PARENTESIS_IZQ
    expresion
    PARENTESIS_DER
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
    ;

// ============================================================
// TIPOS
// ============================================================

tipo
    : tipoPrimitivo
    | IDENTIFICADOR
    ;


tipoPrimitivo
    : TIPO_ENTERO
    | TIPO_FLOTANTE
    | TIPO_CADENA
    | TIPO_CARACTER
    | TIPO_BOOL
    ;