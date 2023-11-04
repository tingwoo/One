//
//  TapModifier.swift
//  One
//
//  Created by Tingwu on 2023/11/5.
//

import Foundation
import SwiftUI

extension FormulaView {
    struct TapModifier: ViewModifier {
        var index: Int
        var dimension: ExpressionDim
        var scale: CGFloat
        var updateCursor: (Int) -> ()
        
        func body(content: Content) -> some View {
            content
                .overlay(
                    HStack(spacing: 0) {
                        Color.clear
                            .contentShape(Rectangle())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onTapGesture {
                                updateCursor(index)
                            }
                        
                        Color.clear
                            .contentShape(Rectangle())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onTapGesture {
                                updateCursor(index + 1)
                            }
                    }
                        .frame(width: dimension.width * scale, height: dimension.height * scale)
//                        .opacity(0.1)
//                        .hidden()
                )
        }
    }
}
