//
//  OnboardingPage.swift
//  Swell
//
//  Created by Tanner Maasen on 1/18/22.
//

import SwiftUI

struct OnboardingInfo {
    let imageName: String
    let title: String
    let description: String
}

struct OnboardingPage: View {
    let page: OnboardingInfo
    var body: some View {
        VStack {
            Spacer()
            Image(self.page.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Group {
                HStack {
                    Text(self.page.title)
                        .font(.title)
                        .foregroundColor(.purple)
                    Spacer()
                }
                HStack {
                    Text(self.page.description)
                    Spacer()
                }
            }
            .padding()
        }
    }
}

//struct OnboardingPage_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingPage(page: self.page[index])
//    }
//}
