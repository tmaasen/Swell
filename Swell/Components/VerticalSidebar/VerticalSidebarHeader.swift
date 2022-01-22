//
//  VerticalSidebarHeader.swift
//  Swell
//
//  Created by Tanner Maasen on 1/20/22.
//

import SwiftUI
import GoogleSignIn

struct VerticalSidebarHeader: View {
    private let googleUser = GIDSignIn.sharedInstance.currentUser
    @Binding var isShowingSidebar: Bool
    
    var body: some View {        
        VStack(alignment: .leading) {
            NetworkImage(url: googleUser?.profile?.imageURL(withDimension: 100))
                .scaledToFit()
                .clipped()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .padding(.bottom, 14)
            
            Text(googleUser?.profile?.name ?? "Tanner Maasen")
                .font(.custom("Ubuntu-Bold", size: 26))
            Text(googleUser?.profile?.email ?? "tmaasen@gmail.com")
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
