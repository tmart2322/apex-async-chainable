public abstract class ChainableAbstract implements Queueable {
    private ChainableFinalizer finalizer;
    public List<ChainableAbstract> chainables;
    protected QueueableContext context;
    public Object passThrough;

    public ChainableAbstract() {
        this(new ChainableFinalizer());
    }

    public ChainableAbstract(ChainableFinalizer finalizer) {
        this.finalizer = finalizer;
    }

    /**
     * @description Overrides the default execute method to call the execute abstract method which will be implemented by the user
     * @param context QueueableContext context of the queueable
     */
    public void execute(QueueableContext context) {
        this.context = context;
        executeWrapper();
    }

    /**
     * @description Wrapper to chain multiple queueables together
     */
    @TestVisible
    private void executeWrapper() {
        finalizer.chainables = this.chainables;
        finalizer.passThrough = this.passThrough;
        System.attachFinalizer(finalizer);

        Boolean runNext = execute();
        finalizer.runNext = runNext;
        finalizer.chainables = this.chainables;
        finalizer.passThrough = this.passThrough;
    }

    /**
     * @description Enqueues the chainable
     */
    public void run() {
        System.enqueueJob(this);
    }

    /**
     * @description Custom queueable logic implemented by the developer
     * @return `Boolean` whether to run the next queueable or not
     */
    public abstract Boolean execute();
}
