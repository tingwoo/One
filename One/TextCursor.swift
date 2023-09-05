//
//  TextCursor.swift
//  One
//
//  Created by Tingwu on 2023/9/21.
//

import SwiftUI

struct TextCursor: View {
    @State private var isOn = false
    
    var body: some View {
        Text("")
            .frame(width: 2, height: 25)
            .border(.blue, width: 2)
            .opacity(isOn ? 0.0 : 1.0) // Toggle text opacity
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    self.isOn.toggle()
                }
            }
    }
}

#Preview {
    TextCursor()
}
