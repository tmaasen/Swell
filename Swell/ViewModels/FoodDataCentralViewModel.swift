//
//  FoodDataCentralViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 2/15/22.
//

import Foundation
import Firebase
import Combine

class FoodDataCentralViewModel: ObservableObject {

    var db = Firestore.firestore()
    @Published var error: String = ""
    let apiKey = Bundle.main.infoDictionary?["USDA_API_KEY"] as? String ?? "food key not found"
    var cancellable: AnyCancellable?
    let formatter = DateFormatter()
    // Food Searching
    @Published var foodSearchResults = [Food]()
    @Published var searchResultsNumber: Int?
    var foodSearchDictionary = FoodDataCentral()
    // Retrieving Food History
    @Published var foodHistory = [FoodRetriever]()
    
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
    public func search(searchTerms: String?, dataType: String? = nil, pageSize: Int? = nil, pageNumber: Int? = nil, brandOwner: String? = nil, completion: @escaping () -> () = {}) {
        var queryItems: [URLQueryItem] = []
        if let searchTerms = searchTerms { queryItems.append(URLQueryItem(name: "query", value: searchTerms)) }
        if let pageSize = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(pageSize))) }
        if let pageNumber = pageNumber { queryItems.append(URLQueryItem(name: "pageNumber", value: String(pageNumber))) }
        if let brandOwner = brandOwner { queryItems.append(URLQueryItem(name: "brandOwner", value: brandOwner)) }
        queryItems.append(URLQueryItem(name: "sortBy", value: "dataType.keyword"))
        queryItems.append(URLQueryItem(name: "dataType", value: "Foundation, SR Legacy, Branded"))
        
        let API_URL = generateURL(path: "fdc/v1/foods/search", queryItems: queryItems)
        var request = URLRequest(url: API_URL!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                self.foodSearchDictionary = try JSONDecoder().decode(FoodDataCentral.self, from: data ?? Data())
                DispatchQueue.main.async {
                    self.foodSearchResults = self.foodSearchDictionary.foods ?? []
                    self.searchResultsNumber = self.foodSearchDictionary.totalHits
                    completion()
                    if self.foodSearchResults.isEmpty {
                        self.error = "No results. Please try again."
                        completion()
                        return
                    }
                }
            } catch {
                print("JSONSerialization error:", error)
                completion()
                return
            }
        }
        .resume()
    }
    
    /**
     Allows you to search for specific foods by ID.
     - Parameter fdcIDs: An array of the food IDs whose data you'd like to retrieve.
     - Returns: An array of the food data for the given food IDs.
     */
    public func getFoodsById(_ fdcIDs: [String], _ mealTypes: [String], _ servingSizes: [Int], _ moods: [String], _ comments: [String], _ docIds: [String], _ foodNames: [String], completion: @escaping () -> () = {}) {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "nutrients", value: "328,418,601,401,203,209,212,213,268,287,291,303,307,318,573,406,415,204,205,211,262,269,301,306"))
//        queryItems.append(URLQueryItem(name: "nutrients", value: "203,204,205"))
        queryItems.append(contentsOf: fdcIDs.map { URLQueryItem(name: "fdcIds", value: $0) })
        
        let url = generateURL(path: "fdc/v1/foods", queryItems: queryItems)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        /// API Request using the Combine framework's dataTaskPublisher
        self.cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: [FoodRetriever].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .sink(receiveValue: { food in
                DispatchQueue.main.async {
                    self.foodHistory = food
                    if !self.foodHistory.isEmpty {
                        for i in 0...fdcIDs.count-1 {
                            self.foodHistory[i].foodName = foodNames[i]
                            self.foodHistory[i].mealType = mealTypes[i]
                            self.foodHistory[i].servingSize = servingSizes[i]
                            self.foodHistory[i].mood = moods[i]
                            self.foodHistory[i].comments = comments[i]
                            self.foodHistory[i].docId = docIds[i]
                        }
                        completion()
                    } else {
                        completion()
                        return
                    }
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
