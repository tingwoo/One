//
//  SettingsSheetView.swift
//  One
//
//  Created by Tingwu on 2024/5/4.
//

import SwiftUI

struct SettingsSheetView: View {
    var body: some View {
        SettingsPage()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(RoundedCorner(radius: 15, corners: [.topLeft, .topRight]))
            .background(RoundedCorner(radius: 15, corners: [.topLeft, .topRight])
                .fill(.white.opacity(0.0001)).shadow(radius: 3))
            .transition(.move(edge: .bottom))
    }
}

private struct SettingsSheetPreview: View {
    @StateObject var sheetManager = SheetManager()
    @State var sheetHeight: CGFloat = 340

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Button {
                sheetManager.present()
            } label: {
                Text("Show sheet")
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.black.opacity(0.8))
                    }
            }

        }
        .overlay {
            ZStack(alignment: .bottom) {
                if sheetManager.action.isPresent {
                    Color.gray
                        .opacity(0.0001)
                        .onTapGesture {
                            sheetManager.dismiss()
//                            sheetHeight += 20
                        }
                }

                // Do NOT put .animation in if statements! https://stackoverflow.com/questions/72370959/swiftui-animation-only-works-with-withanimation-block-and-not-with-animation
                VStack {
                    if sheetManager.action.isPresent {
                        SettingsSheetView()
                            .frame(height: sheetHeight)
                    }
                }
                .animation(.smooth(duration: 0.4), value: sheetManager.action)
                .animation(.smooth(duration: 0.2), value: sheetHeight)
            }
        }
        .ignoresSafeArea()
    }
}

// https://stackoverflow.com/questions/56760335/how-to-round-specific-corners-of-a-view
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    SettingsSheetPreview()
}
