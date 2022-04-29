//
//  AnalyticHistory.swift
//  Swell
//
//  Created by Tanner Maasen on 3/14/22.
//

import SwiftUI

struct AnalyticHistory: View {
    @StateObject var analyticsViewModel = HistoryAnalyticsViewModel()
//    var filterOptions = ["All Time"]
//    @State private var filterTag: Int = 0
    
    var body: some View {
        ScrollView {
            // GRAPH 1
            Analytics_Graph1(analyticsViewModel: analyticsViewModel)
            // GRAPH 2
            Analytics_Graph2(analyticsViewModel: analyticsViewModel)
            // GRAPH 3
            Analytics_Graph3(analyticsViewModel: analyticsViewModel)
        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Picker("Filter by: ", selection: $filterTag) {
//                    ForEach(0..<filterOptions.count) {
//                        Text(self.filterOptions[$0])
//                    }
//                }
//            }
//        }
    }
}

struct AnalyticHistory_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticHistory()
    }
}
