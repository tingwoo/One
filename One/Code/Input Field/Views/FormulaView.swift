//
//  FormulaView.swift
//  One
//
//  Created by Tingwu on 2023/9/28.
//

import SwiftUI

struct FormulaView: View {

    var cursorKey: Int?
    var elementDisplayDict: [ElementDisplay?]
    var setCursor: (Int) -> ()

//    let baseTextSize

    var dictIndicies: [Tmp] {
        Array(0..<(elementDisplayDict.count)).map({Tmp(n: $0)})
    }

    struct Tmp: Identifiable {
        var id = UUID()
        var n: Int
    }

//    var dictLength: Int

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(0..<150) { key in
                if key < elementDisplayDict.count, let displayProps = elementDisplayDict[key] {
                    let show: Bool = (cursorKey == key)
                    let type = displayProps.element.type
                    let dim = displayProps.element.dimension
                    let scale = displayProps.scale

                    HStack(alignment: .center, spacing: 0) {
                        Color.clear
                            .frame(width: displayProps.pos.x) // adjust x position

                        // change to switch statement in the future

                        if(type == .func_start){ // remember to add semi

                            Color.clear
                                .frame(width: 0, height: 0)
                                .id(key)

                            if let params = displayProps.params {
                                displayProps.element.functionView(params, scale)
                                    .modifier(AnimationModifier(value: elementDisplayDict))
                                    .modifier(CursorModifier(show: show, scale: scale))
                            }

                        }
                        else if(type == .character || type == .number) {

                            Color.clear
                                .frame(width: 0, height: 0)
                                .id(key)

                            VStack {
                                Text(displayProps.element.string)
                                    .font(.custom("CMUConcrete-Roman", size: 30 * scale))
                                    .fontWeight(.regular)
                                    .modifier(AnimationModifier(value: elementDisplayDict))
                            }
                            .frame(width: dim.width * scale, height: dim.height * scale)
                            .modifier(CursorModifier(show: show, scale: scale))
                            .modifier(TapModifier(index: displayProps.index, dimension: dim, scale: scale, setCursor: setCursor))

                        }
                        else if(type == .symbol) {

                            Color.clear
                                .frame(width: 0, height: 0)
                                .id(key)

                            VStack {
                                Image(systemName: displayProps.element.string)
                                    .font(.custom("CMUConcrete-Roman", size: 20 * scale))
                                    .fontWeight(.regular)
                                    .modifier(AnimationModifier(value: elementDisplayDict))
                            }
                            .frame(width: dim.width * scale, height: dim.height * scale)
                            .modifier(CursorModifier(show: show, scale: scale))
                            .modifier(TapModifier(index: displayProps.index, dimension: dim, scale: scale, setCursor: setCursor))

                        }
                        else if(type == .bracket_start || type == .bracket_end) {
                            Color.clear
                                .frame(width: 0, height: 0)
                                .id(key)

                            let params = displayProps.params ?? [dim.width * scale, dim.height * scale, -dim.height * 0.5 * scale, dim.height * 0.5 * scale]

                            BracketView(
                                side: displayProps.element == .bracket_start ? .left : .right,
                                params: params,
                                scale: scale
                            )
                            .modifier(AnimationModifier(value: elementDisplayDict))

                            .modifier(TapModifier(index: displayProps.index, dimension: ExpressionDim(width: params[0] / scale, height: params[1] / scale), scale: scale, setCursor: setCursor))
                            .offset(y: params[3] - params[1] / 2)
                            .modifier(CursorModifier(show: show, scale: scale))

                        }
                        else if(type == .placeholder) {

                            VStack {
                                Image(systemName: show ? "square.fill" : "square.dashed")
                                    .font(.system(size: 20 * scale, weight: .regular))
                                    .modifier(AnimationModifier(value: elementDisplayDict))
                                    .foregroundColor(show ? .blue : .primary)
                            }
                            .frame(width: dim.width * scale, height: dim.height * scale)
                            .id(key)
                            .onTapGesture {
                                setCursor(displayProps.index)
                            }

                        } else if(displayProps.element == .END) {

                            Color.clear
                                .frame(width: 0, height: 0)
                                .id(key)

                            Color.clear
                                .frame(width: dim.width * scale, height: dim.height * scale)
                                .modifier(CursorModifier(show: show, scale: scale))
                                .modifier(TapModifier(index: displayProps.index, dimension: dim, scale: scale, setCursor: setCursor))


                        } else {

                            Color.clear
                                .frame(width: 0, height: 0)
                                .modifier(CursorModifier(show: show, scale: scale))
                                .id(key)
                        }

                    }
                    .frame(height: dim.height * scale)
                    .offset(y: displayProps.pos.y - dim.height * scale / 2)
                }
            }
        }
    }
}

//#Preview {
//    FormulaView()
//}

