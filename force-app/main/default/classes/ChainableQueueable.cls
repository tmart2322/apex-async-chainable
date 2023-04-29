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

    // CONSTRUCTORS
    /**
     * @description Uses the default ChainableFinalizer and sets runNextOnUncaughtException to false
     */
    public ChainableQueueable() {
        setFinalizer(new ChainableFinalizer());
    }

    // ABSTRACT METHODS
    /**
     * @description Abstract method for execute logic
     * @return `Boolean` whether to run the next Chainable
     */
    protected abstract Boolean execute();

    // PUBLIC METHODS
    /**
     * @description Overrides the default execute method to call the execute abstract method
     * @param context QueueableContext context of the queueable
     */
    public void execute(QueueableContext context) {
        this.context = context;
        if (this.getFinalizer() != null) {
            this.executeWithFinalizer();
        } else {
            this.executeWithoutFinalizer();
        }
    }

    /**
     * @description Attach a custom finalizer to the ChainableQueueable. Defaults runNextOnUncaughtException to false.
     * @param finalizer the finalizer to attach.
     * @return `Chainable` the current instance of the ChainableQueueable.
     */
    public ChainableQueueable setFinalizer(ChainableFinalizer finalizer) {
        this.finalizer = finalizer;
        return this;
    }

    /**
     * @description Removes the finalizer and runs the next Chainable in the same context.
     * @return  `ChainableQueueable` the current instance of the ChainableQueueable.
     */
    public ChainableQueueable removeFinalizer() {
        this.finalizer = null;
        return this;
    }

    /**
     * @description Returns the finalizer
     * @return  `ChainableFinalizer` finalizer for the ChainableQueueable.
     */
    public ChainableFinalizer getFinalizer() {
        return this.finalizer;
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
        this.finalizer?.setCurrent(this);
    }

    // PRIVATE METHODS
    /**
     * @description Executes the next Chainable via a finalizer
     */
    private void executeWithFinalizer() {
        System.attachFinalizer(finalizer);
        this.synchronize();
        Boolean queueableResult = this.execute();
        this.finalizer.setQueueableResult(queueableResult);
    }

    /**
     * @description Executes the next Chainable in the same context
     */
    private void executeWithoutFinalizer() {
        Boolean runNextChainable = this.execute();
        if (runNextChainable) {
            this.runNext();
        }
    }
}
