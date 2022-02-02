//
//  UserViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 1/26/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

// Basically an interface
protocol UserViewModelProtocol {
    func getUser()
    func updateUser()
}

class UserViewModel: ObservableObject {
    private var db = Firestore.firestore()
    private var utils = UtilFunctions()
    private var currentUser = Auth.auth().currentUser?.uid
    @Published var user = User()
    
    init() {
        getUser()
    }
    
    // gets all user information
    func getUser() {
        if currentUser != nil {
            let docRef = db.collection("users").document(currentUser ?? "user")
            docRef.getDocument { (document, error) in
                guard error == nil else {
                    print("Error retrieving user document. ", error?.localizedDescription ?? "")
                    return
                }
                if let document = document, document.exists {
                    do {
                        self.user = try document.data(as: User.self) ?? self.user
                        self.utils.getGreetingMessage(name: self.user.fname)
//                        print(self.user.fname)
//                        print(UtilFunctions.greeting)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func updateUser(user: User) {
        let docRef = db.collection("users").document(self.currentUser ?? "user")
        do {
            try docRef.setData(from: user)
        }
        catch {
            print(error)
        }
    }
    
    func addUserInfo() {
        let docRef = db.collection("users").document(self.currentUser ?? "user")
        do {
            try docRef.setData(from: user)
        }
        catch {
            print(error)
        }
    }
}
