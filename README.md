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
            -   [Schedulable](#schedulable)
        -   [Other Usage Info](#other-usage-info)
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
-   Utilizes Finalizers for Queueables to ensure the chain can continue even if an uncaught exception is surfaced in the Queueable (including uncatchable limit exceptions).
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
        // Custom business Logic
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

Custom Finalizers also be defined by extending the `ChainableFinalizer` class.

```java
public class ChainableFinalizerCustom extends ChainableFinalizer {
    protected override void execute() {
        // Custom logic when the Finalizer executes
        ...
    }
}
```

```java
public class ChainableQueueableWithCustomFinalizer extends ChainableQueueable {
    public ChainableQueueableWithCustomFinalizer() {
        super(new ChainableFinalizerCustom());
    }

    protected override Boolean execute() { ... }
}
```

By default, the Finalizer _will not_ execute the next Chainable if there is an uncaught exception in the Queueable. If you'd like to execute the next Chainable when there is an uncaught exception, pass true to the ChainableFinalizer's constructor.

```java
public class ChainableQueueableCustom extends ChainableQueueable {
    public ChainableQueueableCustom() {
        super(new ChainableFinalizer(true));
    }

    protected override Boolean execute() { ... }
}
```

#### Batch

[ChainableBatch Test Class](https://github.com/tmart2322/apex-async-chainable/blob/master/force-app/main/test/classes/ChainableBatchTest.cls)

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
public class ChainableBatchWithCustomBatchSize extends ChainableBatch {
    public ChainableBatchWithCustomBatchSize() {
        super(100); // Sets the batch size to 100
    }

    protected override Database.QueryLocator start() { ... }

    protected override void execute(List<sObject> scope) { ... }

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
    protected override void execute() {
        // Schedulable execute logic here
        ...
    }
}
```

### Other Usage Info

#### Using Pass Through

Any `Chainable` implementation can access the `passThrough` variable. This persists across Chainables and any updates are reflected in succeeding Chainables.

Pass Through can either be initalized in the promise-like approach by calling the `setPassThrough` method...

```java
new SomeChainable().setPassThrough(customObject).run();
```

... or by calling after calling `setPassThrough` after `chain` is called in `ChainableUtility`

```java
ChainableUtility.chain(chainables).setPassThrough(customObject).run();
```

Pass Through can be updated at any point in the Chainable execution by using the `setPassThrough` method.

```java
this.setPassThrough(customObject);
```

Pass Through can be accessed at any point in the Chainable execution by accessing the `passThrough` instance variable.

```java
Object customObject = this.getPassThrough();
```

#### Setting Max Depth

There is a risk of infinite recursion if additional jobs are chained within a chainable without an end case defined. In this case, you can use set the maximum depth which will stop the chainable execution at that depth.

Max depth can either be initialized in the promise-like approach by calling the `setMaxDepth` method...

```java
new SomeChainable().setMaxDepth(depth).run();
```

... or by calling after calling `setMaxDepth` after `chain` is called in `ChainableUtility`

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
