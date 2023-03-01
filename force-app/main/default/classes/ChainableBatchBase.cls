public abstract class ChainableBatchBase extends Chainable implements Database.Stateful, Database.AllowsCallouts {
    // STATIC VARIABLES
    public static final Integer DEFAULT_BATCH_SIZE = 200;

    // INSTANCE VARIABLES
    /**
     * context the BatchableContext of the Batch
     */
    protected Database.BatchableContext context { get; protected set; }
    /**
     * batchSize the batch size of the Batch
     */
    protected Integer batchSize { get; private set; }

    // CONSTRUCTORS
    /**
     * @description Constructor the allows a custom batch size
     * @param batchSize the batch size of the Batch
     */
    public ChainableBatchBase(Integer batchSize) {
        this.batchSize = batchSize;
    }

    // ABSTRACT METHODS
    /**
     * @description Abstract method for finish method logic
     * @return  `Boolean` Whether to execute the next Queueable
     */
    protected abstract Boolean finish();

    /**
     * @description Exposing the run method from Chainable as abstract so it can be implemented for both types of batch
     */
    public override abstract void run();

    // PUBLIC METHODS
    /**
     * @description Implementing the Batch finish method to run the developer-defined finish
     * and run the next Chainable after execution.
     * @param context BatchableContext of the Batch
     */
    public void finish(Database.BatchableContext context) {
        this.context = context;
        Boolean runNextChainable = this.finish();
        if (runNextChainable) {
            this.runNext();
        }
    }
}
