//
//  OptionalType.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2019-01-10.
//  Copyright © 2019 Siddarth Kalra. All rights reserved.
//

import Foundation

protocol OptionalType {
    associatedtype Wrapped
    var asOptional:  Wrapped? { get }
}

extension Optional: OptionalType {
    var asOptional: Wrapped? { return self }
}
