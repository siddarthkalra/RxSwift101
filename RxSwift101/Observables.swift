//
//  Observables.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2018-12-05.
//  Copyright © 2018 Siddarth Kalra. All rights reserved.
//

import Foundation
import RxSwift

extension String: Error { }

class ObservableFactory {

    let disposeBag = DisposeBag()

    func observeAllEventsTogether() -> Observable<String> {
        let observable = Observable.of("A", "B", "C")

        _ = observable.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)

        return observable
    }

    func observeAllEventsSeparately() -> Observable<String> {
        let observable = Observable.of("1", "2", "3", "4")

        _ = observable.subscribe(onNext: { (datum) in
            print("datum: \(datum)")
        }, onError: { (error) in
            print("error: \(error)")
        }, onCompleted: {
            print("complete")
        }).disposed(by: disposeBag)

        return observable
    }

    func sequenceWithError() -> Observable<String> {
        let observable = Observable.of("1", "2", "3", "4")
        let observableError = Observable<String>.error("error happened")

        let observableZipped = Observable.concat([observable, observableError])

        _ = observableZipped.subscribe(onNext: { (datum) in
            print("datum: \(datum)")
        }, onError: { (error) in
            print("error: \(error)")
        }, onCompleted: {
            print("complete")
        }).disposed(by: disposeBag)

        return observableZipped
    }

}
