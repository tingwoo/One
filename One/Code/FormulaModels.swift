//
//  FormulaModels.swift
//  One
//
//  Created by Tingwu on 2023/9/28.
//

import Foundation

struct ElementWithID: Identifiable {
    var id = UUID() // change to normal integers?
    var element: Element
}

struct ElementDisplay: Equatable {
    var element: Element
    var pos: CGPoint
    var scale: CGFloat
    var spare: CGFloat? = nil
}
    
//enum ElementName { //
//    case null
//    
//    case one
//    case two
//    case three
//    case four
//    case five
//    case six
//    case seven
//    case eight
//    case nine
//    case zero
//    case point
//    
//    case answer
//    
//    case plus
//    case minus
//    case multiply
//    case divide
//    
//    case paren_l
//    case paren_r
//    
//    case STA_frac
//    case END_frac
//    
//    case PLH
//    case SEP
//    
//    case END
//}


//class ElementManual { //
//    static let instance = ElementManual()
//    
//    func getType(_ name: ElementName) -> ElementType {
//        if let type = list[name]?.type {
//            return type
//        }
//        return .other
//    }
//    
//    func getString(_ name: ElementName) -> String {
//        if let string = list[name]?.string {
//            return string
//        }
//        return ""
//    }
//    
//    func getDimensions(_ name: ElementName) -> ExpressionDim {
//        if let dim = list[name]?.dimension {
//            return dim
//        }
//        return ExpressionDim()
//    }
//    
//    
//    let list : [ElementName: ElementProperty] = [
//        .null:
//            ElementProperty(type: .other),
//        
//        .one:
//            ElementProperty(type: .character,
//                            string: "1",
//                            dimension: ExpressionDim(width: 15, height: 30)),
//        .two:
//            ElementProperty(type: .character,
//                            string: "2",
//                            dimension: ExpressionDim(width: 15, height: 30)),
//        .three:
//            ElementProperty(type: .character,
//                            string: "3",
//                            dimension: ExpressionDim(width: 15, height: 30)),
//        .four:
//            ElementProperty(type: .character,
//                            string: "4",
//                            dimension: ExpressionDim(width: 15, height: 30)),
//        .five:
//            ElementProperty(type: .character,
//                            string: "5",
//                            dimension: ExpressionDim(width: 15, height: 30)),
//        .six:
//            ElementProperty(type: .character,
//                            string: "6",
//                            dimension: ExpressionDim(width: 15, height: 30)),
//        .seven:
//            ElementProperty(type: .character,
//                            string: "7",
//                            dimension: ExpressionDim(width: 15, height: 30)),
//        .eight:
//            ElementProperty(type: .character,
//                            string: "8",
//                            dimension: ExpressionDim(width: 15, height: 30)),
//        .nine:
//            ElementProperty(type: .character,
//                            string: "9",
//                            dimension: ExpressionDim(width: 15, height: 30)),
//        .zero:
//            ElementProperty(type: .character,
//                            string: "0",
//                            dimension: ExpressionDim(width: 15, height: 30)),
//        .point:
//            ElementProperty(type: .character,
//                            string: ".",
//                            dimension: ExpressionDim(width: 10, height: 30)),
//        .answer:
//            ElementProperty(type: .character,
//                            string: "Ans",
//                            dimension: ExpressionDim(width: 52, height: 30)),
//        .plus:
//            ElementProperty(type: .symbol,
//                            string: "plus",
//                            dimension: ExpressionDim(width: 25, height: 30)),
//        .minus:
//            ElementProperty(type: .symbol,
//                            string: "minus",
//                            dimension: ExpressionDim(width: 25, height: 30)),
//        .multiply:
//            ElementProperty(type: .symbol,
//                            string: "multiply",
//                            dimension: ExpressionDim(width: 25, height: 30)),
//        .divide:
//            ElementProperty(type: .symbol,
//                            string: "divide",
//                            dimension: ExpressionDim(width: 25, height: 30)),
//        .paren_l:
//            ElementProperty(type: .character,
//                            string: "(",
//                            dimension: ExpressionDim(width: 15, height: 30)),
//        .paren_r:
//            ElementProperty(type: .character,
//                            string: ")",
//                            dimension: ExpressionDim(width: 15, height: 30)),
//        .PLH:
//            ElementProperty(type: .placeholder,
//                            dimension: ExpressionDim(width: 25, height: 30)),
//        .END:
//            ElementProperty(type: .other)
//
//    ]
//}
    
