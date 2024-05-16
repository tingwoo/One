//
//  ContentView.swift
//  One
//
//  Created by Tingwu on 2023/9/5.
//

import SwiftUI

struct ContentView: View {
    @StateObject var formulaViewModel = FormulaViewModel()
    @StateObject var inputFieldViewModel = InputFieldViewModel()

    var body: some View {
        ZStack {
            Color("AccentBackground").ignoresSafeArea()
            VStack(spacing: 12){
                InputField(formulaViewModel: formulaViewModel)
                Keyboard(formulaViewModel: formulaViewModel)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .environmentObject(inputFieldViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

