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
    @State private var showInvalidPWAlert: Bool = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @ObservedObject var userViewModel = UserViewModel()
    
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
                    NavigationLink(destination: Home(), isActive: $isAuthenticated) { }
                    Button("Sign In") {
                        authViewModel.signInWithEmail(email: emailAddress, password: password)
                        showLoadingIndicator(pAfterDelay:2.0)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            if authViewModel.state != .signedIn {
                                showInvalidPWAlert = true
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
                                authViewModel.resetPassword(email: text)
                            }
                        })
            }
        }
    }
    
    private func showLoadingIndicator(pAfterDelay:Double) {
        hudCoordinator.showHUD {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor(white: 0, alpha: 0.4)
            hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 4, opacity: 0.9)
            hud.vibrancyEnabled = true
            hud.textLabel.text = "Loading"
            hud.dismiss(afterDelay: pAfterDelay)
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
