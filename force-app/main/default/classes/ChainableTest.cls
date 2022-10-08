@IsTest
public class ChainableTest {
    @IsTest
    public static void test_Chainable_SingleSuccess() {
        List<ChainableAbstract> chainables = new List<ChainableAbstract>{
            new ChainableSuccess('Test 1')
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM Chainable_Test__c], 'Should successfully insert a Chainable_Test__c when called');
    }

    @IsTest
    public static void test_Chainable_MultipleSuccess() {
        List<ChainableAbstract> chainables = new List<ChainableAbstract>{
            new ChainableSuccess('Test 1'),
            new ChainableSuccess('Test 2')
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
        Test.stopTest();

        System.assertEquals(2, [SELECT COUNT() FROM Chainable_Test__c], 'Should successfully insert two Chainable_Test__c when called');
    }

    @IsTest
    public static void test_Chainable_PassThrough() {
        String chainableTestNamePrepend = 'Test';

        List<ChainableAbstract> chainables = new List<ChainableAbstract>{
            new ChainablePassThrough(chainableTestNamePrepend),
            new ChainablePassThrough(chainableTestNamePrepend)
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables, 1);
        Test.stopTest();

        List<Chainable_Test__c> chainableTests = [SELECT Name FROM Chainable_Test__c];
        Set<String> chainableTestNames = new Set<String>();
        for (Chainable_Test__c chainableTest : chainableTests) {
            chainableTestNames.add(chainableTest.Name);
        }
        System.assert(chainableTestNames.contains(generateChainableTestName(chainableTestNamePrepend, 1)), 'First Chainable_Test__c name should be appended with 1');
        System.assert(chainableTestNames.contains(generateChainableTestName(chainableTestNamePrepend, 2)), 'Second Chainable_Test__c name should be appended with 2');
    }

    @IsTest
    public static void test_Chainable_RunNextTrue() {
        List<ChainableAbstract> chainables = new List<ChainableAbstract>{
            new ChainableRunNext(true),
            new ChainableSuccess('Test')
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM Chainable_Test__c], 'Should insert Chainable_Test__c in second chainable if first chainable returns true from execute');
    }

    @IsTest
    public static void test_Chainable_RunNextFalse() {
        List<ChainableAbstract> chainables = new List<ChainableAbstract>{
            new ChainableRunNext(false),
            new ChainableSuccess('Test')
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
        Test.stopTest();

        System.assertEquals(0, [SELECT COUNT() FROM Chainable_Test__c], 'Should not insert Chainable_Test__c in second chainable if first chainable returns false from execute');
    }

    @IsTest
    public static void test_Chainable_CustomFinalizer() {
        final String CHAINABLE_FINALIZER_CUSTOM_CHAINABLE_NAME = 'Custom Finalizer Test';

        List<ChainableAbstract> chainables = new List<ChainableAbstract>{
            new ChainableSuccessWithCustomFinalizer('Test', new ChainableFinalizerCustom(CHAINABLE_FINALIZER_CUSTOM_CHAINABLE_NAME)),
            new ChainableSuccess('Test')
        };

        Test.startTest();
        ChainableUtility.runChainables(chainables);
        Test.stopTest();

        List<Chainable_Test__c> chainableTests = [SELECT Name FROM Chainable_Test__c];
        Set<String> chainableTestNames = new Set<String>();
        for (Chainable_Test__c chainableTest : chainableTests) {
            chainableTestNames.add(chainableTest.Name);
        }
        System.assertEquals(3,chainableTests.size(), 'Chainables should each insert 1 Chainable_Test__c and finalizer should insert 1 Chainable_Test__c for a total of 3');
        System.assert(chainableTestNames.contains(CHAINABLE_FINALIZER_CUSTOM_CHAINABLE_NAME), 'Finalizer should insert Chainable_Test__c with specified name');
    }

    /**
     * @description Coverage test for finalizer error handling. Unfortunately not able to test finalizer error handling works correctly.
     */
    @IsTest
    public static void test_Chainable_FinalizerErrorHandlingCoverage() {
        List<ChainableAbstract> chainables = new List<ChainableAbstract>{
            new ChainableError(),
            new ChainableSuccess('Test')
        };

        try {
            Test.startTest();
            ChainableUtility.runChainables(chainables);
            Test.stopTest();
        } catch (Exception e) {}
    }

    public static String generateChainableTestName(String chainableTestNamePrepend, Integer chainableNumber) {
        return chainableTestNamePrepend + ' ' + chainableNumber;
    }

    public static void insertChainableTest(String chainableTestName) {
        insert new Chainable_Test__c(Name = chainableTestName);
    }

    private class ChainableSuccess extends ChainableAbstract {
        private String chainableTestName;

        public ChainableSuccess(String chainableTestName) {
            this.chainableTestName = chainableTestName;
        }

        public override Boolean execute() {
            ChainableTest.insertChainableTest(this.chainableTestName);
            return true;
        }
    }

    private class ChainableRunNext extends ChainableAbstract {
        private Boolean runNext;

        public ChainableRunNext(Boolean runNext) {
            this.runNext = runNext;
        }

        public override Boolean execute() {
            return runNext;
        }
    }

    private class ChainablePassThrough extends ChainableAbstract {
        private String chainableTestNamePrepend;

        public ChainablePassThrough(String chainableTestNamePrepend) {
            this.chainableTestNamePrepend = chainableTestNamePrepend;
        }

        public override Boolean execute() {
            ChainableTest.insertChainableTest(ChainableTest.generateChainableTestName(this.chainableTestNamePrepend, (Integer) this.passThrough));
            this.passThrough = (Integer) this.passThrough + 1;
            return true;
        }
    }

    private class ChainableError extends ChainableAbstract {
        public override Boolean execute() {
            throw new DmlException('Test finalizer');
        }
    }

    private class ChainableSuccessWithCustomFinalizer extends ChainableAbstract {
        private String chainableTestName;

        public ChainableSuccessWithCustomFinalizer(String chainableTestName, ChainableFinalizer finalizer) {
            super(finalizer);
            this.chainableTestName = chainableTestName;
        }

        public override Boolean execute() {
            ChainableTest.insertChainableTest(this.chainableTestName);
            return true;
        }
    }

    private class ChainableFinalizerCustom extends ChainableFinalizer {
        private String chainableTestName;

        public ChainableFinalizerCustom(String chainableTestName) {
            super();
            this.chainableTestName = chainableTestName;
        }

        protected override void execute() {
            if (this.runNext) {
                ChainableTest.insertChainableTest(this.chainableTestName);
                ChainableUtility.runChainables(this.chainables, this.passThrough);
            }
        }
    }
}
