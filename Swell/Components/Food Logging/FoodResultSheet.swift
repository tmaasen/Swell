//
//  FoodResultSheet.swift
//  Swell
//
//  Created by Tanner Maasen on 2/19/22.
//

import SwiftUI

/// Dynamic for both types of data types coming from FoodData Central: Food if searching for food, FoodRetriever if looking at food from History or MyMeals
struct FoodResultSheet: View { 
    var food: Food
    var foodRetriever: FoodRetriever
    @State private var logCompleted: Bool = false
    @State private var liked: Bool = false
    @State private var toast: Bool = false
    @State private var quantity: Int = 1
    @State private var selectedMeal: String = "Breakfast"
    @Binding var meal: String
    @Binding var showFoodInfoSheet: Bool
    @Binding var contains: [String]
    @EnvironmentObject var myMealsViewModel: MyMealsViewModel
    @EnvironmentObject var foodAndMoodViewModel: FoodAndMoodViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .top) {
                HStack {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 25))
                        .padding(.leading, 20)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    Spacer()
                    Image(systemName: liked ? "heart.fill" : "heart")
                        .font(.system(size: 25))
                        .foregroundColor(liked ? .red : .black)
                        .scaleEffect(liked ? 1.2 : 1)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6))
                        .padding(.trailing, 20)
                        .onTapGesture {
                            // triggers a small haptic vibration :)
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            liked.toggle()
                            toast = liked
                            if liked == true {
                                if food.foodDescription == "" {
                                    myMealsViewModel.addToMyMeals(pFoodId: foodRetriever.fdcID ?? 0, pFoodName: foodRetriever.foodDescription ?? "", pFoodCategory: foodRetriever.brandedFoodCategory ?? "food", pHighNutrients: getHighNutrients(pFoodNutrients: [FoodNutrient](), pFoodRetrieverNutrients: foodRetriever.foodNutrients ?? [FoodResultNutrient]()))
                                } else {
                                    myMealsViewModel.addToMyMeals(pFoodId: food.fdcID, pFoodName: food.foodDescription, pFoodCategory: food.foodCategory ?? "food", pHighNutrients: getHighNutrients(pFoodNutrients: food.foodNutrients, pFoodRetrieverNutrients: [FoodResultNutrient]()))
                                }
                            } else {
                                if food.foodDescription == "" {
                                    myMealsViewModel.removeFromMyMeals(pFoodName: foodRetriever.foodDescription ?? "")
                                } else {
                                    myMealsViewModel.removeFromMyMeals(pFoodName: food.foodDescription)
                                }
                            }
                        }
                }
                .padding(.top, 70)
                .zIndex(1.0)
                if food.foodDescription == "" {
                    LottieAnimation(filename: FoodCategories.categoryDict.first(where: {$0.value.contains(foodRetriever.brandedFoodCategory ?? "")})?.key ?? "food", loopMode: .loop, width: .infinity, height: .infinity)
                } else {
                    LottieAnimation(filename: FoodCategories.categoryDict.first(where: {$0.value.contains(food.foodCategory ?? "")})!.key, loopMode: .loop, width: .infinity, height: .infinity)
                }
            }
            .background(Rectangle().foregroundColor(Color("FoodSheet_Purple")))
            .clipShape(CustomShape(corner: .bottomLeft, radii: 55))
            .edgesIgnoringSafeArea(.top)
            .toast(message: "Added \(foodRetriever.foodDescription ?? food.foodDescription.capitalizingFirstLetter()) to MyMeals", isShowing: $toast, duration: Toast.short)
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("\(foodRetriever.foodDescription ?? food.foodDescription.capitalizingFirstLetter())")
                            .font(.custom("Ubuntu-Bold", size: 30))
                        Spacer()
                        NavigationLink(destination: Home(), isActive: $logCompleted,
                            label: {
                                Button(action: {
                                    if food.foodDescription == "" {
                                        foodAndMoodViewModel.logFood(pFoodId: foodRetriever.fdcID ?? 0, pFoodName: foodRetriever.foodDescription ?? "", pHighNutrients: getHighNutrients(pFoodNutrients: [FoodNutrient](), pFoodRetrieverNutrients: foodRetriever.foodNutrients ?? [FoodResultNutrient]()), pQuantity: Int(quantity), pMeal: selectedMeal, pContains: contains)
                                    } else {
                                        foodAndMoodViewModel.logFood(pFoodId: food.fdcID, pFoodName: food.foodDescription, pHighNutrients: getHighNutrients(pFoodNutrients: food.foodNutrients, pFoodRetrieverNutrients: [FoodResultNutrient]()), pQuantity: Int(quantity), pMeal: meal, pContains: contains)
                                    }
                                    logCompleted = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                        presentationMode.wrappedValue.dismiss()
                                        showFoodInfoSheet = false
                                    })
                                }, label: {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundColor(.green)
                                        .font(.system(size: 40))
                                })
                            })
                    }
                    .padding(.bottom, 5)
                    // When a meal type is not specified
                    if meal == "" {
                        MealTypePicker(selectedMeal: $selectedMeal)
                    }
                    HStack {
                        VStack {
                            Text("Servings:")
                                .font(.custom("Ubuntu", size: 16))
                        }
                        Spacer()
                        Stepper("\(quantity)", value: $quantity, in: 1...60, step: 1)
                            .font(.custom("Ubuntu", size: 16))
                        Text("(\(((foodRetriever.servingSize ?? food.servingSize ?? 1) * Double(quantity)), specifier: "%.2f")\(foodRetriever.servingSizeUnit ?? food.servingSizeUnit ?? ""))")
                            .font(.custom("Ubuntu", size: 14))
                    }
                    Text("Category: \(foodRetriever.brandedFoodCategory ?? food.foodCategory ?? "")")
                        .font(.custom("Ubuntu", size: 16))
                    Text(foodRetriever.brandName ?? foodRetriever.brandOwner ?? food.brandOwner ?? food.brandName ?? "")
                        .font(.custom("Ubuntu", size: 16))

                    Section(header: Text("Nutrition Facts")
                                        .bold()
                                        .font(.custom("Ubuntu", size: 18))) {
                        if food.foodDescription == "" {
                            ForEach(foodRetriever.foodNutrients ?? [FoodResultNutrient](), id: \.self) { nutrient in
                                if nutrient.amount ?? 0.0 > 0.0 {
                                    HStack {
                                        Text("\(nutrient.nutrient?.name ?? "")")
                                            .font(.custom("Ubuntu", size: 16))
                                        Spacer()
                                        Text("\(nutrient.amount ?? 0.0, specifier: "%.1f")\(nutrient.nutrient?.unitName ?? "")")
                                            .font(.custom("Ubuntu", size: 16))
                                    }
                                    Divider()
                                }
                            }
                        } else {
                            ForEach(food.foodNutrients, id: \.self) { nutrient in
                                if nutrient.value ?? 0.0 > 0.0 {
                                    HStack {
                                        Text("\(nutrient.nutrientName ?? "")")
                                            .font(.custom("Ubuntu", size: 16))
                                        Spacer()
                                        Text("\(nutrient.value ?? 0.0, specifier: "%.1f")\(nutrient.unitName ?? "")")
                                            .font(.custom("Ubuntu", size: 16))
                                    }
                                    Divider()
                                }
                            }
                        }
                    }
                    Text("Ingredients: \(foodRetriever.ingredients ?? food.ingredients ?? "")")
                        .font(.custom("Ubuntu", size: 16))
                        .lineSpacing(5)
                }
            }
            .padding()
        }
        .onAppear() {
            myMealsViewModel.isLiked(pFoodId: foodRetriever.fdcID ?? food.fdcID, completion: { value in
                liked = value
            })
        }
        .onDisappear() {
            presentationMode.wrappedValue.dismiss()
            showFoodInfoSheet = false
        }
        if logCompleted {
            LottieAnimation(filename: "checkmark", loopMode: .playOnce, width: 400, height: 400)
        }
    }
    func getHighNutrients(pFoodNutrients: [FoodNutrient], pFoodRetrieverNutrients: [FoodResultNutrient]) -> [String] {
        var highNutrients = [String]()
        // if food is high in nutrient, log nutrient
        // 20% DV or more of a nutrient per serving is considered high (fda)
        if pFoodNutrients.isEmpty {
            for nutrient in pFoodNutrients {
                if nutrient.value ?? 0 > 20 {
                    if nutrient.nutrientName! == "Protein" {
                        highNutrients.append("Protein")
                    }
                    if nutrient.nutrientName! == "Sugars, total including NLEA" {
                        highNutrients.append("Sugar")
                    }
                    if nutrient.nutrientName! == "Carbohydrate, by difference" {
                        highNutrients.append("Carbohydrates")
                    }
                }
            }
        } else {
            for nutrient in pFoodRetrieverNutrients {
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
        }
        return highNutrients
    }
}

struct FoodResultSheet_Previews: PreviewProvider {
    static var previews: some View {
        FoodResultSheet(food: Food(id: UUID(), fdcID: 123456, foodDescription: "McDonald's Cheeseburger", lowercaseDescription: "mcdonalds cheeseburger", score: 500.00, foodNutrients: [FoodNutrient()]), foodRetriever: FoodRetriever(), meal: .constant("Snack"), showFoodInfoSheet: .constant(false), contains: .constant(["Gluten"]))
    }
}
