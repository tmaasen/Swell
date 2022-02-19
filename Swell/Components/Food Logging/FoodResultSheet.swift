//
//  FoodResultSheet.swift
//  Swell
//
//  Created by Tanner Maasen on 2/19/22.
//

import SwiftUI

struct FoodResultSheet: View {
    var food: Food
    @Binding var showFoodInfoSheet: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(food.foodDescription.capitalizingFirstLetter())")
            Text("Category: \(food.foodCategory ?? "")")
            Text("Score: \(food.score)")
        }
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            showFoodInfoSheet = false
        }, label: {
            Label("Close", systemImage: "xmark.circle")
        })
    }
}

struct FoodResultSheet_Previews: PreviewProvider {
    static var previews: some View {
        FoodResultSheet(food: Food(id: UUID(), fdcID: 123456, foodDescription: "McDonald's Cheeseburger", lowercaseDescription: "mcdonalds cheeseburger", score: 500.00, foodNutrients: [FoodNutrient()]), showFoodInfoSheet: .constant(false))
    }
}
