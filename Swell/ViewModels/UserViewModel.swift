//
//  UserViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 1/26/22.
//

import Foundation
import Firebase
import SwiftUI
import GoogleSignIn
import BackgroundTasks

// Basically an interface
protocol iUserViewModelProtocol {
    func getUser()
    func updateUser()
} 

class UserViewModel: ObservableObject {
    private var db = Firestore.firestore()
    static var isEveningGradient = false
    @Published var user = User()
    var hasPersistedSignedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @Published var greeting: String = ""
    @Published var gradient: Gradient = Gradient(stops: [
                                                    .init(color: Color.morningLinear1, location: 0),
                                                    .init(color: Color.morningLinear2, location: 0.22),
                                                    .init(color: Color.morningLinear3, location: 0.35)])
    
    init() {
        if hasPersistedSignedIn {
            self.getAllUserInfo()
        }
    }
    
    // gets all user information, but not the greeting message
    func getUser(completion: @escaping (User) -> () = {_ in }) {
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "user")
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("Error in getUser method:", error?.localizedDescription ?? "")
                self.setNewUser(fname: GIDSignIn.sharedInstance.currentUser?.profile?.givenName ?? "",
                           lname: GIDSignIn.sharedInstance.currentUser?.profile?.familyName ?? "")
                return
            }
            if let document = document, document.exists {
                do {
                    self.user = try document.data(as: User.self) ?? self.user
                    completion(self.user)
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
    
    func setNewUser(fname: String, lname: String, age: Int = 0, gender: String = "", height: Int = 0, weight: Int = 0, completion: @escaping () -> () = {}) {
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
                completion()
                return
            } else {
                print("New user successfully written!")
                completion()
            }
        }
    }
    
    // Gets greeting message and sets background gradient
    func getGreeting(name: String, completion: @escaping () -> () = {}) {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<5 :
            self.gradient = Gradient(stops: [
                                        .init(color: Color.eveningLinear1, location: 0.23),
                                        .init(color: Color.eveningLinear2, location: 0.84)])
            self.greeting = "Good evening, \n\(name)"
            completion()
        case 5..<12 :
            self.greeting = "Good morning, \n\(name)"
            UserViewModel.isEveningGradient = false
            completion()
        case 12..<17 :
            self.greeting = "Good afternoon, \n\(name)"
            completion()
        case 17..<24 :
            UserViewModel.isEveningGradient = true
            self.gradient = Gradient(stops: [
                                        .init(color: Color.eveningLinear1, location: 0.23),
                                        .init(color: Color.eveningLinear2, location: 0.84)])
            self.greeting = "Good evening, \n\(name)"
            completion()
        default:
            self.greeting = "Hello"
            completion()
            return
        }
    }
    
    func getAllUserInfo(completion: @escaping () -> () = {}) {
        self.getUser(completion: { currentUser in
            print("got user")
            self.getGreeting(name: GIDSignIn.sharedInstance.currentUser?.profile?.givenName ?? currentUser.fname, completion: {
                print("got greeting")
                completion()
                return
            })
        })
    }
}
