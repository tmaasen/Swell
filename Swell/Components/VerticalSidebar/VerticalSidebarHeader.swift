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
        ZStack(alignment: .topTrailing) {
            //Close Sidebar
            Button(action: {
                withAnimation(.spring()) {
                    isShowingSidebar.toggle()
                }
            }, label: {
                Image(systemName: "xmark")
                    .frame(width: 32, height: 32)
                    .foregroundColor(.black)
                    .padding()
            })
            //AvatarIcon
            VStack(alignment: .leading) {
                NetworkImage(url: googleUser?.profile?.imageURL(withDimension: 100))
                    .scaledToFit()
                    .clipped()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.bottom, 14)
                
                Text("Tanner Maasen")
                    .font(.custom("Ubuntu-Bold", size: 34))
                Text("tmaasen@gmail.com")
                    .font(.custom("Ubuntu-Italic", size: 20))
                    .foregroundColor(.gray)
                
                Spacer()
                
            }.padding()
        }
    }
}

struct VerticalSidebarHeader_Previews: PreviewProvider {
    static var previews: some View {
        VerticalSidebarHeader(isShowingSidebar: .constant(true))
    }
}
