public abstract class Chainable {
    public Chainable next;
    public Chainable previous;
    public Object passThrough;

    public Chainable then(Chainable next) {
        if (this.next != null) {
            this.next.then(next);
        } else {
            this.next = next;
            this.next.previous = this;
        }
        return this;
    }

    public void runNext() {
        if (this.next != null) {
            this.next.passThrough = this.passThrough;
            this.next.run();
        }
    }

    public Chainable setPassThrough(Object passThrough) {
        this.passThrough = passThrough;
        return this;
    }

    public abstract void run();
}
