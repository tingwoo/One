//
//  FormulaViewModel.swift
//  One
//
//  Created by Tingwu on 2023/9/28.
//

import Foundation

class FormulaViewModel: ObservableObject {

    @Published var elements: [ElementWithID]
    @Published var elementsDisplay = [UUID: ElementDisplay]()
    @Published var wholeOffsetY: CGFloat = 0
    
    var cursorLocation: Int
    @Published var cursorKey: UUID

    var fractionGap: CGFloat = 4 //
    
//    var manual = ElementManual.instance
    var hapticManager = HapticManager.instance
    
    init() {
        let firstElement = ElementWithID(element: .END)
        elements = [firstElement]
        cursorLocation = 0
        cursorKey = firstElement.id
    }
    
    func insertElements(index: Int) {
        let command = keyList[index].command
        let shift = keyList[index].cursorShift
        
        if(!command.isEmpty) {
            if(elements[cursorLocation].element == .PLH) {
                elementsDisplay[elements[cursorLocation].id] = nil
                elements.remove(at: cursorLocation)
            }
            elements.insert(contentsOf: command.map({ElementWithID(element: $0)}), at: cursorLocation)
            cursorLocation += shift
            updateCursorKey()
            updateParams()
        }
    }
    
    func clear() {
        elements.removeAll()
        elementsDisplay.removeAll()
        
        elements.append(ElementWithID(element: .END))
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
            if(cursorLocation - 1 >= 0 && elements[cursorLocation - 1].element == .PLH) {
                cursorLocation -= 1
            }
            cursorLocation == 0 ? hapticManager.impact(style: .soft) : hapticManager.wheel()
        }
    }
    
    func shiftR() {
        if(cursorLocation + 1 < elements.count){
            cursorLocation += 1
            if(elements[cursorLocation - 1].element == .PLH){
                cursorLocation += 1
            }
            cursorLocation == elements.count - 1 ? hapticManager.impact(style: .soft) : hapticManager.wheel()
        }
    }
    
    func updateCursorKey() {
        cursorKey = elements[cursorLocation].id
    }
    
    func updateParams() {
        let tmp = self.parse(start: 0, end: elements.count, scale: 1)
        self.wholeOffsetY = -tmp.minY
    }
    
    func nextScale(_ currentScale: CGFloat) -> CGFloat { //
        return 0.1 + currentScale * 0.8
    }
    
    // Input:
    // Parse section                     -- start: Int, end: Int
    // Font scale                        -- scale: CGFloat
    
    // Output:
    // Dimensions of the expression in the segment -- _: ExpressionDim
    func parse(start: Int, end: Int, startPos: CGPoint = CGPoint(x: 0, y: 0), scale: CGFloat) -> ExpressionDim {
        var i = start
        var pos = startPos
        var minY: CGFloat = 0
        var maxY: CGFloat = 0
        
        while(i < end) {
            if(elements[i].element.type != .func_start){
                /* If the element is a character */
                
                // Calculate the position offset of the character
                pos.x += elements[i].element.dimension.halfWidth() * scale
                elementsDisplay[elements[i].id] = ElementDisplay(element: elements[i].element, pos: pos, scale: scale)
                pos.x += elements[i].element.dimension.halfWidth() * scale
                
                // Update maxY and minY
                minY = min(minY, elements[i].element.dimension.minY * scale)
                maxY = max(maxY, elements[i].element.dimension.maxY * scale)
                
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
                
            } else if(elements[i].element.type == .func_start) {
                /* If the element is the start of a function */
                
                pos.x += elements[i].element.dimension.halfWidth() * scale
                elementsDisplay[elements[i].id] = ElementDisplay(element: elements[i].element, pos: pos, scale: scale)
                
                // Find each sub-expression sections in the function
                var j = i + 1
                var cnt = 0
                var sepList: [Int] = [i]
                
                while(j < end) {
                    if(elements[j].element == .SEP && cnt == 0) {
                        sepList.append(j)
                    } else if(elements[j].element.type == .func_start) {
                        cnt += 1
                    } else if(elements[j].element.type == .func_end) {
                        if(cnt == 0) {
                            sepList.append(j)
                            break
                        }
                        cnt -= 1
                    }
                    j += 1
                }
                
                // Calculate the dimensions of each sub-expressions by calling parse() recursively
                var subDimensions: [ExpressionDim] = Array(0..<(sepList.count - 1)).map(
                    {parse(
                        start: sepList[$0] + 1,
                        end: sepList[$0+1] + 1,
                        startPos: CGPoint(x: pos.x, y: 0),
                        scale: elements[i].element.getSubScales($0, scale)
                    )}
                )
                
                // Calculate the position offset of each sub-expressions and apply
                let subPositions: [CGPoint] = elements[i].element.getSubPositions(&subDimensions)
                for k in 0..<(sepList.count - 1) {
                    for l in (sepList[k] + 1)..<(sepList[k+1] + 1) {
                        elementsDisplay[elements[l].id]?.pos += subPositions[k]
                    }
                }
                
                // Calculate the overall dimensions the whole function expression
                let overallDimensions: ExpressionDim = elements[i].element.getOverallDimensions(&subDimensions)
                
                // Update maxY and minY
                minY = min(minY, overallDimensions.minY)
                maxY = max(maxY, overallDimensions.maxY)
                
                // Update pos
                pos.x += overallDimensions.width
                pos.x += elements[i].element.dimension.halfWidth() * scale
                
                // Skip rest of the function
                i = sepList.last!
                
                
//                pos.x += fractionGap / 2.0
//                elementsDisplay[elements[i].id] = ElementDisplay(element: elements[i].element, pos: pos, scale: scale)
//                
//                var j: Int = i + 1
//                var cnt: Int = 0
//                var fracMid: Int? = nil
//                var fracEnd: Int? = nil
//                
//                while(j < end) {
//                    if(elements[j].element == .SEP && cnt == 0) {
//                        fracMid = j
//                    } else if(elements[j].element == .END_frac && cnt == 0) {
//                        fracEnd = j
//                        break
//                    } else if(elements[j].element == .STA_frac) {
//                        cnt += 1
//                    } else if(elements[j].element == .END_frac) {
//                        cnt -= 1
//                    }
//                    
//                    j += 1
//                }
//                
//                guard let fracMid = fracMid else { fatalError("fracMid is nil") }
//                guard let fracEnd = fracEnd else { fatalError("fracEnd is nil") }
//                
//                let numWH: ExpressionDim = self.parse(start: i+1, end: fracMid, startPos: CGPoint(x: pos.x, y: 0), scale: nextScale(scale))
//                elementsDisplay[elements[fracMid].id] = ElementDisplay(element: elements[fracMid].element, pos: CGPoint(x: pos.x + numWH.width, y: pos.y), scale: nextScale(scale))
//                for k in (i+1)...fracMid {
//                    elementsDisplay[elements[k].id]?.pos.y -= numWH.maxY
//                }
//                minY = min(minY, -numWH.height)
//                
//                
//                let denWH: ExpressionDim = self.parse(start: fracMid+1, end: fracEnd, startPos: CGPoint(x: pos.x, y: 0), scale: nextScale(scale))
//                elementsDisplay[elements[fracEnd].id] = ElementDisplay(element: elements[fracEnd].element, pos: CGPoint(x: pos.x + denWH.width, y: pos.y), scale: nextScale(scale))
//                for k in (fracMid+1)...fracEnd {
//                    elementsDisplay[elements[k].id]?.pos.y -= denWH.minY
//                }
//                maxY = max(maxY, denWH.height)
//                
//                
//                if(numWH.width >= denWH.width) {
//                    for k in (fracMid+1)...fracEnd {
//                        elementsDisplay[elements[k].id]!.pos.x += (numWH.width - denWH.width) / 2.0
//                    }
//                } else {
//                    for k in (i+1)...fracMid {
//                        elementsDisplay[elements[k].id]!.pos.x += (denWH.width - numWH.width) / 2.0
//                    }
//                }
//                
//                pos.x += max(numWH.width, denWH.width) + fractionGap / 2.0
//                elementsDisplay[elements[i].id]!.spare = max(numWH.width, denWH.width)
//                elementsDisplay[elements[i].id]!.pos.x += elementsDisplay[elements[i].id]!.spare! / 2.0
//                
//                i = fracEnd
            }
            
            i += 1
        }
        
        return ExpressionDim(width: pos.x - startPos.x, height: maxY - minY, minY: minY, maxY: maxY)
    }
}
