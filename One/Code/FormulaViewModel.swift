//
//  FormulaViewModel.swift
//  One
//
//  Created by Tingwu on 2023/9/28.
//

import Foundation

class FormulaViewModel: ObservableObject {

    @Published var elements: [ElementWithID]
    @Published var elementsDisplayDict = ElementDisplayDict()
    
    @Published var wholeOffsetY: CGFloat = 0
    @Published var wholeWidth: CGFloat = 0
    
    @Published var cursorLocation: Int = 0
    @Published var cursorKey: Int? = nil

    var fractionGap: CGFloat = 4 //

    var hapticManager = HapticManager.instance
    
//    static let example = FormulaViewModel(elements: [ElementWithID(element: .one), ElementWithID(element: .END)])
    
//    static let example = FormulaViewModel(elements: [ElementWithID(element: .one), 
//                                                     ElementWithID(element: .plus),
//                                                     ElementWithID(element: .two),
//                                                     ElementWithID(element: .multiply),
//                                                     ElementWithID(element: .S_frac),
//                                                     ElementWithID(element: .five),
//                                                     ElementWithID(element: .SEP),
//                                                     ElementWithID(element: .seven),
//                                                     ElementWithID(element: .E_frac),
//                                                     ElementWithID(element: .END)])
    
    init() {
        let firstElement = ElementWithID(element: .END)
        elements = [firstElement]
        cursorLocation = 0
    }
    
//    init(elements: [ElementWithID]) {
//        self.elements = elements
//        keysArray = elements.map({$0.id})
//        cursorLocation = 0
//    }
    
    func typeIn(_ index: Int) {
        let command = keyList[index].command
        let shift = keyList[index].cursorShift
        
        if(!command.isEmpty) {
            if(elements[cursorLocation].element == .PLH) {
                removeElement(at: cursorLocation)
            }
            elements.insert(contentsOf: command.map({ElementWithID(element: $0)}), at: cursorLocation)
            
            // give each element an ID
            for i in cursorLocation..<(cursorLocation + command.count) {
                elementsDisplayDict.write(&elements[i].id, ElementDisplay(index: i, element: elements[i].element))
            }
            
            // if inserted a function, determine pair ID
            if !keyList[index].segments.isEmpty {
                
                // head
                elements[cursorLocation].pair = elements[cursorLocation + keyList[index].segments.last!].id
                
                // seps and tail
                for i in keyList[index].segments.indices {
                    elements[cursorLocation + keyList[index].segments[i]].pair = elements[cursorLocation].id
                }
            }
            
            updateParams()
            
            cursorLocation += shift
            updateCursorKey()
        }
    }
    
    private func insertElement(_ element: Element, at: Int) {
        if((0...elements.count).contains(at)) {
            elements.insert(ElementWithID(element: element), at: at)
        }
    }
    
    private func removeElement(at: Int) {
        if(elements.indices.contains(at)) {
            if let id = elements[at].id {
                elementsDisplayDict.erase(id)
                elements.remove(at: at)
            }
        }
    }
    
    func backspace() {
        func insertPlh(at: Int) {
            if(at > 0){
                let needPlhCases: [(ElementType, ElementType)] = [(.func_start, .separator), (.separator, .separator), (.separator, .func_end), (.func_start, .func_end)]
                let currentCase: (ElementType, ElementType) = (elements[at - 1].element.type, elements[at].element.type)
                if(needPlhCases.contains(where: { pair in return pair == currentCase })) {
                    insertElement(.PLH, at: at)
                }
            }
        }
        
        var deletedSomething = false
        
        while (!deletedSomething){
            if(cursorLocation - 1 < 0) {
                return
            }
            
            self.shiftCursor(-1, withHaptics: false)
            
            switch elements[cursorLocation].element.type {
                
            case .placeholder, .separator, .func_end:
                break
                
            case .func_start:
                var i: Int = cursorLocation + 1
                var isEmpty: Bool = true
                
                while(elements[i].element.type != .func_end) {
                    if(elements[i].element.type != .placeholder && elements[i].element.type != .separator){
                        isEmpty = false
                        break
                    }
                    i += 1
                }
                
                if(isEmpty) { // function is empty
                    while(elements[cursorLocation].element.type != .func_end) {
                        removeElement(at: cursorLocation)
                    }
                    removeElement(at: cursorLocation)
                    deletedSomething = true
                    insertPlh(at: cursorLocation)
                }
                
            default:
                removeElement(at: cursorLocation)
                deletedSomething = true
                insertPlh(at: cursorLocation)
            }
        }
    
        updateCursorKey()
        updateParams()
    }
    
