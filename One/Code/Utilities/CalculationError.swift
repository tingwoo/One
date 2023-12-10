//
//  CalculationError.swift
//  One
//
//  Created by Tingwu on 2023/12/11.
//

import Foundation

enum CalculationError: Error {
    case divisionByZero
    case nonRealExponent
    case expressionIncomplete
    case unpairedBrackets
    case wrongFormat
    case notANumber
    case unknown
}
