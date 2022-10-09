# Apex Async Chainable

This library enables chaining of any number of asynchronous processes (Batch, Queueable, Schedulable) together in a standardized and extensible way.

## Library Overview

Chaining asynchronous processes together can be cumbersome in Salesforce. This library aims to make this process simpler by doing the following:

-   Exposes extensible classes that have the chaining logic embedded and surfaces abstract methods for custom business logic.
-   Allows sharing of variables between chain members.
-   Allows both promise-like chaining and list-driven chaining.
-   Allows Batch, Queueable, or Schedulable to be chained.
-   Utilizes Finalizers for Queueables to ensure the chain can continue even if an uncaught exception is surfaced in the Queueable (including uncatchable limit exceptions).

### With Chainable

Chaining can be accomplished in a promise-like way...

```java
new ScheduledJob()
    .then(new BatchJob())
    .then(new QueueableJob())
    .then(new AnotherQueueableJob)
    ...
    .run();
```

...or by providing a list of chainables to run.

```java
List<Chainable> chainables = new List<Chainables>{
    new ScheduledJob(),
    new BatchJob(),
    new QueueableJob(),
    new AnotherQueueableJob()
    ...
};
ChainableUtility.runChainables(chainables);
```

### Without Chainable

Without Chainable chaining logic is tightly coupled with the business logic and needs to be defined in every asynchronous implementation. This may look like the following...

```java
class SchedulableImplementation implements Schedulable {
    public void execute(SchedulableContext context) {
        // Custom business logic
        ...
        // Run next asynchronous process
        Database.executeBatch(new BatchImplementation());
    }
}
```

```java
class BatchImplementation implements Database.Batchable<sObject> {
    Iterator<SObject> start(BatchableContext context) { ... }

    void execute(BatchableContext context, List<Account> scope) { ... }

    void finish(BatchableContext context) {
        // Custom business logic
        ...
        // Run next asynchronous process
        System.enqueueJob(new QueueableImplementation());
    }
}
```

```java
class QueueableImplementation implements Queueable {
    void execute(QueueableContext context) {
        // Custom business Logic
        ...
        // Run next asynchronous process
        ... and so forth
    }
}
```

## Usage

This provides example impelmentations for each Chainable type. If you're interested in additional implementation examples, see the test classes for each Chainable type.

### Chainable Types

#### Queueable

Chainable Queueables are created by extending the `ChainableQueueable` class.

```java
public class ChainableQueueableCustom extends ChainableQueueable {
    public override Boolean execute() {
        // Queueable execute logic here
        ...
        // Return whether to execute the next Chainable
        return true;
    }
}
```

Custom Finalizers also be defined by extending the `ChainableFinalizer` class.

```java
public class ChainableFinalizerCustom extends ChainableFinalizer {
    protected override void executeOnSuccessCustom() {
        // Custom logic when the Queueable is successful
    }

    protected override void executeOnUncaughtExceptionCustom() {
        // Custom logic when the Queueable has an unchaught exception (including uncatchable limit exceptions)
    }
}
```

```java
public class ChainableQueueableCustomWithCustomFinalizer extends ChainableQueueable {
    public ChainableQueueableCustomWithCustomFinalizer() {
        super(new ChainableFinalizerCustom());
    }

    public override Boolean execute() { ... }
}
```

By default, the Finalizer _will not_ execute the next Chainable if there is an uncaught exception in the Queueable. If you'd like to execute the next Chainable when there is an uncaught exception, pass true to the ChainableFinalizer's constructor.

```java
public class ChainableQueueableCustom extends ChainableQueueable {
    public ChainableQueueableCustom() {
        super(new ChainableFinalizer(true));
    }

    public override Boolean execute() { ... }
}
```

#### Batch

Chainable Batches are created by extending the `ChainableBatch` class.

```java
public class ChainableBatchCustom extends ChainableBatch {
    protected override Database.QueryLocator start() {
        // Start execute logic here
        ...
    }

    protected override void execute(List<sObject> scope) {
        // Batch execute logic here
        ...
    }

    protected override Boolean finish() {
        // Batch finish logic here
        ...
        // Return whether to execute the next Chainable
        return true;
    }
}
```

The default batch size is 200 for `ChainableBatch` implementations. This can be overridden by passing the batch size to the base class' constructor.

```java
public class ChainableBatchCustomWithCustomBatchSize extends ChainableBatch {
    public ChainableBatchCustomWithCustomBatchSize() {
        super(100); // Sets the batch size to 100
    }

    protected override Database.QueryLocator start() { ... }

    protected override void execute(List<sObject> scope) { ... }

    protected override Boolean finish() { ... }
}
```

#### Schedulable

Chainable Schedulables are created by extending the `ChainableSchedulable` class. By default, schedulable classes have no logic and the intent is to chain the next job for any logic necessary.

```java
public class ChainableSchedulableCustom extends ChainableSchedulable {
    public ChainableSchedulableCustom() {
        super('ChainableSchedulableTestJob', '20 30 8 10 2 ?');
    }
}
```

However, custom execute logic can be written by overriding the `execute` method.

```java
public class ChainableSchedulableCustomWithExecute extends ChainableSchedulable {
    public ChainableSchedulableCustom() { ... }
    public override void execute() {
        // Schedulable execute logic here
        ...
    }
}
```

### Other Usage Info

#### Using Pass Through

Any `Chainable` implementation can access the `passThrough` variable. This persists across Chainables and any updates are reflected in succeeding Chainables.

Pass Through can either be initalized in the promise-like approach by calling...

```java
new SomeChainable().setPassThrough(customObject).run();
```

... or by passing it as the second parameter in the list-driven approach.

```java
ChainableUtility.runChainables(chainables, customObject);
```

Pass Through can be updated at any point in the Chainable execution by using the setPassThrough method.

```java
this.setPassThrough(customObject);
```

#### Accessing Queueable, Schedulable, or Batch Context

The context of each asynchronous process is saved on the Chainable prior to the developer-implemented methods. These can be accessed by the `context` variable.

```java

QueueableContext context = this.context;
```

#### Adding a Chainable in the Middle of a Chainable Execution

A Chainable can be added at any point in a Chainable's execution by using the `then` method. This will set the Chainable as the next Chainable to run and the remaining Chainables will be run after.

```java
this.then(new SomeChainable());
```
