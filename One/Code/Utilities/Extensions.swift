//
//  Extensions.swift
//  One
//
//  Created by Tingwu on 2023/10/12.
//

import Foundation

extension CGPoint {
    public static func +(lhs:CGPoint,rhs:CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func +=(lhs:inout CGPoint, rhs:CGPoint) {
        lhs = lhs + rhs
    }
}
