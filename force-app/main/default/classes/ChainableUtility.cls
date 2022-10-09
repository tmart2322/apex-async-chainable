/**
 * @description `ChainableUtility` A utility class enables list-driven chaining.
 * @author Tristan Martin
 * @since October 9th, 2022
 */
public class ChainableUtility {
    /**
     * @description Converts a list of Chainables to the library's structure for execution
     * @param chainables List of Chainables to run
     */
    public static void runChainables(List<Chainable> chainables) {
        runChainables(chainables, null);
    }

    /**
     * @description Converts a list of Chainables to the library's structure for execution
     * @param chainables List of Chainables to run
     * @param passThrough Initial Pass Through value
     */
    public static void runChainables(
        List<Chainable> chainables,
        Object passThrough
    ) {
        for (Integer i = 0; i < chainables.size(); i++) {
            Chainable chainable = chainables[i];
            chainable.previous = i > 0 ? chainables[i - 1] : null;
            chainable.next = i < chainables.size() - 1
                ? chainables[i + 1]
                : null;
        }
        chainables[0].setPassThrough(passThrough).run();
    }
}
