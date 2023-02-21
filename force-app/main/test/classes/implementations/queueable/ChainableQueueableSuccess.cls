@IsTest
public class ChainableQueueableSuccess extends ChainableQueueable {
    private String chainableTestName;

    public ChainableQueueableSuccess(String chainableTestName) {
        this.chainableTestName = chainableTestName;
    }

    protected override Boolean execute() {
        ChainableTestUtility.insertChainableTest(this.chainableTestName);
        return true;
    }

    public String getChainableTestName() {
        return this.chainableTestName;
    }
}
