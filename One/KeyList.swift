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

var keyboardLayout: [[[keySet]]] = [[[keySet(19, optionsR: [17, 18]), keySet(7),  keySet(8), keySet(9), keySet(20, optionsL: [16])],
                                     [keySet(26, optionsR: [27, 28]), keySet(4),  keySet(5),  keySet(6),  keySet(15)],
                                     [keySet(21, optionsR: [22, 23]), keySet(1), keySet(2), keySet(3), keySet(14)],
                                     [keySet(24), keySet(10), keySet(11, optionsR: [25]), keySet(12), keySet(13)]],
                                    
                                    [[keySet(), keySet(), keySet(), keySet(), keySet()],
                                     [keySet(), keySet(), keySet(), keySet(), keySet()],
                                     [keySet(), keySet(), keySet(), keySet(), keySet()],
                                     [keySet(), keySet(), keySet(), keySet(), keySet()]]]

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
                          KeyAttr(text: "(", command: [.bracket_start]),
                          KeyAttr(text: ")", command: [.bracket_end]),
                          KeyAttr(text: "( )", command: [.bracket_start, .bracket_end]),

                          KeyAttr(text: "frac", command: [.frac_start, .PLH, .SEP, .PLH, .frac_end], pairList: [4, nil, 0, nil, 0]),
                          KeyAttr(image: "x.squareroot", command: [.radical_start, .PLH, .SEP, .PLH, .radical_end], pairList: [4, nil, 0, nil, 0]),
                          KeyAttr(text: "sqrt", command: [.radical_start, .two, .SEP, .PLH, .radical_end], pairList: [4, nil, 0, nil, 0], cursorShift: 3),
                          KeyAttr(text: "cbrt", command: [.radical_start, .three, .SEP, .PLH, .radical_end], pairList: [4, nil, 0, nil, 0], cursorShift: 3),

                          KeyAttr(text: "π", command: [.pi]),
                          KeyAttr(image: "percent", command: [.percent]),

                          KeyAttr(text: "pow", command: [.power_start, .PLH, .SEP2, .PLH, .power_end], pairList: [4, nil, 0, nil, 0], cursorShift: 3),
                          KeyAttr(text: "p2", command: [.power_start, .PLH, .SEP2, .two, .power_end], pairList: [4, nil, 0, nil, 0], cursorShift: 5),
                          KeyAttr(text: "p3", command: [.power_start, .PLH, .SEP2, .three, .power_end], pairList: [4, nil, 0, nil, 0], cursorShift: 5),

                          // test
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


// 0 NULL
// 1 1
// 2 2
// 3 3
// 4 4
// 5 5
// 6 6
// 7 7
// 8 8
// 9 9
// 10 0
// 11 .
// 12 ANS
// 13 PLUS
// 14 MINUS
// 15 TIMES
// 16 DIVIDE
// 17 LEFT BRACKET
// 18 RIGHT BRACKET
// 19 BOTH BRACKETS
// 20 FRACTION
