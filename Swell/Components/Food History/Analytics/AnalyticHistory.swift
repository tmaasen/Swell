//
//  AnalyticHistory.swift
//  Swell
//
//  Created by Tanner Maasen on 3/14/22.
//

import SwiftUI
import SwiftUICharts
import Firebase

struct AnalyticHistory: View {
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    var filterOptions = ["All Time"]
    @State private var filterTag: Int = 0
    let db = Firestore.firestore()
    
    var body: some View {
        ScrollView {
            // GRAPH 1
            Analytics_Graph1()
            // GRAPH 2
            Analytics_Graph2()
            // GRAPH 3
            Analytics_Graph3()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Picker("Filter by: ", selection: $filterTag) {
                    ForEach(0..<filterOptions.count) {
                        Text(self.filterOptions[$0])
                    }
                }
            }
        }
    }
}

struct AnalyticHistory_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticHistory()
    }
}
