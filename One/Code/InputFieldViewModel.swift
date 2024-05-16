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
    @Published var afExists: Bool = false
    @Published var afRotateAngle: CGFloat = 0
    @Published var afContent: String = ""
    @Published var afContentStatus: ContentStatus = .answer
    @Published var afCalcStatus: CalcStatus = .displaying


    func setRedBorder(_ show: Bool){
        redBorder = show
    }

    func setAnswerFieldExistence(_ show: Bool){
        afExists = show
    }

    func setAnswerFieldContent(_ content: String){
        afContent = content
    }

    func setAFContentStatus(_ stat: ContentStatus){
        if stat == .answer {
            bounceAnswerField()
        }
        afContentStatus = stat
    }

    func setAFCalcStatus(_ stat: CalcStatus){
        afCalcStatus = stat
    }


    func bounceAnswerField() {
        withAnimation(.easeOut(duration: 0.12)) {
            afRotateAngle = 15
        }

        withAnimation(.easeIn(duration: 0.12).delay(0.12)) {
            afRotateAngle = 0
        }
    }

    enum ContentStatus {
        case answer
        case error
    }

    enum CalcStatus {
        case displaying
        case calculating
    }
}

