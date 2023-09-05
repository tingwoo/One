////
////  Attempt1.swift
////  One
////
////  Created by Tingwu on 2023/9/23.
////
//
//import Foundation
//import SwiftUI
//
//class Component: Identifiable {
//    var id: String
//    var type: String
//    var value: String
//    var sub1: [Component]
//    var sub2: [Component]
//    
//    init(type: String, value: String, sub1: [Component], sub2: [Component]) {
//        self.id = UUID().uuidString
//        self.type = type
//        self.value = value
//        self.sub1 = sub1
//        self.sub2 = sub2
//    }
//}
//
//let text: Set<String> = ["1", "2", "3"]
//let symbols: Set<String> = ["plus", "minus", "multiply", "divide"]
//let start: Set<String> = ["sFrac"]
//
//func organizeFormula(source: inout [String], start: Int, end: Int, list: inout [Component]) {
//    var i = start
//    
//    while(i < end) {
//        if(source[i] != "sFrac"){
//            
//            list.append(Component(type: "single", value: source[i], sub1: [] , sub2: []))
//            
//        } else if(source[i] == "sFrac") {
//            
//            var j: Int = i + 1
//            var cnt: Int = 0
//            var fracMid: Int? = nil
//            var fracEnd: Int? = nil
//            
//            while(j < end) {
//                
//                if(source[j] == "sep" && cnt == 0) {
//                    fracMid = j
//                } else if(source[j] == "eFrac" && cnt == 0) {
//                    fracEnd = j
//                    break
//                } else if(source[j] == "sFrac") {
//                    cnt += 1
//                } else if(source[j] == "eFrac") {
//                    cnt -= 1
//                }
//                
//                j += 1
//            }
//            
//            var num: [Component] = []
//            var den: [Component] = []
//            
//            guard let fracMid = fracMid else { fatalError("fracMid is nil") }
//            guard let fracEnd = fracEnd else { fatalError("fracEnd is nil") }
//            
//            organizeFormula(source: &source, start: i+1, end: fracMid, list: &num)
//            organizeFormula(source: &source, start: fracMid+1, end: fracEnd, list: &den)
//            
//            list.append(Component(type: "fraction", value: "", sub1: num , sub2: den))
//            
//            i = fracEnd
//        }
//        
//        i += 1
//    }
//}
//
//struct Fraction<Content1: View, Content2: View>: View {
//    @State var maxWidth: CGFloat = 0
//    
//    let content1: Content1
//    let content2: Content2
//
//    init(@ViewBuilder content1: () -> Content1, @ViewBuilder content2: () -> Content2) {
//        self.content1 = content1()
//        self.content2 = content2()
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            content1
//            VStack(content: {}).overlay(Rectangle().frame(width: maxWidth, height: 2))
//            content2
//        }
//        .overlay(
//            GeometryReader(content: { geometry in
//                Color.clear
//                    .onAppear(perform: {
//                        maxWidth = geometry.frame(in: .global).width
//                    })
//            })
//        )
//    }
//}
//
//struct Line: View {
//    var source: [String] = []
//    var /*components*/: [Component]
//    
//    init(source: [String]) {
//        self.source = source
//        self.components = []
//        organizeFormula(source: &self.source, start: 0, end: self.source.count, list: &self.components)
//    }
//
//    init(components: [Component]) {
//        self.components = components
//    }
//
//    var body: some View {
//        HStack(spacing: 0) {
//            ForEach(self.components, id: \.id) { item in
//                switch item.type {
//                case "single":
//                    Text(item.value)
//                        .font(.custom("CMUConcrete-Roman", size: 30))
//                        .fontWeight(.regular)
//                    
//                case "fraction":
//                    Fraction {
//                        Line(components: item.sub1)
//                    } content2: {
//                        Line(components: item.sub2)
//                    }
//                    
//                default:
//                    Text("?")
//                        .font(.custom("CMUConcrete-Roman", size: 30))
//                        .fontWeight(.regular)
//                }
//            }
//        }
////        .border(.blue)
//    }
//}
