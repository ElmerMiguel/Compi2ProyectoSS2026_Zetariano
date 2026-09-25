package elmer.compi2.zetariano.analysis.symbol;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Stack;

/**
 * Tabla de simbolos con gestion de ambitos anidados en pila.
 */
public class SymbolTable {

    private final List<Symbol> symbols = new ArrayList<>();
    private final Stack<Integer> scopeStack = new Stack<>();
    private int nextScopeId = 1;

    public SymbolTable() {
        // Ambito global inicial (id 0)
        scopeStack.push(0);
    }

    public void enterScope() {
        scopeStack.push(nextScopeId++);
    }

    public void exitScope() {
        if (scopeStack.size() > 1) {
            scopeStack.pop();
        }
    }

    public int getCurrentScopeId() {
        return scopeStack.peek();
    }

    public int getCurrentScopeLevel() {
        return scopeStack.size() - 1;
    }

    public boolean existsInCurrentScope(String name) {
        int currentId = getCurrentScopeId();
        return symbols.stream()
                .anyMatch(s -> s.getName().equals(name) && s.getScopeId() == currentId);
    }

    public void add(Symbol symbol) {
        symbols.add(symbol);
    }

    public Symbol lookup(String name) {
        for (int i = scopeStack.size() - 1; i >= 0; i--) {
            int scopeId = scopeStack.get(i);
            for (int j = symbols.size() - 1; j >= 0; j--) {
                Symbol s = symbols.get(j);
                if (s.getName().equals(name) && s.getScopeId() == scopeId) {
                    return s;
                }
            }
        }
        return null;
    }

    public List<Symbol> getSymbols() {
        return Collections.unmodifiableList(symbols);
    }

    public void print() {
        System.out.println("\n========== TABLA DE SIMBOLOS ==========");
        for (Symbol s : symbols) {
            System.out.println(s);
        }
        System.out.println("========================================");
    }
}
