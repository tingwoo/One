//
//  RadicalView.swift
//  One
//
//  Created by Tingwu on 2023/10/14.
//

import SwiftUI

extension Element {
    static let radical_start
    = Element(
        type: .func_start,
        string: "radical_start",
        functionGap: (left: 0, right: 4),
        numOfParams: 2,
        evaluate: { params in
            return try BPow(params[1], BComplex(re: 1) / params[0])
        },
        getSubScales: { index, scale in
            return (index == 0 ? scaleIteration(scale, coef: 0.6) : scale)
        },
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

    static let radical_end = Element(type: .func_end, string: "radical_end")

    static let radical2_start
    = Element(
        type: .func_start,
        string: "radical2_start",
        functionGap: (left: 4, right: 4),
        numOfParams: 1,
        evaluate: { params in
            return try BPow(params[0], BComplex(re: 0.5))
        },
        getSubScales: { index, scale in
            return scale
        },
        getOverallDimensions: { dims, scale, params in
            return ExpressionDim(
                width: dims[0].width + 8,
                height: dims[0].height,
                minY: dims[0].minY,
                maxY: dims[0].maxY
            )
        },
        getSubPositions: { dims, scale, params in
            return [CGPoint(x: 8, y: 0)]
        },
        getFuncViewParams: { dims, scale, params in
            // 0: width
            // 1: height
            // 2: x offset
            // 3: y offset
            return [dims[0].width + 4, dims[0].height, 4, dims[0].maxY - dims[0].height / 2.0]
        },
        functionView: { params, scale in
            AnyView(RadicalView(leftGap: 0, width: params[0], height: params[1], xOffset: params[2], yOffset: params[3], scale: scale))
        }
    )

    static let radical2_end = Element(type: .func_end, string: "radical2_end")
}

struct RadicalView: View {
    var leftGap: CGFloat
    var width: CGFloat
    var height: CGFloat
    var xOffset: CGFloat
    var yOffset: CGFloat
    var scale: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            if(yOffset > 0) {
                Color.clear.frame(width: 1, height: yOffset * 2)
//                    .border(.black)
            }
            HStack(alignment: .top, spacing: 0) {
//                Color.clear
//                    .frame(width: leftGap * 2 + width + xOffset, height: height)
//                    .border(.blue)

                Color.clear
                    .frame(width: xOffset, height: height)
//                    .border(.blue)

                RadicalShape()
                .stroke(style: StrokeStyle(lineWidth: 2 * scale, lineCap: .round))
                .frame(width: width, height: height - 4 * scale)
            }
            if(yOffset < 0) {
                Color.clear.frame(width: 1, height: -yOffset * 2)
//                    .border(.black)
            }

        }
//        .border(.blue)
    }


    struct RadicalShape: Shape {
        func path(in rect: CGRect) -> Path {
            return Path { path in
                let width = rect.width
                let height = rect.height
                path.move(to: CGPoint(x: -min(5, height / 4.0) - 1, y: height - min(5, height / 4.0)))
                path.addLine(to: CGPoint(x: -1, y: height))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: width, y: 0))
            }
        }
    }
}



#Preview {
    RadicalView(leftGap: 0, width: 70, height: 30, xOffset: 50, yOffset: 0, scale: 1)
}

