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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            LottieAnimation(filename: "cleanVegetableFood", loopMode: .loop, width: .infinity, height: .infinity)
                .background(Rectangle()
                .foregroundColor(Color("FoodSheet_Purple")))
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("\(food.foodDescription)")
                            .textCase(.uppercase)
                            .font(.custom("Ubuntu-Bold", size: 30))
                        Spacer()
                        NavigationLink(
                            destination: Home(),
                            isActive: $logCompleted,
                            label: {
                                Button(action: {
                                    foodViewModel.logFood(pFoodToLog: food, pQuantity: Int(quantity), pMeal: meal)
                                    logCompleted = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                        presentationMode.wrappedValue.dismiss()
                                        showFoodInfoSheet = false
                                    })
                                }, label: {
                                    VStack {
                                        Image(systemName: "checkmark.circle")
                                            .foregroundColor(.green)
                                            .font(.system(size: 50))
                                        Text("Log Item")
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                            .font(.custom("Ubuntu-Bold", size: 25))
                                    }
                                })
                            })
                    }
                    .padding(.bottom, 20)
                    HStack {
                        VStack {
                            Text("Servings:")
                                .font(.custom("Ubuntu", size: 20))
                            if (food.servingSize != nil && !quantity.isEmpty) {
                                Text("(\((food.servingSize! * Double(quantity)!), specifier: "%.2f")\(food.servingSizeUnit ?? ""))")
                                    .font(.custom("Ubuntu", size: 14))
                            }
                        }
                        Spacer()
                        TextField(quantity, text: $quantity)
                            .padding()
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
                            )
                            .padding(.horizontal)
                    }
                    Text("Category: \(food.foodCategory ?? "")")
                        .font(.custom("Ubuntu", size: 16))
                    Text(food.brandOwner ?? food.brandName ?? "")
                        .font(.custom("Ubuntu", size: 16))
                    Section(header:
                                Text("Nutrition Facts")
                                .bold()
                                .font(.custom("Ubuntu", size: 18))) {
                        ForEach(food.foodNutrients, id: \.self) { nutrient in
                            HStack {
                                Text("\(nutrient.nutrientName ?? "")")
                                    .font(.custom("Ubuntu", size: 16))
                                Spacer()
                                Text("\(nutrient.value ?? 0.0, specifier: "%.2f")\(nutrient.unitName ?? "")")
                                    .font(.custom("Ubuntu", size: 16))
                            }
                            Divider()
                        }
                    }
                    if (food.ingredients != nil) {
                        Text("Ingredients: \(food.ingredients ?? "")")
                            .font(.custom("Ubuntu", size: 16))
                    }
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
