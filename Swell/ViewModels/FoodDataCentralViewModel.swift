//
//  FoodDataCentralViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 2/15/22.
//

import Foundation
import Firebase

public class FoodDataCentralViewModel: ObservableObject {
    
    @Published var foodResults = [Food]()
    @Published var error: String = ""
    var foodDict = FoodDataCentral()
    private var db = Firestore.firestore()
    @Published var processCompleted: Bool = false
    @Published var searchResultsNumber: Int?
    let apiKey = Bundle.main.infoDictionary?["USDA_API_KEY"] as? String ?? "food key not found"
    
    public enum SearchFields: String {
        case fdcId = "fdcId"
        case description = "description"
        case commonNames = "commonNames"
        case additionalDescriptions = "additionalDescriptions"
        case dataType = "dataType"
        case foodCode = "foodCode"
        case publishedDate = "publishedDate"
        case allHighlightedFields = "allHighlightedFields"
        case score = "score"
    }
    public enum SortOrder: String {
        case ascending = "asc"
        case descending = "desc"
    }
    
    /**
     Searches the USDA Food Database and returns matching results.
     - Parameter searchTerms: What to search for. (Hot Cheetos, Vitamin Water, etc)
     - Parameter dataType: Optional. Foundation, SR Legacy, Experimental
     - Parameter pageSize: Optional. Defaults to 50 results per page.
     - Parameter pageNumber: Optional. Page number to retrieve. The offset is pexpressed as (pageNumber * pageSize).
     - Parameter sortBy: Optional. A field by which to sort.
     - Parameter sortOrder: Optional. Ascending or descending.
     - Parameter brandOwner: Optional. Filter based on brand. Only applies to Branded Foods.
     - Returns: Results in JSON format.
     */
    public func search(searchTerms: String?, dataType: String? = nil, pageSize: Int? = nil, pageNumber: Int? = nil,
                       sortBy: SearchFields? = nil, sortOrder: SortOrder? = nil, brandOwner: String? = nil) {
        var queryItems: [URLQueryItem] = []
        if let searchTerms = searchTerms { queryItems.append(URLQueryItem(name: "query", value: searchTerms)) }
        if let dataType = dataType { queryItems.append(URLQueryItem(name: "dataType", value: dataType)) }
        if let pageSize = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(pageSize))) }
        if let pageNumber = pageNumber { queryItems.append(URLQueryItem(name: "pageNumber", value: String(pageNumber))) }
        if let sortBy = sortBy { queryItems.append(URLQueryItem(name: "sortBy", value: sortBy.rawValue)) }
        if let sortOrder = sortOrder { queryItems.append(URLQueryItem(name: "sortOrder", value: sortOrder.rawValue)) }
        if let brandOwner = brandOwner { queryItems.append(URLQueryItem(name: "brandOwner", value: brandOwner)) }
        
        self.processCompleted = false
        let API_URL = generateURL(path: "fdc/v1/foods/search", queryItems: queryItems)
        var request = URLRequest(url: API_URL!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.foodDict = try! JSONDecoder().decode(FoodDataCentral.self, from: data!)
                self.foodResults = self.foodDict.foods ?? []
                self.searchResultsNumber = self.foodDict.totalHits
                if self.foodResults.isEmpty {
                    self.error = "No results. Please try again."
                }
                self.processCompleted = true
            }
        }.resume()
    }
    
    /**
     Allows you to search for specific foods by ID.
     - Parameter fdcIDs: An array of the food IDs whose data you'd like to retrieve.
     - Returns: An array of the food data for the given food IDs.
     */
    public func get_foods(_ fdcIDs: [String]) {
        let url = generateURL(path: "fdc/v1/foods", queryItems: fdcIDs.map { URLQueryItem(name: "fdcIds", value: $0) })
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
        }
        task.resume()
    }
    
    /// Logs a food item's fdcid into Cloud Firestore
    func logNutrition(pFoodToLog: Food, pQuantity: Int?, pMeal: String) {
        let docData: [String: Any] = [
            "foodId": pFoodToLog.fdcID,
            "quantity": pQuantity ?? 1,
            "meal": pMeal,
            "date": Timestamp(date: Date())
        ]
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "test").collection("food").addDocument(data: docData, completion: { error in
            if let error = error {
                print("Error in logNutrition method: \(error.localizedDescription)")
            } else {
                self.processCompleted = true
                print("Successfully logged \(pFoodToLog.foodDescription)")
            }
        })
    }
    
    /// Generates a new URL with the given queryItems.
    private func generateURL(path: String, queryItems: [URLQueryItem]) -> URL? {
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.nal.usda.gov"
        url.path = path.prefix(1) == "/" ? path : "/" + path
        url.queryItems = [
            URLQueryItem(name: "api_key", value: self.apiKey)
        ]
        for queryItem in queryItems {
            url.queryItems?.append(queryItem)
        }
        return url.url
    }
}
