@IsTest
public class ChainableSchedulableTest {
    @IsTest
    public static void chainableSchedulableWithBatch() {
        final String CHAINABLE_TEST_NAME_APPEND = 'Append';

        List<String> chainableTestNamesForInsert = new List<String>{ 'Test' };
        Chainable_Test__c chainableTestForInsert = ChainableTestUtility.insertChainableTests(
            chainableTestNamesForInsert
        )[0];

        Test.startTest();
        new ChainableSchedulableCustom()
            .then(
                new ChainableBatchQLSuccess(
                    chainableTestForInsert.Id,
                    CHAINABLE_TEST_NAME_APPEND
                )
            )
            .run();
        Test.stopTest();

        List<AsyncApexJob> scheduledBatches = [
            SELECT ApexClass.Name
            FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
        ];
        System.assertEquals(
            1,
            scheduledBatches.size(),
            'One Batch job should be scheduled'
        );
        System.assertEquals(
            'ChainableBatchQLSuccess',
            scheduledBatches[0].ApexClass.Name,
            'ChainableBatchQLSuccess class should be scheduled'
        );
    }

    @IsTest
    public static void chainableSchedulableWithQueueable() {
        Test.startTest();
        new ChainableSchedulableCustom()
            .then(new ChainableQueueableSuccess('Test 1'))
            .run();
        Test.stopTest();

        List<AsyncApexJob> scheduledQueueables = [
            SELECT ApexClass.Name
            FROM AsyncApexJob
            WHERE JobType = 'Queueable'
        ];
        System.assertEquals(
            1,
            scheduledQueueables.size(),
            'One Queueable job should be scheduled'
        );
        System.assertEquals(
            'ChainableQueueableSuccess',
            scheduledQueueables[0].ApexClass.Name,
            'ChainableQueueableSuccess class should be scheduled'
        );
    }
}
