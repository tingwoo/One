//
//  BackspaceKey.swift
//  One
//
//  Created by Tingwu on 2023/9/17.
//

import SwiftUI

struct BackspaceKey: View {
    
    var backspaceFunc: () -> ()
    var width: CGFloat = 50.0
    var height: CGFloat = 50.0
    var background: Color = Color("AccentKeys2")
    
    var body: some View {
        Button(
            action: { /*backspaceFunc()*/ }
        ) {
            Image(systemName: "delete.left")
                .font(.system(size: 25))
                .frame(width: width, height: height)
                .background(
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                    .fill(background)
                )
                .foregroundColor(.primary)
        }
    }
}

struct BackspaceKey_Previews: PreviewProvider {
    static var previews: some View {
        BackspaceKey(backspaceFunc: {})
    }
}
