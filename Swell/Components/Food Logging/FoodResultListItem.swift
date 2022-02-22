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
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(food.foodDescription.capitalizingFirstLetter())")
                    .font(.custom("Ubuntu-Bold", size: 18))
                Text("\(food.foodCategory ?? "Fast food")")
                    .foregroundColor(Color("FoodListItem_DarkGray"))
                    .font(.custom("Ubuntu", size: 12))
                Text("Contains: gluten")
                    .foregroundColor(Color("FoodListItem_DarkGray"))
                    .font(.custom("Ubuntu", size: 12))
                Text("Score: \(food.score, specifier: "%.2f")")
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
            showFoodInfoSheet = true
        }
        .sheet(isPresented: $showFoodInfoSheet) {
            FoodResultSheet(food: food, meal: $meal, showFoodInfoSheet: $showFoodInfoSheet)
        }
    }
}

struct FoodResultListItem_Previews: PreviewProvider {
    static var previews: some View {
        FoodResultListItem(food: Food(id: UUID(), fdcID: 123456, foodDescription: "McDonald's Cheeseburger", lowercaseDescription: "mcdonalds cheeseburger", score: 500.00, foodNutrients: [FoodNutrient()]), meal: .constant("Snack"))
    }
}
