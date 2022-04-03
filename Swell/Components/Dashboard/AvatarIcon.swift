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
    @State var avatarImage: UIImage = UIImage(systemName: "person.circle.fill")!
    @Binding var isShowingSidebar: Bool
    @Binding var showPhotoPickerSheet: Bool
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        HStack {
            Image(uiImage: (getAvatarImage()))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height, alignment: .topLeading)
                .clipShape(Circle())
//                .cornerRadius(25.0)
//                .contentShape(Rectangle())
        }
        .sheet(isPresented: $showPhotoPickerSheet, content: {
            PhotoPicker(avatarImage: $avatarImage)
        })
        .padding(.top, 60)
    }
    
    func getAvatarImage() -> UIImage {
        if user.user.avatarImage != "" {
            avatarImage = UIImage(named: user.user.avatarImage)!
        } else if GIDSignIn.sharedInstance.currentUser != nil {
            avatarImage = UIImage(data: try! Data(contentsOf: (googleUser?.profile?.imageURL(withDimension: 100))!))!
        }
        return avatarImage
    }
    
    func setAvatarImage(pImage: UIImage) {
        avatarImage = pImage
    }
}

/// A generic view that shows images from the network.
//struct NetworkImage: View {
//    let url: URL?
//    @Binding var isShowingSidebar: Bool
//    @Environment(\.colorScheme) var colorScheme
//
//    var body: some View {
//        if let url = url,
//           let data = try? Data(contentsOf: url),
//           let uiImage = UIImage(data: data) {
//            Image(uiImage: uiImage)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//        } else {
//            Image(systemName: "person.circle.fill")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .foregroundColor(isShowingSidebar ? .black : .white)
//        }
//    }
//}

struct AvatarIcon_Previews: PreviewProvider {
    static var previews: some View {
        AvatarIcon(isShowingSidebar: .constant(true),
                   showPhotoPickerSheet: .constant(false),
                   width: 40,
                   height: 40)
    }
}
