//
//  FoodRetriever.swift
//  Swell
//
//  Created by Tanner Maasen on 2/27/22.
//

import Foundation

struct FoodRetriever: Codable, Identifiable {
    var id = UUID()
    var mealType: String?
    var servingSize: Int?
    var fdcID: Int?
    var description, dataType, publicationDate: String?
    var foodCode: String?
    var foodNutrients: [FoodNutrient]?
    var ndbNumber: String?

    enum CodingKeys: String, CodingKey {
        case fdcID = "fdcId"
        case description = "description"
        case dataType, publicationDate, foodCode, foodNutrients, ndbNumber
    }
}

extension FoodRetriever {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FoodRetriever.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        fdcID: Int? = nil,
        description: String? = nil,
        dataType: String? = nil,
        publicationDate: String? = nil,
        foodCode: String?? = nil,
        foodNutrients: [FoodNutrient]? = nil,
        ndbNumber: String?? = nil
    ) -> FoodRetriever {
        return FoodRetriever(
            fdcID: fdcID ?? self.fdcID,
            description: description ?? self.description,
            dataType: dataType ?? self.dataType,
            publicationDate: publicationDate ?? self.publicationDate,
            foodCode: foodCode ?? self.foodCode,
            foodNutrients: foodNutrients ?? self.foodNutrients,
            ndbNumber: ndbNumber ?? self.ndbNumber
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum DerivationCode: String, Codable {
    case a = "A"
    case nc = "NC"
    case z = "Z"
}

enum UnitName: String, Codable {
    case g = "G"
    case iu = "IU"
    case kJ = "kJ"
    case mg = "MG"
    case ug = "UG"
}
