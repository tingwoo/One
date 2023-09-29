//
//  ClearAllSwitch.swift
//  One
//
//  Created by Tingwu on 2023/9/13.
//
//  https://stackoverflow.com/questions/62268937/swiftui-how-to-change-the-speed-of-drag-based-on-distance-already-dragged

import SwiftUI

struct ClearAllSwitch: View {
    
    var action: () -> ()

    @State var moveHeight = CGSize.zero
    @State var switchOn = false
    @State var backColor = "AccentKeys2"
    @State var pullTime: Date = Date()
    
    var switchW: CGFloat = 100
    var switchH: CGFloat = 150
    var innerH: CGFloat = 38
    var gap: CGFloat = 6
    
    func limit() -> CGFloat{
        return switchH - gap * 2 - innerH
    }
    
    let hapticManager = HapticManager.instance

    var body: some View {
        VStack {
            VStack {
                Image(systemName: "trash")
                    .foregroundColor(.primary)
                    .font(.system(size: 23))
            }
            .frame(width: switchW - 2 * gap, height: innerH)
            .onTapGesture { location in
                withAnimation(.easeOut(duration: 0.15).delay(0)) {
                    moveHeight = CGSize(width: 0, height: 15)
                }
                
                withAnimation(.easeIn(duration: 0.15).delay(0.15)) {
                    moveHeight = CGSize(width: 0, height: 0)
                }
            }
            .background(
                RoundedRectangle(
                    cornerRadius: 5,
                    style: .continuous
                )
                .fill(Color("AccentKeys1"))
                .shadow(radius: 5)
            )
            .padding(.top, gap)
            .offset(y: moveHeight.height)
            .gesture(
                DragGesture().onChanged { value in
                    let dragHeight = value.translation.height >= 0 ? value.translation.height : 0
                    self.moveHeight = CGSize(width: 0, height: dragHeight >= self.limit() ? self.limit() : 0)
                    
                    if (dragHeight >= self.limit() && backColor == "AccentKeys2") {
                        switchOn = true
                        moveHeight = CGSize(width: 0, height: self.limit())
                        backColor = "AccentRed"
                        hapticManager.impact(style: .soft)
                        pullTime = Date()
                    } else if (dragHeight <= self.limit() && backColor == "AccentRed") {
                        switchOn = false
                        moveHeight = CGSize(width: 0, height: 0)
                        backColor = "AccentKeys2"
                        hapticManager.impact(style: .soft)
                    }
                }
                .onEnded { value in
                    let dragHeight = value.translation.height >= 0 ? value.translation.height : 0
                    if (dragHeight >= self.limit() && -pullTime.timeIntervalSinceNow > 0.1) {
//                        print("Cleared!")
                        action()
                        hapticManager.notification(type: .success)
                        
//                        print("Elapsed time: \(pullTime.timeIntervalSinceNow) seconds")
                    } else {
//                        print("Not cleared.")
                    }
                    switchOn = false
                    self.moveHeight = .zero
                    self.backColor = "AccentKeys2"

                }
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: switchOn)
            
            Spacer()
        }
        .frame(width: switchW, height: switchH)
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(
                Color(backColor)
                    .shadow(.inner(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 0))
            )
        )
        .animation(.easeInOut(duration: 0.15), value: backColor)
        

    }
}

struct ClearAllSwitch_Previews: PreviewProvider {
    static var previews: some View {
        ClearAllSwitch(action: {})
    }
}
