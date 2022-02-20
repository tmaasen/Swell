//
//  FoodResultSheet.swift
//  Swell
//
//  Created by Tanner Maasen on 2/19/22.
//

import SwiftUI

struct FoodResultSheet: View {
    var food: Food
    @State private var logCompleted: Bool = false
    @Binding var meal: String
    @Binding var showFoodInfoSheet: Bool
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(food.foodDescription.capitalizingFirstLetter())")
            Text("Category: \(food.foodCategory ?? "")")
            Text("Score: \(food.score)")
            Text("Meal: \(meal)")
        }
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            showFoodInfoSheet = false
        }, label: {
            Label("Close", systemImage: "xmark.circle")
        })
        NavigationLink(
            destination: Home(),
            isActive: $logCompleted,
            label: {
                Button(action: {
                    foodViewModel.logNutrition(pFoodToLog: food, pQuantity: 1, pMeal: meal)
                    logCompleted = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        presentationMode.wrappedValue.dismiss()
                        showFoodInfoSheet = false
                    })
                }, label: {
                    Label("Log Item", systemImage: "checkmark")
                })
            })
        if logCompleted {
            LottieAnimation(filename: "checkmark", loopMode: .playOnce, width: 400, height: 400)
        }
    }
}

struct FoodResultSheet_Previews: PreviewProvider {
    static var previews: some View {
        FoodResultSheet(food: Food(id: UUID(), fdcID: 123456, foodDescription: "McDonald's Cheeseburger", lowercaseDescription: "mcdonalds cheeseburger", score: 500.00, foodNutrients: [FoodNutrient()]), meal: .constant("Snack"), showFoodInfoSheet: .constant(false))
    }
}
