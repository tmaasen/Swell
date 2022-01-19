//
//  Home.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth
import SDWebImageSwiftUI

struct Home: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authModel: AuthenticationViewModel
    @EnvironmentObject var api: API
    private let googleUser = GIDSignIn.sharedInstance.currentUser
    @State var loggedOut: Bool = false
    var pexels = PexelImage()
    
  var body: some View {
//    let imageURL = URL(string: pexels.url)
    NavigationView {
        VStack {
            NetworkImage(url: googleUser?.profile?.imageURL(withDimension: 100))
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .topLeading)
                .cornerRadius(8.0)
// Call Pexel Image
//            WebImage(url: imageURL)
//                .resizable()
//                .frame(width: 100, height: 100, alignment: .center)
            
            // Logout Functionality
            NavigationLink(destination: Login(), isActive: $loggedOut) { }
            Button("Sign Out") {
                authModel.signOut()
                presentationMode.wrappedValue.dismiss()
            }.withButtonStyles()
        }
        .navigationTitle(UtilFunctions.greeting)
    }
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
