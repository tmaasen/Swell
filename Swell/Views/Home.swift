//
//  Home.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct Home: View {
    
    @State var isMorning: Bool = true
    @EnvironmentObject var authModel: AuthenticationViewModel
    private let googleUser = GIDSignIn.sharedInstance.currentUser
    @State var isAuthenticated: Bool = true
    
  var body: some View {
    NavigationView {
        //        NetworkImage(url: user?.profile?.imageURL(withDimension: 100))
        //            .aspectRatio(contentMode: .fit)
        //            .frame(width: 40, height: 40, alignment: .topLeading)
        //            .cornerRadius(8.0)
        //Spacer()
        VStack {
            NavigationLink(
                destination: Login(),
                isActive: $isAuthenticated,
                label: {
                    Button("Sign Out") {
                        authModel.signOut()
                        if Auth.auth().currentUser == nil {
                            isAuthenticated = false
                        }
                    }.withButtonStyles()
                })
            
        }
    }
    .navigationTitle("Home")
    .navigationBarBackButtonHidden(true)
  }
    
}

/// A generic view that shows images from the network.
struct NetworkImage: View {
  let url: URL?

  var body: some View {
    if let url = url,
       let data = try? Data(contentsOf: url),
       let uiImage = UIImage(data: data) {
      Image(uiImage: uiImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
    } else {
      Image(systemName: "person.circle.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
    }
  }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
