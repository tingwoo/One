//
//  ControlBar.swift
//  One
//
//  Created by Tingwu on 2023/9/17.
//

import SwiftUI

struct ControlBar: View {

    @AppStorage("rightHanded") private var rightHanded = 1

    var shiftCursorFunc: (Int, Bool) -> ()
    var keyW: (CGFloat) -> CGFloat
    var keyH: CGFloat
    var keySpacing: CGFloat
    var background: Color = Color("AccentKeys1")

    let hapticManager = HapticManager.instance

    var body: some View {
        HStack(spacing: keySpacing) {
            if rightHanded == 1 {
                moreKeysButton(keyW: keyW(1), keyH: keyH)
            } else {
                CursorWheel(shiftCursorFunc: shiftCursorFunc, width: keyW(3), height: keyH)
            }

            Key(action: {shiftCursorFunc(-1, true)}, width: keyW(1), height: keyH) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
            } shape: {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
            }
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.5)
                    .onEnded { _ in
                        hapticManager.impact(style: .medium)
                        // TODO: to front
                    }
            )

            Key(action: {shiftCursorFunc(1, true)}, width: keyW(1), height: keyH) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 25))
            } shape: {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
            }
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.5)
                    .onEnded { _ in
                        hapticManager.impact(style: .medium)
                        // TODO: to end
                    }
            )

            if rightHanded == 1 {
                CursorWheel(shiftCursorFunc: shiftCursorFunc, width: keyW(3), height: keyH)
            } else {
                moreKeysButton(keyW: keyW(1), keyH: keyH)
            }
        }
    }

    private struct moreKeysButton: View {
        var keyW: CGFloat
        var keyH: CGFloat

        var body: some View {
            Key(action: {}, width: keyW, height: keyH) {
                Image(systemName: "rectangle.grid.2x2")
                    .font(.system(size: 25))
            } shape: {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
            }
        }
    }
}

struct ControlBar_Previews: PreviewProvider {
    static var previews: some View {
        ControlBar(shiftCursorFunc: {i, b in}, keyW: {i in i * 55}, keyH: 50, keySpacing: 8)
    }
}

