//
//  ControlBar.swift
//  One
//
//  Created by Tingwu on 2023/9/17.
//

import SwiftUI

struct ControlBar: View {
    
    var shiftCursorFunc: (Int) -> ()
    var keyW: (CGFloat) -> CGFloat
    var keyH: CGFloat
    var keySpacing: CGFloat
    var background: Color = Color("AccentKeys1")
    
    var body: some View {
        HStack(spacing: keySpacing) {
            Key(action: {shiftCursorFunc(-1)}, image: "chevron.left", width: keyW(1), height: keyH, color: background, textColor: .primary)
            Key(action: {shiftCursorFunc(1)}, image: "chevron.right", width: keyW(1), height: keyH, color: background, textColor: .primary)
            CursorWheel(shiftCursorFunc: shiftCursorFunc, width: keyW(3), height: keyH)
        }
    }
}

struct ControlBar_Previews: PreviewProvider {
    static var previews: some View {
        ControlBar(shiftCursorFunc: {i in}, keyW: {i in i * 70}, keyH: 50, keySpacing: 8)
    }
}
