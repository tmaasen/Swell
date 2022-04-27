//
//  MealTypePicker.swift
//  Swell
//
//  Created by Tanner Maasen on 4/26/22.
//

import SwiftUI

struct MealTypePicker: View {
    @Binding var selectedMeal: String
    
    var body: some View {
        HStack {
            ForEach(MealTypes.allCases, id: \.self) { meal in
                if meal.text != "Water" {
                    Capsule()
                        .stroke(selectedMeal == meal.text ? Color.green : Color.gray, lineWidth: 2)
                        .frame(width: 65, height: 25)
                        .overlay(
                            Text(meal.text)
                                .foregroundColor(.black)
                                .font(.custom(selectedMeal == meal.text ? "Ubuntu-Bold" : "Ubuntu", size: 10))
                        )
                        .onTapGesture {
                            selectedMeal = meal.text
                        }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct MealTypePicker_Previews: PreviewProvider {
    static var previews: some View {
        MealTypePicker(selectedMeal: .constant("Breakfast"))
    }
}
