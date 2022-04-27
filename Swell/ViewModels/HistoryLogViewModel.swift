//
//  HistoryLogViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 4/27/22.
//

import Foundation
import Firebase

import Combine

/// API Request using the Combine framework's dataTaskPublisher
//        self.cancellable = URLSession.shared.dataTaskPublisher(for: request)
//            .map { $0.data }
//            .decode(type: [FoodRetriever].self, decoder: JSONDecoder())
//            .replaceError(with: [])
//            .eraseToAnyPublisher()
//            .sink(receiveValue: { food in
//                DispatchQueue.main.async {
//                    var foodArray = foodArrayToSet
//                    foodArray = food
//                    if !foodArray.isEmpty {
//                        for i in 0...fdcIDs.count-1 {
//                            foodArray[i].foodName = foodNames[i]
//                            foodArray[i].mealType = mealTypes[i]
//                            foodArray[i].quantity = servingSizes[i]
//                            foodArray[i].mood = moods[i]
//                            foodArray[i].comments = comments[i]
//                            foodArray[i].docId = docIds[i]
//                        }
//                        completion(foodArray)
//                    } else {
//                        completion([FoodRetriever]())
//                        return
//                    }
//                }
//            })

class HistoryLogViewModel: ObservableObject {
    // return success and failure bools
    let db = Firestore.firestore()
    var cancellable: AnyCancellable?
    let formatter = DateFormatter()
    let apiKey = Bundle.main.infoDictionary?["USDA_API_KEY"] as? String ?? "food key not found"
    
    @Published var foodHistory = [FoodRetriever]()
    @Published var todaysLog = [FoodRetriever]()
    @Published var waters = FoodRetriever()
    @Published var isNewDay: Bool = false
    var loggedOunces = [Double]()
    
    func getAllHistoryByDate(date: Date = Timestamp(date: Date()).dateValue(), completion: @escaping () -> () = {}) {
        self.getFood(date: date, completion: { didCompleteSuccessfully in
            if didCompleteSuccessfully {
                self.getWater(date: date, completion: { didCompleteSuccessfully in
                    if didCompleteSuccessfully {
                        completion()
                    }
                })
            }
        })
    }
    
    func getFood(date: Date = Timestamp(date: Date()).dateValue(), completion: @escaping (Bool) -> ()) {
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        let pDate = formatter.string(from: date)
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("food").whereField("date", isEqualTo: pDate)
        
        docRef.addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error in getFoodIds method:", error?.localizedDescription ?? "")
                completion(false)
                return
            }
            var foodIds = [String]()
            var foodNames = [String]()
            var mealTypes = [String]()
            var servingSizes = [Int]()
            var moods = [String]()
            var comments = [String]()
            var docIds = [String]()
            
            for document in querySnapshot!.documents {
                let fdcId: Int = document.get("foodId") as! Int
                let foodName: String = document.get("foodName") as! String
                let mealType: String = document.get("meal") as! String
                let servingSize: Int = document.get("quantity") as! Int
                let mood: String = document.get("mood") as? String ?? ""
                let comment: String = document.get("comments") as? String ?? ""
                let toString = String(fdcId)
                foodNames.append(foodName)
                foodIds.append(toString)
                mealTypes.append(mealType)
                servingSizes.append(servingSize)
                moods.append(mood)
                comments.append(comment)
                docIds.append(document.documentID)
            }

            if foodIds.isEmpty {
                self.foodHistory = [FoodRetriever]()
                completion(true)
            } else {
                self.getFoodsById(pDate == self.formatter.string(from: Date()) ? self.todaysLog : self.foodHistory, foodIds, mealTypes, servingSizes, moods, comments, docIds, foodNames, completion: { foodArray in
                    if pDate == self.formatter.string(from: Date()) {
                        self.todaysLog = foodArray
                        self.foodHistory = foodArray
                    } else {
                        self.foodHistory = foodArray
                    }
                    completion(true)
                })
            }
        }
    }
    
    /**
     Gets the water logged and total ounces drank from a user daily.
     Also runs a check to see if it is a new day. If so, the water logger resets itself.
     */
    func getWater(date: Date = Timestamp(date: Date()).dateValue(), completion: @escaping (Bool) -> ()) {
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        let pDate = formatter.string(from: date)
        let today = formatter.string(from: Date())
        
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("water")
            .document(pDate)
            .addSnapshotListener { (documentSnapshot, error) in
                guard error == nil else {
                    print("Error in getWater method:", error?.localizedDescription ?? "")
                    completion(false)
                    return
                }
                if let documentSnapshot = documentSnapshot, !documentSnapshot.exists {
                    if pDate == today {
                        self.isNewDay = true
                    }
                    completion(true)
                } else if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                    self.isNewDay = false
                    self.waters.waterLoggedToday = documentSnapshot.get("waters logged") as? Int
                    self.waters.waterOuncesToday = documentSnapshot.get("total ounces") as? Double
                    self.waters.docId = documentSnapshot.documentID
                    completion(true)
                }
            }
    }
    
    /**
     Allows you to search for specific foods by ID.
     - Parameter fdcIDs: An array of the food IDs whose data you'd like to retrieve.
     - Returns: An array of the food data for the given food IDs.
     */
    public func getFoodsById(_ foodArrayToSet: [FoodRetriever],_ fdcIDs: [String], _ mealTypes: [String], _ servingSizes: [Int], _ moods: [String], _ comments: [String], _ docIds: [String], _ foodNames: [String], completion: @escaping ([FoodRetriever]) -> ()) {
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "nutrients", value: "328,418,601,401,203,209,212,213,268,287,291,303,307,318,573,406,415,204,205,211,262,269,301,306"))
        queryItems.append(contentsOf: fdcIDs.map { URLQueryItem(name: "fdcIds", value: $0) })
        
        let url = generateURL(path: "fdc/v1/foods", queryItems: queryItems)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                self.foodHistory = try JSONDecoder().decode([FoodRetriever].self, from: data ?? Data())
                DispatchQueue.main.async {
                    if !self.foodHistory.isEmpty {
                        for i in 0...fdcIDs.count-1 {
                            self.foodHistory[i].foodName = foodNames[i]
                            self.foodHistory[i].mealType = mealTypes[i]
                            self.foodHistory[i].quantity = servingSizes[i]
                            self.foodHistory[i].mood = moods[i]
                            self.foodHistory[i].comments = comments[i]
                            self.foodHistory[i].docId = docIds[i]
                        }
                        completion(self.foodHistory)
                    }
                }
            } catch {
                print("JSONSerialization error:", error)
                completion([FoodRetriever]())
            }
        }
        .resume()
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
