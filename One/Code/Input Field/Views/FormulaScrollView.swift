//
//  FormulaScrollView.swift
//  One
//
//  Created by Tingwu on 2023/11/8.
//

import SwiftUI

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}

struct FormulaScrollView: View {
    @ObservedObject var formulaViewModel: FormulaViewModel
    @State var scrollOffset: CGFloat = 0
    @State var time: Date = Date()
    
    var fieldWidth: CGFloat
    var contentPadding: CGFloat
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack {
                        GeometryReader { geometryProxy in
                            Color.black
                                .preference(
                                    key: OffsetPreferenceKey.self,
                                    value: geometryProxy.frame(in: .named("scroll_view_origin")).origin
                                )
                        }
                        .frame(width: 0, height: 0)
                        .id(-1)
                        
                        Spacer()
                    }
                    
                    FormulaView(
                        cursorKey: formulaViewModel.cursorKey,
                        elementDisplayDict: formulaViewModel.elementsDisplayDict.array,
                        updateCursor: formulaViewModel.updateCursor
                    )
                    .padding(contentPadding)
//                    .frame(width: 3000)
                    .frame(width: formulaViewModel.wholeWidth + contentPadding * 2)
//                    .border(.black)
                    .offset(x: 0, y: formulaViewModel.wholeOffsetY)
                    
                    Spacer()
                }
//                .border(.orange)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .border(.green)
            .coordinateSpace(name: "scroll_view_origin")
            .onPreferenceChange(OffsetPreferenceKey.self, perform: { value in
                scrollOffset = value.x
            })
            .onChange(of: formulaViewModel.cursorLocation, perform: { _ in
                // Get cursor position
                // Determine whether the view should shift (+/-n elements)
                // Consider: (1) cursor position and (2) scroll offset
                
                if let cursorKey = formulaViewModel.cursorKey, let cursorPosX = formulaViewModel.elementsDisplayDict.array[cursorKey]?.pos.x {
                    
                    let actualPosX = cursorPosX + scrollOffset
                    let scrollAnchor = 0.5
                    
                    withAnimation {
                        if(actualPosX < 0) {
                            time = Date()
                            scrollProxy.scrollTo(cursorKey, anchor: UnitPoint(x: scrollAnchor, y: 0))
                            print("scroll left")
                        } else if(actualPosX > fieldWidth - contentPadding * 2) {
                            time = Date()
                            scrollProxy.scrollTo(cursorKey, anchor: UnitPoint(x: 1 - scrollAnchor, y: 0))
                            print("scroll right")
                        } else {
                            if(-time.timeIntervalSinceNow > 0.35) {
                                scrollProxy.scrollTo(-1, anchor: UnitPoint(x: scrollOffset / fieldWidth , y: 0))
                                print("fixed")
                            }
                        }
                    }
                }
            })
        }
//        .overlay(alignment: .bottomLeading, content: { Text("x offset: \(Int(scrollOffset.rounded()))").fontWeight(.bold) })
    }
}

//#Preview {
//    FormulaScrollView(formulaViewModel: FormulaViewModel.example, contentPadding: 20)
//}
