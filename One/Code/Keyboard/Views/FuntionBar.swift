//
//  FuntionBar.swift
//  One
//
//  Created by Tingwu on 2023/10/8.
//

import SwiftUI

struct funtionBar: View {
    @State private var showSettings = false
    @Binding var keyboardSelection: Int
    @AppStorage("rightHanded") private var rightHanded = true
    @AppStorage("clearButtonInsteadOfSwitch") private var useClearButton = false

    var keyboardCount: Int = 3
    var clearAction: () -> ()
    var height: CGFloat = 40
    var moduleWidth: CGFloat = 90
    var moduleGap: CGFloat { moduleWidth - 2 * height}

    var body: some View {
        HStack(spacing: moduleGap * 1.5) {
            if rightHanded {
                HStack {
                    settingsButton(showSettings: $showSettings)
                    Spacer()
                    historyButton()
                }
                .frame(width: moduleWidth, height: height)
            } else {
                if useClearButton {
                    clearButton(clearAction: clearAction).frame(width: moduleWidth, height: height)
                } else {
                    ClearSwitch(action: clearAction).frame(width: moduleWidth, height: height)
                }
            }

            KeyboardPicker(
                selection: $keyboardSelection,
                numOfSegments: keyboardCount,
                touchAreaH: height,
                spacing: 7.0
            )

            if rightHanded {
                if useClearButton {
                    clearButton(clearAction: clearAction).frame(width: moduleWidth, height: height)
                } else {
                    ClearSwitch(action: clearAction).frame(width: moduleWidth, height: height)
                }
            } else {
                HStack {
                    settingsButton(showSettings: $showSettings)
                    Spacer()
                    historyButton()
                }
                .frame(width: moduleWidth, height: height)
            }
        }
    }

    private struct settingsButton: View {
        @Binding var showSettings: Bool

        var body: some View {
            Key(action: { showSettings.toggle() }, color: Color("AccentKeys1")) {
                Image(systemName: "gearshape")
                    .font(.system(size: 20, weight: .medium))
            } shape: {
                Circle()
            }
            .sheet(isPresented: $showSettings) {
                SettingsPage()
                    .presentationDetents([.height(340)])
    //                        .presentationBackground(.thinMaterial) // iOS 16.4 up
    //                        .presentationCornerRadius(16)
            }
        }
    }

    private struct historyButton: View {
        @State private var showHistory = false

        var body: some View {
            Key(action: {}, color: Color("AccentKeys1")) {
                Image(systemName: "clock")
                    .font(.system(size: 20, weight: .medium))
            } shape: { Circle() }
        }
    }

    private struct clearButton: View {
        @EnvironmentObject var inputFieldViewModel: InputFieldViewModel

        var clearAction: () -> ()
        let hapticManager = HapticManager.instance

        var body: some View {
            Key(action: {
                clearAction()
                hapticManager.impact(style: .medium)
                inputFieldViewModel.setAnswerFieldExistence(false)
                inputFieldViewModel.setAnswerFieldContent("")
            }, color: Color("AccentKeys1")) {
                Image(systemName: "trash")
                    .font(.system(size: 20, weight: .medium))
            } shape: {
                Capsule()
            }
        }
    }
}

#Preview {
    funtionBar(keyboardSelection: .constant(0), clearAction: {})
        .environmentObject(InputFieldViewModel())
}

