//
//  FoodAndWaterViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 3/24/22.
//

import Foundation
import Firebase

class FoodAndWaterViewModel: FoodDataCentralViewModel {
    // Retrieving Water History
    @Published var waters = FoodRetriever()
    @Published var isNewDay: Bool = false
    @Published var isLoading: Bool = false
    @Published var selectedLogDate: Date = Date()
    var loggedOunces = [Double]()

    func getFood(date: Date = Timestamp(date: Date()).dateValue(), completion: @escaping () -> () = {}) {
        var foodIds = [String]()
        var foodNames = [String]()
        var mealTypes = [String]()
        var servingSizes = [Int]()
        var moods = [String]()
        var comments = [String]()
        var docIds = [String]()
        formatter.dateFormat = "EEEE MMM dd, yyyy"
        let pDate = formatter.string(from: date)
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").collection("food").whereField("date", isEqualTo: pDate)
        
        docRef.addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error in getFoodIds method:", error?.localizedDescription ?? "")
                completion()
                return
            }
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
            foodIds.isEmpty ?
                completion() :
                self.getFoodsById(foodIds, mealTypes, servingSizes, moods, comments, docIds, foodNames, completion: {
                    completion()
                })
        }
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
            "foodName": pFoodToLog.foodDescription,
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
//            else {
                // wish I could just append the food to my foodHistory array, but the data types and json structure don't match up in the API search and get methods
//                self.getAllHistoryByDate(date: Date())
//            }
        })
        
        NotificationManager.instance.scheduleNotification(mealType: pMeal, foodTitle: pFoodToLog.foodDescription, docRef: docRef.documentID)
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
            .addSnapshotListener { (documentSnapshot, error) in
                guard error == nil else {
                    print("Error in getWater method:", error?.localizedDescription ?? "")
                    return
                }
                if let documentSnapshot = documentSnapshot, !documentSnapshot.exists {
                    if pDate == today {
                        self.isNewDay = true
                        completion()
                    }
                } else if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                    self.isNewDay = false
                    self.waters.waterLoggedToday = documentSnapshot.get("waters logged") as? Int
                    self.waters.waterOuncesToday = documentSnapshot.get("total ounces") as? Double
                    self.waters.docId = documentSnapshot.documentID
                    completion()
                }
            }
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
        // if watersLoggedToday = 1, new doc...else, update doc
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
                    return
                } else {
                    completion()
                }
            }
    }
    
    func getAllHistoryByDate(date: Date = Timestamp(date: Date()).dateValue(), completion: @escaping () -> () = {}) {
        self.selectedLogDate = date
        self.foodHistory.removeAll()
        self.waters.waterOuncesToday = 0
        self.waters.waterLoggedToday = 0
        self.getFood(date: date, completion: {
            print("got food")
            self.getWater(date: date, completion: {
                print("got water")
                completion()
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
}
