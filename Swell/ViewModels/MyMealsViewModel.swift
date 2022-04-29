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
        self.getMyMeals(completion: {})
    }
    
    /**
     A snapshot listener function that gets all the user's MyMeals collection, both food items from FoodData Central and custom meals.
     MyMeals from FDC will be given in the completion handler
     Custom myMeals are appended to the Published variable myMeals
     - Returns: Results in JSON format.
     */
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

    /**
     Runs a check to see if a given food item is in the user's MyMeals collection.
     - Parameter pFoodId: Food id given by the FoodData Central database for this specific item to uniquely identify this item to see if it's liked by the user.
     - Returns: Completion handler with a boolean value to let me know if the process completed successfully (true) or if there was an error (false).
     */
    func isLiked(pFoodId: Int, completion: @escaping (Bool) -> ()) {
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("myMeals")
            .whereField("foodId", isEqualTo: pFoodId)
            .getDocuments { (documentSnapshot, error) in
                if let documentSnapshot = documentSnapshot, !documentSnapshot.isEmpty {
                    completion(true)
                }
            }
        completion(false)
    }
    
    /**
     Log a custom meal.
     - Parameter pFood: The given MyMeal object. Contains all of the information for an item of type MyMeal.
     - Parameter pHighNutrients: List of nutrients that this food item is high in. This data comes from a function that ran in the view before this function is called.
     - Parameter pQuantity: Amount of the item consumed by the user.
     - Parameter pMealType: Breakfast, Lunch, Dinner, Snack.
     - Parameter pContains: List of nutrients that are often related to intolerances (i.e., Dairy, Gluten, Caffeine) or Whole Grain which represent a very healthy nutrient. This data comes from a function that is ran in the view before this function is called.
     - Returns: Completion handler with a boolean value to let me know if the process completed successfully (true) or if there was an error (false).
     */
    func logCustomMeal(pFood: MyMeal, pHighNutrients: [String], pQuantity: Int = 1, pMealType: String, pContains: [String] = [], completion: @escaping (Bool) -> ()) {
        
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        var docRef: DocumentReference
        
        let docData: [String: Any] = [
            "foodId": pFood.foodId ?? 0,
            "foodName": pFood.name!,
            "quantity": pQuantity,
            "meal": pMealType,
            "highIn": pHighNutrients,
            "contains": pContains,
            "date": formatter.string(from: Timestamp(date: Date()).dateValue()),
            "mood": "",
            "inMyMeals": true,
            "category": pFood.foodCategory!,
            "ingredientNames": pFood.ingredientNames!,
            "ingredientValues": pFood.ingredientValues!,
            "nutrientNames": pFood.nutrientNames!,
            "nutrientValues": pFood.nutrientValues!,
            "instructions": pFood.instructions!,
        ]
        
        docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "test").collection("food").addDocument(data: docData, completion: { error in
            if let error = error {
                print("Error in logCustomMeal method: \(error.localizedDescription)")
                completion(false)
            }
        })
        
        NotificationManager.instance.scheduleNotification(mealType: pMealType, foodTitle: pFood.name!, docRef: docRef.documentID)
        completion(true)
    }
    
    /**
     Adds a food item from FoodDataCentral to the user's MyMeals collection.
     - Parameter pFoodId: Food id given by the FoodData Central database for this specific item.
     - Parameter pFoodName: Name of the food item.
     - Parameter pFoodCategory: Name of the food category. This is mainly for the Lottie Animations that are attached to an aggregated food category.
     - Parameter pHighNutrients: List of nutrients that this food item is high in. This data comes from a function that ran in the view before this function is called.
     - Returns: Completion handler.
     */
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
    
    /**
     Adds a user-created meal to MyMeals.
     - Parameter pMealName: Name of the meal. Also the document title in Firebase Firestore.
     - Parameter pFoodCategory: Name of the food category. This is mainly for the Lottie Animations that are attached to an aggregated food category.
     - Parameter pIngredientNames: List of the ingredient names defined by the user.
     - Parameter pIngredientValues: List of the ingredient values defined by the user.
     - Parameter pNutrientNames: List of the nutrient names defined by the user.
     - Parameter pNutrientValues: List of the nutrient values defined by the user.
     - Returns: Completion handler.
     */
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
    
    /**
     Removes an item from a user's MyMeals collection. This is a hard-delete.
     - Parameter pFoodName: The name of the food to remove. In the MyMeals collection in Firebase Firestore, the document name is the name of the meal.
     - Returns: Completion handler.
     */
    func removeFromMyMeals(pFoodName: String, completion: @escaping () -> () = {}) {
        self.myMeals.removeAll(where: {$0.name == pFoodName})
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("myMeals").document(pFoodName).delete(completion: {_ in
            completion()
        })
    }
    
    /**
     Special credit goes to GitHub repo that I used as a resource for this!
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
    
    /**
     Special credit goes to GitHub repo that I used as a resource for this!
     Build a URL with all the necessary query parameters that will search the USDA Food Database.
     - Parameter path: The URL path that will be used for the HTTP Request
     - Parameter queryItems: This could be specific nutrient codes, search query, etc.
     - Returns: A ready-to-go URL.
     */
    func generateURL(path: String, queryItems: [URLQueryItem]) -> URL? {
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
