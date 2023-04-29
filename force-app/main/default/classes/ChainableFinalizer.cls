/**
 * @description `ChainableFinalizer` A virtual class for implementing a Finalizer for Queueable Chainables.
 * @author Tristan Martin
 * @since October 9th, 2022
 */
public virtual class ChainableFinalizer implements Finalizer {
    // INSTANCE VARIABLES
    /**
     * context the FinalizerContext of the Finalizer
     */
    protected FinalizerContext context { protected get; private set; }
    /**
     * current the current instance of the QueueableChainable
     */
    private ChainableQueueable current;
    /**
     * queueableResult the return of ChainableQueueable's execute method. Null in case of uncaught exception.
     */
    protected Boolean queueableResult { protected get; private set; }
    /**
     * runNextOnUncaughtException whether the next Chainable will be executed on uncaught exception. Defaulted to false.
     */
    protected Boolean runNextOnUncaughtException { protected get; private set; }

    // CONSTRUCTORS
    /**
     * @description Defaults runNextOnUncaughtException to false
     */
    public ChainableFinalizer() {
        this.runNextOnUncaughtException = false;
    }

    // VIRTUAL METHODS
    /**
     * @description Virtual method for execute logic.
     * @param defaultRunNext the chainable finalizers default run next logic
     * @return `Boolean` whether to run the next Chainable. By default returns defaultRunNext.
     */
    protected virtual Boolean execute(Boolean defaultRunNext) {
        return defaultRunNext;
    }

    // PUBLIC METHODS
    /**
     * @description Overrides the default execute method to call the custom
     * virtual `execute` which can be overriden by the user
     * @param context
     */
    public void execute(FinalizerContext context) {
        this.context = context;
        Boolean runNextChainable = this.execute(this.defaultRunNext());
        if (runNextChainable) {
            this.current.runNext();
        }
    }

    /**
     * @description Sets runNextOnUncaughtException on the finalizer
     * @param runNextOnUncaughtException whether the next Chainable will be executed on uncaught exception.
     */
    public void setRunNextOnUncaughtException(
        Boolean runNextOnUncaughtException
    ) {
        this.runNextOnUncaughtException = runNextOnUncaughtException;
    }

    /**
     * @description Set the current ChainableQueueable on the Finalizer
     * @param current the current instance of the QueueableChainable
     */
    public void setCurrent(ChainableQueueable current) {
        this.current = current;
    }

    /**
     * @description Set the result of the execution from the Queueable
     * @param queueableResult the return of ChainableQueueable's execute method. Null in case of uncaught exception.
     */
    public void setQueueableResult(Boolean queueableResult) {
        this.queueableResult = queueableResult;
    }

    // PRIVATE METHODS
    /**
     * @description If uncaught exception, returns result of runNextOnUncaughtException.
     * Otherwise, returns result of ChainableQueueable's execute method.
     * @return  `Boolean` whether to run the next Chainable
     */
    private Boolean defaultRunNext() {
        switch on this.context.getResult() {
            when UNHANDLED_EXCEPTION {
                return this.runNextOnUncaughtException;
            }
        }
        return this.queueableResult;
    }
}
