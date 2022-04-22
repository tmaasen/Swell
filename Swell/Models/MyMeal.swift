//
//  MyMeals.swift
//  Swell
//
//  Created by Tanner Maasen on 4/20/22.
//

import Foundation

struct MyMeal {
    // From FDC
    var foodId: String?
    var dateAdded: String?
    // For custom foods
    var name: String?
    var ingredients: [String?]
    var nutrientName: String?
    var nutrientValue: [String? : Int?]
    var instruction: String?
    var includes: String?
}
