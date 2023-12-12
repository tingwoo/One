//
//  Keyboard.swift
//  One
//
//  Created by Tingwu on 2023/9/12.
//

import SwiftUI

struct Keyboard: View {

    @EnvironmentObject var inputFieldViewModel: InputFieldViewModel
    @State var keyboardSelection = 0

    var formulaViewModel: FormulaViewModel

    let fnBarHeight: CGFloat = 40
    let keyHeight: CGFloat = 45
    let keySpacing: CGFloat = 7.0
    let sectionSpacing: CGFloat = 9.0
//    let pickerCoef: CGFloat = 0.35
    let ctrlBarCoef: CGFloat = 1.2

    let keyboardCount: Int = 2

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
                    keyboardSelection: $keyboardSelection,
                    keyboardCount: keyboardCount,
                    clearAction: formulaViewModel.clear,
                    height: fnBarHeight
                )

                HStack(alignment: .center, spacing: keySpacing / 2.0) {  // 1/2: because of the expanded touch area of keys
                    MainKeyboard(
                        selection: keyboardSelection,
                        typeIn: {i in formulaViewModel.typeIn(i)},
                        keySpacing: keySpacing,
                        keyH: keyH(),
                        keyW: keyW()
                    )
                    .frame(
                        height: keyHeight * 4 + keySpacing * 4
                    )

                    VStack(spacing: keySpacing) {
                        Key(action: { formulaViewModel.backspace() }, color: Color("AccentKeys2")) {
                            Image(systemName: "delete.left")
                                .font(.system(size: 25))
                        } shape: {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                        }

                        Key(
                            action: {
                                if formulaViewModel.elements.count > 1 {
                                    var result = ""
                                    do {
                                        result = try Calculator.evaluate(expression: formulaViewModel.elements)
                                        inputFieldViewModel.setAnswerFieldStatus(.answer)
                                    } catch CalculationError.divisionByZero {
                                        result = "除以0的結果沒有定義"
                                        inputFieldViewModel.setAnswerFieldStatus(.error)
                                    } catch CalculationError.expressionIncomplete {
                                        result = "有尚未填上的空格"
                                        inputFieldViewModel.setAnswerFieldStatus(.error)
                                    } catch CalculationError.nonRealExponent {
                                        result = "函數只接受實數"
                                        inputFieldViewModel.setAnswerFieldStatus(.error)
                                    } catch CalculationError.zeroExponent {
                                        result = "0的0次方沒有定義"
                                        inputFieldViewModel.setAnswerFieldStatus(.error)
                                    } catch CalculationError.negativeExponent {
                                        result = "負數的非整數次方沒有定義"
                                        inputFieldViewModel.setAnswerFieldStatus(.error)
                                    } catch CalculationError.notANumber {
                                        result = "輸入了錯誤的數字格式"
                                        inputFieldViewModel.setAnswerFieldStatus(.error)
                                    } catch CalculationError.unknown {
                                        result = "未知的錯誤"
                                        inputFieldViewModel.setAnswerFieldStatus(.error)
                                    } catch CalculationError.unpairedBrackets {
                                        result = "有無法配對的括弧"
                                        inputFieldViewModel.setAnswerFieldStatus(.error)
                                    } catch CalculationError.wrongOperatorPlacement {
                                        result = "運算符輸入錯誤"
                                        inputFieldViewModel.setAnswerFieldStatus(.error)
                                    } catch CalculationError.noLastAnswer {
                                        result = "「Ans」沒有儲存數值"
                                        inputFieldViewModel.setAnswerFieldStatus(.error)
                                    }  catch {
                                        result = "超級未知的錯誤"
                                        inputFieldViewModel.setAnswerFieldStatus(.error)
                                    }
                                    inputFieldViewModel.setAnswerFieldContent(result)
                                    inputFieldViewModel.setAnswerFieldExistence(true)
                                }
                            },
                            color: Color("AccentYellow"),
                            darkAdjust: -0.1,
                            defaultAdjust: -0.1
                        ) {
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
                    shiftCursorFunc: { i, b in formulaViewModel.shiftCursor(i, withHaptics: b, skipInvisible: true)},
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
              + keySpacing * 4
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
        Keyboard(formulaViewModel: FormulaViewModel()).environmentObject(InputFieldViewModel())
    }
}

