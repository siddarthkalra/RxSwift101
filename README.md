# What is Reactive Programming?

Rx is a platform independent programming paradigm. RxSwift is just one member of the Rx frameworks family like RxJava, RxJS, Rx.NET and others. One of the reasons that Rx has become so popular lately is because async programming can be difficult to write and debug. RxSwift aims to make async code easier to write by allowing you to react to new data and process it in a sequential and isolated manner.

# Async Programming

## Cocoa Async APIs

The following are some of the common Cocoa APIs used for async programming:

* NotificationCenter
* Delegate pattern
* GCD
* Closures

## Problems with Async Code
* Lacks determinism - order is not guaranteed
* Shared Mutable State - this makes things inherently thread unsafe
* Imperative Programming - tell the computer exactly when and how to do things by using if, elseif, else, switch, while & for statements. Further, implementation details are exposed which can reduce readability
* Unexpected Side Effects - shared mutable state and unclear imperative declarations can lead to unexpected side effects

# RxSwift's Solution

* Declarative Code - lets you define pieces of behavior with clear intent where implementation details are abstracted away and state is not shared. RxSwift runs these behaviors every time an event occurs and provide immutable and isolated data input. Now, you can work with async code that is sequential and deterministic , as if you were writing a synchronous for loop.
* Reactive Systems have the following properties:
  * responsive - keep the app up-to-date with the latest data
  * resilient - provide abilities for error recovery
  * elastic - can handle varied workload with features such as event throttling
  * message driven - message based communication which leads to isolation and reusability

# Observable Sequences

Observable Sequences form the core building-block of RxSwift development. They provide the ability to emit events that carry an immutable snapshot of the data.  Observer(s) can observe this data in an async manner.

In RxSwift, **everything is a sequence**. You will see `observable`, `observable sequence`, `sequence` and `stream` all used interchangeably.

There are 3 types of events:

* **next** - the latest datum. This is how an observer receives values
* **completed** - the sequence terminated successfully. No more events will be emitted and the sequence will terminate
* **error** - the sequence terminated with an error. No more events will be emitted and the sequence will terminate

Here are some example sequences:

Sequence of numbers:

`--1--2--3--4--5--6--| // terminates normally`

Sequence of characters:

`--a--b--a--a--a---d---X // terminates with error`

Some sequences are finite, like a sequence of file data:

`--chunk--chunk--chunk---| // end of file will eventually be reached`

while others are infinite, like a sequence of button taps:

`---tap-tap-------tap--->`

