@IsTest
public class ChainableTestUtility {
    public static String joinStrings(
        String chainableTestPrepend,
        String chainableTestAppend
    ) {
        return String.format(
            '{0} {1}',
            new List<String>{ chainableTestPrepend, chainableTestAppend }
        );
    }

    public static Chainable_Test__c insertChainableTest(
        String chainableTestName
    ) {
        return insertChainableTests(new List<String>{ chainableTestName })[0];
    }

    public static List<Chainable_Test__c> insertChainableTests(
        List<String> chainableTestNames
    ) {
        List<Chainable_Test__c> chainableTests = new List<Chainable_Test__c>();
        for (String chainableTestName : chainableTestNames) {
            chainableTests.add(new Chainable_Test__c(Name = chainableTestName));
        }
        insert chainableTests;
        return chainableTests;
    }

    public static Chainable_Test__c updateChainableTest(
        Id chainableTestId,
        String chainableTestName
    ) {
        Chainable_Test__c chainableTest = new Chainable_Test__c(
            Id = chainableTestId,
            Name = chainableTestName
        );

        update chainableTest;
        return chainableTest;
    }

    public static List<Chainable_Test__c> getChainableTests() {
        return [SELECT Id, Name FROM Chainable_Test__c];
    }

    public static Set<String> getChainableTestNames(
        List<Chainable_Test__c> chainableTests
    ) {
        Set<String> chainableTestNames = new Set<String>();
        for (Chainable_Test__c chainableTest : chainableTests) {
            chainableTestNames.add(chainableTest.Name);
        }
        return chainableTestNames;
    }
}
