@IsTest
public class ChainableFinalizerCustom extends ChainableFinalizer {
    private String chainableTestName;

    public ChainableFinalizerCustom(String chainableTestName) {
        this.chainableTestName = chainableTestName;
    }

    protected override Boolean execute(Boolean defaultRunNext) {
        switch on context.getResult() {
            when SUCCESS {
                ChainableTestUtility.insertChainableTest(
                    this.chainableTestName
                );
            }
        }
        return defaultRunNext;
    }
}
