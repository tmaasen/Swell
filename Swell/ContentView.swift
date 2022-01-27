//
//  ContentView.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import JGProgressHUD_SwiftUI


struct ContentView: View {
    @State private var blockTouches = false
    @EnvironmentObject var authModel: AuthenticationViewModel

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
            .environmentObject(AuthenticationViewModel())
    }
}
