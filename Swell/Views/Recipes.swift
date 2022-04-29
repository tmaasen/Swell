//
//  Recipes.swift
//  Swell
//
//  Created by Tanner Maasen on 4/28/22.
//

import SwiftUI

/// View that's a part of the Learning portion of Swell that has YouTube videos containing tutorials for making healthy foods.
struct Recipes: View {
    @State private var webViewHeight: CGFloat = .zero
    var recipes = ["lhI20U41qPs", "qMEJiiRk9mo", "dqZOPJ9isVs", "pGjF9_0BYkE", "Qy_tpqGs0b4", "jbXEE5IEIJ0", "QivZWSw33zc", "A7xeRiqhjZQ", "SZqCVpLj1bI"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(recipes, id: \.self) { recipe in
                    YouTubePlayer(videoId: recipe, dynamicHeight: $webViewHeight)
                        .frame(width: 300, height: 200)
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                }
            }
        }
        .padding(.vertical)
        .navigationTitle("Recipes")
    }
}

struct Recipes_Previews: PreviewProvider {
    static var previews: some View {
        Recipes()
    }
}
