//
//  MyMealsViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 4/20/22.
//

import Foundation
import Firebase

class MyMealsViewModel: ObservableObject {
    private var db = Firestore.firestore()
    let formatter = DateFormatter()
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
            for document in querySnapshot!.documents {
                
                myMeal.name = document.get("name") as? String
                myMeal.isCustomMeal = document.get("isCustomMeal") as? Bool
                myMeal.date = document.get("date") as? String
                
                if document.get("isCustomMeal") as? Bool == true {
                    myMeal.ingredientNames = document.get("ingredientNames") as? [String]
                    myMeal.ingredientValues = document.get("ingredientValues") as? [String]
                    myMeal.nutrientNames = document.get("nutrientNames") as? [String]
                    myMeal.nutrientValues = document.get("nutrientValues") as? [String]
                    myMeal.instructions = document.get("instructions") as? String
                }
                self.myMeals.append(myMeal)
                completion()
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
    
    func addToMyMeals(pFood: Food, completion: @escaping () -> () = {}) {
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        var highNutrients = [String]()
        // if food is high in nutrient, log nutrient
        // 20% DV or more of a nutrient per serving is considered high (fda)
        for nutrient in pFood.foodNutrients {
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
            "foodId": pFood.fdcID,
            "name": pFood.foodDescription,
            "highIn": highNutrients,
            "isCustomMeal": false,
            "date": formatter.string(from: Timestamp(date: Date()).dateValue()),
        ]
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("myMeals")
            .document(pFood.foodDescription).setData(docData, completion: { error in
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
}
