//
//  ElementModelProperties.swift
//  One
//
//  Created by Tingwu on 2023/10/9.
//

import Foundation

enum ElementType {
    case character
    case symbol
    case func_start
    case func_end
    case placeholder
    case other
}

struct ExpressionDim {
    var width: CGFloat
    var height: CGFloat
    var minY: CGFloat
    var maxY: CGFloat
    
    init(width: CGFloat, height: CGFloat, minY: CGFloat, maxY: CGFloat) {
        self.width = max(0, width)
        self.height = max(0, height)
        self.minY = min(minY, maxY)
        self.maxY = max(minY, maxY)
    }
    
    init(width: CGFloat, height: CGFloat) {
        self.width = max(0, width)
        self.height = max(0, height)
        self.minY = -self.height / 2.0
        self.maxY = self.height / 2.0
    }
    
    init() {
        self.width = 0
        self.height = 0
        self.minY = 0
        self.maxY = 0
    }
    
    func halfWidth() -> CGFloat {
        return width / 2.0
    }
}
