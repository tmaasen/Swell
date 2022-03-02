//
//  MealLog.swift
//  Swell
//
//  Created by Tanner Maasen on 2/15/22.
//

import SwiftUI

struct MealLog: View {
    @State var mealType: String
    @State var searchText = ""
    @State var searching = false
    @State var isLoading = false
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText, searching: $searching)
            Spacer()
            if foodViewModel.foodSearchDictionary.totalHits != nil {
                Text("\(String(foodViewModel.foodSearchDictionary.totalHits!)) Results")
                    .foregroundColor(.gray)
            }
            ScrollView {
                ForEach(foodViewModel.foodSearchResults, id: \.self.id) { foodItem in
                    LazyVStack {
                        FoodResultListItem(food: foodItem, meal: $mealType)
                    }
                }
            }
        }
        .navigationTitle(mealType)
        .toolbar {
            if searching {
                Button("Search") {
                    isLoading = true
                    foodViewModel.search(searchTerms: searchText, pageSize: 200)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        isLoading = false
                    })
                    withAnimation {
                        hideKeyboard()
                    }
                }
            }
        }
        .gesture(DragGesture()
                    .onChanged({ _ in
                        hideKeyboard()
                    })
        )
        if isLoading {
            ZStack(alignment: .leading) {
                LottieAnimation(filename: "loading", loopMode: .loop, width: 50, height: 50)
            }
        }
    }
}

struct MealLog_Previews: PreviewProvider {
    static var previews: some View {
        MealLog(mealType: "Breakfast")
    }
}
