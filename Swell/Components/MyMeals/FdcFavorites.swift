//
//  FdcFavorites.swift
//  Swell
//
//  Created by Tanner Maasen on 4/22/22.
//

import SwiftUI

struct FdcFavorites: View {
    @EnvironmentObject var myMealsViewModel: MyMealsViewModel
    
    var body: some View {
        ForEach(myMealsViewModel.myMeals, id: \.self) { myMeal in
            if !(myMeal.isCustomMeal!) {
                Text(myMeal.name ?? "")
            }
        }
    }
}

struct FdcFavorites_Previews: PreviewProvider {
    static var previews: some View {
        FdcFavorites()
    }
}
