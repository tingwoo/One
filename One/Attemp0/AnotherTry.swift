////
////  AnotherTry.swift
////  One
////
////  Created by Tingwu on 2023/9/23.
////
//
//import Foundation
//import SwiftUI
//
//protocol FormulaComponent: View {
////    var hasCursor: Bool
////    var containsCursor: Bool
//    
////
////    associatedtype Body: View
////
////    @ViewBuilder func display() -> Body
//    var id { get }
//    
//    func shiftCursor() -> ()
//    
//    func backspace() -> ()
//    
////    associatedtype What: View
////
////    var body: What { get }
//}
//
//struct Simple: FormulaComponent {
//    
//    var id = UUID()
//
//    var content: String = "E"
//
//    func shiftCursor() -> (){
//
//    }
//
//    func backspace() -> (){
//
//    }
//
//    var body: some View {
//        Text(self.content)
//            .font(.custom("CMUConcrete-Roman", size: 30))
//            .fontWeight(.regular)
//    }
//}
//
//struct Fraction: FormulaComponent{
//    
//    var id = UUID()
//    
//    var contentNum: [any FormulaComponent]
//    var contentDen: [any FormulaComponent]
//
//    func shiftCursor() -> (){
//
//    }
//
//    func backspace() -> (){
//
//    }
//
//    var body: some View {
//        VStack {
//            HStack {
//                ForEach(0..<self.contentNum.count, id: \.self) { i in
//                    self.contentNum[i]
//                }
//            }
//
//            Rectangle().frame(width: 100, height: 5)
//
//            HStack {
//                ForEach(0..<(self.contentDen.count), id: \.self) { i in
//                    self.contentDen[i]
//                }
//            }
//        }
//    }
//}
