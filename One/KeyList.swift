//
//  KeyList.swift
//  One
//
//  Created by Tingwu on 2023/9/12.
//

import Foundation

struct keySet {
    var main: Int
    var optionsL: [Int]
    var optionsR: [Int]
    
    init(_ main: Int = 0, optionsL: [Int] = [], optionsR: [Int] = []) {
        self.main = main
        self.optionsL = optionsL
        self.optionsR = optionsR
    }
}

var keyboardLayout: [[[keySet]]] = [[[keySet(19, optionsR: [17, 18]), keySet(7),  keySet(8),  keySet(9),  keySet(20, optionsL: [16])],
                                     [keySet(18), keySet(4),  keySet(5),  keySet(6),  keySet(15)],
                                     [keySet(21, optionsR: [22, 23]), keySet(1),  keySet(2),  keySet(3),  keySet(14)],
                                     [keySet(24), keySet(10), keySet(11, optionsR: [25]), keySet(12), keySet(13)]],
                                    
                                    [[keySet(), keySet(),  keySet(),  keySet(),  keySet()],
                                     [keySet(), keySet(),  keySet(),  keySet(),  keySet()],
                                     [keySet(), keySet(),  keySet(),  keySet(),  keySet()],
                                     [keySet(), keySet(),  keySet(),  keySet(),  keySet()]]]

var keyList: [KeyAttr] = [KeyAttr(text: "", command: [], cursorShift: 0),
                          KeyAttr(text: "1", command: [.one]),
                          KeyAttr(text: "2", command: [.two]),
                          KeyAttr(text: "3", command: [.three]),
                          KeyAttr(text: "4", command: [.four]),
                          KeyAttr(text: "5", command: [.five]),
                          KeyAttr(text: "6", command: [.six]),
                          KeyAttr(text: "7", command: [.seven]),
                          KeyAttr(text: "8", command: [.eight]),
                          KeyAttr(text: "9", command: [.nine]),
                          KeyAttr(text: "0", command: [.zero]),
                          KeyAttr(text: ".", command: [.point]),
                          KeyAttr(text: "Ans", command: [.answer]),
                          KeyAttr(image: "plus", command: [.plus]),
                          KeyAttr(image: "minus", command: [.minus]),
                          KeyAttr(image: "multiply", command: [.multiply]),
                          KeyAttr(image: "divide", command: [.divide]),
                          KeyAttr(text: "(", command: [.S_bracket]),
                          KeyAttr(text: ")", command: [.E_bracket]),
                          KeyAttr(text: "( )", command: [.S_bracket, .E_bracket]),
                          
                          KeyAttr(text: "frac", command: [.S_frac, .PLH, .SEP, .PLH, .E_frac], segments: [2, 4]),
                          KeyAttr(image: "x.squareroot", command: [.S_radical, .PLH, .SEP, .PLH, .E_radical], segments: [2, 4]),
                          KeyAttr(text: "sqrt", command: [.S_radical, .two, .SEP, .PLH, .E_radical], segments: [2, 4], cursorShift: 3),
                          KeyAttr(text: "cbrt", command: [.S_radical, .three, .SEP, .PLH, .E_radical], segments: [2, 4], cursorShift: 3),
                          
                          KeyAttr(text: "π", command: [.pi]),
                          KeyAttr(image: "percent", command: [.percent]),
                          
                          //test
//                          KeyAttr(text: "sin", command: [], cursorShift: 0), //21
                          KeyAttr(text: "asin", command: [], cursorShift: 0),
                          KeyAttr(text: "sinh", command: [], cursorShift: 0),
                          KeyAttr(text: "cos", command: [], cursorShift: 0),
                          KeyAttr(text: "acos", command: [], cursorShift: 0),
                          KeyAttr(text: "cosh", command: [], cursorShift: 0),
                          KeyAttr(text: "tan", command: [], cursorShift: 0),
                          KeyAttr(text: "atan", command: [], cursorShift: 0),
                          KeyAttr(text: "tanh", command: [], cursorShift: 0),
                          KeyAttr(text: "csc", command: [], cursorShift: 0),
                          KeyAttr(text: "acsc", command: [], cursorShift: 0),
                          KeyAttr(text: "csch", command: [], cursorShift: 0),
                          KeyAttr(text: "sec", command: [], cursorShift: 0),
                          KeyAttr(text: "asec", command: [], cursorShift: 0),
                          KeyAttr(text: "sech", command: [], cursorShift: 0),
                          KeyAttr(text: "cot", command: [], cursorShift: 0),
                          KeyAttr(text: "acot", command: [], cursorShift: 0),
                          KeyAttr(text: "coth", command: [], cursorShift: 0),]


//0 NULL
//1 1
//2 2
//3 3
//4 4
//5 5
//6 6
//7 7
//8 8
//9 9
//10 0
//11 .
//12 ANS
//13 PLUS
//14 MINUS
//15 TIMES
//16 DIVIDE
//17 LEFT BRACKET
//18 RIGHT BRACKET
//19 BOTH BRACKETS
//20 FRACTION
