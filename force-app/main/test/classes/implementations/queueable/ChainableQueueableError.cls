@IsTest
public class ChainableQueueableError extends ChainableQueueable {
    protected override Boolean execute() {
        throw new DmlException('Test finalizer');
    }
}
