//
//  CustomMeals.swift
//  Swell
//
//  Created by Tanner Maasen on 4/22/22.
//

import SwiftUI

struct CustomMealsListItem: View {
    var myMeal: MyMeal
    @State private var showCustomMealsSheet: Bool = false
    @State private var containsGluten: Bool = false
    @State private var containsLactose: Bool = false
    @State private var containsCaffeine: Bool = false
    @State private var isWholeGrain: Bool = false
    @State private var contains = [String]()
    @EnvironmentObject var myMealsViewModel: MyMealsViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(myMeal.name ?? "")
                    .foregroundColor(.black)
                    .font(.custom("Ubuntu-Bold", size: 18))
                Text(myMeal.foodCategory ?? "")
                    .foregroundColor(Color("FoodListItem_DarkGray"))
                    .font(.custom("Ubuntu", size: 12))
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
            showCustomMealsSheet = true
            checkSpecialFoodNutrients(food: myMeal.foodInfo ?? FoodRetriever())
        }
        .sheet(isPresented: $showCustomMealsSheet) {
            CustomMealsSheet(myMeal: myMeal, isFromHistory: false, contains: $contains)
        }
    }
    public func checkSpecialFoodNutrients(food: FoodRetriever) {
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
                    (food.foodDescription!.uppercased().contains("OATMEAL")) != false ||
                    (food.foodDescription!.uppercased().contains("OATS")) != false) {
                isWholeGrain = true
                contains.append("Whole Grain")
            }
        }
    }
}
