//
//  ContentView.swift
//  One
//
//  Created by Tingwu on 2023/9/5.
//

import SwiftUI

struct ContentView: View {
    var formulaManager = FormulaManager()
    
    var body: some View {
        ZStack {
            Color("AccentBackground").ignoresSafeArea()
            VStack(spacing: 15){
                InputField(formulaManager: self.formulaManager)
                Keyboard(formulaManager: self.formulaManager)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
