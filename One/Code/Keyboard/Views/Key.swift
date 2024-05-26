//
//  Key.swift
//  One
//
//  Created by Tingwu on 2023/10/8.
//

import SwiftUI

struct Key<Content: View, Background: Shape>: View {
    @State private var pressed = false
    @Environment(\.colorScheme) var colorScheme

    var action: () -> () = {}
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var color: Color = Color("AccentKeys1")
    var darkAdjust: CGFloat = 0.06
    var defaultAdjust: CGFloat = -0.06
//    var pressedColor: Color = .primary

    @ViewBuilder let content: Content
    @ViewBuilder let shape: Background

    var body: some View {
        ZStack {
            shape
                .fill(color)
            content
        }
        .frame(width: width, height: height)
        .brightness(pressed ? (colorScheme == .dark ? darkAdjust : defaultAdjust) : 0)
        .onTapGesture {
            action()
        }
        .onLongPressGesture(minimumDuration: .infinity) {
//            pressed.toggle()
        } onPressingChanged: { bool in
            if bool { pressed = bool }
            else { withAnimation(.easeOut(duration: 0.15)) { pressed = bool } }
        }
    }
}

#Preview {
    Key(action: {}, width: 50, height: 50) {
        Text("Hi")
    } shape: {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
    }
}

