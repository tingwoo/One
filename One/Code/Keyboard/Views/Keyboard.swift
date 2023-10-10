//
//  Keyboard.swift
//  One
//
//  Created by Tingwu on 2023/9/12.
//

import SwiftUI

struct Keyboard: View {

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
    
    let keyboardsCnt: Int = 2


    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: sectionSpacing) {
                funtionBar(
                    clearAction: formulaViewModel.clear,
                    height: fnBarHeight
                )
                
                HStack(alignment: .bottom, spacing: keySpacing) {
                    MainKeyboard(
                        insertElements: formulaViewModel.insertElements,
                        keySpacing: keySpacing,
                        keyboardCount: keyboardsCnt
                    )
                    .frame(
                        height: keyHeight * 4 + keySpacing * 3
                    )
                    
                    VStack(spacing: keySpacing) {
                        Key(action: {}, color: Color("AccentKeys2")) {
                            Image(systemName: "delete.left")
                                .font(.system(size: 25))
                        } shape: {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                        }
                        
                        Key(action: {}, color: Color("AccentYellow"), pressedColor:  .black) {
                            Image(systemName: "equal")
                                .font(.system(size: 25))
                        } shape: {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                        }
                    }
                    .frame(width: keyW(), height: keyH(4))
                }
                
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
        Keyboard(formulaViewModel: FormulaViewModel())
    }
}
