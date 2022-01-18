//
//  ContentView.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import JGProgressHUD_SwiftUI


struct ContentView: View {
    @EnvironmentObject var authModel: AuthenticationViewModel
    @State private var blockTouches = false

    var body: some View {
        JGProgressHUDPresenter(userInteractionOnHUD: blockTouches) {
            switch authModel.state {
              case .signedIn: Home()
              case .signedOut: Login()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
