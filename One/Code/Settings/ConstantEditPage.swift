//
//  ConstantEditPage.swift
//  One
//
//  Created by Tingwu on 2024/2/24.
//

import SwiftUI

struct ConstantEditPage: View {
    @State var edittingConst: Constant
    @State var pickerSelection: Int = 0

    @FocusState private var nameFocus: Bool
    @FocusState private var coefFocus: Bool
    @FocusState private var expoFocus: Bool

    let tmpGray = Color(red: 0.96, green: 0.96, blue: 0.96)

    func symbolIsSelected(_ symbol: ConstantSymbol?) -> Bool {
        if pickerSelection == 0 {
            return edittingConst.main == symbol
        } else {
            return edittingConst.sub == symbol
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            // Constant Preview
            HStack {
                ConstantView(constant: edittingConst, scale: 1.0)
                Image(systemName: "equal").font(.system(size: 20))
                ConstantValueView(
                    constant: edittingConst,
                    scale: 1.0,
                    bgColorWhenEmpty: tmpGray,
                    coefFocus: _coefFocus,
                    expoFocus: _expoFocus,
                    touchEnable: true
                )
            }
            .frame(maxWidth: .infinity, minHeight: 100, idealHeight: 100, maxHeight: 100)
            .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(tmpGray))

            // Input Fields
            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 8) {
                inputRow(
                    label: "Name",
                    field: $edittingConst.name,
                    placeholder: "Speed of light in vacuum",
                    keyboardType: .default,
                    focusState: $nameFocus,
                    isIncorrect: false
                )

                inputRow(
                    label: "Coefficient",
                    field: $edittingConst.coefString,
                    placeholder: "2.99792458",
                    keyboardType: .numbersAndPunctuation,
                    focusState: $coefFocus,
                    isIncorrect: edittingConst.coefValue == nil
                )

                inputRow(
                    label: "Exponent",
                    field: $edittingConst.expoString,
                    placeholder: "8",
                    keyboardType: .numbersAndPunctuation,
                    focusState: $expoFocus,
                    isIncorrect: edittingConst.expoValue == nil
                )
            }

//            Picker("s", selection: $pickerSelection) {
//                Text("Symbol").tag(0)
//                Text("Subscript").tag(1)
//            }
//            .pickerStyle(.segmented)
            
            // Symbol Options
            SettingsPagePicker(selectedIndex: $pickerSelection, options: ["Symbol", "Subscript"], withHaptics: false).frame(height: 35)

            let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 6)
            let symbolList = pickerSelection == 0 ? ConstantSymbol.allCases.filter({ s in s.isValidMain }) : ConstantSymbol.allCases.filter({ s in s.isValidSub })

            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 3) {
                    // X mark
                    symbolSelectButton(text: Text(Image(systemName: "xmark")), xOffset: 0.0, fontSize: 20.0, compareTarget: nil)
                    // Symbols
                    ForEach(symbolList, id: \.self) { symbol in
                        symbolSelectButton(text: Text(symbol.rawValue), compareTarget: symbol)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .scrollIndicators(.hidden)
        }
    }

    func inputRow(label: String, field: Binding<String>, placeholder: String, keyboardType: UIKeyboardType, focusState: FocusState<Bool>.Binding, isIncorrect: Bool) -> some View {
        GridRow {
            Text(label).font(.custom("CMUConcrete-Roman", size: 20))
            TextField(placeholder, text: field)
                .font(.custom("CMUConcrete-Roman", size: 20))
                .padding([.horizontal], 8)
                .padding([.vertical], 5)
                .background(RoundedRectangle(cornerRadius: 3, style: .continuous).fill(tmpGray))
                .keyboardType(keyboardType)
                .focused(focusState)
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.custom("CMUConcrete-Roman", size: 20))
                        .foregroundColor(Color("AccentRed"))
                        .background(content: { Circle().fill(tmpGray) })
                        .padding(5)
                        .opacity(isIncorrect ? 1 : 0)
                }
        }
    }

    func symbolSelectButton(text: Text, xOffset: CGFloat = -2.0, fontSize: CGFloat = 25.0, compareTarget: ConstantSymbol?) -> some View {
        text
            .foregroundStyle(.black)
            .font(.custom("CMUConcrete-Roman", size: fontSize).italic())
            .offset(CGSize(width: xOffset, height: 0))
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(symbolIsSelected(compareTarget) ? Color("AccentYellow") : tmpGray)
            )
            .onTapGesture {
                if(pickerSelection == 0) { edittingConst.main = compareTarget }
                else { edittingConst.sub = compareTarget }
            }
    }
}

#Preview {
    ConstantEditPage(edittingConst: Constant.example)
        .padding()
}