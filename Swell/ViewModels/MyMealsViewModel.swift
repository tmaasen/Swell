//
//  MyMealsViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 4/20/22.
//

import Foundation
import Firebase

class MyMealsViewModel: UserViewModel {
    var db = Firestore.firestore()
    @Published var items = [MyMeal]()
    
    func getMyMeals(completion: @escaping () -> () = {}) {
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("myMeals")
        
        docRef.addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error in getFoodIds method:", error?.localizedDescription ?? "")
                completion()
                return
            }
            print(querySnapshot?.documents as Any)
            
//            for document in querySnapshot!.documents {
//            }
        }
    }
    
    /// Custom foods created by the user will not have a heart icon
    func isLiked(pFdcId: Int) -> Bool {
        // check if any document in collection contains the fdcId
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("myMeals")
        return true
    }
    
    func addMeal(pFdcId: Int) {
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("myMeals")
    }
    
    func removeMeal(pFdcId: Int) {
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("myMeals")
    }
    
    func addCustomMeal() {
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("myMeals")
    }
}
