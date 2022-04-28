//
//  CustomMealsSheet.swift
//  Swell
//
//  Created by Tanner Maasen on 4/25/22.
//

import SwiftUI

struct CustomMealsSheet: View {
    var myMeal: MyMeal
    var isFromHistory: Bool
    @State private var logCompleted: Bool = false
    @State private var selectedMeal: String = "Breakfast"
    @State private var quantity: Int = 1
    @Binding var contains: [String]
    @EnvironmentObject var myMealsViewModel: MyMealsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 25))
                    .padding(.leading, 20)
                    .onTapGesture { presentationMode.wrappedValue.dismiss() }
                .padding(.top, 70)
                .zIndex(1.0)
                LottieAnimation(filename: FoodCategories.categoryDict.first(where: {$0.key.contains(myMeal.foodCategory ?? "")})?.key ?? "food", loopMode: .loop, width: .infinity, height: .infinity)
            }
            .background(Rectangle().foregroundColor(Color.yellow))
            .clipShape(CustomShape(corner: .bottomLeft, radii: 55))
            .edgesIgnoringSafeArea(.top)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("\(myMeal.name ?? "")")
                            .font(.custom("Ubuntu-Bold", size: 30))
                        Spacer()
                        DeleteButton(docId: isFromHistory ? myMeal.docId ?? "" : myMeal.name ?? "", collection: isFromHistory ? "food" : "myMeals", popUpText: isFromHistory ? "This will permanently remove this item from your history, as well as all mood data accociated with this item." : "This will permanently remove your custom meal from MyMeals. This action cannot be undone.")
                    }
                    .padding(.bottom, 5)
                    
                    if !isFromHistory {
                        HStack {
                            // When a meal type is not specified
                            MealTypePicker(selectedMeal: $selectedMeal)
                            
                            Button(action: {
                                myMealsViewModel.logCustomMeal(pFood: myMeal, pHighNutrients: getHighNutrients(pFoodNutrients: myMeal.foodInfo?.foodNutrients ?? [FoodResultNutrient]()), pQuantity: quantity, pMealType: selectedMeal, pContains: contains, completion: { didCompleteSuccessfully in
                                    logCompleted = true
                                })
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    presentationMode.wrappedValue.dismiss()
                                })
                            }, label: {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                                    .font(.system(size: 40))
                            })
                        }
                    }
                    
                    HStack {
                        if !isFromHistory {
                            VStack {
                                Text("Servings:")
                                    .font(.custom("Ubuntu", size: 16))
                            }
                            Spacer()
                            Stepper("\(quantity)", value: $quantity, in: 1...60, step: 1)
                                .font(.custom("Ubuntu", size: 16))
                            Text("(\((myMeal.foodInfo?.servingSize ?? 1 * Double(quantity)), specifier: "%.2f")\(myMeal.foodInfo?.servingSizeUnit ?? myMeal.foodInfo?.servingSizeUnit ?? ""))")
                                .font(.custom("Ubuntu", size: 14))
                        } else {
                            VStack {
                                Text("Servings: \(quantity)")
                                    .font(.custom("Ubuntu", size: 16))
                            }
                        }
                    }
                    Text("Category: \(myMeal.foodCategory ?? "")")
                        .font(.custom("Ubuntu", size: 16))
                    
                    if myMeal.ingredientNames?.count ?? 0 > 0 {
                        CustomMealsSheet_Section(title: "Ingredients", array1: myMeal.ingredientNames ?? [], array2: myMeal.ingredientValues ?? [])
                    }
                    if myMeal.nutrientNames?.count ?? 0 > 0 {
                        CustomMealsSheet_Section(title: "Nutrition Facts", array1: myMeal.nutrientNames ?? [], array2: myMeal.nutrientValues ?? [])
                    }
                    
                    Section(header:
                                Text("Instructions")
                                .bold()
                                .font(.custom("Ubuntu", size: 18))) {
                        Text(myMeal.instructions ?? "")
                            .font(.custom("Ubuntu", size: 16))
                    }
                }
            }
            .padding()
        }
        if logCompleted {
            LottieAnimation(filename: "checkmark", loopMode: .playOnce, width: 400, height: 400)
        }
    }
    
    func getHighNutrients(pFoodNutrients: [FoodResultNutrient]) -> [String] {
        var highNutrients = [String]()
        // if food is high in nutrient, log nutrient
        // 20% DV or more of a nutrient per serving is considered high (fda)
        for nutrient in pFoodNutrients {
            if nutrient.amount ?? 0 > 20 {
                if nutrient.nutrient?.name == "Protein" {
                    highNutrients.append("Protein")
                }
                if nutrient.nutrient?.name == "Sugars, total including NLEA" {
                    highNutrients.append("Sugar")
                }
                if nutrient.nutrient?.name == "Carbohydrate, by difference" {
                    highNutrients.append("Carbohydrates")
                }
            }
        }
        return highNutrients
    }
}

struct CustomMealsSheet_Previews: PreviewProvider {
    static var previews: some View {
        CustomMealsSheet(myMeal: MyMeal(), isFromHistory: true, contains: .constant(["Gluten"]))
    }
}
