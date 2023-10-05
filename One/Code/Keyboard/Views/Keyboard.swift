//
//  Keyboard.swift
//  One
//
//  Created by Tingwu on 2023/9/12.
//

import SwiftUI

struct Keyboard: View {
    
    @State private var selectedIndex = 0
    
    var formulaViewModel: FormulaViewModel
    
    let keyHeight: CGFloat = 45
    let keySpacing: CGFloat = 8.0
    let sectionSpacing: CGFloat = 12.0
    let pickerCoef: CGFloat = 0.35
    let ctrlBarCoef: CGFloat = 1.2
    
    func keyW(_ cnt: CGFloat = 1.0) -> CGFloat {
        return ((UIScreen.main.bounds.width - keySpacing * 6) / 5) * cnt + keySpacing * (cnt - 1)
    }
    
    func keyH(_ cnt: CGFloat = 1.0) -> CGFloat {
        return keyHeight * cnt + keySpacing * (cnt - 1)
    }
    
    let keyboardsCnt: Int = 2


    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: sectionSpacing) {
                HStack(alignment: .bottom, spacing: keySpacing) {
                    MainKeyboard(
                        insertElements: formulaViewModel.insertElements,
                        pickerHeight: keyHeight * pickerCoef,
                        keySpacing: keySpacing,
                        keyboardCount: keyboardsCnt
                    )
                    .frame(
                        height: keyHeight * ((keyboardsCnt > 1 ? pickerCoef : 0) +  6)
                              + keySpacing * ((keyboardsCnt > 1 ? 6 : 5))
                    )
                    
                    VStack(spacing: keySpacing) {
                        ClearSwitch(action: formulaViewModel.clear)
    //                    ClearAllSwitch(action: formulaViewModel.clear, switchW: keyW(), switchH: keyH(2))
                        Key(action: {}, image: "delete.left", width: keyW(), height: keyH(2), color: Color("AccentKeys2"), textColor: .primary)
                        Key(action: {}, image: "equal", width: keyW(), height: keyH(2), color: Color("AccentYellow"), textColor: .primary)
                    }
                    .frame(width: keyW(), height: keyH(6))
                }
                
                ControlBar(
                    shiftCursorFunc: formulaViewModel.shiftCursor,
                    keyW: keyW,
                    keyH: keyHeight * ctrlBarCoef,
                    keySpacing: keySpacing
                )
            }
            .padding(.horizontal, keySpacing)
            .padding(.vertical, sectionSpacing)
//            .border(.white)
            
            VStack {
                
            }
            .frame(minWidth: 10, maxHeight: .infinity)
//            .border(.white)
        }
        .frame(
            width: UIScreen.main.bounds.width,
            height: 
                keyH() * (6 + ctrlBarCoef + (keyboardsCnt > 1 ? pickerCoef : 0))
              + sectionSpacing * 3
              + keySpacing * (5 + (keyboardsCnt > 1 ? 1 : 0))
              + 40
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
