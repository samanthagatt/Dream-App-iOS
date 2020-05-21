//
//  CustomStringInterpolation.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: Optional<Any>, defaultString: @autoclosure () -> String) {
        if let value = value {
            appendLiteral("\(value)")
        } else {
            appendLiteral(defaultString())
        }
    }
    mutating func appendInterpolation(_ starting: String, _ value: Optional<Any>) {
        if let value = value {
            appendLiteral("\(starting)\(value)")
        }
    }
}
