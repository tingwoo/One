//
//  Key.swift
//  One
//
//  Created by Tingwu on 2023/10/8.
//

import SwiftUI

struct Key<Content: View, Background: Shape>: View {
    @State private var pressed = false
    
    var action: () -> () = {}
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var color: Color = Color("AccentKeys1")
    var pressedColor: Color = .primary
    
    @ViewBuilder let content: Content
    @ViewBuilder let shape: Background
    
    var body: some View {
        ZStack {
            shape
                .fill(color)
            content
            shape
                .fill(pressedColor)
                .opacity(pressed ? 0.2 : 0)
        }
        .frame(width: width, height: height)
        .onTapGesture {
            action()
        }
        .onLongPressGesture(minimumDuration: .infinity) {
            pressed.toggle()
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
