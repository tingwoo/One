//
//  FormulaModels.swift
//  One
//
//  Created by Tingwu on 2023/9/28.
//

import Foundation

struct ElementWithID: Identifiable {
    var id: Int? = nil
    var pair: Int? = nil
    var partners: [Int?]? = nil
    var element: Element
}

struct ElementDisplay: Equatable {
    var index: Int
    var element: Element
    var pos: CGPoint = CGPoint()
    var scale: CGFloat = 1
    var params: [CGFloat]? = nil
}
