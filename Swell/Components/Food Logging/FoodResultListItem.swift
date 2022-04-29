//
//  FoodResultListItem.swift
//  Swell
//
//  Created by Tanner Maasen on 2/19/22.
//

import SwiftUI

struct FoodResultListItem: View {
    var food: Food
    @Binding var meal: String
    @State private var showFoodInfoSheet: Bool = false
    @State private var containsGluten: Bool = false
    @State private var containsLactose: Bool = false
    @State private var containsCaffeine: Bool = false
    @State private var isWholeGrain: Bool = false
    @State private var contains = [String]()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(food.foodDescription.capitalizingFirstLetter())")
                    .foregroundColor(.black)
                    .font(.custom("Ubuntu-Bold", size: 18))
                Text("\(food.foodCategory ?? "")")
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
                if (food.brandOwner != nil) || (food.brandName != nil) {
                    Text(food.brandOwner ?? food.brandName ?? "")
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
            FoodResultSheet(food: food, foodRetriever: FoodRetriever(), meal: $meal, showFoodInfoSheet: $showFoodInfoSheet, contains: $contains)
        }
        .onAppear() {
            checkSpecialFoodNutrients(food: food)
        }
    }
    func checkSpecialFoodNutrients(food: Food) {
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
                    (food.foodDescription.uppercased().contains("OATMEAL")) != false ||
                    (food.foodDescription.uppercased().contains("OATS")) != false) {
                isWholeGrain = true
                contains.append("Whole Grain")
            }
        }
    }
}

struct FoodResultListItem_Previews: PreviewProvider {
    static var previews: some View {
        FoodResultListItem(food: Food(id: UUID(), fdcID: 123456, foodDescription: "McDonald's Cheeseburger", lowercaseDescription: "mcdonalds cheeseburger", score: 500.00, foodNutrients: [FoodNutrient()]), meal: .constant("Snack"))
    }
}
