@IsTest
public class ChainableFinalizerCustom extends ChainableFinalizer {
    private String chainableTestName;

    public ChainableFinalizerCustom(String chainableTestName) {
        this.chainableTestName = chainableTestName;
    }

    protected override Boolean execute() {
        switch on context.getResult() {
            when SUCCESS {
                ChainableTestUtility.insertChainableTest(
                    this.chainableTestName
                );
            }
            when UNHANDLED_EXCEPTION {
                // Unhandled exception logic here
            }
        }
        return true;
    }
}
