//
//  MealLog.swift
//  Swell
//
//  Created by Tanner Maasen on 2/15/22.
//

import SwiftUI

struct MealLog: View {
    var mealType:String
    @State var searchText = ""
    @State var searching = false
    @StateObject var foodViewModel = FoodDataCentralViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText, searching: $searching)
            Spacer()
            if foodViewModel.foodDict.totalHits != nil {
                Text("\(String(foodViewModel.foodDict.totalHits!)) Results")
                    .foregroundColor(.gray)
            }
            List(foodViewModel.foodResults) { foodItem in
                FoodResultListItem(food: foodItem)
            }
        }
        .navigationTitle(mealType)
        .toolbar {
            if searching {
                Button("Search") {
                    foodViewModel.search(searchTerms: searchText, pageSize: 200)
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
    }
}

struct MealLog_Previews: PreviewProvider {
    static var previews: some View {
        MealLog(mealType: "Breakfast")
    }
}
