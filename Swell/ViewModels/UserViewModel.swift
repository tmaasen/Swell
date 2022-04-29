//
//  UserViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 1/26/22.
//

import Firebase
import SwiftUI
import GoogleSignIn
import BackgroundTasks

class UserViewModel: ObservableObject {
    private var db = Firestore.firestore()
    static var isEveningGradient = false
    var hasPersistedSignedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    let avatarCache = NSCache<NSString, UIImage>()
    @Published var hasProfilePic: Bool = false
    @Published var user = User()
    @Published var greeting: String = ""
    @Published var avatarImage: UIImage = UIImage(systemName: "person.circle.fill")!
    @Published var gradient: Gradient = Gradient(stops: [
                                                    .init(color: Color.morningLinear1, location: 0),
                                                    .init(color: Color.morningLinear2, location: 0.22),
                                                    .init(color: Color.morningLinear3, location: 0.35)])
    
    init() {
        if hasPersistedSignedIn {
            self.getAllUserInfo()
        }
        self.getAvatarImage(completion: { image in
            self.avatarImage = image
        })
    }
    
    func getAllUserInfo() {
        self.setGradient()
        self.getAvatarImage(completion: { image in
            self.avatarImage = image
        })
        self.getUser(completion: { currentUser in
            self.setGreeting(name: GIDSignIn.sharedInstance.currentUser?.profile?.givenName ?? currentUser.fname)
            return
        })
    }
    
    // gets all user information, but not the greeting message
    func getUser(completion: @escaping (User) -> () = {_ in }) {
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "user")
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("Error in getUser method:", error?.localizedDescription ?? "")
                self.setNewUser(fname: GIDSignIn.sharedInstance.currentUser?.profile?.givenName ?? "",
                           lname: GIDSignIn.sharedInstance.currentUser?.profile?.familyName ?? "")
                completion(User())
                return
            }
            if let document = document, document.exists {
                do {
                    self.user = try document.data(as: User.self)
                    completion(self.user)
                }
                catch {
                    print(error)
                }
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
        ]
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").setData(docData, merge: true) { err in
            if let err = err {
                print("Error in updateUser method: \(err.localizedDescription)")
            } else {
                self.getUser(completion: { user in
                    self.setGreeting(name: user.fname)
                })
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
                completion()
            }
        }
    }
    
    func softDeleteUser() {
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "user").updateData([
            "isDeleted": true
        ])
        { err in
            if let err = err {
                print("Error in deleteUser method: \(err.localizedDescription)")
            } else {
                self.deleteAvatarImage(pUser: Auth.auth().currentUser?.uid ?? "")
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
    
    func getAvatarImage(completion: @escaping (UIImage) -> () = {_ in }) {
        let ref = Storage.storage().reference().child(Auth.auth().currentUser?.uid ?? "")
        // First check if image is in cache. If so, grab it
        if let image = self.avatarCache.object(forKey: "profilePic") {
            print("Using cache for profile picture")
            self.hasProfilePic = true
            completion(image)
        } else {
            // Else, download it from Firebase Storage
            ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
              if let error = error {
                print("Error retrieving image: \(error.localizedDescription)")
                self.hasProfilePic = false
                completion(UIImage())
                return
              } else {
                let image = UIImage(data: data!)
                self.hasProfilePic = true
                self.avatarImage = image!
                // Set the image to cache
                DispatchQueue.main.async {
                    self.avatarCache.setObject(image!, forKey: "profilePic")
                }
                completion(image!)
              }
            }
        }
    }
    
    func setAvatarImage(pImage: UIImage) {        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storage = Storage.storage()
        let ref = storage.reference(withPath: uid)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        guard let imageData = pImage.jpegData(compressionQuality: 0.3) else { return }
        ref.putData(imageData, metadata: metadata) { metaData, error in
            if let error = error {
                print("Error putting image in storage: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func deleteAvatarImage(pUser: String) {
        let ref = Storage.storage().reference().child(Auth.auth().currentUser?.uid ?? "")

        ref.delete { error in
          if let error = error {
            print("Error removing avatar image: \(error.localizedDescription)")
          }
        }
    }
    
    // Sets greeting message
    func setGreeting(name: String) {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<5 :
            self.greeting = "Good evening, \n\(name)"
        case 5..<12 :
            self.greeting = "Good morning, \n\(name)"
        case 12..<17 :
            self.greeting = "Good afternoon, \n\(name)"
        case 17..<24 :
            self.greeting = "Good evening, \n\(name)"
        default:
            self.greeting = "Hello"
            return
        }
    }
    
    // Sets background gradient
    func setGradient() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<5 :
            UserViewModel.isEveningGradient = true
            self.gradient = Gradient(stops: [
                                        .init(color: Color.eveningLinear1, location: 0.23),
                                        .init(color: Color.eveningLinear2, location: 0.84)])
        case 5..<17 :
            UserViewModel.isEveningGradient = false
            self.gradient = Gradient(stops: [
                                        .init(color: Color.morningLinear1, location: 0),
                                        .init(color: Color.morningLinear2, location: 0.42),
                                        .init(color: Color.morningLinear3, location: 0.60)])
        case 17..<24 :
            UserViewModel.isEveningGradient = true
            self.gradient = Gradient(stops: [
                                        .init(color: Color.eveningLinear1, location: 0.23),
                                        .init(color: Color.eveningLinear2, location: 0.84)])
        default:
            return
        }
    }
    
}
