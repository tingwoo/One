//
//  InputField.swift
//  One
//
//  Created by Tingwu on 2023/9/12.
//

import SwiftUI

struct InputField: View {
    @ObservedObject var formulaViewModel: FormulaViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack { Spacer() }
                Spacer()
            }
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    Color("AccentInputField")
                    .shadow(.inner(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 0))
                )
            )
            
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
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .onAppear {
                formulaViewModel.updateParams()
            }
        }
        .padding(.horizontal, 12)
        
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputField(formulaViewModel: FormulaViewModel())
    }
}
