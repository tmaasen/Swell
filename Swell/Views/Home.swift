//
//  Home.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct Home: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authModel: AuthenticationViewModel
    @EnvironmentObject var api: API
    @State var loggedOut: Bool = false
    var pexels = PexelImage()
    
    var body: some View {
        VStack(alignment: .leading) {
            AvatarIcon()
            VStack {
                Text((UtilFunctions.greeting=="" ? "Hello" : UtilFunctions.greeting))
                    .font(.custom("Ubuntu-Bold", size: 40))
                    .foregroundColor(.white)
            }
            //            VStack {
            //                // Call Pexel Image
            //                //            WebImage(url: imageURL)
            //                //                .resizable()
            //                //                .frame(width: 100, height: 100, alignment: .center)
            //
            //                // Logout Functionality
            NavigationLink(destination: Login(), isActive: $loggedOut) { }
            Button("Sign Out") {
                authModel.signOut()
                presentationMode.wrappedValue.dismiss()
            }
            //                .withButtonStyles()
            //            }
        }
        .padding(.leading, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            LinearGradient(
                gradient: UtilFunctions.gradient,
                startPoint: .top,
                endPoint: .bottom)
        )
        .ignoresSafeArea()
  }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
