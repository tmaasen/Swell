//
//  LottieView.swift
//  Swell
//
//  Created by Tanner Maasen on 2/20/22.
//

import SwiftUI
import Lottie
 
/// View that sets up the lottie files for Swell's animations.
struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView
    var filename: String
    var loopMode: LottieLoopMode
    var animationSpeed: CGFloat
    var play: Bool
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = AnimationView()
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        if play {
            animationView.play()
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
}
