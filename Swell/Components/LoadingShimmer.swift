//
//  LoadingShimmer.swift
//  Swell
//
//  Created by Tanner Maasen on 3/27/22.
//

import SwiftUI

struct LoadingShimmer: View {
    var width: Int
    var height: Int
    var center = (UIScreen.main.bounds.width / 2) + 100
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.09)
                .frame(height: 125)
                .cornerRadius(10)
            
            Color.white
                .frame(height: 125)
                .cornerRadius(10)
                .mask(
                    Rectangle()
                        .fill(
                            LinearGradient(gradient: .init(colors: [.clear, Color.white.opacity(0.48), .clear]), startPoint: .top, endPoint: .bottom)
                        )
                        .rotationEffect(.init(degrees: 70))
                        .offset(x: isLoading ? center : -center)
                )
        }
        .padding(.horizontal)
        .padding(.top)
        .onAppear() {
            withAnimation(Animation.default.speed(0.15).delay(0).repeatForever(autoreverses: false)) {
                isLoading.toggle()
            }
        }
    }
}

struct LoadingShimmer_Previews: PreviewProvider {
    static var previews: some View {
        LoadingShimmer(width: 150, height: 100)
    }
}
