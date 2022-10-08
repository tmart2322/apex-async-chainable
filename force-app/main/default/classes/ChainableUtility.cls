public class ChainableUtility {
    /**
     * @description Pops the first chainable off the stack and initializes for remainder to execute
     * @param chainables List of chainables to run
     */
    public static void runChainables(List<Chainable> chainables) {
        runChainables(chainables, null);
    }

    /**
     * @description Pops the first chainable off the stack and initializes for remainder to execute
     * @param chainables List of chainables to run
     * @param passThrough Object to pass through to next chainable
     */
    public static void runChainables(List<Chainable> chainables, Object passThrough) {
        if (!chainables.isEmpty()) {
            Chainable chainable = chainables.remove(0);
            chainable.chainables = chainables;
            chainable.passThrough = passThrough;
            chainable.run();
        }
    }
}
