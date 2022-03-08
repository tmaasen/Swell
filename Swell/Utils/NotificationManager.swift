//
//  NotificationManager.swift
//  Swell
//
//  Created by Tanner Maasen on 3/4/22.
//

import Foundation
import Firebase
import UserNotifications

// Notification Manager
class NotificationManager: ObservableObject {
    @Published var settings: UNNotificationSettings?
    private var db = Firestore.firestore()
    var docRef: String = ""
    var selectedMood: String = ""
    static let instance = NotificationManager()
    
    func logMood(pMood: String) {
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .document(docRef)
            .updateData(["mood": pMood])
            { err in
                if let err = err {
                    print("Error updating document with mood: \(err.localizedDescription)")
                } else {
                    print("Document successfully updated with mood")
                }
            }
    }
    
    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
                self.fetchNotificationSettings()
                completion(granted)
            }
    }
    
    func fetchNotificationSettings() {
        // 1
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            // 2
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
    
    func removeScheduledNotification() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func scheduleNotification(mealType: String, foodTitle: String, docRef: String) {
        // 1
        self.docRef = docRef
        // 2
        let content = UNMutableNotificationContent()
        content.title = "How was your \(foodTitle.lowercased())?"
        content.body = "Has your mood changed since you ate your \(mealType.lowercased())? Long press to log your mood."
        content.categoryIdentifier = "MOOD_ACTIONS"
        // 3
        // send after 20 minutes (60*20)
        let timer = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        // 4
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: timer)
        // 5
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
}

// For in-app notifications
class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
}
