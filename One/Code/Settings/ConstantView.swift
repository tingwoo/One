//
//  ConstantView.swift
//  One
//
//  Created by Tingwu on 2024/5/2.
//

import SwiftUI

struct ConstantView: View {
    var constant: Constant
    var scale: CGFloat

    var body: some View {
        if let symbolMain = constant.main {
            HStack(alignment: .bottom, spacing: 2.0 * scale){
                Text(symbolMain.rawValue).font(.custom("CMUConcrete-Roman", size: 30 * scale).italic())

                if let symbolSub = constant.sub {
                    Text(symbolSub.rawValue).font(.custom("CMUConcrete-Roman", size: 16 * scale).bold())
                }
            }
        } else {
            RoundedRectangle(cornerRadius: 3 * scale, style: .continuous)
                .strokeBorder(.primary, lineWidth: 1 * scale)
                .frame(width: 28 * scale, height: 28 * scale)
        }
    }
}

struct ConstantValueView: View {
    var constant: Constant
    var scale: CGFloat
    var bgColorWhenEmpty: Color
    @FocusState var coefFocus: Bool
    @FocusState var expoFocus: Bool
    var touchEnable: Bool

    var body: some View {
        HStack(spacing: 5 * scale) {
            // Coefficient
            if let c = constant.coefValue, constant.isValidCoef {
                Text(c.decExpansionCutZeros(precision: 3))
                    .font(.custom("CMUConcrete-Roman", size: 30 * scale))
                    .background(RoundedRectangle(cornerRadius: 3 * scale, style: .continuous).fill(coefFocus ? Color("AccentYellow") : .clear))
                    .onTapGesture {
                        coefFocus = true
                    }
                    .allowsHitTesting(touchEnable)
            } else {
                RoundedRectangle(cornerRadius: 3 * scale, style: .continuous)
                    .strokeBorder(.black, lineWidth: 1 * scale)
                    .background(RoundedRectangle(cornerRadius: 3 * scale, style: .continuous).fill(coefFocus ? Color("AccentYellow") : bgColorWhenEmpty))
                    .frame(width: 40 * scale, height: 30 * scale)
                    .onTapGesture {
                        coefFocus = true
                    }
                    .allowsHitTesting(touchEnable)
            }

            Image(systemName: "multiply").font(.system(size: 20 * scale))

            // 10^n
            HStack(spacing: 3 * scale) {
                Text("10").font(.custom("CMUConcrete-Roman", size: 30 * scale))
                if let e = constant.expoValue, constant.isValidExpo {
                    Text(e.description)
                        .font(.custom("CMUConcrete-Roman", size: 16 * scale).bold())
                        .background(RoundedRectangle(cornerRadius: 3 * scale, style: .continuous).fill(expoFocus ? Color("AccentYellow") : .clear))
                        .offset(CGSize(width: 0, height: -10 * scale))
                        .onTapGesture {
                            expoFocus = true
                        }
                        .allowsHitTesting(touchEnable)
                } else {
                    RoundedRectangle(cornerRadius: 3 * scale, style: .continuous)
                        .strokeBorder(.black, lineWidth: 1 * scale)
                        .background(RoundedRectangle(cornerRadius: 3 * scale, style: .continuous).fill(expoFocus ? Color("AccentYellow") : bgColorWhenEmpty))
                        .frame(width: 16 * scale, height: 16 * scale)
                        .offset(CGSize(width: 0, height: -10 * scale))
                        .onTapGesture {
                            expoFocus = true
                        }
                        .allowsHitTesting(touchEnable)
                }
            }
        }
    }

//    func numberOrPlaceholder(show: Bool, number: String, width: CGFloat, height: CGFloat, focus: FocusState<Bool>.Binding) -> some View {
//        Group {
//            if show {
//                Text(number)
//                    .font(.custom("CMUConcrete-Roman", size: height * scale))
//                    .background(RoundedRectangle(cornerRadius: 3 * scale, style: .continuous).fill(focus.wrappedValue ? Color("AccentYellow") : .clear))
//                    .onTapGesture {
//                        foc
//                    }
//                    .allowsHitTesting(touchEnable)
//            } else {
//                RoundedRectangle(cornerRadius: 3 * scale, style: .continuous)
//                    .strokeBorder(.black, lineWidth: 1 * scale)
//                    .background(RoundedRectangle(cornerRadius: 3 * scale, style: .continuous).fill(focus ? Color("AccentYellow") : bgColorWhenEmpty))
//                    .frame(width: width * scale, height: height * scale)
//                    .onTapGesture {
//                        focus = true
//                    }
//                    .allowsHitTesting(touchEnable)
//            }
//        }
//    }
}

#Preview("Constant") {
    VStack {
        ForEach([Constant].example) { const in
            ConstantView(constant: const, scale: 2.0)
        }
    }
}

private struct ConstantValuePreview: View {
    @FocusState private var focus: Bool
    var body: some View {
        VStack {
            ForEach([Constant].example) { const in
                ConstantValueView(constant: const, scale: 1.5, bgColorWhenEmpty: .white, coefFocus: _focus, expoFocus: _focus, touchEnable: false)
            }
        }
    }
}

#Preview("Constant Value") {
    ConstantValuePreview()
}
