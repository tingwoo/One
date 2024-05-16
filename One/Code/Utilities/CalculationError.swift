//
//  CalculationError.swift
//  One
//
//  Created by Tingwu on 2023/12/11.
//

import Foundation

// TODO: add String raw value to directly present them
enum CalculationError: String, Error {
    case divisionByZero = "除以0的結果沒有定義"
    case nonRealExponent = "函數只接受實數"
    case zeroExponent = "0的0次方沒有定義"
    case negativeExponent = "負數的非整數次方沒有定義"
    case expressionIncomplete = "有尚未填上的空格"
    case unpairedBrackets = "有無法配對的括弧"
    case notANumber = "輸入了錯誤的數字格式"
    case wrongOperatorPlacement = "運算符輸入錯誤"
    case noLastAnswer = "「Ans」沒有儲存數值"
    case unknown = "未知的錯誤"
}
