//
//  VerticalSidebarHeader.swift
//  Swell
//
//  Created by Tanner Maasen on 1/20/22.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct VerticalSidebarHeader: View {
    private let googleUser = GIDSignIn.sharedInstance.currentUser
    @ObservedObject var userViewModel = UserViewModel()
    @Binding var isShowingSidebar: Bool
    
    var body: some View {        
        VStack(alignment: .leading) {
            NetworkImage(url: googleUser?.profile?.imageURL(withDimension: 100), isShowingSidebar: $isShowingSidebar)
                .scaledToFit()
                .clipped()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .padding(.bottom, 14)
            
            Text(googleUser?.profile?.name ?? (userViewModel.user.fname + " " + userViewModel.user.lname))
                .font(.custom("Ubuntu-Bold", size: 26))
            Text(Auth.auth().currentUser?.email ?? "johndoe@test.com")
                .font(.custom("Ubuntu-Italic", size: 14))
                .foregroundColor(.gray)
        }.padding()
    }
}

struct VerticalSidebarHeader_Previews: PreviewProvider {
    static var previews: some View {
        VerticalSidebarHeader(isShowingSidebar: .constant(true))
    }
}
