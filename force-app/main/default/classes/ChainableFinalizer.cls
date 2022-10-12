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
     * @description called when the queueable completed successfully
     */
    protected virtual void executeOnSuccess() {
    }

    /**
     * @description called when the queueable failed due to an uncaught exception
     */
    protected virtual void executeOnUnhandledException() {
    }

    // PUBLIC METHODS
    /**
     * Overrides the default execute method to call the executeOnSuccess or executeOnUnhandledException
     * virtual methods which can be overriden by the user
     * @param context
     */
    public void execute(FinalizerContext context) {
        this.context = context;
        switch on context.getResult() {
            when SUCCESS {
                executeOnSuccess();
            }
            when UNHANDLED_EXCEPTION {
                executeOnUnhandledException();
            }
        }
        if (this.runNextChainable) {
            this.current.runNext();
        }
    }
}
