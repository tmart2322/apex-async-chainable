/**
 * @description `ChainableUtility` A utility class enables list-driven chaining.
 * @author Tristan Martin
 * @since October 9th, 2022
 */
public class ChainableUtility {
    /**
     * @description Chains and runs a list of Chainables
     * @param chainables List of Chainables to run
     */
    public static void runChainables(List<Chainable> chainables) {
        runChainables(chainables, null);
    }

    /**
     * @description Chains and runs a list of Chainables
     * @param chainables List of Chainables to run
     * @param passThrough Initial Pass Through value
     */
    public static void runChainables(
        List<Chainable> chainables,
        Object passThrough
    ) {
        Chainable previousChainable;
        for (Chainable chainable : chainables) {
            if (previousChainable != null) {
                previousChainable.then(chainable);
            }
            previousChainable = chainable;
        }
        chainables[0].setPassThrough(passThrough).run();
    }
}
