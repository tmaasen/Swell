//
//  MoodLog.swift
//  Swell
//
//  Created by Tanner Maasen on 3/6/22.
//
//  MoodLog is an in-app view for users who don't choose to log their mood from a notification. This view offers the ability to provide comments on his/her mood as well.

import SwiftUI
import Firebase

struct MoodLog: View {
    @State private var selectedMood: String = ""
    @State private var comments: String = ""
    @State private var logCompleted: Bool = false
    var docRef: String
    @Binding var showMoodLog: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("How are you feeling?")
                .font(.system(size: 40))
                .bold()
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            Spacer()
            HStack {
                ForEach(Mood.allCases, id: \.self) {moodOption in
                    MoodLogItem(selectedMood: moodOption)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(selectedMood==moodOption.text ? Color.blue : Color.clear, lineWidth: 3)
                        )
                        .onTapGesture {
                            selectedMood = moodOption.text
                        }
                    Spacer()
                }
            }
            .padding(.horizontal)
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Comments")
                    .italic()
                TextEditor(text: $comments)
                    .foregroundColor(.secondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 3)
                    )
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: 260)
            
            Button(action: {
                hideKeyboard()
                MoodLog.logMood(docRef: docRef, pMood: selectedMood, pComments: comments)
                logCompleted = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    presentationMode.wrappedValue.dismiss()
                })
            }, label: {
                Text("Submit")
                    .withButtonStyles()
                    .opacity(selectedMood.isEmpty ? 0.5 : 1.0)
                    .padding()
            })
            .disabled(selectedMood.isEmpty)
            
            if logCompleted {
                LottieAnimation(filename: "checkmark", loopMode: .playOnce, width: 400, height: 400)
            }
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
                "mood": pMood ?? "",
                "comments": pComments ?? "No comments",
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                }
            }
    }
}

struct MoodLog_Previews: PreviewProvider {
    static var previews: some View {
        MoodLog(docRef: "", showMoodLog: .constant(false))
    }
}
