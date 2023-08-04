//
//  Foods.swift
//  FoodPicker
//
//  Created by Jane Chao on 22/10/09.
//

struct Foods: Equatable {
    var name: String
    var image: String
    var calorie: Double
    var carb: Double
    var fat: Double
    var protein: Double
    
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
