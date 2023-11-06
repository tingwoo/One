//
//  InputField.swift
//  One
//
//  Created by Tingwu on 2023/9/12.
//

import SwiftUI

struct InputField: View {
    @ObservedObject var formulaViewModel: FormulaViewModel
    @EnvironmentObject var inputFieldLooks: InputFieldLooks
    
    let cornerRadius: CGFloat = 16
    let gap: CGFloat = 6
    let contentPadding: CGFloat = 20
    
    var body: some View {
        ZStack {
            
            // Inner shadow background
            VStack(spacing: 0) {
                HStack { Spacer() }
                Spacer()
            }
            .background(
                RoundedRectangle(
                    cornerRadius: inputFieldLooks.redBorder ? cornerRadius - gap : cornerRadius,
                    style: .continuous
                )
                .fill(
                    Color("AccentInputField")
                    .shadow(.inner(color: Color(white: 0, opacity: 0.2), radius: 4))
                )
            )
            .padding(inputFieldLooks.redBorder ? gap : 0)
            
            
            ZStack {
                // Formula
                VStack {
                    if (formulaViewModel.elements.count == 1){
                        HStack(spacing: 0) {
                            Text("Enter problem")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(contentPadding)
                    }else{
//                        ScrollableView($scrollOffset, animationDuration: 0.5, showsScrollIndicator: true, axis: .horizontal/*, forceRefresh: true*/) {
//                            HStack {
//                                ForEach(1..<10) { i in
//                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
//                                        .fill(Color.red)
//                                        .frame(width: 50, height: 50)
//                                        
//                                }
//                            }
//                                
//                        }
//                        .border(.red)
//                        .overlay {
//                            FormulaView(cursorKey: formulaViewModel.cursorKey, elementDisplay: formulaViewModel.elementsDisplay, updateCursor: formulaViewModel.updateCursor)
//                                .padding(contentPadding)
//                                .frame(width: formulaViewModel.wholeWidth + contentPadding * 2)
//                                .offset(x: -scrollOffset.x, y: formulaViewModel.wholeOffsetY)
//                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            FormulaView(cursorKey: formulaViewModel.cursorKey, elementDisplay: formulaViewModel.elementsDisplay, updateCursor: formulaViewModel.updateCursor)
                                .padding(contentPadding)
                                .frame(width: formulaViewModel.wholeWidth + contentPadding * 2)
                                .offset(x: 0, y: formulaViewModel.wholeOffsetY)
                                
                        }
                    }
                    Spacer()
                }
                .onAppear {
                    formulaViewModel.updateParams()
                }
                
                // Answer block
                if(inputFieldLooks.answerFieldExists) {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                        }
                        .frame(width: nil, height: 100)
                        .background(
                            RoundedRectangle(
                                cornerRadius: cornerRadius - 10,
                                style: .continuous
                            )
                            .fill(Color("AccentAnswerField"))
                            .shadow(color: Color(white: 0, opacity: 0.1), radius: 2, y: 2)
                        )
                    }
                    .padding(10)
                    .rotation3DEffect(.degrees(inputFieldLooks.answerFieldRotateAngle), axis: (x: -1 , y: 0, z: 0), perspective: 0.5)
                    .offset(x: 0, y: (inputFieldLooks.answerFieldAppears ? 0 : 150))
                }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .scaleEffect(inputFieldLooks.redBorder ? 0.97 : 1)
        }
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(inputFieldLooks.redBorder ? Color("AccentRed") : .clear)
        )
        .padding(.horizontal, 12)
        
        
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputField(formulaViewModel: FormulaViewModel())
            .environmentObject(InputFieldLooks())
    }
}
