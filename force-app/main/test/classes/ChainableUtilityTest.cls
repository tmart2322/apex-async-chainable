@IsTest
public class ChainableUtilityTest {
    @IsTest
    public static void chainableUtilityChaining() {
        final String QUEUEABLE_1_NAME = '1';
        final String QUEUEABLE_2_NAME = '2';

        List<Chainable> chainables = new List<Chainable>{
            new ChainableQueueableSuccess(QUEUEABLE_1_NAME),
            new ChainableQueueableSuccess(QUEUEABLE_2_NAME)
        };

        Test.startTest();
        ChainableQueueableSuccess chainable1 = (ChainableQueueableSuccess) ChainableUtility.chain(
            chainables
        );
        ChainableQueueableSuccess chainable2 = (ChainableQueueableSuccess) chainable1.next;
        Test.stopTest();

        System.assertEquals(
            QUEUEABLE_1_NAME,
            chainable1.getChainableTestName(),
            'The first item in the list should be the first item in the chain'
        );
        System.assertEquals(
            QUEUEABLE_2_NAME,
            chainable2.getChainableTestName(),
            'The second item in the list should be the second item in the chain'
        );
    }
}
