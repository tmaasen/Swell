//
//  History.swift
//  Swell
//
//  Created by Tanner Maasen on 2/14/22.
//
//  History is the main view for both food and mood history, as well as graphical data that attempts to show the relationship between one's nutrition and their mood.

import SwiftUI
import Firebase

struct History: View { 
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    @State private var selectedDate = Date()
    @State private var isLoading: Bool = false
    @State private var selectedPickerIndex: Int = 0
    var pickerOptions = ["Log", "Analytics"]
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedPickerIndex) {
                ForEach(0..<pickerOptions.count) {
                    Text(self.pickerOptions[$0])
                }
            }
            .padding()
            .pickerStyle(SegmentedPickerStyle())
            
            if isLoading {
                LottieAnimation(filename: "loading", loopMode: .loop, width: 50, height: 50)
            }
            
            if selectedPickerIndex == 0 {
                LogHistory(selectedDate: $selectedDate, isLoading: $isLoading)
            } else {
                AnalyticHistory()
            }
        }
        .navigationTitle("History")
        .onAppear() {
            isLoading = true
            foodViewModel.getFoodIds(date: selectedDate)
            foodViewModel.getWater(date: selectedDate)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isLoading = false
            }
        }
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
