//
//  TodaysLogCard.swift
//  Swell
//
//  Created by Tanner Maasen on 4/28/22.
//

import SwiftUI

struct TodaysLogCard: View {
    var food: TodaysLogItem
    @State private var showMoodLog: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(
                destination: MoodLog(docRef: food.docId ?? ""),
                isActive: self.$showMoodLog) {}
            VStack(alignment: .leading) {
                Text("\(food.foodName?.capitalizingFirstLetter() ?? "")")
                    .font(.custom("Ubuntu-Bold", size: 16))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                Spacer()
                    .frame(height: 20)
                Text("\(food.mealType ?? "")")
                    .font(.custom("Ubuntu-BoldItalic", size: 16))
                    .foregroundColor(.black)
                Spacer()
                    .frame(height: 20)
                HStack {
                    Capsule()
                        .fill(food.mood == "" ? Color.gray : getMoodColor())
                        .frame(width: 65, height: 25)
                        .overlay(
                            Text(food.mood == "" ? "Log Mood" : food.mood!)
                                .foregroundColor(.black)
                                .font(.custom("Ubuntu", size: 10))
                                .disabled(food.mood != "")
                        )
                }
            }
            .padding()
        }
        .onTapGesture {
            if food.mood == "" {
                showMoodLog = true
            }
        }
        .padding()
        .frame(maxWidth: 250)
        .background(Color("FoodListItem_LightGray"))
        .cornerRadius(10)
    }
    func getMoodColor() -> Color {
        if food.mood == "Happy" {
            return Color.green
        } else if food.mood == "Neutral" {
            return Color.yellow
        } else if food.mood == "Sick" {
            return Color.red
        } else {
            return Color.purple
        }
    }
}
