/**
 * @description `ChainableUtility` A utility class that enables list-driven chaining.
 * @author Tristan Martin
 * @since October 9th, 2022
 */
public class ChainableUtility {
    /**
     * @description Chains a list of chainables and returns the first item in the Chain
     * @param chainables List of Chainables to chain
     */
    public static Chainable chain(List<Chainable> chainables) {
        Chainable previousChainable;
        for (Chainable chainable : chainables) {
            if (previousChainable != null) {
                previousChainable.then(chainable);
            }
            previousChainable = chainable;
        }
        return chainables[0];
    }
}
