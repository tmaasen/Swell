//
//  MoodLog.swift
//  Swell
//
//  Created by Tanner Maasen on 3/6/22.
//

import SwiftUI
import Firebase

struct MoodLog: View {
    @State private var selectedMood: String = ""
    @State private var comments: String = "Comments..."
    var docRef: String
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack {
                    Text("😀")
                        .font(.system(size: 30))
                    Text("Happy")
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedMood=="Happy" ? Color.blue : Color.clear, lineWidth: 5)
                )
                .onTapGesture {
                    selectedMood = "Happy"
                }
                Spacer()
                VStack {
                    Text("😐")
                        .font(.system(size: 30))
                    Text("Neutral")
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedMood=="Neutral" ? Color.blue : Color.clear, lineWidth: 5)
                )
                .onTapGesture {
                    selectedMood = "Neutral"
                }
                Spacer()
                VStack {
                    Text("🤮")
                        .font(.system(size: 30))
                    Text("Sick")
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedMood=="Sick" ? Color.blue : Color.clear, lineWidth: 5)
                )
                .onTapGesture {
                    selectedMood = "Sick"
                }
                Spacer()
                VStack {
                    Text("🤢")
                        .font(.system(size: 30))
                    Text("Overate")
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedMood=="Overate" ? Color.blue : Color.clear, lineWidth: 5)
                )
                .onTapGesture {
                    selectedMood = "Overate"
                }
            }
            .padding(.horizontal)
            Spacer()
            
            TextEditor(text: $comments)
                .foregroundColor(.secondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: 250)
            
            Button(action: {
                MoodLog.logMood(docRef: docRef, pMood: selectedMood, pComments: comments)
            }, label: {
                Text("Submit")
                    .withButtonStyles()
                    .opacity(selectedMood.isEmpty ? 0.5 : 1.0)
                    .padding()
            })
            .disabled(selectedMood.isEmpty)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    static func logMood(docRef: String, pMood: String?, pComments: String?) {
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
        MoodLog(docRef: "")
    }
}
