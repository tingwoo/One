//
//  FormulaView.swift
//  One
//
//  Created by Tingwu on 2023/9/28.
//

import SwiftUI

struct FormulaView: View {
    
    var cursorKey: UUID
    var elementsParams: [UUID: ElementParamsModel]
    
    
    var textElements: Set<ElementName> = [.zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .point, .paren_l, .paren_r]
    var symbolElements: Set<ElementName> = [.plus, .minus, .multiply, .divide, .PLH]
    
    var body: some View {
        ZStack {
            ForEach(Array(elementsParams.keys), id: \.self) { key in
                let show: Bool = (cursorKey == key)
                
                if(elementsParams[key]!.name == .STA_frac){
                    Rectangle()
                        .frame(width: elementsParams[key]!.param!, height: 2)
                        .modifier(CursorModifier(show))
                        .modifier(ElementAnimation(value: elementsParams))
                        .position(elementsParams[key]!.pos)
                        
                    
                } else if(textElements.contains(elementsParams[key]!.name)) {
                    Text(elementsParams[key]!.name.rawValue)
                        .font(.custom("CMUConcrete-Roman", size: 30))
                        .fontWeight(.regular)
                        .modifier(CursorModifier(show))
                        .modifier(ElementAnimation(value: elementsParams))
                        .position(elementsParams[key]!.pos)
                    
                } else if(symbolElements.contains(elementsParams[key]!.name)) {
                    if(elementsParams[key]!.name.rawValue == "square.dashed" && show) {
                        Image(systemName: "square.fill")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.blue)
                            .position(elementsParams[key]!.pos)
                            .modifier(ElementAnimation(value: elementsParams))
                    }else {
                        Image(systemName: elementsParams[key]!.name.rawValue)
                            .font(.system(size: 20, weight: .regular))
                            .modifier(CursorModifier(show))
                            .modifier(ElementAnimation(value: elementsParams))
                            .position(elementsParams[key]!.pos)
                    }
                    
                } else if(elementsParams[key]!.name == .END || elementsParams[key]!.name == .SEP || elementsParams[key]!.name == .END_frac) {
                    Color.clear.frame(width: 1, height: 1)
                        .modifier(CursorModifier(show))
//                            .modifier(ElementAnimation(value: elementsParams))
                        .position(elementsParams[key]!.pos)
                    
                } else {
                    EmptyView()
                }
            }
        }
    }
}

//#Preview {
//    FormulaView()
//}
