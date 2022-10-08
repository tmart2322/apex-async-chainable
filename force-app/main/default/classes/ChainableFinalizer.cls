public virtual class ChainableFinalizer implements Finalizer {
    public List<ChainableAbstract> chainables;
    protected FinalizerContext context;
    public Boolean runNext;
    public Object passThrough;

    /**
     * @description Constructor
     */
    public ChainableFinalizer() {
        this.runNext = false;
    }

    /**
     * Overrides the default execute method to call the execute or executeOnUnhandledException virtual methods which can be overriden by the user
     * @param context 
     */
    public void execute(FinalizerContext context) {
        this.context = context;
        switch on context.getResult() {
            when SUCCESS {
                execute();
            }
            when UNHANDLED_EXCEPTION {
                executeOnUnhandledException();
            }
        }
    }

    /**
     * @description called when the queueable completed successfully
     */
    protected virtual void execute() {
        if (this.runNext) {
            ChainableUtility.runChainables(this.chainables, this.passThrough);
        }
    }

    /**
     * @description called when the queueable failed due to an uncaught exception
     */
    protected virtual void executeOnUnhandledException() {
        this.execute();
    }
}
