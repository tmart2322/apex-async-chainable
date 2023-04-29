@IsTest
public class ChainableQueueableError extends ChainableQueueable {
    public ChainableQueueableError() {
        this.getFinalizer().setRunNextOnUncaughtException(true);
    }

    protected override Boolean execute() {
        throw new DmlException('Test finalizer');
    }
}
