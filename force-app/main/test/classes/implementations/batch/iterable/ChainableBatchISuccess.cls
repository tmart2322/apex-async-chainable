@IsTest
public class ChainableBatchISuccess extends ChainableBatchIterable {
    private String chainableTestNamePrepend;

    public ChainableBatchISuccess(String chainableTestNamePrepend) {
        this.chainableTestNamePrepend = chainableTestNamePrepend;
    }

    protected override Iterable<Object> start() {
        return (Iterable<Object>) new List<String>{
            this.chainableTestNamePrepend
        };
    }

    protected override void execute(Iterable<Object> scope) {
        String chainableTestName = ((List<String>) scope)[0];
        ChainableTestUtility.insertChainableTest(chainableTestName);
    }

    protected override Boolean finish() {
        return true;
    }
}
