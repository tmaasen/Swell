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
    @StateObject var viewModel = AuthenticationViewModel()

    init() {
      setupFirebase()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

extension SwellApp {
  private func setupFirebase() {
    FirebaseApp.configure()
  }
}
