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

    let characterValue: BComplex
    let numOfParams: Int
    let evaluate: ([BComplex]) throws -> BComplex

    let getSubScales:         (Int, CGFloat) -> CGFloat
    private let getOverallDimensions: (inout [ExpressionDim], CGFloat, [CGFloat]) -> ExpressionDim
    private let getSubPositions:      (inout [ExpressionDim], CGFloat, [CGFloat]) -> [CGPoint]
    private let getFuncViewParams:    (inout [ExpressionDim], CGFloat, [CGFloat]) -> [CGFloat]
    let functionView:         ([CGFloat], CGFloat) -> AnyView

    init(
        type: ElementType,
        string: String = "",
        dimension: ExpressionDim = ExpressionDim(),
        functionGap: (left: CGFloat, right: CGFloat) = (left: 0, right: 0),
        hyperParams: [CGFloat] = [],
        characterValue: BComplex = BComplex(),
        numOfParams: Int = 0,
        evaluate:             @escaping ([BComplex]) throws -> BComplex = {_ in return BComplex()},
        getSubScales:         @escaping (Int, CGFloat) -> CGFloat = { _, _ in return 1 },
        getOverallDimensions: @escaping (inout [ExpressionDim], CGFloat, [CGFloat]) -> ExpressionDim = { _, _, _ in return ExpressionDim() },
        getSubPositions:      @escaping (inout [ExpressionDim], CGFloat, [CGFloat]) -> [CGPoint] = { _, _, _ in return [] },
        getFuncViewParams:    @escaping (inout [ExpressionDim], CGFloat, [CGFloat]) -> [CGFloat] = { _, _, _ in return [] },
        functionView:         @escaping ([CGFloat], CGFloat) -> AnyView = { _, _ in AnyView(EmptyView()) }
    ) {
        self.id = UUID()
        self.type = type
        self.string = string
        self.dimension = dimension
        self.functionGap = functionGap
        self.hyperParams = hyperParams
        self.characterValue = characterValue
        self.numOfParams = numOfParams
        self.evaluate = evaluate
        self.getSubScales = getSubScales
        self.getOverallDimensions = getOverallDimensions
        self.getSubPositions = getSubPositions
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
    Element(type: .number, string: "1", dimension: ExpressionDim(width: 15, height: 30))
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
    Element(type: .number, string: ".", dimension: ExpressionDim(width: 10, height: 30))

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

    static let bracket_start =
    Element(type: .bracket_start, string: "(", dimension: ExpressionDim(width: 15, height: 30))
    static let bracket_end =
    Element(type: .bracket_end, string: ")", dimension: bracket_start.dimension)

    static let pi =
    Element(type: .character, string: "π", dimension: ExpressionDim(width: 20, height: 30), characterValue: BComplex(re: BDouble("3.14159265358979323846")!))

    static let e =
    Element(type: .character, string: "e", dimension: ExpressionDim(width: 20, height: 30), characterValue: BComplex(re: BDouble("2.71828182845904523536")!))

    static let h =
    Element(type: .character, string: "h", dimension: ExpressionDim(width: 20, height: 30), characterValue: BComplex(re: BDouble("6.62607")! / BDouble("10000000000000000000000000000000000")!))

    static let n =
    Element(type: .character, string: "n", dimension: ExpressionDim(width: 20, height: 30), characterValue: BComplex(re: BDouble("0.000000001")!))

    static let img =
    Element(type: .character, string: "i", dimension: ExpressionDim(width: 15, height: 30), characterValue: BComplex(re: 0, im: 1))

    static let percent =
    Element(type: .character, string: "%", dimension: ExpressionDim(width: 25, height: 30), characterValue: BComplex(re: BDouble("0.01")!))

    static let power_start =
    Element(
        type: .semi_start,
        string: "power_start",
        functionGap: (left: 0, right: 2),
        numOfParams: 2,
        evaluate: { params in
            return try BPow(params[0], params[1])
        },
        getSubScales: { index, scale in
            return (index == 0 ? scale : scaleIteration(scale, coef: 0.6))
        },
        getOverallDimensions: { dims, scale, params in
            // 0: base
            // 1: exponent
            let coef: CGFloat = 0.25
            let h = (dims[1].height * (1 - coef) < dims[0].height / 2.0) ? dims[0].height + dims[1].height * coef : dims[0].height / 2.0 + dims[1].height
            return ExpressionDim(
                width: dims[0].width + dims[1].width + 2 * scale,
                height: h,
                minY: dims[0].maxY - h,
                maxY: dims[0].maxY
            )
        },
        getSubPositions: { dims, scale, params in
            let coef: CGFloat = 0.25
            let h = (dims[1].height * (1 - coef) < dims[0].height / 2.0) ? dims[0].height + dims[1].height * coef : dims[0].height / 2.0 + dims[1].height
            return [
                CGPoint(x: 0, y: 0),
                CGPoint(x: dims[0].width + 2 * scale, y: -(h - dims[0].maxY + dims[1].minY))
            ]
        },
        getFuncViewParams: { dims, scale, params in
            return []
        },
        functionView: { params, scale in
            AnyView(EmptyView())
        }
    )

    static let power_end = Element(type: .semi_end, string: "power_end")

    static let PLH = Element(type: .placeholder, string: "PLH", dimension: ExpressionDim(width: 25, height: 30))
    static let SEP = Element(type: .separator, string: "SEP")
    static let SEP2 = Element(type: .separator, string: "SEP2")
    static let END = Element(type: .other, string: "END", dimension: ExpressionDim(width: 150, height: 30))

}

func scaleIteration(_ value: CGFloat, coef: CGFloat, convergeTo: CGFloat = 0.4) -> CGFloat {
    let a = (coef - convergeTo) / (1 - convergeTo)
    let b = coef - a
    return a * value + b
}



