//
//  SwellApp.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import Firebase
import JGProgressHUD_SwiftUI

@main
struct SwellApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    @State private var isNavBarHidden: Bool = false
    @State private var blockTouches = false
    @StateObject var authViewModel = AuthenticationViewModel()
    @StateObject var userViewModel = UserViewModel()
    
    var body: some Scene {
        WindowGroup {
            JGProgressHUDPresenter(userInteractionOnHUD: blockTouches) {
                NavigationView {
                    ContentView()
                        .onAppear {
                            self.isNavBarHidden = true
                        }.onDisappear {
                            self.isNavBarHidden = false
                        }
                        .navigationBarBackButtonHidden(self.isNavBarHidden)
                        .navigationBarHidden(self.isNavBarHidden)
                }
                .environmentObject(userViewModel)
                .environmentObject(authViewModel)
            }
        }
    }
}
