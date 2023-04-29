# Apex Async Chainable

![Build](https://github.com/tmart2322/apex-async-chainable/actions/workflows/code-coverage.yml/badge.svg) [![codecov](https://codecov.io/gh/tmart2322/apex-async-chainable/branch/master/graph/badge.svg?token=N5GSR94JNX)](https://codecov.io/gh/tmart2322/apex-async-chainable)

<a href="https://githubsfdeploy.herokuapp.com?owner=tmart2322&repo=apex-async-chainable">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

-   [Apex Async Chainable](#apex-async-chainable)
    -   [Library Overview](#library-overview)
        -   [With Chainable](#with-chainable)
        -   [Without Chainable](#without-chainable)
    -   [Usage](#usage)
        -   [Chainable Types](#chainable-types)
            -   [Queueable](#queueable)
            -   [Batch](#batch)
                -   [Batch With QueryLocator](#batch-with-querylocator)
                -   [Batch With Iterable](#batch-with-iterable)
            -   [Schedulable](#schedulable)
        -   [Other Usage Info](#other-usage-info)
            -   [Using Kill Switch](#using-kill-switch)
            -   [Using Pass Through](#using-pass-through)
            -   [Setting Max Depth](#setting-max-depth)
            -   [Accessing Queueable, Schedulable, Batch, or Finalizer Context](#accessing-queueable-schedulable-batch-or-finalizer-context)
            -   [Adding a Chainable in the Middle of a Chainable Execution](#adding-a-chainable-in-the-middle-of-a-chainable-execution)

This library enables chaining of any number of asynchronous processes (Batch, Queueable, Schedulable) together in a standardized and extensible way.

## Library Overview

Without this library, chaining asynchronous processes in Salesforce requires tightly coupled chaining and business logic implementations. This library aims to make this process simpler by doing the following:

-   Allows Batch, Queueable, or Schedulable to be chained.
-   Exposes extensible classes that have the chaining logic embedded and surfaces abstract methods for custom business logic.
-   Allows sharing of variables between chain members.
-   Allows both promise-like chaining and list-driven chaining.
-   Utilizes Transaction Finalizers for Queueables to ensure the chain can continue even if an uncaught exception is surfaced in the Queueable (including uncatchable limit exceptions).
-   Supports both Iterable and QueryLocator Batch types
-   Allows a max depth to be defined
-   Comes with a custom metadata kill switch that allows stopping Chainables globally or for a specific Chainable implementation
-   Lightweight (<100 lines of testable code)

### With Chainable

Chaining can be accomplished in a promise-like approach...

```java
new ScheduledJob()
    .then(new BatchJob())
    .then(new QueueableJob())
    .then(new AnotherQueueableJob())
    ...
    .run();
```

…or a list-driven approach utilizing the library’s `ChainableUtility` class.

```java
List<Chainable> chainables = new List<Chainables>{
    new ScheduledJob(),
    new BatchJob(),
    new QueueableJob(),
    new AnotherQueueableJob()
    ...
};
ChainableUtility.chain(chainables).run();
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
    public Database.QueryLocator start(BatchableContext context) { ... }

    public void execute(BatchableContext context, List<sObject> scope) { ... }

    public void finish(BatchableContext context) {
        // Custom business logic
        ...
        // Run next asynchronous process
        System.enqueueJob(new QueueableImplementation());
    }
}
```

```java
class QueueableImplementation implements Queueable {
    public void execute(QueueableContext context) {
        // Custom business logic
        ...
        // Run next asynchronous process
        ... and so forth
    }
}
```

## Usage

This provides example implmentations for each Chainable type. If you're interested in additional implementation examples, see the test classes for each Chainable type.

### Chainable Types

#### Queueable

[ChainableQueueable Test Class](https://github.com/tmart2322/apex-async-chainable/blob/master/force-app/main/test/classes/ChainableQueueableTest.cls)

Chainable Queueables are created by extending the `ChainableQueueable` class.

```java
public class ChainableQueueableCustom extends ChainableQueueable {
    protected override Boolean execute() {
        // Queueable execute logic here
        ...
        // Return whether to execute the next Chainable
        return true;
    }
}
```

By default, the ChainableQueueable uses a finalizer to execute the next Chainable. If you'd like to remove the finalizer and run the next Chainable from the current context, call `removeFinalizer` when instantiating the ChainableQueueable.

```java
new ChainableQueueableCustom()
    .removeFinalizer()
    .run();
```

By default, the ChainableFinalizer _will not_ execute the next Chainable if there is an uncaught exception in the ChainableQueueable. If you'd like to execute the next Chainable when there is an uncaught exception, pass true to `setRunNextOnUncaughtException` when instantiating the finalizer using the `setFinalizer` method.

```java
new ChainableQueueableCustom()
    .setFinalizer(new ChainableFinalizer().setRunNextOnUncaughtException(true))
    .run();
```

If more granular control is needed over in ChainableFinalizer (such as logging, custom logic on when to execute next, etc.), extend `ChainableFinalizer` to override the default ChainableFinalizer `execute` method.

```java
public class ChainableFinalizerCustom extends ChainableFinalizer {
    protected override Boolean execute(Boolean defaultRunNext) {
        // Finalizer execute logic here
        ...
        // Use the default ChainableFinalizer logic on whether to run next by returning defaultRunNext.
        // Otherwise, use your own logic to determine whether the next Chainable should be run.
        return defaultRunNext|true|false;
    }
}
```

```java
new ChainableQueueableCustom()
    .setFinalizer(new ChainableFinalizerCustom())
    .run();
```

#### Batch

##### Batch With QueryLocator

[ChainableBatchQueryLocator Test Class](https://github.com/tmart2322/apex-async-chainable/blob/master/force-app/main/test/classes/ChainableBatchQueryLocatorTest.cls)

Chainable Batches with a QueryLocator are created by extending the `ChainableBatchQueryLocator` class.

```java
public class ChainableBatchCustom extends ChainableBatchQueryLocator {
    protected override Database.QueryLocator start() {
        // Batch start logic here
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

The default batch size is 200 for `ChainableBatchQueryLocator` implementations. This can be overridden by passing the batch size to the base class' constructor.

```java
public class ChainableBatchQueryLocatorWithCustomBatchSize extends ChainableBatchQueryLocator {
    public ChainableBatchQueryLocatorWithCustomBatchSize() {
        super(100); // Sets the batch size to 100
    }

    protected override Database.QueryLocator start() { ... }

    protected override void execute(List<sObject> scope) { ... }

    protected override Boolean finish() { ... }
}
```

##### Batch With Iterable

[ChainableBatchIterable Test Class](https://github.com/tmart2322/apex-async-chainable/blob/master/force-app/main/test/classes/ChainableBatchIterableTest.cls)

Chainable Batches with an Iterable are created by extending the `ChainableBatchIterable` class.

```java
public class ChainableBatchIterableCustom extends ChainableBatchIterable {
    protected override Iterable<Object> start() {
        // Batch start logic here
        ...
    }

    protected override void execute(Iterable<Object> scope) {
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

The default batch size is 200 for `ChainableBatchIterable` implementations. This can be overridden by passing the batch size to the base class' constructor.

```java
public class ChainableBatchIterableWithCustomBatchSize extends ChainableBatchIterable {
    public ChainableBatchIterableWithCustomBatchSize() {
        super(100); // Sets the batch size to 100
    }

    protected override Iterable<Object> start() { ... }

    protected override void execute(Iterable<Object> scope) { ... }

    protected override Boolean finish() { ... }
}
```

#### Schedulable

[ChainableSchedulable Test Class](https://github.com/tmart2322/apex-async-chainable/blob/master/force-app/main/test/classes/ChainableSchedulableTest.cls)

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
public class ChainableSchedulableWithExecute extends ChainableSchedulable {
    public ChainableSchedulableWithExecute() { ... }
    protected override Boolean execute() {
        // Schedulable execute logic here
        ...
        // Return whether to execute the next Chainable
        return true;
    }
}
```

### Other Usage Info

#### Using Kill Switch

Use the `Chainable_Kill_Switch__mdt` Custom Metadata Type to stop the execution of a Chainable if needed.

This library comes with a Global Kill Switch by default which will stop the execution of all Chainables. If you'd like to stop executions for a specific Chainable, you can create a new Custom Metadata record and specify the `Class Name` field to configure it for the specific Chainable implementation.

#### Using Pass Through

Any `Chainable` implementation can access the `passThrough` variable. This persists across Chainables and any updates are reflected in succeeding Chainables.

Pass Through can either be initalized in the promise-like approach by calling the `setPassThrough` method...

```java
new SomeChainable().setPassThrough(customObject).run();
```

... or by calling `setPassThrough` after `chain` is called in `ChainableUtility`

```java
ChainableUtility.chain(chainables).setPassThrough(customObject).run();
```

Pass Through can be updated at any point in the Chainable execution by using the `setPassThrough` method.

```java
this.setPassThrough(customObject);
```

Pass Through can be accessed at any point in the Chainable execution by using the `getPassThrough` method.

```java
Object customObject = this.getPassThrough();
```

#### Setting Max Depth

There is a risk of infinite recursion if additional jobs are chained within a chainable without an end case defined. In this case, you can use set the maximum depth which will stop the chainable execution at that depth.

Max depth can either be initialized in the promise-like approach by calling the `setMaxDepth` method...

```java
new SomeChainable().setMaxDepth(depth).run();
```

... or by calling `setMaxDepth` after `chain` is called in `ChainableUtility`

```java
ChainableUtility.chain(chainables).setMaxDepth(depth).run();
```

#### Accessing Queueable, Schedulable, Batch, or Finalizer Context

The context of each asynchronous process is saved on the Chainable prior to the developer-implemented methods. These can be accessed by the `context` variable.

```java
QueueableContext context = this.context; // In ChainableQueueable 'execute' method
SchedulableContext context = this.context; // In ChainableSchedulable 'execute' method
Database.BatchableContext context = this.context; // In ChainableBatch 'start', 'execute', and 'finish' methods
FinalizerContext context = this.context; // In ChainableFinalizer 'execute' method
```

#### Adding a Chainable in the Middle of a Chainable Execution

A Chainable can be added at any point in a Chainable's execution by using the `then` method. This will set the Chainable as the next Chainable to run and the remaining Chainables will be run after.

```java
this.then(new SomeChainable());
```
