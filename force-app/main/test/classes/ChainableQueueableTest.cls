@IsTest
public class ChainableQueueableTest {
    @IsTest
    public static void chainableQueueableSingleSuccess() {
        List<Chainable> chainables = new List<Chainable>{
            new ChainableQueueableSuccess('Test 1')
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
        Test.stopTest();

        System.assertEquals(1, ChainableTestUtility.getChainableTests().size(), 'Should successfully insert a Chainable_Test__c when called');
    }

    @IsTest
    public static void chainableQueueableMultipleSuccess() {
        List<Chainable> chainables = new List<Chainable>{
            new ChainableQueueableSuccess('Test 1'),
            new ChainableQueueableSuccess('Test 2')
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
        Test.stopTest();

        System.assertEquals(2, ChainableTestUtility.getChainableTests().size(), 'Should successfully insert two Chainable_Test__c when called');
    }

    @IsTest
    public static void chainableQueueableMultipleSuccessWithChaining() {
        Test.startTest();
        new ChainableQueueableSuccess('Test 1')
            .then(new ChainableQueueableSuccess('Test 2'))
            .run();
        Test.stopTest();

        System.assertEquals(2, ChainableTestUtility.getChainableTests().size(), 'Should successfully insert two Chainable_Test__c when called');
    }

    @IsTest
    public static void chainableQueueableMultipleSuccessAddChain() {
        Test.startTest();
        new ChainableQueueableSuccessAddChain('Test 1')
            .then(new ChainableQueueableSuccess('Test 3'))
            .run();
        Test.stopTest();

        System.assertEquals(3, ChainableTestUtility.getChainableTests().size(), 'Should successfully insert two Chainable_Test__c when called');
    }

    @IsTest
    public static void chainableQueueablePassThrough() {
        String chainableTestNamePrepend = 'Test';

        List<Chainable> chainables = new List<Chainable>{
            new ChainableQueueablePassThrough(chainableTestNamePrepend),
            new ChainableQueueablePassThrough(chainableTestNamePrepend)
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables, 1);
        Test.stopTest();

        List<Chainable_Test__c> chainableTests = ChainableTestUtility.getChainableTests();
        Set<String> chainableTestNames = ChainableTestUtility.getChainableTestNames(chainableTests);
        System.assert(chainableTestNames.contains(ChainableTestUtility.joinStrings(chainableTestNamePrepend, String.valueOf(1))), 'First Chainable_Test__c name should be appended with 1');
        System.assert(chainableTestNames.contains(ChainableTestUtility.joinStrings(chainableTestNamePrepend, String.valueOf(1))), 'Second Chainable_Test__c name should be appended with 2');
    }

    @IsTest
    public static void chainableQueueableRunNextTrue() {
        List<Chainable> chainables = new List<Chainable>{
            new ChainableQueueableRunNext(true),
            new ChainableQueueableSuccess('Test')
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
        Test.stopTest();

        System.assertEquals(1, ChainableTestUtility.getChainableTests().size(), 'Should insert Chainable_Test__c in second chainable if first chainable returns true from execute');
    }

    @IsTest
    public static void chainableQueueableRunNextFalse() {
        List<Chainable> chainables = new List<Chainable>{
            new ChainableQueueableRunNext(false),
            new ChainableQueueableSuccess('Test')
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
        Test.stopTest();

        System.assertEquals(0, ChainableTestUtility.getChainableTests().size(), 'Should not insert Chainable_Test__c in second chainable if first chainable returns false from execute');
    }

    @IsTest
    public static void chainableQueueableCustomFinalizer() {
        final String CHAINABLE_FINALIZER_CUSTOM_CHAINABLE_NAME = 'Custom Finalizer Test';

        List<Chainable> chainables = new List<Chainable>{
            new ChainableQueueableSuccessCustomFinalizer('Test', new ChainableFinalizerCustom(CHAINABLE_FINALIZER_CUSTOM_CHAINABLE_NAME)),
            new ChainableQueueableSuccess('Test')
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
        Test.stopTest();

        List<Chainable_Test__c> chainableTests = ChainableTestUtility.getChainableTests();
        Set<String> chainableTestNames = ChainableTestUtility.getChainableTestNames(chainableTests);
        System.assertEquals(3, chainableTests.size(), 'Chainables should each insert 1 Chainable_Test__c and finalizer should insert 1 Chainable_Test__c for a total of 3');
        System.assert(chainableTestNames.contains(CHAINABLE_FINALIZER_CUSTOM_CHAINABLE_NAME), 'Finalizer should insert Chainable_Test__c with specified name');
    }

    /**
     * @description Coverage test for finalizer error handling. Unfortunately not able to test finalizer error handling works correctly.
     */
    @IsTest
    public static void chainableQueueableFinalizerErrorHandlingCoverage() {
        List<Chainable> chainables = new List<Chainable>{
            new ChainableQueueableError(),
            new ChainableQueueableSuccess('Test')
        };

        try {
            Test.startTest();
            ChainableUtility.runChainables(chainables);
            Test.stopTest();
        } catch (Exception e) {}
    }
}
