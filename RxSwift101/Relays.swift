//
//  Relays.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2018-12-30.
//  Copyright © 2018 Siddarth Kalra. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableFactory {

    func publishRelayExample() -> PublishRelay<String> {
        let relay = PublishRelay<String>()

        relay.subscribe { (event) in
            switch event {
            case .next(let element):
                print(element)
            case .error(let error):
                print(error)
            case .completed:
                print("complete")
            }
        }.disposed(by: disposeBag)

        relay.accept("A")
        relay.accept("B")
        relay.accept("C")

        return relay
    }

    func behaviorRelayExample() -> BehaviorRelay<String> {
        let relay = BehaviorRelay<String>(value: "A")

        relay.subscribe { (event) in
            switch event {
            case .next(let element):
                print(element)
            case .error(let error):
                print(error)
            case .completed:
                print("complete")
            }
        }.disposed(by: disposeBag)

        relay.accept("B")

        return relay
    }

}
