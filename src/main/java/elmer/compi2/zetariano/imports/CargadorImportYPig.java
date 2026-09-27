
package elmer.compi2.zetariano.imports;

import elmer.compi2.zetariano.antlr.ypython.YLexer;
import elmer.compi2.zetariano.antlr.ypython.YParser;
import elmer.compi2.zetariano.diagnostic.ErrorReport;
import elmer.compi2.zetariano.diagnostic.ErrorCollector;
import elmer.compi2.zetariano.analysis.semantic.YAnalyzer;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import org.antlr.v4.runtime.BailErrorStrategy;
import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.misc.ParseCancellationException;

/**
 * Cargador de archivos importados en lenguaje Y?.
 */
public class CargadorImportYPig {

    public YAnalyzer cargarSemantico(
            String rutaArchivo)
            throws IOException {

        
        // 1. LEER ARCHIVO .y
        
        String codigo
                = Files.readString(
                        Path.of(rutaArchivo)
                );

        
        // 2. LEXER
        
        CharStream input
                = CharStreams.fromString(
                        codigo
                );

        YLexer lexer
                = new YLexer(
                        input
                );

        List<String> erroresLexicos
                = new ArrayList<>();

        lexer.removeErrorListeners();

        lexer.addErrorListener(
                new BaseErrorListener() {

            @Override
            public void syntaxError(
                    Recognizer<?, ?> recognizer,
                    Object simbolo,
                    int linea,
                    int columna,
                    String mensaje,
                    RecognitionException excepcion) {

                erroresLexicos.add(
                        "Linea "
                        + linea
                        + ", columna "
                        + columna
                        + " -> "
                        + mensaje
                );
            }
        }
        );

        CommonTokenStream tokens
                = new CommonTokenStream(
                        lexer
                );

        tokens.fill();

        for (Token token
                : tokens.getTokens()) {

            if (token.getType()
                    == YLexer.ERROR_CHAR) {

                erroresLexicos.add(
                        "Linea "
                        + token.getLine()
                        + ", columna "
                        + token.getCharPositionInLine()
                        + " -> caracter invalido '"
                        + token.getText()
                        + "'."
                );
            }
        }

        if (!erroresLexicos.isEmpty()) {

            StringBuilder detalle
                    = new StringBuilder();

            for (String error
                    : erroresLexicos) {

                detalle.append(
                        System.lineSeparator()
                );

                detalle.append(
                        error
                );
            }

            throw new IllegalStateException(
                    "El archivo Y importado '"
                    + rutaArchivo
                    + "' contiene errores lexicos:"
                    + detalle
            );
        }

        tokens.seek(0);

        
        // 3. PARSER
        
        YParser parser
                = new YParser(
                        tokens
                );

        parser.setErrorHandler(
                new BailErrorStrategy()
        );

        YParser.ProgramaContext arbol;

        try {

            arbol = parser.programa();

        } catch (ParseCancellationException ex) {

            Token tokenActual
                    = parser.getCurrentToken();

            int linea
                    = tokenActual != null
                            ? tokenActual.getLine()
                            : -1;

            int columna
                    = tokenActual != null
                            ? tokenActual.getCharPositionInLine()
                            : -1;

            String texto
                    = tokenActual != null
                            ? tokenActual.getText()
                            : "<desconocido>";

            throw new IllegalStateException(
                    "Error sintactico en el archivo Y. "
                    + "Linea "
                    + linea
                    + ", columna "
                    + columna
                    + ", cerca de '"
                    + texto
                    + "'.",
                    ex
            );
        }

        ErrorCollector.clear();

        YAnalyzer semantico = new YAnalyzer();
        semantico.visit(arbol);

        if (ErrorCollector.hasErrors()) {
            StringBuilder detalle = new StringBuilder();
            for (ErrorReport error : ErrorCollector.getErrors()) {
                detalle.append(System.lineSeparator()).append(error);
            }
            ErrorCollector.clear();
            throw new IllegalStateException(
                    "El archivo Y importado '"
                    + rutaArchivo
                    + "' contiene errores semanticos:"
                    + detalle
            );
        }

        ErrorCollector.clear();
        return semantico;
    }
}
