@IsTest
public class ChainableSchedulableCustom extends ChainableSchedulable {
    public ChainableSchedulableCustom() {
        super('ChainableSchedulableTestJob', '20 30 8 10 2 ?');
    }
}
