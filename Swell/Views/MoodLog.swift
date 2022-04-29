//
//  MoodLog.swift
//  Swell
//
//  Created by Tanner Maasen on 3/6/22.
//

import SwiftUI
import Firebase
import JGProgressHUD_SwiftUI

///  MoodLog is an in-app view for users who don't choose to log their mood from a notification. This view offers the ability to provide comments on his/her mood as well.
struct MoodLog: View {
    var docRef: String
    @State private var selectedMood: String = ""
    @State private var comments: String = ""
    @State private var logCompleted: Bool = false
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @EnvironmentObject var moodViewModel: FoodAndMoodViewModel
    
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
            
            NavigationLink(destination: Home(), isActive: $logCompleted) {}
            Button(action: {
                hideKeyboard()
                toggleLoadingIndicator()
                moodViewModel.logMood(docRef: docRef, pMood: selectedMood, pComments: comments, completion: {
                    logCompleted = true
                })
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
    func toggleLoadingIndicator() {
        hudCoordinator.showHUD {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor(white: 0, alpha: 0.4)
            hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 4, opacity: 0.9)
            hud.vibrancyEnabled = true
            hud.textLabel.text = "Loading"
            hud.dismiss(afterDelay: 2.0)
            return hud
        }
    }
}

struct MoodLog_Previews: PreviewProvider {
    static var previews: some View {
        MoodLog(docRef: "")
    }
}
