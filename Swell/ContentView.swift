//
//  ContentView.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authModel: AuthenticationViewModel

    var body: some View {
        switch authModel.state {
          case .signedIn: Home()
          case .signedOut: Login()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
