//
//  LogHistory.swift
//  Swell
//
//  Created by Tanner Maasen on 3/14/22.
//

import SwiftUI

struct LogHistory: View {
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    @Binding var selectedDate: Date
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack {
            if !foodViewModel.foodHistory.isEmpty && !isLoading {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(MealTypes.allCases, id: \.self) { meal in
                            Text(foodViewModel.foodHistory.first(where: {$0.mealType == meal.text}) != nil ? meal.text : "")
                                .font(.custom("Ubuntu-BoldItalic", size: 20))
                                .padding(.horizontal)
                            ForEach(foodViewModel.foodHistory, id: \.self.id) { item in
                                if item.mealType == meal.text && item.mealType != "Water" {
                                    HistoryFoodItem(item: item)
                                }
                            }
                        }
                        if foodViewModel.waters.waterLoggedToday != 0 {
                            Text("Water")
                                .font(.custom("Ubuntu-BoldItalic", size: 20))
                                .padding(.horizontal)
                            HistoryWaterItem()
                        }
                    }
                }
            } else {
                Spacer()
                if !isLoading {
                    Image("NoData")
                        .resizable()
                        .scaledToFit()
                    Text("No logging history on this day!")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                }
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                DatePicker("📅", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                    .onChange(of: selectedDate, perform: { value in
                        isLoading = true
                        foodViewModel.foodHistory.removeAll()
                        foodViewModel.getFoodIds(date: selectedDate)
                        foodViewModel.getWater(date: selectedDate)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    })
            }
        }
    }
}

struct LogHistory_Previews: PreviewProvider {
    static var previews: some View {
        LogHistory(selectedDate: .constant(Date()), isLoading: .constant(false))
    }
}
