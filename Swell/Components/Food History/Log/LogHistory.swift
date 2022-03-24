//
//  LogHistory.swift
//  Swell
//
//  Created by Tanner Maasen on 3/14/22.
//

import SwiftUI

struct LogHistory: View {
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
    // this will reset every time it goes here...need to fix
    @State private var selectedDate = Date()
    @State private var isLoading: Bool = false
    
    var body: some View {
        ScrollView {
            // Food and Water Data
            VStack(alignment: .leading) {
                if !foodViewModel.foodHistory.isEmpty {
                    ForEach(MealTypes.allCases, id: \.self) { meal in
                        Text(foodViewModel.foodHistory.first(where: {$0.mealType == meal.text}) != nil ? meal.text : "")
                            .font(.custom("Ubuntu-BoldItalic", size: 20))
                            .padding(.horizontal)
                        ForEach(foodViewModel.foodHistory, id: \.self.id) { item in
                            if item.mealType == meal.text && item.mealType != "Water" {
                                    FoodItem(item: item)
                            }
                        }
                    }
                }
                if foodViewModel.waters.waterLoggedToday != nil {
                    Text("Water")
                        .font(.custom("Ubuntu-BoldItalic", size: 20))
                        .padding(.horizontal)
                    WaterItem()
                }
            }
            // Loading indicator and no data image
            Spacer()
            if isLoading {
                LottieAnimation(filename: "loading", loopMode: .loop, width: 50, height: 50)
            }
            if !isLoading && foodViewModel.foodHistory.isEmpty && foodViewModel.waters.waterLoggedToday == nil {
                Image("NoData")
                    .resizable()
                    .scaledToFit()
                Text("No logging history on this day!")
                    .foregroundColor(.gray)
                    .font(.system(size: 20))
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                DatePicker("📅", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                    .onChange(of: selectedDate, perform: { _ in
                        isLoading = true
                        foodViewModel.foodHistory.removeAll()
                        foodViewModel.waters.waterLoggedToday = nil
                        foodViewModel.getAllHistoryByDate(date: selectedDate, completion: {
                            isLoading = false
                        })
                    })
            }
        }
    }
}

struct LogHistory_Previews: PreviewProvider {
    static var previews: some View {
        LogHistory()
    }
}
