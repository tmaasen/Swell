//
//  Login.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI

extension Color {
    static let swellOrange = Color("swellOrange")
}

struct Login: View {
    
    @EnvironmentObject var authModel: AuthenticationViewModel

    var body: some View {
        VStack {
            Image("LoginImage")
                .aspectRatio(contentMode: .fit)
                .padding(.top, 140)
            
            Text("Welcome to Swell")
                .foregroundColor(.swellOrange)
                .font(.custom("Ubuntu-Bold", size: 40))
                .multilineTextAlignment(.center)
            
            StandardSignIn()
            
            Divider()
            
            Text("OR")
                .foregroundColor(.gray)
                        
            GoogleSignInButton()
                .padding()
                .onTapGesture {
                    authModel.signIn()
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


struct StandardSignIn: View {
    
    @State var username: String = ""
    @State var password: String = ""
    @State var authenticationDidFail: Bool = false
    @State var authenticationDidPass: Bool = true
    @EnvironmentObject var authModel: AuthenticationViewModel
    
    var body: some View {
        return
            VStack {
                TextField("Username", text: $username)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.swellOrange, lineWidth: 2)
                    )
                    .autocapitalization(.none)
                    .padding(.bottom, 20)
                SecureField("Password", text: $password)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.swellOrange, lineWidth: 2)
                    )
                    .autocapitalization(.none)
                    .padding(.bottom, 20)
                Text("Sign In")
                    .font(.custom("Ubuntu-Bold", size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 320, height: 60)
                    .background(Color.swellOrange)
                    .cornerRadius(15.0)
                    .onTapGesture {
                        authModel.signIn()
                    }
            }
            .padding()
    }
}
