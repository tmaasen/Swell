//
//  Onboarding.swift
//  Swell
//
//  Created by Tanner Maasen on 1/18/22.
//

import SwiftUI

struct Onboarding: View {
    
    let pages: [OnboardingInfo]
    @State private var currentPage = 0
    
    var body: some View {
        TabView {
            ForEach (0 ..< self.pages.count) { index in
                OnboardingPage(page: self.pages[index])
                    .tag(index)
                    .padding()
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

//struct Onboarding_Previews: PreviewProvider {
//    static var previews: some View {
//        Onboarding()
//    }
//}
