//
//  History.swift
//  Swell
//
//  Created by Tanner Maasen on 2/14/22.
//

import SwiftUI
import Firebase

public enum MealTypes: Int, CaseIterable {
    case breakfast
    case lunch
    case dinner
    case snack
    case water
    
    var text: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch: return "Lunch"
        case .dinner: return "Dinner"
        case .snack: return "Snack"
        case .water: return "Water"
        }
    }
}

struct History: View {
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    @State private var selectedDate = Date()
    var pickerOptions = ["Log", "Analytics"]
    @State private var selectedPickerIndex: Int = 0
    var filterOptions = ["Week", "All Time"]
    @State private var selectedFilterIndex: Int = 0
    
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
                LogHistory(selectedDate: $selectedDate)
            } else {
                AnalyticHistory(filterTag: $selectedFilterIndex)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Picker("Filter by: ", selection: $selectedFilterIndex) {
                                ForEach(0..<filterOptions.count) {
                                    Text(self.filterOptions[$0])
                                }
                            }
                        }
                    }
            }
        }
        .navigationTitle("History")
        .onAppear() {
            foodViewModel.getFoodIds(date: selectedDate)
        }
        if !foodViewModel.completed {
            ZStack(alignment: .leading) {
                LottieAnimation(filename: "loading", loopMode: .loop, width: 50, height: 50)
            }
        }
        Spacer()
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
