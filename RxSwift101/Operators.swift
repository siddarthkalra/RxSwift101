//
//  Operators.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2019-01-01.
//  Copyright © 2019 Siddarth Kalra. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableFactory {

    func mergeFilterExample() -> Observable<String> {

        let observableA = Observable.of("1", "2", "3", "4")
        let observableB = Observable.of("A", "B", "C", "D")

        let mergedFilteredObv = Observable
            .merge(observableA, observableB)
            .filter { Int($0) ?? 10 < 3 }

        mergedFilteredObv.subscribe { (event) in
            switch event {
            case .next(let element):
                print(element)
            case .error(let error):
                print(error)
            case .completed:
                print("complete")
            }
        }.disposed(by: disposeBag)



        return mergedFilteredObv
    }
    
}

