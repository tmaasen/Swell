//
//  Learn.swift
//  Swell
//
//  Created by Tanner Maasen on 2/14/22.
//

import SwiftUI
import WebKit

struct Learn: View {
    @State private var webViewHeight: CGFloat = .zero
    @State private var navToRecipes: Bool = false
    var videos = ["gN28NzVjHXU", "xyQY8a-ng6g", "CSHO9VdVRfg"]
    
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

struct YouTubePlayer: UIViewRepresentable {
    let videoId: String
    @Binding var dynamicHeight: CGFloat
    var webview: WKWebView = WKWebView()
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: YouTubePlayer

        init(_ parent: YouTubePlayer) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                DispatchQueue.main.async {
                    self.parent.dynamicHeight = height as! CGFloat
                }
            })
        }
    }
    
//    func makeUIView(context: Context) -> WKWebView {
//        return webview
//    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView  {
        webview.scrollView.bounces = false
        webview.navigationDelegate = context.coordinator
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoId)") else {return webview}
        webview.scrollView.isScrollEnabled = false
        webview.load(URLRequest(url: youtubeURL))
        return webview
    }

//    func updateUIView(_ uiView: WKWebView, context: Context) {
//    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
//        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoId)") else {return}
//        uiView.scrollView.isScrollEnabled = false
//        uiView.load(URLRequest(url: youtubeURL))
    }
}

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
