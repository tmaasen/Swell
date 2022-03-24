//
//  FoodInfoSheet.swift
//  Swell
//
//  Created by Tanner Maasen on 3/23/22.
//

import SwiftUI

struct FoodInfoSheet: View {
    var foodRetriever: FoodRetriever
    @Binding var showFoodDataSheet: Bool
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var lottieFoodAnimations = ["Fast Foods", "Chewing Gum & Mints", "Pizza", "Pre-Packaged Fruit and Vegetables", "Cookies & Biscuits", "Frozen Dinners & Entrees", "Powdered Drinks", "Soda", "Seasoning Mixes, Salts, Marinades & Tenderizers"]
    
    var body: some View {
        VStack(alignment: .leading) {
            LottieAnimation(filename: lottieFoodAnimations.contains(foodRetriever.brandedFoodCategory!) ? foodRetriever.brandedFoodCategory! : "Soda", loopMode: .loop, width: .infinity, height: .infinity)
                .background(Rectangle()
                .foregroundColor(Color("FoodSheet_Purple")))
                .clipShape(CustomShape(corner: .bottomLeft, radii: 55))
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("\(foodRetriever.foodDescription?.capitalizingFirstLetter() ?? "")")
                            .font(.custom("Ubuntu-Bold", size: 30))
                        Spacer()
                        DeleteButton(docId: foodRetriever.docId ?? "", collection: "food")
                    }
                    .padding(.bottom, 5)
                    HStack {
                        VStack {
                            Text("Servings:")
                                .font(.custom("Ubuntu", size: 16))
                        }
                        Spacer()
                        if (foodRetriever.servingSize != nil) {
                            Text("\(foodRetriever.servingSize ?? 0, specifier: "%.2f")\(foodRetriever.servingSizeUnit ?? "")")
                                .font(.custom("Ubuntu", size: 14))
                        }
                    }
                    Text("Category: \(foodRetriever.brandedFoodCategory ?? "")")
                        .font(.custom("Ubuntu", size: 16))
                    Text(foodRetriever.brandOwner ?? foodRetriever.brandName ?? "")
                        .font(.custom("Ubuntu", size: 16))
                    Section(header:
                                Text("Nutrition Facts")
                                .bold()
                                .font(.custom("Ubuntu", size: 18))) {
                        ForEach(foodRetriever.foodNutrients ?? [], id: \.self) { nutrient in
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
                    }
                    if (foodRetriever.ingredients != nil) {
                        Text("Ingredients: \(foodRetriever.ingredients ?? "")")
                            .font(.custom("Ubuntu", size: 16))
                            .lineSpacing(5)
                    }
                }
            }
            .padding()
        }
        .onDisappear() {
            presentationMode.wrappedValue.dismiss()
            showFoodDataSheet = false
        }
    }
}

struct FoodInfoSheet_Previews: PreviewProvider {
    static var previews: some View {
        FoodInfoSheet(
//            food: Food(id: UUID(), fdcID: 123456, foodDescription: "McDonald's Cheeseburger", lowercaseDescription: "mcdonalds cheeseburger", score: 500.00, foodNutrients: [FoodNutrient()]),
                      foodRetriever: FoodRetriever(id: UUID(), mealType: "Breakfast", mood: "Happy", comments: "Today was good!", fdcID: 111111, foodDescription: "Cheese Omelet"),
                      showFoodDataSheet: .constant(false))
    }
}
