//
//  BracketView.swift
//  One
//
//  Created by Tingwu on 2023/10/17.
//

import SwiftUI

struct BracketView: View {
    var side: Side
    var width: CGFloat
    var height: CGFloat
    var yOffset: CGFloat
    var scale: CGFloat
    
    var body: some View {
        BracketShape()
            .stroke(style: StrokeStyle(lineWidth: 2 * scale, lineCap: .round))
            .frame(width: width, height: height)
    }
    
    struct BracketShape: Shape {
        func path(in rect: CGRect) -> Path {
            return Path { path in
                let width = rect.width
                let height = rect.height
                
                let P = [CGPoint(x: width * 0.6, y: 0), 
                         CGPoint(x: width * 0.4, y: (height < 20 ? height * 0.5 : 10)),
                         CGPoint(x: width * 0.4, y: (height < 20 ? height * 0.5 : height - 10)),
                         CGPoint(x: width * 0.6, y: height)]
                
                let C = [CGPoint(x: width * 0.4, y: (height < 20 ? height * 0.2 : 4)),
                         CGPoint(x: width * 0.4, y: (height < 20 ? height * 0.8 : height - 4))]

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
    BracketView(side: .left, width: 15, height: 30, yOffset: 0, scale: 1)
//        .border(.black)
}
