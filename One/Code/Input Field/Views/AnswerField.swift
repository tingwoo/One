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
                Spacer()
            }
            .frame(width: nil, height: 100)
            .background(
                RoundedRectangle(
                    cornerRadius: cornerRadius,
                    style: .continuous
                )
                .fill(Color("AccentAnswerField"))
                .shadow(color: Color(white: 0, opacity: 0.1), radius: 2, y: 2)
            )
        }
        .padding(10)
        .rotation3DEffect(.degrees(inputFieldViewModel.answerFieldRotateAngle),
                          axis: (x: -1 , y: 0, z: 0),
                          perspective: 0.5
        )
        .offset(x: 0, y: (inputFieldViewModel.answerFieldExists ? 0 : 150))
        .animation(.bouncy, value: inputFieldViewModel.answerFieldExists)

    }
}

//#Preview {
//    AnswerField().environmentObject(InputFieldViewModel())
//}
