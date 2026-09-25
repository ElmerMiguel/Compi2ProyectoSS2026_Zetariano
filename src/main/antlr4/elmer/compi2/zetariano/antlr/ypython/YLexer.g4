lexer grammar YLexer;


tokens {
INDENT,
    DEDENT
    }
    
@members {

    private final java.util.Queue<Token> tokensPendientes
            = new java.util.ArrayDeque<>();

    private final java.util.Stack<Integer> indentaciones
            = new java.util.Stack<>();

    private Token ultimoToken = null;

    @Override
    public Token nextToken() {

        // Primero devolver tokens artificiales pendientes.
        if (!tokensPendientes.isEmpty()) {
            return tokensPendientes.poll();
        }

        Token siguiente = super.nextToken();

        // Al llegar a EOF hay que cerrar todos los bloques
        // de indentación todavía abiertos.
        if (siguiente.getType() == EOF
                && !indentaciones.isEmpty()) {

            while (!indentaciones.isEmpty()) {

                indentaciones.pop();

                tokensPendientes.add(
                    crearToken(
                        DEDENT,
                        "<DEDENT>",
                        siguiente
                    )
                );
            }

            tokensPendientes.add(siguiente);

            return tokensPendientes.poll();
        }

        if (siguiente.getChannel()
                == Token.DEFAULT_CHANNEL) {

            ultimoToken = siguiente;
        }

        return siguiente;
    }

    private Token crearToken(
            int tipo,
            String texto,
            Token referencia) {

        CommonToken token
                = new CommonToken(tipo, texto);

        if (referencia != null) {

            token.setLine(
                referencia.getLine()
            );

            token.setCharPositionInLine(
                referencia.getCharPositionInLine()
            );
        }

        return token;
    }

    private int contarIndentacion(
            String espacios) {

        int total = 0;

        for (char c : espacios.toCharArray()) {

            if (c == '\t') {

                // Una tabulación equivale a 4 espacios
                total += 4;

            } else {

                total++;
            }
        }

        return total;
    }

    private void procesarIndentacion(
            String espacios) {

        int actual
                = contarIndentacion(
                    espacios
                );

        int anterior
                = indentaciones.isEmpty()
                    ? 0
                    : indentaciones.peek();

        if (actual > anterior) {

            indentaciones.push(actual);

            tokensPendientes.add(
                crearToken(
                    INDENT,
                    "<INDENT>",
                    ultimoToken
                )
            );

            return;
        }

        while (!indentaciones.isEmpty()
                && actual
                < indentaciones.peek()) {

            indentaciones.pop();

            tokensPendientes.add(
                crearToken(
                    DEDENT,
                    "<DEDENT>",
                    ultimoToken
                )
            );
        }
    }
    }
    
    
    // ============================================================
    // SECCIONES
    // ============================================================
    
    ESTRUCTURAS
    : '%estructuras'
    ;

FUNCIONES
    : '%funciones'
    ;


// ============================================================
// PALABRAS RESERVADAS
// ============================================================

ESTRUCTURA
    : 'estructura'
    ;

DEFINIR
    : 'definir'
    ;

RETORNAR
    : 'retornar'
    ;


SI
    : 'si'
    ;

ENTONCES
    : 'entonces'
    ;

SINO
    : 'sino'
    ;

CONTRARIO
    : 'contrario'
    ;


ELEGIR
    : 'elegir'
    ;

CASO
    : 'caso'
    ;

SIEMPRE
    : 'siempre'
    ;


PARA
    : 'para'
    ;

MIENTRAS
    : 'mientras'
    ;

HACER
    : 'hacer'
    ;


CONTINUAR
    : 'continuar'
    ;

ROMPER
    : 'romper'
    ;


// ============================================================
// FUNCIONES DEL SISTEMA
// ============================================================

IMPRIMIR
    : 'imprimir'
    ;

LEER
    : 'leer'
    ;


// ============================================================
// TIPOS
// ============================================================

TIPO_ENTERO
    : 'entero'
    ;

TIPO_FLOTANTE
    : 'flotante'
    ;

TIPO_CADENA
    : 'cadena'
    ;

TIPO_CARACTER
    : 'caracter'
    ;

TIPO_BOOL
    : 'bool'
    ;


VERDADERO
    : 'verdadero'
    ;

FALSO
    : 'falso'
    ;


// ============================================================
// OPERADORES
// ============================================================

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


IGUAL_IGUAL
    : '=='
    ;

DIFERENTE
    : '!='
    ;

MENOR
    : '<'
    ;

MAYOR
    : '>'
    ;


AND
    : '&&'
    ;

OR
    : '||'
    ;

NOT
    : '!'
    ;


INCREMENTO
    : '++'
    ;

DECREMENTO
    : '--'
    ;


ASIGNACION
    : '='
    ;


// ============================================================
// SÍMBOLOS
// ============================================================

FLECHA
    : '->'
    ;

DOS_PUNTOS
    : ':'
    ;

PUNTO_COMA
    : ';'
    ;

COMA
    : ','
    ;

PARENTESIS_IZQ
    : '('
    ;

PARENTESIS_DER
    : ')'
    ;

CORCHETE_IZQ
    : '['
    ;

CORCHETE_DER
    : ']'
    ;

LLAVE_IZQ
    : '{'
    ;

LLAVE_DER
    : '}'
    ;

PUNTO
    : '.'
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
    : '"'
    (
    '\\' .
    |
    ~["\\\r\n]
    )*
    '"'
    ;

CARACTER
    : '\''
    (
    '\\' .
    |
    ~['\\\r\n]
    )
    '\''
    ;


// ============================================================
// IDENTIFICADORES
// ============================================================

IDENTIFICADOR
    : [a-zA-Z_]
    [a-zA-Z_0-9]*
    ;


// ============================================================
// COMENTARIOS
// ============================================================

COMENTARIO
    : '//'
    ~[\r\n]*
    -> skip
    ;


// ============================================================
// SALTO DE LÍNEA E INDENTACIÓN
// ============================================================

NEWLINE
    : (
    '\r'? '\n'
    |
    '\r'
    )
    [ \t]*
      {

          String texto
                  = getText();

          String espacios
                  = texto.replaceAll(
                      "[\\r\\n]",
                      ""
                  );

          String salto
                  = texto.substring(
                      0,
                      texto.length()
                      - espacios.length()
                  );

          setText(salto);

          int siguiente
                  = _input.LA(1);

          // No generar indentación extra
          // cuando encontramos línea vacía.
          if (siguiente != '\r'
                  && siguiente != '\n'
                  && siguiente != IntStream.EOF) {

              procesarIndentacion(
                  espacios
              );
          }
    }
    ;


// ============================================================
// ESPACIOS INTERNOS
// ============================================================

ESPACIOS
    : [ \t]+
    -> skip
    ;


// ============================================================
// CARÁCTER INVÁLIDO
// ============================================================

ERROR_CHAR
    : .
    ;