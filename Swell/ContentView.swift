//
//  ContentView.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import GoogleSignIn
import JGProgressHUD_SwiftUI

struct ContentView: View {
    
    @State private var isNavBarHidden: Bool = false
    @State private var blockTouches = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    var hasPersistedSignedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    var hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    
    init() {
        if hasLaunchedBefore == false {
            NotificationManager.instance.requestAuthorization()
        }
    }

    var body: some View {
        JGProgressHUDPresenter(userInteractionOnHUD: blockTouches) {
            NavigationView {
                if hasLaunchedBefore == false {
                    Onboarding()
                } else {
                    if hasPersistedSignedIn || authViewModel.state == .signedIn {
                        Home()
                    } else {
                        Login()
                    }
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel())
            .environmentObject(UserViewModel())
            .environmentObject(FoodDataCentralViewModel())
    }
}
