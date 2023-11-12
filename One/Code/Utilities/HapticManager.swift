//
//  HapticManager.swift
//  One
//
//  Created by Tingwu on 2023/9/14.
//
//  https://medium.com/@ganeshrajugalla/swiftui-haptics-a09830c8ef63

import Foundation
import SwiftUI

class HapticManager {
    static let instance = HapticManager()
    private init() {}

    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    func wheel() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
