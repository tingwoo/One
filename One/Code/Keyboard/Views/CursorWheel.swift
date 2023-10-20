//
//  CursorWheel.swift
//  One
//
//  Created by Tingwu on 2023/9/18.
//

import SwiftUI

func tickParams(tickIndex: Int,
                dragDist: CGFloat = 0,
                numOfTicks: Int,
                length: CGFloat,
                gapRatio: CGFloat,
                theta: CGFloat) -> (x: CGFloat, width: CGFloat) {
    
    let radius: CGFloat = length / 2.0 / sin(theta / 2.0)
    let dragAngle: CGFloat = dragDist / radius
    let wholeAngle: CGFloat = theta / (CGFloat(numOfTicks) - gapRatio)
    let tickAngle: CGFloat = wholeAngle * (1 - gapRatio)
    
    let tickStartAngle = theta / 2.0 - CGFloat(tickIndex) * wholeAngle - dragAngle
    let tickEndAngle = tickStartAngle - tickAngle
    
    let x = -radius * (sin(tickStartAngle) + sin(tickEndAngle)) / 2.0 + length / 2.0
    let width = radius * (sin(tickStartAngle) - sin(tickEndAngle))
    
    return (x: x, width: width)
}

struct CursorWheel: View {
    @State private var dragDistanceSaved: CGFloat = 0
    @State private var dragDistanceUpdating: CGFloat = 0
    @State private var dragStepRecord: Int = 0
    
    var shiftCursorFunc: (Int, Bool) -> ()
    
    var width: CGFloat = 200
    var height: CGFloat = 60
    var borderGap: CGFloat = 6
    
    var numOfTicks: Int = 12
    var gapRatio: CGFloat = 0.3
    var theta: CGFloat = 2.2
    
    func innerW() -> CGFloat {
        return self.width - self.borderGap * 2
    }
    
    func innerH() -> CGFloat {
        return self.height - self.borderGap * 2
    }
    
    func actualMoveDistance() -> (distance: CGFloat, step: Int) {
        let radius: CGFloat = innerW() / 2.0 / sin(self.theta / 2.0)
        let wholeAngle: CGFloat = self.theta / (CGFloat(self.numOfTicks) - self.gapRatio)
        let range = radius * wholeAngle
        var dist = self.dragDistanceSaved + self.dragDistanceUpdating
        var n = 0
        
        while(dist > range / 2.0){
            dist -= range
            n += 1
        }
        
        while(dist < -range / 2.0){
            dist += range
            n -= 1
        }
        return (distance: dist, step: n)
    }
    
    var body: some View {
        ZStack {
            ZStack {
                ForEach((-1)..<(self.numOfTicks + 1), id: \.self) { n in
                    let params = tickParams(tickIndex: n,
                                         dragDist: self.actualMoveDistance().distance,
                                         numOfTicks: self.numOfTicks,
                                         length: self.innerW(),
                                         gapRatio: self.gapRatio,
                                         theta: self.theta)
                    VStack {
                    }
                    .frame(width: params.width, height: self.innerH())
                    .background(
                        RoundedRectangle(
                            cornerRadius: 3,
                            style: .continuous
                        )
//                        .fill(Color(white: 0.83 - 0.23 * abs(params.x - innerW()/2) / (innerW()/2)))
                        .fill(Color("AccentKeys2"))
                    )
                    .position(CGPoint(x: params.x, y: self.innerH() / 2))
                }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
            )
            .frame(width: self.innerW(), height: self.innerH())
//            .onTapGesture { location in
//                if (location.x < self.width / 3.0) {
//                    self.shiftCursorFunc(-1)
//                    print("L")
//                } else if (location.x > self.width / 3.0 * 2.0) {
//                    self.shiftCursorFunc(1)
//                    print("R")
//                }
//            }
            .gesture(
                DragGesture(minimumDistance: 0).onChanged { value in
                    self.dragDistanceUpdating = value.translation.width
                    let step = actualMoveDistance().step
                    
                    if(self.dragStepRecord != step){
                        self.dragStepRecord > step ? self.shiftCursorFunc(-1, true) : self.shiftCursorFunc(1, true)
                        self.dragStepRecord = step
                    }
                }.onEnded { value in
                    self.dragDistanceUpdating = 0
                    self.dragDistanceSaved += value.translation.width
                }
                
            )
            
            
//            HStack {
//                Button (action: { self.shiftCursorFunc(-1) }) {
//                    Text("").frame(width: self.width / 3.0, height: self.height).border(.black)
//                }
//                
//                Spacer()
//                
//                Button (action: { self.shiftCursorFunc(1) }) {
//                    Text("").frame(width: self.width / 3.0, height: self.height).border(.black)
//                }
//            }
            
        }
        .frame(width: self.width, height: self.height)
        .background(
            RoundedRectangle(
                cornerRadius: 10,
                style: .continuous
            )
            .fill(Color("AccentKeys1"))
        )
        
        
    }
}

struct CursorWheel_Previews: PreviewProvider {
    static var previews: some View {
        CursorWheel(shiftCursorFunc: {i, b in})
    }
}
