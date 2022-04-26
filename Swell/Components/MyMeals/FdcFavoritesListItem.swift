//
//  FdcFavorites.swift
//  Swell
//
//  Created by Tanner Maasen on 4/22/22.
//

import SwiftUI

struct FdcFavoritesListItem: View {
    var foodRetriever: FoodRetriever
    var foodCategory: String
    var foodName: String
    @State var showFoodInfoSheet: Bool = false
    @State private var containsGluten: Bool = false
    @State private var containsLactose: Bool = false
    @State private var containsCaffeine: Bool = false
    @State private var isWholeGrain: Bool = false
    @State var contains = [String]()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(foodName)")
                    .foregroundColor(.black)
                    .font(.custom("Ubuntu-Bold", size: 18))
                Text("\(foodCategory)")
                    .foregroundColor(Color("FoodListItem_DarkGray"))
                    .font(.custom("Ubuntu", size: 12))
                if (containsCaffeine || containsLactose || containsGluten) {
                    Text("Contains: \(containsGluten ? "Gluten" : "") \(containsLactose ? " Lactose" : "") \(containsCaffeine ? " Caffeine" : "")")
                        .foregroundColor(Color("FoodListItem_DarkGray"))
                        .font(.custom("Ubuntu", size: 12))
                }
                if (isWholeGrain) {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(Color.green)
                        Text("Whole Grain")
                            .foregroundColor(Color("FoodListItem_DarkGray"))
                            .font(.custom("Ubuntu", size: 12))
                    }
                }
                if (foodRetriever.brandOwner != nil) || (foodRetriever.brandName != nil) {
                    Text(foodRetriever.brandOwner ?? foodRetriever.brandName ?? "")
                        .foregroundColor(Color("FoodListItem_DarkGray"))
                        .font(.custom("Ubuntu", size: 12))
                }
            }
            Spacer()
            Image(systemName: "plus.circle")
                .font(.system(size: 30))
                .foregroundColor(Color("FoodListItem_DarkGray"))
        }
        .padding()
        .background(Color("FoodListItem_LightGray"))
        .cornerRadius(8)
        .padding(.horizontal, 15)
        .onTapGesture {
            showFoodInfoSheet = true
        }
        .sheet(isPresented: $showFoodInfoSheet) {
            FoodResultSheet(food: Food(fdcID: 0, foodDescription: "", lowercaseDescription: "", score: 0, foodNutrients: [FoodNutrient]()), foodRetriever: foodRetriever, meal: .constant(""), showFoodInfoSheet: $showFoodInfoSheet, contains: $contains)
        }
        .onAppear() {
            checkSpecialFoodNutrients(food: foodRetriever)
        }
    }
    func checkSpecialFoodNutrients(food: FoodRetriever) {
        if(food.ingredients != nil) {
            if ((food.ingredients?.uppercased().contains("GLUTEN")) != false ||
                    (food.ingredients?.uppercased().contains("BREAD")) != false ||
                    (food.ingredients?.uppercased().contains("FLOUR")) != false) {
                containsGluten = true
                contains.append("Gluten")
            }
            if ((food.ingredients?.uppercased().contains("LACTOSE")) != false ||
                    (food.ingredients?.uppercased().contains("MILK")) != false ||
                    (food.ingredients?.uppercased().contains("DAIRY")) != false) {
                containsLactose = true
                contains.append("Dairy")
            }
            if ((food.ingredients?.uppercased().contains("CAFFEINE")) != false ||
                    (food.ingredients?.uppercased().contains("COFFEE")) != false) {
                containsCaffeine = true
                contains.append("Caffeine")
            }
            if ((food.ingredients?.uppercased().contains("WHOLE GRAIN")) != false ||
                    (food.foodDescription?.uppercased().contains("OATMEAL")) != false ||
                    (food.foodDescription?.uppercased().contains("OATS")) != false) {
                isWholeGrain = true
                contains.append("Whole Grain")
            }
        }
    }
}
