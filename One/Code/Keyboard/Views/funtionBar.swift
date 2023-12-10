//
//  funtionBar.swift
//  One
//
//  Created by Tingwu on 2023/10/8.
//

import SwiftUI

struct funtionBar: View {

    @Binding var keyboardSelection: Int

    var keyboardCount: Int = 3
    var clearAction: () -> ()
    var height: CGFloat = 40
    var moduleWidth: CGFloat = 90

    var moduleGap: CGFloat { moduleWidth - 2 * height}

    var body: some View {
        HStack(spacing: moduleGap * 1.5) {
            HStack {
                Key(action: {}, color: Color("AccentKeys1")) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 20, weight: .medium))
                } shape: { Circle() }

                Spacer()

                Key(action: {}, color: Color("AccentKeys1")) {
                    Image(systemName: "clock")
                        .font(.system(size: 20, weight: .medium))
                } shape: { Circle() }
            }
            .frame(width: moduleWidth, height: height)


            KeyboardPicker(
                selection: $keyboardSelection,
                numOfSegments: keyboardCount,
//                width: 170,
                touchAreaH: height,
                spacing: 7.0
            )


            ClearSwitch(action: clearAction)
                .frame(width: moduleWidth, height: height)
        }
//        .padding(3)
//        .background(Capsule()
//            .fill(Color("AccentInputField")
//                .shadow(.inner(color: Color(white: 0, opacity: 0.2), radius: 2))
//            )
//        )
    }
}

#Preview {
    funtionBar(keyboardSelection: .constant(0), clearAction: {})
        .environmentObject(InputFieldViewModel())
}

