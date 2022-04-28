//
//  MyMeals.swift
//  Swell
//
//  Created by Tanner Maasen on 4/20/22.
//

import Foundation

struct MyMeal: Identifiable, Comparable, Hashable {
    static func < (lhs: MyMeal, rhs: MyMeal) -> Bool {
        return true
    }
    
    static func == (lhs: MyMeal, rhs: MyMeal) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
    
    var id = UUID()
    // For FDC
    var foodId: String?
    var foodInfo: FoodRetriever?
    // For FDC & custom foods
    var date: String?
    var name: String?
    var isCustomMeal: Bool?
    var foodCategory: String?
    var mealType: String?
    var docId: String?
    // when retrieving foods
    var mood: String?
    var comments: String?
    var quantity: Int?
    var highIn: [String]?
    var contains: [String]?
    // For custom foods
    var ingredientNames: [String]?
    var ingredientValues: [String]?
    var nutrientNames: [String]?
    var nutrientValues: [String]?
    var instructions: String?
    var includes: String?
}
