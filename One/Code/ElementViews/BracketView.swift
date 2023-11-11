//
//  BracketView.swift
//  One
//
//  Created by Tingwu on 2023/10/17.
//

import SwiftUI

struct BracketView: View {
    var side: Side
    var width: CGFloat = 15
    var params: [CGFloat] = [-15, 15]
    var scale: CGFloat
    
    var height: CGFloat {
        params[1] - params[0]
    }
    
    var body: some View {
        BracketShape(side: side)
            .stroke(style: StrokeStyle(lineWidth: 2 * scale, lineCap: .round))
            .frame(width: width, height: height)
            .offset(y: params[1] - height / 2)
    }
    
    struct BracketShape: Shape {
        var side: Side
        
        func path(in rect: CGRect) -> Path {
            return Path { path in
                let width = rect.width
                let height = rect.height
                let edgeX: CGFloat = (side == .left) ? 0.6 : 0.4
                let middleX: CGFloat = (side == .left) ? 0.4 : 0.6
                
                let P = [CGPoint(x: width * edgeX,   y: 0),
                         CGPoint(x: width * middleX, y: (height < 20 ? height * 0.5 : 10)),
                         CGPoint(x: width * middleX, y: (height < 20 ? height * 0.5 : height - 10)),
                         CGPoint(x: width * edgeX,   y: height)]
                
                let C = [CGPoint(x: width * middleX, y: (height < 20 ? height * 0.2 : 4)),
                         CGPoint(x: width * middleX, y: (height < 20 ? height * 0.8 : height - 4))]

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
    BracketView(side: .left, params: [-15, 15], scale: 1)
//        .border(.black)
}
