@IsTest
public class ChainableFinalizerCustom extends ChainableFinalizer {
    private String chainableTestName;

    public ChainableFinalizerCustom(String chainableTestName) {
        this.chainableTestName = chainableTestName;
    }

    protected override void executeOnSuccess() {
        ChainableTestUtility.insertChainableTest(this.chainableTestName);
    }
}
