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
    @Binding var isShowingSidebar: Bool
    
    var body: some View {
        HStack {
            NetworkImage(url: googleUser?.profile?.imageURL(withDimension: 100), isShowingSidebar: $isShowingSidebar)
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .topLeading)
                .cornerRadius(25.0)
                .contentShape(Rectangle())
        }
        .padding(.top, 35)
    }
}

/// A generic view that shows images from the network.
struct NetworkImage: View {
  let url: URL?
    @Binding var isShowingSidebar: Bool

  var body: some View {
    if let url = url,
       let data = try? Data(contentsOf: url),
       let uiImage = UIImage(data: data) {
      Image(uiImage: uiImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
    } else {
      Image(systemName: "person.circle.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundColor(isShowingSidebar ? .black : .white)
    }
  }
}

struct AvatarIcon_Previews: PreviewProvider {
    static var previews: some View {
        AvatarIcon(isShowingSidebar: .constant(true))
    }
}
