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
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var utils: UtilFunctions
    var isSignedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")

    var body: some View {
        JGProgressHUDPresenter(userInteractionOnHUD: blockTouches) {
            NavigationView {
                if isSignedIn {
                    Home()
                } else {
                    Login()
                }
//                switch authViewModel.state {
//                case .signedIn: Home()
//                case .signedOut: Login()
//                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel())
            .environmentObject(UserViewModel())
            .environmentObject(UtilFunctions())
    }
}
