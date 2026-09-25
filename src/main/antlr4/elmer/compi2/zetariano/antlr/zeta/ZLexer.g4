lexer grammar ZLexer;



// ============================================================
// PALABRAS RESERVADAS
// ============================================================

PUBLIC      : 'public';
CLASS       : 'class';

VOID        : 'void';
RETURN      : 'return';

NEW         : 'new';
NULL        : 'null';

IF          : 'if';
ELSE        : 'else';

SWITCH      : 'switch';
CASE        : 'case';
DEFAULT     : 'default';

FOR         : 'for';
WHILE       : 'while';
DO          : 'do';

BREAK       : 'break';
CONTINUE    : 'continue';

TRUE        : 'true';
FALSE       : 'false';

// ============================================================
// TIPOS PRIMITIVOS
// ============================================================

INT         : 'int';
DOUBLE      : 'double';
STRING      : 'String';
CHAR        : 'char';
BOOLEAN     : 'boolean';

// ============================================================
// FUNCIONES ESPECIALES
// ============================================================

PRINTLN     : 'println';
PRINT       : 'print';
READLN      : 'readln';

// ============================================================
// OPERADORES
// ============================================================

INCREMENTO
    : '++'
    ;

DECREMENTO
    : '--'
    ;

MAS_IGUAL
    : '+='
    ;

MENOS_IGUAL
    : '-='
    ;

POR_IGUAL
    : '*='
    ;

IGUAL_IGUAL
    : '=='
    ;

DIFERENTE
    : '!='
    ;

MAYOR_IGUAL
    : '>='
    ;

MENOR_IGUAL
    : '<='
    ;

AND
    : '&&'
    ;

OR
    : '||'
    ;

ASIGNACION
    : '='
    ;

MAS
    : '+'
    ;

MENOS
    : '-'
    ;

POR
    : '*'
    ;

DIV
    : '/'
    ;

MOD
    : '%'
    ;

MAYOR
    : '>'
    ;

MENOR
    : '<'
    ;

NOT
    : '!'
    ;

TERNARIO
    : '?'
    ;

DOS_PUNTOS
    : ':'
    ;

PUNTO
    : '.'
    ;

COMA
    : ','
    ;

PUNTO_COMA
    : ';'
    ;

// ============================================================
// DELIMITADORES
// ============================================================

PAREN_IZQ
    : '('
    ;

PAREN_DER
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

// ============================================================
// LITERALES
// ============================================================

DECIMAL
    : [0-9]+ '.' [0-9]+
    ;

ENTERO
    : [0-9]+
    ;

CADENA
    : '"' ( '\\' . | ~["\\\r\n] )* '"'
    ;

CARACTER
    : '\'' ( '\\' . | ~['\\\r\n] ) '\''
    ;

// ============================================================
// IDENTIFICADORES
// ============================================================

IDENTIFICADOR
    : [a-zA-Z_] [a-zA-Z0-9_]*
    ;

// ============================================================
// COMENTARIOS
// ============================================================

COMENTARIO_LINEA
    : '//' ~[\r\n]*
      -> skip
    ;

COMENTARIO_BLOQUE
    : '/*' .*? '*/'
      -> skip
    ;

// ============================================================
// ESPACIOS
// ============================================================

WS
    : [ \t\r\n]+
      -> skip
    ;