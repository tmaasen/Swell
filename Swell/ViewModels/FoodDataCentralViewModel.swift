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
    // Retrieving Water History
    @Published var waters = FoodRetriever()
    @Published var isNewDay: Bool = false
    var loggedOunces = [Double]()
    
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
    
    func getFoodIds(date: Date = Timestamp(date: Date()).dateValue(), completion: @escaping () -> () = {}) {
        var foodIds = [String]()
        var mealTypes = [String]()
        var servingSizes = [Int]()
        var moods = [String]()
        var comments = [String]()
        var docIds = [String]()
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        let pDate = formatter.string(from: date)
        
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("food").whereField("date", isEqualTo: pDate)
        docRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("Error in getFoodIds method:", error?.localizedDescription ?? "")
                completion()
                return
            }
            for document in querySnapshot!.documents {
                let fdcId: Int = document.get("foodId") as! Int
                let mealType: String = document.get("meal") as! String
                let servingSize: Int = document.get("quantity") as! Int
                let mood: String = document.get("mood") as? String ?? ""
                let comment: String = document.get("comments") as? String ?? ""
                let toString = String(fdcId)
                foodIds.append(toString)
                mealTypes.append(mealType)
                servingSizes.append(servingSize)
                moods.append(mood)
                comments.append(comment)
                docIds.append(document.documentID)
            }
            completion()
            self.getFoodsById(foodIds, mealTypes, servingSizes, moods, comments, docIds, completion: {
                completion()
            })
//            self.getWater(date: date)
        }
    }
    
    /**
     Allows you to search for specific foods by ID.
     - Parameter fdcIDs: An array of the food IDs whose data you'd like to retrieve.
     - Returns: An array of the food data for the given food IDs.
     */
    public func getFoodsById(_ fdcIDs: [String], _ mealTypes: [String], _ servingSizes: [Int], _ moods: [String], _ comments: [String], _ docIds: [String], completion: @escaping () -> () = {}) {
        var queryItems: [URLQueryItem] = []
//        queryItems.append(URLQueryItem(name: "nutrients", value: "328,418,601,401,203,209,212,213,268,287,291,303,307,318,573,406,415,204,205,211,262,269,301,306"))
        queryItems.append(URLQueryItem(name: "nutrients", value: "203,204,205"))
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
    
    /// Logs a food item's fdcid into Cloud Firestore
    func logFood(pFoodToLog: Food, pQuantity: Int = 1, pMeal: String, pContains: [String] = []) {
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        var highNutrients = [String]()
        
        var docRef: DocumentReference
        
        // if food is high in nutrient, log nutrient
        // 20% DV or more of a nutrient per serving is considered high (fda)
        for nutrient in pFoodToLog.foodNutrients {
            if nutrient.value ?? 0 > 20 {
                if nutrient.nutrientName! == "Protein" {
                    highNutrients.append("Protein")
                }
                if nutrient.nutrientName! == "Sugars, total including NLEA" {
                    highNutrients.append("Sugar")
                }
                if nutrient.nutrientName! == "Carbohydrate, by difference" {
                    highNutrients.append("Carbohydrates")
                }
            }
        }
        
        let docData: [String: Any] = [
            "foodId": pFoodToLog.fdcID,
            "quantity": pQuantity,
            "meal": pMeal,
            "highIn": highNutrients,
            "contains": pContains,
            "date": formatter.string(from: Timestamp(date: Date()).dateValue()),
            "mood": ""
        ]
        
        docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "test").collection("food").addDocument(data: docData, completion: { error in
            if let error = error {
                print("Error in logFood method: \(error.localizedDescription)")
            }
        })
        
        NotificationManager.instance.scheduleNotification(mealType: pMeal, foodTitle: pFoodToLog.foodDescription, docRef: docRef.documentID)
    }
    
    /// Logs a water of specific size into Cloud Firestore
    func logWater(pSize: String, watersLoggedToday: Int = 1, ounces: Double) {
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        
        var docRef: DocumentReference
                
        let docData: [String: Any] = [
            // First time entry
            "meal": "Water",
            "waters logged": watersLoggedToday,
            "total ounces": ounces,
            "date": formatter.string(from: Timestamp(date: Date()).dateValue())
        ]
        // if watersLoggedToday = 0, new doc...else, update doc
        if watersLoggedToday == 1 {
            db.collection("users").document(Auth.auth().currentUser?.uid ?? "test").collection("water").document(formatter.string(from: Timestamp(date: Date()).dateValue())).setData(docData, completion: { error in
                if let error = error {
                    print("Error in logWater method: \(error.localizedDescription)")
                } else {
                    self.loggedOunces.append(ounces)
                }
            })
        } else {
            // first get doc with today's date
            docRef = db.collection("users")
                .document(Auth.auth().currentUser?.uid ?? "user")
                .collection("water")
                .document(formatter.string(from: Timestamp(date: Date()).dateValue()))
            // then update it
            loggedOunces.append(ounces)
            db.collection("users").document(Auth.auth().currentUser?.uid ?? "test").collection("water").document(docRef.documentID).updateData([
                "waters logged": watersLoggedToday,
                "total ounces": loggedOunces.reduce(0, +)
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                }
            }
        }
    }
    
    /**
     Gets the water logged and total ounces drank from a user daily.
     Also runs a check to see if it is a new day. If so, the water logger resets itself.
     */
    func getWater(date: Date = Timestamp(date: Date()).dateValue(), completion: @escaping () -> () = {}) {
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        let pDate = formatter.string(from: date)
        let today = formatter.string(from: Date())
        
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("water")
            .document(pDate)
            .getDocument { (document, error) in
                guard error == nil else {
                    print("Error in getWater method:", error?.localizedDescription ?? "")
                    completion()
                    return
                }
                if let document = document, !document.exists {
                    if pDate == today {
                        self.isNewDay = true
                        completion()
                        return
                    }
                }
                if let document = document, document.exists {
                    self.isNewDay = false
                    self.waters.waterLoggedToday = document.get("waters logged") as? Int
                    self.waters.waterOuncesToday = document.get("total ounces") as? Double
                    self.waters.docId = document.documentID
                    completion()
                    return
                }
            }
    }
    
    func getAllHistoryByDate(date: Date = Timestamp(date: Date()).dateValue(), completion: @escaping () -> () = {}) {
        self.getFoodIds(date: date, completion: {
            self.getWater(date: date, completion: {
                completion()
                return
            })
        })
    }
    
    func deleteFromHistory(doc: String, collection: String, completion: @escaping () -> () = {}) {
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection(collection).document(doc).delete(completion: { error in
            if let error = error {
                print("Error in deleteFromHistory method: \(error.localizedDescription)")
            } else {
                completion()
                return
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
