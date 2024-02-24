//
//  SettingsPage.swift
//  One
//
//  Created by Tingwu on 2023/12/13.
//

import SwiftUI

struct SettingsPagePicker: View {
    @Binding var selectedIndex: Int
    var options: [String] = ["左", "右"]
    var withHaptics: Bool = true

    private let hapticManager = HapticManager.instance


    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { i in
                Text(options[i])
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(selectedIndex == i ? Color("AccentKeysBackground") : Color("AccentKeysBackground").opacity(0.0001))
                    )
                    .onTapGesture {
                        selectedIndex = i
                        if withHaptics { hapticManager.impact(style: .light) }
                    }
                    .animation(.easeInOut(duration: 0.15), value: selectedIndex)
            }
        }
        .padding(3)
        .background(RoundedRectangle(cornerRadius: 6, style: .continuous).fill(Color("AccentKeys1")))
    }
}

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
//                                                             ("questionmark.diamond", "測試") ]

    private var aboutPageItems: [(symbol: String, title: String)] = [ ("person", "開發者"),
                                                                      ("star", "評分"),
                                                                      ("hand.raised", "隱私權政策") ]
//                                                                      ("heart", "鳴謝與版權資訊") ]

    @State private var path: [String] = []
    @AppStorage("rightHanded") private var rightHanded = 1
    @AppStorage("clearButtonInsteadOfSwitch") private var clearButton = false

    let keySpacing: CGFloat = 7.0

//    var rightHandedOption: Binding<Int> {
//        get {
//            return rightHanded ? 1 : 0
//        }
//        set {
//            rightHanded = (newValue == 1)
//        }
//    }

    func keyW(_ cnt: CGFloat = 1.0) -> CGFloat {
        return ((UIScreen.main.bounds.width - keySpacing * 7) / 6) * cnt + keySpacing * (cnt - 1)
    }

    var body: some View {

        VStack(spacing: 0) {
//            Text(path.last ?? "設定")
//                .bold()
//                .frame(maxWidth: .infinity, minHeight: 45, maxHeight: 45)
//                .background(Color("AccentSettingsBackground"))
//                .animation(.easeInOut(duration: 0.2), value: path)

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
            .frame(maxWidth: .infinity, minHeight: 45, maxHeight: 45)
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
                    if (item == "常數") {
                        

                    } else if (item == "操作") {
                        List {
//                                Toggle(isOn: $rightHanded) {
//                                    Text("右手操作")
//                                }
//                                .tint(Color("AccentYellow"))

                            HStack {
                                Text("慣用手")
                                Spacer()
                                SettingsPagePicker(selectedIndex: $rightHanded, options: ["左", "右"]).frame(width: 150)
                            }

                        }
                        .background(Color("AccentSettingsBackground"))
                        .scrollContentBackground(.hidden)
                        .navigationBarBackButtonHidden(true)
                        .listRowSpacing(12)

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
//    ZStack{
//        Color.gray.opacity(0.2)
//        SettingsPagePicker()
//    }
}
