//
//  UserViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 1/26/22.
//

import Foundation
import Firebase

// Basically an interface
protocol iUserViewModelProtocol {
    func getUser()
    func updateUser()
} 

class UserViewModel: ObservableObject {
    private var db = Firestore.firestore()
//    private var utils = UtilFunctions()
    @Published var user = User()
    
    init() {
        getUser()
    }
    
    // gets all user information
    func getUser() {
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "user")
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("Error retrieving user document. ", error?.localizedDescription ?? "")
                return
            }
            if let document = document, document.exists {
                do {
                    self.user = try document.data(as: User.self) ?? self.user
                    print("User: \(self.user)")
//                    self.utils.getGreetingMessage(name: self.user.fname)
//                    print(self.utils.greeting)
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
                print("Error writing document: \(err)")
            } else {
                print("Login timestamp successfully written!")
            }
        }
        // now that they're logged in, get user info
        getUser()
    }
    
    func deleteUser() {
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").updateData([
            "isDeleted": true
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("User successfully deleted!")
            }
        }
    }
        
    func updateUser(fname: String, lname: String, age: Int, gender: String, height: Int, weight: Int) {
        let docData: [String: Any] = [
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
                print("Error writing document: \(err)")
            } else {
                print("setUser document successfully written!")
            }
        }
        getUser()
    }
    
    func setNewUser(fname: String, lname: String, age: Int, gender: String, height: Int, weight: Int) {
        let docData: [String: Any] = [
            "fname": fname,
            "lname": lname,
            "age": age,
            "gender": gender,
            "height": height,
            "weight": weight,
            "isDeleted": false,
            "lastLoggedIn": Timestamp(date: Date())
        ]
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("New user successfully written!")
                self.getUser()
            }
        }
    }
}
