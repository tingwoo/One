//
//  ConstantEditPage.swift
//  One
//
//  Created by Tingwu on 2024/2/24.
//

import SwiftUI

struct ConstantEditPage: View {
    @State var nameField: String = ""
    @State var coefField: String = ""
    @State var expoField: String = ""

    @State var name: String? = nil
    @State var coefficient: BComplex? = nil
    @State var exponent: Int? = nil

    @FocusState private var coefFocus: Bool
    @FocusState private var expoFocus: Bool

    @State var pickerSelection: Int = 0

    @State var selectedSymbol: String? = nil
    @State var selectedSubscript: String? = nil



    let latinCharList: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    let greekCharList: [String] = ["α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ", "ν", "ξ", "ο", "π", "ρ", "σ", "τ", "υ", "φ", "χ", "ψ", "ω"]
    let numberCharList: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

    let tmpGray = Color(red: 0.96, green: 0.96, blue: 0.96)

    func symbolIsSelected(_ char: String?) -> Bool {
        if pickerSelection == 0 {
            return selectedSymbol == char
        } else {
            return selectedSubscript == char
        }
    }

    func isValidCoef(_ str: String) -> Bool {
        return BDouble(str) != nil && coefField != ""
    }

    func isValidExpo(_ str: String) -> Bool {
        return Int(str) != nil
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // Symbol
                if let c1 = selectedSymbol {
                    HStack(alignment: .bottom, spacing: 3){
                        Text(c1).font(.custom("CMUConcrete-Roman", size: 27).italic())

                        if let c2 = selectedSubscript {
                            Text(c2).font(.custom("CMUConcrete-Roman", size: 15).bold())
                        }
                    }
                } else {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .strokeBorder(.black, lineWidth: 1)
                        .frame(width: 30, height: 25)
                }


                Image(systemName: "equal").font(.system(size: 20))
                
                // Coefficient
                if let c = coefficient {
                    Text(c.re.decimalExpansion(precisionAfterDecimalPoint: 3))
                        .font(.custom("CMUConcrete-Roman", size: 27))
                        .background(RoundedRectangle(cornerRadius: 3, style: .continuous).fill(coefFocus ? Color("AccentYellow") : .clear))
                        .onTapGesture {
                            coefFocus = true
                        }
                } else {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .strokeBorder(.black, lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 3, style: .continuous).fill(coefFocus ? Color("AccentYellow") : tmpGray))
                        .frame(width: 30, height: 25)
                        .onTapGesture {
                            coefFocus = true
                        }
                }

                Image(systemName: "multiply").font(.system(size: 20))

                // 10^n
                HStack(spacing: 3) {
                    Text("10").font(.custom("CMUConcrete-Roman", size: 27))
                    if let e = exponent {
                        Text(String(e))
                            .font(.custom("CMUConcrete-Roman", size: 15).bold())
                            .background(RoundedRectangle(cornerRadius: 3, style: .continuous).fill(expoFocus ? Color("AccentYellow") : .clear))
                            .offset(CGSize(width: 0, height: -10))
                            .onTapGesture {
                                expoFocus = true
                            }
                    } else {
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .strokeBorder(.black, lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 3, style: .continuous).fill(expoFocus ? Color("AccentYellow") : tmpGray))
                            .frame(width: 15, height: 12)
                            .offset(CGSize(width: 0, height: -10))
                            .onTapGesture {
                                expoFocus = true
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 100, idealHeight: 100, maxHeight: 100)
            .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(tmpGray))

            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 5) {
                GridRow {
                    Text("Name").font(.custom("CMUConcrete-Roman", size: 20))
                    TextField("Speed of light in vacuum", text: $nameField).font(.custom("CMUConcrete-Roman", size: 20))

                }

                GridRow {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.black)
                        .gridCellColumns(2)
                        .padding([.bottom])
                }

                GridRow {
                    Text("Coefficient").font(.custom("CMUConcrete-Roman", size: 20))
                    TextField("2.99792458", text: $coefField)
                        .font(.custom("CMUConcrete-Roman", size: 20))
//                        .foregroundColor(isValidCoef(coefField) ? .primary : Color("AccentRed"))
                        .keyboardType(.numbersAndPunctuation)
                        .focused($coefFocus)
                        .onChange(of: coefFocus) { focused in
                            if !focused {
                                if let dou = BDouble(coefField), isValidCoef(coefField) {
                                    coefficient = BComplex(re: dou)
                                } else {
                                    coefficient = nil
                                }
                            }
                        }
                        .overlay(alignment: .trailing) {
                            if(coefField != "" && !isValidCoef(coefField)){
                                Image(systemName: "xmark")
                                    .font(.custom("CMUConcrete-Roman", size: 18))
                                    .foregroundColor(Color("AccentRed"))
                            }
                        }
                }

                GridRow {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.black)
                        .gridCellColumns(2)
                        .padding([.bottom])
                }

                GridRow {
                    Text("Exponent").font(.custom("CMUConcrete-Roman", size: 20))
                    TextField("8", text: $expoField)
                        .font(.custom("CMUConcrete-Roman", size: 20))
//                        .foregroundColor(isValidExpo(expoField) ? .primary : .red)
                        .keyboardType(.numbersAndPunctuation)
                        .focused($expoFocus)
                        .onChange(of: expoFocus) { focused in
                            if !focused {
                                if isValidExpo(expoField) {
                                    exponent = Int(expoField)
                                } else {
                                    exponent = nil
                                }
                                exponent = Int(expoField)
                            }
                        }
                        .overlay(alignment: .trailing) {
                            if(expoField != "" && !isValidExpo(expoField)){
                                Image(systemName: "xmark")
                                    .font(.custom("CMUConcrete-Roman", size: 18))
                                    .foregroundColor(Color("AccentRed"))
                            }
                        }
                }

                GridRow {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.black)
                        .gridCellColumns(2)
                        .padding([.bottom])
                }
            }

//            Picker("s", selection: $pickerSelection) {
//                Text("Symbol").tag(0)
//                Text("Subscript").tag(1)
//            }
//            .pickerStyle(.segmented)

            SettingsPagePicker(selectedIndex: $pickerSelection, options: ["Symbol", "Subscript"], withHaptics: false).frame(height: 35)

            let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 5)
            let charList = (pickerSelection == 0 ? [] : numberCharList) + latinCharList + greekCharList
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 3) {
                    ForEach(charList.indices, id: \.self) { index in
                        Text(charList[index])
                            .font(.custom("CMUConcrete-Roman", size: 25).italic())
                            .offset(CGSize(width: -2, height: 0))
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(symbolIsSelected(charList[index]) ? Color("AccentYellow") : tmpGray)
                            )
                            .onTapGesture {
                                if(symbolIsSelected(charList[index])) {
                                    if(pickerSelection == 0) { selectedSymbol = nil }
                                    else { selectedSubscript = nil }
                                } else {
                                    if(pickerSelection == 0) { selectedSymbol = charList[index] }
                                    else { selectedSubscript = charList[index] }
                                }
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    ConstantEditPage().padding()
}
