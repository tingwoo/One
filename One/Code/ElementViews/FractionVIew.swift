//
//  FractionVIew.swift
//  One
//
//  Created by Tingwu on 2023/11/10.
//

import SwiftUI

extension Element {
    static let frac_start
    = Element(
        type: .func_start,
        string: "frac_start",
        functionGap: (left: 3, right: 3),
        hyperParams: [5, 3], // 0: extended Length, 1: gap between number and line
//        functionGap: (left: 20, right: 20),
//        hyperParams: [20, 20], // 0: extended Length, 1: gap between number and line
        getSubScales: { index, scale in
            return scaleIteration(scale, coef: 0.9)
        },
        getOverallDimensions: { dims, scale, params in
            let extendedLength: CGFloat = params[0] * scale
            let gap: CGFloat = params[1] * scale

            // 0: numerator
            // 1: denominator
            return ExpressionDim(
                width: max(dims[0].width, dims[1].width) + extendedLength * 2,
                height: dims[0].height + dims[1].height + gap * 2,
                minY: -dims[0].height - gap,
                maxY: dims[1].height + gap
            )
        },
        getSubPositions: { dims, scale, params in
            let extendedLength: CGFloat = params[0] * scale
            let gap: CGFloat = params[1] * scale

            var tmp: Bool = dims[0].width >= dims[1].width
            var diff: CGFloat = abs(dims[0].width - dims[1].width) / 2.0 + extendedLength

            return [
                CGPoint(x: tmp ? extendedLength : diff, y: -dims[0].maxY - gap),
                CGPoint(x: tmp ? diff : extendedLength, y: -dims[1].minY + gap)
            ]
        },
        getFuncViewParams: { dims, scale, params in
            let extendedLength: CGFloat = params[0] * scale

            // 0: divider length
            return [max(dims[0].width, dims[1].width) + extendedLength * 2]
        },
        functionView: { params, scale in
            AnyView(FractionView(length: params[0], scale: scale))
        }
    )

    static let frac_end = Element(type: .func_end, string: "frac_end")
}

struct FractionView: View {
//    var leftGap: CGFloat
    var length: CGFloat
    var scale: CGFloat

    var body: some View {
        HStack(spacing: 0) {
//            Color.clear.frame(width: length, height: 0)
            Rectangle().frame(width: length, height: 2 * scale)
        }
    }
}

//#Preview {
//    FractionVIew()
//}

