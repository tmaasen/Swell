//
//  FoodRetriever.swift
//  Swell
//
//  Created by Tanner Maasen on 2/27/22.
//

import Foundation
import SwiftUI

//struct FoodRetriever: Codable, Identifiable {
//    var id = UUID()
//    var docId: String?
//    var foodName: String?
//    var mealType: String?
//    var servingSize: Int?
//    var mood: String?
//    var comments: String?
//    var waterOuncesToday: Double?
//    var waterLoggedToday: Int?
//    var fdcID: Int?
//    var description, dataType, publicationDate: String?
//    var foodCode: String?
//    var foodNutrients: [FoodNutrient]?
//    var ndbNumber: String?
//    var labelNutrients: [LabelNutrient]?
//
//    enum CodingKeys: String, CodingKey {
//        case fdcID = "fdcId"
//        case description = "description"
//        case dataType, publicationDate, foodCode, foodNutrients, ndbNumber
//    }
//}
//
//extension FoodRetriever {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(FoodRetriever.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        fdcID: Int? = nil,
//        description: String? = nil,
//        dataType: String? = nil,
//        publicationDate: String? = nil,
//        foodCode: String?? = nil,
//        foodNutrients: [FoodNutrient]? = nil,
//        ndbNumber: String?? = nil
//    ) -> FoodRetriever {
//        return FoodRetriever(
//            fdcID: fdcID ?? self.fdcID,
//            description: description ?? self.description,
//            dataType: dataType ?? self.dataType,
//            publicationDate: publicationDate ?? self.publicationDate,
//            foodCode: foodCode ?? self.foodCode,
//            foodNutrients: foodNutrients ?? self.foodNutrients,
//            ndbNumber: ndbNumber ?? self.ndbNumber,
//            labelNutrients: labelNutrients ?? self.labelNutrients
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//struct LabelNutrient: Codable {
//    var value: Double
//}
//
//extension LabelNutrient {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(LabelNutrient.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        value: Double? = nil
//    ) -> LabelNutrient {
//        return LabelNutrient(
//            value: value ?? self.value
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//enum DerivationCode: String, Codable {
//    case a = "A"
//    case nc = "NC"
//    case z = "Z"
//}
//
//enum UnitName: String, Codable {
//    case g = "G"
//    case iu = "IU"
//    case kJ = "kJ"
//    case mg = "MG"
//    case ug = "UG"
//}


// MARK: - Food
struct FoodRetriever: Codable, Identifiable {
    var id = UUID()
    var docId: String?
    var foodName: String?
    var mealType: String?
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
    var servingSize: Int?
    var servingSizeUnit, packageWeight: String?
    var foodUpdateLog: [FoodRetriever]?
    var labelNutrients: LabelNutrients?

    enum CodingKeys: String, CodingKey {
        case discontinuedDate, foodComponents, foodAttributes, foodPortions
        case fdcID = "fdcId"
        case foodDescription = "description"
        case publicationDate, foodNutrients, dataType, foodClass, modifiedDate, availableDate, brandOwner, brandName, dataSource, brandedFoodCategory, gtinUpc, ingredients, marketCountry, servingSize, servingSizeUnit, packageWeight, foodUpdateLog, labelNutrients
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
