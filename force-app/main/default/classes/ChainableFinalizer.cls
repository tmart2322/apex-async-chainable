/**
 * @description `ChainableFinalizer` A virtual class for implementing a Finalizer for Queueable Chainables.
 * @author Tristan Martin
 * @since October 9th, 2022
 */
public virtual class ChainableFinalizer implements Finalizer {
    // INSTANCE VARIABLES
    /**
     * current The current instance of the QueueableChainable
     */
    public ChainableQueueable current;
    /**
     * context the FinalizerContext of the Finalizer
     */
    protected FinalizerContext context;
    /**
     * runNextChainable whether to run the next Chainable
     */
    public Boolean runNextChainable;

    // CONSTRUCTORS
    /**
     * @description Constructor that initalizes runNextChainable to false
     */
    public ChainableFinalizer() {
        this(false);
    }

    /**
     * @description Constructor that allows a custom value for runNextChainable
     * @param runNextChainable
     */
    public ChainableFinalizer(Boolean runNextChainable) {
        this.runNextChainable = runNextChainable;
    }

    // VIRTUAL METHODS
    /**
     * @description Abstract method for execute method logic
     */
    protected virtual void execute() {
    }

    // PUBLIC METHODS
    /**
     * Overrides the default execute method to call the custom
     * virtual methods which can be overriden by the user
     * @param context
     */
    public void execute(FinalizerContext context) {
        this.context = context;
        this.execute();
        if (this.runNextChainable) {
            this.current.runNext();
        }
    }
}
