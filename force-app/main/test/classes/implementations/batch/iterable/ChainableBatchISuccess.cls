@IsTest
public class ChainableBatchISuccess extends ChainableBatchIterable {
    private String chainableTestNamePrepend;

    public ChainableBatchISuccess(String chainableTestNamePrepend) {
        super(String.class);
        this.chainableTestNamePrepend = chainableTestNamePrepend;
    }

    protected override Iterable<Object> start() {
        return new List<Object>{ this.chainableTestNamePrepend };
    }

    protected override void execute(List<Object> scope) {
        String chainableTestName = ((List<String>) scope)[0];
        ChainableTestUtility.insertChainableTest(chainableTestName);
    }

    protected override Boolean finish() {
        return true;
    }
}
