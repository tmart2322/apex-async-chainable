/**
 * @description `Chainable` An abstract class that uses a linked list approach for running Chainables.
 * @author Tristan Martin
 * @since October 9th, 2022
 */
public abstract class Chainable {
    // INSTANCE VARIABLES
    /**
     * next the next Chainable to execute
     */
    private Chainable next;
    /**
     * previous the previous Chainable that was executed
     */
    private Chainable previous;
    /**
     * passThrough an object that persists across the Chainable execution.
     * Any updates to this variable will be reflected in succeeding Chainables.
     */
    private Object passThrough;

    // ABSTRACT METHODS
    /**
     * @description Abstract method that defines how to run the Chainable.
     * @return `void`
     */
    public abstract void run();

    /**
     * @description INTERNAL USE ONLY - method for synchronizing to the finalizer in ChainableQueueable
     * @return `void`
     */
    protected virtual void synchronize() {
    }

    // PUBLIC METHODS
    /**
     * @description Adds the next Chainable to the queue. If next is already defined for the current Chainable
     * then it will be overridden with the new Chainable and be added as the next item in the queue.
     * @param next the next Chainable to run in the execution
     * @return `Chainable` the instance of this Chainable
     */
    public Chainable then(Chainable next) {
        if (this.next != null) {
            next.then(this.next);
        }
        this.next = next;
        this.next.previous = this;
        this.synchronize();
        return this;
    }

    /**
     * @description Will run the next Chainable in the queue (if it exists).
     */
    public void runNext() {
        if (this.next != null) {
            this.next.setPassThrough(this.getPassThrough());
            this.synchronize();
            this.next.run();
        }
    }

    /**
     * @description Sets the passThrough variable for the current Chainable.
     * @param passThrough Object value to set
     * @return `Chainable` the instance of this Chainable
     */
    public Chainable setPassThrough(Object passThrough) {
        this.passThrough = passThrough;
        this.synchronize();
        return this;
    }

    /**
     * @description Gets the passThrough variable for the current chainable
     * @return `Object` the passThrough of the current Chainable
     */
    public Object getPassThrough() {
        return this.passThrough;
    }
}
