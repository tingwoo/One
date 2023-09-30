//
//  KeyList.swift
//  One
//
//  Created by Tingwu on 2023/9/12.
//

import Foundation

var keyArrange: [[[Int]]] = [[[0  , 0  , 0  , 0  ],
                              [17 , 18 , 19 , 20 ],
                              [7  , 8  , 9  , 16 ],
                              [4  , 5  , 6  , 15 ],
                              [1  , 2  , 3  , 14 ],
                              [10 , 11 , 12 , 13 ]],
                              
                              [[21, 22, 23, 0],
                               [24, 25, 26, 0],
                               [27, 28, 29, 0],
                               [30, 31, 32, 0],
                               [33, 34, 35, 0],
                               [36, 37, 38, 0]],
                              
                              [[0, 0, 0, 0],
                               [0, 0, 0, 0],
                               [0, 0, 0, 0],
                               [0, 0, 0, 0],
                               [0, 0, 0, 0],
                               [0, 0, 0, 0]]]

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
                          KeyAttr(text: "(", command: [.paren_l]),
                          KeyAttr(text: ")", command: [.paren_r]),
                          KeyAttr(text: "( )", command: [.paren_l, .paren_r]),
                          KeyAttr(text: "frac", command: [.STA_frac, .PLH, .SEP, .PLH, .END_frac]),
                          //test
                          KeyAttr(text: "sin", command: [], cursorShift: 0), //21
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
