//
//  Header.swift
//  Swell
//
//  Created by Tanner Maasen on 1/29/22.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct Header: View {
    @Binding var isShowingSidebar: Bool
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                //Avatar
                Button(action: {
                    withAnimation(.spring()) {
                        isShowingSidebar.toggle()
                    }
                }, label: {AvatarIcon(isShowingSidebar: $isShowingSidebar)}).buttonStyle(PlainButtonStyle())
                //Greeting Message
                Text(userViewModel.greeting)
                    .font(.custom("Ubuntu-Bold", size: 40))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
            .navigationBarHidden(true)
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(isShowingSidebar: .constant(true))
    }
}
