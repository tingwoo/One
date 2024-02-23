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

    @State var pickerSelection: Int = 0

    let latinCharList: String = "abcdefghijklmnopqrstuvwxyz"
    let greekCharList: String = "αβγδεζηθικλμνξοπρστυφχψω"
    let numberCharList: String = "0123456789"

    var body: some View {
        VStack(spacing: 20) {
            Text(coefField)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 100, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: 100)
                .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color(red: 0.95, green: 0.95, blue: 0.95)))

            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 15) {
                GridRow {
                    Text("Name")
                    TextField("Speed of light in vacuum", text: $nameField)
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color(red: 0.95, green: 0.95, blue: 0.95)))

                }
                GridRow {
                    Text("Coefficient")
                    TextField("2.99792458", text: $coefField)
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color(red: 0.95, green: 0.95, blue: 0.95)))
                }
                GridRow {
                    Text("Exponent")
                    TextField("8", text: $expoField)
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color(red: 0.95, green: 0.95, blue: 0.95)))
                }
            }

            Picker("s", selection: $pickerSelection) {
                Text("Symbol").tag(0)
                Text("Subscript").tag(1)
            }
            .pickerStyle(.segmented)

            let columns = Array(repeating: GridItem(), count: 5)
            let charList = pickerSelection == 0 ? latinCharList + greekCharList : numberCharList + latinCharList + greekCharList
            LazyVGrid(columns: columns, spacing: 25) {
                if pickerSelection == 1 { Image(systemName: "xmark") }
                ForEach(charList.map { String($0) }, id: \.self) { char in
                    Text(char).font(.custom("CMUConcrete-Roman", size: 25))
                }
            }


        }
    }
}

#Preview {
    ScrollView {
        ConstantEditPage().padding()
    }
}
