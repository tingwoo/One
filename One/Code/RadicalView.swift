//
//  RadicalView.swift
//  One
//
//  Created by Tingwu on 2023/10/14.
//

import SwiftUI

struct RadicalView: View {
    var leftGap: CGFloat
    var width: CGFloat
    var height: CGFloat
    var xOffset: CGFloat
    var yOffset: CGFloat
    
//    func pointSet(index: Int) -> AnimatablePair<CGFloat, CGFloat> {
//        if(index == 0) {
//            return AnimatablePair(-min(5, height / 4.0), height - min(5, height / 4.0))
//        } else if(index == 1) {
//            return AnimatablePair(0, height)
//        } else if(index == 2) {
//            return AnimatablePair(0, 0)
//        } else {
//            return AnimatablePair(width, 0)
//        }
//    }
    
    var body: some View {
        VStack(spacing: 0) {
            if(yOffset > 0) {
                Color.clear.frame(width: 1, height: yOffset * 2)
//                    .border(.black)
            }
            HStack(spacing: 0) {
                Color.clear
                    .frame(width: leftGap * 2 + width + xOffset, height: height)
//                    .border(.blue)
                
                Color.clear
                    .frame(width: xOffset, height: height)
//                    .border(.blue)
                
                RadicalShape()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .frame(width: width, height: height)
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
    RadicalView(leftGap: 0, width: 70, height: 30, xOffset: 50, yOffset: 0)
}
