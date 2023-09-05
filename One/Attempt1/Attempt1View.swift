////
////  Attempt1View.swift
////  One
////
////  Created by Tingwu on 2023/9/23.
////
//
//import SwiftUI
//
////var testFormula: [String] = ["1", "c", "+", "sFrac", "3", "-", "2", "+", "sFrac", "3", "-", "2", "sep", "2", "*", "3", "eFrac", "sep", "2", "+", "sFrac", "1", "sep", "2", "eFrac", "eFrac", "*", "7"]
//
//
//struct Attempt1View: View {
//    @State var testFormula: [String] = ["1", "|", "+", "sFrac", "3", "-", "2", "+", "sFrac", "3", "-", "2", "sep", "2", "*", "3", "eFrac", "sep", "2", "eFrac", "*", "7"]
////    @State var testFormula: [String] = ["1", "+", "sFrac", "3", "-", "2", "sFrac", "3", "-", "2", "sep", "2", "eFrac", "sep", "2", "eFrac"]
//
//    var body: some View {
//        VStack(spacing: 30) {
//            Line(source: testFormula)
//            Grid {
//                GridRow { 
//                    Button("Insert Number") {
//                        if let c = testFormula.firstIndex(of: "|") {
//                            testFormula.insert(String(Int.random(in: 0..<10)), at: c)
//                        } else if let c = testFormula.firstIndex(of: "◼") {
//                            testFormula.remove(at: c)
//                            testFormula.insert(String(Int.random(in: 0..<10)), at: c)
//                        }
//                    }
//                    Button("Insert Fraction") {
//                        if let c = testFormula.firstIndex(of: "|") {
//                            testFormula.insert(contentsOf: ["sFrac", "□", "sep", "□", "eFrac"], at: c)
//                            testFormula.remove(at: c+5)
//                            testFormula.insert("|", at: c+1)
//                        }
//                    }
//                    Button("Backspace") {
//                    }
//                }
//                
//                GridRow {
//                    Button("Clear All") {
//                        testFormula = ["|"]
//                    }
//                    Button("Shift L") {
//                        if let c = testFormula.firstIndex(of: "|") {
//                            if(c != 0){
//                                testFormula.swapAt(c, c-1)
//                            }
//                        }
//                    }
//                    Button("Shift R") {
//                        if let c = testFormula.firstIndex(of: "|") {
//                            if(c != testFormula.count-1){
//                                testFormula.swapAt(c, c+1)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//}
//
//#Preview {
//    Attempt1View()
//}
