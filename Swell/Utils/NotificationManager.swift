//
//  NotificationManager.swift
//  Swell
//
//  Created by Tanner Maasen on 3/4/22.
//

import Foundation
import FirebaseFirestore
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
        content.title = "How was your \(foodTitle)?"
        content.body = "Has your mood changed since you ate \(mealType)?"
        content.sound = .default
        // set mood options here
        let happy = UNNotificationAction(identifier: "happy",
              title: "😀",
              options: [])
        let neutral = UNNotificationAction(identifier: "neutral",
              title: "😐",
              options: [])
        let sick = UNNotificationAction(identifier: "sick",
              title: "🤮",
              options: [])
        let overate = UNNotificationAction(identifier: "overate",
              title: "🤢",
              options: [])
        // Define the notification type
        let moodOptions =
              UNNotificationCategory(identifier: "mood_options",
              actions: [happy, neutral, sick, overate],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([moodOptions])
        // send after 20 minutes
        let timer = UNTimeIntervalNotificationTrigger(timeInterval: (60*1), repeats: false)
        
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
       case "neutral":
        selectedMood = "Neutral"
       case "sick":
        selectedMood = "Sick"
       case "overate":
        selectedMood = "I Overate"
          break
                 
       default:
          break
       }
        
        db.document(docRef).updateData([
            "mood": selectedMood
        ]) { err in
            if let err = err {
                print("Error adding mood: \(err.localizedDescription)")
            } else {
                print("Document successfully updated")
            }
        }
        
       // Always call the completion handler when done.
       completionHandler()
    }
}
