//
//  Extensions.swift
//  SuperNote
//
//  Created by ai C on 2023/8/9.
//

import SwiftUI


extension View { //👈抽象出【主按钮】的样式
    func mainBtnStyle() -> some View {
        buttonStyle(.borderedProminent)
        .cornerRadius(12)
        .padding(.bottom, +4)
        //.background(customColor)
    }
    
    func roundRectBg<BG: ShapeStyle>(
            radius: CGFloat = 12,
            fill: BG = Color.bg) -> some View {//🖌️🖌️ Color. XXX 来自 extension Color 的定义
                background(RoundedRectangle(cornerRadius: radius)
                    .foregroundColor(fill as! Color)) //圆角矩形的背景, 用 ShapeStyle 来填充颜色
    }
}


extension Animation { //👈抽象出来的动画属性值
    static let smallSpring = Animation.spring(dampingFraction: 0.65)
    static let smallEase = Animation.easeInOut(duration: 0.3)
    
}


extension Color {
    static let bg = Color(.systemBackground)
    static let bgBody = Color(.secondarySystemBackground)
}


extension AnyTransition {
    
    static let moveUpOpacity = Self.move(edge: .top).combined(with: .opacity)
    
    static let delayInsertionOpacity = Self.asymmetric( //🔥分别设置进场、离场动画的动画曲线(需要有设置 id，不然 Swift 无法识别）
        insertion:
            .opacity
            .animation(.easeInOut(duration: 0.6).delay(0.2)),//进场
        removal:
            .opacity.animation(
            .easeInOut(duration: 0.9))) //离场
}
