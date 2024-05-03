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
        .navigationTitle("常數")
        .navigationBarTitleDisplayMode(.inline)
        .listRowSpacing(12)
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
                    .frame(minWidth: max(38, maxWidth), minHeight: max(38, maxWidth))
                    .padding(6)
//                    .offset(x: -1)
                    .background {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(Color("AccentKeys1"))
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

private struct ConstantListPreview: View {
    var body: some View {
        NavigationStack {
            ConstantListView()
                .navigationDestination(for: Constant.self) { const in
                    ConstantEditPage(edittingConst: const)
                        .padding()
                        .navigationTitle("Edit")
                }
        }
    }
}

#Preview {
    ConstantListPreview()
}
