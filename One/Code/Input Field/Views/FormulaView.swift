//
//  FormulaView.swift
//  One
//
//  Created by Tingwu on 2023/9/28.
//

import SwiftUI

struct FormulaView: View {
    
    var cursorKey: UUID
    var elementDisplay: [UUID: ElementDisplay]
    
    var body: some View {
        ZStack {
            ForEach(Array(elementDisplay.keys), id: \.self) { key in
                let show: Bool = (cursorKey == key)
                
                if let displayProps = elementDisplay[key] {
                    
                    let type = displayProps.element.type
                    
                    // change to switch statement in the future
                    if(type == .func_start){ //
//                        Rectangle()
//                            .frame(width: params.spare, height: 2 * params.scale)
//                            .modifier(CursorModifier(show: show, scale: params.scale))
//                            .modifier(ElementAnimation(value: elementDisplay))
//                            .position(params.pos)
                        Color.clear.frame(width: 1, height: 1)
                            .overlay(content: {displayProps.element.functionView(displayProps.params, displayProps.scale)} )
                            .modifier(CursorModifier(show: show, scale: displayProps.scale))
                            .modifier(ElementAnimation(value: elementDisplay))
                            .position(displayProps.pos)
                            
                    }
                    else if(type == .character) {
                        Text(displayProps.element.string)
                            .font(.custom("CMUConcrete-Roman", size: 30 * displayProps.scale))
                            .fontWeight(.regular)
                            .modifier(CursorModifier(show: show, scale: displayProps.scale))
                            .modifier(ElementAnimation(value: elementDisplay))
                            .position(displayProps.pos)
                        
                    } else if(type == .symbol) {
                        Image(systemName: displayProps.element.string)
                            .font(.custom("CMUConcrete-Roman", size: 20 * displayProps.scale))
                            .fontWeight(.regular)
                            .modifier(CursorModifier(show: show, scale: displayProps.scale))
                            .modifier(ElementAnimation(value: elementDisplay))
                            .position(displayProps.pos)
                        
                    } else if(type == .placeholder) {
                        Image(systemName: show ? "square.fill" : "square.dashed")
                            .font(.system(size: 20 * displayProps.scale, weight: .regular))
                            .foregroundColor(show ? .blue : .primary)
                            .position(displayProps.pos)
                            .modifier(ElementAnimation(value: elementDisplay))
                        
                    } else {
                        Color.clear.frame(width: 1, height: 1)
                            .modifier(CursorModifier(show: show, scale: displayProps.scale))
                            .position(displayProps.pos)
                        
                    }
                }
            }
        }
    }
}

//#Preview {
//    FormulaView()
//}
