//
//  ClearAllSwitch.swift
//  One
//
//  Created by Tingwu on 2023/9/13.
//
//

import SwiftUI

struct ClearSwitch: View {
    
    var action: () -> ()

    @GestureState var gestureState: (switchOn: Bool, moveHeight: CGFloat) = (false, 0)
    @State var tapAnimHeight: CGFloat = 0
    @State var backColor = "AccentKeys2"
    @State var pullTime: Date = Date()
    
//    var switchW: CGFloat = 100
//    var switchH: CGFloat = 150
    var innerH: CGFloat = 38
    var gap: CGFloat = 6
    
    func limit(_ switchH: CGFloat) -> CGFloat{
        return switchH - gap * 2 - innerH
    }
    
    let hapticManager = HapticManager.instance

    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack {
                    Image(systemName: "trash")
                        .foregroundColor(.primary)
                        .font(.system(size: 23))
                }
                .frame(maxWidth: .infinity, minHeight: innerH)
                .background(
                    RoundedRectangle(
                        cornerRadius: 5,
                        style: .continuous
                    )
                    .fill(Color("AccentKeys1"))
                    .shadow(radius: 5)
                )
                .padding(gap)
                .onTapGesture { location in
                    withAnimation(.easeOut(duration: 0.15).delay(0)) { tapAnimHeight = 15 }
                    withAnimation(.easeIn(duration: 0.15).delay(0.15)) { tapAnimHeight = 0 }
                }
                .offset(y: gestureState.switchOn ? limit(proxy.size.height) : 0)
                .offset(y: tapAnimHeight)
                .gesture(
                    DragGesture().updating($gestureState) { (value, state, transaction) in
                        state.moveHeight = value.translation.height
                        if (state.moveHeight >= limit(proxy.size.height) && !state.switchOn) {
                            state.switchOn = true
                        } else if (state.moveHeight <= limit(proxy.size.height) && state.switchOn) {
                            state.switchOn = false
                        }
                    }
                )
                .onChange(of: gestureState.switchOn, perform: { on in
                    if on {
                        backColor = "AccentRed"
                        hapticManager.impact(style: .soft)
                        pullTime = Date()
                    } else {
                        backColor = "AccentKeys2"
                        if(gestureState.moveHeight != 0 || -pullTime.timeIntervalSinceNow < 0.1) {
                            hapticManager.impact(style: .soft)
                        } else {
                            hapticManager.notification(type: .success)
                            action()
                        }
                    }
                })
                .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: gestureState.switchOn)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(
                    Color(backColor)
                        .shadow(.inner(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 0))
                )
            )
            .animation(.easeInOut(duration: 0.15), value: backColor)
        }
    }
}

struct ClearSwitch_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ClearSwitch(action: {})
        }
        .frame(width: 100, height: 150)
    }
}
