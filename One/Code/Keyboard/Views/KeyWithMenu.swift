//
//  KeyWithMenu.swift
//  One
//
//  Created by Tingwu on 2023/10/18.
//  https://developer.apple.com/documentation/swiftui/composing-swiftui-gestures

import SwiftUI

struct KeyWithMenu: View {
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

    enum DisplayType {
        case text
        case image
        case nothing
    }

    struct DisplayContent {
        var type: DisplayType
        var string: String

        init(_ type: DisplayType, _ string: String) {
            self.type = type
            self.string = string
        }
    }

    @GestureState private var dragState = DragState.inactive
    @State private var selectionRecord: Int? = nil
    @Environment(\.colorScheme) var colorScheme

    var typeIn: (Int) -> () = {i in}

    var gap: CGFloat = 10
    var keyW: CGFloat = 70
    var keyH: CGFloat = 45
    var coef: CGFloat = 1.3
    var cornerRadius: CGFloat = 10

    var main: Int = 3
    var optionsL: [Int] = [12, 13]
    var optionsR: [Int] = [17]

    var numOfoptions: Int { optionsL.count + optionsR.count + 1 }
    var mainIndex: Int { optionsL.count }
    var isSingleKey: Bool { optionsL.isEmpty && optionsR.isEmpty }

    let hapticManager = HapticManager.instance

    func indexToKeyId(_ index: Int) -> Int {
        if(index < optionsL.count) {
            return optionsL[index]
        } else if(index == optionsL.count) {
            return main
        } else {
            return optionsR[index - optionsL.count - 1]
        }
    }

    func combinedOptions(_ index: Int) -> DisplayContent {
        let key: KeyAttr = keyList[indexToKeyId(index)]

        if let string = key.text {
            return DisplayContent(DisplayType.text, string)
        } else if let string = key.image {
            return DisplayContent(DisplayType.image, string)
        } else {
            return DisplayContent(DisplayType.text, "")
        }
    }

    func dragWidthToSelection(_ w: CGFloat) -> Int {
        return max(0, min(numOfoptions - 1, Int((w / (keyW + gap)) + CGFloat(mainIndex) + 0.5)))
    }

    var selection: Int {
        get {
            switch dragState {
            case .dragging(let translation):
                return dragWidthToSelection(translation.width)
            default:
                return mainIndex
            }
        }
    }

    // Unified interface for text and symbols
    @ViewBuilder func Content(displayContent: DisplayContent) -> some View {
        switch displayContent.type {
        case .text:
            Text(displayContent.string)
        case .image:
            Image(systemName: displayContent.string)
        case .nothing:
            EmptyView()
        }
    }

    // Long-press menu
    @ViewBuilder func MenuView() -> some View {
        let expandAnimationTime = 0.15
        HStack(spacing: gap) {
            ForEach(0..<numOfoptions, id: \.self) { i in
                if(i == selection || dragState.isDragging) {
                    Content(displayContent: combinedOptions(i))
                        .font(.system(size: 30))
                        .foregroundStyle(.primary)
                        .frame(width: keyW, height: keyH * coef)
                        .background(
                            RoundedRectangle(cornerRadius: 16 - gap / 2.0, style: .continuous)
                                .fill((!isSingleKey && i == selection && dragState.isDragging) ? Color("AccentKeys2") : Color("AccentKeys1"))
                                .animation(.easeInOut(duration: 0.1), value: dragState.isDragging)
                                .animation(.easeInOut(duration: 0.1), value: selection)

                        )
                }
            }
        }
        .animation(.easeInOut(duration: 0.1).delay(expandAnimationTime), value: dragState.isDragging)
        .padding(gap / 2.0)

        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color("AccentKeys1"))
                .animation(.spring(response: expandAnimationTime, dampingFraction: 0.6), value: dragState.isDragging)
//                .shadow(radius: 1, y: -2)
        )
        .offset(x: (dragState.isDragging ? (keyW + gap) * (CGFloat(numOfoptions) / 2.0 - CGFloat(mainIndex) - 0.5) : 0), y: -(keyH * coef / 2.0 + keyH / 2.0 + gap))
        .onChange(of: selection) { selection in
            hapticManager.wheel()
        }
    }

    var body: some View {
        let minimumLongPressDuration = 0.2
        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
            .sequenced(before: DragGesture())
            .updating($dragState) { value, state, transaction in

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
                guard case .second(true, let drag?) = value else {
                    return
                }

                self.selectionRecord = dragWidthToSelection(drag.translation.width)
            }

        ZStack {
            // Background
            Rectangle()
                .fill(Color("AccentInputField"))
                .frame(width: keyW + gap, height: keyH + gap)

            // Connector
            if(dragState.isActive) {
                Rectangle()
                    .fill(Color("AccentKeys1"))
                    .frame(width: keyW, height: keyH)
                    .offset(y: -keyH / 2.0)
                    .brightness(dragState.isActive ? (colorScheme == .dark ? 0.06 : -0.06) : 0)
            }

            // Main part
            Content(displayContent: combinedOptions(mainIndex))
                .font(.system(size: 25))
                .foregroundStyle(dragState.isActive ? .clear : .primary)
                .frame(width: keyW, height: keyH)
                .background(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).fill(Color("AccentKeys1")))
                .overlay(dragState.isActive ? MenuView() : nil)
                .brightness(dragState.isActive ? (colorScheme == .dark ? 0.06 : -0.06) : 0)


            // Menu indicator
            if(!dragState.isActive && !isSingleKey) {
                Circle()
                    .fill(Color("AccentKeys2"))
                    .frame(width: 6, height: 6)
                    .offset(x: keyW / 2.0 - 8, y: -keyH / 2.0 + 8)
            }
        }
        .gesture(longPressDrag)
        .onChange(of: dragState.isDragging) { dragging in
            if (dragging && !isSingleKey) { hapticManager.wheel() }
        }
        .onChange(of: dragState.isActive) { active in
            if (!active) {
                if let s = selectionRecord {
                    typeIn(indexToKeyId(s))
                    selectionRecord = nil
                } else {
                    typeIn(main)
                }
            }
        }
    }
}

#Preview {
    KeyWithMenu()
}

