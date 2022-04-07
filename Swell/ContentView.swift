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
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
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
                }
                else {
                    if isFromNotification {
                        MoodLog(docRef: docRef)
                    }
                    else {
                        if hasPersistedSignedIn || authViewModel.state == .signedIn {
                            Home()
                        }
                        else {
                            Login()
                        }
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
            .environmentObject(FoodAndWaterViewModel())
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

var isFromNotification: Bool = false
var docRef: String = ""

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
    let foodViewModel = FoodAndWaterViewModel()
    let userInfo = response.notification.request.content.userInfo
    docRef = userInfo["docRef"] as? String ?? ""
    // 1
    switch response.actionIdentifier {
    case "HAPPY":
        foodViewModel.logMood(docRef: docRef, pMood: "Happy", pComments: "")
    case "NEUTRAL":
        foodViewModel.logMood(docRef: docRef, pMood: "Neutral", pComments: "")
    case "SICK":
        foodViewModel.logMood(docRef: docRef, pMood: "Sick", pComments: "")
    case "OVERATE":
        foodViewModel.logMood(docRef: docRef, pMood: "I Overate", pComments: "")
    default:
        isFromNotification = true
    }
    // 2 
    completionHandler()
  }
}
