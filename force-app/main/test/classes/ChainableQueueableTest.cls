@IsTest
public class ChainableQueueableTest {
    @IsTest
    public static void chainableQueueableSingleSuccess() {
        Test.startTest();
        new ChainableQueueableSuccess('Test 1').run();
        Test.stopTest();

        System.assertEquals(
            1,
            ChainableTestUtility.getChainableTests().size(),
            'Should successfully insert a Chainable_Test__c when called'
        );
    }

    @IsTest
    public static void chainableQueueableSingleSuccessWithoutFinalizer() {
        Test.startTest();
        new ChainableQueueableSuccess('Test 1').removeFinalizer().run();
        Test.stopTest();

        System.assertEquals(
            1,
            ChainableTestUtility.getChainableTests().size(),
            'Should successfully insert a Chainable_Test__c when called'
        );
    }

    @IsTest
    public static void chainableQueueableMultipleSuccess() {
        Test.startTest();
        new ChainableQueueableSuccess('Test 1')
            .then(new ChainableQueueableSuccess('Test 2'))
            .run();
        Test.stopTest();

        System.assertEquals(
            2,
            ChainableTestUtility.getChainableTests().size(),
            'Should successfully insert two Chainable_Test__c when called'
        );
    }

    @IsTest
    public static void chainableQueueableMultipleSuccessAddChain() {
        Test.startTest();
        new ChainableQueueableSuccessAddChain('Test 1')
            .then(new ChainableQueueableSuccess('Test 3'))
            .run();
        Test.stopTest();

        System.assertEquals(
            3,
            ChainableTestUtility.getChainableTests().size(),
            'Should successfully insert three Chainable_Test__c when called'
        );
    }

    @IsTest
    public static void chainableQueueablePassThrough() {
        final String chainableTestNamePrepend = 'Test';

        Test.startTest();
        new ChainableQueueablePassThrough(chainableTestNamePrepend)
            .setPassThrough(1)
            .then(new ChainableQueueablePassThrough(chainableTestNamePrepend))
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
    public static void chainableQueueableMaxDepth() {
        Test.startTest();
        new ChainableQueueableSuccess('Test 1')
            .setMaxDepth(1)
            .then(new ChainableQueueableSuccess('Test 2'))
            .run();
        Test.stopTest();

        System.assertEquals(
            1,
            ChainableTestUtility.getChainableTests().size(),
            'Should only insert one Chainable as the maxDepth is reached'
        );
    }

    @IsTest
    public static void chainableQueueableRunNextTrue() {
        Test.startTest();
        new ChainableQueueableRunNext(true)
            .then(new ChainableQueueableSuccess('Test'))
            .run();
        Test.stopTest();

        System.assertEquals(
            1,
            ChainableTestUtility.getChainableTests().size(),
            'Should insert Chainable_Test__c in second chainable if first chainable returns true from execute'
        );
    }

    @IsTest
    public static void chainableQueueableRunNextFalse() {
        Test.startTest();
        new ChainableQueueableRunNext(false)
            .then(new ChainableQueueableSuccess('Test'))
            .run();
        Test.stopTest();

        System.assertEquals(
            0,
            ChainableTestUtility.getChainableTests().size(),
            'Should not insert Chainable_Test__c in second chainable if first chainable returns false from execute'
        );
    }

    @IsTest
    public static void chainableQueueableCustomFinalizer() {
        final String CHAINABLE_FINALIZER_CUSTOM_CHAINABLE_NAME = 'Custom Finalizer Test';

        Test.startTest();
        new ChainableQueueableSuccess('Test')
            .setFinalizer(
                new ChainableFinalizerCustom(
                    CHAINABLE_FINALIZER_CUSTOM_CHAINABLE_NAME
                )
            )
            .then(new ChainableQueueableSuccess('Test'))
            .run();
        Test.stopTest();

        List<Chainable_Test__c> chainableTests = ChainableTestUtility.getChainableTests();
        Set<String> chainableTestNames = ChainableTestUtility.getChainableTestNames(
            chainableTests
        );
        System.assertEquals(
            3,
            chainableTests.size(),
            'Chainables should each insert 1 Chainable_Test__c and finalizer should insert 1 Chainable_Test__c for a total of 3'
        );
        System.assert(
            chainableTestNames.contains(
                CHAINABLE_FINALIZER_CUSTOM_CHAINABLE_NAME
            ),
            'Finalizer should insert Chainable_Test__c with specified name'
        );
    }

    /**
     * @description Coverage test for finalizer error handling. Unfortunately not able to test finalizer error handling works correctly.
     */
    @IsTest
    public static void chainableQueueableFinalizerErrorHandlingCoverage() {
        try {
            Test.startTest();
            new ChainableQueueableError()
                .then(new ChainableQueueableSuccess('Test'))
                .run();
            Test.stopTest();
        } catch (Exception e) {
        }
    }
}
