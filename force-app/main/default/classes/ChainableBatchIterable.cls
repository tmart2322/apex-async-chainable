public abstract class ChainableBatchIterable extends ChainableBatchBase implements Database.Batchable<Object> {
    // INSTANCE VARIABLES
    /**
     * iteratorType Represents the Type of the iterator in the batch
     */
    private Type iteratorType;

    // CONSTRUCTORS
    /**
     * @description Contructor that sets the default batch size of 200
     * @param iteratorType the Type of the iterator returned from the start method
     */
    public ChainableBatchIterable(Type iteratorType) {
        this(iteratorType, ChainableBatchBase.DEFAULT_BATCH_SIZE);
    }

    /**
     * @description Constructor the allows a custom batch size
     * @param iteratorType the Type of the iterator returned from the start method
     * @param batchSize the batch size of the Batch
     */
    public ChainableBatchIterable(Type iteratorType, Integer batchSize) {
        super(batchSize);
        this.iteratorType = iteratorType;
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
    protected abstract void execute(List<Object> scope);

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
    public void execute(Database.BatchableContext context, List<Object> scope) {
        this.context = context;
        this.execute(castToExecuteType(scope, this.iteratorType));
    }

    /**
     * @description Run the batch
     */
    public override void run() {
        Database.executeBatch(this, this.batchSize);
    }

    // PRIVATE METHODS
    /**
     * @description Casts List<ANY> to List<ITERATOR_TYPE>
     * @param scope The execute scope (which is a List<ANY>)
     * @param iteratorType The type the list should be converted to
     * @return `List<Object>` A List<Object> which has an underlying List<ITERATOR_TYPE>
     */
    private List<Object> castToExecuteType(
        List<Object> scope,
        Type iteratorType
    ) {
        String serializedExecuteList = JSON.serialize(scope);
        Type listIteratorType = Type.forName(
            String.format(
                'List<{0}>',
                new List<String>{ iteratorType.getName() }
            )
        );
        return (List<Object>) JSON.deserialize(
            serializedExecuteList,
            listIteratorType
        );
    }
}
