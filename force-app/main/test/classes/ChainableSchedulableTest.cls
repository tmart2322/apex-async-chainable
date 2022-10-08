@IsTest
public class ChainableSchedulableTest {
    @IsTest
    public static void chainableSchedulableWithBatch() {
        final String CHAINABLE_TEST_NAME_APPEND = 'Append';

        List<String> chainableTestNamesForInsert = new List<String>{'Test'};
        Chainable_Test__c chainableTestForInsert = ChainableTestUtility.insertChainableTests(chainableTestNamesForInsert)[0];
        List<Chainable> chainables = new List<Chainable>{
            new ChainableSchedulableCustom(),
            new ChainableBatchSuccess(chainableTestForInsert.Id, CHAINABLE_TEST_NAME_APPEND)
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
        Test.stopTest();

        List<AsyncApexJob> scheduledBatches = [SELECT ApexClass.Name FROM AsyncApexJob WHERE JobType = 'BatchApex'];
        System.assertEquals(1, scheduledBatches.size(), 'One Batch should be scheduled');
        System.assertEquals('ChainableBatchSuccess', scheduledBatches[0].ApexClass.Name, 'Batch class should be scheduled');
    }

    @IsTest
    public static void chainableSchedulableWithQueueable() {
        List<Chainable> chainables = new List<Chainable>{
            new ChainableSchedulableCustom(),
            new ChainableQueueableSuccess('Test 1')
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
        Test.stopTest();

        List<AsyncApexJob> scheduledQueueables = [SELECT ApexClass.Name FROM AsyncApexJob WHERE JobType = 'Queueable'];
        System.assertEquals(1, scheduledQueueables.size(), 'One Queueable should be scheduled');
        System.assertEquals('ChainableQueueableSuccess', scheduledQueueables[0].ApexClass.Name, 'Batch class should be scheduled');
    }
}
