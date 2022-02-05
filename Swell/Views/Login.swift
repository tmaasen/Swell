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
    
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var showAuthLoader: Bool = false
    @State private var isAuthenticated: Bool = false
    @State private var showForgotPWAlert: Bool = false
    @State private var showInvalidPWAlert: Bool = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @StateObject var userViewModel = UserViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            Image("LoginImage")
                .resizable()
                .frame(width: 80, height: 80)
            
            Text("Swell: Live Life Well")
                .foregroundColor(.swellOrange)
                .font(.custom("Ubuntu-Bold", size: 35))
                .padding(.top, 15)
                .multilineTextAlignment(.center)
            
            VStack {
                TextField("Email Address", text: $emailAddress)
                    .withLoginStyles()
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $password)
                    .withSecureFieldStyles()
                NavigationLink(destination: Home(), isActive: $isAuthenticated) { }
                Button("Sign In") {
                    toggleLoadingIndicator()
                    authViewModel.signInWithEmail(email: emailAddress, password: password)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if authViewModel.state != .signedIn {
                            showInvalidPWAlert = true
                            showAuthLoader = false
                        } else {
                            isAuthenticated = true
                            showAuthLoader = false
                        }
                    }
                }
                .withButtonStyles()
                .disabled(emailAddress.isEmpty || password.isEmpty)
                .alert(isPresented: $showInvalidPWAlert) {
                    Alert(title: Text("Email or Password Incorrect"))
                }
            }.padding()
            
            Divider()
            
            GoogleSignInButton()
                .padding()
                .onTapGesture {
                    authViewModel.signIn()
                }.frame(width: 220, height: 80)
            
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
                            authViewModel.resetPassword(email: text)
                        }
                    })
            .frame(width: 200, height: 30)
        }.onTapGesture {
                hideKeyboard()
            }
    }
    func toggleLoadingIndicator() {
        hudCoordinator.showHUD {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor(white: 0, alpha: 0.4)
            hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 4, opacity: 0.9)
            hud.vibrancyEnabled = true
            hud.textLabel.text = "Loading"
            if showAuthLoader == false {
                hud.dismiss(afterDelay: 0.0)
            }
            return hud
        }
    }
}

// FOR DEBUG
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
