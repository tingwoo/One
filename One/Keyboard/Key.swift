//
//  Key.swift
//  One
//
//  Created by Tingwu on 2023/9/9.
//

import SwiftUI

struct Key: View {
//    
//    @Binding var formula: [String]
    
    var insertFunc: (_: Int) -> ()
    
    var width: CGFloat = 50.0
    var height: CGFloat = 50.0
    var attr: KeyAttr = KeyAttr()
    var keyID: Int = 0
    var background: Color = Color("AccentKeys1")
    
    
    var body: some View {
        
        Button(
            action: { self.insertFunc(self.keyID) }
        ) {
            if(attr.text != nil) {
                Text(attr.text!)
                    .font(.system(size: 25))
                    .frame(width: width, height: height)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 10,
                            style: .continuous
                        )
                        .fill(background)
                    )
                    .foregroundColor(.primary)
            } else {
                Image(systemName: attr.image!)
                    .font(.system(size: 25))
                    .frame(width: width, height: height)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 10,
                            style: .continuous
                        )
                        .fill(background)
                    )
                    .foregroundColor(.primary)
            }
        }
    }
}

struct Key_Previews: PreviewProvider {
    static var previews: some View {
        Key(insertFunc: {i in})
    }
}
