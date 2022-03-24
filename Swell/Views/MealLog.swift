//
//  MealLog.swift
//  Swell
//
//  Created by Tanner Maasen on 2/15/22.
//
//  MealLog is the main view for the food logging process.

import SwiftUI

struct MealLog: View {
    @State var mealType: String
    @State private var searchText = ""
    @State private var searching = false
    @State private var isLoading = false
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText, searching: $searching, isLoading: $isLoading)
            Spacer()
            if isLoading {
                LottieAnimation(filename: "loading", loopMode: .loop, width: 50, height: 50)
            }
            if foodViewModel.foodSearchDictionary.totalHits != nil && !isLoading {
                if foodViewModel.foodSearchDictionary.totalHits == 0 {
                    Image("NoData")
                        .resizable()
                        .scaledToFit()
                    Text("Hmm...we couldn't find that one. What else is on your menu?")
                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                } else {
                    Text("\(String(foodViewModel.searchResultsNumber ?? 0)) Results")
                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                    ScrollView {
                        ForEach(foodViewModel.foodSearchResults, id: \.self.id) { foodItem in
                            LazyVStack {
                                FoodResultListItem(food: foodItem, meal: $mealType)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .navigationTitle(mealType)
        .onTapGesture {
            hideKeyboard()
        }
        .onDisappear() {
            foodViewModel.foodSearchDictionary.totalHits = nil
            foodViewModel.foodSearchResults.removeAll()
            foodViewModel.searchResultsNumber = 0
        }
    }
}

struct MealLog_Previews: PreviewProvider {
    static var previews: some View {
        MealLog(mealType: "Breakfast")
    }
}
