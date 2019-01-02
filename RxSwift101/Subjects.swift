//
//  Subjects.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2018-12-08.
//  Copyright © 2018 Siddarth Kalra. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableFactory {

    func publishSubjectExample() -> PublishSubject<String> {
        let subject = PublishSubject<String>()

        subject.subscribe { (event) in
            switch event {
            case .next(let element):
                print(element)
            case .error(let error):
                print(error)
            case .completed:
                print("complete")
            }
        }.disposed(by: disposeBag)

        subject.onNext("A")
        subject.onNext("B")
        subject.onNext("C")
        subject.onCompleted()

        return subject
    }

    func behaviorSubjectExample() -> BehaviorSubject<String> {
        let subject = BehaviorSubject<String>(value: "A")

        subject.subscribe { (event) in
            switch event {
            case .next(let element):
                print(element)
            case .error(let error):
                print(error)
            case .completed:
                print("complete")
            }
        }.disposed(by: disposeBag)

        subject.onNext("B")

        return subject
    }

    func replaySubjectExample() -> ReplaySubject<String> {
        let subject = ReplaySubject<String>.create(bufferSize: 2)

        subject.subscribe { (event) in
            switch event {
            case .next(let element):
                print(element)
            case .error(let error):
                print(error)
            case .completed:
                print("complete")
            }
        }.disposed(by: disposeBag)

        subject.onNext("A")
        subject.onNext("B")
        subject.onNext("C")
        subject.onNext("D")
        subject.onNext("E")

        return subject
    }

    func variableExample() -> Observable<String> {
        let variable = Variable<String>("A")
        let variableObservable = variable.asObservable()

        variableObservable.subscribe { (event) in
            switch event {
            case .next(let element):
                print(element)
            case .error(let error):
                print(error)
            case .completed:
                print("complete")
            }
        }.disposed(by: disposeBag)

        variable.value = "B"
        variable.value = "C"

        return variableObservable
    }
}
