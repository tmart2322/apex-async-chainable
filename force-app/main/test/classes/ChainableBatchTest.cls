@IsTest
public class ChainableBatchTest {
    @IsTest
    public static void chainableBatchSingleSuccess() {
        final String CHAINABLE_TEST_NAME_APPEND = 'Append';

        List<String> chainableTestNamesForInsert = new List<String>{ 'Test' };
        Chainable_Test__c chainableTestForInsert = ChainableTestUtility.insertChainableTests(
            chainableTestNamesForInsert
        )[0];
        List<Chainable> chainables = new List<Chainable>{
            new ChainableBatchSuccess(
                chainableTestForInsert.Id,
                CHAINABLE_TEST_NAME_APPEND
            )
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
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
    public static void chainableBatchMultipleSuccess() {
        final String CHAINABLE_TEST_NAME_APPEND = 'Append';

        List<String> chainableTestNamesForInsert = new List<String>{
            'Test 1',
            'Test 2'
        };
        List<Chainable_Test__c> chainableTestsForInsert = ChainableTestUtility.insertChainableTests(
            chainableTestNamesForInsert
        );
        List<Chainable> chainables = new List<Chainable>{
            new ChainableBatchSuccess(
                chainableTestsForInsert[0].Id,
                CHAINABLE_TEST_NAME_APPEND
            ),
            new ChainableBatchSuccess(
                chainableTestsForInsert[1].Id,
                CHAINABLE_TEST_NAME_APPEND
            )
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
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
    public static void chainableBatchMultipleSuccessWithChaining() {
        final String CHAINABLE_TEST_NAME_APPEND = 'Append';

        List<String> chainableTestNamesForInsert = new List<String>{
            'Test 1',
            'Test 2'
        };
        List<Chainable_Test__c> chainableTestsForInsert = ChainableTestUtility.insertChainableTests(
            chainableTestNamesForInsert
        );

        Test.startTest();
        new ChainableBatchSuccess(
                chainableTestsForInsert[0].Id,
                CHAINABLE_TEST_NAME_APPEND
            )
            .then(
                new ChainableBatchSuccess(
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
    public static void chainableBatchPassThrough() {
        List<String> chainableTestNamesForInsert = new List<String>{
            'Test',
            'Test'
        };
        List<Chainable_Test__c> chainableTestsForInsert = ChainableTestUtility.insertChainableTests(
            chainableTestNamesForInsert
        );
        List<Chainable> chainables = new List<Chainable>{
            new ChainableBatchPassThrough(chainableTestsForInsert[0].Id),
            new ChainableBatchPassThrough(chainableTestsForInsert[1].Id)
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables, 1);
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
    public static void chainableBatchRunNextTrue() {
        final String CHAINABLE_TEST_NAME_APPEND = 'Append';

        List<String> chainableTestNamesForInsert = new List<String>{
            'Test 1',
            'Test 2'
        };
        List<Chainable_Test__c> chainableTestsForInsert = ChainableTestUtility.insertChainableTests(
            chainableTestNamesForInsert
        );
        List<Chainable> chainables = new List<Chainable>{
            new ChainableBatchRunNext(chainableTestsForInsert[0].Id, true),
            new ChainableBatchSuccess(
                chainableTestsForInsert[1].Id,
                CHAINABLE_TEST_NAME_APPEND
            )
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
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
    public static void chainableBatchRunNextFalse() {
        final String CHAINABLE_TEST_NAME_APPEND = 'Append';

        List<String> chainableTestNamesForInsert = new List<String>{
            'Test 1',
            'Test 2'
        };
        List<Chainable_Test__c> chainableTestsForInsert = ChainableTestUtility.insertChainableTests(
            chainableTestNamesForInsert
        );
        List<Chainable> chainables = new List<Chainable>{
            new ChainableBatchRunNext(chainableTestsForInsert[0].Id, false),
            new ChainableBatchSuccess(
                chainableTestsForInsert[1].Id,
                CHAINABLE_TEST_NAME_APPEND
            )
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
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
            'Second Chainable_Test__c name should not be updated since runNext is true'
        );
    }
}
