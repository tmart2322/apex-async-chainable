/**
 * @description `ChainableSchedulable` An abstract class for implementing a Schedulable Chainable.
 * @author Tristan Martin
 * @since October 9th, 2022
 */
public abstract class ChainableSchedulable extends Chainable implements Schedulable {
    // INSTANCE VARIABLES
    /**
     * context the ScheduledContext of the Schedulable
     */
    protected SchedulableContext context;
    /**
     * jobName the job name to pass to the Schedulable
     */
    private String jobName;
    /**
     * cronExp the cron expression to pass to the Schedulable
     */
    private String cronExp;

    // CONSTRUCTORS
    /**
     * @description Constructor for ChainableSchedulable
     * @param jobName the job name to pass to the Schedulable
     * @param cronExp the cron expression to pass to the Schedulable
     */
    public ChainableSchedulable(String jobName, String cronExp) {
        this.jobName = jobName;
        this.cronExp = cronExp;
    }

    // VIRTUAL METHODS
    /**
     * @description Optional method to implement that runs any execution logic for the Schedulable
     * @return `Boolean` whether to run the next Chainable (true by default)
     */
    protected virtual Boolean execute() {
        return true;
    }

    // PUBLIC METHODS
    /**
     * @description Implementing the Schedulable execute method to run the developer-defined execute
     * and run the next Chainable after execution.
     * @param context
     */
    public void execute(SchedulableContext context) {
        this.context = context;
        Boolean runNextChainable = this.execute();
        if (runNextChainable) {
            this.runNext();
        }
    }

    // PROTECTED METHODS
    /**
     * @description Schedule the Schedulable
     */
    protected override void runChainable() {
        System.schedule(this.jobName, this.cronExp, this);
    }
}
