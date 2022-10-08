public abstract class Chainable {
    public List<Chainable> chainables;
    public Object passThrough;

    public abstract void run();
}
