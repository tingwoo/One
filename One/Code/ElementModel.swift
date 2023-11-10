//
//  ElementModel.swift
//  One
//
//  Created by Tingwu on 2023/10/10.
//

import Foundation
import SwiftUI

class Element: Equatable, Identifiable {
    let id: UUID
    let type: ElementType
    let string: String
    let dimension: ExpressionDim
    
    let functionGap: (left: CGFloat, right: CGFloat)
    let hyperParams: [CGFloat]
    private let getOverallDimensions: (inout [ExpressionDim], CGFloat, [CGFloat]) -> ExpressionDim
    private let getSubPositions:      (inout [ExpressionDim], CGFloat, [CGFloat]) -> [CGPoint]
    let getSubScales:         (Int, CGFloat) -> CGFloat
    private let getFuncViewParams:    (inout [ExpressionDim], CGFloat, [CGFloat]) -> [CGFloat]
    let functionView:         ([CGFloat], CGFloat) -> AnyView
    
    init(
        type: ElementType,
        string: String = "",
        dimension: ExpressionDim = ExpressionDim(),
        functionGap: (left: CGFloat, right: CGFloat) = (left: 0, right: 0),
        hyperParams: [CGFloat] = [],
        getOverallDimensions: @escaping (inout [ExpressionDim], CGFloat, [CGFloat]) -> ExpressionDim = { _, _, _ in return ExpressionDim() },
        getSubPositions:      @escaping (inout [ExpressionDim], CGFloat, [CGFloat]) -> [CGPoint] = { _, _, _ in return [] },
        getSubScales:         @escaping (Int, CGFloat) -> CGFloat = { _, _ in return 1 },
        getFuncViewParams:    @escaping (inout [ExpressionDim], CGFloat, [CGFloat]) -> [CGFloat] = { _, _, _ in return [] },
        functionView:         @escaping ([CGFloat], CGFloat) -> AnyView = { _, _ in AnyView(EmptyView()) }
    ) {
        self.id = UUID()
        self.type = type
        self.string = string
        self.dimension = dimension
        self.functionGap = functionGap
        self.hyperParams = hyperParams
        self.getOverallDimensions = getOverallDimensions
        self.getSubPositions = getSubPositions
        self.getSubScales = getSubScales
        self.getFuncViewParams = getFuncViewParams
        self.functionView = functionView
    }
    
    static func ==(lhs: Element, rhs: Element) -> Bool {
        return lhs.id == rhs.id
    }
    
    func getOverallDimensions(dims: inout [ExpressionDim], scale: CGFloat) -> ExpressionDim {
        return self.getOverallDimensions(&dims, scale, self.hyperParams)
    }
    
    func getSubPositions(dims: inout [ExpressionDim], scale: CGFloat) -> [CGPoint] {
        return self.getSubPositions(&dims, scale, self.hyperParams)
    }
    
    func getFuncViewParams(dims: inout [ExpressionDim], scale: CGFloat) -> [CGFloat] {
        return self.getFuncViewParams(&dims, scale, self.hyperParams)
    }
    
    static let null = Element(type: .other)
    
    static let one = 
    Element(type: .character, string: "1", dimension: ExpressionDim(width: 15, height: 30))
    static let two =
    Element(type: one.type, string: "2", dimension: one.dimension)
    static let three = 
    Element(type: one.type, string: "3", dimension: one.dimension)
    static let four = 
    Element(type: one.type, string: "4", dimension: one.dimension)
    static let five = 
    Element(type: one.type, string: "5", dimension: one.dimension)
    static let six = 
    Element(type: one.type, string: "6", dimension: one.dimension)
    static let seven = 
    Element(type: one.type, string: "7", dimension: one.dimension)
    static let eight = 
    Element(type: one.type, string: "8", dimension: one.dimension)
    static let nine = 
    Element(type: one.type, string: "9", dimension: one.dimension)
    static let zero = 
    Element(type: one.type, string: "0", dimension: one.dimension)
    
    static let point =
    Element(type: .character, string: ".", dimension: ExpressionDim(width: 10, height: 30))
    
    static let answer =
    Element(type: .character, string: "Ans", dimension: ExpressionDim(width: 52, height: 30))
    
    static let plus =
    Element(type: .symbol, string: "plus", dimension: ExpressionDim(width: 25, height: 30))
    static let minus =
    Element(type: plus.type, string: "minus",    dimension: plus.dimension)
    static let multiply =
    Element(type: plus.type, string: "multiply", dimension: plus.dimension)
    static let divide =
    Element(type: plus.type, string: "divide",   dimension: plus.dimension)
    
    static let paren_l =
    Element(type: .character, string: "(", dimension: ExpressionDim(width: 15, height: 30))
    static let paren_r =
    Element(type: paren_l.type, string: ")", dimension: paren_l.dimension)
    
    static let S_radical
    = Element(
        type: .func_start,
        string: "S_radical",
        functionGap: (left: 0, right: 4),
        getOverallDimensions: { dims, scale, params in
            // 0: index
            // 1: radicand
            let coef: CGFloat = 0.25
            let h = (dims[0].height * (1 - coef) * 2 < dims[1].height) ? dims[0].height * coef + dims[1].height : dims[1].height / 2.0 + dims[0].height
            return ExpressionDim(
                width: dims[0].width + dims[1].width + 8,
                height: h,
                minY: dims[1].maxY - h,
                maxY: dims[1].maxY
            )
        },
        getSubPositions: { dims, scale, params in
            let coef: CGFloat = 0.25
            let tmp = dims[0].maxY - dims[1].minY
            return [
                CGPoint(
                    x: 0,
                    y: (dims[0].height * (1 - coef) * 2 < dims[1].height) ? (dims[0].height * (1 - coef) - tmp) : (dims[1].height / 2.0 - tmp)
                ),
                CGPoint(x: dims[0].width + 8, y: 0)
            ]
        },
        getSubScales: { index, scale in
            return (index == 0 ? scaleIteration(scale, coef: 0.6) : scale)
        },
        getFuncViewParams: { dims, scale, params in
            // 0: width
            // 1: height
            // 2: x offset
            // 3: y offset
            return [dims[1].width + 4, dims[1].height, dims[0].width + 4, dims[1].maxY - dims[1].height / 2.0]
        },
        functionView: { params, scale in
            AnyView(RadicalView(leftGap: 0, width: params[0], height: params[1], xOffset: params[2], yOffset: params[3], scale: scale))
        }
    )
    static let E_radical = Element(type: .func_end, string: "E_radical")
    
    static let pi =
    Element(type: .character, string: "π", dimension: ExpressionDim(width: 20, height: 30))
    
    static let percent =
    Element(type: .character, string: "%", dimension: ExpressionDim(width: 25, height: 30))
    
    static let PLH = Element(type: .placeholder, string: "PLH", dimension: ExpressionDim(width: 25, height: 30))
    static let SEP = Element(type: .separator, string: "SEP")
    static let END = Element(type: .other, string: "END", dimension: ExpressionDim(width: 150, height: 30))

}

func scaleIteration(_ value: CGFloat, coef: CGFloat, convergeTo: CGFloat = 0.4) -> CGFloat {
    let a = (coef - convergeTo) / (1 - convergeTo)
    let b = coef - a
    return a * value + b
}


