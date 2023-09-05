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
    var command: [String]
    var cursorShift: Int = 0
    
    init() {
        self.text = ""
        self.command = []
    }
    
    init(text: String, command: [String]) {
        self.text = text
        self.command = command
    }
    
    init(image: String, command: [String]) {
        self.image = image
        self.command = command
    }
    
    // If command is not provided, use the input string as command
    init(text: String) {
        self.text = text
        self.command = [text]
    }
    
    init(image: String) {
        self.image = image
        self.command = [image]
    }
}
