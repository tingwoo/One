//
//  FormulaManager.swift
//  One
//
//  Created by Tingwu on 2023/9/20.
//

import Foundation
import SwiftUI

class FormulaManager: ObservableObject {
    @Published private var formula: [String]
    @Published private var cursorLocation: Int
    
    private var keyList: [KeyAttr]
    
    private let hapticManager = HapticManager.instance
    
    init(){
        self.formula = []
        self.keyList = [KeyAttr(),
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
        self.cursorLocation = 0
    }
    
    init(testFormula: [String]){
        self.formula = testFormula
        self.keyList = [KeyAttr(),
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
        self.cursorLocation = 0
    }
    
    func insert(keyID: Int) {
        if(keyID >= 0 && keyID < keyList.count) {
            for i in keyList[keyID].command.indices {
                self.formula.insert(keyList[keyID].command[i], at: self.cursorLocation + i)
            }
            self.cursorLocation += keyList[keyID].command.count
        }
        
//        print("append")
//        print(self.formula)
    }
    
    func backspace() {
        if(self.cursorLocation - 1 >= 0) {
            self.cursorLocation -= 1
            self.formula.remove(at: self.cursorLocation)
        }
    }
    
    func clearAll() {
        self.cursorLocation = 0
        self.formula.removeAll() 
    }
    
    func shiftCursor(shift: Int) {
        if(self.cursorLocation + shift == formula.count || self.cursorLocation + shift == 0){
            self.cursorLocation += shift
            self.hapticManager.impact(style: .soft)
            
        } else if(self.cursorLocation + shift >= 0 && self.cursorLocation + shift <= formula.count) {
            self.cursorLocation += shift
            self.hapticManager.wheel()
        }
    }
    
    // scope: (start: Int, end: Int)
    @ViewBuilder func display() -> some View {
        HStack(spacing: 0) {
            if(self.formula.isEmpty){
                Text("Problem")
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(.secondary)
            }else{
                ForEach(0..<(self.formula.count+1), id: \.self) { i in
                    if(i < self.cursorLocation){
                        Text(self.formula[i])
                            .font(.custom("CMUConcrete-Roman", size: 30))
                            .fontWeight(.regular)
                    } else if(i == self.cursorLocation) {
                        TextCursor()
                    } else {
                        Text(self.formula[i - 1])
                            .font(.custom("CMUConcrete-Roman", size: 30))
                            .fontWeight(.regular)
                    }
                }
            }

            Spacer()
        }
        .padding()
//        .animation(.easeInOut(duration: 0.15), value: self.formula)
        
    }
//    
//    
//    struct Show: View {
//        var body: some View {
//            Text("Hello")
//        }
//    }
}
