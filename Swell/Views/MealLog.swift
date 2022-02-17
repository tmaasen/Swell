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
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText, searching: $searching)
            Spacer()
            List(foodViewModel.foodResults) { food in
                Text("\(food.foodDescription)")
            }
        }
        .navigationTitle(mealType)
        .toolbar {
            if searching {
                Button("Search") {
                    foodViewModel.search(searchTerms: searchText, pageSize: 1)
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
