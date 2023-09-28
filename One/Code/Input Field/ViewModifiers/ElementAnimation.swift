//
//  ElementAnimation.swift
//  One
//
//  Created by Tingwu on 2023/9/28.
//

import Foundation
import SwiftUI

struct ElementAnimation<T: Equatable>: ViewModifier {
    var value: T
    
    func body(content: Content) -> some View {
        content
            .animation(.easeOut(duration: 0.1), value: value)
    }
}
