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
    @State private var liked: Bool = false
    @State private var quantity: Int = 1
    @Binding var meal: String
    @Binding var showFoodInfoSheet: Bool
    @Binding var contains: [String]
    @EnvironmentObject var userViewModel: MyMealsViewModel
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            // Top back button and like buttons
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
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            liked.toggle()
                            if liked == true {
                                userViewModel.addMeal(pFdcId: food.fdcID)
                            } else {
                                userViewModel.removeMeal(pFdcId: food.fdcID)
                            }
                        }
                }
                .padding(.top, 70)
                .zIndex(1.0)
                LottieAnimation(filename: FoodCategories.categoryDict.first(where: {$0.value.contains(food.foodCategory ?? "")})!.key, loopMode: .loop, width: .infinity, height: .infinity)
            }
            .background(Rectangle().foregroundColor(Color("FoodSheet_Purple")))
            .clipShape(CustomShape(corner: .bottomLeft, radii: 55))
            .edgesIgnoringSafeArea(.top)
            .toast(message: "\(liked ? "Added \(food.foodDescription.capitalizingFirstLetter()) to" : "Removed \(food.foodDescription.capitalizingFirstLetter()) from") MyMeals",
                         isShowing: $liked,
                         duration: Toast.short)
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("\(food.foodDescription.capitalizingFirstLetter())")
                            .font(.custom("Ubuntu-Bold", size: 30))
                        Spacer()
                        NavigationLink(
                            destination: Home(),
                            isActive: $logCompleted,
                            label: {
                                Button(action: {
                                    foodViewModel.logFood(pFoodToLog: food, pQuantity: Int(quantity), pMeal: meal, pContains: contains)
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
                    HStack {
                        VStack {
                            Text("Servings:")
                                .font(.custom("Ubuntu", size: 16))
                        }
                        Spacer()
                        Stepper("\(quantity)", value: $quantity, in: 1...60, step: 1)
                            .font(.custom("Ubuntu", size: 16))
                        if (food.servingSize != nil) {
                            Text("(\((food.servingSize! * Double(quantity)), specifier: "%.2f")\(food.servingSizeUnit ?? ""))")
                                .font(.custom("Ubuntu", size: 14))
                        }
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
                    if (food.ingredients != nil) {
                        Text("Ingredients: \(food.ingredients ?? "")")
                            .font(.custom("Ubuntu", size: 16))
                            .lineSpacing(5)
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
        FoodResultSheet(food: Food(id: UUID(), fdcID: 123456, foodDescription: "McDonald's Cheeseburger", lowercaseDescription: "mcdonalds cheeseburger", score: 500.00, foodNutrients: [FoodNutrient()]), meal: .constant("Snack"), showFoodInfoSheet: .constant(false), contains: .constant(["Gluten"]))
    }
}

struct CustomShape: Shape {
    var corner: UIRectCorner
    var radii: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii))
        
        return Path(path.cgPath)
    }
}
