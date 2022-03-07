//
//  MoodLog.swift
//  Swell
//
//  Created by Tanner Maasen on 3/6/22.
//

import SwiftUI
import Firebase

struct MoodLog: View {
    
    var body: some View {
        HStack {
            VStack {
                Button(action: {
                    
                }, label: {
                    VStack {
                        Text("😀")
                        Text("Happy")
                    }
                })
            }
            VStack {
                Text("😐")
                Text("Neutral")
            }
            VStack {
                Text("🤮")
                Text("Sick")
            }
            VStack {
                Text("🤢")
                Text("I Overate")
            }
        }
    }
    static func logMood(docRef: String, pMood: String?, pComments: String?) {
        
        // call this when user logs mood on MoodLog screen after tapping on notification
//        MoodLog.logMood(docRef: docRef.documentID, pMood: nil, pComments: nil)
        
        let db = Firestore.firestore()

        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .document(docRef)
            .updateData([
                "mood": pMood ?? "Happy",
                "comments": pComments ?? "No comments",
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
    }
}

struct MoodLog_Previews: PreviewProvider {
    static var previews: some View {
        MoodLog()
    }
}
