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
            Spacer()
            HStack {
                Text(inputFieldViewModel.answerFieldContent)
                    .font(.custom("CMUConcrete-Roman", size: 30))
                    .padding(.horizontal, 20)
                Spacer()
            }
            .frame(width: nil, height: 100)
            .background(
                RoundedRectangle(
                    cornerRadius: cornerRadius,
                    style: .continuous
                )
                .fill(inputFieldViewModel.answerFieldColor)
                .shadow(color: Color(white: 0, opacity: 0.1), radius: 2, y: 2)
            )
        }
        .padding(10)
//        .brightness(-inputFieldViewModel.answerFieldRotateAngle / 40.0)
        .rotation3DEffect(.degrees(inputFieldViewModel.answerFieldRotateAngle),
                          axis: (x: -1 , y: 0, z: 0),
                          perspective: 0.5
        )
        .offset(x: 0, y: (inputFieldViewModel.answerFieldExists ? 0 : 150))
        .animation(.bouncy, value: inputFieldViewModel.answerFieldExists)
        .animation(.easeInOut(duration: 0.1), value: inputFieldViewModel.answerFieldColor)

    }
}

//#Preview {
//    AnswerField().environmentObject(InputFieldViewModel())
//}
