//
//  Attempt2View.swift
//  One
//
//  Created by Tingwu on 2023/9/24.
//

import SwiftUI



struct Attempt2View: View {
//    @State var source: [String] = ["2", "+", "sFrac", "1", "sep", "2", "2", "eFrac"]
//    @State var source: [String] = ["1", "2", "2"]
    @State var source: [String] = ["1", "2", "plus", "sFrac", "3", "divide", "2", "plus", "sFrac", "3", "minus", "2", "sep", "2", "3", "eFrac", "sep", "2", "eFrac", "multiply", "7", "5", "end"]
    
//    @State var source2: [(id: String, comp: String)] = []
    
    @State var cursorLocation: Int = 0
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            Test(source: self.source, cursorLocation: self.cursorLocation)
                .frame(height: 500)
                .border(.blue)
                .padding()
            
            Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                GridRow {
                    Button("Number") {
                        if(self.source[self.cursorLocation] == "square.dashed") {
                            self.source[self.cursorLocation] = String(Int.random(in: 1..<10))
                        } else {
                            self.source.insert(String(Int.random(in: 1..<10)), at: self.cursorLocation)
                        }
                        self.cursorLocation += 1
                    }
                    Button("Operation") {
                        if(self.source[self.cursorLocation] == "square.dashed") {
                            self.source[self.cursorLocation] = ["plus", "minus", "multiply", "divide"][Int.random(in: 0..<4)]
                        } else {
                            self.source.insert(["plus", "minus", "multiply", "divide"][Int.random(in: 0..<4)], at: self.cursorLocation)
                        }
                        self.cursorLocation += 1
                    }
                    Button("Fraction") {
                        
                        if(self.source[self.cursorLocation] == "square.dashed") {
                            self.source[self.cursorLocation] = "sFrac"
                            self.source.insert(contentsOf: ["square.dashed", "sep", "square.dashed", "eFrac"], at: self.cursorLocation + 1)
                        } else {
                            self.source.insert(contentsOf: ["sFrac", "square.dashed", "sep", "square.dashed", "eFrac"], at: self.cursorLocation)
                        }
                        self.cursorLocation += 1
                        
                    }
                    Button("Backspace") {
                    }
                }
                
                GridRow {
                    Button("Clear All") {
                        self.source.removeAll()
                        self.cursorLocation = 0
                        self.source.append("end")
                    }
                    Button("Shift L") {
                        if(self.cursorLocation - 1 >= 0) {
                            self.cursorLocation -= 1
                        }
                        
                        if(self.cursorLocation - 1 >= 0 && self.source[self.cursorLocation - 1] == "square.dashed"){
                            self.cursorLocation -= 1
                        }
                    }
                    Button("Shift R") {
                        if(self.cursorLocation + 1 < self.source.count) {
                            self.cursorLocation += 1
                            
                            if(self.source[self.cursorLocation - 1] == "square.dashed"){
                                self.cursorLocation += 1
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Attempt2View()
}
