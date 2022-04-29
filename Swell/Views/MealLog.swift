//
//  MealLog.swift
//  Swell
//
//  Created by Tanner Maasen on 2/15/22.
//

import SwiftUI

///  MealLog is the main view for the food logging process.
struct MealLog: View {
    var pickerOptions = ["Search", "MyMeals"]
    @State private var selectedPickerIndex: Int = 0
    @State var mealType: String
    @State private var searchText = ""
    @State private var searching = false
    @State private var isLoading = false
    @EnvironmentObject var foodAndMoodViewModel: FoodAndMoodViewModel
    @EnvironmentObject var myMealsViewModel: MyMealsViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText, searching: $searching, isLoading: $isLoading)
            
            Picker("", selection: $selectedPickerIndex) {
                ForEach(0..<pickerOptions.count) {
                    Text(self.pickerOptions[$0])
                }
            }
            .padding()
            .pickerStyle(SegmentedPickerStyle())
            
            Spacer()
            
            if isLoading {
                LottieAnimation(filename: "loading", loopMode: .loop, width: 50, height: 50)
            }
            
            if selectedPickerIndex == 0 {
                // Search
                if foodAndMoodViewModel.foodSearchDictionary.totalHits != nil && !isLoading {
                    if foodAndMoodViewModel.foodSearchDictionary.totalHits == 0 {
                        Image("NoData")
                            .resizable()
                            .scaledToFit()
                        Text("Hmm...we couldn't find that one. What else is on your menu?")
                            .foregroundColor(colorScheme == .dark ? .white : .gray)
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                    } else {
                        Text("\(String(foodAndMoodViewModel.searchResultsNumber ?? 0)) Results")
                            .foregroundColor(colorScheme == .dark ? .white : .gray)
                        ScrollView {
                            ForEach(foodAndMoodViewModel.foodSearchResults, id: \.self.id) { foodItem in
                                LazyVStack {
                                    FoodResultListItem(food: foodItem, meal: $mealType)
                                }
                            }
                        }
                    }
                }
            } else {
                ScrollView {
                    ForEach(myMealsViewModel.myMeals, id: \.self) { myMeal in
                        if myMeal.isCustomMeal! {
                            CustomMealsListItem(myMeal: myMeal)
                        } else {
                            FdcFavoritesListItem(foodRetriever: myMeal.foodInfo ?? FoodRetriever(), foodCategory: myMeal.foodCategory ?? "food", foodName: myMeal.name ?? "", meal: $mealType)
                        }
                    }
                }
            }
            Spacer()
        }
        .navigationTitle(mealType)
        .onDisappear() {
            foodAndMoodViewModel.foodSearchDictionary.totalHits = nil
            foodAndMoodViewModel.foodSearchResults.removeAll()
            foodAndMoodViewModel.searchResultsNumber = 0
        }
    }
}

struct MealLog_Previews: PreviewProvider {
    static var previews: some View {
        MealLog(mealType: "Breakfast")
    }
}
