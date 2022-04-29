//
//  PexelImage.swift
//  Swell
//
//  Created by Tanner Maasen on 1/29/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PexelImage: View {
    @State private var isLoading: Bool = false
    @StateObject var pexelsViewModel = PexelsViewModel()
    
    var body: some View {
        VStack {
            if isLoading {
                LoadingShimmer(width: 250, height: 300)
            } else {
                WebImage(url: URL(string: pexelsViewModel.pexel.src?.original ?? ""))
                    .resizable()
                    .cornerRadius(10)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .brightness(-0.25)
                    .overlay(TextOverlay(), alignment: .bottomLeading)
            }
        }
        .onChange(of: pexelsViewModel.isLoadingPexel, perform: { newValue in
            isLoading = pexelsViewModel.isLoadingPexel
        })
    }
}

struct TextOverlay: View {
    let quotes: Array = ["Make everyday count", "You are enough", "You are beautiful", "Perfect practice makes perfect", "I am at peace with myself", "You're a valuable human being", "Appreciate who you are", "Bet on yourself", "Your future is bright", "You deserve to relax", "You deserve to be happy", "Enjoy the present moment", "Your future is positive", "Be yourself", "Have a purpose", "Confidence, self-acceptance, and openness", "Surround yourself with positivity"]
    
    var body: some View {
        ZStack {
            Text(quotes.randomElement()!)
                .font(.system(size: 30, weight: .bold))
                .italic()
                .foregroundColor(.white)
                .lineSpacing(5.0)
                .padding(.bottom, 30.0)
                .padding(.leading, 25.0)
        }
    }
}

struct PexelImage_Previews: PreviewProvider {
    static var previews: some View {
        PexelImage()
    }
}
