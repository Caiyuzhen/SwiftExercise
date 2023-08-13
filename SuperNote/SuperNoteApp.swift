//
//  SuperNoteApp.swift
//  SuperNote
//
//  Created by ai C on 2023/8/1.
//

import SwiftUI

@main
//App 入口文件, 需要设定一个 body 为 Scene  (基础结构: App -> Scene -> View)
struct SuperNoteApp: App {
    var body: some Scene {
        // 👇可以显示多个视窗(Scene)
        WindowGroup {
            // 👇模拟器中要预览的视图
            FoodListView()
            // ContentView()
        }
        // 另外一个视窗(Scene) DocumentGroup
        // 另外一个视窗(Scene) Setting
    }
    //add black background
}

