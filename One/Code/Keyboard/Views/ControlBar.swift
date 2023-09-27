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
            Button(
                action: {
                    
                }
            ) {
                Image(systemName: "gearshape")
                    .font(.system(size: 25))
                    .frame(width: keyW(), height: keyHeight)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 10,
                            style: .continuous
                        )
                        .fill(background)
                    )
                    .foregroundColor(.primary)
            }
            
            Button(
                action: {
                    
                }
            ) {
                Image(systemName: "clock")
                    .font(.system(size: 25))
                    .frame(width: keyW(), height: keyHeight)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 10,
                            style: .continuous
                        )
                        .fill(background)
                    )
                    .foregroundColor(.primary)
            }
            
            CursorWheel(shiftCursorFunc: self.shiftCursorFunc, width: keyW(3), height: keyHeight)
        }
    }
}

struct ControlBar_Previews: PreviewProvider {
    static var previews: some View {
        ControlBar(shiftCursorFunc: {i in}, keyHeight: 45, keySpacing: 8)
    }
}
