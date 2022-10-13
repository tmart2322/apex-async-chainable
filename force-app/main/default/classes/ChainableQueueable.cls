/**
 * @description `ChainableQueueable` An abstract class for implementing a Queueable Chainable.
 * @author Tristan Martin
 * @since October 9th, 2022
 */
public abstract class ChainableQueueable extends Chainable implements Queueable, Database.AllowsCallouts {
    // INSTANCE VARIABLES
    /**
     * context the QueueableContext of the Queueable
     */
    protected QueueableContext context;
    /**
     * finalizer the instace of the QueueableFinalizer to run after the implementation
     */
    private ChainableFinalizer finalizer;

    // CONSTRUCTORS
    /**
     * @description Uses the default ChainableFinalizer.
     */
    public ChainableQueueable() {
        this(new ChainableFinalizer());
    }

    /**
     * @description Allows a user-defined ChainableFinalizer to be used.
     * @param finalizer The ChainableFinalizer to use
     */
    public ChainableQueueable(ChainableFinalizer finalizer) {
        this.finalizer = finalizer;
    }

    // ABSTRACT METHODS
    /**
     * @description Abstract method for execute method logic
     * @return `Boolean` whether to run the next Chainable
     */
    protected abstract Boolean execute();

    // PUBLIC METHODS
    /**
     * @description Overrides the default execute method to call the execute abstract method
     * which will be implemented by the user and initializes the finalizer.
     * @param context QueueableContext context of the queueable
     */
    public void execute(QueueableContext context) {
        this.context = context;
        this.finalizer.current = this;
        System.attachFinalizer(finalizer);
        Boolean runNextChainable = this.execute();
        this.finalizer.current = this;
        this.finalizer.runNextChainable = runNextChainable;
    }

    /**
     * @description Enqueues the queueable
     */
    public override void run() {
        System.enqueueJob(this);
    }
}
