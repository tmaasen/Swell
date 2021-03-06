//
//  Header.swift
//  Swell
//
//  Created by Tanner Maasen on 1/29/22.
//

import SwiftUI

struct Header: View {
    @Binding var isShowingSidebar: Bool
    @EnvironmentObject var user: AuthenticationViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                //Avatar
                Button(action: {
                    withAnimation(.spring()) {
                        isShowingSidebar.toggle()
                    }
                }, label: {
                    AvatarIcon(width: 40, height: 40, isShowingSidebar: $isShowingSidebar, showPhotoPickerSheet: .constant(false))
                })
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 60)
                //Greeting Message
                Text(user.greeting)
                    .font(.custom("Ubuntu-Bold", size: 40))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
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
