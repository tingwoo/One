//
//  InputFieldViewModel.swift
//  One
//
//  Created by Tingwu on 2023/10/17.
//

import Foundation
import SwiftUI

class InputFieldViewModel: ObservableObject {
    @Published var redBorder: Bool = false
    @Published var answerFieldExists: Bool = false
    @Published var answerFieldRotateAngle: CGFloat = 0
    @Published var answerFieldContent: String = ""
    @Published var answerFieldStatus: Status = .answer


    func setRedBorder(_ show: Bool){
        redBorder = show
    }

    func setAnswerFieldExistence(_ show: Bool){
        if answerFieldExists && show {
            bounceAnswerField()
        }
        answerFieldExists = show
    }

    func setAnswerFieldContent(_ content: String){
        answerFieldContent = content
    }

    func setAnswerFieldStatus(_ stat: Status){
        answerFieldStatus = stat
    }

    func bounceAnswerField() {
        withAnimation(.easeOut(duration: 0.12)) {
            answerFieldRotateAngle = 15
        }

        withAnimation(.easeIn(duration: 0.12).delay(0.12)) {
            answerFieldRotateAngle = 0
        }
    }

    enum Status {
        case answer
        case error
    }
}

