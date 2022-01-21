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
    @State private var loggedOut: Bool = false
    @State private var isShowingSidebar: Bool = false
    var pexels = PexelImage()
    
    var body: some View {
        NavigationView {
            ZStack {
                if isShowingSidebar {
                    VerticalSidebarMain(isShowingSidebar: $isShowingSidebar)
                }
                VStack(alignment: .leading) {
                    //Avatar
                    Button(action: {
                        withAnimation(.spring()) {
                            isShowingSidebar.toggle()
                        }
                    }, label: {AvatarIcon()})
                    //Greeting Message
                    Text((UtilFunctions.greeting=="" ? "Hello" : UtilFunctions.greeting))
                        .font(.custom("Ubuntu-Bold", size: 40))
                        .foregroundColor(.white)
                    //Logout Functionality
                    NavigationLink(destination: Login(), isActive: $loggedOut) { }
                    Button("Sign Out") {
                        authModel.signOut()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .cornerRadius(isShowingSidebar ? 20 : 10)
                .scaleEffect(isShowingSidebar ? 0.8 : 1)
                .navigationBarHidden(true)
                .padding()
                .offset(x: isShowingSidebar ? 300 : 0, y: isShowingSidebar ? 44 : 0)
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
  }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
