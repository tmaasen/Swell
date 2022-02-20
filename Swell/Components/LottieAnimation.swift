//
//  LottieAnimation.swift
//  Swell
//
//  Created by Tanner Maasen on 2/20/22.
//

import SwiftUI
import Lottie

struct LottieAnimation: View {
    var filename: String
    var loopMode: LottieLoopMode
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        VStack {
            LottieView(filename: filename, loopMode: loopMode)
                .frame(width: width, height: height)
        }
    }
}

struct LottieAnimation_Previews: PreviewProvider {
    static var previews: some View {
        LottieAnimation(filename: "checkmark", loopMode: .loop, width: 100, height: 100)
    }
}
