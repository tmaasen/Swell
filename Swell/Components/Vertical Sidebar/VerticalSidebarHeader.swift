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
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Binding var isShowingSidebar: Bool
    
    var body: some View {        
        VStack(alignment: .leading) {
            AvatarIcon(isShowingSidebar: $isShowingSidebar, showPhotoPickerSheet: .constant(false), width: 80, height: 80)
                .padding(.bottom, 14)
            Text(googleUser?.profile?.name ?? (authViewModel.user.fname + " " + authViewModel.user.lname))
                .font(.custom("Ubuntu-Bold", size: 26))
            Text(Auth.auth().currentUser?.email ?? "johndoe@test.com")
                .font(.custom("Ubuntu-Italic", size: 14))
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct VerticalSidebarHeader_Previews: PreviewProvider {
    static var previews: some View {
        VerticalSidebarHeader(isShowingSidebar: .constant(true))
    }
}
