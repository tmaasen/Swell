//
//  FoodResultListItem.swift
//  Swell
//
//  Created by Tanner Maasen on 2/19/22.
//

import SwiftUI

struct FoodResultListItem: View {
    var food: Food
    @State var showFoodInfoSheet: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(food.foodDescription.capitalizingFirstLetter())")
            Text("Category: ").bold() + Text("\(food.foodCategory ?? "Fast food")")
            Text("Score: ").bold() + Text("\(food.score, specifier: "%.2f")")
        }
        .onTapGesture {
            showFoodInfoSheet = true
        }
        .sheet(isPresented: $showFoodInfoSheet) {
            FoodResultSheet(food: food, showFoodInfoSheet: $showFoodInfoSheet)
        }
    }
}

struct FoodResultListItem_Previews: PreviewProvider {
    static var previews: some View {
        FoodResultListItem(food: Food(id: UUID(), fdcID: 123456, foodDescription: "McDonald's Cheeseburger", lowercaseDescription: "mcdonalds cheeseburger", score: 500.00, foodNutrients: [FoodNutrient()]))
    }
}
