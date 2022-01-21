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
    
    var body: some View {
        HStack {
            NetworkImage(url: googleUser?.profile?.imageURL(withDimension: 100))
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .topLeading)
                .cornerRadius(25.0)
        }
        .padding(.top, 50)
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
    } else {
      Image(systemName: "person.circle.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundColor(.white)
    }
  }
}

struct AvatarIcon_Previews: PreviewProvider {
    static var previews: some View {
        AvatarIcon()
    }
}