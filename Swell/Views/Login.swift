//
//  Login.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import FirebaseAuth
import JGProgressHUD_SwiftUI

struct Login: View {
    
    @State var emailAddress: String = ""
    @State var password: String = ""
    @State var isAuthenticated: Bool = false
    @State private var showForgotPWAlert: Bool = false
    @EnvironmentObject var authModel: AuthenticationViewModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    
    var body: some View {
        
        NavigationView {
            VStack {
                Image("LoginImage")
                    .aspectRatio(contentMode: .fit)
                
                Text("Welcome to Swell")
                    .foregroundColor(.swellOrange)
                    .font(.custom("Ubuntu-Bold", size: 40))
                    .multilineTextAlignment(.center)
                
                VStack {
                    TextField("Email Address", text: $emailAddress)
                        .withTextFieldStyles()
                        .textContentType(.emailAddress)
                    SecureField("Password", text: $password)
                        .withSecureFieldStyles()
                    NavigationLink(destination: Home(), isActive: $isAuthenticated, label:{
                        Button("Sign In") {
                            authModel.signInWithEmail(email: emailAddress, password: password)
                            if Auth.auth().currentUser == nil {
                                print(isAuthenticated)
                            } else {
                                isAuthenticated = true
                            }
                        }
                        .withButtonStyles()
                    })
                    .disabled(emailAddress.isEmpty || password.isEmpty)
// causing a lot of constraint errors
//                    .alert(isPresented: $isAuthenticated) {
//                        Alert(title: Text("Email or Password Incorrect"))
//                    }
                    .navigationBarBackButtonHidden(true)
                }.padding()
                
                Divider()
                
                GoogleSignInButton()
                    .padding()
                    .onTapGesture {
                        authModel.signIn()
                    }
                
                Divider()
                
                NavigationLink("Register", destination: Register())

                Button("Forgot Password") {
                    showForgotPWAlert = true
                }.alert(isPresented: $showForgotPWAlert,
                        TextAlert(
                            title: "Reset Password",
                            message: "Enter your Swell account email address, then check your email for further instructions.",
                            keyboardType: .emailAddress)
                        { result in
                            if let text = result {
                                authModel.resetPassword(email: text)
                            }
                        })
            }
        }
    }
}

// FOR DEBUG
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
