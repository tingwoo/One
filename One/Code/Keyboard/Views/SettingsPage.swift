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

    @State private var path: [String] = []
    @AppStorage("rightHanded") private var rightHanded = true
    @AppStorage("clearButtonInsteadOfSwitch") private var clearButton = false

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
            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
//            .frame(width: nil, height: 50)
            .background(Color("AccentSettingsBackground"))
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
                .background(Color("AccentSettingsBackground"))
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .listRowSpacing(12)
                .navigationDestination(for: String.self) { item in
                    if (item == "操作") {
                        List {
                            Toggle(isOn: $rightHanded) {
                                Text("右手操作")
                            }
                            .tint(Color("AccentYellow"))
                        }
                        .background(Color("AccentSettingsBackground"))
                        .scrollContentBackground(.hidden)
                        .navigationBarBackButtonHidden(true)

                    } else if (item == "輔助使用") {
                        List {
                            Section {
                                Toggle(isOn: $clearButton) {
                                    Text("將清除拉桿替換為按鈕")
                                }
                                .tint(Color("AccentYellow"))
                            } footer: {
                                Text("說明文字")
                            }

                        }
                        .background(Color("AccentSettingsBackground"))
                        .scrollContentBackground(.hidden)
                        .navigationBarBackButtonHidden(true)

                    } else {
                        Text(item)
                            .navigationBarBackButtonHidden(true)
                    }
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
