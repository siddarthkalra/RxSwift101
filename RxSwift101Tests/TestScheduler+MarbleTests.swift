import Foundation
import RxTest
import RxCocoa
import RxSwift

let resolution: TimeInterval = 0.2 // seconds

extension TestableObserver {
    var firstElement: E? {
        return events.first!.value.element
    }
    var lastElement: E? {
        return events.last!.value.element
    }
    func element(atIndex index: Int) -> E? {
        return events[index].value.element
    }
}

extension TestScheduler {
    func parseEventsAndTimes<T>(timeline: String, values: [String: T], errors: [String: Swift.Error] = [:]) -> [[Recorded<Event<T>>]] {
        //print("parsing: \(timeline)")
        typealias RecordedEvent = Recorded<Event<T>>

        let timelines = timeline.components(separatedBy: "|")

        let allExceptLast = timelines[0 ..< timelines.count - 1]

        return (allExceptLast.map { $0 + "|" } + [timelines.last!])
            .filter { $0.count > 0 }
            .map { timeline -> [Recorded<Event<T>>] in
                let segments = timeline.components(separatedBy:"-")
                let (time: _, events: events) = segments.reduce((time: 0, events: [RecordedEvent]())) { state, event in
                    let tickIncrement = event.count + 1

                    if event.count == 0 {
                        return (state.time + tickIncrement, state.events)
                    }

                    if event == "#" {
                        let errorEvent = RecordedEvent(time: state.time, value: Event<T>.error(NSError(domain: "Any error domain", code: -1, userInfo: nil)))
                        return (state.time + tickIncrement, state.events + [errorEvent])
                    }

                    if event == "|" {
                        let completed = RecordedEvent(time: state.time, value: Event<T>.completed)
                        return (state.time + tickIncrement, state.events + [completed])
                    }

                    guard let next = values[event] else {
                        guard let error = errors[event] else {
                            fatalError("Value with key \(event) not registered as value:\n\(values)\nor error:\n\(errors)")
                        }

                        let nextEvent = RecordedEvent(time: state.time, value: Event<T>.error(error))
                        return (state.time + tickIncrement, state.events + [nextEvent])
                    }

                    let nextEvent = RecordedEvent(time: state.time, value: Event<T>.next(next))
                    return (state.time + tickIncrement, state.events + [nextEvent])
                }

                //print("parsed: \(events)")
                return events
        }
    }

    /**
     Creates driver for marble test.

     - parameter timeline: Timeline in the form `---a---b------c--|`
     - parameter values: Dictionary of values in timeline. `[a:1, b:2]`

     - returns: Driver specified by timeline and values.
     */
    //    func createDriver<T>(timeline: String, values: [String: T]) -> Driver<T> {
    //        return createObservable(timeline: timeline, values: values, errors: [:]).asDriver(onErrorRecover: { (error) -> Driver<T> in
    //            genericFatal("This can't error out")
    //        })
    //    }

    /**
     Creates observable for marble tests.

     - parameter timeline: Timeline in the form `---a---b------c--|`
     - parameter values: Dictionary of values in timeline. `[a:1, b:2]`
     - parameter errors: Dictionary of errors in timeline.

     - returns: Observable sequence specified by timeline and values.
     */
    func createObservable<T>(timeline: String, values: [String: T], errors: [String: Swift.Error] = [:]) -> Observable<T> {
        let events = self.parseEventsAndTimes(timeline: timeline, values: values, errors: errors)
        return createObservable(events)
    }

    /**
     Creates observable for marble tests.

     - parameter events: Recorded events to replay.

     - returns: Observable sequence specified by timeline and values.
     */
    func createObservable<T>(_ events: [Recorded<Event<T>>]) -> Observable<T> {
        return createObservable([events])
    }

    /**
     Creates observable for marble tests.

     - parameter events: Recorded events to replay. This overloads enables modeling of retries.
     `---a---b------c----#|----a--#|----b`
     When next observer is subscribed, next sequence will be replayed. If all sequences have
     been replayed and new observer is subscribed, `fatalError` will be raised.

     - returns: Observable sequence specified by timeline and values.
     */
    func createObservable<T>(_ events: [[Recorded<Event<T>>]]) -> Observable<T> {
        var attemptCount = 0
        print("created for \(events)")

        return Observable.create { observer in
            if attemptCount >= events.count {
                fatalError("This is attempt # \(attemptCount + 1), but timeline only allows \(events.count).\n\(events)")
            }

            let scheduledEvents = events[attemptCount].map { event in
                return self.scheduleRelative((), dueTime: resolution * TimeInterval(event.time)) { _ in
                    observer.on(event.value)
                    return  Disposables.create()
                }
            }

            attemptCount += 1

            return Disposables.create(scheduledEvents)
        }
    }

    /**
     Enables simple construction of mock implementations from marble timelines.

     - parameter Arg: Type of arguments of mocked method.
     - parameter Ret: Return type of mocked method. `Observable<Ret>`

     - parameter values: Dictionary of values in timeline. `[a:1, b:2]`
     - parameter errors: Dictionary of errors in timeline.
     - parameter timelineSelector: Method implementation. The returned string value represents timeline of
     returned observable sequence. `---a---b------c----#|----a--#|----b`

     - returns: Implementation of method that accepts arguments with parameter `Arg` and returns observable sequence
     with parameter `Ret`.
     */
    func mock<Arg, Ret>(values: [String: Ret], errors: [String: Swift.Error] = [:], timelineSelector: @escaping (Arg) -> String) -> (Arg) -> Observable<Ret> {
        return { (parameters: Arg) -> Observable<Ret> in
            let timeline = timelineSelector(parameters)

            return self.createObservable(timeline: timeline, values: values, errors: errors)
        }
    }

    /**
     Builds testable observer for s specific observable sequence, binds it's results and sets up disposal.

     - parameter source: Observable sequence to observe.
     - returns: Observer that records all events for observable sequence.
     */
    func record<O: ObservableConvertibleType>(source: O) -> TestableObserver<O.E> {
        let observer = self.createObserver(O.E.self)
        let disposable = source.asObservable().bind(to: observer)
        self.scheduleAt(100000) {
            disposable.dispose()
        }
        return observer
    }
}
