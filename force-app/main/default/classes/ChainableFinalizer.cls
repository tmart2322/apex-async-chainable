public virtual class ChainableFinalizer implements Finalizer {
    public Chainable current;
    protected FinalizerContext context;
    public Boolean runNextChainable;

    /**
     * @description Constructor
     */
    public ChainableFinalizer() {
        this.runNextChainable = false;
    }

    /**
     * Overrides the default execute method to call the execute or executeOnUnhandledException virtual methods which can be overriden by the user
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
    }

    /**
     * @description called when the queueable completed successfully
     */
    protected virtual void executeOnSuccess() {
        this.executeOnSuccessCustom();
        this.runNext();
    }
    
    /**
     * @description optional method that can be implemented by the developer to do custom logic on success
     */
    protected virtual void executeOnSuccessCustom() {}

    /**
     * @description called when the queueable failed due to an uncaught exception
     */
    protected virtual void executeOnUnhandledException() {
        this.executeOnUnhandledExceptionCustom();
        this.runNext();
    }

    /**
     * @description optional method that can be implemented by the developer to do custom logic on unhandled exception
     */
    protected virtual void executeOnUnhandledExceptionCustom() {}

    protected void runNext() {
        if (this.runNextChainable) {
            current.runNext();
        }
    }
}
