@IsTest
public class ChainableFinalizerCustom extends ChainableFinalizer {
    private String chainableTestName;

    public ChainableFinalizerCustom(String chainableTestName) {
        super();
        this.chainableTestName = chainableTestName;
    }

    protected override void executeOnSuccessCustom() {
        ChainableTestUtility.insertChainableTest(this.chainableTestName);
    }
}
