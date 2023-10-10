//
//  ElementProperty.swift
//  One
//
//  Created by Tingwu on 2023/10/10.
//

import Foundation

struct ElementProperty {
    var type: ElementType
    var string: String = ""
    var dimension: ExpressionDim = ExpressionDim()
}

class Element {
    let type: ElementType
    let string: String
    let dimension: ExpressionDim
    
    init(type: ElementType, string: String = "", dimension: ExpressionDim = ExpressionDim()) {
        self.type = type
        self.string = string
        self.dimension = dimension
    }
    
    static let null = Element(type: .other)
    
    static let one = 
    Element(type: .character, string: "1", dimension: ExpressionDim(width: 15, height: 30))
    static let two =
    Element(type: one.type, string: "2", dimension: one.dimension)
    static let three = 
    Element(type: one.type, string: "3", dimension: one.dimension)
    static let four = 
    Element(type: one.type, string: "4", dimension: one.dimension)
    static let five = 
    Element(type: one.type, string: "5", dimension: one.dimension)
    static let six = 
    Element(type: one.type, string: "6", dimension: one.dimension)
    static let seven = 
    Element(type: one.type, string: "7", dimension: one.dimension)
    static let eight = 
    Element(type: one.type, string: "8", dimension: one.dimension)
    static let nine = 
    Element(type: one.type, string: "9", dimension: one.dimension)
    static let zero = 
    Element(type: one.type, string: "0", dimension: one.dimension)
    
    static let point =
    Element(type: .character, string: ".", dimension: ExpressionDim(width: 10, height: 30))
    
    static let answer =
    Element(type: .character, string: "Ans", dimension: ExpressionDim(width: 52, height: 30))
    
    static let plus =
    Element(type: .symbol, string: "plus", dimension: ExpressionDim(width: 25, height: 30))
    static let minus =
    Element(type: plus.type, string: "minus",    dimension: plus.dimension)
    static let multiply =
    Element(type: plus.type, string: "multiply", dimension: plus.dimension)
    static let divide =
    Element(type: plus.type, string: "divide",   dimension: plus.dimension)
    
    static let paren_l =
    Element(type: .character, string: "(", dimension: ExpressionDim(width: 15, height: 30))
    static let paren_r =
    Element(type: paren_l.type, string: ")", dimension: paren_l.dimension)
    
    static let STA_frac = Element(type: .func_start)
    static let END_frac = Element(type: .func_end)
    
    static let PLH = Element(type: .placeholder, dimension: ExpressionDim(width: 25, height: 30))
    static let SEP = Element(type: .other)
    static let END = Element(type: .other)
}
