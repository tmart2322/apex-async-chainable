@IsTest
public class ChainableQueueableSuccessCustomFinalizer extends ChainableQueueable {
    private String chainableTestName;

    public ChainableQueueableSuccessCustomFinalizer(
        String chainableTestName,
        ChainableFinalizer finalizer
    ) {
        super(finalizer);
        this.chainableTestName = chainableTestName;
    }

    protected override Boolean execute() {
        ChainableTestUtility.insertChainableTest(this.chainableTestName);
        return true;
    }
}
