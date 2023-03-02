@IsTest
public class ChainableBatchIRunNext extends ChainableBatchIterable {
    Boolean runNext;

    public ChainableBatchIRunNext(Boolean runNext) {
        this.runNext = runNext;
    }

    protected override Iterable<Object> start() {
        return new List<Object>{};
    }

    protected override void execute(Iterable<Object> scope) {
    }

    protected override Boolean finish() {
        return runNext;
    }
}
