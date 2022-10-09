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
        for (Integer i = 0; i < chainables.size(); i++) {
            Chainable chainable = chainables[i];
            chainable.previous = i > 0 ? chainables[i - 1] : null;
            chainable.next = i < chainables.size() - 1 ? chainables[i + 1] : null;
        }
        chainables[0].setPassThrough(passThrough).run();
    }
}
