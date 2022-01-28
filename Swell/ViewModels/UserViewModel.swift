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

protocol UserViewModelProtocol {
    func getUser()
    func updateUser()
}

class UserViewModel: ObservableObject {
    private var db = Firestore.firestore()
    private var utils = UtilFunctions()
    private var currentUser = Auth.auth().currentUser?.uid
    @Published var user = User()
    @Published var title = "The Sandlot"
    
    // gets all user information
    func getUser() {
        if currentUser != nil {
            let docRef = db.collection("users").document(currentUser ?? "user")
            docRef.getDocument { (document, error) in
                if let error = error as NSError? {
                    print("Error getting document: \(error.localizedDescription)")
                }
                else {
                    if let document = document {
                        do {
                            self.user = try document.data(as: User.self) ?? self.user
                            print(self.user)
                            self.title = "The Sandlot 2"
                            self.utils.getGreetingMessage(name: self.user.fname)
                        }
                        catch {
                            print(error)
                        }
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
}
