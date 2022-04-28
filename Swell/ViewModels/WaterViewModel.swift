//
//  WaterViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 4/28/22.
//

import Foundation
import Firebase

class WaterViewModel: ObservableObject {
    var db = Firestore.firestore()
    let formatter = DateFormatter()
    @Published var waters = FoodRetriever()
    @Published var isNewDay: Bool = false
    var loggedOunces = [Double]()
    
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
}
