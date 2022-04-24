//
//  CustomMeals.swift
//  Swell
//
//  Created by Tanner Maasen on 4/22/22.
//

import SwiftUI

struct CustomMeals: View {
    @EnvironmentObject var myMealsViewModel: MyMealsViewModel
    
    var body: some View {
        ForEach(myMealsViewModel.myMeals, id: \.self) { myMeal in
            if myMeal.isCustomMeal! {
                Text(myMeal.name ?? "")
            }
        }
    }
}

struct CustomMeals_Previews: PreviewProvider {
    static var previews: some View {
        CustomMeals()
    }
}
