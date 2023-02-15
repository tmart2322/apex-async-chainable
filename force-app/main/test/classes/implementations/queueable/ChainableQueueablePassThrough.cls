@IsTest
public class ChainableQueueablePassThrough extends ChainableQueueable {
    private String chainableTestNamePrepend;

    public ChainableQueueablePassThrough(String chainableTestNamePrepend) {
        this.chainableTestNamePrepend = chainableTestNamePrepend;
    }

    protected override Boolean execute() {
        ChainableTestUtility.insertChainableTest(
            ChainableTestUtility.joinStrings(
                this.chainableTestNamePrepend,
                String.valueOf((Integer) this.getPassThrough())
            )
        );
        this.setPassThrough((Integer) this.getPassThrough() + 1);
        return true;
    }
}
