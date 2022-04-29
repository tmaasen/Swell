//
//  History.swift
//  Swell
//
//  Created by Tanner Maasen on 2/14/22.
//

import SwiftUI

/// History is the main view for both food and mood history, as well as graphical data that attempts to show the relationship between one's nutrition and their mood.
struct History: View {
    var pickerOptions = ["Food", "Mood"]
    @State private var selectedPickerIndex: Int = 0
    @EnvironmentObject var foodAndMoodViewModel: FoodAndMoodViewModel
    
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
