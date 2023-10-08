//
//  Key.swift
//  One
//
//  Created by Tingwu on 2023/9/9.
//

import SwiftUI

struct Key: View {
    
    var action: () -> () = {}
    var text: String? = nil
    var image: String? = nil
    var width: CGFloat = 50.0
    var height: CGFloat = 50.0
    var color: Color = Color("AccentKeys1")
    var textColor: Color = .primary
    
    func modifier () -> KeyModifier {
        return KeyModifier(width: self.width, height: self.height, color: self.color, textColor: self.textColor)
    }
    
    var body: some View {
        Button(action: self.action) {
            if let text = self.text {
                Text(text)
                    .modifier(self.modifier())
            } else if let image = self.image {
                Image(systemName: image)
                    .modifier(self.modifier())
            } else {
                Text("")
                    .modifier(self.modifier())
            }
        }
    }
}

struct Key_Previews: PreviewProvider {
    static var previews: some View {
        Key()
    }
}
