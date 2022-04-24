//
//  AddMeal.swift
//  Swell
//
//  Created by Tanner Maasen on 4/9/22.
//

import SwiftUI

struct AddMeal: View {
    @State private var name = ""
    @State private var ingredientNames = [""]
    @State private var ingredientValues: [String] = [""]
    @State private var nutrientNames = [""]
    @State private var nutrientValues: [String] = [""]
    @State private var instructions = ""
    @State private var includes = [""]
    @State private var mealCreated: Bool = false
    @State private var selectedPickerIndex: Int = 0
    @EnvironmentObject var myMealsViewModel: MyMealsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // do something to sanitize input before sending it off to firestore
    var body: some View {
        Form {
            Section(header: Text("Meal")) {
                TextField("Meal Name", text: $name)
            }
            
            Section(header: Text("Food Category")) {
                Picker("", selection: $selectedPickerIndex) {
                    ForEach(0..<FoodCategories.aggregatedCategories.count) {
                        Text(FoodCategories.aggregatedCategories[$0])
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            
            Section(header: Text("Ingredients")) {
                ForEach(0..<ingredientNames.count, id: \.self){ ingredient in
                    HStack(spacing: 5){
                        TextField("Ingredient", text: $ingredientNames[ingredient])
                        Divider()
                        TextField("Amount (e.g., 1/2 cup)", text: $ingredientValues[ingredient])
                    }
                }
                Button("Add Ingredient"){
                    ingredientNames.append("")
                    ingredientValues.append("")
                }
            }
            
            Section(header: Text("Nutrition Facts")) {
                ForEach(0...nutrientNames.count-1, id: \.self) { nutrient in
                    HStack(spacing: 5){
                        TextField("Nutrient", text: $nutrientNames[nutrient])
                        Divider()
                        TextField("Amount", text: $nutrientValues[nutrient])
                    }
                }
                Button("Add Nutrient"){
                    nutrientNames.append("")
                    nutrientValues.append("")
                }
            }
            
            Section(header: Text("Instructions / Comments")) {
                VStack(alignment: .leading) {
                    TextEditor(text: $instructions)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 400)
            }
              
            Section {
                HStack(alignment: .bottom) {
                    Button(action: {
                        hideKeyboard()
                        myMealsViewModel.addCustomMeal(pMealName: name, pFoodCategory: FoodCategories.aggregatedCategories[selectedPickerIndex], pIngredientNames: ingredientNames, pIngredientValues: ingredientValues, pNutrientNames: nutrientNames, pNutrientValues: nutrientValues, pInstructions: instructions, completion: {
                            mealCreated = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                presentationMode.wrappedValue.dismiss()
                            })
                        })
                    }) {
                        Text("Save")
                            .withButtonStyles()
                    }
                }
            }
            .listRowBackground(Color.swellOrange)
        }
        .navigationTitle("New Meal")
        .onAppear() {
            print("Nutrient names: \(nutrientNames)")
        }
        if mealCreated {
            LottieAnimation(filename: "checkmark", loopMode: .playOnce, width: 400, height: 400)
        }
    } 
}

struct AddMeal_Previews: PreviewProvider {
    static var previews: some View {
        AddMeal()
    }
}
