//
//  AuthenticationViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import Firebase
import GoogleSignIn

class AuthenticationViewModel: UserViewModel {

    enum SignInState {
        case signedIn
        case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    @Published var needsToReauthenticate: Bool = false
    @Published var errorMessage: String = ""
    
    override init() {
        super.init()
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn {
                [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
    }
//    override init() {
//        super.init()
//        if hasPersistedSignedIn {
//            if GIDSignIn.sharedInstance.hasPreviousSignIn() {
//                GIDSignIn.sharedInstance.restorePreviousSignIn {
//                    [unowned self] user, error in
//                    authenticateUser(for: user, with: error)
//                }
//            }
//        }
//    }
    
    // sign in with email and password
    func signInWithEmail(email: String, password: String, completion: @escaping () -> () = {}) {
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            if result != nil, error == nil {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.getAllUserInfo()
                self.setLoginTimestamp()
                self.state = .signedIn
                completion()
                return
            } else {
                print(error?.localizedDescription ?? "Error signing in with email and pw")
                completion()
                return
            }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping () -> () = {}) {
        Auth.auth().createUser(withEmail: email, password: password) {result, error in
            if result != nil, error == nil {
                // user is also logged in when registered
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.state = .signedIn
                print(self.state)
                completion()
                return
            } else {
                print(error?.localizedDescription ?? "Error Signing Up User")
                completion()
                return
            }
        }
    }
    
    // sign in with Google
    func signInWithGoogle(completion: @escaping () -> () = {}) {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn {
                [unowned self] user, error in
                print("Restoring previous session")
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: clientID)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController
                else { return }
            
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
                authenticateUser(for: user, with: error, completion: {
                    completion()
                })
            }
        }
    }
    
    func authenticateUser(for user: GIDGoogleUser?, with error: Error?, completion: @escaping () -> () = {}) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user?.authentication, let idToken = authentication.idToken
            else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion()
                return
            } else {
                self.getAllUserInfo()
                self.setLoginTimestamp()
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.state = .signedIn
                print(self.state)
                completion()
                return
            }
        }
    }
    
    func verifyEmail() {
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            if error != nil {
                return
            }
        }
    }
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                return
            }
        }
    }
    
    // Function will work for all sign out methods
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            self.state = .signedOut
            print(self.state)
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            self.user = User()
            self.greeting = ""
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeAccount() {
        self.softDeleteUser()
        
        Auth.auth().currentUser?.delete { error in
          if let error = error {
            self.needsToReauthenticate = true
            print("Error removing account: ", error.localizedDescription)
            self.errorMessage = error.localizedDescription
          } else {
            self.needsToReauthenticate = false
            self.signOut()
          }
        }
    }
}
