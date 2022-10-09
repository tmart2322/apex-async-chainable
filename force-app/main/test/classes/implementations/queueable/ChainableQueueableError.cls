@IsTest
public class ChainableQueueableError extends ChainableQueueable {
    public override Boolean execute() {
        throw new DmlException('Test finalizer');
    }
}
