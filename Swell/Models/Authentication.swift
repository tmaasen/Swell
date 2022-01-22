//
//  AuthenticationViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import Firebase
import GoogleSignIn

class AuthenticationViewModel: ObservableObject {

    enum SignInState {
        case signedIn
        case signedOut
    }
    
    var utils = UtilFunctions()
    @Published var state: SignInState = .signedOut
    
    // sign in with email and password
    func signInWithEmail(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            if result != nil, error == nil {
                self.state = .signedIn
                self.utils.getTimeOfDay(name: "")
                print(self.state)
                return
            } else {
                return
            }
        }
    }
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) {result, error in
            guard result != nil, error == nil else {
                return
            }
        }
    }
    // sign in with Google
    func signIn() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn {
                [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: clientID)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController
                else { return }
            
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
    }
    
    func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
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
            } else {
                self.state = .signedIn
                utils.getTimeOfDay(name: GIDSignIn.sharedInstance.currentUser?.profile?.givenName)
                print(self.state)
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
            state = .signedOut
            print(self.state)
        } catch {
            print(error.localizedDescription)
        }
    }
}
