//
//  UserViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 1/26/22.
//

import Foundation
import Firebase
import SwiftUI

// Basically an interface
protocol iUserViewModelProtocol {
    func getUser()
    func updateUser()
} 

class UserViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var user = User()
    @Published var greeting: String = ""
    @Published var gradient: Gradient = Gradient(stops: [
                                                    .init(color: Color.morningLinear1, location: 0),
                                                    .init(color: Color.morningLinear2, location: 0.22),
                                                    .init(color: Color.morningLinear3, location: 0.35)])
    
    // gets all user information
    func getUser() {
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "user")
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("Error in getUser method:", error?.localizedDescription ?? "")
                return
            }
            if let document = document, document.exists {
                do {
                    self.user = try document.data(as: User.self) ?? self.user
                    self.getGreeting(name: self.user.fname)
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
    func setLoginTimestamp() {
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").updateData([
            "lastLoggedIn": Timestamp(date: Date())]) { err in
            if let err = err {
                print("Error in setLoginTimestamp method: \(err.localizedDescription)")
            } else {
                print("Login timestamp successfully written!")
            }
        }
    }
    
    func softDeleteUser() {
        //        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").delete()
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").updateData([
            "isDeleted": true
        ])
        { err in
            if let err = err {
                print("Error in deleteUser method: \(err.localizedDescription)")
            } else {
                print("User \(Auth.auth().currentUser?.uid ?? "nil") successfully deleted")
            }
        }
    }
        
    func updateUser(fname: String, lname: String, age: Int, gender: String, height: Int, weight: Int) {
        let docData: [String: Any] = [
            "userId": Auth.auth().currentUser?.uid ?? "",
            "fname": fname,
            "lname": lname,
            "age": age,
            "gender": gender,
            "height": height,
            "weight": weight,
//            "arrayExample": [5, true, "hello"],
//            "nullExample": NSNull(),
//            "objectExample": [
//                "a": 5,
//                "b": [
//                    "nested": "foo"
//                ]
//            ]
        ]
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").setData(docData, merge: true) { err in
            if let err = err {
                print("Error in updateUser method: \(err.localizedDescription)")
            } else {
                self.getUser()
            }
        }
    }
    
    func setNewUser(fname: String, lname: String, age: Int, gender: String, height: Int, weight: Int) {
        let docData: [String: Any] = [
            "userId": Auth.auth().currentUser?.uid ?? "",
            "fname": fname,
            "lname": lname,
            "age": age,
            "gender": gender,
            "height": height,
            "weight": weight,
            "isDeleted": false,
        ]
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").setData(docData) { err in
            if let err = err {
                print("Error in setNewUser method: \(err.localizedDescription)")
            } else {
                print("New user successfully written!")
            }
        }
    }
    
    // Gets greeting message and sets background gradient
    func getGreeting(name: String) {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<5 :
            self.gradient = Gradient(stops: [
                                        .init(color: Color.eveningLinear1, location: 0.23),
                                        .init(color: Color.eveningLinear2, location: 0.84)])
            self.greeting = "Good evening, \n\(name)"
        case 5..<12 : self.greeting = "Good morning, \n\(name)"
        case 12..<17 : self.greeting = "Good afternoon, \n\(name)"
        case 17..<24 :
            self.gradient = Gradient(stops: [
                                        .init(color: Color.eveningLinear1, location: 0.23),
                                        .init(color: Color.eveningLinear2, location: 0.84)])
            self.greeting = "Good evening, \n\(name)"
        default:
            self.greeting = "Hello"
        }
    }
}
