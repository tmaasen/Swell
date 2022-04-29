//
//  Learn.swift
//  Swell
//
//  Created by Tanner Maasen on 2/14/22.
//

import SwiftUI

/// Learning resources such as infographics and YouTube videos (reference YouTubePlayer.swift) to see the player I made using WebKit.
struct Learn: View {
    var videos = ["gN28NzVjHXU", "xyQY8a-ng6g", "CSHO9VdVRfg"]
    @State private var webViewHeight: CGFloat = .zero
    @State private var navToRecipes: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                NavigationLink(destination: Recipes(), isActive: $navToRecipes) {}
                Image("Food-and-Mood-Infographic")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                ForEach(videos, id: \.self) { video in
                    YouTubePlayer(videoId: video, dynamicHeight: $webViewHeight)
                        .frame(width: 300, height: 200)
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                }
            }
        }
        .padding(.vertical)
        .navigationTitle("Learn")
        .navigationBarItems(trailing:
                                Button(action: {
                                    navToRecipes = true
                                }, label: {
                                    Text("Recipes")
                                })
        )
    }
}

struct Learn_Previews: PreviewProvider {
    static var previews: some View {
        Learn()
    }
}
