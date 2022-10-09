public abstract class ChainableBatch extends Chainable implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    protected Database.BatchableContext context;
    private Integer batchSize;

    public ChainableBatch() {
        this(200);
    }

    public ChainableBatch(Integer batchSize) {
        this.batchSize = batchSize;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        this.context = context;
        return this.start();
    }

    public void execute(Database.BatchableContext context, List<sObject> scope) {
        this.context = context;
        this.execute(scope);
    }

    public void finish(Database.BatchableContext context) {
        this.context = context;
        Boolean runNextChainable = this.finish();
        if (runNextChainable) {
            this.runNext();
        }
    }

    public override void run() {
        Database.executeBatch(this, this.batchSize);
    }

    protected abstract Database.QueryLocator start();
    protected abstract void execute(List<sObject> scope);
    protected abstract Boolean finish();
}
