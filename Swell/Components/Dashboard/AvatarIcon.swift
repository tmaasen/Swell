//
//  AvatarIcon.swift
//  Swell
//
//  Created by Tanner Maasen on 1/19/22.
//

import SwiftUI
import GoogleSignIn

struct AvatarIcon: View {
    private let googleUser = GIDSignIn.sharedInstance.currentUser
    @EnvironmentObject var user: AuthenticationViewModel
    @Binding var isShowingSidebar: Bool
    @Binding var showPhotoPickerSheet: Bool
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        HStack {
            if GIDSignIn.sharedInstance.currentUser != nil && user.avatarImage.pngData() == nil {
                NetworkImage(url: googleUser?.profile?.imageURL(withDimension: 100))
                    .frame(width: width, height: height, alignment: .topLeading)
                    .clipShape(Circle())
                    .foregroundColor(isShowingSidebar ? .black : .white)
            } else {
                Image(uiImage: (user.avatarImage))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height, alignment: .topLeading)
                    .clipShape(Circle())
                    .foregroundColor(isShowingSidebar ? .black : .white)
            }
        }
        .sheet(isPresented: $showPhotoPickerSheet, content: {
            PhotoPicker()
        })
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
        }
    }
}

struct AvatarIcon_Previews: PreviewProvider {
    static var previews: some View {
        AvatarIcon(isShowingSidebar: .constant(true),
                   showPhotoPickerSheet: .constant(false),
                   width: 40,
                   height: 40)
    }
}
