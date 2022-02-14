//
//  SwellApp.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import Firebase

@main
struct SwellApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    @StateObject var authViewModel = AuthenticationViewModel()
    @StateObject var userViewModel = UserViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
                .environmentObject(authViewModel)
        }
    }
}
