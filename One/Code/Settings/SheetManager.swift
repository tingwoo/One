//
//  PopUpManager.swift
//  One
//
//  Created by Tingwu on 2024/5/4.
//

import Foundation

class SheetManager: ObservableObject {
    enum Action {
        case na
        case present
        case dismiss

        var isPresent: Bool {
            self == .present
        }
    }

    @Published private(set) var action: Action = .na

    func present() {
//        guard !action.isPresent else {
//            return
//        }
        action = .present
    }

    func dismiss() {
        action = .dismiss
    }


}
