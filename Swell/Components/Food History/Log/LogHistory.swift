//
//  LogHistory.swift
//  Swell
//
//  Created by Tanner Maasen on 3/14/22.
//

import SwiftUI

struct LogHistory: View {
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
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
                        if foodViewModel.foodHistory.isEmpty && foodViewModel.waters.waterOuncesToday == 0 {
                            Image("NoData")
                                .resizable()
                                .scaledToFit()
                            Text("No food history on this day!")
                                .foregroundColor(.gray)
                                .font(.system(size: 20))
                        }
                    }
                    // DATA
                    if !foodViewModel.foodHistory.isEmpty {
                        ForEach(MealTypes.allCases, id: \.self) { meal in
                            if foodViewModel.foodHistory.first(where: {$0.mealType == meal.text}) != nil {
                                Text(meal.text)
                                    .font(.custom("Ubuntu-BoldItalic", size: 20))
                                    .padding()
                            }
                            ForEach(foodViewModel.foodHistory, id: \.self.id) { item in
                                if item.mealType == meal.text && item.mealType != "Water" {
                                    FoodItem(item: item)
                                }
                            }
                        }
                    }
                    if foodViewModel.waters.waterOuncesToday ?? 0 > 0 {
                        Text("Water")
                            .font(.custom("Ubuntu-BoldItalic", size: 20))
                            .padding(.horizontal)
                        WaterItem()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    DatePicker("📅", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                        .onChange(of: selectedDate, perform: { _ in
                            isLoading = true
                            foodViewModel.getAllHistoryByDate(date: selectedDate, completion: {
                                isLoading = false
                            })
                        })
                }
            }
        }
    }
}

struct LogHistory_Previews: PreviewProvider {
    static var previews: some View {
        LogHistory()
    }
}
