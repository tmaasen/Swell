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
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
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
            
            if selectedPickerIndex == 0 {
                LogHistory()
            } else {
                AnalyticHistory()
            }
        }
        .navigationTitle("History")
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
