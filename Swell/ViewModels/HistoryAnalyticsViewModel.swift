//
//  HistoryAnalyticsViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 3/26/22.
//

import Foundation
import Firebase

class HistoryAnalyticsViewModel: ObservableObject {
    let db = Firestore.firestore()
    var totalDataPoints: Double = 0
    var happyMoods: Double = 0
    var neutralMoods: Double = 0
    var sickMoods: Double = 0
    var overateMoods: Double = 0
    
    func getGraph1Data(completion: @escaping ([Double]) -> () = {_ in }) {
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .getDocuments(completion: { querySnapshot, error in
            if let error = error {
                print("Error in getGraph1Data method: \(error.localizedDescription)")
            } else {
                self.totalDataPoints = Double(querySnapshot?.count ?? 0)
                self.happyMoods = 0
                self.neutralMoods = 0
                self.sickMoods = 0
                self.overateMoods = 0
                // sort them by mood
                for document in querySnapshot!.documents {
                    let mood = document.get("mood") as! String
                    switch mood {
                    case Mood.happy.text:
                        self.happyMoods+=1
                    case Mood.neutral.text:
                        self.neutralMoods+=1
                    case Mood.sick.text:
                        self.sickMoods+=1
                    default:
                        self.overateMoods+=1
                    }
                }
                completion([self.totalDataPoints, self.happyMoods, self.neutralMoods, self.sickMoods, self.overateMoods])
            }
        })
    }
    
    func getGraph2Data(pNutrient: String?, completion: @escaping ([Double]) -> () = {_ in }) {
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .whereField("highIn", arrayContains: pNutrient ?? "")
            .getDocuments(completion: { querySnapshot, error in
            if let error = error {
                print("Error in getGraph2Data method: \(error.localizedDescription)")
            } else {
                self.totalDataPoints = Double(querySnapshot?.count ?? 0)
                self.happyMoods = 0
                self.neutralMoods = 0
                self.sickMoods = 0
                self.overateMoods = 0
                // sort them by mood
                for document in querySnapshot!.documents {
                    let mood = document.get("mood") as! String
                    switch mood {
                    case Mood.happy.text:
                        self.happyMoods+=1
                    case Mood.neutral.text:
                        self.neutralMoods+=1
                    case Mood.sick.text:
                        self.sickMoods+=1
                    default:
                        self.overateMoods+=1
                    }
                }
                completion([self.totalDataPoints, self.happyMoods, self.neutralMoods, self.sickMoods, self.overateMoods])
            }
        })
    }
    
    func getGraph3Data(pContains: String?, completion: @escaping ([Double]) -> () = {_ in }) {
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .whereField("contains", arrayContains: pContains ?? "")
            .getDocuments(completion: { querySnapshot, error in
            if let error = error {
                print("Error in getGraph3Data method: \(error.localizedDescription)")
            } else {
                self.totalDataPoints = Double(querySnapshot?.count ?? 0)
                self.happyMoods = 0
                self.neutralMoods = 0
                self.sickMoods = 0
                self.overateMoods = 0
                // sort them by mood
                for document in querySnapshot!.documents {
                    let mood = document.get("mood") as! String
                    switch mood {
                    case Mood.happy.text:
                        self.happyMoods+=1
                    case Mood.neutral.text:
                        self.neutralMoods+=1
                    case Mood.sick.text:
                        self.sickMoods+=1
                    default:
                        self.overateMoods+=1
                    }
                }
                completion([self.totalDataPoints, self.happyMoods, self.neutralMoods, self.sickMoods, self.overateMoods])
            }
        })
    }
}
