//
//  Onboarding.swift
//  Swell
//
//  Created by Tanner Maasen on 1/18/22.
//

import SwiftUI

struct Onboarding: View {
    @State private var isNavBarHidden: Bool = false
    
    init() {
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    }
    
    var body: some View {
        TabView {
            OnboardView(image: "OnboardingDirection", title: "Food and mood. A connection?", description: "Swell seeks to promote a healthy, sustainable lifestyle, and bring a positive, mindful perspective to nutrition")
            OnboardView(image: "OnboardingPieChart", title: "Food and mood logging", description: "Swell helps you realize your eating patterns and how they correlate with your mood")
            OnboardView(image: "OnboardingDiet", title: "No diet? No problem", description: "Swell doesn't believe in temporary diets for a quick (loss or gain) result. We promote eating habits that are healthy and sustainable")
            OnboardView(image: "OnboardingDataSecurity", title: "We protect your data", description: "At Swell, security is a top priority. Swell stores your data securely and does not share it with anyone")
            OnboardView(image: "OnboardingWinners", title: "Celebrate achieving your goals!", description: "Set personalized, achievable healthy eating goals that will motivate you to Live Life Well ", buttonText: "Start")
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .onAppear {
            self.isNavBarHidden = true
        }.onDisappear {
            self.isNavBarHidden = false
        }
        .navigationBarBackButtonHidden(self.isNavBarHidden)
        .navigationBarHidden(self.isNavBarHidden)
    }
}

struct OnboardView: View {
    let image: String
    let title: String
    let description: String
    var buttonText: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Image(image)
                .resizable()
                .scaledToFit()
            
            Text(title)
                .font(.title).bold()
            
            Text(description)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("onboardingDescription"))
            
            if buttonText != nil {
                NavigationLink(buttonText!, destination: Register())
                    .font(.custom("Ubuntu-Bold", size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal, 25)
                    .background(Color.swellOrange)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 30)
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
