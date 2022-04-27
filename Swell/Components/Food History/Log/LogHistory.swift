//
//  LogHistory.swift
//  Swell
//
//  Created by Tanner Maasen on 3/14/22.
//

import SwiftUI

struct LogHistory: View {
    @EnvironmentObject var myMealsViewModel: MyMealsViewModel
    @StateObject var historyLogViewModel = HistoryLogViewModel()
    @State private var selectedDate = Date()
    @State private var isLoading: Bool = false
    
    var body: some View {
        ScrollView {
            // Food and Water Data
            VStack(alignment: .leading) {
                if isLoading {
                    LottieAnimation(filename: "loading", loopMode: .loop, width: 50, height: 50)
                } else {
                    // NO DATA
                    VStack(alignment: .center) {
                        if historyLogViewModel.foodHistory.isEmpty && historyLogViewModel.waters.waterOuncesToday == 0 {
                            Image("NoData")
                                .resizable()
                                .scaledToFit()
                            Text("No food history on this day!")
                                .foregroundColor(.gray)
                                .font(.system(size: 20))
                        }
                    }
                    // DATA
                    if !historyLogViewModel.foodHistory.isEmpty {
                        ForEach(MealTypes.allCases, id: \.self) { meal in
                            if historyLogViewModel.foodHistory.first(where: {$0.mealType == meal.text}) != nil {
                                Text(meal.text)
                                    .font(.custom("Ubuntu-BoldItalic", size: 20))
                                    .padding()
                            }
                            ForEach(historyLogViewModel.foodHistory, id: \.self.id) { item in
                                if item.mealType == meal.text && item.mealType != "Water" {
                                    FoodItem(item: item)
                                }
                            }
                            ForEach(myMealsViewModel.myMeals, id: \.self) { item in
                                if item.mealType == meal.text {
                                    FoodItem(item: item.foodInfo ?? FoodRetriever())
                                }
                            }
                        }
                    }
                    if historyLogViewModel.waters.waterOuncesToday ?? 0 > 0 {
                        Text("Water")
                            .font(.custom("Ubuntu-BoldItalic", size: 20))
                            .padding(.horizontal)
                        WaterItem(waterOunces: historyLogViewModel.waters.waterOuncesToday ?? 0)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    DatePicker("📅", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                        .onChange(of: selectedDate, perform: { _ in
                            isLoading = true
                            historyLogViewModel.foodHistory.removeAll()
                            historyLogViewModel.waters.waterOuncesToday = 0
                            historyLogViewModel.waters.waterLoggedToday = 0
                            historyLogViewModel.getAllHistoryByDate(date: selectedDate, completion: {
                                isLoading = false
                            })
                        })
                }
            }
        }
        .onAppear() {
            historyLogViewModel.getAllHistoryByDate(date: Date(), completion: {
                print("items: \(historyLogViewModel.foodHistory.count)")
            })
            myMealsViewModel.getMyMeals(completion: {
                print("myMeals: \(myMealsViewModel.myMeals.count)")
            })
        }
    }
}

struct LogHistory_Previews: PreviewProvider {
    static var previews: some View {
        LogHistory()
    }
}
