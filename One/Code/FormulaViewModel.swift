//
//  FormulaViewModel.swift
//  One
//
//  Created by Tingwu on 2023/9/28.
//

import Foundation

class FormulaViewModel: ObservableObject {
//    @Published var elements: [ElementModel] = [ElementModel(name: .three),
//                                                        ElementModel(name: .plus),
//                                                        ElementModel(name: .STA_frac),
//                                                        ElementModel(name: .two),
//                                                        ElementModel(name: .SEP),
//                                                        ElementModel(name: .one),
//                                                        ElementModel(name: .one),
//                                                        ElementModel(name: .minus),
//                                                        ElementModel(name: .STA_frac),
//                                                        ElementModel(name: .two),
//                                                        ElementModel(name: .SEP),
//                                                        ElementModel(name: .one),
//                                                        ElementModel(name: .one),
//                                                        ElementModel(name: .END_frac),
//                                                        ElementModel(name: .END_frac),
//                                                        ElementModel(name: .END)]
//        @Published var elements: [ElementModel] = [ElementModel(name: .three),
//                                                            ElementModel(name: .multiply),
//                                                            ElementModel(name: .two),
//                                                            ElementModel(name: .END)]
    
    @Published var elements: [ElementModel]
    @Published var elementsParams = [UUID: ElementParamsModel]()
    @Published var wholeOffsetY: CGFloat = 0
    
    var cursorLocation: Int
    @Published var cursorKey: UUID
    
    var floorGap: CGFloat = 30
    
    var textElements: Set<ElementName> = [.zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .point, .paren_l, .paren_r]
    var textGap: CGFloat = 15

    var symbolElements: Set<ElementName> = [.plus, .minus, .multiply, .divide, .PLH]
    var symbolGap: CGFloat = 25

    var fractionGap: CGFloat = 4
    
    var hapticManager = HapticManager.instance
    
    
    init() {
        let firstElement = ElementModel(name: .END)
        elements = [firstElement]
        cursorLocation = 0
        cursorKey = firstElement.id
    }
    
//    func insertNumber() {
//        if(elements[cursorLocation].name == .PLH) {
//            elements[cursorLocation].name = textElements.randomElement()!
//        } else {
//            elements.insert(ElementModel(name: textElements.randomElement()!), at: cursorLocation)
//        }
//        cursorLocation += 1
//        updateParams()
//    }
//    
//    func insertFraction() {
//        if(elements[cursorLocation].name == .PLH) {
//            elements[cursorLocation].name = .STA_frac
//            elements.insert(contentsOf: [ElementModel(name: .PLH), ElementModel(name: .SEP), ElementModel(name: .PLH), ElementModel(name: .END_frac)], at: cursorLocation + 1)
//        } else {
//            elements.insert(contentsOf: [ElementModel(name: .STA_frac), ElementModel(name: .PLH), ElementModel(name: .SEP), ElementModel(name: .PLH), ElementModel(name: .END_frac)], at: cursorLocation)
//        }
//        cursorLocation += 1
//        updateParams()
//    }
    
    func insertElements(index: Int) {
        let command = keyList[index].command
        let shift = keyList[index].cursorShift
        
        if(elements[cursorLocation].name == .PLH) {
            elementsParams[elements[cursorLocation].id] = nil
            elements.remove(at: cursorLocation)
        }
        elements.insert(contentsOf: command.map({ElementModel(name: $0)}), at: cursorLocation)
        cursorLocation += shift
        updateCursorKey()
        updateParams()
    }
    
    func clear() {
        elements.removeAll()
        elementsParams.removeAll()
        
        elements.append(ElementModel(name: .END))
        cursorLocation = 0
        updateCursorKey()
        updateParams()
    }
    
    func updateParams() {
        let (_, _, tmp, _) = self.parse(start: 0, end: elements.count)
        self.wholeOffsetY = -tmp + floorGap / 2.0
    }
    
    func shiftCursor(_ step: Int) {
        step > 0 ? shiftR() : shiftL()
        updateCursorKey()
    }
    
    //    func shiftCursor(shift: Int) {
    //        if(self.cursorLocation + shift == formula.count || self.cursorLocation + shift == 0){
    //            self.cursorLocation += shift
    //            self.hapticManager.impact(style: .soft)
    //
    //        } else if(self.cursorLocation + shift >= 0 && self.cursorLocation + shift <= formula.count) {
    //            self.cursorLocation += shift
    //            self.hapticManager.wheel()
    //        }
    //    }
    
    func shiftL() {
        if(cursorLocation - 1 >= 0){
            cursorLocation -= 1
            if(cursorLocation - 1 >= 0 && elements[cursorLocation - 1].name == .PLH) {
                cursorLocation -= 1
            }
            cursorLocation == 0 ? hapticManager.impact(style: .soft) : hapticManager.wheel()
        }
    }
    
