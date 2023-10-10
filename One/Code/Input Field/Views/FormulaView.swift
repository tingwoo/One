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
    
    var manual = ElementManual.instance
    
    var body: some View {
        ZStack {
            ForEach(Array(elementsParams.keys), id: \.self) { key in
                let show: Bool = (cursorKey == key)
                
                if let params = elementsParams[key] {
                    
                    let type = manual.getType(params.name)
                    
                    // change to switch statement in the future
                    if(params.name == .STA_frac){ //
                        Rectangle()
                            .frame(width: params.param, height: 2)
                            .modifier(CursorModifier(show))
                            .modifier(ElementAnimation(value: elementsParams))
                            .position(params.pos)
                        
                    } else if(type == .character) {
                        Text(manual.getString(params.name))
                            .font(.custom("CMUConcrete-Roman", size: 30))
                            .fontWeight(.regular)
                            .modifier(CursorModifier(show))
                            .modifier(ElementAnimation(value: elementsParams))
                            .position(params.pos)
                        
                    } else if(type == .symbol) {
                        Image(systemName: manual.getString(params.name))
                            .font(.custom("CMUConcrete-Roman", size: 20))
                            .fontWeight(.regular)
                            .modifier(CursorModifier(show))
                            .modifier(ElementAnimation(value: elementsParams))
                            .position(params.pos)
                        
                    } else if(type == .placeholder) {
                        Image(systemName: show ? "square.fill" : "square.dashed")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(show ? .blue : .primary)
                            .position(params.pos)
                            .modifier(ElementAnimation(value: elementsParams))
                        
                    } else {
                        Color.clear.frame(width: 1, height: 1)
                            .modifier(CursorModifier(show))
                            .position(params.pos)
                        
                    }
                }
            }
        }
    }
}

//#Preview {
//    FormulaView()
//}
