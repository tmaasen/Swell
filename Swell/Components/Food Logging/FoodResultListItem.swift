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
    @State var showFoodInfoSheet: Bool = false
    @State private var containsGluten: Bool = false
    @State private var containsLactose: Bool = false
    @State private var containsCaffeine: Bool = false
    @State private var isWholeGrain: Bool = false
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
                    Text("Contains: \(containsGluten ? "gluten" : "") \(containsLactose ? " lactose" : "") \(containsCaffeine ? " caffeine" : "")")
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
            FoodResultSheet(food: food, meal: $meal, showFoodInfoSheet: $showFoodInfoSheet)
        }
        .onAppear() {
            if(food.ingredients != nil) {
                if ((food.ingredients?.contains("Gluten")) != false ||
                    (food.ingredients?.contains("BREAD")) != false) {
                    containsGluten = true
                }
                if ((food.ingredients?.contains("Lactose")) != false ||
                    (food.ingredients?.contains("MILK")) != false) {
                    containsLactose = true
                }
                if ((food.ingredients?.contains("Caffeine")) != false ||
                    (food.ingredients?.contains("COFFEE")) != false ||
                    (food.foodDescription.contains("Coffee")) != false) {
                    containsCaffeine = true
                }
                if ((food.ingredients?.contains("Whole Grain")) != false ||
                    (food.foodDescription.contains("Oatmeal")) != false) {
                    isWholeGrain = true
                }
            }
        }
    }
}

struct FoodResultListItem_Previews: PreviewProvider {
    static var previews: some View {
        FoodResultListItem(food: Food(id: UUID(), fdcID: 123456, foodDescription: "McDonald's Cheeseburger", lowercaseDescription: "mcdonalds cheeseburger", score: 500.00, foodNutrients: [FoodNutrient()]), meal: .constant("Snack"))
    }
}
