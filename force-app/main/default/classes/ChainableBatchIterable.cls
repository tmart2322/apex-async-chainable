/**
 * @description `ChainableSchedulable` An abstract class for implementing an Iterable Batch Chainable
 * @author Tristan Martin
 * @since October 9th, 2022
 */
public abstract class ChainableBatchIterable extends ChainableBatchBase implements Database.Batchable<Object> {
    // CONSTRUCTORS
    /**
     * @description Contructor that sets the default batch size of 200
     * @param iteratorType the Type of the iterator returned from the start method
     */
    public ChainableBatchIterable() {
        this(ChainableBatchBase.DEFAULT_BATCH_SIZE);
    }

    /**
     * @description Constructor the allows a custom batch size
     * @param iteratorType the Type of the iterator returned from the start method
     * @param batchSize the batch size of the Batch
     */
    public ChainableBatchIterable(Integer batchSize) {
        super(batchSize);
    }

    // ABSTRACT METHODS
    /**
     * @description Abstract method for start method logic
     * @return `Iterable<Object>` Iterable to run batch on
     */
    protected abstract Iterable<Object> start();

    /**
     * @description Abstract method for execute method logic
     * @param scope List of Objects returned from the iterable
     * @return `void`
     */
    protected abstract void execute(Iterable<Object> scope);

    /**
     * @description Abstract method for finish method logic
     * @return `Boolean` Whether to execute the next Queueable
     */
    protected override abstract Boolean finish();

    // PUBLIC METHODS
    /**
     * @description Calls the user-defined start method
     * @param context BatchableContext of the Batch
     * @return `Iterable<Object>` Iterable to run batch on
     */
    public Iterable<Object> start(Database.BatchableContext context) {
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
        Iterable<Object> scope
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
