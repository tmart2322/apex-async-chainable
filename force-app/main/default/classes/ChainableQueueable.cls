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
    protected QueueableContext context { protected get; private set; }
    /**
     * finalizer the instace of the QueueableFinalizer to run after the implementation
     */
    private ChainableFinalizer finalizer;
    /**
     * runNextOnUncaughtException whether the QueueableFinalizer will execute the next Chainable on an uncaught
     * exception (default is false)
     */
    public Boolean runNextOnUncaughtException { public get; private set; }

    // CONSTRUCTORS
    /**
     * @description Uses the default ChainableFinalizer and sets runNextOnUncaughtException to false
     */
    public ChainableQueueable() {
        this(new ChainableFinalizer());
    }

    /**
     * @description Allows a user-defined ChainableFinalizer to be used  and sets runNextOnUncaughtException to false
     * @param finalizer The ChainableFinalizer to use
     */
    public ChainableQueueable(ChainableFinalizer finalizer) {
        this.finalizer = finalizer;
        this.runNextOnUncaughtException = false;
    }

    // ABSTRACT METHODS
    /**
     * @description Abstract method for execute logic
     * @return `Boolean` whether to run the next Chainable
     */
    protected abstract Boolean execute();

    // PUBLIC METHODS
    /**
     * @description set whether the QueueableFinalizer will execute the next Chainable on an uncaught
     * exception. By default, Queueable will not run on uncaught exception.
     * @param runNextOnUncaughtException whether to run the next Chainable on an uncaught exception
     * @return `ChainableQueueable` instance of the ChainableQueueable
     */
    public ChainableQueueable setRunNextOnUncaughtException(
        Boolean runNextOnUncaughtException
    ) {
        this.runNextOnUncaughtException = runNextOnUncaughtException;
        this.synchronize();
        return this;
    }

    /**
     * @description Returns whether the next Chainable will run on uncaught exception
     * @return `Boolean` whether the next Chainable will run on uncaught exception
     */
    public Boolean getRunNextOnUncaughtException() {
        return this.runNextOnUncaughtException;
    }

    /**
     * @description Overrides the default execute method to call the execute abstract method
     * which will be implemented by the user and initializes the finalizer.
     * @param context QueueableContext context of the queueable
     */
    public void execute(QueueableContext context) {
        this.context = context;
        System.attachFinalizer(finalizer);
        this.synchronize();
        Boolean queueableResult = this.execute();
        this.finalizer.setQueueableResult(queueableResult);
    }

    // PROTECTED METHODS
    /**
     * @description Enqueues the queueable
     */
    protected override void runChainable() {
        System.enqueueJob(this);
    }

    /**
     * @description Used to synchronize any updates of the chain to the finalizer
     */
    protected override void synchronize() {
        this.finalizer.setCurrent(this);
    }
}
