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
            fill: BG = .bg) -> some View {//🖌️🖌️ Color. XXX 来自 extension Color 的定义, 如果👇下面定义了  static var bg: Color { ... } 之后, 这里就不用加 Color 了！ 直接 .bg !!
                background(RoundedRectangle(cornerRadius: radius).fill(fill))// 因为圆角矩形原本就是形状，所以最好用 .fill
//                    .foregroundColor(fill as! Color)) //圆角矩形的背景, 用 ShapeStyle 来填充颜色
    }
}


extension Animation { //👈抽象出来的动画属性值
    static let smallSpring = Animation.spring(dampingFraction: 0.65)
    static let smallEase = Animation.easeInOut(duration: 0.3)
    
}


extension ShapeStyle where Self == Color {
    static var bg: Color { Color(.systemBackground) } //⚡️⚡️⚡️var 是计算属性，let 是静态属性！！
    static var bgBody: Color { Color(.secondarySystemBackground) }
    static var listBg: Color { Color(.systemGroupedBackground) } //食物清单 list 背景色
}


extension AnyTransition {
    
    static let moveUpOpacity = Self.move(edge: .top).combined(with: .opacity)
    
    static let delayInsertionOpacity = Self.asymmetric( //🔥分别设置进场、离场动画的动画曲线(需要有设置 id，不然 Swift 无法识别）
        insertion:
            .opacity
            .animation(.easeInOut(duration: 0.6).delay(0.2)),//进场
        removal:
            .opacity.animation(
            .easeInOut(duration: 0.3))) //离场
}
