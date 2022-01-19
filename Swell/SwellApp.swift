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
    @StateObject var authModel = AuthenticationViewModel()
    @ObservedObject var api = API()

    init() {
      setupFirebase()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authModel)
                .environmentObject(api)
        }
    }
}

extension SwellApp {
  private func setupFirebase() {
    FirebaseApp.configure()
  }
}
