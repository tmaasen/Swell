//
//  FoodRetriever.swift
//  Swell
//
//  Created by Tanner Maasen on 2/27/22.
//

import Foundation
import SwiftUI

struct FoodRetriever: Codable, Identifiable {
    var id = UUID()
    var docId: String?
    var foodName: String?
    var mealType: String?
    var quantity: Int?
    var mood: String?
    var comments: String?
    var waterOuncesToday: Double?
    var waterLoggedToday: Int?
    var discontinuedDate: String?
    var foodComponents: [JSONAny]?
    var foodAttributes: [FoodAttribute]?
    var foodPortions: [JSONAny]?
    var fdcID: Int?
    var foodDescription, publicationDate: String?
    var foodNutrients: [FoodResultNutrient]?
    var dataType, foodClass, modifiedDate, availableDate: String?
    var brandOwner, brandName, dataSource, brandedFoodCategory: String?
    var gtinUpc, ingredients, marketCountry: String?
    var servingSize: Double?
    var servingSizeUnit, packageWeight: String?
    var foodUpdateLog: [FoodRetriever]?
    var labelNutrients: LabelNutrients?
    var householdServingFullText: String?
    var subbrandName, notaSignificantSourceOf: String?

    enum CodingKeys: String, CodingKey {
        case discontinuedDate, foodComponents, foodAttributes, foodPortions
        case fdcID = "fdcId"
        case foodDescription = "description"
        case publicationDate, foodNutrients, dataType, foodClass, modifiedDate, availableDate, brandOwner, brandName, dataSource, brandedFoodCategory, gtinUpc, ingredients, marketCountry, servingSize, servingSizeUnit, packageWeight, foodUpdateLog, labelNutrients, householdServingFullText, subbrandName, notaSignificantSourceOf
    }
}

// MARK: - FoodAttribute
struct FoodAttribute: Codable {
    var id, value: Int?
    var name: String?
}

// MARK: - FoodNutrient
struct FoodResultNutrient: Codable, Hashable {
    static func == (lhs: FoodResultNutrient, rhs: FoodResultNutrient) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(type)
    }
    
    var type: String?
    var nutrient: Nutrient?
    var foodNutrientDerivation: FoodNutrientDerivation?
    var id: Int?
    var amount: Double?
}

// MARK: - FoodNutrientDerivation
struct FoodNutrientDerivation: Codable {
    var id: Int?
    var code, foodNutrientDerivationDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, code
        case foodNutrientDerivationDescription = "description"
    }
}

// MARK: - Nutrient
struct Nutrient: Codable {
    var id: Int?
    var number, name: String?
    var rank: Int?
    var unitName: String?
}

// MARK: - LabelNutrients
struct LabelNutrients: Codable {
    var fat, saturatedFat, cholesterol, sodium: Calcium?
    var carbohydrates, fiber, sugars, calcium: Calcium?
    var iron, potassium, calories: Calcium?
}

// MARK: - Calcium
struct Calcium: Codable {
    var value: Double?
}
