//
//  MyMeals.swift
//  Swell
//
//  Created by Tanner Maasen on 2/14/22.
//

import SwiftUI

struct MyMeals: View {
    @State private var addMeal: Bool = false
    @State private var selectedPickerIndex: Int = 0
    var pickerOptions = ["Favorites", "Created"]
    
    var body: some View {
        VStack {
            NavigationLink(destination: AddMeal(), isActive: $addMeal) {}
            
            Picker("", selection: $selectedPickerIndex) {
                ForEach(0..<pickerOptions.count) {
                    Text(self.pickerOptions[$0])
                }
            }
            .padding()
            .pickerStyle(SegmentedPickerStyle())
            
            if selectedPickerIndex == 0 {
                // For each item in MyMeals, if picker is 0, show as a FoodResultListItem (or at least styled as such)
            } else {
                // If picker is 1, show a form
                    // food name
                    // ingredients []
                    // includes x nutrient [] (maybe?)
                    // nutrition facts []
                    // comments / instructions (TextArea)
            }
                        
        }
        .navigationTitle("MyMeals")
        .navigationBarItems(trailing:
                                Button(action: {
                                    addMeal = true
                                }, label: {
                                    Image(systemName: "plus")
                                })
        )
    }
}

struct MyMeals_Previews: PreviewProvider {
    static var previews: some View {
        MyMeals()
    }
}
