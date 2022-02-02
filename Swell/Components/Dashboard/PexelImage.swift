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
    @State var isLoading: Bool = true
    
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
//            .redacted(when: isLoading, redactionType: .customPlaceholder)
            .onAppear {
                if ((pexelsViewModel.pexel.photos?[0].src?.original) != nil) {
                    isLoading = false
                }
            }
    }
}

struct ImageOverlay: View {
    var body: some View {
        ZStack {
            Text("\"Make everyday count\"")
                .font(.system(size: 33, weight: .bold))
                .italic()
//                .font(.custom("Ubuntu-BoldItalic", size: 33))
                .foregroundColor(.white)
                .lineSpacing(5.0)
                .padding(.bottom, 30.0)
                .padding(.leading, 15.0)
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
