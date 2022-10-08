public class ChainableBatchSuccess extends ChainableBatch {
    private Id chainableTestId;
    private String chainableTestNameAppend;

    public ChainableBatchSuccess(Id chainableTestId, String chainableTestNameAppend) {
        this.chainableTestId = chainableTestId;
        this.chainableTestNameAppend = chainableTestNameAppend;
    }

    protected override Database.QueryLocator start() {
        return Database.getQueryLocator('SELECT Id, Name FROM Chainable_Test__c WHERE Id = :chainableTestId');
    }

    protected override void execute(List<sObject> scope) {
        Chainable_Test__c chainableTest = ((List<Chainable_Test__c>) scope)[0];
        String updatedChainableTestName = ChainableTestUtility.joinStrings(chainableTest.Name, chainableTestNameAppend);
        ChainableTestUtility.updateChainableTest(chainableTest.Id, updatedChainableTestName);
    }

    protected override Boolean finish() {
        return true;
    }
}