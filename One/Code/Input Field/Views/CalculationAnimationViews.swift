//
//  CalculationAnimationViews.swift
//  One
//
//  Created by Tingwu on 2024/05/17.
//

import SwiftUI

struct AnimationPhase: Equatable {
    var index: Int
    var animationPhase: Int
    var first: Double
    var second: Double
}

@available(iOS 17.0, *)
struct BarLoadingView: View {
    private let animPhases = [AnimationPhase(index: 0, animationPhase: 0, first: 0.0, second: 0.0),
                              AnimationPhase(index: 0, animationPhase: 1, first: 0.0, second: 1.0),
                              AnimationPhase(index: 0, animationPhase: 2, first: 1.0, second: 1.0)]
    var body: some View {
        PhaseAnimator(animPhases) { state in
            Bar()
                .digitStyle(from: state.first, to: state.second, strokeWidth: 25.0)
        } animation: { state in
            if state.animationPhase == 0 {
                return nil
            } else if state.animationPhase == 1 {
                return .easeInOut(duration: 0.8)
            } else {
                return .easeInOut(duration: 0.8)
            }
        }

    }

    struct Bar: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.0, y: 0.5 * height))
            path.addLine(to: CGPoint(x: 1.0 * width, y: 0.5 * height))
            return path
        }
    }
}

@available(iOS 17.0, *)
struct GlyphLoadingView: View {
    let numOfGlyphs: Int = 10
    @State private var height: CGFloat = 1.0

    private var gap: CGFloat {
        height * 0.1
    }

    private var width: CGFloat {
        gap * CGFloat(numOfGlyphs - 1) + 0.6 * height * CGFloat(numOfGlyphs)
    }

    var body: some View {
        HStack(spacing: gap) {
            ForEach(0..<numOfGlyphs, id: \.self) { i in
                GlyphAnimation()
            }
        }
        .overlay(content: {
            GeometryReader(content: { geometry in
                Color.clear
                    .onAppear {
                        height = geometry.size.height
                    }
            })
        })
        .aspectRatio(CGSize(width: width, height: height), contentMode: .fit)
    }
}

