public abstract class ChainableQueueable extends Chainable implements Queueable, Database.AllowsCallouts {
    private ChainableFinalizer finalizer;
    protected QueueableContext context;

    public ChainableQueueable() {
        this(new ChainableFinalizer());
    }

    public ChainableQueueable(ChainableFinalizer finalizer) {
        this.finalizer = finalizer;
    }

    /**
     * @description Overrides the default execute method to call the execute abstract method which will be implemented by the user
     * @param context QueueableContext context of the queueable
     */
    public void execute(QueueableContext context) {
        this.context = context;
        finalizer.current = this;
        System.attachFinalizer(finalizer);
        Boolean runNextChainable = this.execute();
        finalizer.runNextChainable = runNextChainable;
        finalizer.current = this;
    }

    /**
     * @description Enqueues the chainable
     */
    public override void run() {
        System.enqueueJob(this);
    }

    /**
     * @description Custom queueable logic implemented by the developer
     * @return `Boolean` whether to run the next queueable or not
     */
    public abstract Boolean execute();
}
