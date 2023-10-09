//
//  ElementModel.swift
//  One
//
//  Created by Tingwu on 2023/9/28.
//

import Foundation

struct ElementModel: Identifiable {
    var id = UUID()
    var name: ElementName
}

struct ElementParamsModel: Equatable {
    var name: ElementName
    var pos: CGPoint
    var param: CGFloat? = nil
}

enum ElementName: String {
    case null
    
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case point = "."
    
    case answer = "Ans"
    
    case plus = "plus"
    case minus = "minus"
    case multiply = "multiply"
    case divide = "divide"
    
    case paren_l = "("
    case paren_r = ")"
    
    case STA_frac
    case END_frac
    
    case PLH = "square.dashed"
    case SEP
    
    case END
    
    func getDimensions() -> ExpressionDim {
        switch self {
        case .null:
            return ExpressionDim()
        
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            return ExpressionDim(width: 15, height: 30)
        case .point:
            return ExpressionDim(width: 10, height: 30)
            
        case .answer:
            return ExpressionDim(width: 30, height: 30)
            
        case .plus, .minus, .multiply, .divide:
            return ExpressionDim(width: 25, height: 30)
            
        case .paren_l, .paren_r:
            return ExpressionDim(width: 15, height: 30)
            
        case .PLH:
            return ExpressionDim(width: 25, height: 30)
            
        case .END:
            return ExpressionDim()

        default:
            return ExpressionDim()
        }
    }
}
