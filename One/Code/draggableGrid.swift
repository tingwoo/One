//
//  draggableGrid.swift
//  One
//
//  Created by Tingwu on 2024/5/25.
//

import SwiftUI


struct KeyHolder: Identifiable, Equatable {
    var id: Int
    var number: Int? // change to Key
}


struct draggableGrid: View {


    let columns = Array(repeating: GridItem(.flexible()), count: 6)

    @StateObject var itemsData = ItemViewModel()

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(itemsData.items, id: \.self) { item in
                Text(item)
                    .font(.system(size: 25))
                    .frame(maxWidth: .infinity, minHeight: 30)
                    .padding(8)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(itemsData.hoverItem == item ? Color.blue : Color.gray))
                    .onDrag({
                        let draggedItem = NSItemProvider(object: NSString(string: item))
                        draggedItem.suggestedName = item

                        itemsData.currentDraggedItem = item

                        return draggedItem
                    })
                    .onDrop(of: [.text], delegate: DropViewDelegate(item: item, itemsData: itemsData))
                    .animation(.default, value: itemsData.hoverItem)

            }
        }
        .padding(10)
    }
}

class ItemViewModel: ObservableObject {
    @Published var items = Array(0..<24).map({ String($0) })
    @Published var currentDraggedItem: String? = nil
    @Published var currentExchangedItem: String? = nil
    @Published var isInExchange: Bool = false
    @Published var hoverItem: String?

    func swap(_ from: Int, _ to: Int) {
        print("swap")
        if from < 0 || from >= items.count || to < 0 || to >= items.count {
            return
        }

        let tmpItem = items[from]
        items[from] = items[to]
        items[to] = tmpItem
    }
}

struct DropViewDelegate: DropDelegate {
    var item: String
    var itemsData: ItemViewModel

    func performDrop(info: DropInfo) -> Bool {
        print("performDrop")

        let fromIndex = itemsData.items.firstIndex(of: itemsData.currentDraggedItem ?? "-1") ?? -1
        let toIndex = itemsData.items.firstIndex(of: self.item) ?? -1

        // If enter self, do nothing


        // If enter others, exchange

        if fromIndex != toIndex {
            withAnimation(.default) {
                itemsData.swap(fromIndex, toIndex)
            }

        }

        itemsData.hoverItem = nil
        return true
    }

    func dropEntered(info: DropInfo) {
        print("enter")
        itemsData.hoverItem = item
    }

    func dropExited(info: DropInfo) {
        print("left")
        itemsData.hoverItem = nil
    }

    func validateDrop(info: DropInfo) -> Bool {
        print("validateDrop")
        return true
    }
}

#Preview {
    draggableGrid()
}
