@IsTest
public class ChainableBatchIterableTest {
    @IsTest
    public static void chainableBatchIterableSingleSuccess() {
        Test.startTest();
        new ChainableBatchISuccess('Test 1').run();
        Test.stopTest();

        System.assertEquals(
            1,
            ChainableTestUtility.getChainableTests().size(),
            'Should successfully insert a Chainable_Test__c when called'
        );
    }

    @IsTest
    public static void chainableBatchIterableMultipleSuccess() {
        Test.startTest();
        new ChainableBatchISuccess('Test 1')
            .then(new ChainableBatchISuccess('Test 2'))
            .run();
        Test.stopTest();

        System.assertEquals(
            2,
            ChainableTestUtility.getChainableTests().size(),
            'Should successfully insert two Chainable_Test__c when called'
        );
    }

    @IsTest
    public static void chainableBatchIterablePassThrough() {
        final String chainableTestNamePrepend = 'Test';

        Test.startTest();
        new ChainableBatchIPassThrough(chainableTestNamePrepend)
            .setPassThrough(1)
            .then(new ChainableBatchIPassThrough(chainableTestNamePrepend))
            .run();
        Test.stopTest();

        List<Chainable_Test__c> chainableTests = ChainableTestUtility.getChainableTests();
        Set<String> chainableTestNames = ChainableTestUtility.getChainableTestNames(
            chainableTests
        );
        System.assert(
            chainableTestNames.contains(
                ChainableTestUtility.joinStrings(
                    chainableTestNamePrepend,
                    String.valueOf(1)
                )
            ),
            'First Chainable_Test__c name should be appended with 1'
        );
        System.assert(
            chainableTestNames.contains(
                ChainableTestUtility.joinStrings(
                    chainableTestNamePrepend,
                    String.valueOf(1)
                )
            ),
            'Second Chainable_Test__c name should be appended with 2'
        );
    }

    @IsTest
    public static void chainableBatchIterableRunNextTrue() {
        Test.startTest();
        new ChainableBatchIRunNext(true)
            .then(new ChainableBatchISuccess('Test'))
            .run();
        Test.stopTest();

        System.assertEquals(
            1,
            ChainableTestUtility.getChainableTests().size(),
            'Should insert Chainable_Test__c in second chainable if first chainable returns true from execute'
        );
    }

    @IsTest
    public static void chainableBatchIterableRunNextFalse() {
        Test.startTest();
        new ChainableBatchIRunNext(false)
            .then(new ChainableBatchISuccess('Test'))
            .run();
        Test.stopTest();

        System.assertEquals(
            0,
            ChainableTestUtility.getChainableTests().size(),
            'Should not insert Chainable_Test__c in second chainable if first chainable returns false from execute'
        );
    }
}
