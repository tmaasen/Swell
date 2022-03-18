//
//  ContentView.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import UIKit
import JGProgressHUD_SwiftUI

struct ContentView: View {
    
    @State private var blockTouches: Bool = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    var hasPersistedSignedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    var hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    
    init() {
        if hasLaunchedBefore == false {
            NotificationManager.instance.requestAuthorization { granted in
              if granted {
                print("Notification access granted")
              }
            }
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
            .environmentObject(AppDelegate())
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        configureNotification()
        return true
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler(.banner)
  }

  private func configureNotification() {
    UNUserNotificationCenter.current().delegate = self
    // 1
    let happy = UNNotificationAction(identifier: "HAPPY", title: "Happy 😀", options: [])
    let neutral = UNNotificationAction(identifier: "NEUTRAL", title: "Neutral 😐", options: [])
    let sick = UNNotificationAction(identifier: "SICK", title: "Sick 🤮", options: [])
    let overate = UNNotificationAction(identifier: "OVERATE", title: "I Overate 🤢", options: [])
    // 2
    let moodOptions =
        UNNotificationCategory(identifier: "MOOD_ACTIONS",
                               actions: [happy, neutral, sick, overate],
                               intentIdentifiers: [],
                               options: [])
    // 3
    UNUserNotificationCenter.current().setNotificationCategories([moodOptions])
  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    // 1
    switch response.actionIdentifier {
    case "HAPPY":
        NotificationManager.instance.logMood(pMood: "Happy")
    case "NEUTRAL":
        NotificationManager.instance.logMood(pMood: "Neutral")
    case "SICK":
        NotificationManager.instance.logMood(pMood: "Sick")
    case "OVERATE":
        NotificationManager.instance.logMood(pMood: "I Overate")
    default:
        NotificationCenter.default.post(name: NSNotification.Name("MoodLog"), object: nil)
    }
    // 2
    completionHandler()
  }
}
