//
//  Keyboard.swift
//  One
//
//  Created by Tingwu on 2023/9/12.
//

import SwiftUI

extension UISegmentedControl {
  override open func didMoveToSuperview() {
     super.didMoveToSuperview()
     self.setContentHuggingPriority(.defaultLow, for: .vertical)
   }
}

struct Keyboard: View {
    
    @State private var selectedIndex = 0
    
    var formulaManager: FormulaManager
    
    let keyHeight: CGFloat = 45
    let keySpacing: CGFloat = 8.0
    let sectionSpacing: CGFloat = 14.0
    let pickerCoef: CGFloat = 0.8
    let ctrlBarCoef: CGFloat = 1.2
    
    func keyW(_ cnt: CGFloat = 1.0) -> CGFloat {
        return ((UIScreen.main.bounds.width - keySpacing * 6) / 5) * cnt + keySpacing * (cnt - 1)
    }
    
    func keyH(_ cnt: CGFloat = 1.0) -> CGFloat {
        return keyHeight * cnt + keySpacing * (cnt - 1)
    }
    
    let keyboards = ["textformat.123", "sum", "angle"]


    var body: some View {
        VStack {
            VStack(spacing: sectionSpacing) {
                
                Picker(selection: $selectedIndex) {
                    ForEach(keyboards.indices, id: \.self) { item in
                        Image(systemName: keyboards[item])
                    }
                } label: {
                    Text("選擇鍵盤")
                }
                .pickerStyle(.segmented)
                .frame(width: UIScreen.main.bounds.width - keySpacing * 2, height: keyH() * pickerCoef)
                .padding(.horizontal)
                
                HStack(spacing: keySpacing) {
                    VStack {
                        ForEach(keyArrange[selectedIndex].indices, id: \.self) { row in
                            HStack(spacing: keySpacing) {
                                ForEach(keyArrange[selectedIndex][row].indices, id: \.self) { item in
                                    Key(insertFunc: self.formulaManager.insert, width: keyW(), height: keyH(), attr: keyList[keyArrange[selectedIndex][row][item] ?? 0], keyID: keyArrange[selectedIndex][row][item] ?? 0)
                                }
                            }
                        }
                    }
                    VStack(spacing: keySpacing) {
                        ClearAllSwitch(clearAllFunc: self.formulaManager.clearAll, switchW: keyW(), switchH: keyH(2))
                        BackspaceKey(backspaceFunc: self.formulaManager.backspace, width: keyW(), height: keyH(2))
                        EqualKey(width: keyW(), height: keyH(2))
                    }
                }
                
                ControlBar(shiftCursorFunc: self.formulaManager.shiftCursor, keyHeight: keyHeight * ctrlBarCoef, keySpacing: keySpacing)

                Spacer()
            }
            .padding(.top, sectionSpacing)
            .frame(
                width: UIScreen.main.bounds.width,
                height: keyH() * (6 + pickerCoef + ctrlBarCoef) + sectionSpacing * 3 + keySpacing * 5 + 50
            )
            .background(
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
                .fill(Color("AccentInputField"))
                .shadow(radius: 2)
            )
        }
        .ignoresSafeArea()
    }
}

struct Keyboard_Previews: PreviewProvider {
    
    static var previews: some View {
        Keyboard(formulaManager: FormulaManager())
    }
}
