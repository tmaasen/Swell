//
//  PexelImage.swift
//  Swell
//
//  Created by Tanner Maasen on 1/29/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PexelImage: View {
    @StateObject var pexelsViewModel = PexelsViewModel()
    @State private var isLoading: Bool = true
    
    var body: some View {
        WebImage(url: URL(string: pexelsViewModel.pexel.src?.original ?? ""))
            .resizable()
            .cornerRadius(10)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .brightness(-0.25)
            .overlay(TextOverlay(), alignment: .bottomLeading)
            .redacted(when: isLoading, redactionType: .scaled)
            .onAppear {
                if ((pexelsViewModel.pexel.src?.original) != nil) {
                    isLoading = false
                }
            }
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


public enum RedactionType {
    case customPlaceholder
    case scaled
}

struct Redactable: ViewModifier {
    let type: RedactionType?

    @ViewBuilder
    func body(content: Content) -> some View {
        switch type {
        case .customPlaceholder:
            content
                .modifier(Placeholder())
        case .scaled:
            content
                .modifier(Scaled())
        case nil:
            content
        }
    }
}

struct Placeholder: ViewModifier {

    @State private var condition: Bool = false
    func body(content: Content) -> some View {
        content
            .accessibility(label: Text("Placeholder"))
            .redacted(reason: .placeholder)
            .opacity(condition ? 0.0 : 1.0)
            .animation(Animation
                        .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true))
            .onAppear { condition = true }
    }
}

struct Scaled: ViewModifier {

    @State private var condition: Bool = false
    func body(content: Content) -> some View {
        content
            .accessibility(label: Text("Scaled"))
            .redacted(reason: .placeholder)
            .scaleEffect(condition ? 0.9 : 1.0)
            .animation(Animation
                        .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true))
            .onAppear { condition = true }
    }
}
