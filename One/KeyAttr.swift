//
//  KeyAttr.swift
//  One
//
//  Created by Tingwu on 2023/9/12.
//

import Foundation

struct KeyAttr {
    var text: String?
    var image: String?
    var customImage: String?
    var command: [Element]
    var pairList: [Int?] = []
    var cursorShift: Int = 1
}
