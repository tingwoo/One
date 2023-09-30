//
//  KeyboardPicker.swift
//  One
//
//  Created by Tingwu on 2023/9/30.
//

import SwiftUI

struct KeyboardPicker: View {
    @Binding var selection: Int
    
    var numOfSegments: Int = 4
    var height: CGFloat = 15.0
    var keySpacing: CGFloat = 8.0
    var bgNormal: Color = Color("AccentKeys1")
    var bgHighlight: Color = Color("AccentKeys2")
    
    var body: some View {
        HStack (spacing: keySpacing) {
            ForEach(0..<numOfSegments, id: \.self) { i in
                (selection == i ? bgHighlight : bgNormal)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 3,
                            style: .continuous
                        )
                    )
//                    .overlay{
//                        Rectangle()
//                            .fill(Color("AccentYellow"))
//                            .opacity(0.1)
//                            .frame(height: height * 3)
//                    }
                    .onTapGesture { selection = i }
                    .animation(.easeInOut(duration: 0.1), value: selection)
            }
        }
        .clipShape(
            RoundedRectangle(
                cornerRadius: 10,
                style: .continuous
            )
        )
        .frame(height: height)
    }
}

#Preview {
    KeyboardPicker(selection: .constant(0))
}
