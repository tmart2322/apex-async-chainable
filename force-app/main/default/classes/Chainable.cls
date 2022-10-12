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
    public Chainable next;
    /**
     * previous the previous Chainable that was executed
     */
    public Chainable previous;
    /**
     * passThrough an object that persists across the Chainable execution.
     * Any updates to this variable will be reflected in succeeding Chainables.
     */
    public Object passThrough { get; private set; }

    // ABSTRACT METHODS
    /**
     * @description Abstract method that defines how to run the Chainable.
     * @return `void`
     */
    public abstract void run();

    // PUBLIC METHODS
    /**
     * @description Adds the next Chainable to the stack. If next is already defined for the current Chainable
     * then it will be overridden with the new Chainable and be added as the next item in the stack.
     * @param next the next Chainable to run in the execution
     * @return `Chainable` the instance of this Chainable
     */
    public Chainable then(Chainable next) {
        if (this.next != null) {
            next.then(this.next);
        }
        this.next = next;
        this.next.previous = this;
        return this;
    }

    /**
     * @description Will run the next Chainable in the stack (if it exists).
     */
    public void runNext() {
        if (this.next != null) {
            this.next.passThrough = this.passThrough;
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
        return this;
    }
}
