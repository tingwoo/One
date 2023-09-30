//
//  ControlBar.swift
//  One
//
//  Created by Tingwu on 2023/9/17.
//

import SwiftUI

struct ControlBar: View {
    
    var shiftCursorFunc: (Int) -> ()
    var keyHeight: CGFloat
    var keySpacing: CGFloat
    var background: Color = Color("AccentKeys1")
    
    func keyW(_ cnt: CGFloat = 1.0) -> CGFloat {
        return ((UIScreen.main.bounds.width - keySpacing * 6) / 5) * cnt + keySpacing * (cnt - 1)
    }
    
    var body: some View {
        HStack(spacing: keySpacing) {
            Key(action: {}, image: "gearshape", width: keyW(), height: keyHeight, color: background, textColor: .primary)
            Key(action: {}, image: "clock", width: keyW(), height: keyHeight, color: background, textColor: .primary)
            CursorWheel(shiftCursorFunc: self.shiftCursorFunc, width: keyW(3), height: keyHeight)
        }
    }
}

struct ControlBar_Previews: PreviewProvider {
    static var previews: some View {
        ControlBar(shiftCursorFunc: {i in}, keyHeight: 45, keySpacing: 8)
    }
}
