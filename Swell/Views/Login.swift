//
//  Login.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI

struct Login: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel

    var body: some View {
        Image("header_image")
          .resizable()
          .aspectRatio(contentMode: .fit)

        Text("Welcome to Swell!")
          .fontWeight(.black)
          .foregroundColor(Color(.systemIndigo))
          .font(.largeTitle)
          .multilineTextAlignment(.center)

        Text("Empower your elliptical workouts by tracking every move.")
          .fontWeight(.light)
          .multilineTextAlignment(.center)
          .padding()

        Spacer()
        
        GoogleSignInButton()
          .padding()
          .onTapGesture {
            viewModel.signIn()
          }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
