@IsTest
public class ChainableBatchPassThrough extends ChainableBatch {
    private Id chainableTestId;

    public ChainableBatchPassThrough(Id chainableTestId) {
        this.chainableTestId = chainableTestId;
    }

    protected override Database.QueryLocator start() {
        return Database.getQueryLocator('SELECT Id, Name FROM Chainable_Test__c WHERE Id = :chainableTestId');
    }

    protected override void execute(List<sObject> scope) {
        Chainable_Test__c chainableTest = ((List<Chainable_Test__c>) scope)[0];
        String chainablePassThrough = String.valueOf(this.passThrough);
        String updatedChainableTestName = ChainableTestUtility.joinStrings(chainableTest.Name, chainablePassThrough);
        ChainableTestUtility.updateChainableTest(chainableTest.Id, updatedChainableTestName);

        this.passThrough = (Integer) this.passThrough + 1;
    }

    protected override Boolean finish() {
        return true;
    }
}