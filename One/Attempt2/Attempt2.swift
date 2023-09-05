//
//  Attempt2.swift
//  One
//
//  Created by Tingwu on 2023/9/24.
//

import Foundation
import SwiftUI

struct ComponentAttr {
    var value: String
    var pos: CGPoint
    var param: CGFloat? = nil
}

var componentAttrList: [ComponentAttr] = []

//var singleGap: CGFloat = 15
var floorGap: CGFloat = 30

var textComponents: Set<String> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
var textGap: CGFloat = 15

var symbolComponents: Set<String> = ["plus", "minus", "multiply", "divide", "square.dashed"]
var symbolGap: CGFloat = 25

var fractionGap: CGFloat = 4

func makeComponentAttrList(source: [String], start: Int, end: Int, list: inout [ComponentAttr], startPosX: CGFloat = 0, startPosY: CGFloat = 0) -> (w: CGFloat, h: CGFloat, minY: CGFloat, maxY: CGFloat) {
    var i = start
    var posX = startPosX
    let posY = startPosY
    
    var minY: CGFloat = 0
    var maxY: CGFloat = 0
    
    while(i < end) {
        if(source[i] != "sFrac"){
            
            if(textComponents.contains(source[i])) {
                posX += textGap / 2.0
                list.append(ComponentAttr(value: source[i], pos: CGPoint(x: posX, y: posY)))
                posX += textGap / 2.0
                
            } else if(symbolComponents.contains(source[i])) {
                posX += symbolGap / 2.0
                list.append(ComponentAttr(value: source[i], pos: CGPoint(x: posX, y: posY)))
                posX += symbolGap / 2.0
                
            } else if(source[i] == "end") {
                list.append(ComponentAttr(value: source[i], pos: CGPoint(x: posX, y: posY)))
            }
            
        } else if(source[i] == "sFrac") {
            
            posX += fractionGap / 2.0
            list.append(ComponentAttr(value: source[i], pos: CGPoint(x: posX, y: posY)))
            
            var j: Int = i + 1
            var cnt: Int = 0
            var fracMid: Int? = nil
            var fracEnd: Int? = nil
            
            while(j < end) {
                if(source[j] == "sep" && cnt == 0) {
                    fracMid = j
                } else if(source[j] == "eFrac" && cnt == 0) {
                    fracEnd = j
                    break
                } else if(source[j] == "sFrac") {
                    cnt += 1
                } else if(source[j] == "eFrac") {
                    cnt -= 1
                }
                
                j += 1
            }
            
            guard let fracMid = fracMid else { fatalError("fracMid is nil") }
            guard let fracEnd = fracEnd else { fatalError("fracEnd is nil") }
            
            let numWH: (w: CGFloat, h: CGFloat, _, maxY: CGFloat) = makeComponentAttrList(source: source, start: i+1, end: fracMid, list: &list, startPosX: posX, startPosY: 0.0)
            
            list.append(ComponentAttr(value: source[fracMid], pos: CGPoint(x: posX + numWH.w, y: posY)))
            
            for k in (i+1)...fracMid {
                list[k].pos.y -= (numWH.maxY + floorGap / 2.0)
                minY = min(minY, list[k].pos.y)
            }
            
            let denWH: (w: CGFloat, h: CGFloat, minY: CGFloat, _) = makeComponentAttrList(source: source, start: fracMid+1, end: fracEnd, list: &list, startPosX: posX, startPosY: 0.0)
            
            list.append(ComponentAttr(value: source[fracEnd], pos: CGPoint(x: posX + denWH.w, y: posY)))
            
            for k in (fracMid+1)...fracEnd {
                list[k].pos.y -= (denWH.minY - floorGap / 2.0)
                maxY = max(maxY, list[k].pos.y)
            }
            
            if(numWH.w >= denWH.w) {
                for k in (fracMid+1)...fracEnd {
                    list[k].pos.x += (numWH.w - denWH.w) / 2.0
                }
            } else {
                for k in (i+1)...fracMid {
                    list[k].pos.x += (denWH.w - numWH.w) / 2.0
                }
            }
            
            posX += max(numWH.w, denWH.w) + fractionGap / 2.0
            list[i].param = max(numWH.w, denWH.w)
            list[i].pos.x += list[i].param! / 2.0
            
            i = fracEnd
        }
        
        i += 1
    }
    
    return (w: posX - startPosX, h: maxY - minY + floorGap, minY: minY, maxY: maxY)
}


struct Test: View {
    var attr: [ComponentAttr] = []
    var wholeOffsetY: CGFloat
    var cursorLocation: Int
    
    init(source: [String], cursorLocation: Int) {
        print("init")
        let (_, _, tmp, _) = makeComponentAttrList(source: source, start: 0, end: source.count, list: &self.attr)
        self.wholeOffsetY = -tmp
        self.cursorLocation = cursorLocation
    }

    var body: some View {
        ZStack {
            ForEach(0..<self.attr.count, id: \.self) { i in
                
                if(self.attr[i].value == "sFrac"){
                    Rectangle()
                        .frame(width: self.attr[i].param!, height: 2)
                        .modifier(withCursor(show: i == self.cursorLocation))
                        .position(self.attr[i].pos)
                    
                } else if(textComponents.contains(self.attr[i].value)) {
                    Text(self.attr[i].value)
                        .font(.custom("CMUConcrete-Roman", size: 30))
                        .fontWeight(.regular)
                        .modifier(withCursor(show: i == self.cursorLocation))
                        .position(self.attr[i].pos)
                    
                } else if(symbolComponents.contains(self.attr[i].value)) {
                    if(self.attr[i].value == "square.dashed" && i == self.cursorLocation) {
                        Image(systemName: "square")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.blue)
                            .position(self.attr[i].pos)
                    }else {
                        Image(systemName: self.attr[i].value)
                            .font(.system(size: 20, weight: .regular))
                            .modifier(withCursor(show: i == self.cursorLocation))
                            .position(self.attr[i].pos)
                    }
                    
                } else if(self.attr[i].value == "end" || self.attr[i].value == "sep" || self.attr[i].value == "eFrac") {
                    Color.clear.frame(width: 1, height: 1)
                        .modifier(withCursor(show: i == self.cursorLocation))
                        .position(self.attr[i].pos)
                    
                } else {
                    EmptyView()
                }
            }
            
        }
        .offset(x: 0, y: self.wholeOffsetY + floorGap / 2.0)
    }
}

struct withCursor: ViewModifier {
    @State private var isOn: Bool = true
    var show: Bool
    
    func body(content: Content) -> some View {
        if(show) {
            content
                .overlay(
                    Rectangle()
                        .frame(width: 2, height: 25, alignment: .leading)
                        .foregroundColor(Color.blue)
                        .offset(x: -1, y: 0)
                        .opacity(isOn ? 1.0 : 0.0)
                        .onAppear {
                            self.isOn = true
                            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                self.isOn.toggle()
                            }
                        },
                    alignment: .leading
                )
        }else{
            content
        }
    }
}


