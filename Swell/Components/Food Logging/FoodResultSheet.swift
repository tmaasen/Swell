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
    @State private var quantity: String = "1"
    @Binding var meal: String
    @Binding var showFoodInfoSheet: Bool
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            LottieAnimation(filename: "cleanVegetableFood", loopMode: .loop, width: .infinity, height: .infinity)
                .background(Rectangle()
                                .foregroundColor(Color("FoodSheet_Purple")))
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("\(food.foodDescription.capitalizingFirstLetter())")
                        .font(.custom("Ubuntu-Bold", size: 35))
                        .padding(.bottom, 20)
                    HStack {
                        Text("Quantity:")
                            .font(.custom("Ubuntu", size: 20))
                        TextField(quantity, text: $quantity)
                            .padding()
                            .keyboardType(.numberPad)
                            .border(Color("FoodListItem_DarkGray"))
                            .frame(maxWidth: 50)
                            .multilineTextAlignment(.center)
                        Spacer()
                        NavigationLink(
                            destination: Home(),
                            isActive: $logCompleted,
                            label: {
                                Button(action: {
                                    foodViewModel.logNutrition(pFoodToLog: food, pQuantity: Int(quantity), pMeal: meal)
                                    logCompleted = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                        presentationMode.wrappedValue.dismiss()
                                        showFoodInfoSheet = false
                                    })
                                }, label: {
                                    Label("Log Item", systemImage: "checkmark")
                                })
                            })
                    }
                    Text("Category: \(food.foodCategory ?? "Fast Foods")")
                        .font(.custom("Ubuntu", size: 20))
                    Text("Score: \(food.score)")
                        .font(.custom("Ubuntu", size: 20))
                    Text("Meal: \(meal)")
                        .font(.custom("Ubuntu", size: 20))
                }
            }
            .padding()
        }
        .onDisappear() {
            presentationMode.wrappedValue.dismiss()
            showFoodInfoSheet = false
        }
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
