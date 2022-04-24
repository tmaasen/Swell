//
//  MyMeals.swift
//  Swell
//
//  Created by Tanner Maasen on 2/14/22.
//

import SwiftUI

struct MyMeals: View {
    @State private var isLoading: Bool = false
    @State private var addMeal: Bool = false
    @State private var selectedPickerIndex: Int = 0
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var myMealsViewModel: MyMealsViewModel
    var pickerOptions = ["Favorites", "Custom Meals"]
    
    var body: some View {
        VStack {
            NavigationLink(destination: AddMeal(), isActive: $addMeal) { }
            
            Picker("", selection: $selectedPickerIndex) {
                ForEach(0..<pickerOptions.count) {
                    Text(self.pickerOptions[$0])
                }
            }
            .padding()
            .pickerStyle(SegmentedPickerStyle())
            
            Spacer()
            
            if selectedPickerIndex == 0 {
                FdcFavorites()
            } else {
                CustomMeals()
            }
            
            Spacer()
            
            if isLoading {
                LottieAnimation(filename: "loading", loopMode: .loop, width: 50, height: 50)
            } else if myMealsViewModel.myMeals.isEmpty && !isLoading {
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
