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
                                                             ("circle.righthalf.filled", "外觀"),
                                                             ("wave.3.right", "觸覺回饋"),
                                                             ("hand.draw", "操作"),
                                                             ("figure.child.circle", "輔助使用"),
                                                             ("bubble.left", "意見回饋"),
                                                             ("info.circle", "關於") ]

    private var aboutPageItems: [(symbol: String, title: String)] = [ ("person", "開發者"),
                                                                      ("star", "評分"),
                                                                      ("hand.raised", "隱私權政策") ]
//                                                                      ("heart", "鳴謝與版權資訊") ]

    @State private var path: [String] = []
    @AppStorage("rightHanded") private var rightHanded = true
    @AppStorage("clearButtonInsteadOfSwitch") private var clearButton = false

    let keySpacing: CGFloat = 7.0
    func keyW(_ cnt: CGFloat = 1.0) -> CGFloat {
        return ((UIScreen.main.bounds.width - keySpacing * 7) / 6) * cnt + keySpacing * (cnt - 1)
    }

    var body: some View {

        VStack(spacing: 0) {
            Text(path.last ?? "設定")
                .bold()
                .frame(maxWidth: .infinity, minHeight: 45, maxHeight: 45)
                .background(Color("AccentSettingsBackground"))
                .animation(.easeInOut(duration: 0.2), value: path)

            ZStack(alignment: .bottom) {
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
                                Toggle(isOn: $clearButton) {
                                    Text("將清除拉桿替換為按鈕")
                                }
                                .tint(Color("AccentYellow"))

                            }
                            .background(Color("AccentSettingsBackground"))
                            .scrollContentBackground(.hidden)
                            .navigationBarBackButtonHidden(true)

                        } else if (item == "關於") {
                            List(aboutPageItems, id: \.title) { item in
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
                            .navigationBarBackButtonHidden(true)
                            .listRowSpacing(12)

                        } else {
                            Text(item)
                                .navigationBarBackButtonHidden(true)
                        }
                    }

                }


                HStack {
                    Key(
                        action: { if path.count != 0 { path.remove(at: path.count - 1) }  },
                        color: Color("AccentKeys2"),
                        darkAdjust: -0.1,
                        defaultAdjust: -0.1
                    ) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 22, weight: .medium))
                    } shape: {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                    }
                    .frame(width: keyW(1), height: 50)

                    VStack { }
                    .frame(width: 1, height: 50)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(8)
                .opacity(path.isEmpty ? 0 : 1)
                .animation(.easeInOut(duration: 0.2), value: path)
            }
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
