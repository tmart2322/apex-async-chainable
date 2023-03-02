@IsTest
public class ChainableBatchIPassThrough extends ChainableBatchIterable {
    private String chainableTestNamePrepend;

    public ChainableBatchIPassThrough(String chainableTestNamePrepend) {
        this.chainableTestNamePrepend = chainableTestNamePrepend;
    }

    protected override Iterable<Object> start() {
        return (Iterable<Object>) new List<String>{
            this.chainableTestNamePrepend
        };
    }

    protected override void execute(Iterable<Object> scope) {
        String chainableTestName = ((List<String>) scope)[0];
        ChainableTestUtility.insertChainableTest(
            ChainableTestUtility.joinStrings(
                this.chainableTestNamePrepend,
                String.valueOf((Integer) this.getPassThrough())
            )
        );
        this.setPassThrough((Integer) this.getPassThrough() + 1);
    }

    protected override Boolean finish() {
        return true;
    }
}
