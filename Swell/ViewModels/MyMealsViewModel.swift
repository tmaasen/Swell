//
//  MyMealsViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 4/20/22.
//

import Foundation
import Firebase
import Combine

class MyMealsViewModel: ObservableObject {
    private var db = Firestore.firestore()
    let formatter = DateFormatter()
    let apiKey = Bundle.main.infoDictionary?["USDA_API_KEY"] as? String ?? "food key not found"
    var cancellable: AnyCancellable?
    @Published var myMeals = [MyMeal]()
    
    init() {
        self.getMyMeals()
    }
    
    func getMyMeals(completion: @escaping () -> () = {}) {
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("myMeals")
        
        docRef.addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error in getFoodIds method:", error?.localizedDescription ?? "")
                completion()
                return
            }
            
            self.myMeals.removeAll()
            var myMeal = MyMeal()
            var foodIds = [String]()
            
            for document in querySnapshot!.documents {
                myMeal.name = document.get("name") as? String
                myMeal.isCustomMeal = document.get("isCustomMeal") as? Bool
                myMeal.date = document.get("date") as? String
                myMeal.foodCategory = document.get("category") as? String
                myMeal.mealType = document.get("meal") as? String
                
                if document.get("isCustomMeal") as? Bool == true {
                    myMeal.ingredientNames = document.get("ingredientNames") as? [String]
                    myMeal.ingredientValues = document.get("ingredientValues") as? [String]
                    myMeal.nutrientNames = document.get("nutrientNames") as? [String]
                    myMeal.nutrientValues = document.get("nutrientValues") as? [String]
                    myMeal.instructions = document.get("instructions") as? String
                } else {
                    let fdcId: Int = document.get("foodId") as! Int
                    let toString = String(fdcId)
                    foodIds.append(toString)
                }
                
                self.myMeals.append(myMeal)
            }
            
            if foodIds.isEmpty {
                completion()
            } else {
                self.getFoodsFromFDC(foodIds, completion: { 
                    completion()
                })
            }
        }
    }

    func isLiked(pFood: String, completion: @escaping (Bool) -> ()) {
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("myMeals")
            .document(pFood).getDocument { (document, error) in
                if let document = document, document.exists {
                    completion(true)
                }
            }
        completion(false)
    }
    
    func logCustomMeal(pFoodId: Int, pFoodName: String, pHighNutrients: [String], pQuantity: Int = 1, pMeal: String, pContains: [String] = [], completion: @escaping (Bool) -> ()) {
        
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        var docRef: DocumentReference
        
        let docData: [String: Any] = [
            "foodId": pFoodId,
            "foodName": pFoodName,
            "quantity": pQuantity,
            "meal": pMeal,
            "highIn": pHighNutrients,
            "contains": pContains,
            "date": formatter.string(from: Timestamp(date: Date()).dateValue()),
            "mood": "",
            "inMyMeals": true
        ]
        
        docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "test").collection("food").addDocument(data: docData, completion: { error in
            if let error = error {
                print("Error in logCustomMeal method: \(error.localizedDescription)")
                completion(false)
            }
        })
        
        NotificationManager.instance.scheduleNotification(mealType: pMeal, foodTitle: pFoodName, docRef: docRef.documentID)
        completion(true)
    }
    
    func addToMyMeals(pFoodId: Int, pFoodName: String, pFoodCategory: String, pHighNutrients: [String], completion: @escaping () -> () = {}) {
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        
        let docData: [String: Any] = [
            "foodId": pFoodId,
            "name": pFoodName,
            "highIn": pHighNutrients,
            "isCustomMeal": false,
            "category": pFoodCategory,
            "date": formatter.string(from: Timestamp(date: Date()).dateValue()),
        ]
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("myMeals")
            .document(pFoodName).setData(docData, completion: { error in
            if let error = error {
                print("Error in addToMyMeals method: \(error.localizedDescription)")
                completion()
            }
            completion()
        })
    }
    
    func addCustomMeal(pMealName: String, pFoodCategory: String,
                       pIngredientNames: [String], pIngredientValues: [String],
                       pNutrientNames: [String], pNutrientValues: [String],
                       pInstructions: String, completion: @escaping () -> () = {}) {
        
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        let docData: [String: Any] = [
            "name": pMealName,
            "category": pFoodCategory,
            "ingredientNames": pIngredientNames,
            "ingredientValues": pIngredientValues,
            "nutrientNames": pNutrientNames,
            "nutrientValues": pNutrientValues,
            "instructions": pInstructions,
            "isCustomMeal": true,
            "date": formatter.string(from: Timestamp(date: Date()).dateValue())
        ]
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("myMeals")
            .document(pMealName).setData(docData, completion: { error in
            if let error = error {
                print("Error in addCustomMeal method: \(error.localizedDescription)")
            }
            completion()
        })
    }
    
    func removeFromMyMeals(pFoodName: String, completion: @escaping () -> () = {}) {
        self.myMeals.removeAll(where: {$0.name == pFoodName})
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("myMeals").document(pFoodName).delete(completion: {_ in
            completion()
        })
    }
    
    func getFoodsFromFDC(_ fdcIDs: [String], completion: @escaping () -> () = {}) {
        var queryItems: [URLQueryItem] = []
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
                    if !food.isEmpty {
                        for i in 0...fdcIDs.count-1 {
                            self.myMeals[i].foodInfo = food[i]
                        }
                        completion()
                    }
                }
            })
    }
    
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
