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
    
    var formulaViewModel: FormulaViewModel
    
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
                                    Key(
                                        action: {formulaViewModel.insertElements(index: keyArrange[selectedIndex][row][item])},
                                        text: keyList[keyArrange[selectedIndex][row][item]].text,
                                        image: keyList[keyArrange[selectedIndex][row][item]].image,
                                        width: keyW(),
                                        height: keyH()
                                    )
                                }
                            }
                        }
                    }
                    // keyList[keyArrange[selectedIndex][row]].command
                    // keyList[keyArrange[selectedIndex][row]].cursorShift
                    VStack(spacing: keySpacing) {
                        ClearAllSwitch(action: formulaViewModel.clear, switchW: keyW(), switchH: keyH(2))
                        Key(action: {}, image: "delete.left", width: keyW(), height: keyH(2), color: Color("AccentKeys2"), textColor: .primary)
                        Key(action: {}, image: "equal", width: keyW(), height: keyH(2), color: Color("AccentYellow"), textColor: .primary)
                    }
                }
                
                ControlBar(shiftCursorFunc: formulaViewModel.shiftCursor, keyHeight: keyHeight * ctrlBarCoef, keySpacing: keySpacing)

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
        Keyboard(formulaViewModel: FormulaViewModel())
    }
}
