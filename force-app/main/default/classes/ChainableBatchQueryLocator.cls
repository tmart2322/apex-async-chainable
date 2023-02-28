public abstract class ChainableBatchQueryLocator extends ChainableBatchBase implements Database.Batchable<sObject> {
    // CONSTRUCTORS
    /**
     * @description Contructor that sets the default batch size of 200
     */
    public ChainableBatchQueryLocator() {
        this(ChainableBatchBase.DEFAULT_BATCH_SIZE);
    }

    /**
     * @description Constructor the allows a custom batch size
     * @param batchSize the batch size of the Batch
     */
    public ChainableBatchQueryLocator(Integer batchSize) {
        super(batchSize);
    }

    // ABSTRACT METHODS
    /**
     * @description Abstract method for start method logic
     * @return `Database.QueryLocator`
     */
    protected abstract Database.QueryLocator start();

    /**
     * @description Abstract method for execute method logic
     * @param scope List of sObjects returned from the start method
     * @return `void`
     */
    protected abstract void execute(List<sObject> scope);

    /**
     * @description Abstract method for finish method logic
     * @return `Boolean` Whether to execute the next Queueable
     */
    protected override abstract Boolean finish();

    // PUBLIC METHODS
    /**
     * @description Calls the user-defined start method
     * @param context BatchableContext of the Batch
     * @return `Database.QueryLocator`
     */
    public Database.QueryLocator start(Database.BatchableContext context) {
        this.context = context;
        return this.start();
    }

    /**
     * @description Calls the developer-defined execute method
     * @param context BatchableContext of the Batch
     * @param scope List of sObjects returned from the start method
     */
    public void execute(
        Database.BatchableContext context,
        List<sObject> scope
    ) {
        this.context = context;
        this.execute(scope);
    }

    /**
     * @description Run the batch
     */
    public override void run() {
        Database.executeBatch(this, this.batchSize);
    }
}