    func clear() {
        elements.removeAll()
        elementsDisplayDict.eraseAll()
        
        elements.append(ElementWithID(element: .END))
        cursorLocation = 0
        updateCursorKey()
        updateParams()
    }
    
    func shiftCursor(_ step: Int, withHaptics: Bool) {
        step > 0 ? shiftR(withHaptics) : shiftL(withHaptics)
        updateCursorKey()
    }
    
    private func shiftL(_ withHaptics: Bool) {
        if(cursorLocation - 1 >= 0){
            cursorLocation -= 1
            if(cursorLocation - 1 >= 0 && elements[cursorLocation - 1].element == .PLH) {
                cursorLocation -= 1
            }
            if(withHaptics) {
                cursorLocation == 0 ? hapticManager.impact(style: .soft) : hapticManager.wheel()
            }
        }
    }
    
    private func shiftR(_ withHaptics: Bool) {
        if(cursorLocation + 1 < elements.count){
            cursorLocation += 1
            if(elements[cursorLocation - 1].element == .PLH){
                cursorLocation += 1
            }
            if(withHaptics) {
                cursorLocation == elements.count - 1 ? hapticManager.impact(style: .soft) : hapticManager.wheel()
            }
        }
    }
    
    func updateCursor(index: Int) {
        if(index >= 0 && index < elements.count) {
            cursorLocation = index
            updateCursorKey()
        }
    }
    
    func updateCursorKey() {
        cursorKey = elements[cursorLocation].id
    }
    
    func updateParams() {
        pairBrackets()
        let tmp = self.parse(start: 0, end: elements.count, scale: 1)
        self.wholeOffsetY = -tmp.minY
        self.wholeWidth = tmp.width
        
        // print elements
//        for e in elements {
//            print("(\(e.element.string), \tid: \(e.id!), \tpair: \(e.pair == nil ? -1 : e.pair!))")
//            
//        }
//        print("")
        
        // print dictionary
//        let list = elementsDisplayDict.array.map({
//            if let e = $0 {
//                return "(" + e.element.string + ", \t\tindex: \(e.index), \t\(e.pos))"
//            } else {
//                return "nil"
//            }
//        })
//        
//        for str in list {
//            print(str)
//        }
//        
//        print("")
    }
    
