//
//  LogHistory.swift
//  Swell
//
//  Created by Tanner Maasen on 3/14/22.
//

import SwiftUI

struct LogHistory: View {
    @StateObject var historyLogViewModel = HistoryLogViewModel()
    @State private var selectedDate = Date()
    @State private var isLoading: Bool = false
    @State private var fdcFoodHistory = [FoodRetriever]()
    @State private var customFoodHistory = [MyMeal]()
    
    var body: some View {
        ScrollView {
            // Food and Water Data
            VStack(alignment: .leading) {
                if isLoading {
                    LottieAnimation(filename: "loading", loopMode: .loop, width: 50, height: 50)
                } else {
                    // NO DATA
                    VStack(alignment: .center) {
                        if fdcFoodHistory.isEmpty && customFoodHistory.isEmpty && historyLogViewModel.waters.waterOuncesToday == 0 {
                            Image("NoData")
                                .resizable()
                                .scaledToFit()
                            Text("No food history on this day!")
                                .foregroundColor(.gray)
                                .font(.system(size: 20))
                        }
                    }
                    // DATA
                    if !fdcFoodHistory.isEmpty || !customFoodHistory.isEmpty {
                        ForEach(MealTypes.allCases, id: \.self) { meal in
                            if fdcFoodHistory.first(where: {$0.mealType == meal.text}) != nil && customFoodHistory.first(where: {$0.mealType == meal.text}) != nil {
                                Text(meal.text)
                                    .font(.custom("Ubuntu-BoldItalic", size: 20))
                                    .padding()
                            }
                            // for FDC items and myMeals that are from FDC
                            ForEach(fdcFoodHistory, id: \.self.id) { item in
                                if item.mealType == meal.text && item.mealType != "Water" {
                                    FoodItem(fdcFoodHistory: item, customFoodHistory: MyMeal())
                                }
                            }
                            // for custom meals
                            ForEach(customFoodHistory, id: \.self) { item in
                                if item.mealType == meal.text {
                                    FoodItem(fdcFoodHistory: FoodRetriever(), customFoodHistory: item)
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
                            fdcFoodHistory.removeAll()
                            customFoodHistory.removeAll()
                            historyLogViewModel.waters.waterOuncesToday = 0
                            historyLogViewModel.waters.waterLoggedToday = 0
                            historyLogViewModel.getAllHistoryByDate(date: selectedDate, completion: { foodArray, myCustomMeals in
                                fdcFoodHistory = foodArray
                                customFoodHistory = myCustomMeals
                                print("Food: \(foodArray.count)")
                                print("Custom Food: \(myCustomMeals.count)")
                                isLoading = false
                            })
                        })
                }
            }
        }
        .onAppear() {
            historyLogViewModel.getAllHistoryByDate(date: Date(), completion: { foodArray, myCustomMeals in
                fdcFoodHistory = foodArray
                customFoodHistory = myCustomMeals
            })
        }
    }
}

struct LogHistory_Previews: PreviewProvider {
    static var previews: some View {
        LogHistory()
    }
}
