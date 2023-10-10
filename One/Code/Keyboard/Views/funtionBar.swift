//
//  funtionBar.swift
//  One
//
//  Created by Tingwu on 2023/10/8.
//

import SwiftUI

struct funtionBar: View {
    
    var clearAction: () -> ()
    var height: CGFloat = 40
    var moduleWidth: CGFloat = 90
    
    var body: some View {
        HStack {
            HStack {
                Key(action: {}, color: Color("AccentKeys1")) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 20, weight: .medium))
                } shape: { Circle() }
                
                Spacer()
                
                Key(action: {}, color: Color("AccentKeys1")) {
                    Image(systemName: "clock")
                        .font(.system(size: 20, weight: .medium))
                } shape: { Circle() }
            }
            .frame(width: moduleWidth, height: height)
            
            Spacer()
            
            ClearSwitch(action: clearAction)
                .frame(width: moduleWidth, height: height)
        }
    }
}

#Preview {
    funtionBar(clearAction: {})
}
