//
//  BracketView.swift
//  One
//
//  Created by Tingwu on 2023/10/17.
//

import SwiftUI

struct BracketView: View {
    var side: Side
    var params: [CGFloat]
    var scale: CGFloat
    // 0: width
    // 1: height
    // 2: minY
    // 3: maxY
    
    var body: some View {
        BracketShape(side: side)
            .stroke(style: StrokeStyle(lineWidth: 2 * scale, lineCap: .round))
            .frame(width: params[0], height: params[1])
    }
    
    struct BracketShape: Shape {
        var side: Side
        
//        func shrink(_ val: CGFloat, height: CGFloat) -> CGFloat {
//            let ratio = height - gap * 2 * scale
//            return (val - height / 2) * 0.8 + height / 2
//        }
        
        func path(in rect: CGRect) -> Path {
            return Path { path in
                let width = rect.width
                let height = rect.height
                let edgeX: CGFloat = (side == .left) ? 0.6 : 0.4
                let middleX: CGFloat = (side == .left) ? 0.4 : 0.6
//                let gap = 5
                
                let P = [CGPoint(x: width * edgeX,   y: 0),
                         CGPoint(x: width * middleX, y: (height < 20 ? height * 0.5 : 10)),
                         CGPoint(x: width * middleX, y: (height < 20 ? height * 0.5 : height - 10)),
                         CGPoint(x: width * edgeX,   y: height)]
                
                let C = [CGPoint(x: width * middleX, y: (height < 20 ? height * 0.2 : 2)),
                         CGPoint(x: width * middleX, y: (height < 20 ? height * 0.8 : height - 2))]

                path.move(to: P[0])
                path.addQuadCurve(to: P[1], control: C[0])
                path.addLine(to: P[2])
                path.addQuadCurve(to: P[3], control: C[1])
            }
        }
    }
    
    enum Side {
        case left
        case right
    }
}

#Preview {
    BracketView(side: .left, params: [15, 30, -15, 15], scale: 1)
//        .border(.black)
}
