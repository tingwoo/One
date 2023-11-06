//
//  InputFieldLooks.swift
//  One
//
//  Created by Tingwu on 2023/10/17.
//

import Foundation
import SwiftUI

class InputFieldLooks: ObservableObject {
    @Published var redBorder: Bool = false
    @Published var answerFieldExists: Bool = false
    @Published var answerFieldAppears: Bool = false
    @Published var answerFieldRotateAxis: (x: CGFloat, y: CGFloat, z: CGFloat) = (x: 0, y: 0, z: 0)
    @Published var answerFieldRotateX: CGFloat = 0
    @Published var answerFieldRotateAngle: CGFloat = 0
    
    func showRedBorder(_ show: Bool){
        withAnimation(.spring(duration: 0.2, bounce: 0.5)) {
            redBorder = show
        }
    }
    
    func showAnswerField(_ show: Bool){
        if(answerFieldExists != show){
            if(!answerFieldExists) {
                answerFieldExists = true
                withAnimation(.bouncy) {
                    answerFieldAppears = true
                }
            } else {
                withAnimation(.bouncy) {
                    answerFieldAppears = false
                }
                withAnimation(.default.delay(1)) {
                    answerFieldExists = false
                }
            }
        }
    }
    
    func bounceAnswerField() {
        withAnimation(.easeOut(duration: 0.12)) {
            answerFieldRotateAngle = 5
        }
        
        withAnimation(.easeIn(duration: 0.12).delay(0.12)) {
            answerFieldRotateAngle = 0
        }
    }
}
