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
    
    var body: some View {
        ZStack {
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
                    .shadow(.inner(
                        color: Color(white: 0, opacity: 0.2),
                        radius: 4,
                        x: 0,
                        y: 0
                    ))
                )
            )
            .padding(inputFieldLooks.redBorder ? gap : 0)
            
            
            VStack {
                if (formulaViewModel.elements.count == 1){
                    HStack(spacing: 0) {
                        Text("Enter problem")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding()
                }else{
                    FormulaView(cursorKey: formulaViewModel.cursorKey, elementDisplay: formulaViewModel.elementsDisplay)
                        .padding()
                        .offset(x: 0, y: formulaViewModel.wholeOffsetY)
                }
                Spacer()
            }
            .clipShape(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .scaleEffect(inputFieldLooks.redBorder ? 0.97 : 1)
            .onAppear {
                formulaViewModel.updateParams()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(inputFieldLooks.redBorder ? Color("AccentRed") : .clear)
        )
        .padding(.horizontal, 12)
        .animation(.spring(duration: 0.2, bounce: 0.5), value: inputFieldLooks.redBorder)
        
        
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputField(formulaViewModel: FormulaViewModel())
            .environmentObject(InputFieldLooks())
    }
}
