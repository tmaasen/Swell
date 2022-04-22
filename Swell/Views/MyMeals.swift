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
    @Environment(\.colorScheme) var colorScheme
//    var pickerOptions = ["Favorites", "Created"]
    
    var body: some View {
        VStack {
            NavigationLink(destination: AddMeal(), isActive: $addMeal) {}
            
            Spacer()
            Image("NoData")
                .resizable()
                .scaledToFit()
            Text("MyMeals is Empty")
                .foregroundColor(colorScheme == .dark ? .white : .gray)
                .font(.system(size: 18))
                .bold()
            Text("What's a Food You Couldn't Live Without?")
                .foregroundColor(colorScheme == .dark ? .white : .gray)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
            Spacer()
            
//            Picker("", selection: $selectedPickerIndex) {
//                ForEach(0..<pickerOptions.count) {
//                    Text(self.pickerOptions[$0])
//                }
//            }
//            .padding()
//            .pickerStyle(SegmentedPickerStyle())
//
//            if selectedPickerIndex == 0 {
//                // For each item in MyMeals, if picker is 0, show as a FoodResultListItem (or at least styled as such)
//            } else {
//                // If picker is 1, show a form
//                    // food name
//                    // ingredients []
//                    // includes x nutrient [] (maybe?)
//                    // nutrition facts []
//                    // comments / instructions (TextArea)
//            }
            
            // if there are no meals in MyMeals, show no data screen with message
            // else show a list
                        
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
