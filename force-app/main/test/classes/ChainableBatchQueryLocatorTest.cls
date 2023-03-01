@IsTest
public class ChainableBatchQueryLocatorTest {
    @IsTest
    public static void chainableBatchQueryLocatorSingleSuccess() {
        final String CHAINABLE_TEST_NAME_APPEND = 'Append';

        List<String> chainableTestNamesForInsert = new List<String>{ 'Test' };
        Chainable_Test__c chainableTestForInsert = ChainableTestUtility.insertChainableTests(
            chainableTestNamesForInsert
        )[0];

        Test.startTest();
        new ChainableBatchQLSuccess(
                chainableTestForInsert.Id,
                CHAINABLE_TEST_NAME_APPEND
            )
            .run();
        Test.stopTest();

        List<Chainable_Test__c> chainableTests = ChainableTestUtility.getChainableTests();
        Set<String> chainableTestNames = ChainableTestUtility.getChainableTestNames(
            chainableTests
        );
        System.assert(
            chainableTestNames.contains(
                ChainableTestUtility.joinStrings(
                    chainableTestNamesForInsert[0],
                    CHAINABLE_TEST_NAME_APPEND
                )
            ),
            'Chainable_Test__c name should be appended with CHAINABLE_TEST_NAME_APPEND'
        );
    }

    @IsTest
    public static void chainableBatchQueryLocatorMultipleSuccess() {
        final String CHAINABLE_TEST_NAME_APPEND = 'Append';

        List<String> chainableTestNamesForInsert = new List<String>{
            'Test 1',
            'Test 2'
        };
        List<Chainable_Test__c> chainableTestsForInsert = ChainableTestUtility.insertChainableTests(
            chainableTestNamesForInsert
        );

        Test.startTest();
        new ChainableBatchQLSuccess(
                chainableTestsForInsert[0].Id,
                CHAINABLE_TEST_NAME_APPEND
            )
            .then(
                new ChainableBatchQLSuccess(
                    chainableTestsForInsert[1].Id,
                    CHAINABLE_TEST_NAME_APPEND
                )
            )
            .run();
        Test.stopTest();

        List<Chainable_Test__c> chainableTests = ChainableTestUtility.getChainableTests();
        Set<String> chainableTestNames = ChainableTestUtility.getChainableTestNames(
            chainableTests
        );
        System.assert(
            chainableTestNames.contains(
                ChainableTestUtility.joinStrings(
                    chainableTestNamesForInsert[0],
                    CHAINABLE_TEST_NAME_APPEND
                )
            ),
            'First Chainable_Test__c name should be appended with CHAINABLE_TEST_NAME_APPEND'
        );
        System.assert(
            chainableTestNames.contains(
                ChainableTestUtility.joinStrings(
                    chainableTestNamesForInsert[1],
                    CHAINABLE_TEST_NAME_APPEND
                )
            ),
            'Second Chainable_Test__c name should be appended with CHAINABLE_TEST_NAME_APPEND'
        );
    }

    @IsTest
    public static void chainableBatchQueryLocatorPassThrough() {
        List<String> chainableTestNamesForInsert = new List<String>{
            'Test',
            'Test'
        };
        List<Chainable_Test__c> chainableTestsForInsert = ChainableTestUtility.insertChainableTests(
            chainableTestNamesForInsert
        );

        Test.startTest();
        new ChainableBatchQLPassThrough(chainableTestsForInsert[0].Id)
            .setPassThrough(1)
            .then(
                new ChainableBatchQLPassThrough(chainableTestsForInsert[1].Id)
            )
            .run();
        Test.stopTest();

        List<Chainable_Test__c> chainableTests = ChainableTestUtility.getChainableTests();
        Set<String> chainableTestNames = ChainableTestUtility.getChainableTestNames(
            chainableTests
        );
        System.assert(
            chainableTestNames.contains(
                ChainableTestUtility.joinStrings(
                    chainableTestNamesForInsert[0],
                    String.valueOf(1)
                )
            ),
            'First Chainable_Test__c name should be appended with passThrough value'
        );
        System.assert(
            chainableTestNames.contains(
                ChainableTestUtility.joinStrings(
                    chainableTestNamesForInsert[1],
                    String.valueOf(2)
                )
            ),
            'Second Chainable_Test__c name should be appended with passThrough value'
        );
    }

    @IsTest
    public static void chainableBatchQueryLocatorRunNextTrue() {
        final String CHAINABLE_TEST_NAME_APPEND = 'Append';

        List<String> chainableTestNamesForInsert = new List<String>{
            'Test 1',
            'Test 2'
        };
        List<Chainable_Test__c> chainableTestsForInsert = ChainableTestUtility.insertChainableTests(
            chainableTestNamesForInsert
        );

        Test.startTest();
        new ChainableBatchQLRunNext(chainableTestsForInsert[0].Id, true)
            .then(
                new ChainableBatchQLSuccess(
                    chainableTestsForInsert[1].Id,
                    CHAINABLE_TEST_NAME_APPEND
                )
            )
            .run();
        Test.stopTest();

        List<Chainable_Test__c> chainableTests = ChainableTestUtility.getChainableTests();
        Set<String> chainableTestNames = ChainableTestUtility.getChainableTestNames(
            chainableTests
        );
        System.assert(
            chainableTestNames.contains(chainableTestNamesForInsert[0]),
            'First Chainable_Test__c name should not be updated'
        );
        System.assert(
            chainableTestNames.contains(
                ChainableTestUtility.joinStrings(
                    chainableTestNamesForInsert[1],
                    CHAINABLE_TEST_NAME_APPEND
                )
            ),
            'Second Chainable_Test__c name should be appended with CHAINABLE_TEST_NAME_APPEND since runNext is true'
        );
    }

    @IsTest
    public static void chainableBatchQueryLocatorRunNextFalse() {
        final String CHAINABLE_TEST_NAME_APPEND = 'Append';

        List<String> chainableTestNamesForInsert = new List<String>{
            'Test 1',
            'Test 2'
        };
        List<Chainable_Test__c> chainableTestsForInsert = ChainableTestUtility.insertChainableTests(
            chainableTestNamesForInsert
        );

        Test.startTest();
        new ChainableBatchQLRunNext(chainableTestsForInsert[0].Id, false)
            .then(
                new ChainableBatchQLSuccess(
                    chainableTestsForInsert[1].Id,
                    CHAINABLE_TEST_NAME_APPEND
                )
            )
            .run();
        Test.stopTest();

        List<Chainable_Test__c> chainableTests = ChainableTestUtility.getChainableTests();
        Set<String> chainableTestNames = ChainableTestUtility.getChainableTestNames(
            chainableTests
        );
        System.assert(
            chainableTestNames.contains(chainableTestNamesForInsert[0]),
            'First Chainable_Test__c name should not be updated'
        );
        System.assert(
            chainableTestNames.contains(chainableTestNamesForInsert[1]),
            'Second Chainable_Test__c name should not be updated since runNext is false'
        );
    }
}
