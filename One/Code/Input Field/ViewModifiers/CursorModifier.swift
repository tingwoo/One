//
//  CursorModifier.swift
//  One
//
//  Created by Tingwu on 2023/9/28.
//

import Foundation
import SwiftUI

struct CursorModifier: ViewModifier {
    @State private var isOn: Bool
    var show: Bool
    var scale: CGFloat
    
    init(show: Bool, scale: CGFloat) {
        self.isOn = true
        self.show = show
        self.scale = scale
    }
    
    func body(content: Content) -> some View {
        if(show) {
            content
                .overlay(
                    Rectangle()
                        .frame(width: 2, height: 25 * scale, alignment: .leading)
                        .foregroundColor(Color.blue)
                        .offset(x: -1, y: 0)
                        .opacity(isOn ? 1.0 : 0.0)
                        .onAppear {
                            self.isOn = true
                            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                self.isOn.toggle()
                            }
                        },
                    alignment: .leading
                )
        }else{
            content
        }
    }
}
