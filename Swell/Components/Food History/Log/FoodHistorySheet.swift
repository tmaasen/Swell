//
//  FoodInfoSheet.swift
//  Swell
//
//  Created by Tanner Maasen on 3/23/22.
//

import SwiftUI

struct FoodHistorySheet: View {
    var foodRetriever: FoodRetriever
    @Environment(\.presentationMode) var presentationMode
    @Binding var showFoodDataSheet: Bool
    @State private var toast: Bool = false
    @State private var liked: Bool = false
    
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
                            // triggers a small haptic vibration
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            liked.toggle()
                            toast = liked
//                            liked == true ? myMealsViewModel.addToMyMeals(pFood: food) :
//                            myMealsViewModel.removeFromMyMeals(pFoodName: food.foodDescription)
                        }
                }
                .padding(.top, 70)
                .zIndex(1.0)
                LottieAnimation(filename: FoodCategories.categoryDict.first(where: {$0.value.contains(foodRetriever.brandedFoodCategory ?? "")})!.key, loopMode: .loop, width: .infinity, height: .infinity)
            }
            .background(Rectangle().foregroundColor(Color.yellow))
            .clipShape(CustomShape(corner: .bottomLeft, radii: 55))
            .edgesIgnoringSafeArea(.top)
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("\(foodRetriever.foodDescription?.capitalizingFirstLetter() ?? "")")
                            .font(.custom("Ubuntu-Bold", size: 30))
                        Spacer()
                        DeleteButton(docId: foodRetriever.docId ?? "", collection: "food", popUpText: "This will permanently remove this item from your history, as well as all mood data accociated with this item.")
                    }
                    .padding(.bottom, 5)
                    HStack {
                        Text("Servings:")
                            .font(.custom("Ubuntu", size: 16))
                        Text("\(foodRetriever.quantity ?? 0)")
                            .font(.custom("Ubuntu", size: 16))
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
            showFoodDataSheet = false
        }
    }
}

struct FoodHistorySheet_Previews: PreviewProvider {
    static var previews: some View {
        FoodHistorySheet(foodRetriever: FoodRetriever(id: UUID(), mealType: "Breakfast", mood: "Happy", comments: "Today was good!", fdcID: 111111, foodDescription: "Cheese Omelet"),
            showFoodDataSheet: .constant(false))
    }
}
