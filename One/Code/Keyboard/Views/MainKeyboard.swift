//
//  MainKeyboard.swift
//  One
//
//  Created by Tingwu on 2023/10/19.
//

import SwiftUI

struct MainKeyboard: View {
    var selection: Int = 0

    var typeIn: (Int) -> () = {i in}
    var keySpacing: CGFloat = 8.0
    var keyH: CGFloat = 45
    var keyW: CGFloat = 60

    var body: some View {
//        Grid(horizontalSpacing: keySpacing, verticalSpacing: keySpacing) {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(keyboardLayout[selection].indices, id: \.self) { row in
                GridRow {
                    ForEach(keyboardLayout[selection][row].indices, id: \.self) { item in
                        KeyWithMenu(
                            typeIn: typeIn,
                            gap: keySpacing,
                            keyW: keyW,
                            keyH: keyH,
                            cornerRadius: 10,
                            main: keyboardLayout[selection][row][item].main,
                            optionsL: keyboardLayout[selection][row][item].optionsL,
                            optionsR: keyboardLayout[selection][row][item].optionsR
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    MainKeyboard()
}

