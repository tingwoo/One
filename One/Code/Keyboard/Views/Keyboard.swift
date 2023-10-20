//
//  Keyboard.swift
//  One
//
//  Created by Tingwu on 2023/9/12.
//

import SwiftUI

struct Keyboard: View {
    
    @EnvironmentObject var inputFieldLooks: InputFieldLooks

    var formulaViewModel: FormulaViewModel
    
    let fnBarHeight: CGFloat = 40
    let keyHeight: CGFloat = 45
    let keySpacing: CGFloat = 7.0
    let sectionSpacing: CGFloat = 12.0
//    let pickerCoef: CGFloat = 0.35
    let ctrlBarCoef: CGFloat = 1.2
    
    func keyW(_ cnt: CGFloat = 1.0) -> CGFloat {
        return ((UIScreen.main.bounds.width - keySpacing * 7) / 6) * cnt + keySpacing * (cnt - 1)
    }
    
    func keyH(_ cnt: CGFloat = 1.0) -> CGFloat {
        return keyHeight * cnt + keySpacing * (cnt - 1)
    }
    
//    let keyboardsCnt: Int = 2

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: sectionSpacing) {
                funtionBar(
                    clearAction: formulaViewModel.clear,
                    height: fnBarHeight
                )
                
                HStack(alignment: .bottom, spacing: keySpacing / 2.0) {  // 1/2: because of the expanded touch area of keys
                    MainKeyboard(
                        typeIn: {i in formulaViewModel.typeIn(i)},
                        keySpacing: keySpacing,
                        keyH: keyH(),
                        keyW: keyW()
                    )
                    .frame(
                        height: keyHeight * 4 + keySpacing * 3
                    )
                    
                    VStack(spacing: keySpacing) {
                        Key(action: { formulaViewModel.backspace() }, color: Color("AccentKeys2")) {
                            Image(systemName: "delete.left")
                                .font(.system(size: 25))
                        } shape: {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                        }
                        
                        Key(action: { inputFieldLooks.showAnswerField(true) }, color: Color("AccentYellow"), darkAdjust: -0.1, defaultAdjust: -0.1) {
                            Image(systemName: "equal")
                                .font(.system(size: 25))
                        } shape: {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                        }
                    }
                    .frame(width: keyW(), height: keyH(4))
                }
                .offset(x: -keySpacing / 4.0) // because of the expanded touch area of keys
                
                ControlBar(
                    shiftCursorFunc: formulaViewModel.shiftCursor,
                    keyW: keyW,
                    keyH: keyHeight * ctrlBarCoef,
                    keySpacing: keySpacing
                )
            }
            .padding(.horizontal, keySpacing)
            .padding(.top, sectionSpacing)
//            .border(.white)
            
            VStack {
                
            }
            .frame(minWidth: 10, maxHeight: .infinity)
//            .border(.white)
        }
        .frame(
            width: UIScreen.main.bounds.width,
            height: 
                fnBarHeight
              + keyH() * (4 + ctrlBarCoef)
              + sectionSpacing * 3
              + keySpacing * 3
              + 50
        )
        .background(
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
            .fill(Color("AccentInputField"))
            .shadow(radius: 2)
        )
        .ignoresSafeArea()
    }
}

struct Keyboard_Previews: PreviewProvider {
    
    static var previews: some View {
        Keyboard(formulaViewModel: FormulaViewModel()).environmentObject(InputFieldLooks())
    }
}
