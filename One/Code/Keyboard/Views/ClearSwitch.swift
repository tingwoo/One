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

    @GestureState var gestureState: (switchOn: Bool, moveWidth: CGFloat) = (false, 0)
    @State var tapAnimDist: CGFloat = 0
    @State var backColor = "AccentKeys2"
    @State var pullTime: Date = Date()

    @EnvironmentObject var inputFieldViewModel: InputFieldViewModel

//    var switchW: CGFloat = 100
//    var switchH: CGFloat = 150
//    var innerH: CGFloat = 38
    var gap: CGFloat = 0

    func limit(_ proxy: GeometryProxy) -> CGFloat{
        return (proxy.size.width - proxy.size.height) / 2.0
    }

    let hapticManager = HapticManager.instance

    var body: some View {
        GeometryReader { proxy in
            HStack {
                VStack {
                    Image(systemName: "trash")
                        .foregroundColor(.primary)
                        .font(.system(size: 20, weight: .medium))
                }
                .frame(width: proxy.size.height - gap * 2, height: proxy.size.height - gap * 2)
                .background(
                    Circle()
                        .fill(Color("AccentKeys1"))
                        .shadow(radius: 1)
                )
                .padding(gap)
                .onTapGesture { location in
                    withAnimation(.easeOut(duration: 0.15).delay(0)) { tapAnimDist = 15 }
                    withAnimation(.easeIn(duration: 0.15).delay(0.15)) { tapAnimDist = 0 }
                }
                .offset(x: gestureState.switchOn ? limit(proxy) * 2 : 0)
                .offset(x: tapAnimDist)
                .gesture(
                    DragGesture().updating($gestureState) { (value, state, transaction) in
                        state.moveWidth = value.translation.width
                        if (state.moveWidth >= limit(proxy) && !state.switchOn) {
                            state.switchOn = true
                        } else if (state.moveWidth <= limit(proxy) && state.switchOn) {
                            state.switchOn = false
                        }
                    }
                )
                .onChange(of: gestureState.switchOn, perform: { on in
                    if on {
                        backColor = "AccentRed"
                        hapticManager.impact(style: .soft)
                        pullTime = Date()
                        inputFieldViewModel.showRedBorder(true)
                    } else {
                        backColor = "AccentKeys2"
                        if(gestureState.moveWidth != 0 || -pullTime.timeIntervalSinceNow < 0.1) {
                            hapticManager.impact(style: .soft)
                        } else {
                            hapticManager.notification(type: .success)
                            action()
                            inputFieldViewModel.showAnswerField(false)
                        }
                        inputFieldViewModel.showRedBorder(false)
                    }
                })
                .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: gestureState.switchOn)
//                .animation(.easeInOut(duration: 0.5), value: gestureState.switchOn)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
//                .fill(
//                    Color(backColor)
//                        .shadow(.inner(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 0))
//                )
//            )
            .background(Capsule()
                .fill(
                    Color(backColor)
                        .shadow(.inner(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 0))
                ))
            .animation(.easeInOut(duration: 0.15), value: backColor)
        }
    }
}

struct ClearSwitch_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ClearSwitch(action: {})
        }
        .frame(width: 200, height: 80)
        .environmentObject(InputFieldViewModel())
    }
}

