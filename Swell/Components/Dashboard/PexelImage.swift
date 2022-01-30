//
//  PexelImage.swift
//  Swell
//
//  Created by Tanner Maasen on 1/29/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PexelImage: View {
    @ObservedObject var pexelsViewModel = PexelsViewModel()
    
    init() {
        pexelsViewModel.getPexel()
    }
    
    var body: some View {
        WebImage(url: URL(string: pexelsViewModel.pexel.photos?[0].src?.original ?? ""))
            .resizable()
            .cornerRadius(10)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
            .frame(width: 350, height: 250, alignment: .center)
            .brightness(-0.25)
            .overlay(ImageOverlay(), alignment: .bottomLeading)
    }
}

struct ImageOverlay: View {
    var body: some View {
        ZStack {
            Text("\"Make everyday count\"")
                .font(.custom("Ubuntu-BoldItalic", size: 35))
                .foregroundColor(.white)
                .lineSpacing(5.0)
                .padding(.bottom, 5.0)
        }
    }
}

struct PexelImage_Previews: PreviewProvider {
    static var previews: some View {
        PexelImage()
    }
}
