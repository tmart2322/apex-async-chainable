@IsTest
public class ChainableQueueableSuccess extends ChainableQueueable {
    private String chainableTestName;

    public ChainableQueueableSuccess(String chainableTestName) {
        this.chainableTestName = chainableTestName;
    }

    public override Boolean execute() {
        ChainableTestUtility.insertChainableTest(this.chainableTestName);
        return true;
    }
}