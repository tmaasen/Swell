//
//  MealLog.swift
//  Swell
//
//  Created by Tanner Maasen on 2/15/22.
//

import SwiftUI

struct MealLog: View {
    @State var mealType: String
    @State private var searchText = ""
    @State private var searching = false
    @State private var isLoading = false
    @State private var noResults = false
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack {
                SearchBar(searchText: $searchText, searching: $searching)
                Spacer()
                if searching {
                    Label("Go", systemImage: "arrow.forward.circle")
                        .padding()
                        .onTapGesture {
                            isLoading = true
                            foodViewModel.search(searchTerms: searchText, pageSize: 200)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                isLoading = false
                                if foodViewModel.foodSearchDictionary.totalHits == 0 {
                                    noResults = true
                                } else {
                                    noResults = false
                                }
                            })
                            withAnimation {
                                hideKeyboard()
                            }
                        }
                }
            }
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
                } else {
                    Text("\(String(foodViewModel.foodSearchDictionary.totalHits!)) Results")
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
