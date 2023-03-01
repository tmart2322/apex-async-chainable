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
     * current The current instance of the QueueableChainable
     */
    private ChainableQueueable current;
    /**
     * queueableResult the return of ChainableQueueable's execute method. If null assume uncaught exception ocurred
     */
    protected Boolean queueableResult { protected get; private set; }

    // VIRTUAL METHODS
    /**
     * @description Virtual method for execute logic.
     * By default, calls `defaultRunNext` to determine whether to run the next Queueable.
     */
    protected virtual Boolean execute() {
        return this.defaultRunNext();
    }

    // PUBLIC METHODS
    /**
     * @description Overrides the default execute method to call the custom
     * virtual `execute` which can be overriden by the user
     * @param context
     */
    public void execute(FinalizerContext context) {
        this.context = context;
        Boolean runNextChainable = this.execute();
        if (runNextChainable) {
            this.current.runNext();
        }
    }

    /**
     * @description By default, it will take the result from the ChainableQueueable's execute method.
     * If the result from the ChainableQueueable's execute method is not set,
     * runNextChainableOnUncaughtException willl determine whether the next Chainable is run.
     * Can be overridden for custom implementations.
     * @return  `Boolean` default logic used to determine whether to run the next Chainable
     */
    public Boolean defaultRunNext() {
        return this.queueableResult != null
            ? this.queueableResult
            : current.getRunNextOnUncaughtException();
    }

    /**
     * @description Set the current ChainableQueueable on the Finalizer
     * @param current
     */
    public void setCurrent(ChainableQueueable current) {
        this.current = current;
    }

    /**
     * @description Set the result of the execution from the Queueable
     * @param queueableResult
     */
    public void setQueueableResult(Boolean queueableResult) {
        this.queueableResult = queueableResult;
    }
}
