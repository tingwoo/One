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

    var hapticManager = HapticManager.instance

//    static let example = FormulaViewModel(elements: [ElementWithID(element: .one), ElementWithID(element: .END)])

//    static let example = FormulaViewModel(elements: [ElementWithID(element: .one),
//                                                     ElementWithID(element: .plus),
//                                                     ElementWithID(element: .two),
//                                                     ElementWithID(element: .multiply),
//                                                     ElementWithID(element: .frac_start),
//                                                     ElementWithID(element: .five),
//                                                     ElementWithID(element: .SEP),
//                                                     ElementWithID(element: .seven),
//                                                     ElementWithID(element: .frac_end),
//                                                     ElementWithID(element: .END)])

    init() {
        let firstElement = ElementWithID(element: .END)
        elements = [firstElement]
        elementsDisplayDict.write(&elements[0].id, ElementDisplay(index: 0, element: elements[0].element))
        cursorLocation = 0
    }

//    init(elements: [ElementWithID]) {
//        self.elements = elements
//        keysArray = elements.map({$0.id})
//        cursorLocation = 0
//    }

    func typeIn(_ index: Int) {
        let command = keyList[index].command

        if !command.isEmpty {
            if elements[cursorLocation].element == .PLH {
                removeElement(at: cursorLocation)
            }

            insertElement(command, at: cursorLocation)

            // determine pair ID
            for i in keyList[index].pairList.indices {
                if let p = keyList[index].pairList[i] {
                    elements[cursorLocation + i].pair = elements[cursorLocation + p].id
                }
            }

            cursorLocation += keyList[index].cursorShift
            updateCursorKey()
            updateParams()
        }
    }

    private func insertElement(_ element: Element, at: Int) {
        if (0...elements.count).contains(at) == false {
            return
        }

        elements.insert(ElementWithID(element: element), at: at)
        elementsDisplayDict.write(&elements[at].id, ElementDisplay(index: at, element: elements[at].element))
    }

    private func insertElement(_ elementList: [Element], at: Int) {
        if (0...elements.count).contains(at) == false {
            return
        }
        
        // 1. insert one at a time
        // for i in elementList.indices {
        //     elements.insert(ElementWithID(element: elementList[i]), at: at + i)
        // }

        // 2. insert all at once
        elements.insert(contentsOf: elementList.map({ElementWithID(element: $0)}), at: at)

        // give each element an ID
        for i in at..<(at + elementList.count) {
            elementsDisplayDict.write(&elements[i].id, ElementDisplay(index: i, element: elements[i].element))
        }
    }

    private func removeElement(at: Int) {
        if elements.indices.contains(at) {
            if let id = elements[at].id {
                elementsDisplayDict.erase(id)
                elements.remove(at: at)
            }
        }
    }

    func backspace() {
        func insertPlh(at: Int) {
            if at > 0 {
                let needPlhCases: [(ElementType, ElementType)] = [
                    (.separator, .separator),
                    (.func_start, .separator),
                    (.separator, .func_end),
                    (.func_start, .func_end),
                    (.semi_start, .separator),
                    (.separator, .semi_end),
                    (.semi_start, .semi_end)
                ]
                let currentCase: (ElementType, ElementType) = (elements[at - 1].element.type, elements[at].element.type)
                if needPlhCases.contains(where: { pair in return pair == currentCase }) {
                    insertElement(.PLH, at: at)
                }
            }
        }

        var deletedSomething = false

        while !deletedSomething {
            if cursorLocation - 1 < 0 {
                return
            }

            self.shiftCursor(-1, withHaptics: false, skipInvisible: false)

            switch elements[cursorLocation].element.type {

            case .placeholder, .separator, .func_end, .semi_end:
                break

            case .func_start:
                var i: Int = cursorLocation + 1
                var isEmpty: Bool = true

                while elements[i].element.type != .func_end {
                    if elements[i].element.type != .placeholder && elements[i].element.type != .separator {
                        isEmpty = false
                        break
                    }
                    i += 1
                }

                if isEmpty { // function is empty
                    while elements[cursorLocation].element.type != .func_end {
                        removeElement(at: cursorLocation)
                    }
                    removeElement(at: cursorLocation)
                    deletedSomething = true
                    insertPlh(at: cursorLocation)
                }

            case .semi_start:
                var i: Int = cursorLocation + 1
                var isEmpty: Bool = true

                while elements[i].element.type != .semi_end {
                    if elements[i].element.type != .placeholder && elements[i].element.type != .separator {
                        isEmpty = false
                        break
                    }
                    i += 1
                }

                if isEmpty { // function is empty
                    while elements[cursorLocation].element.type != .semi_end {
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
        elementsDisplayDict.write(&elements[0].id, ElementDisplay(index: 0, element: elements[0].element))
        cursorLocation = 0
        updateParams()
    }

    func shiftCursor(_ direction: Int, withHaptics: Bool, skipInvisible: Bool) {
        let step = direction > 0 ? 1 : -1
        let originalLocation = cursorLocation

        if elements.indices.contains(cursorLocation + step) {
            cursorLocation += step
            if !skipInvisible { 
                updateCursorKey()
                return
            }
            skipInvisibleElement()
            if cursorLocation == originalLocation && elements.indices.contains(cursorLocation + 2 * step) {
                cursorLocation += 2 * step
            }
        }

        updateCursorKey()
    }

//    private func shiftL(_ withHaptics: Bool) {
//        if cursorLocation - 1 >= 0 {
//            cursorLocation -= 1
//            if cursorLocation - 1 >= 0 && elements[cursorLocation - 1].element == .PLH {
//                cursorLocation -= 1
//            }
//            if withHaptics {
//                cursorLocation == 0 ? hapticManager.impact(style: .soft) : hapticManager.wheel()
//            }
//        }
//    }
//
//    private func shiftR(_ withHaptics: Bool) {
//        if cursorLocation + 1 < elements.count {
//            cursorLocation += 1
//            if elements[cursorLocation - 1].element == .PLH {
//                cursorLocation += 1
//            }
//            if withHaptics {
//                cursorLocation == elements.count - 1 ? hapticManager.impact(style: .soft) : hapticManager.wheel()
//            }
//        }
//    }

    func setCursor(index: Int) {
        if index >= 0 && index < elements.count {
            cursorLocation = index
            updateCursorKey()
        }
    }

    func updateCursorLocation() {
        if let newLocation = elements.firstIndex(where: { $0.id == cursorKey }) {
            cursorLocation = newLocation
        }
    }

    func updateCursorKey() {
        cursorKey = elements[cursorLocation].id
    }

    func skipInvisibleElement() {
        if cursorLocation >= 1 && elements[cursorLocation - 1].element == .PLH {
            cursorLocation -= 1
            print("skip PLH")
        }

        if elements[cursorLocation].element.type == .semi_start {
            cursorLocation += 1
            print("skip semi_start")
        }

    }

    func updateParams() {
        pairBrackets()

        handleSemiFunctions()

        skipInvisibleElement()

        updateCursorKey()

        let tmp = self.parse(start: 0, end: elements.count, scale: 1)
        self.wholeOffsetY = -tmp.minY
        self.wholeWidth = tmp.width

        // print elements
        for e in elements {
//            print("(\(e.element.string), \tid: \(e.id!), \tpair: \(e.pair == nil ? -1 : e.pair!))")
            print("\(e.element.string),\t\tid: \(e.id ?? 0),\t\tpair: \(e.pair ?? 0)")

        }
        print("Cursor Location: \(cursorLocation)")
        print("Cursor Key:      \(cursorKey ?? -1)")
        print("")

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

    func handleSemiFunctions() {
        var i = 0
        var originalStartIndex: [Int: Int] = [:]

        // remove all semi_start
        var cnt = 0
        while i < elements.count {
            if elements[i].element.type == .semi_start {
                originalStartIndex[elements[i].pair!] = i + cnt
                cnt += 1
                removeElement(at: i)
                if elements[i].element == .PLH {
                    removeElement(at: i)
                    cursorLocation -= 1
                }
                continue
            }
            i += 1
        }

        // enclose the previous number / function / paired brackets
        i = 0
        while i < elements.count {
            if elements[i].element == .SEP2 {
                let tmpIdentifier: Int? = elements[i].pair
                var newHeadIndex: Int = 0

                if i == 0 {
                    insertElement([.power_start, .PLH], at: 0)
                    cursorLocation += 1
                    newHeadIndex = 0
                    i = 2
                } else {
                    switch elements[i-1].element.type {
                    case .number:
                        var j = i - 2
                        while j >= 0 && elements[j].element.type == .number {
                            j -= 1
                        }
                        insertElement(.power_start, at: j+1)
                        newHeadIndex = j+1
                        i += 1

                    case .character:
                        insertElement(.power_start, at: i-1)
                        newHeadIndex = i-1
                        i += 1

                    case .func_end:
                        let pair = elements[i-1].pair
                        if let j = elements.firstIndex(where: { $0.id == pair }) {
                            insertElement(.power_start, at: j)
                            newHeadIndex = j
                            i += 1
                        } else {
                            fatalError("func_end pair can't be found.")
                        }

                    case .bracket_end:
                        if let pair = elements[i-1].pair {
                            if let j = elements.firstIndex(where: { $0.id == pair }) {
                                insertElement(.power_start, at: j)
                                newHeadIndex = j
                                i += 1
                            } else {
                                fatalError("bracket_end pair can't be found.")
                            }
                        } else {
                            insertElement([.power_start, .PLH], at: i)
                            cursorLocation += 1
                            newHeadIndex = i
                            i += 2
                        }

                    default:
                        insertElement([.power_start, .PLH], at: i)
                        cursorLocation += 1
                        newHeadIndex = i
                        i += 2
                    }
                }

                var k = i
                while true {
                    if elements[k].pair == tmpIdentifier {
                        elements[k].pair = elements[newHeadIndex].id
                        if elements[k].element.type == .semi_end {
                            elements[newHeadIndex].pair = elements[k].id
                            break
                        }
                    }
                    k += 1
                }

            }
            i += 1
        }

        // check if any semi_start move past the cursor location
        i = 0
        while i < elements.count {
            if elements[i].element == .power_start {
                if (i - cursorLocation) < 0 && originalStartIndex[elements[i].pair!]! >= cursorLocation {
                    cursorLocation += 1
                    print("plus 1")
                } else if (i - cursorLocation) >= 0 && originalStartIndex[elements[i].pair!]! < cursorLocation {
                    cursorLocation -= 1
                    print("minus 1")
                }
            }
            i += 1
        }
    }

    func pairBrackets() {
        var stack = Stack<BracketStackItem>()

        for i in elements.indices {
            switch elements[i].element.type {
            case .func_start:
                stack.push(BracketStackItem(type: .function, index: i))

            case .bracket_start:
                elements[i].pair = nil
                stack.push(BracketStackItem(type: .normal, index: i))

            case .func_end:
                // pop all the elements pushed within the function
                while stack.peek()?.type != .function {
                    var _ = stack.pop()
                }
                var _ = stack.pop()

            case .bracket_end:
                elements[i].pair = nil
                if stack.peek()?.type == .normal {
                    let leftIndex = stack.pop()!.index
                    elements[i].pair = elements[leftIndex].id
                    elements[leftIndex].pair = elements[i].id
                }

            default:
                break
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

        while i < end {
            if elements[i].element == .bracket_start && elements[i].pair != nil {
                let w = elements[i].element.dimension.width * scale
                let h = elements[i].element.dimension.height * scale

                elementsDisplayDict.write(&elements[i].id, ElementDisplay(index: i, element: elements[i].element, pos: pos, scale: scale))
                pos.x += w

                let headID = elements[i].id
                var j = i + 1

                while true {
                    if elements[j].pair == headID { break }
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

            } else if elements[i].element.type == .func_start || elements[i].element.type == .semi_start {
                /* If the element is the start of a function */

                pos.x += elements[i].element.functionGap.left * scale
                elementsDisplayDict.write(&elements[i].id, ElementDisplay(index: i, element: elements[i].element, pos: pos, scale: scale))

                // Find each sub-expression sections in the function

                let headID = elements[i].id
                let tailID = elements[i].pair
                var j = i + 1
                var sepList: [Int] = [i]

                while true {
                    if elements[j].pair == headID {
                        sepList.append(j)
                        if elements[j].id == tailID { break }
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
            if numberOfNils == 0 {
                array.append(nil)
                length += 1
                nextID = length - 1
            } else {
                var i = nextID + 1
                while array[i] != nil { i += 1 }
                nextID = i
            }
        }
    }

    func erase(_ index: Int) {
        if index >= 0 && index < length {

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

