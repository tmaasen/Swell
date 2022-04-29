//
//  YouTubePlayer.swift
//  Swell
//
//  Created by Tanner Maasen on 4/28/22.
//

import WebKit
import SwiftUI

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
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
