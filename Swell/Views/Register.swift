//
//  Register.swift
//  Swell
//
//  Created by Tanner Maasen on 1/15/22.
//

import SwiftUI

struct Register: View {
    var body: some View {
        VStack {
            Image("LoginImage")
                .aspectRatio(contentMode: .fit)
            
            Text("Welcome to Swell")
                .foregroundColor(.swellOrange)
                .font(.custom("Ubuntu-Bold", size: 40))
                .multilineTextAlignment(.center)
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
