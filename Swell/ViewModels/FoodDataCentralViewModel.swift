//
//  FoodDataCentralViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 2/15/22.
//

import Foundation
import Firebase
import Combine

public class FoodDataCentralViewModel: ObservableObject {

    private var db = Firestore.firestore()
    @Published var error: String = ""
    let apiKey = Bundle.main.infoDictionary?["USDA_API_KEY"] as? String ?? "food key not found"
    private var cancellable: AnyCancellable?
    let formatter = DateFormatter()
    // Food Searching
    @Published var foodSearchResults = [Food]()
    @Published var searchResultsNumber: Int?
    var foodSearchDictionary = FoodDataCentral()
    // Retrieving Food History
    @Published var foodHistory = [FoodRetriever]()
    
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
    public func search(searchTerms: String?, dataType: String? = nil, pageSize: Int? = nil, pageNumber: Int? = nil, brandOwner: String? = nil) {
        
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
            DispatchQueue.main.async {
                self.foodSearchDictionary = try! JSONDecoder().decode(FoodDataCentral.self, from: data!)
                self.foodSearchResults = self.foodSearchDictionary.foods ?? []
                self.searchResultsNumber = self.foodSearchDictionary.totalHits
                if self.foodSearchResults.isEmpty {
                    self.error = "No results. Please try again."
                }
            }
        }.resume()
    }
    
    func getFoodIds(date: Date?) {
        var foodIds = [String]()
        var mealTypes = [String]()
        var servingSizes = [Int]()
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        let pDate = formatter.string(from: date ?? Timestamp(date: Date()).dateValue())
        
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("food").whereField("date", isEqualTo: pDate)
        docRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("Error in getFoodIds method:", error?.localizedDescription ?? "")
                return
            }
            for document in querySnapshot!.documents {
                let fdcId: Int = document.get("foodId") as! Int
                let mealType: String = document.get("meal") as! String
                let servingSize: Int = document.get("quantity") as! Int
                let toString = String(fdcId)
                foodIds.append(toString)
                mealTypes.append(mealType)
                servingSizes.append(servingSize)
            }
            self.getFoods(foodIds, mealTypes, servingSizes)
        }
    }
    
    /**
     Allows you to search for specific foods by ID.
     - Parameter fdcIDs: An array of the food IDs whose data you'd like to retrieve.
     - Returns: An array of the food data for the given food IDs.
     */
    public func getFoods(_ fdcIDs: [String], _ mealTypes: [String], _ servingSizes: [Int]) {
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "format", value: "abridged"))
        queryItems.append(URLQueryItem(name: "nutrients", value: "328,418,601,401,203,209,212,213,268,287,291,303,307,318,573,406,415,204,205,211,262,269,301,306"))
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
                        for i in 0...mealTypes.count-1 {
                            self.foodHistory[i].mealType = mealTypes[i]
                            self.foodHistory[i].servingSize = servingSizes[i]
                        }
                    }
                }
            })
    }
    
    /// Logs a food item's fdcid into Cloud Firestore
    func logFood(pFoodToLog: Food, pQuantity: Int?, pMeal: String) {
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        
        var docRef: DocumentReference
        
        let docData: [String: Any] = [
            "foodId": pFoodToLog.fdcID,
            "quantity": pQuantity ?? 1,
            "meal": pMeal,
            "date": formatter.string(from: Timestamp(date: Date()).dateValue())
        ]
        
        docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "test").collection("food").addDocument(data: docData, completion: { error in
            if let error = error {
                print("Error in logFood method: \(error.localizedDescription)")
            }
        })
        
        NotificationManager.instance.scheduleNotification(mealType: pMeal, foodTitle: pFoodToLog.foodDescription, docRef: docRef.documentID)
    }
    
    /// Logs a water of specific size
    func logWater() {}
    
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
