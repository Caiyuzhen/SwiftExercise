//
//  Foods.swift
//  FoodPicker
//
//  Created by Jane Chao on 22/10/09.
//
import Foundation

@propertyWrapper struct Suffix: Equatable {
    var wrappedValue: Double
    private let suffix: String
    
    init(wrappedValue: Double, _ suffix: String) {
        self.wrappedValue = wrappedValue
        self.suffix = suffix
    }
    
    var projectedValue: String {
        wrappedValue.formatted() + " \(suffix)"
    }
}



struct Foods: Equatable, Identifiable { // Identifiable 用来定义 id
    let id = UUID() //需要 import Foundation 才行
    var name: String
    var image: String
//    var calorie: Double
//    var carb: Double
//    var fat: Double
//    var protein: Double
    @Suffix("大卡") var calorie: Double = .zero
    @Suffix("g") var carb: Double = .zero //计算属性, 处理后缀, 要配合上面的 @propertyWrapper struct Suffix: Equatable} 的定义！避免让 view 来做 formatted() 这件事
    @Suffix("g") var fat: Double = .zero //计算属性, 要配合上面的 @propertyWrapper struct Suffix: Equatable} 的定义！避免让 view 来做 formatted() 这件事
    @Suffix("g") var protein: Double = .zero //计算属性, 要配合上面的 @propertyWrapper struct Suffix: Equatable} 的定义！避免让 view 来做 formatted() 这件事
    
    
    static let examples = [
        Foods(name: "漢堡", image: "🍔", calorie: 294, carb: 14, fat: 24, protein: 17),
        Foods(name: "沙拉", image: "🥗", calorie: 89, carb: 20, fat: 0, protein: 1.8),
        Foods(name: "披薩", image: "🍕", calorie: 266, carb: 33, fat: 10, protein: 11),
        Foods(name: "義大利麵", image: "🍝", calorie: 339, carb: 74, fat: 1.1, protein: 12),
        Foods(name: "雞腿便當", image: "🍗🍱", calorie: 191, carb: 19, fat: 8.1, protein: 11.7),
        Foods(name: "刀削麵", image: "🍜", calorie: 256, carb: 56, fat: 1, protein: 8),
        Foods(name: "火鍋", image: "🍲", calorie: 233, carb: 26.5, fat: 17, protein: 22),
        Foods(name: "牛肉麵", image: "🐄🍜", calorie: 219, carb: 33, fat: 5, protein: 9),
        Foods(name: "關東煮", image: "🥘", calorie: 80, carb: 4, fat: 4, protein: 6),
    ]
}
