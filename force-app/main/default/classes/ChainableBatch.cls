public abstract class ChainableBatch extends Chainable implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    protected Database.BatchableContext context;

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
        Boolean runNext = this.finish();
        if (runNext) {
            ChainableUtility.runChainables(this.chainables, this.passThrough);
        }
    }

    public override void run() {
        Database.executeBatch(this);
    }

    protected abstract Database.QueryLocator start();
    protected abstract void execute(List<sObject> scope);
    protected abstract Boolean finish();
}
