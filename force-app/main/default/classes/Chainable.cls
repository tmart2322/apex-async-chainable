/**
 * @description `Chainable` An abstract class that uses a linked list approach for running Chainables.
 * @author Tristan Martin
 * @since October 9th, 2022
 */
public abstract class Chainable {
    // INSTANCE VARIABLES
    /**
     * `next` the next Chainable to execute
     */
    private Chainable next;
    /**
     * `previous` the previous Chainable executed
     */
    private Chainable previous;
    /**
     * `passThrough` an object that persists across the Chainable execution.
     * Any updates to this variable will be reflected in succeeding Chainables.
     */
    private Object passThrough;
    /**
     * `depth` represents the current depth of the chain (0 indexed).
     * This variable is incremented by 1 for each succeeding Chainable.
     */
    private Integer depth;
    /**
     * `maxDepth` If < 1, chain will run indefinitely. If >= 1, chain will end when depth + 1 = maxDepth.
     * Any updates to this variable will be reflected in succeeding Chainables.
     */
    private Integer maxDepth;

    // CONSTRUCTORS
    /**
     * @description Used to initialize depth and maxDepth on the Chainable
     */
    public Chainable() {
        this.depth = 0;
        this.maxDepth = 0;
    }

    // ABSTRACT METHODS
    /**
     * @description Abstract method that defines how to run the Chainable.
     * @return `void`
     */
    public abstract void run();

    // VIRTUAL METHODS
    /**
     * @description Virtual method used for any synchronization needed for Chainables
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
        if (this.maxDepth > 0 && this.depth + 1 >= this.maxDepth) {
            return;
        }
        if (this.next != null) {
            this.next.setPassThrough(this.getPassThrough());
            this.next.setMaxDepth(this.getMaxDepth());
            this.next.setDepth(this.getDepth() + 1);
            this.synchronize();
            this.next.run();
        }
    }

    /**
     * @description Gets the passThrough variable for the current Chainable
     * @return `Object` the passThrough of the current Chainable
     */
    public Object getPassThrough() {
        return this.passThrough;
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
     * @description Gets the maxDepth variable for the current Chainable
     * @return `Integer` the maxDepth of the current Chainable
     */
    public Integer getMaxDepth() {
        return this.maxDepth;
    }

    /**
     * @description Sets the maxDepth variable for the current Chainable
     * @return `Chainable` the instance of this Chainable
     */
    public Chainable setMaxDepth(Integer maxDepth) {
        this.maxDepth = maxDepth;
        this.synchronize();
        return this;
    }

    // PRIVATE METHODS
    /**
     * @description Gets the depth variable for the current Chainable
     * @return  `Integer`
     */
    private Integer getDepth() {
        return this.depth;
    }

    /**
     * @description Sets the depth variable for the current Chainable
     * @param depth
     */
    private void setDepth(Integer depth) {
        this.depth = depth;
    }

    /**
     * Used to test that the chain is properly set
     * @return  `Chainable`
     */
    @TestVisible
    private Chainable getNext() {
        return this.next;
    }
}
