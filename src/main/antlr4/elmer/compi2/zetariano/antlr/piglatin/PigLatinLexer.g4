lexer grammar PigLatinLexer;



// ***********
// pl reserv - Struc program
// ***********

IMPORT
    : 'import'
    ;

VARIABILES
    : 'VARIABILES'
    ;

MAIOR
    : 'MAIOR'
    ;

FINIS
    : 'FINIS'
    ;

FINIS_BLOQUE
    : 'finis'
    ;

// ***********
// declaraciones
// ***********

ESTO
    : 'esto'
    ;

SERIES
    : 'series'
    ;

NOVUS
    : 'novus'
    ;

// ***********
// tips primitivs
// ***********

NUMERUS
    : 'numerus'
    ;

TEXTUM
    : 'textum'
    ;

DECIMALIS
    : 'decimalis'
    ;

LITTERA
    : 'littera'
    ;

// ***********
// bools
// ***********

VERUM
    : 'verum'
    ;

FALSUS
    : 'falsus'
    ;

// ***********
// condicionales
// ***********

SI
    : 'si'
    ;

ALITER
    : 'aliter'
    ;

// ***********
// ciclos
// ***********

DUM
    : 'dum'
    ;

FACERE
    : 'facere'
    ;

PER
    : 'per'
    ;

PERGE
    : 'perge'
    ;

INTERRUMPE
    : 'interrumpe'
    ;

// ***********
// entrada y salida
// ***********

LECTURA
    : '<<'
    ;

ESCRITURA
    : '>>'
    ;

// ***********
// operadores relacionales
// ***********

IGUAL_IGUAL
    : '=='
    ;

DIFERENTE
    : '!='
    ;

MENOR_IGUAL
    : '<='
    ;

MAYOR_IGUAL
    : '>='
    ;

IGUAL
    : '='
    ;

MENOR
    : '<'
    ;

MAYOR
    : '>'
    ;

// ***********
// oper aritmeticos
// ***********

INCREMENTO
    : '++'
    ;

DECREMENTO
    : '--'
    ;

MAS
    : '+'
    ;

MENOS
    : '-'
    ;

MULTIPLICACION
    : '*'
    ;

DIVISION
    : '/'
    ;

MODULO
    : '%'
    ;

// ***********
// operadores logicos
// ***********

AND
    : '&&'
    ;

OR
    : '||'
    ;

NOT
    : '!'
    ;


NON
    : 'non'
    ;

// ***********
// delimitador
// ***********

DOS_PUNTOS
    : ':'
    ;

PUNTO_COMA
    : ';'
    ;

PARENTESIS_IZQ
    : '('
    ;

PARENTESIS_DER
    : ')'
    ;

LLAVE_IZQ
    : '{'
    ;

LLAVE_DER
    : '}'
    ;

CORCHETE_IZQ
    : '['
    ;

CORCHETE_DER
    : ']'
    ;

COMA
    : ','
    ;

PUNTO
    : '.'
    ;

// ***********
// lieterales
// ***********


DECIMAL
    : [0-9]+ '.' [0-9]+
    ;

ENTERO
    : [0-9]+
    ;

CADENA
    : '"'
      (
          ~["\\\r\n]
        | '\\' .
      )*
      '"'
    ;

CARACTER
    : '\''
      (
          ~['\\\r\n]
        | '\\' .
      )
      '\''
    ;

// ***********
// identificadores
// ***********

IDENTIFICADOR
    : [a-zA-Z_] [a-zA-Z0-9_]*
    ;

// ***********
// coemtnarios
// ***********


COMENTARIO_LINEA
    : '//' ~[\r\n]* -> skip
    ;

COMENTARIO_BLOQUE
    : '##' .*? '##' -> skip
    ;

// ***********
// esoacios
// ***********

ESPACIOS
    : [ \t\r\n]+ -> skip
    ;

// ***********
// error lexico
// ***********

ERROR_LEXICO
    : .
    ;