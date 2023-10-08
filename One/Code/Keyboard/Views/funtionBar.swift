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
    var width: CGFloat = 95
    
    var body: some View {
        HStack {
            HStack {
                
                ZStack {
                    Circle()
                        .fill(Color("AccentKeys1"))
                    Image(systemName: "gearshape")
                        .font(.system(size: 20, weight: .medium))
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color("AccentKeys1"))
                    Image(systemName: "clock")
                        .font(.system(size: 20, weight: .medium))
                }
            }
            .frame(width: width, height: height)
//            .border(.black)
            
            Spacer()
            
            ClearSwitch(action: clearAction)
                .frame(width: width, height: height)
//                .border(.black)

        }
    }
}

#Preview {
    funtionBar(clearAction: {})
}
