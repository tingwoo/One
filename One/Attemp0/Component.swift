////
////  FormulaComponent.swift
////  One
////
////  Created by Tingwu on 2023/9/21.
////
//
//import Foundation
//import SwiftUI
//
//struct Component : View{
//    
//    @State var maxWidth: CGFloat = 0
//    
//    var id = UUID() // Add a unique identifier
//    
//    var type: String
//    
//    var value: String? = nil
//    var list1: [Component]? = nil
//    var list2: [Component]? = nil
//    
//    var hasCursor: Bool = false
//    var containsCursor: Bool = false
//    
//    init() {
//        self.type = "whol"
//        self.containsCursor = true
//        self.list1 = [Component(type: "star")]
//    }
//    
//    init(type: String) {
//        self.type = type
//        self.hasCursor = true
//    }
//    
////    init(value: String) {
////        self.type = "char"
////        self.value = value
////    }
////
////    init(type: String, value: String) {
////        self.type = type
////        self.value = value
////    }
////
////    init(list1: [Component], list2: [Component]) {
////        self.type = "frac"
////        self.list1 = list1
////        self.list2 = list2
////    }
//    
//    func shiftCursor() {
//        
//    }
//    
//    func insert(component: Component) {
//    }
//
//    func backspace() {
//
//    }
//
//    var body: some View {
//        switch type {
//            
//        case "whol":
//            HStack(spacing: 0) {
//                ForEach(self.list1!, id: \.id) { item in item }
//            }
//            
//        case "star":
//            Text("S")
//                .font(.custom("CMUConcrete-Roman", size: 30))
//                .modifier(Cursor(show: hasCursor))
//            
//        case "char":
//            Text(value!)
//                .font(.custom("CMUConcrete-Roman", size: 30))
//                .modifier(Cursor(show: hasCursor))
//            
//        case "symb":
//            Image(systemName: value!)
//                .font(.system(size: 20))
//                .modifier(Cursor(show: hasCursor))
//            
//        case "frac":
//            VStack(spacing: 0) {
//                HStack(spacing: 0) {
//                    ForEach(self.list1!, id: \.id) { item in item }
//                }
//                .overlay(
//                    GeometryReader(content: { geometry in
//                        Color
//                            .clear
//                            .onAppear(perform: { maxWidth = max(maxWidth, geometry.frame(in: .global).width) + 5.0 })
//                    })
//                )
//                
//                Rectangle()
//                    .frame(width: maxWidth, height: 2)
//                    .modifier(Cursor(show: hasCursor))
//                
//                HStack(spacing: 0) {
//                    ForEach(self.list2!, id: \.id) { item in item }
//                }
//                .overlay(
//                    GeometryReader(content: { geometry in
//                        Color
//                            .clear
//                            .onAppear(perform: { maxWidth = max(maxWidth, geometry.frame(in: .global).width) + 5.0 })
//                    })
//                )
//            }
//            
//        default:
//            Text("?")
//                .font(.custom("CMUConcrete-Roman", size: 30))
//        }
//    }
//}
//
//struct Cursor: ViewModifier {
//    
//    var show: Bool
//    
//    @State private var isOn = false
//    
//    func body(content: Content) -> some View {
//        if(self.show) {
//            content
//                .overlay(
//                    Rectangle()
//                        .frame(width: 2, height: 25, alignment: .trailing)
//                        .foregroundColor(Color(red: 30/255.0, green: 117/255.0, blue: 223/255.0, opacity: isOn ? 0.0 : 1.0))
//                        .offset(CGSize(width: 1, height: 0)),
//                    alignment: .trailing
//                )
//                .onAppear {
//                    withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
//                        self.isOn.toggle()
//                    }
//                }
//        } else {
//            content
//        }
//    }
//}
//
//
//
//
////struct Simple: FormulaComponent {
////    
////    var content: String = "E"
////    
////    func shiftCursor() -> (){
////        
////    }
////    
////    func backspace() -> (){
////        
////    }
////    
////    var body: some View {
////        Text(self.content)
////            .font(.custom("CMUConcrete-Roman", size: 30))
////            .fontWeight(.regular)
////    }
////}
////
////struct Fraction: FormulaComponent{
////    var contentNum = [Simple(content: "3"), Simple(content: "7"), Fraction(ini)]
////    var contentDen = [Simple(content: "2")]
////    
////    func shiftCursor() -> (){
////        
////    }
////    
////    func backspace() -> (){
////        
////    }
////    
////    var body: some View {
////        VStack {
////            HStack {
////                ForEach(0..<(self.contentNum.count), id: \.self) { i in
////                    self.contentNum[i]
////                }
////            }
////            
////            Rectangle().frame(width: 100, height: 5)
////
////            HStack {
////                ForEach(0..<(self.contentDen.count), id: \.self) { i in
////                    self.contentDen[i]
////                }
////            }
////        }
////    }
////}
//
////class Simple: FormulaComponent{
////    var content: String
////    
////    init(content: String) {
////        self.content = content
////    }
////    
////    @ViewBuilder func display() -> some View {
////        Text(self.content)
////            .font(.custom("CMUConcrete-Roman", size: 30))
////            .fontWeight(.regular)
////    }
////}
////
////class Fraction: FormulaComponent{
////    var contentNum: [any FormulaComponent] = [Simple(content: "3"), Simple(content: "5")]
////    var contentDen: [any FormulaComponent] = [Simple(content: "2")]
////    
////    func display() -> some View {
////        VStack {
////            HStack {
////                ForEach(0..<(self.contentNum.count), id: \.self) { i in
////                    self.contentNum[i].display()
////                }
////            }
////            
////            HStack {
////                ForEach(0..<(self.contentDen.count), id: \.self) { i in
////                    self.contentDen[i].display()
////                }
////            }
////        }
////    }
////}
