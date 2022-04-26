//
//  CustomMealsSheet.swift
//  Swell
//
//  Created by Tanner Maasen on 4/25/22.
//

import SwiftUI

struct CustomMealsSheet: View {
    var myMeal: MyMeal
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
                LottieAnimation(filename: FoodCategories.categoryDict.first(where: {$0.key.contains(myMeal.foodCategory!)})!.key, loopMode: .loop, width: .infinity, height: .infinity)
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
                        DeleteButton(docId: myMeal.name ?? "", collection: "myMeals", popUpText: "This will permanently remove your custom meal from MyMeals. This action cannot be undone.")
                    }
                    .padding(.bottom, 5)
                    
                    Text("Category: \(myMeal.foodCategory ?? "")")
                        .font(.custom("Ubuntu", size: 16))
                    
                    CustomMealsSheet_Section(title: "Ingredients", array1: myMeal.ingredientNames ?? [], array2: myMeal.ingredientValues ?? [])
                    
                    CustomMealsSheet_Section(title: "Nutrition Facts", array1: myMeal.nutrientNames ?? [], array2: myMeal.nutrientValues ?? [])
                    
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
    }
}

struct CustomMealsSheet_Previews: PreviewProvider {
    static var previews: some View {
        CustomMealsSheet(myMeal: MyMeal())
    }
}

struct CustomMealsSheet_Section: View {
    var title: String
    var array1: [String]
    var array2: [String]
    
    var body: some View {
        Section(header:
                    Text(title)
                    .bold()
                    .font(.custom("Ubuntu", size: 18))) {
            VStack(alignment: .leading) {
                ForEach(0..<array1.count) { i in
                    HStack {
                        Text(array1[i].capitalizingFirstLetter())
                            .font(.custom("Ubuntu", size: 16))
                        Text(array2[i])
                            .font(.custom("Ubuntu", size: 16))
                    }
                    Divider()
                }
            }
        }
    }
}
