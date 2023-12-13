//
//  SettingsPage.swift
//  One
//
//  Created by Tingwu on 2023/12/13.
//

import SwiftUI

struct SettingsPage: View {
    private var icons: [(symbol: String, title: String)] = [ ("rectangle.grid.2x2", "鍵盤排列"), 
                                                             ("number", "常數"),
                                                             ("textformat.123", "數字樣式"),
                                                             ("sun.max", "外觀"),
                                                             ("wave.3.right", "觸覺回饋"),
                                                             ("hand.draw", "操作"),
                                                             ("figure.child.circle", "輔助使用"),
                                                             ("bubble.left", "意見回饋"),
                                                             ("info.circle", "關於") ]

//    @State private var PageTitle: String = []
    @State private var path: [String] = []
//    @Environment(\.dismiss) private var dismiss

    var body: some View {

        VStack(spacing: 0) {
            ZStack {
                if !path.isEmpty {
                    HStack {
                        Button(action: { path = .init() }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 22, weight: .medium))
                                .padding()
                        }
                        Spacer()
                    }
                }
                Text(path.last ?? "設定").bold()

            }
            .frame(height: 50)
            .animation(.easeInOut(duration: 0.1), value: path)

            NavigationStack(path: $path) {
                List(icons, id: \.title) { item in
    //                Section {
                    NavigationLink(value: item.title) {
                        HStack(spacing: 15) {
                            Image(systemName: item.symbol)
                                .frame(width: 20)
                            Text(item.title)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .listRowSpacing(13)
    //            .toolbar {
    //                ToolbarItem(placement: .principal) {
    //                    Text("設定").bold()
    //                }
    //            }
                .navigationDestination(for: String.self) { item in
                    Text(item)
                        .navigationBarBackButtonHidden(true)
    //                    .toolbar {
    //                        ToolbarItem(placement: .topBarLeading) {
    //                            Button(action: { path = .init() }) {
    //                                Image(systemName: "arrow.left.circle.fill")
    //                            }
    //                        }
    //
    //                        ToolbarItem(placement: .principal) {
    //                            Text(item).bold()
    //                        }
    //                    }
                }

            }
            .onChange(of: path, perform: { value in
                print(value)
            })
        }

    }
}

// What wizardry is this?? https://stackoverflow.com/questions/59234958/swiftui-navigationbarbackbuttonhidden-swipe-back-gesture

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

#Preview {
    SettingsPage()
}
