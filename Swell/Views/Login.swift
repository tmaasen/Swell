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
    @State private var showForgotPWAlert: Bool = false
    @State private var showInvalidPWAlert: Bool = false
    @State private var isAuthenticated: Bool = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            NavigationLink(destination: Home(), isActive: $isAuthenticated) {}
            Spacer()
            Image("LoginImage")
                .resizable()
                .frame(width: 80, height: 80)
            
            Text("Swell: Live Life Well")
                .foregroundColor(colorScheme == .dark ? .white : .swellOrange)
                .font(.custom("Ubuntu-Bold", size: 35))
                .padding(.top, 15)
            
            VStack {
                TextField("Email Address", text: $emailAddress)
                    .withLoginStyles()
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $password)
                    .withSecureFieldStyles()
                Button(action: {
                    hideKeyboard()
                    toggleLoadingIndicator()
                    authViewModel.signInWithEmail(email: emailAddress, password: password, completion: {
                        if authViewModel.state != .signedIn {
                            showInvalidPWAlert = true
                        } else {
                            isAuthenticated = true
                        }
                        showAuthLoader = false
                    })
                }) {
                    Text("Sign In")
                        .withButtonStyles()
                        .disabled(emailAddress.isEmpty || password.isEmpty)
                        .alert(isPresented: $showInvalidPWAlert) {
                            Alert(title: Text("Email or Password Incorrect"))
                        }
                }
            }
            .padding()
            
            Spacer()
            
            GoogleSignInButton()
                .padding()
                .onTapGesture {
                    hideKeyboard()
                    authViewModel.signInWithGoogle()
                    if authViewModel.state == .signedIn {
                        isAuthenticated = true
                    }
                }.frame(width: 220, height: 80)
            
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(Color("FoodListItem_DarkGray"))
                NavigationLink(destination: Register(), label: {
                    Text("Register")
                        .bold()
                        .foregroundColor(.swellOrange)
                })
            }
            
            Button {
                showForgotPWAlert = true
            } label: {
                Text("Forgot Password")
                    .bold()
                    .foregroundColor(.swellOrange)
            }
            .alert(isPresented: $showForgotPWAlert,
                    TextAlert(
                        title: "Reset Password",
                        message: "Enter your Swell account email address, then check your email for further instructions.",
                        keyboardType: .emailAddress)
                    { result in
                        if let text = result {
                            authViewModel.resetPassword(email: text)
                        }
                    }).frame(width: 200, height: 30)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
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
                hud.dismiss(afterDelay: 3.0)
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
