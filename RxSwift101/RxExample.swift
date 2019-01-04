//
//  RxExample.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2018-12-31.
//  Copyright © 2018 Siddarth Kalra. All rights reserved.
//

import RxSwift

enum RxExample: String, CustomStringConvertible {
    case observeAllEventsTogether = "Observable Sequence, all events together"
    case observeAllEventsSeparately = "Observable Sequence, all events separately"
    case sequenceWithError = "Observable Sequence with Error"
    case publishSubjectExample = "Publish Subject"
    case behaviorSubjectExample = "Behavior Subject"
    case replaySubjectExample = "Replay Subject"
    case variableExample = "Variable"
    case publishRelayExample = "Publish Relay"
    case behaviorRelayExample = "Behavior Relay"
    case mergeFilterExample = "Merge and Filter"

    var description: String {
        return rawValue
    }
}

class RxExampleFactory {

    typealias ExampleClosure = () -> Observable<String>
    static let factory: ObservableFactory = ObservableFactory()

    static func exampleClosure(forExample example: RxExample) -> ExampleClosure {
        switch example {
        case .observeAllEventsTogether:
            return factory.observeAllEventsTogether
        case .observeAllEventsSeparately:
            return factory.observeAllEventsSeparately
        case .sequenceWithError:
            return factory.sequenceWithError
        case .publishSubjectExample:
            return factory.publishSubjectExample
        case .behaviorSubjectExample:
            return factory.behaviorSubjectExample
        case .replaySubjectExample:
            return factory.replaySubjectExample
        case .variableExample:
            return factory.variableExample
        case .publishRelayExample:
            return factory.publishRelayExample().asObservable
        case .behaviorRelayExample:
            return factory.behaviorRelayExample().asObservable
        case .mergeFilterExample:
            return factory.mergeFilterExample
        }
    }


}
