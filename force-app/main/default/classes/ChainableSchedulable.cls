public abstract class ChainableSchedulable extends Chainable implements Schedulable {
    protected SchedulableContext context;
    private String jobName;
    private String cronExp;
    
    public ChainableSchedulable(String jobName, String cronExp) {
        this.jobName = jobName;
        this.cronExp = cronExp;
    }

    public void execute(SchedulableContext context) {
        this.context = context;
        execute();
        ChainableUtility.runChainables(this.chainables, this.passThrough);
    }

    public override void run() {
        System.schedule(this.jobName, this.cronExp, this);
    }

    protected virtual void execute() {}
}