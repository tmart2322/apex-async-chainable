@IsTest
public class ChainableBatchIPassThrough extends ChainableBatchIterable {
    private String chainableTestNamePrepend;

    public ChainableBatchIPassThrough(String chainableTestNamePrepend) {
        super(String.class);
        this.chainableTestNamePrepend = chainableTestNamePrepend;
    }

    protected override Iterable<Object> start() {
        return new List<Object>{ this.chainableTestNamePrepend };
    }

    protected override void execute(List<Object> scope) {
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
