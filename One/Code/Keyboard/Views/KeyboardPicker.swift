
//  KeyboardPicker.swift
//  One
//
//  Created by Tingwu on 2023/9/30.
//

import SwiftUI

struct KeyboardPicker: View {
    @Binding var selection: Int
    @Environment(\.colorScheme) var colorScheme

    var numOfSegments: Int = 4
//    var width: CGFloat = 200.0
    var touchAreaH: CGFloat = 40.0
    var spacing: CGFloat = 10.0
    var bgNormal: Color = Color("AccentKeys1")
    var bgHighlight: Color = Color("AccentYellow")

//    var segmentW: CGFloat { (width - spacing * CGFloat(numOfSegments - 1)) / CGFloat(numOfSegments) }

    let hapticManager = HapticManager.instance

    var body: some View {
        HStack (spacing: spacing) {
            ForEach(0..<numOfSegments, id: \.self) { i in
                ZStack {
                    Color("AccentInputField")
                        .frame(height: touchAreaH)

                    (selection == i ? bgHighlight : bgNormal)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 4,
                                style: .continuous
                            )
                        )
                        .shadow(color: (selection == i && colorScheme == .dark) ? Color("AccentYellow") : .clear, radius: 3)
                        .frame(height: touchAreaH / 4.0)
                        .animation(.easeInOut(duration: 0.1), value: selection)
                }
                .onTapGesture {
                    if(selection != i) {
                        selection = i
                        hapticManager.wheel()
                    }

                }
//                .border(.gray)
            }
        }
//        .clipShape(
//            RoundedRectangle(
//                cornerRadius: 10,
//                style: .continuous
//            )
//        )
    }
}

#Preview {
    KeyboardPicker(selection: .constant(0))
}

