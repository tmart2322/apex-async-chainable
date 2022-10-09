/**
 * @description `ChainableBatch` An abstract class for implementing a Batch Chainable.
 * @author Tristan Martin
 * @since October 9th, 2022
 */
public abstract class ChainableBatch extends Chainable implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    // INSTANCE VARIABLES
    /**
     * context the BatchableContext of the Batch
     */
    protected Database.BatchableContext context;
    /**
     * batchSize the batch size of the Batch
     */
    private Integer batchSize;

    // CONSTRUCTORS
    /**
     * @description Contructor that sets the default batch size of 200
     */
    public ChainableBatch() {
        this(200);
    }

    /**
     * @description Constructor the allows a custom batch size
     * @param batchSize the batch size of the Batch
     */
    public ChainableBatch(Integer batchSize) {
        this.batchSize = batchSize;
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
     * @return  `Boolean` Whether to execute the next Queueable
     */
    protected abstract Boolean finish();

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

    /**
     * @description Executes the Batch
     */
    public override void run() {
        Database.executeBatch(this, this.batchSize);
    }
}
