//
//  KeyWithOptions.swift
//  One
//
//  Created by Tingwu on 2023/10/18.
//  https://developer.apple.com/documentation/swiftui/composing-swiftui-gestures

import SwiftUI

struct KeyWithOptions: View {
    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            case .pressing, .dragging:
                return true
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive, .pressing:
                return false
            case .dragging:
                return true
            }
        }
    }
        
    @GestureState private var dragState = DragState.inactive
    @State private var viewState = CGSize.zero
    
    var gapH: CGFloat = 10
    var gapV: CGFloat = 7
    var keyW: CGFloat = 70
    var keyH: CGFloat = 45
    
    var mainOptionIndex: Int = 2
    var menuOptions: [String] = ["x.squareroot", "function", "plusminus", "percent"]
    var selection: Int {
        get {
            switch dragState {
            case .dragging(let trans):
                return max(0, min(menuOptions.count - 1, Int((trans.width / (keyW + gapH)) + CGFloat(mainOptionIndex) + 0.5)))
            default:
                return mainOptionIndex
            }
        }
    }
    
    let hapticManager = HapticManager.instance
    
    @ViewBuilder func MenuView() -> some View {
        let expandAnimationTime = 0.15
        HStack(spacing: (dragState.isDragging ? gapH : 0)) {
            ForEach(menuOptions.indices, id: \.self) { i in
                if(i == selection || dragState.isDragging) {
                    Image(systemName: menuOptions[i]).font(.system(size: 25))
                        .frame(width: keyW, height: keyH)
                        .background((i == selection && dragState.isDragging) ? RoundedRectangle(cornerRadius: 16 - gapV, style: .continuous).fill(Color("AccentKeys2")) : nil)
                        .animation(.easeInOut(duration: 0.1), value: selection)
                        
                }
                    
            }
        }
        .padding(gapV)
        .animation(.easeInOut(duration: 0.15).delay(expandAnimationTime), value: dragState.isDragging)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color("AccentKeys1"))
                .animation(.spring(response: expandAnimationTime, dampingFraction: 0.6), value: dragState.isDragging)
//                .shadow(radius: 1, y: -2)
        )
        .offset(x: (dragState.isDragging ?(keyW + gapH) * (CGFloat(menuOptions.count) / 2.0 - CGFloat(mainOptionIndex) - 0.5) : 0), y: -(keyH + gapV))
        .onChange(of: selection) { selection in
            hapticManager.wheel()
        }
    }
    
//    @ViewBuilder func ExtendedView() -> some View {
//        Image(systemName: menuOptions[mainOptionIndex]).font(.system(size: 25))
//            .frame(width: keyW, height: keyH + gapV * 2)
//            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color("AccentKeys1")))
//            .offset(y: -(keyH + gapV))
//    }
    
    var body: some View {
        let minimumLongPressDuration = 0.2
        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
            .sequenced(before: DragGesture())
            .updating($dragState) { value, state, transaction in
//                print(value)
            
                switch value {
                // Long press begins.
                case .first(true):
                    state = .pressing
                // Long press confirmed, dragging may begin.
                case .second(true, let drag):
                    state = .dragging(translation: drag?.translation ?? .zero)
//                        hapticManager.wheel()
                // Dragging ended or the long press cancelled.
                default:
                    state = .inactive
                }
            }
            .onEnded { value in
//                guard case .second(true, let drag?) = value else { return }
//                self.viewState.width += drag.translation.width
//                self.viewState.height += drag.translation.height
                
//                print("end")
            }
        
        ZStack {
            if(dragState.isActive) {
                Rectangle()
                    .fill(Color("AccentKeys1"))
                    .frame(width: keyW, height: keyH)
                    .offset(y: -keyH / 2.0)
            }
            Image(systemName: menuOptions[mainOptionIndex]).font(.system(size: 25))
                .foregroundStyle(dragState.isActive ? .clear : .black)
                .frame(width: keyW, height: keyH)
                .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color("AccentKeys1")))
                .overlay(dragState.isActive ? MenuView() : nil)
            //                    .overlay(dragState.isDragging ? MenuView() : nil)
            
            
            //                    .offset(
            //                        x: viewState.width + dragState.translation.width,
            //                        y: viewState.height + dragState.translation.height
            //                    )
            //                    .animation(nil)
            //                    .shadow(radius: dragState.isActive ? 8 : 0)
            //                    .animation(.linear(duration: minimumLongPressDuration))
                .gesture(longPressDrag)
                .onChange(of: dragState.isDragging) { d in
                    if (d) { hapticManager.wheel() }
                }
            
        }
    }
}

#Preview {
    KeyWithOptions()
}
