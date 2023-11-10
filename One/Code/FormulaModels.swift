//
//  FormulaModels.swift
//  One
//
//  Created by Tingwu on 2023/9/28.
//

import Foundation

struct ElementWithID: Identifiable {
    var id: Int? = nil
    var element: Element
}

struct ElementDisplay: Equatable {
    var index: Int
    var element: Element
    var pos: CGPoint
    var scale: CGFloat
    var params: [CGFloat] = []
}
