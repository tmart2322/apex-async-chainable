@IsTest
public class ChainableQueueableSuccessAddChain extends ChainableQueueable {
    private String chainableTestName;

    public ChainableQueueableSuccessAddChain(String chainableTestName) {
        this.chainableTestName = chainableTestName;
    }

    protected override Boolean execute() {
        ChainableTestUtility.insertChainableTest(this.chainableTestName);
        this.then(new ChainableQueueableSuccess('Test 2'));
        return true;
    }
}
