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
        VStack(spacing: 0) {
            
            VStack {
                if (formulaViewModel.elements.count == 1){
                    HStack(spacing: 0) {
                        Text("Problem")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding()
                }else{
                    FormulaView(cursorKey: formulaViewModel.cursorKey, elementsParams: formulaViewModel.elementsParams)
                        .padding()
                        .offset(x: 0, y: formulaViewModel.wholeOffsetY)
                }
                Spacer()
            }
            .background(Color("AccentInputField"))
            .onAppear {
                formulaViewModel.updateParams()
            }
            
//            VStack {
//                HStack(spacing: 0) {
//                    Text("Answer")
//                        .font(.system(size: 30, weight: .medium))
//                        .foregroundColor(.secondary)
//                    
//                    Spacer()
//                }
//                .padding()
//                
//                Spacer()
//            }
//            .background(Color("AccentAnswerField"))
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(.horizontal)
        .shadow(radius: 2)
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
//        InputField(formula: ["1", "2", "3"])
        InputField(formulaViewModel: FormulaViewModel())
    }
}
