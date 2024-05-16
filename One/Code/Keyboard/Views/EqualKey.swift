//
//  EqualKey.swift
//  One
//
//  Created by Tingwu on 2024/5/9.
//

import SwiftUI

struct EqualKey: View {
    @EnvironmentObject var inputFieldViewModel: InputFieldViewModel
    @ObservedObject var formulaViewModel: FormulaViewModel
    @StateObject var calculatorViewModel = CalculatorViewModel()
    @State var calculating: Bool = false
    @State var task: Task<Void, Error>?
//    @State var holdCalculationAnim: Bool = false

    var body: some View {
        Key(
            action: {
                // If input math formula is not empty
                if formulaViewModel.elements.count > 1 {
                    // Cancel previous task (Unsuccessful)
                    task?.cancel()

//                    print((task?.isCancelled)?.description ?? "nil")
                    task = Task {
                        do {
                            var result = ""
                            Task {
                                // If calculation takes longer than 0.5 seconds, show calculation animation
                                try await Task.sleep(nanoseconds: 300_000_000)
                                if calculating {
                                    inputFieldViewModel.setAFCalcStatus(.calculating)
                                }
                            }

                            // Display answer field to screen
                            inputFieldViewModel.setAnswerFieldExistence(true)

                            // Calculate
                            calculating = true
                            result = try await calculatorViewModel.evaluate(expression: formulaViewModel.elements)
                            try Task.checkCancellation()

                            calculating = false

                            // Put calculation result to answer field
                            inputFieldViewModel.setAFContentStatus(.answer)
                            inputFieldViewModel.setAFCalcStatus(.displaying)
                            inputFieldViewModel.setAnswerFieldContent(result)

                        } catch {
                            // Put error message to answer field
                            if let errorMessage = (error as? CalculationError)?.rawValue {
                                // Set answer field appearance
                                calculating = false
                                inputFieldViewModel.setAFContentStatus(.error)
                                inputFieldViewModel.setAFCalcStatus(.displaying)
                                inputFieldViewModel.setAnswerFieldContent(errorMessage)
                            } else {
                                print("Unknown error: \(error)")
                            }
                        }
                    }
                }
            },
            color: Color("AccentYellow"),
            darkAdjust: -0.1,
            defaultAdjust: -0.1
        ) {
            Image(systemName: "equal")
                .font(.system(size: 25))
        } shape: {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
        }
    }
}

#Preview {
    EqualKey(formulaViewModel: FormulaViewModel())
        .environmentObject(InputFieldViewModel())
}
