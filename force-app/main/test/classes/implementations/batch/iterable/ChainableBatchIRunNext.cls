@IsTest
public class ChainableBatchIRunNext extends ChainableBatchIterable {
    Boolean runNext;

    public ChainableBatchIRunNext(Boolean runNext) {
        super(String.class);
        this.runNext = runNext;
    }

    protected override Iterable<Object> start() {
        return new List<Object>{};
    }

    protected override void execute(List<Object> scope) {
    }

    protected override Boolean finish() {
        return runNext;
    }
}
