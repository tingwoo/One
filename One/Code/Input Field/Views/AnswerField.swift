//
//  AnswerField.swift
//  One
//
//  Created by Tingwu on 2023/12/10.
//

import SwiftUI

struct AnswerField: View {
    @EnvironmentObject var inputFieldViewModel: InputFieldViewModel
    var cornerRadius: CGFloat = 6

    var body: some View {
        VStack {
            Group {
                switch inputFieldViewModel.afContentStatus {
                case .answer:
                    Text("答案")
                        .font(.headline)
                        .foregroundStyle(Color("AccentAnswerFieldDark"))

                case .error:
                    Text("錯誤")
                        .font(.headline)
                        .foregroundStyle(Color("AccentAnswerFieldDarkRed"))

                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .horizontal], 20)

            Spacer()
            
            Group {
                switch inputFieldViewModel.afCalcStatus {
                case .displaying:
                    Text(inputFieldViewModel.afContent)
                        .textSelection(.enabled)
                        .font(inputFieldViewModel.afContentStatus == .answer ? .custom("CMUConcrete-Roman", size: 30) : .system(size: 25, weight: .medium))

                case .calculating:
                    ProgressView()

                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.bottom, .horizontal], 20)
            .animation(.easeInOut(duration: 0.1), value: inputFieldViewModel.afContentStatus)

        }
        .frame(maxWidth: .infinity, idealHeight: 110, maxHeight: 110)
        .background(
            RoundedRectangle(
                cornerRadius: cornerRadius,
                style: .continuous
            )
            .fill(bgColor)
            .shadow(color: Color(white: 0, opacity: 0.1), radius: 2, y: 2)
        )
        .padding(10)
        .rotation3DEffect(.degrees(inputFieldViewModel.afRotateAngle),
                          axis: (x: -1 , y: 0, z: 0),
                          perspective: 0.5
        )
        .offset(x: 0, y: (inputFieldViewModel.afExists ? 0 : 150))
        .animation(.bouncy, value: inputFieldViewModel.afExists)
        .animation(.easeInOut(duration: 0.1), value: inputFieldViewModel.afContentStatus)

    }

    var bgColor: Color {
        switch inputFieldViewModel.afContentStatus {
        case .answer:
            Color("AccentAnswerField")
        case .error:
            Color("AccentAnswerFieldRed")

        }
    }
}

//#Preview {
//    AnswerField().environmentObject(InputFieldViewModel())
//}
