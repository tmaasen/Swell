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
    @StateObject var foodAndMoodViewModel = FoodAndMoodViewModel()
    @StateObject var myMealsViewModel = MyMealsViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(foodAndMoodViewModel)
                .environmentObject(myMealsViewModel)
        }
    }
}
