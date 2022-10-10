@IsTest
public class ChainableQueueableRunNext extends ChainableQueueable {
    private Boolean runNext;

    public ChainableQueueableRunNext(Boolean runNext) {
        this.runNext = runNext;
    }

    protected override Boolean execute() {
        return runNext;
    }
}
