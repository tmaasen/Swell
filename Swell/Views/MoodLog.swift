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
        MoodLog(docRef: "", showMoodLog: .constant(false))
    }
}

public enum Mood: Int, CaseIterable {
    case happy
    case neutral
    case sick
    case overate
    
    var emoji: String {
        switch self {
        case .happy: return "😀"
        case .neutral: return "😐"
        case .sick: return "🤮"
        case .overate: return "🤢"
        }
    }
    
    var text: String {
        switch self {
        case .happy: return "Happy"
        case .neutral: return "Neutral"
        case .sick: return "Sick"
        case .overate: return "Overate"
        }
    }
}
