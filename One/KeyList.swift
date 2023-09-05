//
//  KeyList.swift
//  One
//
//  Created by Tingwu on 2023/9/12.
//

import Foundation

//===
//var keyList: [[KeyAttr]] = [[KeyAttr(text: ""), KeyAttr(text: ""), KeyAttr(text: "7"), KeyAttr(text: "4"), KeyAttr(text: "1"), KeyAttr(text: "0")],
//                            [KeyAttr(text: ""), KeyAttr(text: ""), KeyAttr(text: "8"), KeyAttr(text: "5"), KeyAttr(text: "2"), KeyAttr(text: ".")],
//                            [KeyAttr(text: ""), KeyAttr(text: ""), KeyAttr(text: "9"), KeyAttr(text: "6"), KeyAttr(text: "3"), KeyAttr(text: "Ans")],
//                            [KeyAttr(text: ""), KeyAttr(text: ""), KeyAttr(image: "divide"), KeyAttr(image: "multiply"), KeyAttr(image: "minus"), KeyAttr(image: "plus")]]
//
//var keyList2: [[KeyAttr]] = [[KeyAttr(text: "cos"), KeyAttr(text: "sin"), KeyAttr(text: "tan"), KeyAttr(text: "sec"), KeyAttr(text: "csc"), KeyAttr(text: "cot")],
//                            [KeyAttr(text: "acos"), KeyAttr(text: "asin"), KeyAttr(text: "atan"), KeyAttr(text: "asec"), KeyAttr(text: "acsc"), KeyAttr(text: "acot")],
//                            [KeyAttr(text: "cosh"), KeyAttr(text: "sinh"), KeyAttr(text: "tanh"), KeyAttr(text: "sech"), KeyAttr(text: "csch"), KeyAttr(text: "coth")],
//                            [KeyAttr(text: "°"), KeyAttr(text: "\'"), KeyAttr(text: "\""), KeyAttr(text: ""), KeyAttr(text: ""), KeyAttr(text: "")]]
//
//func delete(formula: inout [String]) {
//    if(!formula.isEmpty) {
//        formula.removeLast()
//    }
//}
//
//var funcKeyList: [KeyAttr] = [KeyAttr(image: "delete.left", action: delete), KeyAttr(image: "equal")]
//===

//               ["", "", "8", "5", "2", "."],
//               ["", "", "9", "6", "3", "Ans"],
//               ["", "", "/", "*", "-", "+"]]


var keyArrange: [[[Int?]]] = [[[nil, nil, nil, nil],
                               [17, 18, 19, 20],
                               [7  , 8  , 9  , 16 ],
                               [4  , 5  , 6  , 15 ],
                               [1  , 2  , 3  , 14 ],
                               [10 , 11 , 12 , 13 ]],
                              
                              [[nil, nil, nil, nil],
                               [nil, nil, nil, nil],
                               [nil, nil, nil, nil],
                               [nil, nil, nil, nil],
                               [nil, nil, nil, nil],
                               [nil, nil, nil, nil]],
                              
                              [[nil, nil, nil, nil],
                               [nil, nil, nil, nil],
                               [nil, nil, nil, nil],
                               [nil, nil, nil, nil],
                               [nil, nil, nil, nil],
                               [nil, nil, nil, nil]]]

var keyList: [KeyAttr] = [KeyAttr(),
                          KeyAttr(text: "1"),
                          KeyAttr(text: "2"),
                          KeyAttr(text: "3"),
                          KeyAttr(text: "4"),
                          KeyAttr(text: "5"),
                          KeyAttr(text: "6"),
                          KeyAttr(text: "7"),
                          KeyAttr(text: "8"),
                          KeyAttr(text: "9"),
                          KeyAttr(text: "0"),
                          KeyAttr(text: "."),
                          KeyAttr(text: "Ans"),
                          KeyAttr(image: "plus", command: ["+"]),
                          KeyAttr(image: "minus", command: ["-"]),
                          KeyAttr(image: "multiply", command: ["*"]),
                          KeyAttr(image: "divide", command: ["/"]),
                          KeyAttr(text: "("),
                          KeyAttr(text: ")"),
                          KeyAttr(text: "( )", command: ["(", ")"]),
                          KeyAttr(text: "frac", command: ["frac[", ",", "]"]),]


//0 NIL
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
