//
//  NotificationManager.swift
//  Swell
//
//  Created by Tanner Maasen on 3/4/22.
//

import Foundation
import Firebase
import UserNotifications

class NotificationManager {
    
    private var db = Firestore.firestore()
    var docRef: String = ""
    var selectedMood: String = ""
    static let instance = NotificationManager()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: { (success, error) in
            if error != nil {
                print("Push notification access refused")
            } else {
                print("Push notification access granted")
            }
        })
    }
    
    func scheduleNotification(mealType: String, foodTitle: String, docRef: String) {
        let content = UNMutableNotificationContent()
        content.title = "How was your \(foodTitle.lowercased())?"
        content.body = "Has your mood changed since you ate \(mealType.lowercased())? Long press this notification to log your mood."
        content.sound = .default
        content.categoryIdentifier = "MOOD_ACTIONS"
        // set mood options here
        let happy = UNNotificationAction(identifier: "happy", title: "Happy 😀")
        let neutral = UNNotificationAction(identifier: "neutral", title: "Neutral 😐")
        let sick = UNNotificationAction(identifier: "sick", title: "Sick 🤮")
        let overate = UNNotificationAction(identifier: "overate", title: "I Overate 🤢")
        // Define the notification type
        let moodOptions =
              UNNotificationCategory(identifier: "MOOD_ACTIONS",
              actions: [happy, neutral, sick, overate],
              intentIdentifiers: [],
              options: [])
        UNUserNotificationCenter.current().setNotificationCategories([moodOptions])
        // send after 20 minutes
        let timer = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: timer)
        UNUserNotificationCenter.current().add(request)
        
        self.docRef = docRef
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
           didReceive response: UNNotificationResponse,
           withCompletionHandler completionHandler:
             @escaping () -> Void) {
           
       // Get the meeting ID from the original notification.
//       let userInfo = response.notification.request.content.userInfo
//       let meetingID = userInfo["MEETING_ID"] as! String
//       let userID = userInfo["USER_ID"] as! String
                    
       // Perform the task associated with the action.
       switch response.actionIdentifier {
       
       // Parameters needed: document name of food log
       case "happy":
        selectedMood = "Happy"
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .document(docRef)
            .updateData(["mood": selectedMood])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
       case "neutral":
        selectedMood = "Neutral"
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .document(docRef)
            .updateData(["mood": selectedMood])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
       case "sick":
        selectedMood = "Sick"
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .document(docRef)
            .updateData(["mood": selectedMood])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
       case "overate":
        selectedMood = "I Overate"
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .document(docRef)
            .updateData(["mood": selectedMood])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
       default:
          break
       }
        
        /// In case it works here, remove the code in the switch statement
//        db.collection("users")
//            .document(Auth.auth().currentUser?.uid ?? "test")
//            .collection("food")
//            .document(docRef)
//            .updateData(["mood": selectedMood])
//            { err in
//                if let err = err {
//                    print("Error updating document: \(err)")
//                } else {
//                    print("Document successfully updated")
//                }
//            }
        
       // Always call the completion handler when done.
       completionHandler()
    }
}

// For in-app notifications
class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
}
