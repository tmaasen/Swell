//
//  Learn.swift
//  Swell
//
//  Created by Tanner Maasen on 2/14/22.
//

import SwiftUI
import WebKit

struct Learn: View {
    var body: some View {
        VStack(spacing: 30) {
            YouTubePlayer(videoId: "gN28NzVjHXU")
                .frame(minWidth: 0, maxHeight: UIScreen.main.bounds.height * 0.3)
                .cornerRadius(12)
                .padding(.horizontal, 24)
            YouTubePlayer(videoId: "xyQY8a-ng6g")
                .frame(minWidth: 0, maxHeight: UIScreen.main.bounds.height * 0.3)
                .cornerRadius(12)
                .padding(.horizontal, 24)
            YouTubePlayer(videoId: "CSHO9VdVRfg")
                .frame(minWidth: 0, maxHeight: UIScreen.main.bounds.height * 0.3)
                .cornerRadius(12)
                .padding(.horizontal, 24)
        }
        .padding(.vertical)
        .navigationTitle("Learn")
    }
}

struct Learn_Previews: PreviewProvider {
    static var previews: some View {
        Learn()
    }
}

struct YouTubePlayer: UIViewRepresentable {
    let videoId: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoId)") else {return}
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
}
