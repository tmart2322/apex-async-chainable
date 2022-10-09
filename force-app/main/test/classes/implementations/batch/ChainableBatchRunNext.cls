@IsTest
public class ChainableBatchRunNext extends ChainableBatch {
    private Id chainableTestId;
    private Boolean runNext;

    public ChainableBatchRunNext(Id chainableTestId, Boolean runNext) {
        this.chainableTestId = chainableTestId;
        this.runNext = runNext;
    }

    protected override Database.QueryLocator start() {
        return Database.getQueryLocator(
            'SELECT Id, Name FROM Chainable_Test__c WHERE Id = :chainableTestId'
        );
    }

    protected override void execute(List<sObject> scope) {
    }

    protected override Boolean finish() {
        return runNext;
    }
}
