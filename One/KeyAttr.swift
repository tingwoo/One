//
//  KeyAttr.swift
//  One
//
//  Created by Tingwu on 2023/9/12.
//

import Foundation

struct KeyAttr {
    
    var text: String? = nil
    var image: String? = nil
    var command: [Element]
    var segments: [Int] = []
    var cursorShift: Int = 1
}
