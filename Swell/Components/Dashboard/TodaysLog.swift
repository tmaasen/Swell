//
//  TodaysLog.swift
//  Swell
//
//  Created by Tanner Maasen on 3/27/22.
//

import SwiftUI

struct TodaysLog: View {
    @StateObject var historyLogViewModel = HistoryLogViewModel()
    @State private var isLoading = true
    @State private var tempTodaysLog = [TodaysLogItem]()
    @State private var todaysLog = [TodaysLogItem]()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's Log")
                .font(.custom("Ubuntu-Bold", size: 30))
                .foregroundColor(.white)
            if isLoading {
                HStack(spacing: 20) {
                    LoadingShimmer(width: 200, height: 150)
                    LoadingShimmer(width: 200, height: 150)
                    LoadingShimmer(width: 200, height: 150)
                }
            }
            if !isLoading {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(MealTypes.allCases, id: \.self) { meal in
                            if todaysLog.first(where: {$0.mealType == meal.text}) != nil {
                                ForEach(todaysLog, id: \.self.id) { food in
                                    if food.mealType == meal.text {
                                        TodaysLogCard(food: food)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
//            if !todaysLog.containsSameElements(as: tempTodaysLog) {
            isLoading = true
            todaysLog.removeAll()
            historyLogViewModel.getAllHistoryByDate(date: Date(), completion: { foodArray, myCustomMeals in
                for i in 0...foodArray.count-1 {
                    var todaysLogItem = TodaysLogItem()
                    todaysLogItem.foodName = foodArray[i].foodDescription
                    todaysLogItem.mealType = foodArray[i].mealType
                    todaysLogItem.mood = foodArray[i].mood
                    todaysLogItem.docId = foodArray[i].docId
                    todaysLog.append(todaysLogItem)
                }
                for i in 0...myCustomMeals.count-1 {
                    var todaysLogItem = TodaysLogItem()
                    todaysLogItem.foodName = myCustomMeals[i].name
                    todaysLogItem.mealType = myCustomMeals[i].mealType
                    todaysLogItem.mood = myCustomMeals[i].mood
                    todaysLogItem.docId = myCustomMeals[i].docId
                    todaysLog.append(todaysLogItem)
                }
                print(todaysLog.count)
                isLoading = false
                })
//            }
        }
    }
}

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

struct TodaysLog_Previews: PreviewProvider {
    static var previews: some View {
        TodaysLog()
    }
}
