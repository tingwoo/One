//
//  MainKeyboard.swift
//  One
//
//  Created by Tingwu on 2023/9/30.
//

import SwiftUI

struct MainKeyboard: View {
    @State var step: Int = 0
    @State var dragStep: CGFloat = 0
    
    var insertElements: (Int) -> () = {i in}
    
    var pickerHeight: CGFloat = 15.0
    var keySpacing: CGFloat = 8.0
    var keyboardCount: Int = 3
    
    func rubberBand(_ offset: CGFloat) -> CGFloat{
        // x / (2x+1)
        let cnt: CGFloat = CGFloat(keyboardCount)
        if(offset > cnt - 1) {
            return (offset - (cnt - 1)) / (2 * (offset - (cnt - 1)) + 1) + (cnt - 1)
        } else if (offset < 0) {
            return offset / (-2 * offset + 1)
        }
        return offset
    }
    
    var body: some View {
        Grid(horizontalSpacing: keySpacing, verticalSpacing: keySpacing) {
            if(keyboardCount > 1) {
                GridRow {
                    KeyboardPicker(selection: $step, numOfSegments: keyboardCount, height: pickerHeight, keySpacing: keySpacing)
                }
                .gridCellColumns(4)
            }
            
            ForEach(keyArrange[step].indices, id: \.self) { row in
                GridRow {
                    ForEach(keyArrange[step][row].indices, id: \.self) { item in
                        KeyWheel(
                            actions: Array(0..<keyboardCount).map { i -> (()->()) in
                                {insertElements(keyArrange[i][row][item])}
                            },
                            texts: Array(0..<keyboardCount).map({ keyList[keyArrange[$0][row][item]].text }),
                            images: Array(0..<keyboardCount).map({ keyList[keyArrange[$0][row][item]].image }),
                            intStep: step,
                            step: rubberBand(CGFloat(step) + dragStep)
                        )
                        .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.5), value: step)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.5), value: dragStep)
                    }
                }
            }
        }
        .gesture(
            DragGesture()
                
                .onChanged { value in
                    dragStep = -value.translation.width / 150.0
            }.onEnded { value in
                let tmp = Int(round(CGFloat(step) + dragStep))
                
//                withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.5)) {
//                withAnimation() {
                    if(tmp >= keyboardCount) {
                        step = keyboardCount - 1
                    } else if(tmp < 0) {
                        step = 0
                    } else {
                        step = tmp
                    }
                    dragStep = 0
//                }
            }
        )
    }
}

struct KeyWheel: View {
    @State var tapped: Bool = false
    
    var actions: [(() -> ())?]
    var texts: [String?]
    var images: [String?]
    
    var intStep: Int = 0
    var step: CGFloat = 0
    var radiusRatio: CGFloat = 2
    
    var angleShown = 3.14159 * 0.8
    var angleBetweenSymbols = 3.14159 * 0.5
    
    func radius(_ proxy: GeometryProxy) -> CGFloat {
        return (proxy.size.width / 2.0) / cos((3.14159 - angleShown) / 2.0)
    }
    
    func findAngle(step: CGFloat, index: Int) -> CGFloat {
        return 3.14159 / 2.0 + (step - CGFloat(index)) * angleBetweenSymbols
    }
    
    func findOffset(step: CGFloat, index: Int, proxy: GeometryProxy) -> CGFloat {
        let tmp = min(max(findAngle(step: step, index: index), 0), 3.14159)
        
        return radius(proxy) * cos(tmp)
    }
    
    func findScale(step: CGFloat, index: Int, proxy: GeometryProxy) -> CGFloat {
        let r = radius(proxy)
        let tmp = pow(r, 2) - pow(findOffset(step: step, index: index, proxy: proxy), 2)
        return sqrt(tmp > 0 ? tmp : 0) / r
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Color(tapped ? "AccentKeys2" : "AccentKeys1")
                ForEach(0..<texts.count, id: \.self) { i in
                    if let text = texts[i] {
                        Text(text)
                            .font(.system(size: 25))
                            .scaleEffect(x: findScale(step: step, index: i, proxy: geometry))
                            .offset(x: findOffset(step: step, index: i, proxy: geometry))
                    } else if let image = images[i] {
                        Image(systemName: image)
                            .font(.system(size: 25))
                            .scaleEffect(x: findScale(step: step, index: i, proxy: geometry))
                            .offset(x: findOffset(step: step, index: i, proxy: geometry))
                    } else {
                        Text("")
                            .font(.system(size: 25))
                            .scaleEffect(x: findScale(step: step, index: i, proxy: geometry))
                            .offset(x: findOffset(step: step, index: i, proxy: geometry))
                    }
                        
                        
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .onTapGesture { // key action
                if let action = actions[intStep] {
                    action()
                }
            }
            .onLongPressGesture(minimumDuration: .infinity) {
                tapped.toggle()
            } onPressingChanged: { bool in
                if bool { tapped = bool }
                else { withAnimation(.easeOut(duration: 0.15)) { tapped = bool } }
            }
            
        }
    }
}

#Preview {
    MainKeyboard()
}
