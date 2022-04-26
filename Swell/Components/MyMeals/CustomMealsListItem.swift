//
//  CustomMeals.swift
//  Swell
//
//  Created by Tanner Maasen on 4/22/22.
//

import SwiftUI

struct CustomMealsListItem: View {
    @EnvironmentObject var myMealsViewModel: MyMealsViewModel
    @State private var showCustomMealsSheet: Bool = false
    var myMeal: MyMeal
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(myMeal.name ?? "")
                    .foregroundColor(.black)
                    .font(.custom("Ubuntu-Bold", size: 18))
                Text(myMeal.foodCategory ?? "")
                    .foregroundColor(Color("FoodListItem_DarkGray"))
                    .font(.custom("Ubuntu", size: 12))
            }
            Spacer()
            Image(systemName: "plus.circle")
                .font(.system(size: 30))
                .foregroundColor(Color("FoodListItem_DarkGray"))
        }
        .padding()
        .background(Color("FoodListItem_LightGray"))
        .cornerRadius(8)
        .padding(.horizontal, 15)
        .onTapGesture {
            showCustomMealsSheet = true
        }
        .sheet(isPresented: $showCustomMealsSheet) {
            CustomMealsSheet(myMeal: myMeal)
        }
    }
}
