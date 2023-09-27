//
//  KeyModifier.swift
//  One
//
//  Created by Tingwu on 2023/9/27.
//

import Foundation
import SwiftUI

struct KeyModifier: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    var color: Color
    var textColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .frame(width: self.width, height: self.height)
            .background(
                RoundedRectangle(
                    cornerRadius: 10,
                    style: .continuous
                )
                .fill(self.color)
            )
            .foregroundColor(self.textColor)
    }
}
