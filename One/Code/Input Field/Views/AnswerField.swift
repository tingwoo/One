//
//  AnswerField.swift
//  One
//
//  Created by Tingwu on 2023/12/10.
//

import SwiftUI

struct AnswerField: View {
    @StateObject var inputFieldViewModel: InputFieldViewModel

    var cornerRadius: CGFloat = 6

    var body: some View {
        VStack {
            Text(inputFieldViewModel.answerFieldStatus == .answer ? "答案" : "錯誤")
                .font(.headline)
                .foregroundStyle(inputFieldViewModel.answerFieldStatus == .answer ? Color("AccentAnswerFieldDark") : Color("AccentAnswerFieldDarkRed"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .horizontal], 20)

            Spacer()

            Text(inputFieldViewModel.answerFieldContent)
                .textSelection(.enabled)
                .font(inputFieldViewModel.answerFieldStatus == .answer ? .custom("CMUConcrete-Roman", size: 30) : .system(size: 25, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.bottom, .horizontal], 20)
                .animation(.easeInOut(duration: 0.1), value: inputFieldViewModel.answerFieldStatus)
        }
        .frame(maxWidth: .infinity, idealHeight: 110, maxHeight: 110)
        .background(
            RoundedRectangle(
                cornerRadius: cornerRadius,
                style: .continuous
            )
            .fill(inputFieldViewModel.answerFieldStatus == .answer ? Color("AccentAnswerField") : Color("AccentAnswerFieldRed"))
            .shadow(color: Color(white: 0, opacity: 0.1), radius: 2, y: 2)
        )
        .padding(10)
//        .brightness(-inputFieldViewModel.answerFieldRotateAngle / 40.0)
        .rotation3DEffect(.degrees(inputFieldViewModel.answerFieldRotateAngle),
                          axis: (x: -1 , y: 0, z: 0),
                          perspective: 0.5
        )
        .offset(x: 0, y: (inputFieldViewModel.answerFieldExists ? 0 : 150))
        .animation(.bouncy, value: inputFieldViewModel.answerFieldExists)
        .animation(.easeInOut(duration: 0.1), value: inputFieldViewModel.answerFieldStatus)

    }
}

//#Preview {
//    AnswerField().environmentObject(InputFieldViewModel())
//}
