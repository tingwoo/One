//
//  FormulaViewModel.swift
//  One
//
//  Created by Tingwu on 2023/9/28.
//

import Foundation

class FormulaViewModel: ObservableObject {

    @Published var elements: [ElementModel]
    @Published var elementsParams = [UUID: ElementParamsModel]()
    @Published var wholeOffsetY: CGFloat = 0
    
    var cursorLocation: Int
    @Published var cursorKey: UUID
    
    var floorGap: CGFloat = 30 //
    
//    var textElements: Set<ElementName> = [.zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .point, .paren_l, .paren_r] //
//    var textGap: CGFloat = 15 //
//
//    var symbolElements: Set<ElementName> = [.plus, .minus, .multiply, .divide, .PLH] //
//    var symbolGap: CGFloat = 25 //

    var fractionGap: CGFloat = 4 //
    
    var hapticManager = HapticManager.instance
    
    
    init() {
        let firstElement = ElementModel(name: .END)
        elements = [firstElement]
        cursorLocation = 0
        cursorKey = firstElement.id
    }
    
    func insertElements(index: Int) {
        let command = keyList[index].command
        let shift = keyList[index].cursorShift
        
        if(!command.isEmpty) {
            if(elements[cursorLocation].name == .PLH) {
                elementsParams[elements[cursorLocation].id] = nil
                elements.remove(at: cursorLocation)
            }
            elements.insert(contentsOf: command.map({ElementModel(name: $0)}), at: cursorLocation)
            cursorLocation += shift
            updateCursorKey()
            updateParams()
        }
    }
    
    func clear() {
        elements.removeAll()
        elementsParams.removeAll()
        
        elements.append(ElementModel(name: .END))
        cursorLocation = 0
        updateCursorKey()
        updateParams()
    }
    
    func shiftCursor(_ step: Int) {
        step > 0 ? shiftR() : shiftL()
        updateCursorKey()
    }
    
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
    
    func updateParams() {
        let tmp = self.parse(start: 0, end: elements.count)
        self.wholeOffsetY = -tmp.minY
    }
    
    // Input:
    // Parse section                     -- start: Int, end: Int
    // Font scale                        -- fontScale: CGFloat
    
    // Output:
    // Dimensions of the expression in the segment -- _: ExpressionDim
    func parse(start: Int, end: Int, startPos: CGPoint = CGPoint(x: 0, y: 0)) -> ExpressionDim {
        var i = start
        var pos = startPos
        var minY: CGFloat = 0
        var maxY: CGFloat = 0
        
        while(i < end) {
            if(elements[i].name != .STA_frac){
                /* If the element is a character */
                
                // Calculate the position offset of the character
                pos.x += elements[i].name.getDimensions().halfWidth()
                elementsParams[elements[i].id] = ElementParamsModel(name: elements[i].name, pos: pos)
                pos.x += elements[i].name.getDimensions().halfWidth()
                
                // Update maxY and minY
                minY = min(minY, elements[i].name.getDimensions().minY)
                maxY = max(maxY, elements[i].name.getDimensions().maxY)
                
//                if(textElements.contains(elements[i].name)) {
//                    pos.x += textGap / 2.0
//                    elementsParams[elements[i].id] = ElementParamsModel(name: elements[i].name, pos: pos)
//                    pos.x += textGap / 2.0
//                    
//                } else if(symbolElements.contains(elements[i].name)) {
//                    pos.x += symbolGap / 2.0
//                    elementsParams[elements[i].id] = ElementParamsModel(name: elements[i].name, pos: pos)
//                    pos.x += symbolGap / 2.0
//                    
//                } else if(elements[i].name == .END) {
//                    elementsParams[elements[i].id] = ElementParamsModel(name: elements[i].name, pos: pos)
//                } else {
//                    elementsParams[elements[i].id] = ElementParamsModel(name: elements[i].name, pos: pos)
//                }
                
            } else if(elements[i].name == .STA_frac) {
                /* If the element is the start of a function */
                
                // Find each sub-expressions in the function
                
                // Calculate the dimensions of each sub-expressions by calling parse() recursively
                
                // Calculate the position offset of each sub-expressions and apply
                
                // Calculate the position offset of the whole function expression
                
                // Update maxY and minY
                
                // Update pos
                
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
                
                let numWH: ExpressionDim = self.parse(start: i+1, end: fracMid, startPos: CGPoint(x: pos.x, y: 0))
                elementsParams[elements[fracMid].id] = ElementParamsModel(name: elements[fracMid].name, pos: CGPoint(x: pos.x + numWH.width, y: pos.y))
                for k in (i+1)...fracMid {
                    elementsParams[elements[k].id]?.pos.y -= numWH.maxY
                }
                minY = min(minY, -numWH.height)
                
                
                let denWH: ExpressionDim = self.parse(start: fracMid+1, end: fracEnd, startPos: CGPoint(x: pos.x, y: 0))
                elementsParams[elements[fracEnd].id] = ElementParamsModel(name: elements[fracEnd].name, pos: CGPoint(x: pos.x + denWH.width, y: pos.y))
                for k in (fracMid+1)...fracEnd {
                    elementsParams[elements[k].id]?.pos.y -= denWH.minY
                }
                maxY = max(maxY, denWH.height)
                
                
                if(numWH.width >= denWH.width) {
                    for k in (fracMid+1)...fracEnd {
                        elementsParams[elements[k].id]!.pos.x += (numWH.width - denWH.width) / 2.0
                    }
                } else {
                    for k in (i+1)...fracMid {
                        elementsParams[elements[k].id]!.pos.x += (denWH.width - numWH.width) / 2.0
                    }
                }
                
                pos.x += max(numWH.width, denWH.width) + fractionGap / 2.0
                elementsParams[elements[i].id]!.param = max(numWH.width, denWH.width)
                elementsParams[elements[i].id]!.pos.x += elementsParams[elements[i].id]!.param! / 2.0
                
                i = fracEnd
            }
            
            i += 1
        }
        
        return ExpressionDim(width: pos.x - startPos.x, height: maxY - minY, minY: minY, maxY: maxY)
    }
}
