//
//  ConstantListView.swift
//  One
//
//  Created by Tingwu on 2024/5/3.
//

import SwiftUI

struct ConstantListView: View {
    @State var constantList: [Constant] = [Constant].example
    @State var maxWidth: CGFloat = 0

    var body: some View {
        NavigationStack {
            List {
                ForEach(constantList, content: constantRow)
                .onDelete { indexSet in
                    for ind in indexSet {
                        constantList.remove(at: ind)
                    }
                }.onMove { indices, newOffset in
                    constantList.move(fromOffsets: indices, toOffset: newOffset)
                }

            }
            .navigationTitle("Constants")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Constant.self) { const in
                ConstantEditPage(edittingConst: const)
                    .padding()
                    .navigationTitle("Edit")
//                    .toolbar {
//                        ToolbarItem(placement: .confirmationAction) {
//                            Button("儲存") {
//
//                            }
//                        }
//                    }
            }
            .listRowSpacing(12)
        }
    }

    func constantRow(const: Constant) -> some View {
        NavigationLink(value: const) {
            HStack(spacing: 12) {
                ConstantView(constant: const, scale: 0.8)
                    .background(GeometryReader { proxy in
                        Color
                            .clear
                            .onAppear {
                                maxWidth = max(proxy.size.width, maxWidth)
                            }
                    })
                    .frame(minWidth: maxWidth, minHeight: maxWidth)
                    .padding(6)
//                    .offset(x: -1)
                    .background {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
                    }

                VStack(alignment: .leading, spacing: 6) {
                    Text(const.name).font(.subheadline)
                    ConstantValueView(constant: const, scale: 0.75, bgColorWhenEmpty: .clear, touchEnable: false)
                }
            }
        }
    }

    func constantRow2(const: Constant) -> some View {
        NavigationLink(value: const) {
            VStack(alignment:.leading, spacing: 6) {
                Text(const.name).font(.subheadline)

                HStack {
                    ConstantView(constant: const, scale: 0.75)
                    Image(systemName: "equal").font(.system(size: 20 * 0.75))
                    ConstantValueView(constant: const, scale: 0.75, bgColorWhenEmpty: .clear, touchEnable: false)
                }
            }
        }
    }
}

#Preview {
    ConstantListView()
}
