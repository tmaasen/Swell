//
//  Onboarding.swift
//  Swell
//
//  Created by Tanner Maasen on 1/18/22.
//

import SwiftUI

struct Onboarding: View {
    
    var body: some View {
        TabView {
            OnboardView(image: "OnboardingPieChart", title: "Title", description: "Description")
            OnboardView(image: "OnboardingDataSecurity", title: "Title", description: "Description")
            OnboardView(image: "OnboardingDirection", title: "Title", description: "Description")
            OnboardView(image: "OnboardingCommunication", title: "Title", description: "Description")
            OnboardView(image: "OnboardingWinners", title: "Title", description: "Description")
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct OnboardView: View {
    let image: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(image)
                .resizable()
                .scaledToFit()
            
            Text(title)
                .font(.title).bold()
            
            Text(description)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 40)
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