    func pairBrackets() {
        var stack = Stack<BracketStackItem>()
        
        for i in elements.indices {
            if (elements[i].element.type == .func_start) {
                stack.push(BracketStackItem(type: .function, index: i))
                
            } else if (elements[i].element == .S_bracket) {
                elements[i].pair = nil
                stack.push(BracketStackItem(type: .normal, index: i))
                
            } else if (elements[i].element.type == .func_end) {
                while (stack.peek()?.type != .function) {
                    var _ = stack.pop()
                }
                var _ = stack.pop()
                
            } else if (elements[i].element == .E_bracket) {
                elements[i].pair = nil
                if (stack.peek()?.type == .normal) {
                    let leftIndex = stack.pop()!.index
                    elements[i].pair = elements[leftIndex].id
                    elements[leftIndex].pair = elements[i].id
                }
            }
        }
        
        struct Stack<Item> {
            private var storage = [Item]()
            func peek() -> Item? { storage.last }
            mutating func push(_ item: Item) { storage.append(item)  }
            mutating func pop() -> Item? { storage.popLast() }
        }
        
        struct BracketStackItem {
            var type: BracketType
            var index: Int
        }
        
        enum BracketType {
            case normal
            case function
        }
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
            if(elements[i].element == .S_bracket && elements[i].pair != nil) {
                let w = elements[i].element.dimension.width * scale
                let h = elements[i].element.dimension.height * scale
                
                elementsDisplayDict.write(&elements[i].id, ElementDisplay(index: i, element: elements[i].element, pos: pos, scale: scale))
                pos.x += w
                
                let headID = elements[i].id
                var j = i + 1
                
                while (true) {
                    if (elements[j].pair == headID) { break }
                    j += 1
                }
                
                let innerDimension: ExpressionDim = parse(start: i+1, end: j, startPos: CGPoint(x: pos.x, y: 0), scale: scale)
                let bracketMinY = (i + 1 == j) ? -h * 0.5 : innerDimension.minY
                let bracketMaxY = (i + 1 == j) ?  h * 0.5 : innerDimension.maxY
                
                minY = min(minY, bracketMinY)
                maxY = max(maxY, bracketMaxY)
                pos.x += innerDimension.width
            
                elementsDisplayDict.write(&elements[j].id, ElementDisplay(index: j, element: elements[j].element, pos: pos, scale: scale))
                pos.x += w
                
                elementsDisplayDict.array[elements[i].id!]?.params = [w, bracketMaxY - bracketMinY, bracketMinY, bracketMaxY] // 0: width, 1: height, 2: minY, 3: maxY
                elementsDisplayDict.array[elements[j].id!]?.params = [w, bracketMaxY - bracketMinY, bracketMinY, bracketMaxY]
                
                i = j
                
            } else if(elements[i].element.type == .func_start) {
                /* If the element is the start of a function */
                
                pos.x += elements[i].element.functionGap.left * scale
                elementsDisplayDict.write(&elements[i].id, ElementDisplay(index: i, element: elements[i].element, pos: pos, scale: scale))
                
                // Find each sub-expression sections in the function
                
                let headID = elements[i].id
                let tailID = elements[i].pair
                var j = i + 1
                var sepList: [Int] = [i]
                
                while(true) {
                    if(elements[j].pair == headID) {
                        sepList.append(j)
                        if(elements[j].id == tailID){ break }
                    }
                    j += 1
                }
                
                // Calculate the dimensions of each sub-expressions by calling parse() recursively
                var subDimensions: [ExpressionDim] = Array(sepList.indices.dropLast()).map(
                    { parse(
                        start: sepList[$0] + 1,
                        end: sepList[$0+1] + 1,
                        startPos: CGPoint(x: pos.x, y: 0),
                        scale: elements[i].element.getSubScales($0, scale)
                    ) }
                )
                
                // Calculate the position offset of each sub-expressions and apply
                let subPositions: [CGPoint] = elements[i].element.getSubPositions(dims: &subDimensions, scale: scale)
                for k in 0..<(sepList.count - 1) {
                    for l in (sepList[k] + 1)..<(sepList[k+1] + 1) {
                        elementsDisplayDict.array[elements[l].id!]?.pos += subPositions[k]
                    }
                }
                
                // Calculate the overall dimensions the whole function expression
                let overallDimensions: ExpressionDim = elements[i].element.getOverallDimensions(dims: &subDimensions, scale: scale)
                
                elementsDisplayDict.array[elements[i].id!]?.params = elements[i].element.getFuncViewParams(dims: &subDimensions, scale: scale)
                
                // Update maxY and minY
                minY = min(minY, overallDimensions.minY)
                maxY = max(maxY, overallDimensions.maxY)
                
                // Update pos
                pos.x += overallDimensions.width
                pos.x += elements[i].element.functionGap.right * scale
                
                // Skip rest of the function
                i = sepList.last!
                
            } else {
                /* If the element is a character */
                
                // Calculate the position offset of the character
                elementsDisplayDict.write(&elements[i].id, ElementDisplay(index: i, element: elements[i].element, pos: pos, scale: scale))
                pos.x += elements[i].element.dimension.width * scale
                
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
                
            }
            
            i += 1
        }
        
        return ExpressionDim(width: pos.x - startPos.x, height: maxY - minY, minY: minY, maxY: maxY)
    }
}

class ElementDisplayDict: Equatable, ObservableObject {
    var array: [ElementDisplay?] = [nil]
    private(set) var nextID: Int = 0
    
    private(set) var length: Int = 1
    private var numberOfElements: Int = 0
    private var numberOfNils : Int {
        length - numberOfElements
    }
    
    static func == (lhs: ElementDisplayDict, rhs: ElementDisplayDict) -> Bool {
        return lhs.array == rhs.array
    }
    
    func write(_ elementID: inout Int?, _ ed: ElementDisplay) {
        if let id = elementID {
            array[id] = ed
        } else {
            elementID = nextID
            array[nextID] = ed
            numberOfElements += 1
            if(numberOfNils == 0) {
                array.append(nil)
                length += 1
                nextID = length - 1
            } else {
                var i = nextID + 1
                while(array[i] != nil) { i += 1 }
                nextID = i
            }
        }
    }
    
    func erase(_ index: Int) {
        if(index >= 0 && index < length) {
            
            array[index] = nil
            nextID = min(nextID, index)
            numberOfElements -= 1
            
        }
    }
    
    func eraseAll() {
        array = [nil]
        nextID = 0
        length = 1
        numberOfElements = 0
    }
}