See more sequences here: [rxmarbles.com](http://rxmarbles.com)

This is the simple contract that RxSwift requires you to fulfill. It does not make any assumptions about the nature of the `Observable` or the `Observer`, which provides the maximum possible decoupling of objects that need to share data. The delegate pattern and closures are not able to achieve the same level of decoupling.

# Subscribing to Observable Sequences

So, we have all these sequences emitting events but how do we actually subscribe to them? The easiest approach is to use the `subscribe()` API like so:

```swift
let one = 1
let two = 2
let three = 3

let observable = Observable.of(one, two, three)

let subscription = observable.subscribe { event in
    print(event)
}
```

See more examples [here](https://github.com/siddarthkalra/RxSwift101/blob/master/RxSwift101/Observables.swift).

# Memory Management

Just like everything else in programming, memory must be managed somehow. Any subscription can be deallocated like so:

```swift
subscription.dispose()
```

However, this approach is not practical for most codebases of medium/high complexity. Thus, RxSwift provides the `DisposeBag` type:

```swift
let disposeBag = DisposeBag() // usually held as a instance/class property

let one = 1
let two = 2
let three = 3

let observable = Observable.of(one, two, three)

observable.subscribe { event in
    print(event)
}.disposed(by: disposeBag)
```

A dispose bag holds disposables and will call `dispose()` subscription for all observables it is holding when the dispose bag itself is deallocted.

# Debugging

* When using RxSwift, stack-traces can be hard to decipher, which can make debugging difficult
* Use the [debug operator](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md#debugging)
* Use logging (standard output, file etc.) a lot

# Subjects

* A Subject is an observable and an observer. It emit events and subscribes to emitted events. There are four types:
  * `PublishSubject` - starts empty and only emits events to current subscribers. No replays for new subscribers
  * `BehaviorSubject` - starts with an initial value. It replays the latest element to new subscribers
  * `ReplaySubject` - Initialized with a buffer size and will replay elements in that buffer to new subscribers
  * `Variable` - Wrapper around a `BehaviorSubject`. It preserves the current value as state and replays the latest value to new subscribers. Unlike other `Subject` types, it is guaranteed not to emit an error and will emit a complete event upon deallocation. This concept will be deprecated from RxSwift and its use should be avoided. Use [BehaviorRelay](#relays) instead

See code examples [here](https://github.com/siddarthkalra/RxSwift101/blob/master/RxSwift101/Subjects.swift).

# Schedulers

* An abstraction for threads, dispatch queues, NSOperationQueues etc
* They do not have a one-to-one relationship to threads
* `subscribeOn` - set which scheduler the observable computation code runs on - not the code in any of the subscription operators but the code that is actually emitting observable events
* `observeOn` - the opposite of `subscribeOn`, this sets the scheduler where the observation runs on

# UI Programming with RxSwift

Instead of using raw observables, use the higher level concepts of relays, drivers and signals. These objects are specifically tailored to work with the UI.

## Relays

* Two kinds: `PublishRelay` and `BehaviorRelay`
* They never complete
* They never emit errors

See code examples [here](https://github.com/siddarthkalra/RxSwift101/blob/master/RxSwift101/Relays.swift).

## RxCocoa Traits

* Driver - Used when working with the UI. See full explanation [here](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/Traits.md#driver).
* Signal - Similar to `Driver`. However, `Driver` replays once when subscribed to, but `Signal` does not. See full explanation [here](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/Traits.md#signal).

# Hot vs. Cold Observables

RxSwift doesn't explicitly differentiate between hot and cold observables (except during testing) unlike other reactive frameworks.

* Cold - data is produced by the observable itself. For each subscriber, the observable starts a new execution, which means that the data is not shared
* Hot - data is produced outside of the observable. Data is shared between multiple observers and is produced regardless if there is a subscriber or not. If there is no subscriber when the data is being produced, the data is lost

# Traits

* Optional helper types that wrap raw observables:
  * Single - instead of emitting a series of elements, it is always guaranteed to emit either a single element or an error. Does not share side effects
  * Completable - can only complete or emit an error. It will never emit any elements. This trait should be used when we only care whether an operation completed or not
  * Maybe - it can either emit a single element, or a completion or an error. Once an event is emitted, no other event will be emitted

# Operators

Operators are functions that you can apply to your observable sequence(s) to transform and/or process them in some manner. Similar to how arithmetic operators +, -, / and * can be combined to create maths expressions, RxSwift operators can be chained together to express programming logic. This is how reactive programming really becomes functional reactive programming (FRP).

Here are some examples:

* Combination operator `merge`:

```swift
let obvA = Observable.of("1", "2", "3", "4")
let obvB = Observable.of("A", "B", "C", "D")

let mergedObv = Observable.merge(obvA, obvB)

// subscribers will receive: 1, A, 2, B, 3, C, 4, D
// http://rxmarbles.com/#merge
```

* Filtering operator `filter`:

```swift
let obvA = Observable.of("1", "2", "3", "4")

let filteredObv = obvA.filter { Int($0)! < 3 }

// subscribers will receive: 1, 2
// http://rxmarbles.com/#filter
```

* Chaining `merge` and `filter`:

```swift
let obvA = Observable.of("1", "2", "3", "4")
let obvB = Observable.of("A", "B", "C", "D")

let mergedFilteredObv = Observable
    .merge(obvA, obvB)
    .filter { Int($0) ?? 10 < 3 }
```

Visit http://rxmarbles.com to get more visual examples on how other operators work or run the app.

# Testing

RxSwift provides a separate framework, RxTest, which provides an easy-to-use API for testing such as a `TestScheduler` class and, hot and cold obervables. Read more about how to use RxTest [here](http://adamborek.com/rxtests-rxactionsheet/).

# Common Use-cases for RxSwift

## MVVM data-binding

MVVM introduces another layer inbetween the view and model layers, which is known as a view model. Somehow data must travel from its original source (e.g. the cloud, user input, local file etc.) and make its way through the layers in your app architecture to reach its final destination (e.g. UI, local file, the cloud etc.). Complex apps will have bi-directional data flow which further complicates the landscape.

To connect the different layers of your app, one can use the usual suspects in Cocoa development - delegates, closures and/or `NotificationCenter`. However, they all have significant drawbacks:

* Delegates - This will lead to protocol explosion. Every view controller and view model combination would have to define their own custom interface
* Closures - Every layer would have to define a closure, which means a series of closures, with the same signature, will get called every time data flows through your app's architecture. This is essentially code duplication which can lead to a maintenance nightmare. Any change to the data being transported will require you to update closures at each layer
* NotificationCenter - The API isn't type-safe and your further coupling your codebase to Apple's platforms, which reduces portability

## Sharing data between Child View Controllers

When using child view controllers, sometimes you need the children to "talk" to each other. That is, when an action is taken by one child, the other child should react to it.

A classic example is a Point of Sale application's register. A register might have a menu item picker on one side (child VC 1) and a cart on the right side (child VC 2). When the user picks a menu item, it should be added to the cart. Again, we could employ the delegate pattern or use a closure to link the two view controllers but RxSwift provides a more elegant and minimal solution - data binding.

See our MVVM with child view controllers example [here](https://github.com/siddarthkalra/RxSwift101/tree/master/RxSwift101/MVVM).

## Networking

RxSwift provides traits like `Single`, `Completable` and `Maybe` that specifically tackle problems that arise when dealing with networking code.

Further, RxSwift provides elegant solutions to certain types of networking problems. For e.g.

* load 2 or more resources simultaneously and wait until all are finished before continuing - this can be solved by employing GCD's `DispatchGroup` but with RxSwift it's a single line:

```swift
let resources = Observable.combineLatest(
    request(endpoint1()),
    request(endpoint2())
)
```

* Chain requests - sometimes network operations depend on each other. For e.g. you might have a request that depends on data seeded by the response from another request. RxSwift makes this easy via the `flatmap` operator.
