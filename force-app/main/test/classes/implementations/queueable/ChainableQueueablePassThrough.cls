@IsTest
public class ChainableQueueablePassThrough extends ChainableQueueable {
    private String chainableTestNamePrepend;

    public ChainableQueueablePassThrough(String chainableTestNamePrepend) {
        this.chainableTestNamePrepend = chainableTestNamePrepend;
    }

    public override Boolean execute() {
        ChainableTestUtility.insertChainableTest(ChainableTestUtility.joinStrings(this.chainableTestNamePrepend, String.valueOf((Integer) this.passThrough)));
        this.passThrough = (Integer) this.passThrough + 1;
        return true;
    }
}