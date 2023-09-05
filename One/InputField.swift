//
//  InputField.swift
//  One
//
//  Created by Tingwu on 2023/9/12.
//

import SwiftUI

struct InputField: View {
//    var formula: [String] = []
    @ObservedObject var formulaManager: FormulaManager
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                self.formulaManager.display()
                Spacer()
            }
            .background(Color("AccentInputField"))
            
            VStack {
                HStack(spacing: 0) {
                    Text("Answer")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
            }
            .background(Color("AccentAnswerField")
)
            
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(.horizontal)
        .shadow(radius: 2)
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
//        InputField(formula: ["1", "2", "3"])
        InputField(formulaManager: FormulaManager(testFormula: ["3", ".", "1", "4"]))
    }
}
