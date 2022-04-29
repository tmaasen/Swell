//
//  TodaysLog.swift
//  Swell
//
//  Created by Tanner Maasen on 3/27/22.
//

import SwiftUI

struct TodaysLog: View {
    @State private var isLoading = true
//    @State private var tempTodaysLog = [TodaysLogItem]()
    @State private var todaysLog = [TodaysLogItem]()
    @StateObject var historyLogViewModel = HistoryLogViewModel()
    
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
                if !foodArray.isEmpty {
                    for i in 0...foodArray.count-1 {
                        var todaysLogItem = TodaysLogItem()
                        todaysLogItem.foodName = foodArray[i].foodDescription
                        todaysLogItem.mealType = foodArray[i].mealType
                        todaysLogItem.mood = foodArray[i].mood
                        todaysLogItem.docId = foodArray[i].docId
                        todaysLog.append(todaysLogItem)
                    }
                }
                if !myCustomMeals.isEmpty {
                    for i in 0...myCustomMeals.count-1 {
                        var todaysLogItem = TodaysLogItem()
                        todaysLogItem.foodName = myCustomMeals[i].name
                        todaysLogItem.mealType = myCustomMeals[i].mealType
                        todaysLogItem.mood = myCustomMeals[i].mood
                        todaysLogItem.docId = myCustomMeals[i].docId
                        todaysLog.append(todaysLogItem)
                    }
                }
                isLoading = false
                })
//            }
        }
    }
}

struct TodaysLog_Previews: PreviewProvider {
    static var previews: some View {
        TodaysLog()
    }
}
