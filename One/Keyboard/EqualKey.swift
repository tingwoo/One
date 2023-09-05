//
//  EqualKey.swift
//  One
//
//  Created by Tingwu on 2023/9/17.
//

import SwiftUI

struct EqualKey: View {
    var width: CGFloat = 50.0
    var height: CGFloat = 50.0
    var background: Color = Color("AccentYellow")
    
    var body: some View {
        Button(
            action: { }
        ) {
            Image(systemName: "equal")
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

struct EqualKey_Previews: PreviewProvider {
    static var previews: some View {
        EqualKey()
    }
}