    func shiftR() {
        if(cursorLocation + 1 < elements.count){
            cursorLocation += 1
            if(elements[cursorLocation - 1].name == .PLH){
                cursorLocation += 1
            }
            cursorLocation == elements.count - 1 ? hapticManager.impact(style: .soft) : hapticManager.wheel()
        }
    }
    
    func updateCursorKey() {
        cursorKey = elements[cursorLocation].id
    }
    
    func parse(start: Int, end: Int, startPos: CGPoint = CGPoint(x: 0, y: 0)) -> (w: CGFloat, h: CGFloat, minY: CGFloat, maxY: CGFloat) {
        var i = start
        var pos = startPos
        var minY: CGFloat = 0
        var maxY: CGFloat = 0
        
        while(i < end) {
            if(elements[i].name != .STA_frac){
                
                if(textElements.contains(elements[i].name)) {
                    pos.x += textGap / 2.0
                    elementsParams[elements[i].id] = ElementParamsModel(name: elements[i].name, pos: pos)
                    pos.x += textGap / 2.0
                    
                } else if(symbolElements.contains(elements[i].name)) {
                    pos.x += symbolGap / 2.0
                    elementsParams[elements[i].id] = ElementParamsModel(name: elements[i].name, pos: pos)
                    pos.x += symbolGap / 2.0
                    
                } else if(elements[i].name == .END) {
                    elementsParams[elements[i].id] = ElementParamsModel(name: elements[i].name, pos: pos)
                } else {
                    elementsParams[elements[i].id] = ElementParamsModel(name: elements[i].name, pos: pos)
                }
                
            } else if(elements[i].name == .STA_frac) {
                
                pos.x += fractionGap / 2.0
                elementsParams[elements[i].id] = ElementParamsModel(name: elements[i].name, pos: pos)
                
                var j: Int = i + 1
                var cnt: Int = 0
                var fracMid: Int? = nil
                var fracEnd: Int? = nil
                
                while(j < end) {
                    if(elements[j].name == .SEP && cnt == 0) {
                        fracMid = j
                    } else if(elements[j].name == .END_frac && cnt == 0) {
                        fracEnd = j
                        break
                    } else if(elements[j].name == .STA_frac) {
                        cnt += 1
                    } else if(elements[j].name == .END_frac) {
                        cnt -= 1
                    }
                    
                    j += 1
                }
                
                guard let fracMid = fracMid else { fatalError("fracMid is nil") }
                guard let fracEnd = fracEnd else { fatalError("fracEnd is nil") }
                
                let numWH: (w: CGFloat, h: CGFloat, _, maxY: CGFloat) = self.parse(start: i+1, end: fracMid, startPos: CGPoint(x: pos.x, y: 0))
                elementsParams[elements[fracMid].id] = ElementParamsModel(name: elements[fracMid].name, pos: CGPoint(x: pos.x + numWH.w, y: pos.y))
                for k in (i+1)...fracMid {
                    elementsParams[elements[k].id]?.pos.y -= (numWH.maxY + floorGap / 2.0)
                    minY = min(minY, elementsParams[elements[k].id]!.pos.y)
                }
                
                
                let denWH: (w: CGFloat, h: CGFloat, minY: CGFloat, _) = self.parse(start: fracMid+1, end: fracEnd, startPos: CGPoint(x: pos.x, y: 0))
                elementsParams[elements[fracEnd].id] = ElementParamsModel(name: elements[fracEnd].name, pos: CGPoint(x: pos.x + denWH.w, y: pos.y))
                for k in (fracMid+1)...fracEnd {
                    elementsParams[elements[k].id]?.pos.y -= (denWH.minY - floorGap / 2.0)
                    maxY = max(maxY, elementsParams[elements[k].id]!.pos.y)
                }
                
                
                if(numWH.w >= denWH.w) {
                    for k in (fracMid+1)...fracEnd {
                        elementsParams[elements[k].id]!.pos.x += (numWH.w - denWH.w) / 2.0
                    }
                } else {
                    for k in (i+1)...fracMid {
                        elementsParams[elements[k].id]!.pos.x += (denWH.w - numWH.w) / 2.0
                    }
                }
                
                pos.x += max(numWH.w, denWH.w) + fractionGap / 2.0
                elementsParams[elements[i].id]!.param = max(numWH.w, denWH.w)
                elementsParams[elements[i].id]!.pos.x += elementsParams[elements[i].id]!.param! / 2.0
                
                i = fracEnd
            }
            
            i += 1
        }
        
        return (w: pos.x - startPos.x, h: maxY - minY + floorGap, minY: minY, maxY: maxY)
    }
}
