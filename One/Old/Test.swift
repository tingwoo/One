//
//  Test.swift
//  One
//
//  Created by Tingwu on 2023/11/10.
//

import Foundation
import SwiftUI

struct TestView: View {
//    let hello: Hello = Hello()
    var body: some View {
        HStack {
            AnyView(Color.blue.frame(width: 100, height: 100).opacity(0.5))
            AnyView(Color.red.frame(width: 100, height: 100).opacity(0.5))
        }
    }
}

#Preview {
    TestView()
}


