//
//  Calculator.swift
//  One
//
//  Created by Tingwu on 2023/12/10.
//  https://en.wikipedia.org/wiki/Shunting_yard_algorithm

import Foundation

class Calculator {

    static var lastAnswer: BComplex? = nil
    static let operatorPrecedence: [String: Int] = ["plus": 0, "minus": 0, "multiply": 1, "divide": 1]

    static func evaluate(expression: [ElementWithID]) throws -> String {
        // Check brackets are all paired
        // Check no placeholder
        var i = 0
        while i < expression.count - 1 {
            switch expression[i].element.type {
            case .placeholder:
                throw CalculationError.expressionIncomplete
            case .bracket_start, .bracket_end:
                if expression[i].pair == nil {
                    throw CalculationError.unpairedBrackets
                }
            default:
                break
            }
            i += 1
        }

        // Transform
        //   - From: (  2  +  pi   )  *  4  +  fracS    1  3  +  4  ,  2  fracE
        //   - To:   (  2  +  3.14 )  *  4  +  frac  (  13    +  4  ,  2  )
        var newArray: [ElementWithNumber] = []
        i = 0
        while i < expression.count - 1 {
            switch expression[i].element.type {
            case .number:
                // Combine numbers
                let tmp = try getNumber(expression: expression, index: i)
                i = tmp.nextIndex
                newArray.append(ElementWithNumber(tmp.number))
                continue
            case .func_start, .semi_start:
                newArray.append(ElementWithNumber(expression[i].element))
                newArray.append(ElementWithNumber(Element.bracket_start))
            case .func_end, .semi_end:
                newArray.append(ElementWithNumber(Element.bracket_end))
            case .character:
                if expression[i].element != .answer {
                    newArray.append(ElementWithNumber(expression[i].element.characterValue))
                } else if let ans = lastAnswer {
                    newArray.append(ElementWithNumber(ans))
                } else {
                    throw CalculationError.noLastAnswer
                }
            default:
                newArray.append(ElementWithNumber(expression[i].element))
            }

            i += 1
        }

        // Insert multiplication
        i = 0
        while i < newArray.count - 1 {
            switch (newArray[i].element?.type, newArray[i+1].element?.type) {
            case (nil, nil), (nil, .bracket_start), (.bracket_end, nil), (.bracket_end, .bracket_start), (nil, .func_start), (.bracket_end, .func_start), (nil, .semi_start), (.bracket_end, .semi_start):
                newArray.insert(ElementWithNumber(Element.multiply), at: i+1)
                i += 1
            default:
                break
            }
            i += 1
        }
        
        // Shunting yard
        var outputQueue: [ElementWithNumber] = []
        var operatorStack = Stack<Element>()
        i = 0
        while i < newArray.count {
            if newArray[i].isNumber {
                outputQueue.append(newArray[i])
            } else {
                if let element = newArray[i].element {
                    switch element.type {
                    case .func_start, .semi_start:
                        operatorStack.push(element)

                    case .symbol:
                        let currentOpPrecedence = self.operatorPrecedence[element.string]!
                        while let topOp = operatorStack.peek(), topOp.type == .symbol, currentOpPrecedence <= self.operatorPrecedence[topOp.string]! {
                            outputQueue.append(ElementWithNumber(operatorStack.pop()!))
                        }
                        operatorStack.push(element)

                    case .separator:
                        while !operatorStack.isEmpty() && operatorStack.peek()!.type != .bracket_start {
                            outputQueue.append(ElementWithNumber(operatorStack.pop()!))
                        }

                    case .bracket_start:
                        operatorStack.push(element)

                    case .bracket_end:
                        while !operatorStack.isEmpty() && operatorStack.peek()!.type != .bracket_start {
                            outputQueue.append(ElementWithNumber(operatorStack.pop()!))
                        }
                        _ = operatorStack.pop()
                        if !operatorStack.isEmpty() && (operatorStack.peek()!.type == .func_start || operatorStack.peek()!.type == .semi_start) {
                            outputQueue.append(ElementWithNumber(operatorStack.pop()!))
                        }

                    default:
                        break
                    }
                }
            }
            i += 1
        }

        while !operatorStack.isEmpty() {
            outputQueue.append(ElementWithNumber(operatorStack.pop()!))
        }

        let tmpArray: [String] = outputQueue.map({ $0.isNumber ? ($0.number?.description ?? "") : ($0.element?.string ?? "") })
        print("RPN:")
        print(tmpArray)

        // Evaluate RPN
        var resultStack = Stack<ElementWithNumber>()
        i = 0
        while i < outputQueue.count {
            if outputQueue[i].isNumber {
                resultStack.push(outputQueue[i])
                i += 1
                continue
            }
            let newOperator = outputQueue[i].element!
            if newOperator.type == .symbol {
                if let n2 = resultStack.pop()?.number, let n1 = resultStack.pop()?.number  {
                    switch newOperator {
                    case .plus:
                        resultStack.push(ElementWithNumber(n1 + n2))
                    case .minus:
                        resultStack.push(ElementWithNumber(n1 - n2))
                    case .multiply:
                        resultStack.push(ElementWithNumber(n1 * n2))
                    default:
                        resultStack.push(try ElementWithNumber(n1 / n2))
                    }
                } else {
                    throw CalculationError.wrongOperatorPlacement
                }
            } else if newOperator.type == .func_start || newOperator.type == .semi_start {
                var paramArray: [BComplex] = []
                for _ in 0..<newOperator.numOfParams {
                    if let n = resultStack.pop()?.number {
                        paramArray.append(n)
                    } else {
                        throw CalculationError.unknown
                    }
                }
                paramArray.reverse()
                resultStack.push(ElementWithNumber(try newOperator.evaluate(paramArray)))
            }
            i += 1
        }

        self.lastAnswer = resultStack.peek()!.number!

        let evaluationResult: BComplex = resultStack.peek()!.number!

        // Transform result
        var reStr = evaluationResult.re.decimalExpansion(precisionAfterDecimalPoint: 5)
        var imStr = evaluationResult.im.decimalExpansion(precisionAfterDecimalPoint: 5)

        while reStr[reStr.index(before: reStr.endIndex)] == "0" {
            reStr = String(reStr.dropLast())
        }
        if reStr[reStr.index(before: reStr.endIndex)] == "." {
            reStr = String(reStr.dropLast())
        }

        while imStr[imStr.index(before: imStr.endIndex)] == "0" {
            imStr = String(imStr.dropLast())
        }
        if imStr[imStr.index(before: imStr.endIndex)] == "." {
            imStr = String(imStr.dropLast())
        }

        if evaluationResult.re == 0 && evaluationResult.im == 0 {
            return "0"
        } else if evaluationResult.im == 0 {
            return reStr
        } else if evaluationResult.re == 0 {
            if evaluationResult.im > 0 {
                return (imStr == "1" ? "" : imStr) + "i"
            }
            return "-" + (imStr == "-1" ? "" : imStr.dropFirst()) + "i"
        } else {
            if evaluationResult.im > 0 {
                return reStr + " + " + (imStr == "1" ? "" : imStr) + "i"
            }
            return reStr + " - " + (imStr == "-1" ? "" : imStr.dropFirst()) + "i"
        }
    }

    static func numberToString(number: BDouble) -> String {
        return ""
    }

    static func getNumber(expression: [ElementWithID], index: Int) throws -> (number: BComplex, nextIndex: Int) {
        var i = index
        var str = ""
        while expression[i].element.type == .number {
            str += expression[i].element.string
            i += 1
        }

        if let number = BDouble(str) {
            return (number: BComplex(re: number), nextIndex: i)
        }
        throw CalculationError.notANumber
    }

    struct ElementWithNumber {
        var element: Element? = nil
        var number: BComplex? = nil

        init(_ element: Element) {
            self.element = element
        }

        init(_ number: BComplex) {
            self.number = number
        }

        var isNumber: Bool {
            number != nil
        }
    }

    struct Stack<Item> {
        private var storage = [Item]()
        func peek() -> Item? { storage.last }
        func isEmpty() -> Bool { storage.count == 0 }
        mutating func push(_ item: Item) { storage.append(item)  }
        mutating func pop() -> Item? { storage.popLast() }
    }

}
