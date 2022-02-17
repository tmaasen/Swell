//
//  FoodDataCentral.swift
//  Swell
//
//  Created by Tanner Maasen on 2/15/22.
//

import Foundation

// MARK: - FoodDataCentral
struct FoodDataCentral: Codable {
    var totalHits, currentPage, totalPages: Int?
    var pageList: [Int]?
    var foodSearchCriteria: FoodSearchCriteria?
    var foods: [Food]?
    var aggregations: Aggregations?
}

// MARK: FoodDataCentral convenience initializers and mutators

extension FoodDataCentral {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FoodDataCentral.self, from: data)
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
        totalHits: Int? = nil,
        currentPage: Int? = nil,
        totalPages: Int? = nil,
        pageList: [Int]? = nil,
        foodSearchCriteria: FoodSearchCriteria? = nil,
        foods: [Food]? = nil,
        aggregations: Aggregations? = nil
    ) -> FoodDataCentral {
        return FoodDataCentral(
            totalHits: totalHits ?? self.totalHits,
            currentPage: currentPage ?? self.currentPage,
            totalPages: totalPages ?? self.totalPages,
            pageList: pageList ?? self.pageList,
            foodSearchCriteria: foodSearchCriteria ?? self.foodSearchCriteria,
            foods: foods ?? self.foods,
            aggregations: aggregations ?? self.aggregations
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Aggregations
struct Aggregations: Codable {
    var dataType: DataType
    var nutrients: Nutrients
}

// MARK: Aggregations convenience initializers and mutators

extension Aggregations {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Aggregations.self, from: data)
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
        dataType: DataType? = nil,
        nutrients: Nutrients? = nil
    ) -> Aggregations {
        return Aggregations(
            dataType: dataType ?? self.dataType,
            nutrients: nutrients ?? self.nutrients
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DataType
struct DataType: Codable {
    var branded, srLegacy, surveyFNDDS, foundation: Int

    enum CodingKeys: String, CodingKey {
        case branded = "Branded"
        case srLegacy = "SR Legacy"
        case surveyFNDDS = "Survey (FNDDS)"
        case foundation = "Foundation"
    }
}

// MARK: DataType convenience initializers and mutators

extension DataType {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DataType.self, from: data)
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
        branded: Int? = nil,
        srLegacy: Int? = nil,
        surveyFNDDS: Int? = nil,
        foundation: Int? = nil
    ) -> DataType {
        return DataType(
            branded: branded ?? self.branded,
            srLegacy: srLegacy ?? self.srLegacy,
            surveyFNDDS: surveyFNDDS ?? self.surveyFNDDS,
            foundation: foundation ?? self.foundation
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Nutrients
struct Nutrients: Codable {
}

// MARK: Nutrients convenience initializers and mutators

extension Nutrients {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Nutrients.self, from: data)
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
    ) -> Nutrients {
        return Nutrients(
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - FoodSearchCriteria
struct FoodSearchCriteria: Codable {
    var query, generalSearchInput: String
    var pageNumber, numberOfResultsPerPage, pageSize: Int
    var requireAllWords: Bool
}

// MARK: FoodSearchCriteria convenience initializers and mutators

extension FoodSearchCriteria {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FoodSearchCriteria.self, from: data)
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
        query: String? = nil,
        generalSearchInput: String? = nil,
        pageNumber: Int? = nil,
        numberOfResultsPerPage: Int? = nil,
        pageSize: Int? = nil,
        requireAllWords: Bool? = nil
    ) -> FoodSearchCriteria {
        return FoodSearchCriteria(
            query: query ?? self.query,
            generalSearchInput: generalSearchInput ?? self.generalSearchInput,
            pageNumber: pageNumber ?? self.pageNumber,
            numberOfResultsPerPage: numberOfResultsPerPage ?? self.numberOfResultsPerPage,
            pageSize: pageSize ?? self.pageSize,
            requireAllWords: requireAllWords ?? self.requireAllWords
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Food
struct Food: Identifiable, Codable {
    var id = UUID()
    var fdcID: Int
    var foodDescription, lowercaseDescription, dataType, gtinUpc: String
    var publishedDate, brandOwner, ingredients, marketCountry: String
    var foodCategory, modifiedDate, dataSource, servingSizeUnit: String?
    var servingSize: Int
    var householdServingFullText, allHighlightFields: String?
    var score: Double
    var foodNutrients: [FoodNutrient]?
    var finalFoodInputFoods, foodMeasures, foodAttributes, foodAttributeTypes: [JSONAny]?
    var foodVersionIDS: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case fdcID = "fdcId"
        case foodDescription = "description"
        case lowercaseDescription, dataType, gtinUpc, publishedDate, brandOwner, ingredients, marketCountry, foodCategory, modifiedDate, dataSource, servingSizeUnit, servingSize, householdServingFullText, allHighlightFields, score, foodNutrients, finalFoodInputFoods, foodMeasures, foodAttributes, foodAttributeTypes
        case foodVersionIDS = "foodVersionIds"
    }
}

// MARK: Food convenience initializers and mutators

extension Food {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Food.self, from: data)
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
        foodDescription: String? = nil,
        lowercaseDescription: String? = nil,
        dataType: String? = nil,
        gtinUpc: String? = nil,
        publishedDate: String? = nil,
        brandOwner: String? = nil,
        ingredients: String? = nil,
        marketCountry: String? = nil,
        foodCategory: String? = nil,
        modifiedDate: String? = nil,
        dataSource: String? = nil,
        servingSizeUnit: String? = nil,
        servingSize: Int? = nil,
        householdServingFullText: String? = nil,
        allHighlightFields: String? = nil,
        score: Double? = nil,
        foodNutrients: [FoodNutrient]? = nil,
        finalFoodInputFoods: [JSONAny]? = nil,
        foodMeasures: [JSONAny]? = nil,
        foodAttributes: [JSONAny]? = nil,
        foodAttributeTypes: [JSONAny]? = nil,
        foodVersionIDS: [JSONAny]? = nil
    ) -> Food {
        return Food(
            fdcID: fdcID ?? self.fdcID,
            foodDescription: foodDescription ?? self.foodDescription,
            lowercaseDescription: lowercaseDescription ?? self.lowercaseDescription,
            dataType: dataType ?? self.dataType,
            gtinUpc: gtinUpc ?? self.gtinUpc,
            publishedDate: publishedDate ?? self.publishedDate,
            brandOwner: brandOwner ?? self.brandOwner,
            ingredients: ingredients ?? self.ingredients,
            marketCountry: marketCountry ?? self.marketCountry,
            foodCategory: foodCategory ?? self.foodCategory,
            modifiedDate: modifiedDate ?? self.modifiedDate,
            dataSource: dataSource ?? self.dataSource,
            servingSizeUnit: servingSizeUnit ?? self.servingSizeUnit,
            servingSize: servingSize ?? self.servingSize,
            householdServingFullText: householdServingFullText ?? self.householdServingFullText,
            allHighlightFields: allHighlightFields ?? self.allHighlightFields,
            score: score ?? self.score,
            foodNutrients: foodNutrients ?? self.foodNutrients,
            finalFoodInputFoods: finalFoodInputFoods ?? self.finalFoodInputFoods,
            foodMeasures: foodMeasures ?? self.foodMeasures,
            foodAttributes: foodAttributes ?? self.foodAttributes,
            foodAttributeTypes: foodAttributeTypes ?? self.foodAttributeTypes,
            foodVersionIDS: foodVersionIDS ?? self.foodVersionIDS
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - FoodNutrient
struct FoodNutrient: Codable {
    var nutrientID: Int
    var nutrientName, nutrientNumber, unitName: String
    var derivationCode: DerivationCode
    var derivationDescription: String
    var derivationID: Int
    var value: Double
    var foodNutrientSourceID: Int
    var foodNutrientSourceCode: String
    var foodNutrientSourceDescription: FoodNutrientSourceDescription
    var rank, indentLevel, foodNutrientID, percentDailyValue: Int

    enum CodingKeys: String, CodingKey {
        case nutrientID = "nutrientId"
        case nutrientName, nutrientNumber, unitName, derivationCode, derivationDescription
        case derivationID = "derivationId"
        case value
        case foodNutrientSourceID = "foodNutrientSourceId"
        case foodNutrientSourceCode, foodNutrientSourceDescription, rank, indentLevel
        case foodNutrientID = "foodNutrientId"
        case percentDailyValue
    }
}

// MARK: FoodNutrient convenience initializers and mutators

extension FoodNutrient {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FoodNutrient.self, from: data)
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
        nutrientID: Int? = nil,
        nutrientName: String? = nil,
        nutrientNumber: String? = nil,
        unitName: String? = nil,
        derivationCode: DerivationCode? = nil,
        derivationDescription: String? = nil,
        derivationID: Int? = nil,
        value: Double? = nil,
        foodNutrientSourceID: Int? = nil,
        foodNutrientSourceCode: String? = nil,
        foodNutrientSourceDescription: FoodNutrientSourceDescription? = nil,
        rank: Int? = nil,
        indentLevel: Int? = nil,
        foodNutrientID: Int? = nil,
        percentDailyValue: Int? = nil
    ) -> FoodNutrient {
        return FoodNutrient(
            nutrientID: nutrientID ?? self.nutrientID,
            nutrientName: nutrientName ?? self.nutrientName,
            nutrientNumber: nutrientNumber ?? self.nutrientNumber,
            unitName: unitName ?? self.unitName,
            derivationCode: derivationCode ?? self.derivationCode,
            derivationDescription: derivationDescription ?? self.derivationDescription,
            derivationID: derivationID ?? self.derivationID,
            value: value ?? self.value,
            foodNutrientSourceID: foodNutrientSourceID ?? self.foodNutrientSourceID,
            foodNutrientSourceCode: foodNutrientSourceCode ?? self.foodNutrientSourceCode,
            foodNutrientSourceDescription: foodNutrientSourceDescription ?? self.foodNutrientSourceDescription,
            rank: rank ?? self.rank,
            indentLevel: indentLevel ?? self.indentLevel,
            foodNutrientID: foodNutrientID ?? self.foodNutrientID,
            percentDailyValue: percentDailyValue ?? self.percentDailyValue
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
    case lccd = "LCCD"
    case lccs = "LCCS"
    case lcsl = "LCSL"
}

enum FoodNutrientSourceDescription: String, Codable {
    case manufacturerSAnalyticalPartialDocumentation = "Manufacturer's analytical; partial documentation"
}

// MARK: - Helper functions for creating encoders and decoders

//func newJSONDecoder() -> JSONDecoder {
//    let decoder = JSONDecoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        decoder.dateDecodingStrategy = .iso8601
//    }
//    return decoder
//}
//
//func newJSONEncoder() -> JSONEncoder {
//    let encoder = JSONEncoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        encoder.dateEncodingStrategy = .iso8601
//    }
//    return encoder
//}

// MARK: - Encode/decode helpers

class JSONNull: Codable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

//    public var hashValue: Int {
//        return 0
//    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
