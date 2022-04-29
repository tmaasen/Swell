//
//  FoodAndWaterViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 3/24/22.
//

import Foundation
import Firebase

class FoodAndMoodViewModel: FoodDataCentralViewModel {
    var db = Firestore.firestore()
    let formatter = DateFormatter()
    
    /// Logs a food item's fdcid into Cloud Firestore
    func logFood(pFoodId: Int, pFoodName: String, pHighNutrients: [String], pQuantity: Int = 1, pMeal: String, pContains: [String] = []) {
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
            "inMyMeals": false
        ]
        
        docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "test").collection("food").addDocument(data: docData, completion: { error in
            if let error = error {
                print("Error in logFood method: \(error.localizedDescription)")
            }
        })
        
        NotificationManager.instance.scheduleNotification(mealType: pMeal, foodTitle: pFoodName, docRef: docRef.documentID)
    }
    
    func logMood(docRef: String, pMood: String?, pComments: String?, completion: @escaping () -> () = {}) {
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .document(docRef)
            .updateData([
                "mood": pMood ?? "",
                "comments": pComments ?? "No comments",
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    completion()
                } else {
                    completion()
                }
            }
    }
}
