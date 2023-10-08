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
            Key(action: {}, width: keyW(1), height: keyH) {
                Image(systemName: "rectangle.grid.2x2")
                    .font(.system(size: 25))
            } shape: {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
            }
            
            Key(action: {shiftCursorFunc(-1)}, width: keyW(1), height: keyH) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
            } shape: {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
            }
            
            Key(action: {shiftCursorFunc(1)}, width: keyW(1), height: keyH) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 25))
            } shape: {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
            }
            
            CursorWheel(shiftCursorFunc: shiftCursorFunc, width: keyW(3), height: keyH)
        }
    }
}

struct ControlBar_Previews: PreviewProvider {
    static var previews: some View {
        ControlBar(shiftCursorFunc: {i in}, keyW: {i in i * 55}, keyH: 50, keySpacing: 8)
    }
}