@available(iOS 17.0, *)
struct GlyphAnimation: View {
    private let digitList: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].shuffled()
    private let animPhases = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map({
        [AnimationPhase(index: $0, animationPhase: 0, first: 0.0, second: 0.0),
         AnimationPhase(index: $0, animationPhase: 1, first: 0.0, second: 0.0),
         AnimationPhase(index: $0, animationPhase: 2, first: 0.0, second: 1.0),
         AnimationPhase(index: $0, animationPhase: 3, first: 1.0, second: 1.0)]
    }).flatMap { $0 }

    var body: some View {
        PhaseAnimator(animPhases) { state in
            if digitList[state.index] == 0 {
                Digit0()
                    .digitStyle(from: state.first, to: state.second)
            } else if digitList[state.index] == 1 {
                Digit1()
                    .digitStyle(from: state.first, to: state.second)
            } else if digitList[state.index] == 2 {
                Digit2()
                    .digitStyle(from: state.first, to: state.second)
            } else if digitList[state.index] == 3 {
                Digit3()
                    .digitStyle(from: state.first, to: state.second)
            } else if digitList[state.index] == 4 {
                Digit4()
                    .digitStyle(from: state.first, to: state.second)
            } else if digitList[state.index] == 5 {
                Digit5()
                    .digitStyle(from: state.first, to: state.second)
            } else if digitList[state.index] == 6 {
                Digit6()
                    .digitStyle(from: state.first, to: state.second)
            } else if digitList[state.index] == 7 {
                Digit7()
                    .digitStyle(from: state.first, to: state.second)
            } else if digitList[state.index] == 8 {
                Digit8()
                    .digitStyle(from: state.first, to: state.second)
            } else {
                Digit9()
                    .digitStyle(from: state.first, to: state.second)
            }
        } animation: { state in
            if state.animationPhase == 0 {
                return nil
            } else if state.animationPhase == 1 {
                return nil
            } else if state.animationPhase == 2 {
                return .easeInOut(duration: 1.0)
            } else {
                return .easeInOut(duration: 1.0)
            }
        }

    }

    private struct Digit0: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.9082*width, y: 0.03482*height))
            path.addCurve(to: CGPoint(x: 0.19234*width, y: 0.52518*height), control1: CGPoint(x: 0.9082*width, y: 0.03482*height), control2: CGPoint(x: 0.44331*width, y: 0.31685*height))
            path.addCurve(to: CGPoint(x: 0.14661*width, y: 0.86244*height), control1: CGPoint(x: 0.05015*width, y: 0.64321*height), control2: CGPoint(x: 0.05221*width, y: 0.77822*height))
            path.addCurve(to: CGPoint(x: 0.55086*width, y: 0.97144*height), control1: CGPoint(x: 0.23593*width, y: 0.94213*height), control2: CGPoint(x: 0.39466*width, y: 0.98094*height))
            path.addCurve(to: CGPoint(x: 0.9082*width, y: 0.72676*height), control1: CGPoint(x: 0.79746*width, y: 0.95643*height), control2: CGPoint(x: 0.90753*width, y: 0.84677*height))
            path.addCurve(to: CGPoint(x: 0.9082*width, y: 0.24925*height), control1: CGPoint(x: 0.90907*width, y: 0.57202*height), control2: CGPoint(x: 0.9082*width, y: 0.24925*height))
            return path
        }
    }

    private struct Digit1: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()

            let height = rect.size.height
            let width = rect.size.width
            path.move(to: CGPoint(x: 0.88322*width, y: 0.02527*height))
            path.addLine(to: CGPoint(x: 0.88322*width, y: 0.2637*height))
            path.addCurve(to: CGPoint(x: 0.4828*width, y: 0.49906*height), control1: CGPoint(x: 0.88322*width, y: 0.41685*height), control2: CGPoint(x: 0.72177*width, y: 0.49906*height))
            path.addLine(to: CGPoint(x: 0.09575*width, y: 0.49906*height))
            path.addLine(to: CGPoint(x: 0.4828*width, y: 0.49906*height))
            path.addCurve(to: CGPoint(x: 0.88322*width, y: 0.73442*height), control1: CGPoint(x: 0.72177*width, y: 0.49906*height), control2: CGPoint(x: 0.88322*width, y: 0.58126*height))
            path.addLine(to: CGPoint(x: 0.88322*width, y: 0.97285*height))
            return path
        }
    }

    private struct Digit2: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.10605*width, y: 0.40756*height))
            path.addLine(to: CGPoint(x: 0.89353*width, y: 0.40756*height))
            path.move(to: CGPoint(x: 0.89353*width, y: 0.03024*height))
            path.addLine(to: CGPoint(x: 0.89353*width, y: 0.67221*height))
            path.addCurve(to: CGPoint(x: 0.52931*width, y: 0.97285*height), control1: CGPoint(x: 0.89353*width, y: 0.87189*height), control2: CGPoint(x: 0.79381*width, y: 0.96055*height))
            path.addCurve(to: CGPoint(x: 0.10605*width, y: 0.86065*height), control1: CGPoint(x: 0.3482*width, y: 0.98126*height), control2: CGPoint(x: 0.18087*width, y: 0.93596*height))
            return path
        }
    }

    private struct Digit3: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.64347*width, y: 0.03024*height))
            path.addLine(to: CGPoint(x: 0.76825*width, y: 0.25024*height))
            path.addLine(to: CGPoint(x: 0.91167*width, y: 0.50326*height))
            path.addCurve(to: CGPoint(x: 0.52376*width, y: 0.39208*height), control1: CGPoint(x: 0.91167*width, y: 0.50326*height), control2: CGPoint(x: 0.7888*width, y: 0.3838*height))
            path.addCurve(to: CGPoint(x: 0.07478*width, y: 0.67001*height), control1: CGPoint(x: 0.23232*width, y: 0.40119*height), control2: CGPoint(x: 0.07884*width, y: 0.53935*height))
            path.addCurve(to: CGPoint(x: 0.52376*width, y: 0.96626*height), control1: CGPoint(x: 0.06934*width, y: 0.84504*height), control2: CGPoint(x: 0.25754*width, y: 0.96626*height))
            path.addCurve(to: CGPoint(x: 0.91167*width, y: 0.83363*height), control1: CGPoint(x: 0.72493*width, y: 0.96626*height), control2: CGPoint(x: 0.86052*width, y: 0.90272*height))
            return path
        }
    }

    private struct Digit4: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.11078*width, y: 0.03974*height))
            path.addLine(to: CGPoint(x: 0.60199*width, y: 0.03974*height))
            path.addCurve(to: CGPoint(x: 0.89957*width, y: 0.21416*height), control1: CGPoint(x: 0.79226*width, y: 0.03974*height), control2: CGPoint(x: 0.88996*width, y: 0.11304*height))
            path.addCurve(to: CGPoint(x: 0.49381*width, y: 0.43766*height), control1: CGPoint(x: 0.9109*width, y: 0.3333*height), control2: CGPoint(x: 0.79446*width, y: 0.41443*height))
            path.addCurve(to: CGPoint(x: 0.07293*width, y: 0.70518*height), control1: CGPoint(x: 0.21651*width, y: 0.45909*height), control2: CGPoint(x: 0.07293*width, y: 0.56712*height))
            path.addCurve(to: CGPoint(x: 0.50341*width, y: 0.97361*height), control1: CGPoint(x: 0.07293*width, y: 0.86014*height), control2: CGPoint(x: 0.26582*width, y: 0.97361*height))
            path.addCurve(to: CGPoint(x: 0.92362*width, y: 0.70518*height), control1: CGPoint(x: 0.741*width, y: 0.97361*height), control2: CGPoint(x: 0.92362*width, y: 0.86014*height))
            path.addCurve(to: CGPoint(x: 0.75398*width, y: 0.4942*height), control1: CGPoint(x: 0.92362*width, y: 0.61415*height), control2: CGPoint(x: 0.85706*width, y: 0.54552*height))
            return path
        }
    }

    private struct Digit5: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.08726*width, y: 0.03482*height))
            path.addCurve(to: CGPoint(x: 0.08726*width, y: 0.26799*height), control1: CGPoint(x: 0.08726*width, y: 0.03482*height), control2: CGPoint(x: 0.08503*width, y: 0.16274*height))
            path.addCurve(to: CGPoint(x: 0.49979*width, y: 0.50154*height), control1: CGPoint(x: 0.08995*width, y: 0.39467*height), control2: CGPoint(x: 0.22384*width, y: 0.48219*height))
            path.addCurve(to: CGPoint(x: 0.91233*width, y: 0.7351*height), control1: CGPoint(x: 0.77575*width, y: 0.5209*height), control2: CGPoint(x: 0.90964*width, y: 0.60842*height))
            path.addCurve(to: CGPoint(x: 0.91233*width, y: 0.96827*height), control1: CGPoint(x: 0.91456*width, y: 0.84035*height), control2: CGPoint(x: 0.91233*width, y: 0.96827*height))
            path.move(to: CGPoint(x: 0.91332*width, y: 0.03482*height))
            path.addLine(to: CGPoint(x: 0.08627*width, y: 0.96827*height))
            return path
        }
    }

    private struct Digit6: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.91332*width, y: 0.96827*height))
            path.move(to: CGPoint(x: 0.88792*width, y: 0.03974*height))
            path.addLine(to: CGPoint(x: 0.3834*width, y: 0.03974*height))
            path.addCurve(to: CGPoint(x: 0.0871*width, y: 0.21661*height), control1: CGPoint(x: 0.21559*width, y: 0.03974*height), control2: CGPoint(x: 0.09667*width, y: 0.11408*height))
            path.addCurve(to: CGPoint(x: 0.49828*width, y: 0.43076*height), control1: CGPoint(x: 0.07582*width, y: 0.33742*height), control2: CGPoint(x: 0.20164*width, y: 0.43076*height))
            path.addCurve(to: CGPoint(x: 0.91019*width, y: 0.71452*height), control1: CGPoint(x: 0.77657*width, y: 0.43076*height), control2: CGPoint(x: 0.91019*width, y: 0.55738*height))
            path.addLine(to: CGPoint(x: 0.91019*width, y: 0.96827*height))
            path.move(to: CGPoint(x: 0.49828*width, y: 0.43076*height))
            path.addCurve(to: CGPoint(x: 0.08637*width, y: 0.71452*height), control1: CGPoint(x: 0.21998*width, y: 0.43076*height), control2: CGPoint(x: 0.08637*width, y: 0.55738*height))
            path.addLine(to: CGPoint(x: 0.08637*width, y: 0.96827*height))
            return path
        }
    }

    private struct Digit7: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.08141*width, y: 0.22765*height))
            path.addCurve(to: CGPoint(x: 0.49828*width, y: 0.02865*height), control1: CGPoint(x: 0.11325*width, y: 0.12889*height), control2: CGPoint(x: 0.2634*width, y: 0.02865*height))
            path.addCurve(to: CGPoint(x: 0.91376*width, y: 0.27219*height), control1: CGPoint(x: 0.76346*width, y: 0.02865*height), control2: CGPoint(x: 0.91376*width, y: 0.14488*height))
            path.addCurve(to: CGPoint(x: 0.44272*width, y: 0.52769*height), control1: CGPoint(x: 0.91376*width, y: 0.42663*height), control2: CGPoint(x: 0.75052*width, y: 0.52769*height))
            path.addLine(to: CGPoint(x: 0.12249*width, y: 0.52769*height))
            path.addLine(to: CGPoint(x: 0.86241*width, y: 0.97262*height))
            return path
        }
    }

    private struct Digit8: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.09362*width, y: 0.04039*height))
            path.addLine(to: CGPoint(x: 0.89127*width, y: 0.04039*height))
            path.move(to: CGPoint(x: 0.89127*width, y: 0.04039*height))
            path.addCurve(to: CGPoint(x: 0.51929*width, y: 0.3057*height), control1: CGPoint(x: 0.89127*width, y: 0.04039*height), control2: CGPoint(x: 0.71078*width, y: 0.16269*height))
            path.addCurve(to: CGPoint(x: 0.08452*width, y: 0.72062*height), control1: CGPoint(x: 0.28805*width, y: 0.4784*height), control2: CGPoint(x: 0.08452*width, y: 0.58081*height))
            path.addCurve(to: CGPoint(x: 0.50209*width, y: 0.97385*height), control1: CGPoint(x: 0.08452*width, y: 0.87755*height), control2: CGPoint(x: 0.26451*width, y: 0.97385*height))
            path.addCurve(to: CGPoint(x: 0.91204*width, y: 0.70201*height), control1: CGPoint(x: 0.73968*width, y: 0.97385*height), control2: CGPoint(x: 0.91204*width, y: 0.85894*height))
            return path
        }
    }

    private struct Digit9: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.09916*width, y: 0.05256*height))
            path.addLine(to: CGPoint(x: 0.09916*width, y: 0.9621*height))
            path.addLine(to: CGPoint(x: 0.90503*width, y: 0.9621*height))
            path.move(to: CGPoint(x: 0.09916*width, y: 0.39203*height))
            path.addCurve(to: CGPoint(x: 0.52738*width, y: 0.57687*height), control1: CGPoint(x: 0.14596*width, y: 0.52878*height), control2: CGPoint(x: 0.34301*width, y: 0.57687*height))
            path.addCurve(to: CGPoint(x: 0.87587*width, y: 0.4656*height), control1: CGPoint(x: 0.7014*width, y: 0.57687*height), control2: CGPoint(x: 0.81664*width, y: 0.54121*height))
            path.addCurve(to: CGPoint(x: 0.90503*width, y: 0.23965*height), control1: CGPoint(x: 0.90352*width, y: 0.43031*height), control2: CGPoint(x: 0.90503*width, y: 0.36377*height))
            path.addLine(to: CGPoint(x: 0.90503*width, y: 0.05256*height))
            return path
        }
    }
}

extension Shape {
    func digitStyle(from: CGFloat, to: CGFloat, strokeWidth: CGFloat = 2.0) -> some View {
        self
            .trim(from: from, to: to)
            .stroke(
//                Color("AccentAnswerFieldDark").gradient,
                Color("AccentAnswerFieldDark").opacity(0.5),
                style: StrokeStyle(lineWidth: strokeWidth, lineCap: .butt, lineJoin: .round)
            )
    }
}

#Preview("Bar") {
    if #available(iOS 17.0, *) {
        BarLoadingView()
    } else {
        Text("Not supported")
    }
}

#Preview("Glyph") {
    if #available(iOS 17.0, *) {
        GlyphLoadingView()
    } else {
        Text("Not supported")
    }
}
